From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 5/9] KVM: arm/arm64: replace vcpu->arch.power_off with
 a vcpu request
Date: Tue, 4 Apr 2017 19:37:26 +0200
Message-ID: <20170404173726.GA31208@cbox>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-6-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170331160658.4331-6-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 31, 2017 at 06:06:54PM +0200, Andrew Jones wrote:
> Like pause, replacing power_off with a vcpu request ensures
> visibility of changes and avoids the final race before entering
> the guest.

I think it's worth explaining the race in the commit message first, just
briefly.

> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arch/arm/include/asm/kvm_host.h   |  4 +---
>  arch/arm/kvm/arm.c                | 32 ++++++++++++++++++--------------
>  arch/arm/kvm/psci.c               | 17 +++++------------
>  arch/arm64/include/asm/kvm_host.h |  4 +---
>  4 files changed, 25 insertions(+), 32 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 52c25536d254..afed5d44634d 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -46,6 +46,7 @@
>  #endif
>  
>  #define KVM_REQ_PAUSE		8
> +#define KVM_REQ_POWER_OFF	9
>  
>  u32 *kvm_vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num, u32 mode);
>  int __attribute_const__ kvm_target_cpu(void);
> @@ -170,9 +171,6 @@ struct kvm_vcpu_arch {
>  	 * here.
>  	 */
>  
> -	/* vcpu power-off state */
> -	bool power_off;
> -
>  	/* IO related fields */
>  	struct kvm_decode mmio_decode;
>  
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index f3bfbb5f3d96..7ed39060b1cf 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -381,7 +381,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
>  				    struct kvm_mp_state *mp_state)
>  {
> -	if (vcpu->arch.power_off)
> +	if (test_bit(KVM_REQ_POWER_OFF, &vcpu->requests))
>  		mp_state->mp_state = KVM_MP_STATE_STOPPED;
>  	else
>  		mp_state->mp_state = KVM_MP_STATE_RUNNABLE;
> @@ -394,10 +394,10 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
>  {
>  	switch (mp_state->mp_state) {
>  	case KVM_MP_STATE_RUNNABLE:
> -		vcpu->arch.power_off = false;
> +		clear_bit(KVM_REQ_POWER_OFF, &vcpu->requests);
>  		break;
>  	case KVM_MP_STATE_STOPPED:
> -		vcpu->arch.power_off = true;
> +		set_bit(KVM_REQ_POWER_OFF, &vcpu->requests);

this looks a bit dodgy; I am getting an even stronger feeling that we
should keep power_off = true, and here we can safely set it directly
because we have mutual exclusion from KVM_RUN, and that leaves us using
requests only to "ask the VCPU to do something for us, like setting its
power_off state", except...

>  		break;
>  	default:
>  		return -EINVAL;
> @@ -415,9 +415,9 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
>   */
>  int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
>  {
> -	return ((!!v->arch.irq_lines || kvm_vgic_vcpu_pending_irq(v))
> -		&& !v->arch.power_off
> -		&& !test_bit(KVM_REQ_PAUSE, &v->requests));
> +	return (!!v->arch.irq_lines || kvm_vgic_vcpu_pending_irq(v)) &&
> +		!test_bit(KVM_REQ_POWER_OFF, &v->requests) &&
> +		!test_bit(KVM_REQ_PAUSE, &v->requests);
>  }
>  
>  /* Just ensure a guest exit from a particular CPU */
> @@ -578,8 +578,9 @@ static void vcpu_sleep(struct kvm_vcpu *vcpu)
>  {
>  	struct swait_queue_head *wq = kvm_arch_vcpu_wq(vcpu);
>  
> -	swait_event_interruptible(*wq, ((!vcpu->arch.power_off) &&
> -		(!test_bit(KVM_REQ_PAUSE, &vcpu->requests))));
> +	swait_event_interruptible(*wq,
> +		!test_bit(KVM_REQ_POWER_OFF, &vcpu->requests) &&
> +		!test_bit(KVM_REQ_PAUSE, &vcpu->requests));
>  }
>  
>  static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
> @@ -632,8 +633,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  
>  		update_vttbr(vcpu->kvm);
>  
> -		if (vcpu->arch.power_off || test_bit(KVM_REQ_PAUSE, &vcpu->requests))
> -			vcpu_sleep(vcpu);
> +		if (kvm_request_pending(vcpu)) {
> +			if (test_bit(KVM_REQ_POWER_OFF, &vcpu->requests) ||
> +			    test_bit(KVM_REQ_PAUSE, &vcpu->requests))
> +				vcpu_sleep(vcpu);
> +		}

...hmm, I do like that we only need to check the requests variable once,
and not check multiple flags, but at least we'd only have to do it once
(not after disabling interrupts again).

>  
>  		/*
>  		 * Preparing the interrupts to be injected also
> @@ -664,8 +668,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		WRITE_ONCE(vcpu->mode, IN_GUEST_MODE);
>  		smp_mb();
>  
> -		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
> -			vcpu->arch.power_off || kvm_request_pending(vcpu)) {
> +		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm)
> +		    || kvm_request_pending(vcpu)) {
>  			WRITE_ONCE(vcpu->mode, OUTSIDE_GUEST_MODE);
>  			local_irq_enable();
>  			kvm_pmu_sync_hwstate(vcpu);
> @@ -892,9 +896,9 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
>  	 * Handle the "start in power-off" case.
>  	 */
>  	if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
> -		vcpu->arch.power_off = true;
> +		set_bit(KVM_REQ_POWER_OFF, &vcpu->requests);
>  	else
> -		vcpu->arch.power_off = false;
> +		clear_bit(KVM_REQ_POWER_OFF, &vcpu->requests);
>  
>  	return 0;
>  }
> diff --git a/arch/arm/kvm/psci.c b/arch/arm/kvm/psci.c
> index 82fe7eb5b6a7..f732484abc7a 100644
> --- a/arch/arm/kvm/psci.c
> +++ b/arch/arm/kvm/psci.c
> @@ -64,7 +64,7 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
>  
>  static void kvm_psci_vcpu_off(struct kvm_vcpu *vcpu)
>  {
> -	vcpu->arch.power_off = true;
> +	set_bit(KVM_REQ_POWER_OFF, &vcpu->requests);
>  }
>  
>  static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> @@ -88,7 +88,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>  	 */
>  	if (!vcpu)
>  		return PSCI_RET_INVALID_PARAMS;
> -	if (!vcpu->arch.power_off) {
> +	if (!test_bit(KVM_REQ_POWER_OFF, &vcpu->requests)) {
>  		if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
>  			return PSCI_RET_ALREADY_ON;
>  		else
> @@ -116,8 +116,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>  	 * the general puspose registers are undefined upon CPU_ON.
>  	 */
>  	vcpu_set_reg(vcpu, 0, context_id);
> -	vcpu->arch.power_off = false;
> -	smp_mb();		/* Make sure the above is visible */
> +	clear_bit(KVM_REQ_POWER_OFF, &vcpu->requests);
>  
>  	wq = kvm_arch_vcpu_wq(vcpu);
>  	swake_up(wq);
> @@ -154,7 +153,7 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
>  		mpidr = kvm_vcpu_get_mpidr_aff(tmp);
>  		if ((mpidr & target_affinity_mask) == target_affinity) {
>  			matching_cpus++;
> -			if (!tmp->arch.power_off)
> +			if (!test_bit(KVM_REQ_POWER_OFF, &tmp->requests))
>  				return PSCI_0_2_AFFINITY_LEVEL_ON;
>  		}
>  	}
> @@ -167,9 +166,6 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
>  
>  static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type)
>  {
> -	int i;
> -	struct kvm_vcpu *tmp;
> -
>  	/*
>  	 * The KVM ABI specifies that a system event exit may call KVM_RUN
>  	 * again and may perform shutdown/reboot at a later time that when the
> @@ -179,10 +175,7 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type)
>  	 * after this call is handled and before the VCPUs have been
>  	 * re-initialized.
>  	 */
> -	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
> -		tmp->arch.power_off = true;
> -		kvm_vcpu_kick(tmp);
> -	}
> +	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_POWER_OFF);

certainly we want this part of the change in some form.

Thanks,
-Christoffer

>  
>  	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
>  	vcpu->run->system_event.type = type;
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 6e1271a77e92..e78895f675d0 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -43,6 +43,7 @@
>  #define KVM_VCPU_MAX_FEATURES 4
>  
>  #define KVM_REQ_PAUSE		8
> +#define KVM_REQ_POWER_OFF	9
>  
>  int __attribute_const__ kvm_target_cpu(void);
>  int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
> @@ -253,9 +254,6 @@ struct kvm_vcpu_arch {
>  		u32	mdscr_el1;
>  	} guest_debug_preserved;
>  
> -	/* vcpu power-off state */
> -	bool power_off;
> -
>  	/* IO related fields */
>  	struct kvm_decode mmio_decode;
>  
> -- 
> 2.9.3
> 
