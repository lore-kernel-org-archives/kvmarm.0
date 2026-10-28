Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793195112;
	b=AYKrYY53SIiX+/BqIm7OZBdYid6tPBNQ1X4agoyyU0wwI2A7UKvf7r3szRhQg8i0IMkY
	 yfh6P6DVjnbJon+c5UGxsgd6XKTPj5Tz0IJdsWdzVpqjeeXta5WQBJcbleh3HDet/VH0o
	 v3Y16eqLbPIm/kX79xOPQrQLERi0sF34C8eO9//wBeuqC1rIdCwVNY4UYXJoG65sSo+ca
	 wa0eoXv1SrxQM+fnboPblCP+EJWf50FKby3AZNuLv+QwCaWb3uF5ziCM8QZHP+m0K87hQ
	 Z/3Y36EVtphP4RXtcwjG3MZkX8+Yaqa1j8Pusf8JoqSuzCNus5jVLBYz4q0Q9V6XPEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793195112;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=yURS2hXuvzV92pMc05dUU/QQG9YV7RclfziXU/y0sU8=;
	b=Q4qtkq1eaXY3RAHMqgHPc2+WuSM7pQcGjDLB4PHXG2OmBD/EAjeBHzOMDPGLa4TD41p/
	 J20vqfl3mZCywDtH+/BbpINBR1uUnWfgUOZlCjJgsrueC7yC7okwUHSirnLzZQKaI7kBB
	 zH5/Ygvo2knuNW6+983s+0fUC9oH2j9pL1aKi/jY4HJe2k/10LIJa/+UyKrVUBJxv2kEi
	 HNA0oEhbvUGTVZw3uIaj0JMbtNcQaFyErk5Id0loiblbU2oJoS2bmaQYF+AmKjzNsemub
	 TWIIflne+hPYCHUqUna0ER3ckXpxZkIu0WbiClYzQzEYPQ5H+s/rvg6gCxEMawTt4Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NcM0ThU6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C8E606A321;
	Wed, 28 Oct 2026 13:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NcM0ThU6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B2B1F01825;
	Wed, 28 Oct 2026 13:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793195111;
	bh=yURS2hXuvzV92pMc05dUU/QQG9YV7RclfziXU/y0sU8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NcM0ThU63PoKJPDTxUWSqpakP0z87uWj9w/igy4q3OJBPPYedRf72ofmtVj4w1NIO
	 bt7xxrI7T3En4XLPFoKOuC4U8VYH2JyVhBTNqOIneRcv5KhVUmKoDkLhnMWuYL03pD
	 xMCFeYgs2t5WPEQrD3AHxteJA5+Sp88nP2Zlxgg4aaZcoaQj+MOORI8+lAGNzexLoJ
	 jcumZWTCzlmhhuar3cJpwPRglgqdVEyUNL6QcWyayIM9BamWQfu+v7MKX9t11YV/KR
	 WUCJFWYMSZk2WGmIBE2Qiak17nKgsWKe2rbXorUYUWJMG9PMJ2Zd+u8J+adfuPLMVp
	 LDJmVB7ZOCmUw==
Date: Wed, 28 Oct 2026 13:45:05 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org, Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [RFC PATCH v7 14/28] KVM: arm64: Add SPE VCPU device attribute
 to initialize SPE
Message-ID: <auH00DS9sS-eKZoR@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-15-alexandru.elisei@arm.com>
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
In-Reply-To: <20260903160623.315525-15-alexandru.elisei@arm.com>

On Thu, Sep 03, 2026 at 05:06:09PM +0100, Alexandru Elisei wrote:
> Add KVM_ARM_VCPU_SPE_CTRL(KVM_ARM_VCPU_SPE_INIT) VCPU ioctl to initialize
> SPE. Initialization must be done exactly once for each VCPU.

Again be good to have a little more in the commit message.

