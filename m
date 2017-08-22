From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 09/27] arm64/sve: Signal frame and context structure
 definition
Date: Tue, 22 Aug 2017 12:17:06 +0100
Message-ID: <20170822111705.GT6321@e103592.cambridge.arm.com>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
 <1502280338-23002-10-git-send-email-Dave.Martin@arm.com>
 <87y3qb52ez.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87y3qb52ez.fsf@linaro.org>
Sender: linux-arch-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, gdb@sourceware.org, Yao Qi <Yao.Qi@arm.com>, Alan Hayward <alan.hayward@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 22, 2017 at 11:22:44AM +0100, Alex Bennée wrote:
> 
> Dave Martin <Dave.Martin@arm.com> writes:
> 
> > This patch defines the representation that will be used for the SVE
> > register state in the signal frame, and implements support for
> > saving and restoring the SVE registers around signals.
> >
> > The same layout will also be used for the in-kernel task state.
> >
> > Due to the variability of the SVE vector length, it is not possible
> > to define a fixed C struct to describe all the registers.  Instead,
> > Macros are defined in sigcontext.h to facilitate access to the
> > parts of the structure.
> >
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > ---
> >  arch/arm64/include/uapi/asm/sigcontext.h | 113 ++++++++++++++++++++++++++++++-
> >  1 file changed, 112 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/include/uapi/asm/sigcontext.h b/arch/arm64/include/uapi/asm/sigcontext.h
> > index f0a76b9..0533bdf 100644
> > --- a/arch/arm64/include/uapi/asm/sigcontext.h
> > +++ b/arch/arm64/include/uapi/asm/sigcontext.h
> > @@ -16,6 +16,8 @@
> >  #ifndef _UAPI__ASM_SIGCONTEXT_H
> >  #define _UAPI__ASM_SIGCONTEXT_H
> >
> > +#ifndef __ASSEMBLY__
> > +
> >  #include <linux/types.h>
> >
> >  /*
> > @@ -41,10 +43,11 @@ struct sigcontext {
> >   *
> >   *	0x210		fpsimd_context
> >   *	 0x10		esr_context
> > + *	0x8a0		sve_context (vl <= 64) (optional)
> >   *	 0x20		extra_context (optional)
> >   *	 0x10		terminator (null _aarch64_ctx)
> >   *
> > - *	0xdb0		(reserved for future allocation)
> > + *	0x510		(reserved for future allocation)
> >   *
> >   * New records that can exceed this space need to be opt-in for userspace, so
> >   * that an expanded signal frame is not generated unexpectedly.  The mechanism
> > @@ -116,4 +119,112 @@ struct extra_context {
> >  	__u32 __reserved[3];
> >  };
> >
> > +#define SVE_MAGIC	0x53564501
> > +
> > +struct sve_context {
> > +	struct _aarch64_ctx head;
> > +	__u16 vl;
> > +	__u16 __reserved[3];
> > +};
> > +
> > +#endif /* !__ASSEMBLY__ */
> > +
> > +/*
> > + * The SVE architecture leaves space for future expansion of the
> > + * vector length beyond its initial architectural limit of 2048 bits
> > + * (16 quadwords).
> > + */
> > +#define SVE_VQ_MIN		1
> > +#define SVE_VQ_MAX		0x200
> > +
> > +#define SVE_VL_MIN		(SVE_VQ_MIN * 0x10)
> > +#define SVE_VL_MAX		(SVE_VQ_MAX * 0x10)
> > +
> > +#define SVE_NUM_ZREGS		32
> > +#define SVE_NUM_PREGS		16
> > +
> > +#define sve_vl_valid(vl) \
> > +	((vl) % 0x10 == 0 && (vl) >= SVE_VL_MIN && (vl) <= SVE_VL_MAX)
> > +#define sve_vq_from_vl(vl)	((vl) / 0x10)
> > +#define sve_vl_from_vq(vq)	((vq) * 0x10)
> 
> I got a little confused first time through over what VQ and VL where.
> Maybe it would make sense to expand a little more from first principles?
> 
>   /*
>    * The SVE architecture defines vector registers as a multiple of 128
>    * bit quadwords. The current architectural limit is 2048 bits (16
>    * quadwords) but there is room for future expansion beyond that.
>     */

This comes up in several places and so I didn't want to comment it
repeatedly everywhere.

Instead, I wrote up something in section 2 (Vector length terminology)
of Documentation/arm64/sve.txt -- see patch 25.  Can you take a look and
see whether that's adequate?

[...]

Cheers
---Dave
