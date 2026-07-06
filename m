Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B89B672;
	Mon,  6 Jul 2026 18:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783362240; cv=none; b=RKx1y986YWs5pspqRuN7uY1Anqlni/y5pkzo6pfr0DPRqm/8g7wc6j/tYEiFVmgDll9cPqPDsPIT/UKHsviO3/wTDOzdawqYNWHy7S2DE3v92l43L2NvD18QkV5n4y6r2gFAqEBmvTAOQsL0OzNw7vwoHFV+yzLz1EW5M+kH2cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783362240; c=relaxed/simple;
	bh=OAZW2mOhO7NaL6oxqnNTVcDyra+tNWR2x3SKVGe+Lf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lFFRdwmHy0cHLDp9Td2lUlqPGVogP3G9TnXh+p00AWjnanFzkel56sBdQglNoRWgGrn1/F8wJwBUNwnU0rH4eFfoUvaeo7Ojcyp+QMxwed/nk0ampgpDsIi8EwQjOPUg50iYbxFEYv7l3sTMT/ts/4sR0zadPZjicBsBddiy6vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kumziUdy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kumziUdy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD941F000E9;
	Mon,  6 Jul 2026 18:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783362238;
	bh=SsdGNSB4zy5M0ej3qNdxVPNJ5ocdqwgLpYFnxrwRiOA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kumziUdyrjugrxYZugzIjlWcmC9HIodhRMZrmVkXke0JQHc6DSSO6eYyMfq5CiKE9
	 BBmRIfa50qID9aoZHs3mU54ICO17zjuZm2QSn0ZNhv4rX8myFYPfFwehkg2/YxyEUC
	 y4cwrMjn5amJToz/JhoF1gAGvh0rSORDSCafQZ9sOrZp1XWo3//gU/Z6518bMMgfLc
	 7l2YRvqGYxltd3+1No6PKk5KCn2uJuCQlWLTXTZfA9RdbAh6BN0zxHIPcPJ40mpgCH
	 PwetxkjP2bXyTXfxGXDQZDob0kfbFiGrQCFG10MA64mdwp706YJKni8AECL7P7ZaQq
	 f0FBu47IYqtTw==
Date: Mon, 6 Jul 2026 11:23:57 -0700
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
Subject: Re: [PATCH v8 5/7] KVM: arm64: PMU: Implement fixed-counters-only
 emulation
Message-ID: <akvyvclUQ2b2YHiU@kernel.org>
References: <20260706-hybrid-v8-0-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
 <20260706-hybrid-v8-5-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260706-hybrid-v8-5-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>

