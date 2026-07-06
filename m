Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1989727A107;
	Mon,  6 Jul 2026 17:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360699; cv=none; b=krS2M0SGlNUmhImO+LLd2BnA2VmgxRLV+a2vPf7jTkk7pCCyXoChh+62t5j4HbV7HHKfAnbmoRLGPlLJJvqtWNggzdZHTHnNJk5j4JFgBSdTEUSA59Z9CBeEsXbAS5aqQ4c08oK8k9wu8KS2GoAlIbfAk3JnIkVGFssBNABfLKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360699; c=relaxed/simple;
	bh=h980sEF6MU4UaII9Q4INlvAIxaxOl7RRKHFGjT/8d/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W22BNX206mRsgB0w0rJOVe8211Z2Ta8KRtUCoIK2iZMlTXZD0MYu49HykUQqBVkikS7aHZv+QZ1Q/sVxK+KI+2bXf7ow6JKYiulgvqCJwfPoGFbZTdlu4SM/9UWglQvLcsCOb2yLT0VDUkVBx40lpLE4utKd+yH7X2/XwS9Oqt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l/EoXkqE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l/EoXkqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83771F000E9;
	Mon,  6 Jul 2026 17:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783360697;
	bh=Xfa02w+2R7v85UsHbfc8c8fBDDDTcGtnNT9og3+/x+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l/EoXkqEqLzf/RmDFKoleUlyWGN8jKQKxq88TU+k7AINCMlouqbeFvDNtMG1ujBD0
	 daO+DPr9pYbKdvKxoQu38X0ZYp1smDFej9Nm24s6FwslOX+7mIbZnPFTFajOX3N+Lx
	 uHvR+9g0G8rKkVBPNnzYKihpTCv8aP4sg0oR4ct0Xw7Oy7bpgmGTdHo24nyLjp+uTQ
	 SxzKfmEUvtM8MGXPQbAL4s27RmkpJ9I3v9p3/nrB1Ubo+h+TUiFVG27qZJcqGAvCI1
	 aKXOvLUS0HrAjs7XNVArgFq+aXnLaJEkr0mQZzY11Yfvlti/0vf1GKWx7Rh2OgdSmU
	 ui4UATs+PWTKA==
Date: Mon, 6 Jul 2026 10:58:16 -0700
From: Oliver Upton <oupton@kernel.org>
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v8 6/7] KVM: arm64: PMU: Introduce FIXED_COUNTERS_ONLY
Message-ID: <akvsuBcqCCzlrBLk@kernel.org>
References: <20260706-hybrid-v8-0-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
 <20260706-hybrid-v8-6-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260706-hybrid-v8-6-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>

On Mon, Jul 06, 2026 at 07:03:29PM +0900, Akihiko Odaki wrote:
> +1.6 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY
> +------------------------------------------------------
> +
> +:Parameters: no additional parameter in kvm_device_attr.addr
> +
> +:Returns:
> +
> +	 =======  ==================================================
> +	 -EBUSY   PMUv3 already initialized, a VCPU has already run,
> +		  an event filter has already been set or
> +		  a hardware PMU has already been specified
> +	 -ENXIO   Attempted to get before setting
> +	 -ENODEV  Attempted to set while PMUv3 not supported
> +	 =======  ==================================================
> +
> +If set, KVM emulates PMUv3 without programmable event counters. Only fixed
> +counters are exposed to the guest: the cycle counter today, and the instruction
> +counter if support for FEAT_PMUv3_ICNTR is added.

Drop the mention of cycle counter and FEAT_PMUv3_ICNTR, I want to avoid
the argument later down the line when ICNTR support is added to this
mode.

The expectation is that the VMM discovers the feature set using the ID
registers just like every other CPU feature. KVM documentation doesn't
need to describe the architecture.

> +With programmable counters disabled, the VCPU can run on any physical CPU.
> +This is particularly useful on heterogeneous systems where different hardware
> +PMUs cover different physical CPUs. All VCPUs in a VM share this attribute.

  When this attribute is enabled, the vCPU can run on any physical CPU
  that has a PMU, regardless of the underlying implementation. This
  attribute is VM-scoped.

The documentation is focused on unambiguously representing the UAPI, not
providing application recommendations.

>  2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
>  =================================
>  
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 1c13bfa2d38a..39a1a1e412e6 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -437,6 +437,7 @@ enum {
>  #define   KVM_ARM_VCPU_PMU_V3_FILTER		2
>  #define   KVM_ARM_VCPU_PMU_V3_SET_PMU		3
>  #define   KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS	4
> +#define   KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY	5
>  #define KVM_ARM_VCPU_TIMER_CTRL		1
>  #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
>  #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 40cad183376c..ad9ff4d0d89c 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -1149,11 +1149,13 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
>  		arm_pmu = entry->arm_pmu;
>  		if (arm_pmu->pmu.type == pmu_id) {
>  			if (kvm_vm_has_ran_once(kvm) ||
> +			    kvm_pmu_fixed_counters_only(kvm) ||
>  			    (kvm->arch.pmu_filter && kvm->arch.arm_pmu != arm_pmu)) {
>  				ret = -EBUSY;
>  				break;
>  			}
>  
> +			set_bit(KVM_ARCH_FLAG_PMU_V3_EXPLICIT, &kvm->arch.flags);

Why is this flag necessary? kvm->arch.arm_pmu is NULL if no PMU
implementation was selected by userspace.

>  			kvm_arm_set_pmu(kvm, arm_pmu);
>  			cpumask_copy(kvm->arch.supported_cpus, &arm_pmu->supported_cpus);
>  			ret = 0;
> @@ -1164,6 +1166,22 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
>  	return ret;
>  }
>  
> +static int kvm_arm_pmu_v3_set_pmu_fixed_counters_only(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +
> +	lockdep_assert_held(&kvm->arch.config_lock);
> +
> +	if (kvm_vm_has_ran_once(kvm) || kvm->arch.pmu_filter ||
> +	    test_bit(KVM_ARCH_FLAG_PMU_V3_EXPLICIT, &kvm->arch.flags))
> +		return -EBUSY;
> +
> +	set_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &kvm->arch.flags);
> +	kvm_arm_set_nr_counters(kvm, 0);
> +
> +	return 0;
> +}
> +
>  static int kvm_arm_pmu_v3_set_nr_counters(struct kvm_vcpu *vcpu, unsigned int n)
>  {
>  	struct kvm *kvm = vcpu->kvm;
> @@ -1238,7 +1256,7 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  		     filter.action != KVM_PMU_EVENT_DENY))
>  			return -EINVAL;
>  
> -		if (kvm_vm_has_ran_once(kvm))
> +		if (kvm_vm_has_ran_once(kvm) || kvm_pmu_fixed_counters_only(kvm))

There's no reason for doing this, just let userspace create an event
filter. Even with the current PMU implementation it's possible that the
fixed cycle counter gets filtered.

Thanks,
Oliver
