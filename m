From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2] arm/arm64: KVM: Properly account for guest CPU time
Date: Mon, 8 Jun 2015 13:35:24 +0200
Message-ID: <20150608113524.GA2001@cbox>
References: <1432838950-28774-1-git-send-email-christoffer.dall@linaro.org>
 <5568E987.5010702@samsung.com> <20150531065923.GB763@cbox>
 <556C7EC6.3010105@samsung.com> <20150602092759.GA7783@cbox>
 <557194E7.5020102@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC058538E3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jun 2015 07:24:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p9HuPovwJpoD for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Jun 2015 07:24:35 -0400 (EDT)
Received: from mail-la0-f53.google.com (mail-la0-f53.google.com
 [209.85.215.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 081AC538C8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jun 2015 07:24:34 -0400 (EDT)
Received: by laar3 with SMTP id r3so45565116laa.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Jun 2015 04:34:47 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <557194E7.5020102@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, borntraeger@de.ibm.com, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jun 05, 2015 at 05:24:07AM -0700, Mario Smarduch wrote:
> On 06/02/2015 02:27 AM, Christoffer Dall wrote:
> > On Mon, Jun 01, 2015 at 08:48:22AM -0700, Mario Smarduch wrote:
> >> On 05/30/2015 11:59 PM, Christoffer Dall wrote:
> >>> Hi Mario,
> >>>
> >>> On Fri, May 29, 2015 at 03:34:47PM -0700, Mario Smarduch wrote:
> >>>> On 05/28/2015 11:49 AM, Christoffer Dall wrote:
> >>>>> Until now we have been calling kvm_guest_exit after re-enabling
> >>>>> interrupts when we come back from the guest, but this has the
> >>>>> unfortunate effect that CPU time accounting done in the context of timer
> >>>>> interrupts occurring while the guest is running doesn't properly notice
> >>>>> that the time since the last tick was spent in the guest.
> >>>>>
> >>>>> Inspired by the comment in the x86 code, move the kvm_guest_exit() call
> >>>>> below the local_irq_enable() call and change __kvm_guest_exit() to
> >>>>> kvm_guest_exit(), because we are now calling this function with
> >>>>> interrupts enabled.  We have to now explicitly disable preemption and
> >>>>> not enable preemption before we've called kvm_guest_exit(), since
> >>>>> otherwise we could be preempted and everything happening before we
> >>>>> eventually get scheduled again would be accounted for as guest time.
> >>>>>
> >>>>> At the same time, move the trace_kvm_exit() call outside of the atomic
> >>>>> section, since there is no reason for us to do that with interrupts
> >>>>> disabled.
> >>>>>
> >>>>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> >>>>> ---
> >>>>> This patch is based on kvm/queue, because it has the kvm_guest_enter/exit
> >>>>> rework recently posted by Christian Borntraeger.  I hope I got the logic
> >>>>> of this right, there were 2 slightly worrying facts about this:
> >>>>>
> >>>>> First, we now enable and disable and enable interrupts on each exit
> >>>>> path, but I couldn't see any performance overhead on hackbench - yes the
> >>>>> only benchmark we care about.
> >>>>>
> >>>>> Second, looking at the ppc and mips code, they seem to also call
> >>>>> kvm_guest_exit() before enabling interrupts, so I don't understand how
> >>>>> guest CPU time accounting works on those architectures.
> >>>>>
> >>>>> Changes since v1:
> >>>>>  - Tweak comment and commit text based on Marc's feedback.
> >>>>>  - Explicitly disable preemption and enable it only after kvm_guest_exit().
> >>>>>
> >>>>>  arch/arm/kvm/arm.c | 21 +++++++++++++++++----
> >>>>>  1 file changed, 17 insertions(+), 4 deletions(-)
> >>>>>
> >>>>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> >>>>> index e41cb11..fe8028d 100644
> >>>>> --- a/arch/arm/kvm/arm.c
> >>>>> +++ b/arch/arm/kvm/arm.c
> >>>>> @@ -532,6 +532,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >>>>>  		kvm_vgic_flush_hwstate(vcpu);
> >>>>>  		kvm_timer_flush_hwstate(vcpu);
> >>>>>  
> >>>>> +		preempt_disable();
> >>>>>  		local_irq_disable();
> >>>>>  
> >>>>>  		/*
> >>>>> @@ -544,6 +545,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >>>>>  
> >>>>>  		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm)) {
> >>>>>  			local_irq_enable();
> >>>>> +			preempt_enable();
> >>>>>  			kvm_timer_sync_hwstate(vcpu);
> >>>>>  			kvm_vgic_sync_hwstate(vcpu);
> >>>>>  			continue;
> >>>>> @@ -559,8 +561,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >>>>>  		ret = kvm_call_hyp(__kvm_vcpu_run, vcpu);
> >>>>>  
> >>>>>  		vcpu->mode = OUTSIDE_GUEST_MODE;
> >>>>> -		__kvm_guest_exit();
> >>>>> -		trace_kvm_exit(kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
> >>>>> +		/*
> >>>>> +		 * Back from guest
> >>>>> +		 *************************************************************/
> >>>>> +
> >>>>>  		/*
> >>>>>  		 * We may have taken a host interrupt in HYP mode (ie
> >>>>>  		 * while executing the guest). This interrupt is still
> >>>>> @@ -574,8 +578,17 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >>>>>  		local_irq_enable();
> >>>>>  
> >>>>>  		/*
> >>>>> -		 * Back from guest
> >>>>> -		 *************************************************************/
> >>>>> +		 * We do local_irq_enable() before calling kvm_guest_exit() so
> >>>>> +		 * that if a timer interrupt hits while running the guest we
> >>>>> +		 * account that tick as being spent in the guest.  We enable
> >>>>> +		 * preemption after calling kvm_guest_exit() so that if we get
> >>>>> +		 * preempted we make sure ticks after that is not counted as
> >>>>> +		 * guest time.
> >>>>> +		 */
> >>>>> +		kvm_guest_exit();
> >>>>> +		trace_kvm_exit(kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
> >>>>> +		preempt_enable();
> >>>>> +
> >>>>>  
> >>>>>  		kvm_timer_sync_hwstate(vcpu);
> >>>>>  		kvm_vgic_sync_hwstate(vcpu);
> >>>>>
> >>>>
> >>>> Hi Christoffer,
> >>>>  so currently we take a snap shot when we enter the guest
> >>>> (tsk->vtime_snap) and upon exit add the time we spent in
> >>>> the guest and update accrued time, which appears correct.
> >>>
> >>> not on arm64, because we don't select HAVE_VIRT_CPU_ACCOUNTING_GEN.  Or
> >>> am I missing something obvious here?
> >> I see what you mean we can't use cycle based accounting to accrue
> >> Guest time.
> >>
> > 
> > See other thread, we can enable this in the config but it still only
> > works with NO_HZ_FULL.
> > 
> >>>
> >>>>
> >>>> With this patch it appears that interrupts running
> >>>> in host mode are accrued to Guest time, and additional preemption
> >>>> latency is added.
> >>>>
> >>> It is true that interrupt processing in host mode (if they hit on a CPU
> >>> when it is running a guest) are accrued to guest time, but without this
> >>> patch on current arm64 we accrue no CPU time to guest time at all, which
> >>> is hardly more correct.
> >> Yes if only ticks are supported then it's definitely better!
> >>
> >> Nevertheless with high interrupt rate it will complicate root causing
> >> issues, a lot of that time will go to guest.
> > 
> > That sounds like a separate fix to me; if there's an existing mechanism
> > to account for time spent on hw IRQs and it is somehow invalidated by
> > the PF_VCPU flag being set, then that feels wrong, at least how arm64
> > works, but it doesn't make this patch less correct.
> 
> Tracing through the code (account_system_time()) it appears if the
> timer fires while an IRQ runs, tick are accounted to host IRQ
> mode (CPUTIME_IRQ). Otherwise it's accrued to guest. Under heavy
> interrupt load it's likely guest will mis some ticks, it appears
> it's the reverse of what I initially thought but in practice
> guest time should be ok as far as ticks go.
> 
> > 
> >>
> >>>
> >>> If this patch is incorrect, then how does it work on x86, where
> >>> handle_external_intr() is called (with a barrier in between) before
> >>> kvm_guest_exit(), and where handle_external_intr() is simply
> >>> local_irq_enable() on SVM and something more complicated on VMX ?
> >>>
> >>> Finally, how exactly is preemption latency added here?   Won't IRQ
> >>> processing run with higher priority than any task on your system, so the
> >>> order of (1) process pending IRQs (2) call schedule if needed is still
> >>> preserved here, but we call kvm_guest_exit() between (1) and (2) instead
> >>> of before (1).
> >>
> >> I may be missing something, but on return from interrupt with preempt
> >> disabled we can't take the need resched path. And need to return
> >> to KVM no?
> > 
> > preempt_enable() will call __preempt_schedule() and cause preemption
> > there, so you're talking about adding these lines of latency:t
> > 
> > 	kvm_guest_exit();
> > 	trace_kvm_exit(kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
> 
> On return from IRQ this should execute - and el1_preempt won't
> get called.
> 
> #ifdef CONFIG_PREEMPT
>         get_thread_info tsk
>         ldr     w24, [tsk, #TI_PREEMPT]         // get preempt count
>         cbnz    w24, 1f                         // preempt count != 0
>         ldr     x0, [tsk, #TI_FLAGS]            // get flags
>         tbz     x0, #TIF_NEED_RESCHED, 1f       // needs rescheduling?
>         bl      el1_preempt
> 1:
> #endif
> 

I understand that, but then you call preempt_enable right after which
calls __preempt_schedule() which has the same affect as that asm snippet
you pasted here.

> 
> > 
> > And these were called with interrupts disabled before, so I don't see
> > the issue??
> > 
> > However, your question is making me think whether we have a race in the
> > current code on fully preemptible kernels, if we get preempted before
> > calling kvm_timer_sync_hwstate() and kvm_vgic_sync_hwstate(), then we
> > could potentially schedule another vcpu on this core and loose/corrupt
> > state, can we not?  We probably need to check for this in
> > kvm_vcpu_load/kvm_vcpu_put.  I need to think more about if this is a
> > real issue or if I'm seeing ghosts.
> 
> Yes appears like it could be an issue in PREEMPT mode.

see separate mail, I don't believe this to be an issue anymore.

> > 
> >>>
> >>> It is entirely possible that I'm missing the mark here and everything
> >>> gets solved by enabling HAVE_VIRT_CPU_ACCOUNTING_GEN or we need some
> >>> extra logic?
> >>
> >> I think something to look into for us, taking a low issue to high level
> >> application - for state machine based type of applications (I guess like
> >> NFV) it cause problems  to root cause issues, a lot of activities
> >> run between ticks. For VM cycle based accounting is probably a must
> >> in that case.
> >>
> > Would you run with NO_HZ_FULL in this case?  Because then we should just
> > enable HAVE_VIRT_CPU_ACCOUNTING_GEN, and I think that would be a good
> > start.
> It may have a use case to run an isolated vCPU, but in general any mode
> may be used (,NO_HZ, even low PERIODIC).
> 
ok, but I still think it would be more correct to have this patch than
not to.

-Christoffer
