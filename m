Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FEE536920C;
	Tue,  6 Oct 2026 06:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791266505; cv=none; b=P+aqIMZWVeOij47vUwP/0BsW0wv2aSCimRSMdkpHfCQa28E0t2gwuw4n9DIMnZWIof/73Op1jbiipjzWR5GK/bnWw5Qfau8QRm3f+bBrHEnohgsi0CoB9DUu4CKuRrsHnqfA06DxboPvUhbdytm74/73LHHmcoxSxUckB8T7r/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791266505; c=relaxed/simple;
	bh=K5ZbFg0ad6QXuzcRw9vXkYN2H3KpO+AxVP0d6o2ZYfo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PDuaD5jqqURrOEUo39usjX8Lt6HOsi9ttubkBJFgx/qPefcQg3Of/AKfxALeGdagfnaBuYPrWwWWI5Dsv4l2QxnIbBezrp9XtkUWSpdTw9jWnFEViQ0DrslsOvowT2pirYYSDJG+POriCL7wj3vTlSdsDUY+M28eegi+uck+qMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KNxGHj4Y; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KNxGHj4Y"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0EF9C168F;
	Mon,  5 Oct 2026 23:01:40 -0700 (PDT)
Received: from [10.57.10.233] (unknown [10.57.10.233])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8B4BA3F763;
	Mon,  5 Oct 2026 23:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791266503; bh=K5ZbFg0ad6QXuzcRw9vXkYN2H3KpO+AxVP0d6o2ZYfo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KNxGHj4Y75GUVXBSpnYDZyrtIb1rQQbHv6uTZZCgA/BESWq1aQW6vGKVGXtGY5vTi
	 PuyO5ciX1UcbAZyJj47gAMCVKSWouSxeeczjXlIHisWimYRAu/6rME70AwIDc+9flR
	 WtQFpbIOAe90/rA6C1Fvdp3clq1F+u9TDpsPZi20=
Message-ID: <7b6ed626-eca4-41f2-ae56-0af59a931b29@arm.com>
Date: Tue, 6 Oct 2026 08:01:37 +0200
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
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <52e3e45a-751e-40b2-8dd3-3db589ddebee@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 06/10/2026 06:47, Gavin Shan wrote:
> On 10/5/26 7:07 PM, Suzuki K Poulose wrote:
>> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
>>
>> The RMM restricts the access to the register states that the host can
>> read/modify for a given Realm.
>>
>> e.g., At VCPU creation, can modify GPRS (x0-x30) and PC.
>>        While servicing SMCCC calls via RSI_HOST_CALL or servicing PSCI
>>        requests.
>>        MMIO emulation in the unprotected space.
>>
>> Additionally we use the sysreg configuration to advertise/configure the
>> following Realm parameters, which are required before the Realm 
>> Descriptor
>> is created:
>>   - SVE Vector Length
>>   - Number of HW Breakpoints/Watchpoints
>>   - PMU Counters.
>>
>> Thus KVM also additionally allows access to ID_AA64DFR0_EL1 and 
>> SVE_VLS for
>> the configuration of Realm creation parameters. We don't support PMUs for
>> the Realm VMs yet, so PMCR is not exposed.
>>
>> The RMM makes similar restrictions for reading of the guest's registers
>> (this is *confidential* compute after all), however we don't impose the
>> restriction here. This allows the VMM to read (stale) values from the
>> registers which might be useful to read back the initial values even if
>> the RMM doesn't provide the latest version. For migration of a realm VM,
>> a new interface will be needed so that the VMM can receive an
>> (encrypted) blob of the VM's state.
>>
>> Reflect the above in KVM_GET_REG_LIST, KVM_SET_ONE_REG calls.

>>   static int core_reg_size_from_offset(const struct kvm_vcpu *vcpu, 
>> u64 off)
>>   {
>>       int size;
>> @@ -553,6 +572,9 @@ static int copy_core_reg_indices(const struct 
>> kvm_vcpu *vcpu,
>>           u64 reg = KVM_REG_ARM64 | KVM_REG_ARM_CORE | i;
>>           int size = core_reg_size_from_offset(vcpu, i);
>> +        if (vcpu_is_rec(vcpu) && !kvm_realm_validate_core_reg(i))
>> +            continue;
>> +
>>           if (size < 0)
>>               continue;
>> @@ -598,6 +620,9 @@ static unsigned long num_sve_regs(const struct 
>> kvm_vcpu *vcpu)
>>       if (!vcpu_has_sve(vcpu))
>>           return 0;
>> +    if (kvm_vm_is_realm(vcpu->kvm))
>> +        return 1; /* KVM_REG_ARM64_SVE_VLS */
>> +
>>       if (!kvm_arm_vcpu_sve_finalized(vcpu))
>>           return 1; /* KVM_REG_ARM64_SVE_VLS */
>>
> 
> Aren't above two checks conflicting to each other?

Do they? We allow SVE_VLS only for the Realms and we allow that
before the vCPUs are finalized. For normal VMs, depending on
whether the vcpus are finalized, we either send 1 or the full list.

> 
>> @@ -625,6 +650,10 @@ static int copy_sve_reg_indices(const struct 
>> kvm_vcpu *vcpu,
>>           return -EFAULT;
>>       ++num_regs;
>> +    /* For Realms only support SVE_VLS */
>> +    if (kvm_vm_is_realm(vcpu->kvm))
>> +        return num_regs;
>> +
>>       if (!kvm_arm_vcpu_sve_finalized(vcpu))
>>           return num_regs;
> 
> Same question here.

As above.

Suzuki
