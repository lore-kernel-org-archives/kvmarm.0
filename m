From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 17/27] arm64/sve: Preserve SVE registers around EFI
 runtime service calls
Date: Wed, 16 Aug 2017 10:13:07 +0100
Message-ID: <20170816091303.GX6321@e103592.cambridge.arm.com>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
 <1502280338-23002-18-git-send-email-Dave.Martin@arm.com>
 <CAKv+Gu-z2MmQM6rzSBf=3oxKh2iUV+5zVjOkEJVhCwq3JwrdoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-z2MmQM6rzSBf=3oxKh2iUV+5zVjOkEJVhCwq3JwrdoQ@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, libc-alpha@sourceware.org, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 15, 2017 at 06:44:45PM +0100, Ard Biesheuvel wrote:
> On 9 August 2017 at 13:05, Dave Martin <Dave.Martin@arm.com> wrote:
> > The EFI runtime services ABI allows EFI to make free use of the
> > FPSIMD registers during EFI runtime service calls, subject to the
> > callee-save requirements of the AArch64 procedure call standard.
> >
> > However, the SVE architecture allows upper bits of the SVE vector
> > registers to be zeroed as a side-effect of FPSIMD V-register
> > writes.  This means that the SVE vector registers must be saved in
> > their entirety in order to avoid data loss: non-SVE-aware EFI
> > implementations cannot restore them correctly.
> >
> > The non-IRQ case is already handled gracefully by
> > kernel_neon_begin().  For the IRQ case, this patch allocates a
> > suitable per-CPU stash buffer for the full SVE register state and
> > uses it to preserve the affected registers around EFI calls.  It is
> > currently unclear how the EFI runtime services ABI will be
> > clarified with respect to SVE, so it safest to assume that the
> > predicate registers and FFR must be saved and restored too.
> >
> > No attempt is made to restore the restore the vector length after
> > a call, for now.  It is deemed rather insane for EFI to change it,
> > and contemporary EFI implementations certainly won't.
> >
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > ---
> >  arch/arm64/kernel/fpsimd.c | 53 ++++++++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 49 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c

[...]

> > +static void __init sve_kernel_mode_neon_setup(void)
> > +{
> > +       if (!IS_ENABLED(CONFIG_KERNEL_MODE_NEON))
> > +               return;
> > +
> > +       /*
> > +        * alloc_percpu() warns and prints a backtrace if this goes wrong.
> > +        * This is evidence of a crippled system and we are returning void,
> > +        * so no attempt is made to handle this situation here.
> > +        */
> > +       BUG_ON(!sve_vl_valid(sve_max_vl));
> > +       efi_sve_state = __alloc_percpu(
> > +               SVE_SIG_REGS_SIZE(sve_vq_from_vl(sve_max_vl)), 16);
> > +       if (!efi_sve_state)
> > +               panic("Cannot allocate percpu memory for EFI SVE save/restore");
> 
> 
> Do we really need to panic here?

Debatable.  I'm a bit unfomfortable just leaving the kernel to bleed to
death of its own accord.  OTOH, if this allocation fails, the kernel is
unlikely to survive long enough to do any real damage.

Unfortunately we're in a call chain that leads to a void function
called from core code, so returning an error is impossible.  I'm very
unconvinved that applying percpu offset on NULL will result in
something that is "NULL enough" to guarantee a fault.  Perhaps this is
supposed to be a guarantee of the percpu design, but I've seen no
statement about this anywhere.

A similar quandary also effects
drivers/firmware/efi/arm-init.c:efi_init().  In the end I followed its
lead, but I don't know which answer is correct.


[...]

> >  void fpsimd_release_thread(struct task_struct *dead_task)
> > @@ -797,6 +818,7 @@ EXPORT_SYMBOL(kernel_neon_end);
> >
> >  DEFINE_PER_CPU(struct fpsimd_state, efi_fpsimd_state);
> >  DEFINE_PER_CPU(bool, efi_fpsimd_state_used);
> > +DEFINE_PER_CPU(bool, efi_sve_state_used);
> >
> 
> Could this be static?

Hmm, looks like it.  I just followed the pattern I'd already set, but
it looks like efi_fpsimd_state and efi_fpsimd_state_used ought to be
static too.

I'll fix those, though it'll be a separate patch since Catalin already
took the EFI fpsimd stuff.

> >  /*
> >   * EFI runtime services support functions
> > @@ -825,7 +847,20 @@ void __efi_fpsimd_begin(void)
> >         if (may_use_simd())
> >                 kernel_neon_begin();
> >         else {
> > -               fpsimd_save_state(this_cpu_ptr(&efi_fpsimd_state));
> > +               /*
> > +                * If !efi_sve_state, SVE can't be in use yet and doesn't need
> > +                * preserving:
> > +                */
> > +               if (system_supports_sve() && likely(efi_sve_state)) {
> > +                       char *sve_state = this_cpu_ptr(efi_sve_state);
> > +
> > +                       __this_cpu_write(efi_sve_state_used, true);
> > +
> > +                       sve_save_state(sve_state + sve_ffr_offset(sve_max_vl),
> > +                                      &this_cpu_ptr(&efi_fpsimd_state)->fpsr);
> > +               } else
> > +                       fpsimd_save_state(this_cpu_ptr(&efi_fpsimd_state));
> > +
> 
> Consistent braces please

Argh, I always seem to have a blind spot about this one.

(I do disagree with this rule, but that's another story...)

Will fix, and I'll double check whether any others instances of this
slipped through.

> >                 __this_cpu_write(efi_fpsimd_state_used, true);
> >         }
> >  }
> > @@ -838,10 +873,20 @@ void __efi_fpsimd_end(void)
> >         if (!system_supports_fpsimd())
> >                 return;
> >
> > -       if (__this_cpu_xchg(efi_fpsimd_state_used, false))
> > -               fpsimd_load_state(this_cpu_ptr(&efi_fpsimd_state));
> > -       else
> > +       if (!__this_cpu_xchg(efi_fpsimd_state_used, false))
> >                 kernel_neon_end();
> > +       else
> > +               if (system_supports_sve() &&
> > +                   likely(__this_cpu_read(efi_sve_state_used))) {
> > +                       char const *sve_state = this_cpu_ptr(efi_sve_state);
> > +
> > +                       sve_load_state(sve_state + sve_ffr_offset(sve_max_vl),
> > +                                      &this_cpu_ptr(&efi_fpsimd_state)->fpsr,
> > +                                      sve_vq_from_vl(sve_get_vl()) - 1);
> > +
> > +                       __this_cpu_write(efi_sve_state_used, false);
> > +               } else
> > +                       fpsimd_load_state(this_cpu_ptr(&efi_fpsimd_state));
> 
> Please use braces for non-trivial if/else conditions

Do you mean add braces around the else clause?  It looks like I should
add those for consistency.

Otherwise, I'm not sure what you're getting at here.  I don't think the
nature of the _condition_ has any bearing on this (?)

> 
> >  }
> >
> >  #endif /* CONFIG_KERNEL_MODE_NEON */
> > --
> > 2.1.4
> >
> 
> With those fixed
> 
> Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Thanks, I'll hold off on applying that until we've concluded on the
above.

Cheers
---Dave
