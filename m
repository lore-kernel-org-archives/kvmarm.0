Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E104F4FD78C;
	Tue, 22 Sep 2026 07:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790061108; cv=none; b=I1u/EcjojbPcXx3O9pkkeaPqfxFH78+bXQmrMhGH7cCIPJIp4ay4Wta+QNgOP7h8pvpcGy2KYLigbWtp3jp+HNGIrGodSi+bw84ehZzFa/tGa1L6ew0ibmyNyTaYffA28nID8OpdRuRRTsf1xX53MbWw/u7gJVZEQRSAaO73qJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790061108; c=relaxed/simple;
	bh=yPiXXWI+hAFjLv0PMpHnzjXO7hwE+RuJHXZnmqx/Wh8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nOtwdHr8xl3TEADgUgClknBZ6eLfz/QO9LEjMxaPee/4Hfza9UdYVG/caVX+FpTxJSAbDic2fvjl1tUQfS2YRmCpQ2CXzKA2Il30M6txHdADEVLSoI3hYFpq+Te0uYp+LET1aDy7OUz1P7HWYF8P3w41LBX1ev9CaPaxfGKH82A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MgrBn9UP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MgrBn9UP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098311F000FF;
	Tue, 22 Sep 2026 07:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790061106;
	bh=4KLMG7LWk0+A+uvrmJ78op/X5X6IpAwrk4iXchNk6nE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MgrBn9UPljxQNdik8LXXL9muQ9ay4WcJ6YzghmIufSEbC5kd8VyZKOmmJB7A1fKW6
	 1Ia05SBqETsNvSzREePrYvOaaVm9JvJIvg2gmYGbiGtnj47/TTCQfCME3NyoBUSwyT
	 ocjy7FjMuGZW7m9QaJ5S7PZHQEmqaJCoOIE6frn5ASMwiKQ9Zi7Z7I9tm447J+tjPG
	 pezZ8LhNow7r3/L7gJLlfQ6F7ND79e+UAkUEbeAdbIb6k9bgt3bQc8t7uP9UVJ0Ui4
	 wAk7WEWVyBYMNms7yUshQ9o4EVuS8hVA4Fz4My3yTtaT5iKatoietEWtIfpykt2QHh
	 mlBErA/VcUG2Q==
Date: Tue, 22 Sep 2026 00:11:44 -0700
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
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Andrew Jones <andrew.jones@oss.qualcomm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Mark Rutland <mark.rutland@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Shannon Zhao <shannon.zhao@linaro.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v11 20/21] KVM: arm64: PMU: Introduce FIXED_COUNTERS_ONLY
Message-ID: <arIqMO-f8X0gCzjA@kernel.org>
References: <20260920-hybrid-v11-0-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>
 <20260920-hybrid-v11-20-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260920-hybrid-v11-20-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>