>
> [ Alexandru E: Split from "KVM: arm64: Add a new VCPU device control group
> 	   for SPE" ]
>
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  Documentation/virt/kvm/devices/vcpu.rst | 28 ++++++++++++++++++++---
>  arch/arm64/include/asm/kvm_spe.h        |  6 +++++
>  arch/arm64/include/uapi/asm/kvm.h       |  1 +
>  arch/arm64/kvm/arm.c                    |  6 +++++
>  arch/arm64/kvm/spe.c                    | 30 +++++++++++++++++++++++++
>  5 files changed, 68 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> index d60dd1daa67f..e2eac48b9d28 100644
> --- a/Documentation/virt/kvm/devices/vcpu.rst
> +++ b/Documentation/virt/kvm/devices/vcpu.rst
> @@ -317,6 +317,7 @@ From the destination VMM process:
>  Returns:
>
>  	 =======  ==========================================================
> +	 -EBUSY   SPE already initialized
>  	 -EFAULT  Error accessing the buffer management interrupt number
>  	 -EINVAL  Invalid interrupt number or not using an in-kernel irqchip
>  	 -ENODEV  KVM_ARM_VCPU_HAS_SPE VCPU feature not set
> @@ -338,15 +339,15 @@ vGIC implementation.
>
>  :Returns:

Just highlighting again the very nitty point about consistency between
'Returns:' and ':Returns:' :P.

>
> -	 =======  =========================================================
> -	 -EBUSY   Virtual machine has already run
> +	 =======  ===========================================================
> +	 -EBUSY   Virtual machine has already run, or SPE already initialized
>  	 -EFAULT  Error accessing the SPE identifier
>  	 -EINVAL  A different SPE instance already assigned, or no physical
>                    CPUs found
>  	 -ENXIO   SPE not supported or not properly configured, or the SPE
>                    module not loaded
>  	 -ENODEV  KVM_ARM_VCPU_HAS_SPE VCPU feature not set
> -	 =======  =========================================================
> +	 =======  ===========================================================
>
>  Required.
>
> @@ -361,3 +362,24 @@ responsible for making sure that the VCPU is run only on physical CPUs which
>  share the specified SPE instance. If the VCPU has a PMU assigned, and there are
>  no physical CPUs which share the same SPE and PMU instance, an error is
>  returned.
> +
> +5.3 ATTRIBUTE: KVM_ARM_VCPU_SPE_INIT
> +-----------------------------------

This underline looks short?

> +
> +:Parameters: no additional parameter in kvm_device_attr.addr
> +
> +Returns:
> +
> +	 =======  ============================================
> +	 -EBUSY   SPE already initialized for this VCPU
> +	 -ENXIO   SPE not supported or not properly configured
> +	 =======  ============================================
> +
> +Required.
> +
> +Request initialization of the Statistical Profiling Extension for this VCPU.
> +Must be done last, after SPE has been fully configured for the VCPU, and after
> +the in-kernel irqchip has been initialized.
> +
> +KVM will refuse to run the VCPU and KVM_RUN will return an error if the SPE
> +feature has been set for the VCPU, but SPE hasn't been initialized.
> diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
> index b8afb419c851..a6999709b298 100644
> --- a/arch/arm64/include/asm/kvm_spe.h
> +++ b/arch/arm64/include/asm/kvm_spe.h
> @@ -18,6 +18,7 @@ struct kvm_spe {
>
>  struct kvm_vcpu_spe {
>  	int irq_num;		/* Buffer management interrupt number */
> +	bool initialized;	/* SPE initialized for the VCPU */
>  };
>
>  bool kvm_supports_spe(void);
> @@ -25,6 +26,7 @@ bool kvm_supports_spe(void);
>  #define vcpu_has_spe(vcpu)					\
>  	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_SPE))
>
> +int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu);
>  void kvm_spe_destroy_vm(struct kvm *kvm);
>
>  int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
> @@ -46,6 +48,10 @@ static __always_inline bool kvm_supports_spe(void)
>
>  #define vcpu_has_spe(vcpu)	false
>
> +static inline int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
> +{
> +	return 0;
> +}
>  static inline void kvm_spe_destroy_vm(struct kvm *kvm)
>  {
>  }
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 8ffa3e89d38c..c695aae484d3 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -449,6 +449,7 @@ enum {
>  #define KVM_ARM_VCPU_SPE_CTRL		3
>  #define   KVM_ARM_VCPU_SPE_IRQ		0
>  #define   KVM_ARM_VCPU_SPE_ID		1
> +#define   KVM_ARM_VCPU_SPE_INIT		2
>
>  /* KVM_IRQ_LINE irq field index values */
>  #define KVM_ARM_IRQ_VCPU2_SHIFT		28
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 132df44c3088..c9a026c61ce7 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1026,6 +1026,12 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
>  			return ret;
>  	}
>
> +	if (vcpu_has_spe(vcpu)) {
> +		ret = kvm_spe_vcpu_first_run_init(vcpu);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	ret = vgic_v5_finalize_ppi_state(kvm);
>  	if (ret)
>  		return ret;
> diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> index 87fcdbbcbd67..fa87d224c8af 100644
> --- a/arch/arm64/kvm/spe.c
> +++ b/arch/arm64/kvm/spe.c
> @@ -59,6 +59,16 @@ bool kvm_supports_spe(void)
>  	return !list_empty(&spe_pmus);
>  }
>
> +int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)

