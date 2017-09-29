From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v2 19/28] arm64/sve: ptrace and ELF coredump support
Date: Fri, 29 Sep 2017 13:46:06 +0100
Message-ID: <20170929124605.GF3611@e103592.cambridge.arm.com>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
 <1504198860-12951-20-git-send-email-Dave.Martin@arm.com>
 <87bmmda15n.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87bmmda15n.fsf@linaro.org>
Sender: linux-arch-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, gdb@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Yao Qi <Yao.Qi@arm.com>, Alan Hayward <alan.hayward@arm.com>, Will Deacon <will.deacon@arm.com>, Oleg Nesterov <oleg@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Sep 14, 2017 at 01:57:08PM +0100, Alex Bennée wrote:
> 
> Dave Martin <Dave.Martin@arm.com> writes:
> 
> > This patch defines and implements a new regset NT_ARM_SVE, which
> > describes a thread's SVE register state.  This allows a debugger to
> > manipulate the SVE state, as well as being included in ELF
> > coredumps for post-mortem debugging.
> >
> > Because the regset size and layout are dependent on the thread's
> > current vector length, it is not possible to define a C struct to
> > describe the regset contents as is done for existing regsets.
> > Instead, and for the same reasons, NT_ARM_SVE is based on the
> > freeform variable-layout approach used for the SVE signal frame.
> >
> > Additionally, to reduce debug overhead when debugging threads that
> > might or might not have live SVE register state, NT_ARM_SVE may be
> > presented in one of two different formats: the old struct
> > user_fpsimd_state format is embedded for describing the state of a
> > thread with no live SVE state, whereas a new variable-layout
> > structure is embedded for describing live SVE state.  This avoids a
> > debugger needing to poll NT_PRFPREG in addition to NT_ARM_SVE, and
> > allows existing userspace code to handle the non-SVE case without
> > too much modification.
> >
> > For this to work, NT_ARM_SVE is defined with a fixed-format header
> > of type struct user_sve_header, which the recipient can use to
> > figure out the content, size and layout of the reset of the regset.
> > Accessor macros are defined to allow the vector-length-dependent
> > parts of the regset to be manipulated.
> >
> > Signed-off-by: Alan Hayward <alan.hayward@arm.com>
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > Cc: Alex Bennée <alex.bennee@linaro.org>
> >
> > ---
> >
> > Changes since v1
> > ----------------
> >
> > Other changes related to Alex Bennée's comments:
> >
> > * Migrate to SVE_VQ_BYTES instead of magic numbers.
> >
> > Requested by Alex Bennée:
> >
> > * Thin out BUG_ON()s:
> > Redundant BUG_ON()s and ones that just check invariants are removed.
> > Important sanity-checks are migrated to WARN_ON()s, with some
> > minimal best-effort patch-up code.
> >
> > Other:
> >
> > * [ABI fix] Bail out with -EIO if attempting to set the
> > SVE regs for an unsupported VL, instead of misparsing the regset data.
> >
> > * Replace some in-kernel open-coded arithmetic with ALIGN()/
> > DIV_ROUND_UP().
> > ---

[...]

> > diff --git a/arch/arm64/include/uapi/asm/ptrace.h b/arch/arm64/include/uapi/asm/ptrace.h

[...]

> > +/* Definitions for user_sve_header.flags: */
> > +#define SVE_PT_REGS_MASK		(1 << 0)
> > +
> > +/* Flags: must be kept in sync with prctl interface in
> > <linux/ptrace.h> */
> 
> Which flags? We base some on PR_foo flags but we seem to shift them
> anyway so where is the requirement for them to match from?

I've rearranged this as:

-8<-

/* Definitions for user_sve_header.flags: */
#define SVE_PT_REGS_MASK		(1 << 0)

#define SVE_PT_REGS_FPSIMD		0
#define SVE_PT_REGS_SVE			SVE_PT_REGS_MASK

/*
 * Common SVE_PT_* flags:
 * These must be kept in sync with prctl interface in <linux/ptrace.h>
 */
#define SVE_PT_VL_INHERIT		(PR_SVE_VL_INHERIT >> 16)
#define SVE_PT_VL_ONEXEC		(PR_SVE_SET_VL_ONEXEC >> 16)

->8-

This avoids the suggestion that SVE_PT_REGS_{MASK,FPSIMD,SVE} are
supposed to have prctl counterparts.

I don't really want to write more, in case it is misinterpreted as
specification of behaviour.

This comment is really only meant as a reminder to maintainers that
they should go look at prctl.h too, before blindly making changes
here.


Any good?  If you have a different suggestion, I'm all ears...

[...]

Cheers
---Dave