On Sun, Sep 20, 2026 at 08:16:01PM +0900, Akihiko Odaki wrote:
> Introduce the KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY attribute to
> create a "fixed-counters-only" PMU.
> 
> Much like KVM_ARM_VCPU_PMU_V3_IRQ and other read-write attributes, this
> attribute provides a getter that facilitates kernel and userspace
> debugging/testing.
> 
> Allow strict PMUv3 vCPUs to initialize the PMU after selecting
> fixed-counters-only mode, without selecting a VM-wide hardware PMU.
> 
> Assisted-by: Codex:gpt-5.6-sol
> Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
> ---
>  Documentation/virt/kvm/api.rst          |  8 +++++--
>  Documentation/virt/kvm/devices/vcpu.rst | 42 ++++++++++++++++++++++++++-------
>  arch/arm64/include/uapi/asm/kvm.h       |  1 +
>  arch/arm64/kvm/pmu-emul.c               | 34 ++++++++++++++++++++++----
>  tools/arch/arm64/include/uapi/asm/kvm.h |  1 +
>  5 files changed, 71 insertions(+), 15 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 1a90598901c5..a6aef405ef87 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -3531,9 +3531,13 @@ Possible features:
>  
>  	    * Userspace must explicitly select a PMU implementation before
>  	      initializing the PMU or configuring a PMU event filter
> +	      (KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY also satisfies the
> +	      initialization requirement; event filtering remains unavailable
> +	      in that mode)
>  
> -	    * If the PMU implements FEAT_PMUv3p4, PMMIR_EL1.SLOTS provides the
> -	      hardware value of the underlying implementation
> +	    * If a hardware PMU is selected and implements FEAT_PMUv3p4,
> +	      PMMIR_EL1.SLOTS provides its hardware value. In fixed-counters-only
> +	      mode, PMMIR_EL1 reads as zero
>  
>  	    * Writes to PMCR_EL0.N via KVM_SET_ONE_REG are ignored
>  
> diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> index a3f20a4ee4b1..41f6d708ff43 100644
> --- a/Documentation/virt/kvm/devices/vcpu.rst
> +++ b/Documentation/virt/kvm/devices/vcpu.rst
> @@ -53,9 +53,9 @@ Returns:
>  	 =======  ======================================================
>  	 -EEXIST  Interrupt number already used
>  	 -ENODEV  PMUv3 not supported or GIC not initialized
> -	 -ENXIO   PMUv3 not supported, missing VCPU feature, missing
> -                  hardware PMU, or interrupt number not set (non-GICv5
> -                  guests, only)
> +	 -ENXIO   PMUv3 not supported, missing VCPU feature,
> +		  neither hardware PMU nor FIXED_COUNTERS_ONLY selected,
> +		  or interrupt number not set (non-GICv5 guests only)
>  	 -EBUSY   PMUv3 already initialized
>  	 =======  ======================================================
>  
> @@ -64,7 +64,8 @@ virtual GIC implementation, this must be done after initializing the in-kernel
>  irqchip.
>  
>  When the KVM_ARM_VCPU_PMU_V3_STRICT vCPU feature is enabled this must be done
> -after selecting a hardware PMU.
> +after selecting a hardware PMU or enabling
> +KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY.
>  
>  1.3 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_FILTER
>  -----------------------------------------
> @@ -78,7 +79,8 @@ after selecting a hardware PMU.
>  	 -ENODEV  PMUv3 not supported or GIC not initialized
>  	 -ENXIO   PMUv3 not properly configured or in-kernel irqchip not
>  	 	  configured as required prior to calling this attribute
> -	 -EBUSY   PMUv3 already initialized or a VCPU has already run
> +	 -EBUSY   PMUv3 already initialized, a VCPU has already run or
> +		  FIXED_COUNTERS_ONLY has already been set
>  	 -EINVAL  Invalid filter range
>  	 =======  ======================================================
>  
> @@ -123,14 +125,14 @@ after selecting a hardware PMU.
>  
>  :Returns:
>  
> -	 =======  ====================================================
> +	 =======  ===========================================================
>  	 -EBUSY   PMUv3 already initialized, a VCPU has already run or
> -                  an event filter has already been set
> +                  an event filter or FIXED_COUNTERS_ONLY has already been set
>  	 -EFAULT  Error accessing the PMU identifier
>  	 -ENXIO   PMU not found
>  	 -ENODEV  PMUv3 not supported or GIC not initialized
>  	 -ENOMEM  Could not allocate memory
> -	 =======  ====================================================
> +	 =======  ===========================================================
>  
>  Request that the VCPU uses the specified hardware PMU when creating guest events
>  for the purpose of PMU emulation. The PMU identifier can be read from the "type"
> @@ -172,6 +174,30 @@ explicitly selected, or the number of counters is out of range for the
>  selected PMU. Selecting a new PMU cancels the effect of setting this
>  attribute.
>  
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
> +If set, KVM emulates PMUv3 without programmable event counters.
> +
> +With KVM_ARM_VCPU_PMU_V3_STRICT, enabling this attribute satisfies the
> +PMU selection requirement for KVM_ARM_VCPU_PMU_V3_INIT.
> +
> +When this attribute is enabled, the vCPU can run on any physical CPU
> +that has a PMU, regardless of the underlying implementation. This
> +attribute is VM-scoped.
> +
>  2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
>  =================================
>  
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 65ee09bd1463..7a6a0af14f5a 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -453,6 +453,7 @@ struct kvm_vgic_v5_ist {
>  #define   KVM_ARM_VCPU_PMU_V3_FILTER		2
>  #define   KVM_ARM_VCPU_PMU_V3_SET_PMU		3
>  #define   KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS	4
> +#define   KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY	5
>  #define KVM_ARM_VCPU_TIMER_CTRL		1
>  #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
>  #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 9c1e2f3e41db..ebb648eabdc6 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -1017,8 +1017,8 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
>  
>  static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
>  {
> -	/* Only possible when using KVM_ARM_VCPU_PMU_V3_STRICT */
> -	if (!vcpu->kvm->arch.arm_pmu)
> +	/* Strict PMUv3 requires a hardware PMU or fixed-counters-only mode. */
> +	if (!vcpu->kvm->arch.arm_pmu && !kvm_pmu_fixed_counters_only(vcpu->kvm))
>  		return -ENXIO;
>  
>  	if (irqchip_in_kernel(vcpu->kvm)) {
> @@ -1153,8 +1153,8 @@ int kvm_arm_set_default_pmu(struct kvm *kvm)
>  	 * affines the VMM to a particular cluster of cores.
>  	 *
>  	 * In any case, userspace should just do the sane thing and use the UAPI
> -	 * to select a PMU type directly. But, be wary of the baggage being
> -	 * carried here.
> +	 * to select a PMU type directly, or request fixed-counters-only
> +	 * emulation. But, be wary of the baggage being carried here.
>  	 */
>  	struct arm_pmu *arm_pmu = kvm_pmu_probe_armpmu(raw_smp_processor_id());
>  
> @@ -1179,11 +1179,13 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
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
>  			kvm_arm_set_pmu(kvm, arm_pmu);
>  			cpumask_copy(kvm->arch.supported_cpus, &arm_pmu->supported_cpus);
>  
> @@ -1205,6 +1207,22 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
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
> +	kvm->arch.nr_pmu_counters = 0;
> +
> +	return 0;
> +}
> +

I'd rather that FIXED_COUNTERS_ONLY depend on the KVM_ARM_VCPU_PMU_V3_STRICT
feature flag. The expectation of that flag is that userspace specifies a
backing PMU implementation; your FIXED_COUNTERS_ONLY could just be seen
as one such PMU implementation.

Thanks,
Oliver
 
