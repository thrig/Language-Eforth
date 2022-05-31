#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#include "embed.h"

typedef embed_t* Language__Eforth;

/* TODO instead target some perl something? or just Capture::Tiny */
int put_char(int ch, void *file)
{
    int ret = fputc(ch, file);
    fflush(file);
    return ret;
}

MODULE = Language::Eforth		PACKAGE = Language::Eforth		
PROTOTYPES: ENABLE

void
DESTROY(Language::Eforth self)
    CODE:
        free(self->m);
        Safefree(self);

UV
depth(Language::Eforth self)
    CODE:
        RETVAL = embed_depth(self);
    OUTPUT:
    	RETVAL

# NOTE the string MUST end with a newline
void
eval(Language::Eforth self, SV *expr)
    CODE:
        if (!SvOK(expr) || !SvCUR(expr))
            croak("invalid empty expression");
        embed_eval(self, (char *)SvPV_nolen(expr));

Language::Eforth
new( const char *class )
    PREINIT:
        embed_t *self;
        embed_opt_t opts;
    CODE:
        Newxz(self, 1, embed_t);
        if (!self) croak("could not allocate forth");
        self->m = calloc(EMBED_CORE_SIZE * sizeof(cell_t), 1);
        if (!(self->m)) croak("could not allocate memory");
        embed_default(self);
        opts         = embed_opt_default();
        opts.out     = stdout;
        opts.put     = put_char;
        opts.options = 0;
        self->o      = opts;
        /* KLUGE prime the engine so push works from the get-go */
        embed_eval(self, "\n");
        RETVAL = self;
    OUTPUT:
    	RETVAL

void
pop(Language::Eforth self)
    PREINIT:
        cell_t value;
        int ret;
        U8 gimme;
    PPCODE:
        ret = embed_pop(self, &value);
        gimme = GIMME_V;
        if (gimme == G_VOID) {
            XSRETURN(0);
        } else if (gimme == G_SCALAR) {
            ST(0) = newSViv(value);
            sv_2mortal(ST(0));
            XSRETURN(1);
        } else {
            ST(0) = newSViv(value);
            sv_2mortal(ST(0));
            ST(1) = newSViv(ret);
            sv_2mortal(ST(1));
            XSRETURN(2);
        }

UV
push(Language::Eforth self, SV *value)
    CODE:
        if (!SvOK(value) || !SvIOK(value))
            croak("value must be an integer");
        RETVAL = embed_push(self, SvIV(value));
    OUTPUT:
    	RETVAL

void
reset(Language::Eforth self)
    CODE:
        embed_reset(self);
