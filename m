Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A67B41D106;
	Tue,  6 Oct 2026 12:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791290239; cv=none; b=t4o+kdIAmHTgOBPbbwKaOOE0c9FtXZLayVEYHJWE+6w1lmf1nmhlPDdQWrfmRYE0fho0js7iXG2Fj3VoSUM3DBy0blZkv6a5HqwLTEyeJ51zL+/qHDv+TfVyfdO205lBus0zVZ1rjsML8Bw2XLsRsDxDrbigtxVnuBiIR45Zm14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791290239; c=relaxed/simple;
	bh=HEC1onotm9kW6QKrnzD0dawCfe6JSLioR7zbkY+XEdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n2uBnT6oeu7GX1S2sBBDAP89z88GA6lwUjTJRWbWxHJID4pwyL4rJ7XxzScG5hy9N8PVnnR7AJyPfyRRlU2hVjRFBuJA4+LzEMNsNABFqzjVEScsbIFQZgdZaTipa8l1BJmv4WuBWFTNIBMuzqCg+rknlC+WnJ+Zoty74dTA5VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cmJHBHd/; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cmJHBHd/"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BDFD51516;
	Tue,  6 Oct 2026 05:36:51 -0700 (PDT)
Received: from [10.57.10.233] (unknown [10.57.10.233])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 86AD73F66F;
	Tue,  6 Oct 2026 05:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791290215; bh=HEC1onotm9kW6QKrnzD0dawCfe6JSLioR7zbkY+XEdo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cmJHBHd/tPoaiaFDB+pHi4cdyG3iQqM8NNm9D0s0e54/KwUvvrB7GTB3RL6cbWQUN
	 uoQM/Uh3rx22FzyshOZ6d1yBpYp3ImxJ5asGG1AEspVgFgpMXPSikCEiVc/7247Qbr
	 RS8u+Ae3LpsMoBx8dZxP19enp8JguDuXyDk06wKg=
Message-ID: <71ceb680-e168-450e-99e0-7a8cf4160bba@arm.com>
Date: Tue, 6 Oct 2026 14:36:48 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 23/23] KVM: arm64: CCA: Control user register access
 for Realms
Content-Language: en-GB
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com,
 Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
 <20261005090754.2140522-24-suzuki.poulose@arm.com>
 <52e3e45a-751e-40b2-8dd3-3db589ddebee@redhat.com>
 <7b6ed626-eca4-41f2-ae56-0af59a931b29@arm.com>
 <6bd785aa-4693-407d-b70a-39b1d0eda63e@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <6bd785aa-4693-407d-b70a-39b1d0eda63e@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 06/10/2026 07:16, Gavin Shan wrote:
