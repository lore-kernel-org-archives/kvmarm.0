From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v3 19/28] arm64/sve: ptrace and ELF coredump support
Date: Fri, 13 Oct 2017 17:16:39 +0100
Message-ID: <20171013161638.GM19485@e103592.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-20-git-send-email-Dave.Martin@arm.com>
 <20171012170632.35zifttm55rzu745@armageddon.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AD2C49D29
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Oct 2017 12:15:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l41wFZQAG+hc for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Oct 2017 12:15:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE42149D26
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Oct 2017 12:15:56 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20171012170632.35zifttm55rzu745@armageddon.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Will Deacon <will.deacon@arm.com>, Alan Hayward <alan.hayward@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 12, 2017 at 06:06:32PM +0100, Catalin Marinas wrote:
> On Tue, Oct 10, 2017 at 07:38:36PM +0100, Dave P Martin wrote:
> > @@ -702,6 +737,211 @@ static int system_call_set(struct task_struct *target,
> >  	return ret;
> >  }
> >  
> > +#ifdef CONFIG_ARM64_SVE
> > +
> > +static void sve_init_header_from_task(struct user_sve_header *header,
> > +				      struct task_struct *target)
> > +{
> > +	unsigned int vq;
> > +
> > +	memset(header, 0, sizeof(*header));
> > +
> > +	header->flags = test_tsk_thread_flag(target, TIF_SVE) ?
> > +		SVE_PT_REGS_SVE : SVE_PT_REGS_FPSIMD;
> 
> For PTRACE_SYSCALL, we may or may not have TIF_SVE depending on what
> happened with the target. Just a thought: shall we clear TIF_SVE (and
> sync it to fpsimd) in syscall_trace_enter()?

I'm not so sure: if we were to do that, a syscall that is cancelled by
writing -1 to REGSET_SYSCALL could still discard the SVE registers as a
side-effect.

The target committed to discard by executing SVC, but my feeling is
that cancellation of a syscall in this way shouldn't have avoidable
side-effects for the target.  But the semantics of cancelled syscalls
are a bit of a grey area, so I can see potential arguments on both
sides.

The current approach at least saves a bit of code.  What do you think?

> > +	if (test_tsk_thread_flag(target, TIF_SVE_VL_INHERIT))
> > +		header->flags |= SVE_PT_VL_INHERIT;
> > +
> > +	header->vl = target->thread.sve_vl;
> > +	vq = sve_vq_from_vl(header->vl);
> > +
> > +	header->max_vl = sve_max_vl;
> > +	if (WARN_ON(!sve_vl_valid(sve_max_vl)))
> > +		header->max_vl = header->vl;
> > +
> > +	header->size = SVE_PT_SIZE(vq, header->flags);
> > +	header->max_size = SVE_PT_SIZE(sve_vq_from_vl(header->max_vl),
> > +				      SVE_PT_REGS_SVE);
> > +}
> [...]
> > +static int sve_set(struct task_struct *target,
> > +		   const struct user_regset *regset,
> > +		   unsigned int pos, unsigned int count,
> > +		   const void *kbuf, const void __user *ubuf)
> > +{
> > +	int ret;
> > +	struct user_sve_header header;
> > +	unsigned int vq;
> > +	unsigned long start, end;
> > +
> > +	if (!system_supports_sve())
> > +		return -EINVAL;
> > +
> > +	/* Header */
> > +	if (count < sizeof(header))
> > +		return -EINVAL;
> > +	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &header,
> > +				 0, sizeof(header));
> > +	if (ret)
> > +		goto out;
> > +
> > +	/*
> > +	 * Apart from PT_SVE_REGS_MASK, all PT_SVE_* flags are consumed by
> > +	 * sve_set_vector_length(), which will also validate them for us:
> > +	 */
> > +	ret = sve_set_vector_length(target, header.vl,
> > +		((unsigned long)header.flags & ~SVE_PT_REGS_MASK) << 16);
> > +	if (ret)
> > +		goto out;
> > +
> > +	/* Actual VL set may be less than the user asked for: */
> > +	vq = sve_vq_from_vl(target->thread.sve_vl);
> > +
> > +	/* Registers: FPSIMD-only case */
> > +
> > +	BUILD_BUG_ON(SVE_PT_FPSIMD_OFFSET != sizeof(header));
> > +	if ((header.flags & SVE_PT_REGS_MASK) == SVE_PT_REGS_FPSIMD) {
> > +		sve_sync_to_fpsimd(target);
> > +
> > +		ret = __fpr_set(target, regset, pos, count, kbuf, ubuf,
> > +				SVE_PT_FPSIMD_OFFSET);
> > +		clear_tsk_thread_flag(target, TIF_SVE);
> > +		goto out;
> > +	}
> 
> __fpr_set() already calls sve_sync_to_fpsimd(). Anyway, do you actually

