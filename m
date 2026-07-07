Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649B930100E
	for <kvmarm@lists.linux.dev>; Tue,  7 Jul 2026 11:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783423753; cv=none; b=RI0e1zPPGi3J2VaXVkcEgK9lYdLCENPec9moBAoGELjlrot+v3IpoQ70qIdQy80E4Icq7Gvzei6BSE631ECJ9tMwxzlzGu3F/608oZK1fvC/IH9VN5twmNfjBiHTaNOPGwr8zxVW/QfoMPw9txN/eH8mTL1cYA6BIb2LqqcshFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783423753; c=relaxed/simple;
	bh=onBhDyqzL4dpAY4chrVkKmkoS4sjWp6Os00FF9DRTZs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tb7+4SXr4l0pbOZjbbZWr7QIU8TLiGLz41sfC9ayVpjQKnArgr/Us7covpsPfZPEBXuok5DAcCXbIcHjg+2DNR2aLeUHWAW1c9QVuuKj5W8rs9Tf/XS9hC6Snh7IqaTk0J8jt8/Pb7OLIWAS/XNT6RC/O8ocrQY6GyjihNR5BQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=pUJ/OyF7 reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="pUJ/OyF7"
Received: from [133.11.54.183] (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 667BNfJs005495
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 7 Jul 2026 20:23:42 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=FbPusrcXPnpYFyMiIMTwRTROLwgbaX8b1Agwe0KIe8E=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1783423422; v=1;
        b=pUJ/OyF7ICHeyUEuLdKMr4YCFsLqDapVuMRnLQ1VG7qoZLxt4aFcFeO4o7kJliWn
         H3b7btpDubqYTMc9GZCHY5WXZStHC0PvxFiMDD07iruin19bvrgV4oOrmbqrFwGL
         2e6SFbIbSZA2dMHu2Ue3tvi0icj3flekDGu400ANaIoILfDXU2YSG92LLbGEfKwY
         qeakxzWWZshEsXfQfd+3pw9cJNbdEwZEsTMAMFX1PtjbqZUypMMGWCmgWfK2C6AI
         gS95j9Ph4YatoHewtYhkaTotazxRpdOEUFGz1u8zd/R7Fg7xuNZKLxD6q/fhCtwI
         dK+JUrYcPvBaufMKvSU3Lw==
Message-ID: <cb5d5f13-a1a9-47dd-a717-5533a8b32b20@rsg.ci.i.u-tokyo.ac.jp>
Date: Tue, 7 Jul 2026 20:23:41 +0900
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 5/7] KVM: arm64: PMU: Implement fixed-counters-only
 emulation
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu
 <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20260706-hybrid-v8-0-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
 <20260706-hybrid-v8-5-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
 <akvyvclUQ2b2YHiU@kernel.org>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <akvyvclUQ2b2YHiU@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/07/07 3:23, Oliver Upton wrote:
