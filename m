Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792516844;
	b=iJgE02ByF3NjRTtT0YMWs+GKLh6HipPbCZzXkTSxCLtLWrAfntImFwKfjhWCLnCBzmh0
	 t8FFq14bwEMQt3RZVXqVXzIXyVKciXiaSD8DfLehWeGzIegNbqZT3Kuhn5TUcB8jPNis5
	 HNDmVFQBPmRkmdzsKA4GygMBDGOEAPKMVfzaHkrpknUG/L2PoKt64LONZqLHKxjAgZ4/O
	 +Qc+nBUuoe61bY/L6fdKEy68fqHDGNk96jA0+RvZFuL6H+5U4MoEB50D+MLZIhJj3aRqb
	 sjVvNOHwFybRvqfJLdyJC96uNKmxSPaOBv82ex5wPVjjRvTNVSvM9mO44SnRb3+qAOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792516844;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=6WWk7zExmFICqSLgFYRdnOfnAX1UA+1LzUHxktArr0A=;
	b=J4kIxOv+RlXLLAs39rYOsI58kawPscGXp+TM7xe3CXIjm55LZDXBrxaIOuDwbQgDfbSs
	 l03j8fJCHy8/5dVys4KZqUbemJtwTUkYhhRQH/Cm+0R+UbJn/dY8F/mZzNStLsBnHxmpl
	 86QwBuwcrOvyY+cb542xd320D+2kjE5RXd0GxX5eQHHupJBUPPg4s2MsyP9FGBpRIu1y0
	 fzHVt7ye7uvA7x5Pwi3/4v6mwMOkMAXpiJIy0Q0cU7ybDD6oBPWR1xEbnRsfyT6B/4LcS
	 gl3SifcWYmy82WxOwEeTD0kyzCvR5vjmWYaiyw/WeshOQ3qyZydY3pPoISzrVeDEXHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KAny9+RY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAA9606A31A;
	Tue, 20 Oct 2026 17:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KAny9+RY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2D51F000C9;
	Tue, 20 Oct 2026 17:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792516844;
	bh=6WWk7zExmFICqSLgFYRdnOfnAX1UA+1LzUHxktArr0A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KAny9+RYL3Bjeb2mO44a1DmHjw5+oGJtZavst+KtM/yvA1XeMdgFf3bk6UL5KVh+P
	 1I8S6GaqWuXL8Un8uzuTijsxfTPN2YhPmtDXJNFntGZsRaXLO6wtVyd41QOtYOGfE3
	 DPTZSKa9l5SlKTfbLLVmDokn5amCYcHczoUjzfGt2L3Uyy37nkRW3J/FhkwA3HpxpG
	 aGmdXDp18uRFtMDOMDDhO12qmoLrthj/KgtRm3RlSyU6VmZBQP9KXQYj2NKwGS1cL5
	 p11g45R+3sO/Aeb4+glyJU+LCXXl9ZLUNj23hri92cY95iFyeu7QdrrZJpBX2srtW+
	 +6cYTtWtGJAOA==
Date: Tue, 20 Oct 2026 18:20:29 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org, Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [RFC PATCH v7 12/28] KVM: arm64: Add SPE VCPU device attribute
 to set the interrupt number
Message-ID: <ateEKZC3pjL6Sjrq@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-13-alexandru.elisei@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903160623.315525-13-alexandru.elisei@arm.com>

On Thu, Sep 03, 2026 at 05:06:07PM +0100, Alexandru Elisei wrote:
> From: Sudeep Holla <sudeep.holla@arm.com>
>
> Add KVM_ARM_VCPU_SPE_CTRL(KVM_ARM_VCPU_SPE_IRQ) to allow the user to set
> the interrupt number for the buffer management interrupt.

I know this is a bit of a theme of the review :P but feels a little short.

