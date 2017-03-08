From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 2/5] KVM: arm/arm64: replace vcpu->arch.pause with a
 vcpu-request
Date: Wed, 8 Mar 2017 06:33:12 -0800
Message-ID: <20170308143312.GC109908@lvm>
References: <20170227175504.15751-1-drjones@redhat.com>
 <20170227175504.15751-3-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7CB240BBB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Mar 2017 09:31:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ixaryllmIpmx for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Mar 2017 09:31:51 -0500 (EST)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4327540296
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Mar 2017 09:31:51 -0500 (EST)
Received: by mail-wm0-f53.google.com with SMTP id n11so116374620wma.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Mar 2017 06:33:14 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20170227175504.15751-3-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: marc.zyngier@arm.com, ashoks@broadcom.com, imammedo@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Feb 27, 2017 at 06:55:01PM +0100, Andrew Jones wrote:
> This not only ensures visibility of changes to pause by using
> atomic ops, but also plugs a small race where a vcpu could get
> its pause state enabled just after its last check before entering
> the guest. With this patch, while the vcpu will still initially
> enter the guest, it will exit immediately due to the IPI sent by
> the vcpu kick issued after making the vcpu request.
> 
> We use __kvm_request_set, because we don't need the barrier
> kvm_request_set() provides. Additionally, kvm_request_test_and_clear
> is not used because, for pause, only the requester should do the
> clearing, i.e. testing and clearing need to be independent.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arch/arm/include/asm/kvm_host.h   |  5 +----
>  arch/arm/kvm/arm.c                | 26 +++++++++++++-------------
>  arch/arm64/include/asm/kvm_host.h |  5 +----
>  3 files changed, 15 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index cc495d799c67..3b5d60611cac 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -46,7 +46,7 @@
>  #define KVM_MAX_VCPUS VGIC_V2_MAX_CPUS
>  #endif
>  
> -#define KVM_REQ_VCPU_EXIT	8
> +#define KVM_REQ_VCPU_PAUSE	8
>  
>  u32 *kvm_vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num, u32 mode);
>  int __attribute_const__ kvm_target_cpu(void);
> @@ -174,9 +174,6 @@ struct kvm_vcpu_arch {
>  	/* vcpu power-off state */
>  	bool power_off;
>  
> -	 /* Don't run the guest (internal implementation need) */
> -	bool pause;
> -
>  	/* IO related fields */
>  	struct kvm_decode mmio_decode;
>  
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index c9a2103faeb9..17d5f3fb33d9 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -401,7 +401,8 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
>  int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
>  {
>  	return ((!!v->arch.irq_lines || kvm_vgic_vcpu_pending_irq(v))
> -		&& !v->arch.power_off && !v->arch.pause);
> +		&& !v->arch.power_off
> +		&& !__kvm_request_test(KVM_REQ_VCPU_PAUSE, v));
>  }
>  
>  /* Just ensure a guest exit from a particular CPU */
> @@ -532,17 +533,12 @@ bool kvm_arch_intc_initialized(struct kvm *kvm)
>  
>  void kvm_arm_halt_guest(struct kvm *kvm)
>  {
> -	int i;
> -	struct kvm_vcpu *vcpu;
> -
> -	kvm_for_each_vcpu(i, vcpu, kvm)
> -		vcpu->arch.pause = true;
> -	kvm_make_all_cpus_request(kvm, KVM_REQ_VCPU_EXIT);
> +	kvm_make_all_cpus_request(kvm, KVM_REQ_VCPU_PAUSE);
>  }
>  
>  void kvm_arm_halt_vcpu(struct kvm_vcpu *vcpu)
>  {
> -	vcpu->arch.pause = true;
> +	__kvm_request_set(KVM_REQ_VCPU_PAUSE, vcpu);
>  	kvm_vcpu_kick(vcpu);
>  }
>  
> @@ -550,7 +546,7 @@ void kvm_arm_resume_vcpu(struct kvm_vcpu *vcpu)
>  {
>  	struct swait_queue_head *wq = kvm_arch_vcpu_wq(vcpu);
>  
> -	vcpu->arch.pause = false;
> +	__kvm_request_clear(KVM_REQ_VCPU_PAUSE, vcpu);
>  	swake_up(wq);
>  }
>  
> @@ -568,7 +564,7 @@ static void vcpu_sleep(struct kvm_vcpu *vcpu)
>  	struct swait_queue_head *wq = kvm_arch_vcpu_wq(vcpu);
>  
>  	swait_event_interruptible(*wq, ((!vcpu->arch.power_off) &&
> -				       (!vcpu->arch.pause)));
> +		(!__kvm_request_test(KVM_REQ_VCPU_PAUSE, vcpu))));
>  }
>  
>  static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
> @@ -621,7 +617,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  
>  		update_vttbr(vcpu->kvm);
>  
> -		if (vcpu->arch.power_off || vcpu->arch.pause)
> +		if (vcpu->arch.power_off || __kvm_request_test(KVM_REQ_VCPU_PAUSE, vcpu))
>  			vcpu_sleep(vcpu);
>  
>  		/*
> @@ -644,8 +640,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  			run->exit_reason = KVM_EXIT_INTR;
>  		}
>  
> +		vcpu->mode = IN_GUEST_MODE;
> +		smp_mb(); /* ensure vcpu->mode is visible to kvm_vcpu_kick */

I think this comment is misleading, because this smp_mb() is really
about ensuring that with respect to other CPUs, the write to vcpu->mode
is observable before the read of kvm_request_pending below, and the
corresponding other barrier is the barrier implied in cmpxchg used by
kvm_vcpu_exiting_guest_mode, which gets called by kvm_vcpu_kick(), which
is called after __kvm_set_request.

So this also means that our direct use of kvm_vcpu_kick() without making
a request is currently racy, so we should address that where appropriate
as well.

Do you feel brave enough to take a look at that?

Thanks,
-Christoffer

> +
>  		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
> -			vcpu->arch.power_off || vcpu->arch.pause) {
> +			vcpu->arch.power_off || kvm_request_pending(vcpu)) {
> +			vcpu->mode = OUTSIDE_GUEST_MODE;
> +			smp_mb();
>  			local_irq_enable();
>  			kvm_pmu_sync_hwstate(vcpu);
>  			kvm_timer_sync_hwstate(vcpu);
> @@ -661,7 +662,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		 */
>  		trace_kvm_entry(*vcpu_pc(vcpu));
>  		guest_enter_irqoff();
> -		vcpu->mode = IN_GUEST_MODE;
>  
>  		ret = kvm_call_hyp(__kvm_vcpu_run, vcpu);
>  
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f21fd3894370..c03e1fc3bc34 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -43,7 +43,7 @@
>  
>  #define KVM_VCPU_MAX_FEATURES 4
>  
> -#define KVM_REQ_VCPU_EXIT	8
> +#define KVM_REQ_VCPU_PAUSE	8
>  
>  int __attribute_const__ kvm_target_cpu(void);
>  int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
> @@ -257,9 +257,6 @@ struct kvm_vcpu_arch {
>  	/* vcpu power-off state */
>  	bool power_off;
>  
> -	/* Don't run the guest (internal implementation need) */
> -	bool pause;
> -
>  	/* IO related fields */
>  	struct kvm_decode mmio_decode;
>  
> -- 
> 2.9.3
> 
