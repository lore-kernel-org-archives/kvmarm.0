Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09E643CB542;
	Thu, 10 Sep 2026 06:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789022163; cv=none; b=PA6i2Oab54v3mZbG2L2ZgJlUq03reMb2oPVy6MOXdLza8x8H/0oaT0Pvu5mLMYEohquNuiytvEDM+d7x9TEOutepU21CRIpSrGp8uWLaMBJeFZNjnTraFCd3Qk6XRPRHdwpIkLdZekwTxgPAoLXtlPVvnEa+HPEOGvngE2K2xX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789022163; c=relaxed/simple;
	bh=kumzXJBqaaaXDeADdZjd0wn2AlS+mSdcuauVEB3m0SI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hnsttTCuJwZhUYey503aKkeyF9XYsnIyZ2lv0hu39Leq0+c17ndbwYRypkWcS+KEoh0kFnXVLiqs6iDlFJqH15ZnZ6cJlXMf5oPSFE2+yU7GKIz1YHBwVvywre+DC7v+ehjjEyG/WEe5nu8QXLpp3xp1J7BZjqjJVrWXA/HLIFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qF5OLKKu; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qF5OLKKu"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D40751570;
	Wed,  9 Sep 2026 23:35:52 -0700 (PDT)
Received: from [10.57.8.56] (unknown [10.57.8.56])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E11703F7B4;
	Wed,  9 Sep 2026 23:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789022156; bh=kumzXJBqaaaXDeADdZjd0wn2AlS+mSdcuauVEB3m0SI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qF5OLKKuz5yjN123Vu3aY3Ez3e3J7MqGqqChZHjho0jgPyGoOTVyJVQ93PhNsTP/d
	 ZRoZgAeFWG3kJEQY79JbZlpRyws55gl2DJJ63aXMXDnpRINvaZ7kmHaZe/9OkubJEt
	 IIkFa7X4pIfEdVb/YlhxmvzQRi4CPsggJPsoOCCU=
Message-ID: <92ab372a-0db0-46fe-bbfe-03649e18de37@arm.com>
Date: Thu, 10 Sep 2026 07:35:52 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 03/20] KVM: arm64: Track the type of VM in kvm_arch
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
 <20260908162223.1683432-4-suzuki.poulose@arm.com>
 <3cd34b9c-7500-4993-86ff-c1ee9a86b601@redhat.com>
