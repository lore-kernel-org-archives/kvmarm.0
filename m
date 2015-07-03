From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [RFC 08/17] kvm: arm/arm64: implement kvm_arm_[halt, resume]_guest
Date: Fri, 03 Jul 2015 13:55:52 +0200
Message-ID: <55967848.5050204@linaro.org>
References: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
 <1435843047-6327-9-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52B855792C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 07:44:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3qya4TVehAuG for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jul 2015 07:44:53 -0400 (EDT)
Received: from mail-wi0-f178.google.com (mail-wi0-f178.google.com
 [209.85.212.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EC41D578DD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 07:44:51 -0400 (EDT)
Received: by wiwl6 with SMTP id l6so224729543wiw.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Jul 2015 04:56:10 -0700 (PDT)
In-Reply-To: <1435843047-6327-9-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.williamson@redhat.com, pbonzini@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, joro@8bytes.org, b.reynal@virtualopensystems.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Christoffer, Marc,
On 07/02/2015 03:17 PM, Eric Auger wrote:
> On halt, the guest is forced to exit and prevented from being
> re-entered. This is synchronous.
> 
> Those two operations will be needed for IRQ forwarding setting.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
would you agree to handle this ARM functionality separately from the
forwarding series?

This includes 2 patch files, that one +
https://lkml.org/lkml/2015/7/2/288. This functionality is needed for
forwarding control since when changing the forwarding state we need to
"freeze" the state of the physical/virtual IRQ to undertake proper
actions. Stopping the guest makes sure it won't deactivate the virtual
IRQ while we are doing state change actions.

The forwarding series is quite heterogeneous (VFIO platform driver,
vgic, irq bypass manager) and I think it would simplify the review process.

Please let me know if you agree. If yes, I will post a separate series.

Best Regards

Eric
> 
> ---
> 
> RFC:
> - rename the function and this latter becomes static
> - remove __KVM_HAVE_ARCH_HALT_GUEST
> 
> v4 -> v5: add arm64 support
> - also defines __KVM_HAVE_ARCH_HALT_GUEST for arm64
> - add pause field
> ---
>  arch/arm/include/asm/kvm_host.h   |  3 +++
>  arch/arm/kvm/arm.c                | 32 +++++++++++++++++++++++++++++---
>  arch/arm64/include/asm/kvm_host.h |  3 +++
>  3 files changed, 35 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 304004d..899ae27 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -132,6 +132,9 @@ struct kvm_vcpu_arch {
>  	/* vcpu power-off state */
>  	bool power_off;
>  
> +	/* Don't run the guest */
> +	bool pause;
> +
>  	/* IO related fields */
>  	struct kvm_decode mmio_decode;
>  
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 7537e68..4be6715 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -471,11 +471,36 @@ bool kvm_arch_intc_initialized(struct kvm *kvm)
>  	return vgic_initialized(kvm);
>  }
>  
> +static void kvm_arm_halt_guest(struct kvm *kvm)
> +{
> +	int i;
> +	struct kvm_vcpu *vcpu;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm)
> +		vcpu->arch.pause = true;
> +	force_vm_exit(cpu_all_mask);
> +}
> +
> +static void kvm_arm_resume_guest(struct kvm *kvm)
> +{
> +	int i;
> +	struct kvm_vcpu *vcpu;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		wait_queue_head_t *wq = kvm_arch_vcpu_wq(vcpu);
> +
> +		vcpu->arch.pause = false;
> +		wake_up_interruptible(wq);
> +	}
> +}
> +
> +
>  static void vcpu_pause(struct kvm_vcpu *vcpu)
>  {
>  	wait_queue_head_t *wq = kvm_arch_vcpu_wq(vcpu);
>  
> -	wait_event_interruptible(*wq, !vcpu->arch.power_off);
> +	wait_event_interruptible(*wq, ((!vcpu->arch.power_off) &&
> +				       (!vcpu->arch.pause)));
>  }
>  
>  static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
> @@ -525,7 +550,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  
>  		update_vttbr(vcpu->kvm);
>  
> -		if (vcpu->arch.power_off)
> +		if (vcpu->arch.power_off || vcpu->arch.pause)
>  			vcpu_pause(vcpu);
>  
>  		/*
> @@ -551,7 +576,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  			run->exit_reason = KVM_EXIT_INTR;
>  		}
>  
> -		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm)) {
> +		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
> +		    vcpu->arch.pause) {
>  			local_irq_enable();
>  			preempt_enable();
>  			kvm_vgic_sync_hwstate(vcpu);
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 009da6b..69e3785 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -125,6 +125,9 @@ struct kvm_vcpu_arch {
>  	/* vcpu power-off state */
>  	bool power_off;
>  
> +	/* Don't run the guest */
> +	bool pause;
> +
>  	/* IO related fields */
>  	struct kvm_decode mmio_decode;
>  
> 
