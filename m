Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A2D233A9DD
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 15:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767711979; cv=none; b=EnMtKIo/9FqdMrlE4u5W7FkuJUXQ9EWBUR2c62qE+Udwe2QWEkuCdmJzwtw/KQ4iDPt+eiYCGxXPyrRa7EeIJH5GpvdW/QCFQp53QMV6jxcac0C4RCexKLQvM9+hiJmx1SD7PtifF6vWxN6apnH7bO3ky9g1uVVngDDB8yYXotY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767711979; c=relaxed/simple;
	bh=zUzbDaAUWKW1REAiG6IUFo1KPQJfq7xHWWl2saQmulA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=riM/feBlQx/GKAtCCzv6xw1IJck0biOK8+5iHAg2vTuTj7s7CVcbzmqUYA1v+FA4tM7lwrXWzDc+4nlk8LqnAr50D0Ck+4VAU9tflYau5JPPyQvRO5+6a+c1FAEUzjqsf1/OrSLtxCQdBBt4l6PvmOxrYBGY96bwPDIRkijM8As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C7304497;
	Tue,  6 Jan 2026 07:06:09 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C9B7A3F5A1;
	Tue,  6 Jan 2026 07:06:14 -0800 (PST)
Date: Tue, 6 Jan 2026 15:06:12 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: Re: [PATCH v2 27/36] KVM: arm64: gic-v5: Mandate architected PPI for
 PMU emulation on GICv5
Message-ID: <20260106150612.GB1982@e124191.cambridge.arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
 <20251219155222.1383109-28-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219155222.1383109-28-sascha.bischoff@arm.com>

Question,

On Fri, Dec 19, 2025 at 03:52:45PM +0000, Sascha Bischoff wrote:
> Make it mandatory to use the architected PPI when running a GICv5
> guest. Attempts to set anything other than the architected PPI (23)
> are rejected.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arch/arm64/kvm/pmu-emul.c | 14 ++++++++++++--
>  include/kvm/arm_pmu.h     |  5 ++++-
>  2 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index afc838ea2503e..2d3b50dec6c5d 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -962,8 +962,13 @@ static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
>  		if (!vgic_initialized(vcpu->kvm))
>  			return -ENODEV;
>  
> -		if (!kvm_arm_pmu_irq_initialized(vcpu))
> -			return -ENXIO;
> +		if (!kvm_arm_pmu_irq_initialized(vcpu)) {
> +			/* Use the architected irq number for GICv5. */
> +			if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V5)
> +				vcpu->arch.pmu.irq_num = KVM_ARMV8_PMU_GICV5_IRQ;
> +			else
> +				return -ENXIO;
> +		}

This relaxes the KVM_ARM_VCPU_PMU_V3_INIT uAPI to not need
KVM_ARM_VCPU_PMU_V3_IRQ to be called first for gic-v5, right?

Maybe that's intentional, but it should be mentioned in the commit and maybe
even in the docs (Documentation/virt/kvm/devices/vcpu.rst)?

Thanks,
Joey

>  
>  		ret = kvm_vgic_set_owner(vcpu, vcpu->arch.pmu.irq_num,
>  					 &vcpu->arch.pmu);
> @@ -988,6 +993,11 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
>  	unsigned long i;
>  	struct kvm_vcpu *vcpu;
>  
> +	/* On GICv5, the PMUIRQ is architecturally mandated to be PPI 23 */
> +	if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V5 &&
> +	    irq != KVM_ARMV8_PMU_GICV5_IRQ)
> +		return false;
> +
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
>  		if (!kvm_arm_pmu_irq_initialized(vcpu))
>  			continue;
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 96754b51b4116..0a36a3d5c8944 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -12,6 +12,9 @@
>  
>  #define KVM_ARMV8_PMU_MAX_COUNTERS	32
>  
> +/* PPI #23 - architecturally specified for GICv5 */
> +#define KVM_ARMV8_PMU_GICV5_IRQ		0x20000017
> +
>  #if IS_ENABLED(CONFIG_HW_PERF_EVENTS) && IS_ENABLED(CONFIG_KVM)
>  struct kvm_pmc {
>  	u8 idx;	/* index into the pmu->pmc array */
> @@ -38,7 +41,7 @@ struct arm_pmu_entry {
>  };
>  
>  bool kvm_supports_guest_pmuv3(void);
> -#define kvm_arm_pmu_irq_initialized(v)	((v)->arch.pmu.irq_num >= VGIC_NR_SGIS)
> +#define kvm_arm_pmu_irq_initialized(v)	((v)->arch.pmu.irq_num != 0)
>  u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
>  void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val);
>  void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu, u64 select_idx, u64 val);
> -- 
> 2.34.1