Be good to see why you want to do this, broadly what you are changing
(shouldn't duplicate stuff you can see from the diff but something like '

>
> [ Alexandru E: Split from "KVM: arm64: Add a new VCPU device control group
>                for SPE" ]
>
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

I guess similar comment to before - is this a significant change? If so
then probably best to go Co-developed-by route, otherwise not a big deal.

> ---
>  Documentation/virt/kvm/devices/vcpu.rst | 22 +++++++
>  arch/arm64/include/asm/kvm_host.h       |  2 +
>  arch/arm64/include/asm/kvm_spe.h        | 11 ++++
>  arch/arm64/include/uapi/asm/kvm.h       |  1 +
>  arch/arm64/kvm/guest.c                  |  2 +
>  arch/arm64/kvm/spe.c                    | 82 +++++++++++++++++++++++++
>  6 files changed, 120 insertions(+)
>
> diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> index e0a7fa35dfd2..d30b2f7fec9a 100644
> --- a/Documentation/virt/kvm/devices/vcpu.rst
> +++ b/Documentation/virt/kvm/devices/vcpu.rst
> @@ -307,3 +307,25 @@ From the destination VMM process:
>  ===============================
>
>  :Architectures: ARM64
> +
> +5.1 ATTRIBUTE: KVM_ARM_VCPU_SPE_IRQ
> +-----------------------------------
> +
> +:Parameters: in kvm_device_attr.addr the address for the Profiling Buffer
> +             management interrupt number as a pointer to an int
> +
> +Returns:

Was going to say maybe it should be ':Returns:' but actually the doc seems
super inconsistent on this... :P so it doesn't really matter.

> +
> +	 =======  ==========================================================
> +	 -EFAULT  Error accessing the buffer management interrupt number
> +	 -EINVAL  Invalid interrupt number or not using an in-kernel irqchip
> +	 -ENODEV  KVM_ARM_VCPU_HAS_SPE VCPU feature not set

Seems like a typo, should be KVM_ARM_VCPU_SPE_IRQ right?

> +	 -ENXIO   SPE not supported or not properly configured
> +	 =======  ==========================================================
> +
> +Required.
> +
> +Specifies the Profiling Buffer management interrupt number. The interrupt number
> +must be a PPI and the interrupt number must be the same for each VCPU. Arm
> +recommends 21 as the interrupt number. SPE virtualization requires an in-kernel
> +vGIC implementation.
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 27fe0cd5b2d7..e7332bd82bf3 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -27,6 +27,7 @@
>  #include <asm/fpsimd.h>
>  #include <asm/kvm.h>
>  #include <asm/kvm_asm.h>
> +#include <asm/kvm_spe.h>
>  #include <asm/vncr_mapping.h>
>
>  #define __KVM_HAVE_ARCH_INTC_INITIALIZED
> @@ -918,6 +919,7 @@ struct kvm_vcpu_arch {
>  	struct vgic_cpu vgic_cpu;
>  	struct arch_timer_cpu timer_cpu;
>  	struct kvm_pmu pmu;
> +	struct kvm_vcpu_spe vcpu_spe;
>
>  	/* vcpu power state */
>  	struct kvm_mp_state mp_state;
> diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
> index 1327064d0984..8ded2d821bff 100644
> --- a/arch/arm64/include/asm/kvm_spe.h
> +++ b/arch/arm64/include/asm/kvm_spe.h
> @@ -6,7 +6,15 @@
>  #ifndef __ARM64_KVM_SPE_H__
>  #define __ARM64_KVM_SPE_H__
>
> +struct kvm;
> +struct kvm_vcpu;
> +struct kvm_device_attr;
> +
>  #ifdef CONFIG_KVM_ARM_SPE
> +struct kvm_vcpu_spe {
> +	int irq_num;		/* Buffer management interrupt number */
> +};

I guess this struct will be expanded over time?

> +
>  bool kvm_supports_spe(void);
>
>  #define vcpu_has_spe(vcpu)					\
> @@ -16,6 +24,9 @@ int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>  int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>  int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>  #else

NIT, and probably applicable to a previous patch, but useful to put /*
CONFIG_KVM_ARM_SPE */ there, certainly useful as things grow.

> +struct kvm_vcpu_spe {
> +};
> +

OK good this covers off the !CONFIG_KVM_ARM_SPE case.

>  static __always_inline bool kvm_supports_spe(void)
>  {
>  	return false;
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index e8a68e34be63..b9e5019181eb 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -447,6 +447,7 @@ enum {
>  #define KVM_ARM_VCPU_PVTIME_CTRL	2
>  #define   KVM_ARM_VCPU_PVTIME_IPA	0
>  #define KVM_ARM_VCPU_SPE_CTRL		3
> +#define   KVM_ARM_VCPU_SPE_IRQ		0
>
>  /* KVM_IRQ_LINE irq field index values */
>  #define KVM_ARM_IRQ_VCPU2_SHIFT		28
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 56c5f937fcdb..f953b235b458 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -920,7 +920,9 @@ int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
>  		ret = kvm_arm_pvtime_set_attr(vcpu, attr);
>  		break;
>  	case KVM_ARM_VCPU_SPE_CTRL:
> +		mutex_lock(&vcpu->kvm->arch.config_lock);
>  		ret = kvm_spe_set_attr(vcpu, attr);
> +		mutex_unlock(&vcpu->kvm->arch.config_lock);
>  		break;
>  	default:
>  		ret = -ENXIO;
> diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> index fe45ad4c703a..dd5f80318ba4 100644
> --- a/arch/arm64/kvm/spe.c
> +++ b/arch/arm64/kvm/spe.c
> @@ -59,17 +59,99 @@ bool kvm_supports_spe(void)
>  	return !list_empty(&spe_pmus);
>  }
>
> +static bool kvm_spe_irq_is_valid(struct kvm *kvm, int irq)
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vcpu_spe *vcpu_spe;
> +	unsigned long i;
> +

Maybe worth a small comment:

	/* Every vCPU must have either the same or no IRQ set. */

> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		vcpu_spe = &vcpu->arch.vcpu_spe;
> +
> +		if (!vcpu_spe->irq_num)
> +			continue;
> +
> +		if (vcpu_spe->irq_num != irq)
> +			return false;
> +	}
> +
> +	return true;
> +}
> +

>  int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  {
> +	struct kvm_vcpu_spe *vcpu_spe = &vcpu->arch.vcpu_spe;
> +	struct kvm *kvm = vcpu->kvm;
> +
> +	lockdep_assert_held(&kvm->arch.config_lock);
> +
> +	if (!vcpu_has_spe(vcpu))
> +		return -ENODEV;
> +
> +	switch (attr->attr) {
> +	case KVM_ARM_VCPU_SPE_IRQ: {
> +		int __user *uaddr = (int __user *)(long)attr->addr;
> +		int irq;
> +
> +		if (!irqchip_in_kernel(kvm))
> +			return -EINVAL;
> +
> +		if (get_user(irq, uaddr))
> +			return -EFAULT;
> +
> +		if (!irq_is_ppi(kvm, irq))
> +			return -EINVAL;
> +
> +		if (!kvm_spe_irq_is_valid(kvm, irq))
> +			return -EINVAL;

What about changing the IRQ for vcpu? kvm_spe_irq_is_valid() will abort
even if only the current vCPU has an IRQ set.

Also what about the case of setting the current vCPU's IRQ to the same
value? Should that be -EBUSY?

PMU seems to do something like that, so maybe worth doing that for
consistency? Not exactly a huge thing, that though!

Also looking at PMU there's:

	/* On GICv5, the PMUIRQ is architecturally mandated to be PPI 23 */
	if (vgic_is_v5(kvm) && irq != KVM_ARMV8_PMU_GICV5_IRQ)
		return false;

Is that something you have to worry about for SPE?


> +
> +		vcpu_spe->irq_num = irq;
> +		return 0;
> +	}
> +	}
> +
>  	return -ENXIO;
>  }
>
>  int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  {
> +	struct kvm_vcpu_spe *vcpu_spe = &vcpu->arch.vcpu_spe;
> +	struct kvm *kvm = vcpu->kvm;
> +
> +	if (!vcpu_has_spe(vcpu))
> +		return -ENODEV;
> +
> +	switch (attr->attr) {
> +	case KVM_ARM_VCPU_SPE_IRQ: {
> +		int __user *uaddr = (int __user *)(long)attr->addr;
> +		int irq;
> +
> +		if (!irqchip_in_kernel(kvm))
> +			return -EINVAL;
> +
> +		if (!vcpu_spe->irq_num)
> +			return -ENXIO;
> +
> +		irq = vcpu_spe->irq_num;
> +		if (put_user(irq, uaddr))
> +			return -EFAULT;
> +
> +		return 0;
> +	}
> +	}
> +
>  	return -ENXIO;
>  }
>
>  int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  {
> +	if (!vcpu_has_spe(vcpu))
> +		return -ENODEV;
> +
> +	switch(attr->attr) {
> +	case KVM_ARM_VCPU_SPE_IRQ:
> +		return 0;
> +	}
> +
>  	return -ENXIO;
>  }
> --
> 2.43.0
>
>

--
Cheers, Lorenzo
