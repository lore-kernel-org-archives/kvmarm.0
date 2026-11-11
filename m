Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794419437;
	b=YbDI33swMJEQkag7zC/ZyEzfJIDWvl8g1JkyKzS5Hqew/qRaW2ynWCScpuQJbh8O7ZAT
	 ksTA76bnB7Q1XTHADjbuMkp3t6CL3UE2/IQULPdMI/iIgh7Pe8GBGv+6Ydklz6R1O7aJh
	 QgaThmAB/RMTMPGEW4RKzWBFpk3GezcPrR/JfSWzzix9QQLrXH69Sjum03X4MRbCR8PRt
	 rDtclvZaXoiBNyNQHLqGj4M+WUfMrjzdad+wZqwaGrWfB/hriPhOkq0c7W4GfmhNUl9Bj
	 /UUmxQQKibwkMtfZAKNtdzQQ3alpMgV+M8VprLLaCXCSmxAZhz/k3EKHjieYWCTdkog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794419437;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=Z8qU6+HvaIS0hGP6RSMrC3qaiOO8YyUA1e15Sl/ZGXE=;
	b=mgYD16TuX7yTUr7kPgCgGshy6JRdGgFja7YDBF32vK4+t18KJHAtlW5Xtqj6z7t96BRy
	 Gh+ayOe6FS1t+lSEFGYGCEzbBUAkDzSGqgjgJF8Uq+0SdDmKHpZ6JclkuXqt6499oZ9tS
	 UOLWt3YpKNPfcJJ8Q/4tlKBa7WIPdni3aFv5Z9vxK2xBLlIhlKkCqSrM+nKZ7pglBBIF3
	 zZM6byjcWEw2F/J1VpAzTauGdA8+2IdWMB4CB89sonLHIDXkc1YxFHEK1QkPQ4zAW2n/d
	 19Wt+nb3IZpXXE88/T2hez6WM2Fi4Y98Y6NT3MVSnHO/cxWtquo86MwT7UKsuXtkqng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=B0vx20da;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CE74606A321
	for <kvmarm@lists.linux.dev>; Wed, 11 Nov 2026 17:50:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8CE74606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=B0vx20da
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DADC11576;
	Wed, 11 Nov 2026 09:50:32 -0800 (PST)
Received: from [10.57.69.47] (unknown [10.57.69.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DC4093F632;
	Wed, 11 Nov 2026 09:50:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794419435; bh=mkeJMyoQ8Qv6RCg92gwoZ/tiJll4x2tHEGTQlboYilQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=B0vx20daoO+pjHgnuqgkbbdr6Am0qaJ+xSgQiGc5DV5qXM28UAODjDIdbLLg3j+P/
	 JVlF8vJ8I0yzmAja1WatBIQIdsq/5ssyGRXt8SQoW39vxsUmwE3B3KibZBxalzjzoM
	 52ANnchXJdVDMcsSysOPgEhvoy0NWAp+/DfnpoPE=
Message-ID: <c426f5a3-d161-476d-8911-99903ecf8e46@arm.com>
Date: Wed, 11 Nov 2026 17:50:31 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/18] KVM: arm64: Implement HVC handling for protected
 guests at EL2
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com,
 seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 mark.rutland@arm.com, steven.price@arm.com, vdonnefort@google.com,
 qperret@google.com
References: <20261001135711.1640520-1-fuad.tabba@linux.dev>
 <20261001135711.1640520-10-fuad.tabba@linux.dev>
 <5fa8a1fb-4e2c-4746-8a70-a47f387ef0d6@arm.com>
 <CA+EHjTyCcGPMte9=HuqyvCS7CCCt80Lc_JQuA+1e3ZE+3A0zqQ@mail.gmail.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <CA+EHjTyCcGPMte9=HuqyvCS7CCCt80Lc_JQuA+1e3ZE+3A0zqQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/11/2026 16:45, Fuad Tabba wrote:
> Hi Ryan,
> 
> On Wed, 11 Nov 2026 13:59:17 +0000, Ryan Roberts <ryan.roberts@arm.com> wrote:
> [...]
>>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> [...]
>>> @@ -2622,6 +2622,10 @@ static void kvm_hyp_init_symbols(void)
>>>          kvm_nvhe_sym(__icache_flags) = __icache_flags;
>>>          kvm_nvhe_sym(kvm_arm_vmid_bits) = kvm_arm_vmid_bits;
>>>
>>> +        kvm_nvhe_sym(spectre_v2_state) = arm64_get_spectre_v2_state();
>>> +        kvm_nvhe_sym(spectre_v4_state) = arm64_get_spectre_v4_state();
>>> +        kvm_nvhe_sym(spectre_bhb_state) = arm64_get_spectre_bhb_state();
>>
>> Is it really correct to snapshot this state then use it at runtime assuming its
>> still accurate? See below...
> 
> These can't change after this point: update_mitigation_state() doesn't
> update a state once system_capabilities_finalized() is true, and
> kvm_arm_init() runs after that.
> 
> [...]
>>> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> [...]
>>> @@ -1181,8 +1187,70 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
> [...]
>>> +        case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
>>> +                /* The workaround calls themselves are handled on hyp entry. */
>>> +                val[0] = SMCCC_RET_NOT_SUPPORTED;
> [...]
>>> +                case ARM_SMCCC_ARCH_WORKAROUND_2:
>>> +                        switch (spectre_v4_state) {
>>> +                        case SPECTRE_VULNERABLE:
>>> +                                break;
>>> +                        case SPECTRE_MITIGATED:
>>> +                                /* With SSBS advertised the guest's default is safe. */
>>> +                                if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, SSBS, IMP))
>>> +                                        break;
>>
>> For this case (and the break immediately above) you return val[0] =
>> SMCCC_RET_INVALID_PARAMETER (from init at top of this function). But the
>> kernel's kvm_smccc_call_handler() returns val[0] = SMCCC_RET_NOT_SUPPORTED in
>> these cases (which seems more likely to be correct). Does this violate the ABI?
> 
> Both return NOT_SUPPORTED. val[0] is set to it at the top of the
> ARM_SMCCC_ARCH_FEATURES_FUNC_ID case.

Ahh missed that oops!

> 
>>
>>> +                                fallthrough;
>>> +                        case SPECTRE_UNAFFECTED:
>>> +                                val[0] = SMCCC_RET_NOT_REQUIRED;
>>
>> Is it possible that the (compromised) kernel could have disabled the mitigation
>> after the state snapshot was taken? I.e. spectre_v4_state == SPECTRE_MITIGATED
>> and the VM doesn't advertise SSBS so it returns SMCCC_RET_NOT_REQUIRED here. But
>> the kernel has since turned off the mitigation?
> 
> Yes, where the mitigation is the firmware one. The host can disable it
> with an ARM_SMCCC_ARCH_WORKAROUND_2 call, which EL2 forwards, and EL2
> doesn't enable it again before running the guest. With TF-A that's
> only on a Cortex-A76 without SSBS, the only CPU it implements the
> dynamic workaround for.

If the mitigation is via SSBS but SSBS is not exposed to the guest, I'm guessing
this is safe because the guest is expected to set SSBS=0 in this case?

Thanks,
Ryan

> 
> I'll send out a fix. Thanks for spotting this!
> 
> Cheers,
> /fuad

