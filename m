Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2664F22F770;
	Wed, 21 May 2025 10:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747822883; cv=none; b=SsqFHqtCT5evJ487tpVGNcvsnFcmQDwxXbzqyvL61MOFHUQsus/hMkjZb+/aOexylOiegn5FDOgwZIjKZx6jkoCecl9ZNQIDVbuzy1leBl9S5+/4xYXdYuunlqILiZLGrctCPTlNJ10YGY/buYMU40Gigjv/B3Nq8erCDMjlIoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747822883; c=relaxed/simple;
	bh=O0M/Knc1SstOgP9f+/1lfj76rztByzOvmpyIseFRX8w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o+ZeuMRUdO+1f9fPkq7t2acs5MpfTi2b2Lc2/wok+JKVDn8KogR2ZSBK/NoGqpvCTGxmsDj2OZKu1Pd4euTU9JLLFLVYOsybvIEYffQ4OzChgDuFwPI0faHgEDRVV7iD6VIZxf6mNtW8ASBp/HcyDHMuJ6/8F1DpOzEN9Rk2GqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 962AF1515;
	Wed, 21 May 2025 03:21:05 -0700 (PDT)
Received: from [10.57.23.70] (unknown [10.57.23.70])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 460CB3F6A8;
	Wed, 21 May 2025 03:21:15 -0700 (PDT)
Message-ID: <0906c39b-2e67-4f5f-86fb-aa8d5abde0ed@arm.com>
Date: Wed, 21 May 2025 11:21:13 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 21/43] KVM: arm64: Handle realm VCPU load
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-22-steven.price@arm.com>
 <9a09a3fe-c91c-457f-b6da-9fccbf98e649@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <9a09a3fe-c91c-457f-b6da-9fccbf98e649@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 19/05/2025 18:48, Suzuki K Poulose wrote:
> On 16/04/2025 14:41, Steven Price wrote:
>> When loading a realm VCPU much of the work is handled by the RMM so only
>> some of the actions are required. Rearrange kvm_arch_vcpu_load()
>> slightly so we can bail out early for a realm guest.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   arch/arm64/kvm/arm.c | 13 +++++++++----
>>   1 file changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index cf707130ef66..08d5e0d76749 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -644,10 +644,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu,
>> int cpu)
> 
> I think we use the pkvm hook to skip to the nommu goto, to avoid
> the VMID allocation and context flush.
> 
> 
>>       kvm_timer_vcpu_load(vcpu);
>>       kvm_vgic_load(vcpu);
>>       kvm_vcpu_load_debug(vcpu);
>> -    if (has_vhe())
>> -        kvm_vcpu_load_vhe(vcpu);
>> -    kvm_arch_vcpu_load_fp(vcpu);
>> -    kvm_vcpu_pmu_restore_guest(vcpu);
>>       if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
>>           kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
> 
> We could also move thise pvtime to the bottom too ?
> 
>>   @@ -671,6 +667,15 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu,
>> int cpu)
>>                    &vcpu->arch.vgic_cpu.vgic_v3);
>>       }
>>   +    /* No additional state needs to be loaded on Realmed VMs */
>> +    if (vcpu_is_rec(vcpu))
>> +        return;
>> +
>> +    if (has_vhe())
>> +        kvm_vcpu_load_vhe(vcpu);
>> +    kvm_arch_vcpu_load_fp(vcpu);
>> +    kvm_vcpu_pmu_restore_guest(vcpu);
>> +
> 
> With the above addressed:
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Thanks, the suggestions above seem sensible, I'll make those changes.

Thanks,
Steve

> 
> 
>>       if (!cpumask_test_cpu(cpu, vcpu->kvm->arch.supported_cpus))
>>           vcpu_set_on_unsupported_cpu(vcpu);
>>   }
> 

