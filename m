Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 138EB35F60F;
	Tue,  6 Oct 2026 05:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791263824; cv=none; b=NeOduLTcLFnfax30faqYZzHoJ1jiOjmuYEG8XqocyV6Rs4cqIeSFe5K8/9GEObDTfN1FpleS61KtQjxVq2XwDEYP+Gppjkyy0I3SX+0z3lTmGaxOmQYKw1enkNzxg412241EnUFO1F7AOdFQ67lYsgf/P73S6LAw3xTx+0ZGrw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791263824; c=relaxed/simple;
	bh=kHIm+ZDWQlpWJpE9d5aQjGHHIl9MwtWL1KWoAeMrPFg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UoJRae7UXj6kPHW8T998IML/j70I4YwM6+SchJhy9AMy2bjCOVf1EfEReiAHGP1lklhKRfoLjMvqKsyW1ViIHHWPizKPz1EQgNBhHB9UE/FuBDBXPjsmX6rDhg69HTOLC2LPQJVPL8vJ6W8OK2vBkaot//hNsOaB9Qnla2Zg0a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pHx0Id4R; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pHx0Id4R"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0DB501595;
	Mon,  5 Oct 2026 22:16:59 -0700 (PDT)
Received: from [10.57.10.233] (unknown [10.57.10.233])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9FDC93F763;
	Mon,  5 Oct 2026 22:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791263822; bh=kHIm+ZDWQlpWJpE9d5aQjGHHIl9MwtWL1KWoAeMrPFg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pHx0Id4RKKixcaqOGUtz/rMKGkyxbzSAbBrO66ZqlaFbKPPloHaO3JHCtR5afBzb0
	 NlpNxt/3vunMOVgdAGko+QCAtqhQ1ORCT+DjwS0czGB4udJdRHbD1eoYsr5mJzNbbp
	 wmCb02JNAgIr3EnhWzn4YGctrLa+XgHkM+6kb9XA=
Message-ID: <f8cbd31f-3512-47c2-a046-1fd398df13e3@arm.com>
Date: Tue, 6 Oct 2026 07:16:56 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 09/23] KVM: arm64: Prevent unsupported vcpu features
 for VM types
Content-Language: en-GB
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
 <20261005090754.2140522-10-suzuki.poulose@arm.com>
 <32c662e1-0de9-44a7-81e5-2b1e6c824114@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <32c662e1-0de9-44a7-81e5-2b1e6c824114@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 06/10/2026 03:25, Gavin Shan wrote:
> On 10/5/26 7:07 PM, Suzuki K Poulose wrote:
>> Prevent unsupported VCPU features for the protected VCPUs. Realms and 
>> pVMs
>> not support 32bit EL1 or NV yet. pKVM doesn't rely on the host vcpu
>> features and it clears the unsupported features while hyp_vcpu is
>> initialised. Block the features early in the vcpu init if we detect
>> incompatible features.
>>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>   arch/arm64/kvm/arm.c | 10 ++++++----
>>   1 file changed, 6 insertions(+), 4 deletions(-)
>>
> 
> One nitpick below. In either way:
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>

Thanks !

> 
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index f31d31fa27ad9..9c2ef7ca6a961 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -1668,11 +1668,12 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, 
>> struct kvm_irq_level *irq_level,
>>       return -EINVAL;
>>   }
>> -static unsigned long system_supported_vcpu_features(void)
>> +static unsigned long system_supported_vcpu_features(struct kvm_vcpu 
>> *vcpu)
>>   {
>>       unsigned long features = KVM_VCPU_VALID_FEATURES;
>> -    if (!cpus_have_final_cap(ARM64_HAS_32BIT_EL1))
>> +    if (vcpu_is_protected(vcpu) ||
>> +        !cpus_have_final_cap(ARM64_HAS_32BIT_EL1))
>>           clear_bit(KVM_ARM_VCPU_EL1_32BIT, &features);
>>       if (!kvm_supports_guest_pmuv3()) {
>> @@ -1688,7 +1689,8 @@ static unsigned long 
>> system_supported_vcpu_features(void)
>>           clear_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, &features);
>>       }
>> -    if (!cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
>> +    if (vcpu_is_protected(vcpu) ||
>> +        !cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
>>           clear_bit(KVM_ARM_VCPU_HAS_EL2, &features);
>>       return features;
>> @@ -1708,7 +1710,7 @@ static int kvm_vcpu_init_check_features(struct 
>> kvm_vcpu *vcpu,
>>               return -ENOENT;
>>       }
>> -    if (features & ~system_supported_vcpu_features())
>> +    if (features & ~system_supported_vcpu_features(vcpu))
>>           return -EINVAL;
>>
> 
> The following check at the beginning of kvm_vcpu_init_check_features() 
> is redundant to
> the check here. We can drop that in this patch or a preparatory patch.
> 
> static int kvm_vcpu_init_check_features(...)
> {
>         /*
>          * This check can be dropped since the same check has been done
>      * by the followup "if (features & 
> ~system_supported_vcpu_features(vcpu))"
>          */
>         if (features & ~KVM_VCPU_VALID_FEATURES)
>                  return -ENOENT;

We could, but the errno is different with -ENOENT vs -EINVAL, with a
relevant meaning. So I would leave that alone.

Cheers
Suzuki