Yes, the call to sve_sync_to_fpsimd() is superfluous here -- I think
that I realised that all callers of __fpr_set() need this to happen,
but never deleted the explicit call from sve_set().

I'll delete it.


Looking more closely at __fpr_set() though, I think it needs this change
too, because the sync is unintentionally placed after reading
thread.fpsimd_state instead of before:

@@ -652,11 +652,12 @@ static int __fpr_set(struct task_struct *target,
                     unsigned int start_pos)
 {
        int ret;
-       struct user_fpsimd_state newstate =
-               target->thread.fpsimd_state.user_fpsimd;
+       struct user_fpsimd_state newstate;
 
        sve_sync_to_fpsimd(target);
 
+       newstate = target->thread.fpsimd_state.user_fpsimd;
+
        ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &newstate,
[...]

(Or were you confident that this was already OK?  Maybe I'm confusing
myself.)

> need this since we are going to override the FPSIMD state anyway here.

The underlying reason for this is the issue of what should happen
for short regset writes.  Historically, writes through fpr_set() can
be truncated arbitrarily, and the rest of fpsimd_state will remain
unchanged.

The issue is that if TIF_SVE is set, fpsimd_state can be stale for
target.  If the initial sve_sync_to_fpsimd() is removed in sve_set()
above, then we may resurrect old values for the untouched registers,
instead of simply leaving them unmodified.

Should I add comments explaining the purpose?  I guess it is rather
non-obvious.


Of course, I don't know whether userspace should really rely on partial
regset writes doing anything sane, but I figured the implemented
behaviour is at least less surprising with respect to the fpr_set()
behavior.

No legacy software can be relying on NT_ARM_SVE at all, so the behaviour
here may not matter that much.  My idea was to reduce the invasiveness
of porting ptrace clients to use NT_ARM_SVE.

> 
> > +
> > +	/* Otherwise: full SVE case */
> > +
> > +	/*
> > +	 * If setting a different VL from the requested VL and there is
> > +	 * register data, the data layout will be wrong: don't even
> > +	 * try to set the registers in this case.
> > +	 */
> > +	if (count && vq != sve_vq_from_vl(header.vl)) {
> > +		ret = -EIO;
> > +		goto out;
> > +	}
> > +
> > +	sve_alloc(target);
> > +	fpsimd_sync_to_sve(target);
> 
> Similarly here, it's a full SVE case, so we are going to override it
> anyway.

The argument here is similar: target->sve_state might already be
allocated and if so it could contain data that doesn't match the user
task's idea of what's in the V-regs.  (In fact, sve_alloc() currently
zeroes sve_state, but that's still different from the current V-regs.)

There is no possibility of legacy software relying on this code path,
so we could say that a short write to NT_ARM_SVE with PT_SVE_REGS_SVE
in flags zeroes any trailing data instead of preserving it.


Either way, I don't intend to document the behaviour of partial
writes to NT_ARM_SVE.  From a userspace point of view, I leave it
unspecified.

> > +	set_tsk_thread_flag(target, TIF_SVE);
> 
> This has the side-effect of enabling TIF_SVE even for PTRACE_SYSCALL
> which may be cleared in some circumstances. It may not be an issue
> though.

I would argue that this is correct behaviour: the syscall enter trap and
exit traps should both behave as if they are outside the syscall,
allowing the debugger to simulate the effect of inserting any
instructions the target could have inserted before or after the SVC.
This may include simulating SVE instructions or modifying SVE regs,
which would require TIF_SVE to get set.

If the tracer doesn't cancel the syscall at the enter trap, then a
real syscall will execute and that may cause the SVE state to be
discarded in the usual way in the case of preemption or blocking: it
seems cleaner for the debug illusion that this decision isn't made
differently just because the target is being traced.

(Spoiler alert though: the syscall exit trap will force the target
to be scheduled out, which will force discard with the current
task_fpsimd_save() behaviour ... but that could be changed in the
future, and I prefer not to document any sort of guarantee here.)


Does this make sense?  There may be issues or corner cases here
that I didn't spot...

Cheers
---Dave