Content-Language: en-GB
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <3cd34b9c-7500-4993-86ff-c1ee9a86b601@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/09/2026 04:39, Gavin Shan wrote:
> Hi Suzuki,
> 
> On 9/9/26 2:22 AM, Suzuki K Poulose wrote:
>> KVM arm64 has different types of VMs with all the different modes in 
>> which the
>> hypervisor code can be run. e.g., VHE, nVHE, PKVM etc. Then there is 
>> protected
>> VM and normal VMs with PKVM. We might soon add other types, e.g., Arm 
>> CCA Realm.
>> So in an effort to make the handling of these different types of VMs a 
>> bit more
>> friendlier to the eyes, add a VM flavor to the kvm_arch and we could 
>> then add
>> handlers for different operations based on the VM type.
>>
>> Keep the flavor initialisation at the beginning to allow for the 
>> detection
>> early enough and fail out on any unsupported requests. (e.g., 
>> protected on !PKVM)
>>
>> With that, use the vm_flavor to detect if a VM is protected VM on PKVM.
>>
>> Based on a patch by Marc Zyngier
>>
>> Suggested-by: Marc Zyngier <maz@kernel.org>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>   arch/arm64/include/asm/kvm_host.h | 12 ++++++++++--
>>   arch/arm64/kvm/arm.c              | 27 ++++++++++++++++++++++++---
>>   arch/arm64/kvm/hyp/nvhe/pkvm.c    |  2 +-
>>   arch/arm64/kvm/pkvm.c             |  1 -
>>   4 files changed, 35 insertions(+), 7 deletions(-)
>>
> 
> Some nitpicks below. In either way:
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> 
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/ 
>> asm/kvm_host.h
>> index 27fe0cd5b2d7a..d0dccc9ad6aa8 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -257,7 +257,6 @@ struct kvm_protected_vm {
>>       pkvm_handle_t handle;
>>       struct kvm_hyp_memcache teardown_mc;
>>       struct kvm_hyp_memcache stage2_teardown_mc;
>> -    bool is_protected;
>>       bool is_created;
>>       /*
>> @@ -306,9 +305,18 @@ enum fgt_group_id {
>>       __NR_FGT_GROUP_IDS__
>>   };
>> +enum kvm_arm_vm_flavor {
>> +    VM_NVHE,
>> +    VM_VHE,
>> +    VM_PKVM,        /* Normal guests on PKVM */
>> +    VM_PROTECTED_PKVM,    /* Protected VM */
>> +    VM_FLAVOR_MAX,
>> +};
>> +
>>   struct kvm_arch {
>>       struct kvm_s2_mmu mmu;
>> +    enum kvm_arm_vm_flavor vm_flavor;
>>       /*
>>        * Fine-Grained UNDEF, mimicking the FGT layout defined by the
>>        * architecture. We track them globally, as we present the
>> @@ -1504,7 +1512,7 @@ struct kvm *kvm_arch_alloc_vm(void);
>>   #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
>> -#define kvm_vm_is_protected(kvm)    (is_protected_kvm_enabled() && 
>> (kvm)->arch.pkvm.is_protected)
>> +#define kvm_vm_is_protected(kvm)    ((kvm)->arch.vm_flavor == 
>> VM_PROTECTED_PKVM)
> 
> Here we may introduce one more helper for generic use cases. It's going to
> be used in kvm_arch_init_vm().
> 
> #define kvm_vm_flavor_eq(kvm, flavor)    ((kvm)->arch.vm_flaor == (flavor))
> #define kvm_vm_is_protected(kvm)    kvm_vm_flavor_eq(kvm, 
> VM_PROTECTED_PKVM)

see below.

> 
>>   #define vcpu_is_protected(vcpu)        kvm_vm_is_protected((vcpu)->kvm)
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 8b080804bc90b..67f1ff9bc4fbe 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -214,6 +214,26 @@ static int kvm_arm_default_max_vcpus(void)
>>       return vgic_present ? kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
>>   }
>> +static int kvm_init_vm_flavor(struct kvm *kvm, unsigned long type)
>> +{
>> +    bool protected = type & KVM_VM_TYPE_ARM_PROTECTED;
>> +
>> +    if (is_protected_kvm_enabled()) {
>> +        if (protected)
>> +            kvm->arch.vm_flavor = VM_PROTECTED_PKVM;
>> +        else
>> +            kvm->arch.vm_flavor = VM_PKVM;
>> +    } else if (protected) {
>> +        return -EINVAL;
>> +    } else if (has_vhe()) {
>> +        kvm->arch.vm_flavor = VM_VHE;
>> +    } else {
>> +        kvm->arch.vm_flavor = VM_NVHE;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>>   /**
>>    * kvm_arch_init_vm - initializes a VM data structure
>>    * @kvm:    pointer to the KVM struct
>> @@ -236,6 +256,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned 
>> long type)
>>       mutex_unlock(&kvm->lock);
>>   #endif
>> +    ret = kvm_init_vm_flavor(kvm, type);
>> +    if (ret)
>> +        return ret;
>> +
>>       kvm_init_nested(kvm);
>>       ret = kvm_share_hyp(kvm, kvm + 1);
>> @@ -260,9 +284,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned 
>> long type)
>>           ret = pkvm_init_host_vm(kvm, type);
>>           if (ret)
>>               goto err_uninit_mmu;
>> -    } else if (type & KVM_VM_TYPE_ARM_PROTECTED) {
>> -        ret = -EINVAL;
>> -        goto err_uninit_mmu;
>>       }
>>       kvm_vgic_early_init(kvm);
> 
> We needn't depend on is_protected_kvm_enabled() to call 
> pkvm_init_host_vm() because
> the output of is_protected_kvm_enabled() has been updated to kvm- 
>  >arch.vm_flavor
> by previous call kvm_init_vm_flavor().

TBH, thats a faster way to check if we are running on PKVM. I could
add something linke kvm_vm_has_pkvm(kvm) which covers both VM_PKVM and
VM_PROTECTED_PKVM.

> 
>      if (kvm_vm_is_protected(kvm) || kvm_vm_flavor_eq(kvm, VM_PKVM)) {
>          ret = pkvm_init_host_vm(kvm, type);
>          if (ret)
>              goto err_unit_mmu;
>      }

And I can drop the type fron pkvm_init_host_vm with suggestion below.

Cheers
Suzuki

> 
>> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/ 
>> pkvm.c
>> index 459bd9eb7e4bc..09961c0056f2b 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
>> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
>> @@ -432,7 +432,7 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, 
>> struct pkvm_hyp_vm *hyp_vm,
>>       hyp_vm->host_kvm = host_kvm;
>>       hyp_vm->kvm.created_vcpus = nr_vcpus;
>> -    hyp_vm->kvm.arch.pkvm.is_protected = READ_ONCE(host_kvm- 
>> >arch.pkvm.is_protected);
>> +    hyp_vm->kvm.arch.vm_flavor = READ_ONCE(host_kvm->arch.vm_flavor);
>>       hyp_vm->kvm.arch.flags = 0;
>>       pkvm_init_features_from_host(hyp_vm, host_kvm);
>> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
>> index 8e4c6e4bec123..3948fa46f4d75 100644
>> --- a/arch/arm64/kvm/pkvm.c
>> +++ b/arch/arm64/kvm/pkvm.c
>> @@ -240,7 +240,6 @@ int pkvm_init_host_vm(struct kvm *kvm, unsigned 
>> long type)
>>           return ret;
>>       kvm->arch.pkvm.handle = ret;
>> -    kvm->arch.pkvm.is_protected = protected;
>>       if (protected) {
>>           pr_warn_once("kvm: protected VMs are experimental and for 
>> development only, tainting kernel\n");
>>           add_taint(TAINT_USER, LOCKDEP_STILL_OK);
> 
> In pkvm_init_host_vm(), the local variable 'protected' is used for once
> and can be removed by:
> 
>      if (kvm_vm_is_protected(kvm)) {
>          pr_warn_once(...);
>          add_taint(...);
>      }
> 
> Thanks,
> Gavin
> 