On Mon, Jul 06, 2026 at 07:03:28PM +0900, Akihiko Odaki wrote:
> Add internal state for PMUv3 emulation without programmable event
> counters. When fixed-counters-only mode is active, KVM reports no
> programmable counters and hides PMCEID, avoiding event-counter state
> whose behavior can depend on the selected hardware PMU.
> 
> The cycle counter still uses a host perf event. Unlike the normal PMU
> path, fixed-counters-only mode may create that event from the hardware
> PMU attached to the VCPU's current pCPU. If the VCPU later loads on a
> pCPU that is not covered by the existing event's PMU, request a PMU
> reload so the cycle counter can be recreated against the new pCPU's PMU.
> Keep this affinity check limited to fixed-counters-only VMs; the normal
> programmable-counter mode continues to use the VM-wide PMU and does not
> need per-load reload decisions.
> 
> Add a separate internal flag for explicit userspace PMU selection. The
> UAPI wiring added later will use it to keep explicit PMU selection and
> fixed-counters-only mode mutually exclusive while still allowing
> fixed-counters-only mode to replace the default PMU selected during
> KVM_ARM_VCPU_INIT.
> 
> The UAPI wiring that sets the fixed-counters-only flag and records
> explicit PMU selection is added later in the series.
> 
> Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
> ---
>  arch/arm64/include/asm/kvm_host.h |  4 ++++
>  arch/arm64/kvm/arm.c              |  1 +
>  arch/arm64/kvm/pmu-emul.c         | 43 +++++++++++++++++++++++++++++++++++++--
>  include/kvm/arm_pmu.h             |  2 ++
>  4 files changed, 48 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 0c39d9db7d57..aa07b05b8231 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -353,6 +353,10 @@ struct kvm_arch {
>  #define KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS		10
>  	/* Unhandled SEAs are taken to userspace */
>  #define KVM_ARCH_FLAG_EXIT_SEA				11
> +	/* PMUv3 is emulated with an explicitly specified hardware PMU */
> +#define KVM_ARCH_FLAG_PMU_V3_EXPLICIT			12
> +	/* PMUv3 is emulated without progammable event counters */
> +#define KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY	13
>  	unsigned long flags;
>  
>  	/* VM-wide vCPU feature set */
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 68767bb08285..1cc7754d5ace 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -687,6 +687,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	if (has_vhe())
>  		kvm_vcpu_load_vhe(vcpu);
>  	kvm_arch_vcpu_load_fp(vcpu);
> +	kvm_vcpu_load_pmu(vcpu);
>  	kvm_vcpu_pmu_restore_guest(vcpu);
>  	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
>  		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index e70628653e4b..40cad183376c 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -96,6 +96,11 @@ u64 kvm_pmu_evtyper_mask(struct kvm *kvm)
>  	return mask;
>  }
>  
> +static bool kvm_pmu_fixed_counters_only(struct kvm *kvm)
> +{
> +	return test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &kvm->arch.flags);
> +}
> +
>  /**
>   * kvm_pmc_is_64bit - determine if counter is 64bit
>   * @pmc: counter context
> @@ -343,7 +348,11 @@ u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu)
>  
>  static void kvm_pmc_enable_perf_event(struct kvm_pmc *pmc)
>  {
> -	if (!pmc->perf_event) {
> +	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
> +
> +	if (!pmc->perf_event ||
> +	    (kvm_pmu_fixed_counters_only(vcpu->kvm) &&
> +	     !cpumask_test_cpu(vcpu->cpu, &to_arm_pmu(pmc->perf_event->pmu)->supported_cpus))) {
>  		kvm_pmu_create_perf_event(pmc);
>  		return;
>  	}
> @@ -720,6 +729,12 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
>  	int eventsel;
>  	u64 evtreg;
>  
> +	if (kvm_pmu_fixed_counters_only(vcpu->kvm)) {
> +		arm_pmu = kvm_pmu_probe_armpmu(vcpu->cpu);
> +		if (WARN_ON_ONCE(!arm_pmu))
> +			return;
> +	}
> +
>  	evtreg = kvm_pmc_read_evtreg(pmc);
>  
>  	kvm_pmu_stop_counter(pmc);
> @@ -748,7 +763,7 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
>  	 * Don't create an event if we're running on hardware that requires
>  	 * PMUv3 event translation and we couldn't find a valid mapping.
>  	 */
> -	eventsel = kvm_map_pmu_event(vcpu->kvm->arch.arm_pmu, eventsel);
> +	eventsel = kvm_map_pmu_event(arm_pmu, eventsel);
>  	if (eventsel < 0)
>  		return;
>  
> @@ -878,6 +893,9 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
>  	u64 val, mask = 0;
>  	int base, i, nr_events;
>  
> +	if (kvm_pmu_fixed_counters_only(vcpu->kvm))
> +		return 0;
> +

Even if we advertise bits in PMCEID, does it matter? There's no PMC that
the guest could use to count it.

I understand it isn't aesthetic but I really want to minimize the
special-casing that has to be done for this feature.

> +void kvm_vcpu_load_pmu(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * ARMV8_PMU_INSTR_IDX will need the same check once
> +	 * FEAT_PMUv3_ICNTR is supported.
> +	 */
> +	struct kvm_pmc *pmc = kvm_vcpu_idx_to_pmc(vcpu, ARMV8_PMU_CYCLE_IDX);
> +	struct arm_pmu *cpu_pmu;
> +
> +	if (!kvm_pmu_fixed_counters_only(vcpu->kvm) ||
> +	    !kvm_pmu_counter_is_enabled(pmc) || !pmc->perf_event)
> +		return;
> +
> +	cpu_pmu = to_arm_pmu(pmc->perf_event->pmu);
> +	if (!cpumask_test_cpu(vcpu->cpu, &cpu_pmu->supported_cpus))
> +		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);

Just detect the changing PMU implementation here, KVM_REQ_RELOAD_PMU
will need to detect the PMCs that require an update anyway. Stash the
last cpu in kvm_arch_vcpu_load() and pass it to this:

void kvm_vcpu_load_pmu(struct kvm_vcpu *vcpu, int last_cpu)
{
	if (!kvm_pmu_fixed_counters_only(vcpu->kvm) || vcpu->cpu == last_cpu)
		return;

	if (kvm_pmu_probe_armpmu(vcpu->cpu) != kvm_pmu_probe_armpmu(last_cpu))
		kvm_make_request(KVM_REQ_RELOAD_PMU);
}

Thanks,
Oliver