This isn't initialising anything, I guess you plan to build it up over patches
but maybe worth mentioning that in the commit msg?


> +{
> +	struct kvm_vcpu_spe *vcpu_spe = &vcpu->arch.vcpu_spe;
> +
> +	if (!vcpu_spe->initialized)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
>  void kvm_spe_destroy_vm(struct kvm *kvm)
>  {
>  	struct arm_spe_pmu *spe_pmu;
> @@ -147,12 +157,16 @@ int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  {
>  	struct kvm_vcpu_spe *vcpu_spe = &vcpu->arch.vcpu_spe;
>  	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_spe *kvm_spe = &kvm->arch.kvm_spe;
>
>  	lockdep_assert_held(&kvm->arch.config_lock);
>
>  	if (!vcpu_has_spe(vcpu))
>  		return -ENODEV;
>
> +	if (vcpu_spe->initialized)
> +		return -EBUSY;
> +
>  	switch (attr->attr) {
>  	case KVM_ARM_VCPU_SPE_IRQ: {
>  		int __user *uaddr = (int __user *)(long)attr->addr;
> @@ -182,6 +196,21 @@ int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>
>  		return kvm_spe_set_spe_id(vcpu, spe_id);
>  	}
> +	case KVM_ARM_VCPU_SPE_INIT:
> +		if (!vcpu_spe->irq_num)
> +			return -ENXIO;
> +
> +		if (!kvm_spe->spe_pmu)
> +			return -ENXIO;
> +
> +		if (!vgic_initialized(kvm))
> +			return -ENXIO;

PMU returns -ENODEV in this case (+ documents it), worth keeping consistent with
that?

E.g.:

	1.2 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_INIT
	...
	 -ENODEV  PMUv3 not supported or GIC not initialized

> +
> +		if (kvm_vgic_set_owner(vcpu, vcpu_spe->irq_num, vcpu_spe))

This is getting an error then replacing it with -ENXIO, so probably better as:

	int err;
	...
	err = kvm_vgic_set_owner(vcpu, vcpu_spe->irq_num, vcpu_spe);
	if (err)
		return err;

> +			return -ENXIO;
> +
> +		vcpu_spe->initialized = true;
> +		return 0;
>  	}
>
>  	return -ENXIO;
> @@ -240,6 +269,7 @@ int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  	switch(attr->attr) {
>  	case KVM_ARM_VCPU_SPE_IRQ:
>  	case KVM_ARM_VCPU_SPE_ID:
> +	case KVM_ARM_VCPU_SPE_INIT:
>  		return 0;
>  	}
>
> --
> 2.43.0
>
>

--
Cheers, Lorenzo
