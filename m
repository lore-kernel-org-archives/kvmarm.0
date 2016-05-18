From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 50/56] KVM: arm/arm64: vgic-new: vgic_init: implement
 vgic_create
Date: Wed, 18 May 2016 16:11:44 +0200
Message-ID: <20160518141144.GS3827@cbox>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
 <1463392481-26583-51-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1463392481-26583-51-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, May 16, 2016 at 10:53:38AM +0100, Andre Przywara wrote:
> From: Eric Auger <eric.auger@linaro.org>
> 
> This patch implements the vgic_creation function which is
> called on CREATE_IRQCHIP VM IOCTL (v2 only) or KVM_CREATE_DEVICE
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Changelog v3 .. v4:
> - fix comment
> 
>  include/kvm/vgic/vgic.h       |  1 +
>  virt/kvm/arm/vgic/vgic-init.c | 84 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 85 insertions(+)
> 
> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
> index 393489f..0634d89 100644
> --- a/include/kvm/vgic/vgic.h
> +++ b/include/kvm/vgic/vgic.h
> @@ -195,6 +195,7 @@ struct vgic_cpu {
>  };
>  
>  int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
> +int kvm_vgic_create(struct kvm *kvm, u32 type);
>  int kvm_vgic_hyp_init(void);
>  
>  int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index 4523beb..15d5428 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -22,6 +22,90 @@
>  #include <asm/kvm_mmu.h>
>  #include "vgic.h"
>  
> +/* CREATION */
> +
> +/**
> + * kvm_vgic_create: triggered by the instantiation of the VGIC device by
> + * user space, either through the legacy KVM_CREATE_IRQCHIP ioctl (v2 only)
> + * or through the generic KVM_CREATE_DEVICE API ioctl.
> + * irqchip_in_kernel() tells you if this function succeeded or not.
> + */
> +int kvm_vgic_create(struct kvm *kvm, u32 type)
> +{
> +	int i, vcpu_lock_idx = -1, ret;
> +	struct kvm_vcpu *vcpu;
> +
> +	mutex_lock(&kvm->lock);
> +
> +	if (irqchip_in_kernel(kvm)) {
> +		ret = -EEXIST;
> +		goto out;
> +	}
> +
> +	/*
> +	 * This function is also called by the KVM_CREATE_IRQCHIP handler,
> +	 * which had no chance yet to check the availability of the GICv2
> +	 * emulation. So check this here again. KVM_CREATE_DEVICE does
> +	 * the proper checks already.
> +	 */
> +	if (type == KVM_DEV_TYPE_ARM_VGIC_V2 &&
> +		!kvm_vgic_global_state.can_emulate_gicv2) {
> +		ret = -ENODEV;
> +		goto out;
> +	}
> +
> +	/*
> +	 * Any time a vcpu is run, vcpu_load is called which tries to grab the
> +	 * vcpu->mutex.  By grabbing the vcpu->mutex of all VCPUs we ensure
> +	 * that no other VCPUs are run while we create the vgic.
> +	 */
> +	ret = -EBUSY;
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		if (!mutex_trylock(&vcpu->mutex))
> +			goto out_unlock;
> +		vcpu_lock_idx = i;
> +	}
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		if (vcpu->arch.has_run_once)
> +			goto out_unlock;
> +	}
> +	ret = 0;
> +
> +	if (type == KVM_DEV_TYPE_ARM_VGIC_V2)
> +		kvm->arch.max_vcpus = VGIC_V2_MAX_CPUS;
> +	else
> +		kvm->arch.max_vcpus = VGIC_V3_MAX_CPUS;
> +
> +	if (atomic_read(&kvm->online_vcpus) > kvm->arch.max_vcpus) {
> +		ret = -E2BIG;
> +		goto out_unlock;
> +	}
> +
> +	kvm->arch.vgic.in_kernel = true;
> +	kvm->arch.vgic.vgic_model = type;
> +
> +	/*
> +	 * kvm_vgic_global_state.vctrl_base is set on vgic probe (kvm_arch_init)
> +	 * it is stored in distributor struct for asm save/restore purpose
> +	 */
> +	kvm->arch.vgic.vctrl_base = kvm_vgic_global_state.vctrl_base;

I had some bit about the S/R code not being assembly anymore, so we
should get rid of the 'asm' part of the comment, but if reworking this
to be global state is too messy at this point, I'm ok with leaving this
as a fix for later.

So, for the remaining part:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> +
> +	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
> +	kvm->arch.vgic.vgic_cpu_base = VGIC_ADDR_UNDEF;
> +	kvm->arch.vgic.vgic_redist_base = VGIC_ADDR_UNDEF;
> +
> +out_unlock:
> +	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
> +		vcpu = kvm_get_vcpu(kvm, vcpu_lock_idx);
> +		mutex_unlock(&vcpu->mutex);
> +	}
> +
> +out:
> +	mutex_unlock(&kvm->lock);
> +	return ret;
> +}
> +
>  /* GENERIC PROBE */
>  
>  static void vgic_init_maintenance_interrupt(void *info)
> -- 
> 2.8.2
> 
