Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85277572661
	for <kvmarm@lists.linux.dev>; Tue,  8 Sep 2026 13:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788873333; cv=none; b=SLhOZRgJv/AuCDw87M74FyfDBHC4HMz0tpXiMzuME9JuOMmNXmKBWEPfadkt9TGeoFwZb3njujeObEsduhknqrTxVtI0GUp87KsEf11fgoBCAfC2+h2pAK0MQMM4VoI4bN9TODNxK64cS/qH4syQP3ReT6EB5L26bOjaua5D5V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788873333; c=relaxed/simple;
	bh=rTMz/xlUFYVRRRGd5XADHoDI6DvwfIJL1qpU/Fb0hHk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MkhPWlUMVgMQkDjylz6SfSeulOS7YvmHFcVGGA/khonACE/6Z4vPWtBu6WaDOcVBUF5cnADv3wL7OJEusrd3lvfCmSX6w9C2qde8mqOgrk7yjsFXqJfU9u8mwEzwFmhGDoqHWEB+NHAzP0XSRBFS4lFbNhq4bq2WqQYs1LXUNbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=i3lnViUl; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="i3lnViUl"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C45BE1476;
	Tue,  8 Sep 2026 06:15:24 -0700 (PDT)
Received: from [10.2.212.8] (e134344.arm.com [10.2.212.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3A3583F7B4;
	Tue,  8 Sep 2026 06:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788873328; bh=rTMz/xlUFYVRRRGd5XADHoDI6DvwfIJL1qpU/Fb0hHk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=i3lnViUlTkdIdq8vFPwdhABKk1klUY2eE8I1NZTqXzzWk4B211p8HV0G84qurtHb9
	 kXoVE4R8/aGfp/N8pI2DRKkcpkxk1af6HmQBWmeuG4tD3xvQMICZ0t0iX7ZEdvbcSK
	 /ksnXZcaVkQjl79ddCxU9DqKSvB5LBajCzwwicZA=
Message-ID: <18acfcfd-93e7-4319-9a2e-4fe1ccccacfd@arm.com>
Date: Tue, 8 Sep 2026 14:15:24 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Trap guest MPAM accesses whenever MPAM is
 implemented
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Xi Ruoyao <xry111@xry111.site>,
 Mark Rutland <mark.rutland@arm.com>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Steffen Eiden <seiden@linux.ibm.com>,
 Gavin Shan <gshan@redhat.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260903160819.831518-1-fuad.tabba@linux.dev>
 <dd850141-ea85-4d94-9793-393f24a2fdc2@arm.com>
 <CA+EHjTyuLKYE1UL4XYvq4rxW7fgFNafdTY8H0=Qt6Hnjz3wYvQ@mail.gmail.com>
 <CA+EHjTzZovYDUeoEryhdmP1bvqJyEDmOoPtT7PEDvS2y5puXYA@mail.gmail.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <CA+EHjTzZovYDUeoEryhdmP1bvqJyEDmOoPtT7PEDvS2y5puXYA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Fuad,

On 07/09/2026 16:00, Fuad Tabba wrote:
> Hi Ben,
> 
> I built the respin first, and it didn't hold up.
> 
> On Mon, 7 Sept 2026 at 11:28, Fuad Tabba <fuad.tabba@linux.dev> wrote:
> ...
>> This patch misses that case. check_override reads the CPU's own ID
>> registers, detect_ftr_has_mpam() the sanitised ones, so
>> finalise_el2_state clears the traps and neither cap is set.
>>
>> Not advertising MPAM already happens, since a mismatch lowers the ID
>> field to 0. The trap default is the missing half, and I agree it
>> belongs in finalise_el2_state, which already computes whether
>> MPAM2_EL2 can be touched. KVM then needs only system_supports_mpam(),
>> and the cap goes.
> 
> finalise_el2_state can't set that default. Under nVHE and hVHE the
> host is the trapped party, and cpufeature reads MPAMIDR_EL1 and
> MPAM1_EL1 from EL1 before KVM exists, so the only way out is to stop
> the host detecting MPAM.
> 
>> The one host left is a forced nVHE, where test_has_mpam()'s MPAM1_EL1
>> read would trap before cpu_enable_mpam(). The respin makes the caps
>> false when is_hyp_nvhe(), so MPAM is off there rather than the boot
>> hanging [1].
> 
> is_hyp_nvhe() is true on an hVHE host too, since
> is_kernel_in_hyp_mode() reads CurrentEL. So that turns MPAM off for
> every pKVM host on VHE hardware, not for a forced-nVHE corner. On the
> AEM FVP with MPAM, a host booted kvm-arm.mode=protected detects MPAM
> without the change and not with it.
> 
>> I'll respin along those lines.
> 
> Not along those lines :) I think that v2 would be v1 with a clearer
> commit message, keeping both predicates. Merging them would give
> resctrl the wrong answer, since it needs firmware to have enabled MPAM
> where KVM's trapping needs only that the registers are implemented.
> 
> The mismatched machine stays uncovered, with this patch at least.
> Closing it means deciding per CPU at EL2 from the CPU's own registers
> rather than from a system-wide cap.


Ok, there seems no way to properly handle mismatched systems anyway as CPUs can come online at any
time. I don't know of any mismatched MPAM systems and they would be strange as the interface to the
interconnect would on the CPUS that support MPAM require providing PARTID and PMG and the others not.

Thanks,

Ben

> 
> Cheers,
> /fuad
> 
>> Cheers,
>> /fuad
>>
>> [1] https://lore.kernel.org/all/apqrky27mJmUV9UA@willie-the-truck/
>>
>>
>>>
>>> Thanks,
>>>
>>> Ben
>>>
>>>
>>>> +
>>>>  static inline bool system_supports_pmuv3(void)
>>>>  {
>>>>       return cpus_have_final_cap(ARM64_HAS_PMUV3);
>>>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>>>> index 17b83a2518a8f..36a27692e5cf7 100644
>>>> --- a/arch/arm64/kernel/cpufeature.c
>>>> +++ b/arch/arm64/kernel/cpufeature.c
>>>> @@ -2501,6 +2501,13 @@ test_has_mpam(const struct arm64_cpu_capabilities *entry, int scope)
>>>>       return (read_sysreg_s(SYS_MPAM1_EL1) & MPAM1_EL1_MPAMEN);
>>>>  }
>>>>
>>>> +static bool
>>>> +test_has_mpam_sysregs(const struct arm64_cpu_capabilities *entry, int __unused)
>>>> +{
>>>> +     /* The registers exist whether or not firmware enabled MPAM. */
>>>> +     return detect_ftr_has_mpam();
>>>> +}
>>>> +
>>>>  static void
>>>>  cpu_enable_mpam(const struct arm64_cpu_capabilities *entry)
>>>>  {
>>>> @@ -3116,6 +3123,12 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>>>>               .matches = test_has_mpam,
>>>>               .cpu_enable = cpu_enable_mpam,
>>>>       },
>>>> +     {
>>>> +             .desc = "Memory Partitioning And Monitoring system registers",
>>>> +             .type = ARM64_CPUCAP_SYSTEM_FEATURE,
>>>> +             .capability = ARM64_MPAM_SYSREGS,
>>>> +             .matches = test_has_mpam_sysregs,
>>>> +     },
>>>>       {
>>>>               .desc = "Memory Partitioning And Monitoring Virtualisation",
>>>>               .type = ARM64_CPUCAP_SYSTEM_FEATURE,
>>>> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
>>>> index 1ce7130e25490..8941335724f6b 100644
>>>> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
>>>> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
>>>> @@ -298,7 +298,7 @@ static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)
>>>>       u64 clr = MPAM2_EL2_EnMPAMSM;
>>>>       u64 set = MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1;
>>>>
>>>> -     if (!system_supports_mpam())
>>>> +     if (!system_supports_mpam_sysregs())
>>>>               return;
>>>>
>>>>       /* trap guest access to MPAMIDR_EL1 */
>>>> @@ -317,7 +317,7 @@ static inline void __deactivate_traps_mpam(void)
>>>>       u64 clr = MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1 | MPAM2_EL2_TIDR;
>>>>       u64 set = MPAM2_EL2_EnMPAMSM;
>>>>
>>>> -     if (!system_supports_mpam())
>>>> +     if (!system_supports_mpam_sysregs())
>>>>               return;
>>>>
>>>>       sysreg_clear_set_s(SYS_MPAM2_EL2, clr, set);
>>>> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
>>>> index 2775ba3359cfe..aa5be51385f68 100644
>>>> --- a/arch/arm64/tools/cpucaps
>>>> +++ b/arch/arm64/tools/cpucaps
>>>> @@ -78,6 +78,7 @@ KVM_PROTECTED_MODE
>>>>  MISMATCHED_CACHE_TYPE
>>>>  MPAM
>>>>  MPAM_HCR
>>>> +MPAM_SYSREGS
>>>>  MTE
>>>>  MTE_ASYMM
>>>>  MTE_FAR
>>>>
>>>> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
>>>