> On 10/6/26 4:01 PM, Suzuki K Poulose wrote:
>> On 06/10/2026 06:47, Gavin Shan wrote:
>>> On 10/5/26 7:07 PM, Suzuki K Poulose wrote:
>>>> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
>>>>
>>>> The RMM restricts the access to the register states that the host can
>>>> read/modify for a given Realm.
>>>>
>>>> e.g., At VCPU creation, can modify GPRS (x0-x30) and PC.
>>>>        While servicing SMCCC calls via RSI_HOST_CALL or servicing PSCI
>>>>        requests.
>>>>        MMIO emulation in the unprotected space.
>>>>
>>>> Additionally we use the sysreg configuration to advertise/configure the
>>>> following Realm parameters, which are required before the Realm 
>>>> Descriptor
>>>> is created:
>>>>   - SVE Vector Length
>>>>   - Number of HW Breakpoints/Watchpoints
>>>>   - PMU Counters.
>>>>
>>>> Thus KVM also additionally allows access to ID_AA64DFR0_EL1 and 
>>>> SVE_VLS for
>>>> the configuration of Realm creation parameters. We don't support 
>>>> PMUs for
>>>> the Realm VMs yet, so PMCR is not exposed.
>>>>
>>>> The RMM makes similar restrictions for reading of the guest's registers
>>>> (this is *confidential* compute after all), however we don't impose the
>>>> restriction here. This allows the VMM to read (stale) values from the
>>>> registers which might be useful to read back the initial values even if
>>>> the RMM doesn't provide the latest version. For migration of a realm 
>>>> VM,
>>>> a new interface will be needed so that the VMM can receive an
>>>> (encrypted) blob of the VM's state.
>>>>
>>>> Reflect the above in KVM_GET_REG_LIST, KVM_SET_ONE_REG calls.
>>
>>>>   static int core_reg_size_from_offset(const struct kvm_vcpu *vcpu, 
>>>> u64 off)
>>>>   {
>>>>       int size;
>>>> @@ -553,6 +572,9 @@ static int copy_core_reg_indices(const struct 
>>>> kvm_vcpu *vcpu,
>>>>           u64 reg = KVM_REG_ARM64 | KVM_REG_ARM_CORE | i;
>>>>           int size = core_reg_size_from_offset(vcpu, i);
>>>> +        if (vcpu_is_rec(vcpu) && !kvm_realm_validate_core_reg(i))
>>>> +            continue;
>>>> +
>>>>           if (size < 0)
>>>>               continue;
>>>> @@ -598,6 +620,9 @@ static unsigned long num_sve_regs(const struct 
>>>> kvm_vcpu *vcpu)
>>>>       if (!vcpu_has_sve(vcpu))
>>>>           return 0;
>>>> +    if (kvm_vm_is_realm(vcpu->kvm))
>>>> +        return 1; /* KVM_REG_ARM64_SVE_VLS */
>>>> +

This could be vcpu_is_rec().
>>>>       if (!kvm_arm_vcpu_sve_finalized(vcpu))
>>>>           return 1; /* KVM_REG_ARM64_SVE_VLS */
>>>>
>>>
>>> Aren't above two checks conflicting to each other?
>>
>> Do they? We allow SVE_VLS only for the Realms and we allow that
>> before the vCPUs are finalized. For normal VMs, depending on
>> whether the vcpus are finalized, we either send 1 or the full list.
>>
> 
> num_sve_regs() can be called for 3 cases: (a) non-finalized RECs; (b) 
> finalized
> RECs; (c) Other finalized vCPUs, correct? "if (kvm_vm_is_realm(vcpu- 
>  >kvm))", which
> would be "if (vcpu_is_rec(vcpu))", covers (a) and (b). We needn't the 
> excessive
> check "if (!kvm_arm_vcpu_sve_finalized(vcpu))". So the check would be 
> something
> as below after this series is applied:
> 
>      /*
>       * KVM_REG_ARM64_SVE_VLS is visible on realm vCPU no matter if it
>       * has been finalized.
>       */
>      if (vcpu_is_rec(vcpu))
>          return 1;
> 
> This check "if (vcpu_is_rec(vcpu))" belongs to PATCH[22]. Hope I make 
> myself
> clear this time :)

Sure, these two patches are closely related and may be even could be
folded in. I split it out to make it easier to review.

22: Allow exposing SVE_VLS for unfinalized VCPU RECs
23: Control register accesses includingthe SVE_VLS, but prevent
everything else

Does it help ?

Cheers
Suzuki


> 
>>>
>>>> @@ -625,6 +650,10 @@ static int copy_sve_reg_indices(const struct 
>>>> kvm_vcpu *vcpu,
>>>>           return -EFAULT;
>>>>       ++num_regs;
>>>> +    /* For Realms only support SVE_VLS */
>>>> +    if (kvm_vm_is_realm(vcpu->kvm))
>>>> +        return num_regs;
>>>> +
>>>>       if (!kvm_arm_vcpu_sve_finalized(vcpu))
>>>>           return num_regs;
>>>
>>> Same question here.
>>
>> As above.
>>
>> Suzuki
> 
> Thanks,
> Gavin
> 

