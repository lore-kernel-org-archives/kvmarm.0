From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 10/20] KVM: arm/arm64: Move timer/vgic flush/sync under
 disabled irq
Date: Mon, 9 Oct 2017 18:34:45 +0100
Message-ID: <512939dd-1f04-f653-d069-e468936eeabb@arm.com>
References: <20170923004207.22356-1-cdall@linaro.org>
 <20170923004207.22356-11-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170923004207.22356-11-cdall@linaro.org>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 23/09/17 01:41, Christoffer Dall wrote:
> As we are about to play tricks with the timer to be more lazy in saving
> and restoring state, we need to move the timer sync and flush functions
> under a disabled irq section and since we have to flush the vgic state
> after the timer and PMU state, we do the whole flush/sync sequence with
> disabled irqs.
> 
> The only downside is a slightly longer delay before being able to
> process hardware interrupts and run softirqs.
> 
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> ---
>  virt/kvm/arm/arm.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index b9f68e4..27db222 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -654,11 +654,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  
>  		kvm_pmu_flush_hwstate(vcpu);
>  
> +		local_irq_disable();
> +
>  		kvm_timer_flush_hwstate(vcpu);
>  		kvm_vgic_flush_hwstate(vcpu);
>  
> -		local_irq_disable();
> -
>  		/*
>  		 * If we have a singal pending, or need to notify a userspace
>  		 * irqchip about timer or PMU level changes, then we exit (and
> @@ -683,10 +683,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
>  		    kvm_request_pending(vcpu)) {
>  			vcpu->mode = OUTSIDE_GUEST_MODE;
> -			local_irq_enable();
>  			kvm_pmu_sync_hwstate(vcpu);
>  			kvm_timer_sync_hwstate(vcpu);
>  			kvm_vgic_sync_hwstate(vcpu);
> +			local_irq_enable();
>  			preempt_enable();
>  			continue;
>  		}
> @@ -710,6 +710,16 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		kvm_arm_clear_debug(vcpu);
>  
>  		/*
> +		 * We must sync the PMU and timer state before the vgic state so
> +		 * that the vgic can properly sample the updated state of the
> +		 * interrupt line.
> +		 */
> +		kvm_pmu_sync_hwstate(vcpu);
> +		kvm_timer_sync_hwstate(vcpu);
> +
> +		kvm_vgic_sync_hwstate(vcpu);
> +
> +		/*
>  		 * We may have taken a host interrupt in HYP mode (ie
>  		 * while executing the guest). This interrupt is still
>  		 * pending, as we haven't serviced it yet!
> @@ -732,16 +742,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		guest_exit();
>  		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
>  
> -		/*
> -		 * We must sync the PMU and timer state before the vgic state so
> -		 * that the vgic can properly sample the updated state of the
> -		 * interrupt line.
> -		 */
> -		kvm_pmu_sync_hwstate(vcpu);
> -		kvm_timer_sync_hwstate(vcpu);
> -
> -		kvm_vgic_sync_hwstate(vcpu);
> -
>  		preempt_enable();
>  
>  		ret = handle_exit(vcpu, run, ret);
> 

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