> On Mon, Jul 06, 2026 at 07:03:28PM +0900, Akihiko Odaki wrote:
>> Add internal state for PMUv3 emulation without programmable event
>> counters. When fixed-counters-only mode is active, KVM reports no
>> programmable counters and hides PMCEID, avoiding event-counter state
>> whose behavior can depend on the selected hardware PMU.
>>
>> The cycle counter still uses a host perf event. Unlike the normal PMU
>> path, fixed-counters-only mode may create that event from the hardware
>> PMU attached to the VCPU's current pCPU. If the VCPU later loads on a
>> pCPU that is not covered by the existing event's PMU, request a PMU
>> reload so the cycle counter can be recreated against the new pCPU's PMU.
>> Keep this affinity check limited to fixed-counters-only VMs; the normal
>> programmable-counter mode continues to use the VM-wide PMU and does not
>> need per-load reload decisions.
>>
>> Add a separate internal flag for explicit userspace PMU selection. The
>> UAPI wiring added later will use it to keep explicit PMU selection and
>> fixed-counters-only mode mutually exclusive while still allowing
>> fixed-counters-only mode to replace the default PMU selected during
>> KVM_ARM_VCPU_INIT.
>>
>> The UAPI wiring that sets the fixed-counters-only flag and records
>> explicit PMU selection is added later in the series.
>>
>> Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
>> ---
>>   arch/arm64/include/asm/kvm_host.h |  4 ++++
>>   arch/arm64/kvm/arm.c              |  1 +
>>   arch/arm64/kvm/pmu-emul.c         | 43 +++++++++++++++++++++++++++++++++++++--
>>   include/kvm/arm_pmu.h             |  2 ++
>>   4 files changed, 48 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 0c39d9db7d57..aa07b05b8231 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -353,6 +353,10 @@ struct kvm_arch {
>>   #define KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS		10
>>   	/* Unhandled SEAs are taken to userspace */
>>   #define KVM_ARCH_FLAG_EXIT_SEA				11
>> +	/* PMUv3 is emulated with an explicitly specified hardware PMU */
>> +#define KVM_ARCH_FLAG_PMU_V3_EXPLICIT			12
>> +	/* PMUv3 is emulated without progammable event counters */
>> +#define KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY	13
>>   	unsigned long flags;
>>   
>>   	/* VM-wide vCPU feature set */
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 68767bb08285..1cc7754d5ace 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -687,6 +687,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>   	if (has_vhe())
>>   		kvm_vcpu_load_vhe(vcpu);
>>   	kvm_arch_vcpu_load_fp(vcpu);
>> +	kvm_vcpu_load_pmu(vcpu);
>>   	kvm_vcpu_pmu_restore_guest(vcpu);
>>   	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
>>   		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>> index e70628653e4b..40cad183376c 100644
>> --- a/arch/arm64/kvm/pmu-emul.c
>> +++ b/arch/arm64/kvm/pmu-emul.c
>> @@ -96,6 +96,11 @@ u64 kvm_pmu_evtyper_mask(struct kvm *kvm)
>>   	return mask;
>>   }
>>   
>> +static bool kvm_pmu_fixed_counters_only(struct kvm *kvm)
>> +{
>> +	return test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &kvm->arch.flags);
>> +}
>> +
>>   /**
>>    * kvm_pmc_is_64bit - determine if counter is 64bit
>>    * @pmc: counter context
>> @@ -343,7 +348,11 @@ u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu)
>>   
>>   static void kvm_pmc_enable_perf_event(struct kvm_pmc *pmc)
>>   {
>> -	if (!pmc->perf_event) {
>> +	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
>> +
>> +	if (!pmc->perf_event ||
>> +	    (kvm_pmu_fixed_counters_only(vcpu->kvm) &&
>> +	     !cpumask_test_cpu(vcpu->cpu, &to_arm_pmu(pmc->perf_event->pmu)->supported_cpus))) {
>>   		kvm_pmu_create_perf_event(pmc);
>>   		return;
>>   	}
>> @@ -720,6 +729,12 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
>>   	int eventsel;
>>   	u64 evtreg;
>>   
>> +	if (kvm_pmu_fixed_counters_only(vcpu->kvm)) {
>> +		arm_pmu = kvm_pmu_probe_armpmu(vcpu->cpu);
>> +		if (WARN_ON_ONCE(!arm_pmu))
>> +			return;
>> +	}
>> +
>>   	evtreg = kvm_pmc_read_evtreg(pmc);
>>   
>>   	kvm_pmu_stop_counter(pmc);
>> @@ -748,7 +763,7 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
>>   	 * Don't create an event if we're running on hardware that requires
>>   	 * PMUv3 event translation and we couldn't find a valid mapping.
>>   	 */
>> -	eventsel = kvm_map_pmu_event(vcpu->kvm->arch.arm_pmu, eventsel);
>> +	eventsel = kvm_map_pmu_event(arm_pmu, eventsel);
>>   	if (eventsel < 0)
>>   		return;
>>   
>> @@ -878,6 +893,9 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
>>   	u64 val, mask = 0;
>>   	int base, i, nr_events;
>>   
>> +	if (kvm_pmu_fixed_counters_only(vcpu->kvm))
>> +		return 0;
>> +
> 
> Even if we advertise bits in PMCEID, does it matter? There's no PMC that
> the guest could use to count it.
> 
> I understand it isn't aesthetic but I really want to minimize the
> special-casing that has to be done for this feature.

This strictly ensures that sysregs are stable after migrating across 
physical CPUs, which may have different PMCEID values.

> 
>> +void kvm_vcpu_load_pmu(struct kvm_vcpu *vcpu)
>> +{
>> +	/*
>> +	 * ARMV8_PMU_INSTR_IDX will need the same check once
>> +	 * FEAT_PMUv3_ICNTR is supported.
>> +	 */
>> +	struct kvm_pmc *pmc = kvm_vcpu_idx_to_pmc(vcpu, ARMV8_PMU_CYCLE_IDX);
>> +	struct arm_pmu *cpu_pmu;
>> +
>> +	if (!kvm_pmu_fixed_counters_only(vcpu->kvm) ||
>> +	    !kvm_pmu_counter_is_enabled(pmc) || !pmc->perf_event)
>> +		return;
>> +
>> +	cpu_pmu = to_arm_pmu(pmc->perf_event->pmu);
>> +	if (!cpumask_test_cpu(vcpu->cpu, &cpu_pmu->supported_cpus))
>> +		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
> 
> Just detect the changing PMU implementation here, KVM_REQ_RELOAD_PMU
> will need to detect the PMCs that require an update anyway. Stash the
> last cpu in kvm_arch_vcpu_load() and pass it to this:
> 
> void kvm_vcpu_load_pmu(struct kvm_vcpu *vcpu, int last_cpu)
> {
> 	if (!kvm_pmu_fixed_counters_only(vcpu->kvm) || vcpu->cpu == last_cpu)
> 		return;
> 
> 	if (kvm_pmu_probe_armpmu(vcpu->cpu) != kvm_pmu_probe_armpmu(last_cpu))
> 		kvm_make_request(KVM_REQ_RELOAD_PMU);
> }

It is a nice way to simplify the code and to avoid hardcoding 
ARMV8_PMU_INSTR_IDX. I'll use the code for the next version.

Regards,
Akihiko Odaki
