Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 030A93C3429;
	Thu, 10 Sep 2026 10:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789035698; cv=none; b=oDrwjZ1ZjQNLDK5Gz2zNTs19JtREuQD9UQlsCV1YDHIY2K5lFfflhszkeuBEg085+SFuOD+u1VTvKXmnJXwj6/CG+Uh71ErQOVLawAOJ7hVuVD8T3MQMYaYC2XMaWpHXTFS+wvhE/Lgrz4OshHV7vTLQhfKKV8KOsDPBb7AILkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789035698; c=relaxed/simple;
	bh=NdJwICU4hKphndkhJfKo4meJGdIZvN650SafLlOB/BM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nIW9QmwO50LmRXoLs/2p8lVvlD2f9/XXepG/r8mjWRciSxhuqX6P/Bz1QEvQorWynR9hNl9MT4hMlmidRR88f4KI+zdH+BvlJICCI9CPhgJBUnrZsSkinCA+IC+Ey5Gvnk0/RWeaXvvq6aWACJhGPMeqFdbV0GogtF2lyURDeXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=k//7Ud38; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="k//7Ud38"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 51C7D143D;
	Thu, 10 Sep 2026 03:21:31 -0700 (PDT)
Received: from [10.0.129.245] (unknown [10.0.129.245])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 899BA3F7B4;
	Thu, 10 Sep 2026 03:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789035695; bh=NdJwICU4hKphndkhJfKo4meJGdIZvN650SafLlOB/BM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=k//7Ud38dQTnvnKQxVZAcd73FhyR9Iv9bKLlrmoT04DSSuniGXJGJi8nFSmCLEuE8
	 fX11Ow/pTfdIBC/fgh+DTGC9ZRproSkmFOyVb9rmmwngQfXyaH/MYJCYNZcxFenoQH
	 YnDm/TS+rtBLyZhhM83WRgOUSjTOe3zhZn+o0zjo=
Message-ID: <b7a8e864-d7a3-4765-8b62-c5452766769d@arm.com>
Date: Thu, 10 Sep 2026 11:21:29 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 04/20] KVM: arm64: Refactor the vcpu_load to allow for
 VM specific callbacks
Content-Language: en-GB
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
 <20260908162223.1683432-5-suzuki.poulose@arm.com>
 <a0c5c373-b5c2-4ad2-9e53-ede58c392972@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <a0c5c373-b5c2-4ad2-9e53-ede58c392972@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/09/2026 05:00, Gavin Shan wrote:
> Hi Suzuki,
> 
> On 9/9/26 2:22 AM, Suzuki K Poulose wrote:
>> Based on a work by Marc Zyngier
>>
>> To keep the VCPU load/put handling cleaner with the different kinds of 
>> VM types,
>> we are about to introduce VM specific callbacks to do just the right 
>> thing.
>> In preparation for that, make some refactoring to add the change easier.
>>
>> No functional changes intended.
>>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>   arch/arm64/kvm/arm.c | 46 +++++++++++++++++++++++++++-----------------
>>   1 file changed, 28 insertions(+), 18 deletions(-)
>>
> 
> Nitpicks below, none of them are introduced by this patch itself. In 
> either way:
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>

Thank you !

> 
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 67f1ff9bc4fbe..51fc651267157 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -683,14 +683,11 @@ static bool kvm_vcpu_should_clear_twe(struct 
>> kvm_vcpu *vcpu)
>>       return single_task_running();
>>   }
>> -void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>> +static void vcpu_prepare_mmu(struct kvm_vcpu *vcpu)
>>   {
>>       struct kvm_s2_mmu *mmu;
>>       int *last_ran;
>> -    if (is_protected_kvm_enabled())
>> -        goto nommu;
>> -
>>       if (vcpu_has_nv(vcpu))
>>           kvm_vcpu_load_hw_mmu(vcpu);
>> @@ -720,10 +717,33 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, 
>> int cpu)
>>           kvm_call_hyp(__kvm_flush_cpu_context, mmu);
>>           *last_ran = vcpu->vcpu_idx;
>>       }
>> +}
>> +
>> +static void vcpu_set_wfx_traps(struct kvm_vcpu *vcpu)
>> +{
>> +    if (kvm_vcpu_should_clear_twe(vcpu))
>> +        vcpu->arch.hcr_el2 &= ~HCR_TWE;
>> +    else
>> +        vcpu->arch.hcr_el2 |= HCR_TWE;
>> +
>> +    if (kvm_vcpu_should_clear_twi(vcpu))
>> +        vcpu->arch.hcr_el2 &= ~HCR_TWI;
>> +    else
>> +        vcpu->arch.hcr_el2 |= HCR_TWI;
>> +}
>> +
> 
> It seems FIELD_MODIFY() can be applied here if no visible constraints 
> exist:
> 
>      FIELD_MODIFY(HCR_TWE, vcpu->arch.hcr_el2, ! 
> kvm_vcpu_should_clear_twe(vcpu));
>      FIELD_MODIFY(HCR_TWI, vcpu->arch.hcr_el2, ! 
> kvm_vcpu_should_clear_twi(vcpu));

I would leave this out for now. Can be a separate patch

> 
>> +static void vcpu_load_pvtime(struct kvm_vcpu *vcpu)
>> +{
>> +    if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
>> +        kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
>> +}
>> +
>> +void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>> +{
>> +    if (!is_protected_kvm_enabled())
>> +        vcpu_prepare_mmu(vcpu);
>>
> 
> I think we probably try to depend on kvm->arch.vm_flavor instead
> of !is_protected_kvm_enabled().
> 
>      struct kvm *kvm = vcpu->kvm;
> 
>      if (kvm_vm_is_protected(kvm) || kvm_vm_flavor_eq(kvm, VM_PKVM))
>          vcpu_prepare_mmu(vcpu);

This will be removed as part of the call back in the next patch.

Cheers
Suzuki
