From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v5 13/30] arm64/sve: Core task context handling
Date: Thu, 09 Nov 2017 18:06:18 +0000
Message-ID: <877euzqqcl.fsf@linaro.org>
References: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com> <1509465082-30427-14-git-send-email-Dave.Martin@arm.com> <878tffqsnb.fsf@linaro.org> <20171109175638.GF22781@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arch-owner@vger.kernel.org>
In-reply-to: <20171109175638.GF22781@e103592.cambridge.arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu


Dave Martin <Dave.Martin@arm.com> writes:

> On Thu, Nov 09, 2017 at 05:16:40PM +0000, Alex Benn=C3=A9e wrote:
>>
>> Dave Martin <Dave.Martin@arm.com> writes:
>>
>> > This patch adds the core support for switching and managing the SVE
>> > architectural state of user tasks.
>> >
>> > Calls to the existing FPSIMD low-level save/restore functions are
>> > factored out as new functions task_fpsimd_{save,load}(), since SVE
>> > now dynamically may or may not need to be handled at these points
>> > depending on the kernel configuration, hardware features discovered
>> > at boot, and the runtime state of the task.  To make these
>> > decisions as fast as possible, const cpucaps are used where
>> > feasible, via the system_supports_sve() helper.
>> >
>> > The SVE registers are only tracked for threads that have explicitly
>> > used SVE, indicated by the new thread flag TIF_SVE.  Otherwise, the
>> > FPSIMD view of the architectural state is stored in
>> > thread.fpsimd_state as usual.
>> >
>> > When in use, the SVE registers are not stored directly in
>> > thread_struct due to their potentially large and variable size.
>> > Because the task_struct slab allocator must be configured very
>> > early during kernel boot, it is also tricky to configure it
>> > correctly to match the maximum vector length provided by the
>> > hardware, since this depends on examining secondary CPUs as well as
>> > the primary.  Instead, a pointer sve_state in thread_struct points
>> > to a dynamically allocated buffer containing the SVE register data,
>> > and code is added to allocate and free this buffer at appropriate
>> > times.
>> >
>> > TIF_SVE is set when taking an SVE access trap from userspace, if
>> > suitable hardware support has been detected.  This enables SVE for
>> > the thread: a subsequent return to userspace will disable the trap
>> > accordingly.  If such a trap is taken without sufficient system-
>> > wide hardware support, SIGILL is sent to the thread instead as if
>> > an undefined instruction had been executed: this may happen if
>> > userspace tries to use SVE in a system where not all CPUs support
>> > it for example.
>> >
>> > The kernel will clear TIF_SVE and disable SVE for the thread
>> > whenever an explicit syscall is made by userspace.  For backwards
>> > compatibility reasons and conformance with the spirit of the base
>> > AArch64 procedure call standard, the subset of the SVE register
>> > state that aliases the FPSIMD registers is still preserved across a
>> > syscall even if this happens.  The remainder of the SVE register
>> > state logically becomes zero at syscall entry, though the actual
>> > zeroing work is currently deferred until the thread next tries to
>> > use SVE, causing another trap to the kernel.  This implementation
>> > is suboptimal: in the future, the fastpath case may be optimised
>> > to zero the registers in-place and leave SVE enabled for the task,
>> > where beneficial.
>> >
>> > TIF_SVE is also cleared in the following slowpath cases, which are
>> > taken as reasonable hints that the task may no longer use SVE:
>> >  * exec
>> >  * fork and clone
>> >
>> > Code is added to sync data between thread.fpsimd_state and
>> > thread.sve_state whenever enabling/disabling SVE, in a manner
>> > consistent with the SVE architectural programmer's model.
>> >
>> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
>> > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>> > Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> > Cc: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> >
>> > ---
>> >
>> > Kept Catalin's Reviewed-by, since this is a trivial change.
>> >
>> > Changes since v4
>> > ----------------
>> >
>> > Miscellaneous:
>> >
>> >  * Mark do_sve_acc() as asmlinkage.
>> >
>> >    (Semantic correctness only; no functional impact.)
>
> [...]
>
>> > diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
>> > index f5e851e..56e848f 100644
>> > --- a/arch/arm64/kernel/entry.S
>> > +++ b/arch/arm64/kernel/entry.S
>> > @@ -607,6 +607,8 @@ el0_sync:
>> >  	b.eq	el0_ia
>> >  	cmp	x24, #ESR_ELx_EC_FP_ASIMD	// FP/ASIMD access
>> >  	b.eq	el0_fpsimd_acc
>> > +	cmp	x24, #ESR_ELx_EC_SVE		// SVE access
>> > +	b.eq	el0_sve_acc
>>
>> I'm guessing there is a point that this long chain of cmp instructions
>> is better handled with a jump table? One for the maintainer though I
>> guess?
>
> Probably it would be worth refactoring this at some point.
>
> There's a tradeoff between the length of this list the extra D-cache
> and/or branch miss(es) that might result from using a table.
>
> The optimimum approach would be microarchitecture dependent, but I
> suspect a good compromise would be to profile this, pick the few most
> common / most latency sensitive exception types and keep those as
> compare-and-branch, deferring the remainder to a table lookup.
>
> I had a vague plan to take a look at it, but for this series is
> was very much in "nice-to-have" territory.
>
>> >  	cmp	x24, #ESR_ELx_EC_FP_EXC64	// FP/ASIMD exception
>> >  	b.eq	el0_fpsimd_exc
>> >  	cmp	x24, #ESR_ELx_EC_SYS64		// configurable trap
>> > @@ -658,6 +660,7 @@ el0_svc_compat:
>> >  	/*
>> >  	 * AArch32 syscall handling
>> >  	 */
>> > +	ldr	x16, [tsk, #TSK_TI_FLAGS]	// load thread flags
>> >  	adrp	stbl, compat_sys_call_table	// load compat syscall table pointer
>> >  	mov	wscno, w7			// syscall number in w7 (r7)
>> >  	mov     wsc_nr, #__NR_compat_syscalls
>
> [...]
>
>> > @@ -835,16 +848,36 @@ ENDPROC(ret_to_user)
>> >   */
>> >  	.align	6
>> >  el0_svc:
>> > +	ldr	x16, [tsk, #TSK_TI_FLAGS]	// load thread flags
>> >  	adrp	stbl, sys_call_table		// load syscall table pointer
>> >  	mov	wscno, w8			// syscall number in w8
>> >  	mov	wsc_nr, #__NR_syscalls
>> > +
>> > +#ifndef CONFIG_ARM64_SVE
>> > +	b	el0_svc_naked
>>
>> Hmm we've hoisted the ldr x16, [tsk, #TSK_TI_FLAGS] out of el0_svc_naked
>> but we'll still be testing the bit when CONFIG_ARM64_SVE isn't enabled?
>
> Where?  In this patch it's #ifdef'd out.  In "Detect SVE and activate
> runtime support" this is converted to an asm alternative, so this should
> reduce to a statically predictable branch when CONFIG_ARM64_SVE=3Dy but
> SVE support is not detected.
>
>> I'm not clear why you couldn't keep that where it was?
>
> Catalin wasn't keen on the duplication of work reading and writing the
> thread flags, so I moved it to the common path.

Ahh sorry, I see it now.

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

>
>>
>> > +#else
>> > +	tbz	x16, #TIF_SVE, el0_svc_naked	// Skip unless TIF_SVE set:
>> > +	bic	x16, x16, #_TIF_SVE		// discard SVE state
>> > +	str	x16, [tsk, #TSK_TI_FLAGS]
>> > +
>> > +	/*
>> > +	 * task_fpsimd_load() won't be called to update CPACR_EL1 in
>> > +	 * ret_to_user unless TIF_FOREIGN_FPSTATE is still set, which only
>> > +	 * happens if a context switch or kernel_neon_begin() or context
>> > +	 * modification (sigreturn, ptrace) intervenes.
>> > +	 * So, ensure that CPACR_EL1 is already correct for the fast-path ca=
se:
>> > +	 */
>> > +	mrs	x9, cpacr_el1
>> > +	bic	x9, x9, #CPACR_EL1_ZEN_EL0EN	// disable SVE for el0
>> > +	msr	cpacr_el1, x9			// synchronised by eret to el0
>> > +#endif /* CONFIG_ARM64_SVE */
>> > +
>> >  el0_svc_naked:					// compat entry point
>> >  	stp	x0, xscno, [sp, #S_ORIG_X0]	// save the original x0 and syscall =
number
>> >  	enable_dbg_and_irq
>> >  	ct_user_exit 1
>> >
>> > -	ldr	x16, [tsk, #TSK_TI_FLAGS]	// check for syscall hooks
>> > -	tst	x16, #_TIF_SYSCALL_WORK
>> > +	tst	x16, #_TIF_SYSCALL_WORK		// check for syscall hooks
>> >  	b.ne	__sys_trace
>> >  	cmp     wscno, wsc_nr			// check upper syscall limit
>> >  	b.hs	ni_sys
>
> [...]
>
>> > diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
>> > index 18c0290..9d3c7f0 100644
>> > --- a/arch/arm64/kernel/traps.c
>> > +++ b/arch/arm64/kernel/traps.c
>> > @@ -310,8 +310,8 @@ static int call_undef_hook(struct pt_regs *regs)
>> >  	return fn ? fn(regs, instr) : 1;
>> >  }
>> >
>> > -static void force_signal_inject(int signal, int code, struct pt_regs =
*regs,
>> > -				unsigned long address)
>> > +void force_signal_inject(int signal, int code, struct pt_regs *regs,
>> > +			 unsigned long address)
>> >  {
>> >  	siginfo_t info;
>> >  	void __user *pc =3D (void __user *)instruction_pointer(regs);
>> > @@ -325,7 +325,7 @@ static void force_signal_inject(int signal, int co=
de, struct pt_regs *regs,
>> >  		desc =3D "illegal memory access";
>> >  		break;
>> >  	default:
>> > -		desc =3D "bad mode";
>> > +		desc =3D "unknown or unrecoverable error";
>> >  		break;
>> >  	}
>>
>> Is this a separate trivial clean-up patch? It seems like you should
>> handle SIGKILL explicitly?
>
> I considered it part of this patch, since this function is not currently
> used elsewhere.
>
> I only expect this path to be followed as a catch-all for BUG() like
> conditions that can be contained by killing the user task.  Printing
> out a super-descriptive message didn't seem appropriate, but "bad mode"
> is especially opaque.  I think that was a paste from arch/arm -- AArch64
> doesn't have "modes" as such.
>
> Cheers
> ---Dave
