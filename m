Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA5B12DC791;
	Fri, 20 Mar 2026 16:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774024765; cv=none; b=Pm5AeNuZgGKsBV4+HbB67/Dup8vPO5BZ4G3kvRPne8EOPU+p23/KZA2kdHTdPtvSs8F81/5ch+YAev9BByYdP4Va4ijnu1BIyvAL93Ldy1PZMYOstgZqbO6Tq6V+oPUH4cZvyiyaWoZiRZY6NAWbKcqRkyEQRgfP+0Mnx/1c4hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774024765; c=relaxed/simple;
	bh=E3dCiClnQemoe20ySw2frD7EM1AeKLqJmvTYJV/veJ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cJsWqrKYxTnqlf9Kn++aWBT/JuRpT2sx7yshIxAfnqTfVO1CzbG4Uy32ufCnDoAKSRE0kSz5kplcc2R5c7WJAgHsFytMOEyXRlTNOoDicTvbCLlknNxCn02OOpoH8rTass6Qw6IxRMsazBUaZ6xxt3VNqpvbxJvj18OYXHHqKO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 46592165C;
	Fri, 20 Mar 2026 09:39:17 -0700 (PDT)
Received: from [10.1.29.20] (e122027.cambridge.arm.com [10.1.29.20])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 415983F7BD;
	Fri, 20 Mar 2026 09:39:19 -0700 (PDT)
Message-ID: <33150925-095a-485f-83a9-34b6fb9fbd6a@arm.com>
Date: Fri, 20 Mar 2026 16:39:16 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 23/48] KVM: arm64: Expose support for private memory
To: Wei-Lin Chang <weilin.chang@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260318155413.793430-24-steven.price@arm.com>
 <ea5hsyyhitiemen6hsacrig3g72igi3rgms3ja2n7jlhumsjjh@mkkk65t4to2p>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <ea5hsyyhitiemen6hsacrig3g72igi3rgms3ja2n7jlhumsjjh@mkkk65t4to2p>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 19/03/2026 19:01, Wei-Lin Chang wrote:
> On Wed, Mar 18, 2026 at 03:53:47PM +0000, Steven Price wrote:
>> Select KVM_GENERIC_MEMORY_ATTRIBUTES and provide the necessary support
>> functions.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v12:
>>  * Only define kvm_arch_has_private_mem() when
>>    CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES is set to avoid build issues
>>    when KVM is disabled.
>> Changes since v10:
>>  * KVM_GENERIC_PRIVATE_MEM replacd with KVM_GENERIC_MEMORY_ATTRIBUTES.
>> Changes since v9:
>>  * Drop the #ifdef CONFIG_KVM_PRIVATE_MEM guard from the definition of
>>    kvm_arch_has_private_mem()
>> Changes since v2:
>>  * Switch kvm_arch_has_private_mem() to a macro to avoid overhead of a
>>    function call.
>>  * Guard definitions of kvm_arch_{pre,post}_set_memory_attributes() with
>>    #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES.
>>  * Early out in kvm_arch_post_set_memory_attributes() if the WARN_ON
>>    should trigger.
>> ---
>>  arch/arm64/include/asm/kvm_host.h |  4 ++++
>>  arch/arm64/kvm/Kconfig            |  1 +
>>  arch/arm64/kvm/mmu.c              | 24 ++++++++++++++++++++++++
>>  3 files changed, 29 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 64304848aad4..1efea996f474 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -1486,6 +1486,10 @@ struct kvm *kvm_arch_alloc_vm(void);
>>  
>>  #define vcpu_is_protected(vcpu)		kvm_vm_is_protected((vcpu)->kvm)
>>  
>> +#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
>> +#define kvm_arch_has_private_mem(kvm) ((kvm)->arch.is_realm)
>> +#endif
>> +
>>  int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
>>  bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
>>  
>> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
>> index 4f803fd1c99a..1cac6dfc0972 100644
>> --- a/arch/arm64/kvm/Kconfig
>> +++ b/arch/arm64/kvm/Kconfig
>> @@ -38,6 +38,7 @@ menuconfig KVM
>>  	select SCHED_INFO
>>  	select GUEST_PERF_EVENTS if PERF_EVENTS
>>  	select KVM_GUEST_MEMFD
>> +	select KVM_GENERIC_MEMORY_ATTRIBUTES
> 
> Hi,
> 
> I believe we should also add this:
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index bfa0ab343081..13722f876dcd 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6365,7 +6365,7 @@ Returns -EINVAL if called on a protected VM.
>  -------------------------------
>  
>  :Capability: KVM_CAP_MEMORY_ATTRIBUTES
> -:Architectures: x86
> +:Architectures: x86, arm64
>  :Type: vm ioctl
>  :Parameters: struct kvm_memory_attributes (in)
>  :Returns: 0 on success, <0 on error

Good spot.

Thanks,
Steve

> 
> Thanks,
> Wei-Lin Chang
> 
>>  	help
>>  	  Support hosting virtualized guest machines.
>>  
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index b705ad6c6c8b..bad93938acdb 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -2494,6 +2494,30 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>>  	return ret;
>>  }
>>  
>> +#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
>> +bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
>> +					struct kvm_gfn_range *range)
>> +{
>> +	WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm));
>> +	return false;
>> +}
>> +
>> +bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
>> +					 struct kvm_gfn_range *range)
>> +{
>> +	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
>> +		return false;
>> +
>> +	if (range->arg.attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE)
>> +		range->attr_filter = KVM_FILTER_SHARED;
>> +	else
>> +		range->attr_filter = KVM_FILTER_PRIVATE;
>> +	kvm_unmap_gfn_range(kvm, range);
>> +
>> +	return false;
>> +}
>> +#endif
>> +
>>  void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
>>  {
>>  }
>> -- 
>> 2.43.0
>>

