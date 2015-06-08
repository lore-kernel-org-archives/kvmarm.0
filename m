From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2] arm/arm64: KVM: Properly account for guest CPU time
Date: Mon, 08 Jun 2015 18:50:08 +0100
Message-ID: <5575D5D0.3090701@arm.com>
References: <1432838950-28774-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F245A53E18
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jun 2015 13:39:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jNPp63KstuvO for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Jun 2015 13:39:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2363E53E17
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jun 2015 13:39:56 -0400 (EDT)
In-Reply-To: <1432838950-28774-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Cc: "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 28/05/15 19:49, Christoffer Dall wrote:
> Until now we have been calling kvm_guest_exit after re-enabling
> interrupts when we come back from the guest, but this has the
> unfortunate effect that CPU time accounting done in the context of timer
> interrupts occurring while the guest is running doesn't properly notice
> that the time since the last tick was spent in the guest.
> 
> Inspired by the comment in the x86 code, move the kvm_guest_exit() call
> below the local_irq_enable() call and change __kvm_guest_exit() to
> kvm_guest_exit(), because we are now calling this function with
> interrupts enabled.  We have to now explicitly disable preemption and
> not enable preemption before we've called kvm_guest_exit(), since
> otherwise we could be preempted and everything happening before we
> eventually get scheduled again would be accounted for as guest time.
> 
> At the same time, move the trace_kvm_exit() call outside of the atomic
> section, since there is no reason for us to do that with interrupts
> disabled.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
> This patch is based on kvm/queue, because it has the kvm_guest_enter/exit
> rework recently posted by Christian Borntraeger.  I hope I got the logic
> of this right, there were 2 slightly worrying facts about this:
> 
> First, we now enable and disable and enable interrupts on each exit
> path, but I couldn't see any performance overhead on hackbench - yes the
> only benchmark we care about.
> 
> Second, looking at the ppc and mips code, they seem to also call
> kvm_guest_exit() before enabling interrupts, so I don't understand how
> guest CPU time accounting works on those architectures.
> 
> Changes since v1:
>  - Tweak comment and commit text based on Marc's feedback.
>  - Explicitly disable preemption and enable it only after kvm_guest_exit().
> 
>  arch/arm/kvm/arm.c | 21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index e41cb11..fe8028d 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -532,6 +532,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		kvm_vgic_flush_hwstate(vcpu);
>  		kvm_timer_flush_hwstate(vcpu);
>  
> +		preempt_disable();
>  		local_irq_disable();
>  
>  		/*
> @@ -544,6 +545,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  
>  		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm)) {
>  			local_irq_enable();
> +			preempt_enable();
>  			kvm_timer_sync_hwstate(vcpu);
>  			kvm_vgic_sync_hwstate(vcpu);
>  			continue;
> @@ -559,8 +561,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		ret = kvm_call_hyp(__kvm_vcpu_run, vcpu);
>  
>  		vcpu->mode = OUTSIDE_GUEST_MODE;
> -		__kvm_guest_exit();
> -		trace_kvm_exit(kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
> +		/*
> +		 * Back from guest
> +		 *************************************************************/
> +
>  		/*
>  		 * We may have taken a host interrupt in HYP mode (ie
>  		 * while executing the guest). This interrupt is still
> @@ -574,8 +578,17 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		local_irq_enable();
>  
>  		/*
> -		 * Back from guest
> -		 *************************************************************/
> +		 * We do local_irq_enable() before calling kvm_guest_exit() so
> +		 * that if a timer interrupt hits while running the guest we
> +		 * account that tick as being spent in the guest.  We enable
> +		 * preemption after calling kvm_guest_exit() so that if we get
> +		 * preempted we make sure ticks after that is not counted as
> +		 * guest time.
> +		 */
> +		kvm_guest_exit();
> +		trace_kvm_exit(kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
> +		preempt_enable();
> +
>  
>  		kvm_timer_sync_hwstate(vcpu);
>  		kvm_vgic_sync_hwstate(vcpu);
> 

I've been thinking about this a bit more, and I wonder if we can
simplify it a bit. At the moment, we disable the interrupts around the
HYP entry. But now that you have introduced preempt_disable, it looks
like we move the local_irq_disable call to be just after
__kvm_guest_enter, and not bother with having such a long critical section.

This is possible because entering HYP mode automatically masks
interrupts, and we restore PSTATE on exception return.

I think this would slightly reduce the amount of code we run on the host
that gets accounted to the guest.

Thoughts?

Thanks,

	M.

-- 
Jazz is not dead. It just smells funny...
