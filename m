From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 4/4] KVM: arm/arm64: implement
 kvm_arm_[halt,resume]_guest
Date: Mon, 31 Aug 2015 12:43:33 +0200
Message-ID: <20150831104333.GO24113@cbox>
References: <1438963713-10460-1-git-send-email-eric.auger@linaro.org>
 <1438963713-10460-5-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438963713-10460-5-git-send-email-eric.auger@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, marc.zyngier@arm.com, drjones@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Aug 07, 2015 at 06:08:33PM +0200, Eric Auger wrote:
> We introduce kvm_arm_halt_guest and resume functions. They
> will be used for IRQ forward state change.
> 
> Halt is synchronous and prevents the guest from being re-entered.
> We use the same mechanism put in place for PSCI former pause,
> now renamed power_off. A new flag is introduced in arch vcpu state,
> pause, only meant to be used by those functions.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 
> ---
> v1 -> v2:
> - check pause in kvm_arch_vcpu_runnable
> - we cannot use kvm_vcpu_block since this latter would exit on
>   IRQ/FIQ and this is not what we want
> ---
>  arch/arm/include/asm/kvm_host.h   |  3 +++
>  arch/arm/kvm/arm.c                | 35 +++++++++++++++++++++++++++++++----
>  arch/arm64/include/asm/kvm_host.h |  3 +++
>  3 files changed, 37 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 304004d..dac85f6 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -132,6 +132,9 @@ struct kvm_vcpu_arch {
>  	/* vcpu power-off state */
>  	bool power_off;
>  
> +	 /* Exit and don't run the guest (internal implementation need) */

Why exit?  I think it's slightly more correct to just say.
"Don't run the guest (internal implementation need)"

> +	bool pause;
> +
>  	/* IO related fields */
>  	struct kvm_decode mmio_decode;
>  
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index cc404a8..0529b38 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -348,7 +348,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
>  int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
>  {
>  	return ((!!v->arch.irq_lines || kvm_vgic_vcpu_pending_irq(v))
> -		&& !v->arch.power_off);
> +		&& !v->arch.power_off && !v->arch.pause);
>  }
>  
>  /* Just ensure a guest exit from a particular CPU */
> @@ -474,11 +474,38 @@ bool kvm_arch_intc_initialized(struct kvm *kvm)
>  	return vgic_initialized(kvm);
>  }
>  
> +static void kvm_arm_halt_guest(struct kvm *kvm) __maybe_unused;
> +static void kvm_arm_resume_guest(struct kvm *kvm) __maybe_unused;
> +
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
>  static void vcpu_sleep(struct kvm_vcpu *vcpu)
>  {
>  	wait_queue_head_t *wq = kvm_arch_vcpu_wq(vcpu);
>  
> -	wait_event_interruptible(*wq, !vcpu->arch.power_off);
> +	wait_event_interruptible(*wq, ((!vcpu->arch.power_off) &&
> +				       (!vcpu->arch.pause)));
>  }
>  
>  static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
> @@ -528,7 +555,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  
>  		update_vttbr(vcpu->kvm);
>  
> -		if (vcpu->arch.power_off)
> +		if (vcpu->arch.power_off || vcpu->arch.pause)
>  			vcpu_sleep(vcpu);
>  
>  		/*
> @@ -556,7 +583,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		}
>  
>  		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
> -			vcpu->arch.power_off) {
> +			vcpu->arch.power_off || vcpu->arch.pause) {
>  			local_irq_enable();
>  			kvm_vgic_sync_hwstate(vcpu);
>  			preempt_enable();
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 009da6b..69e3785 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -125,6 +125,9 @@ struct kvm_vcpu_arch {
>  	/* vcpu power-off state */
>  	bool power_off;
>  
> +	/* Don't run the guest */

Can we have the same comment on the arm and arm64 version?

> +	bool pause;
> +
>  	/* IO related fields */
>  	struct kvm_decode mmio_decode;
>  
> -- 
> 1.9.1
> 

Besides these commenting nits, I think this looks reasonable overall.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

On the series.
