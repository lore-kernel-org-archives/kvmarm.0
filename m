Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8190F3D88FC;
	Fri, 10 Apr 2026 15:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775833935; cv=none; b=g23wJvtyjnfWzcfNuVgwqFp7ZyJhTmd4CtnuwO0Pu4ULxqry5tQlBsuutCadgw8WQIUqHIaghKYrg/qg1SIiqdU7Y4zrrv3T63mko26H0yvRD6KcvT+rjOgi+c64ptoqns9UWAQfVkLlJRdE4drZyOumaDxaptj1m9Qmm7zCVQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775833935; c=relaxed/simple;
	bh=GJKcHTezPstrZHtfO15ScOCgcXew2OM8/KUMjRAZidQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OW/R86Dr7A7c0K9ttu92meliZM/6M/OGawKRTUX3EZWwkqtmZHr0TYNt67vOISm7CARDIrGM6v9PnVu9WJ/50ISd2tbuKzUxXkrMWED0wu/VE17hP2PU73C6FMFpc5oLomelIcZ5tI+lPP2fhJ6jCVbdqEBlTK8geVnrCMtHoGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QnNDrSZN; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QnNDrSZN"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 536F01CE2;
	Fri, 10 Apr 2026 08:12:07 -0700 (PDT)
Received: from [10.1.29.18] (e122027.cambridge.arm.com [10.1.29.18])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 25E513FAA1;
	Fri, 10 Apr 2026 08:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775833933; bh=GJKcHTezPstrZHtfO15ScOCgcXew2OM8/KUMjRAZidQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QnNDrSZNUzYW/9X57giTRgy3j3izu/JL37kvNQVkk3HfGfFTTYVLTzc+VKrrGKHQ2
	 sghnshPzg7CRgelAd9jTPw6uhj6OlF4HZVCk1KRFVYcniSC0w9iAMTouf6gXq+b33V
	 siT7P8g5+ChI8QW5j5triYs4S5BA1leyEpwB5Dlc=
Message-ID: <04db668a-bb9e-40e4-b974-ba3a6a14bda1@arm.com>
Date: Fri, 10 Apr 2026 16:12:08 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 24/48] arm64: RMI: Allow populating initial contents
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
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260318155413.793430-25-steven.price@arm.com>
 <7ab3dcd2-23b9-45a6-84ef-9617c4614c0a@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <7ab3dcd2-23b9-45a6-84ef-9617c4614c0a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 23/03/2026 11:32, Suzuki K Poulose wrote:
> On 18/03/2026 15:53, Steven Price wrote:
>> The VMM needs to populate the realm with some data before starting (e.g.
>> a kernel and initrd). This is measured by the RMM and used as part of
>> the attestation later on.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v12:
>>   * The ioctl now updates the structure with the amount populated rather
>>     than returning this through the ioctl return code.
>>   * Use the new RMM v2.0 range based RMI calls.
>>   * Adapt to upstream changes in kvm_gmem_populate().
>> Changes since v11:
>>   * The multiplex CAP is gone and there's a new ioctl which makes use of
>>     the generic kvm_gmem_populate() functionality.
>> Changes since v7:
>>   * Improve the error codes.
>>   * Other minor changes from review.
>> Changes since v6:
>>   * Handle host potentially having a larger page size than the RMM
>>     granule.
>>   * Drop historic "par" (protected address range) from
>>     populate_par_region() - it doesn't exist within the current
>>     architecture.
>>   * Add a cond_resched() call in kvm_populate_realm().
>> Changes since v5:
>>   * Refactor to use PFNs rather than tracking struct page in
>>     realm_create_protected_data_page().
>>   * Pull changes from a later patch (in the v5 series) for accessing
>>     pages from a guest memfd.
>>   * Do the populate in chunks to avoid holding locks for too long and
>>     triggering RCU stall warnings.
>> ---
>>   arch/arm64/include/asm/kvm_rmi.h |   4 ++
>>   arch/arm64/kvm/Kconfig           |   1 +
>>   arch/arm64/kvm/arm.c             |  13 ++++
>>   arch/arm64/kvm/rmi.c             | 111 +++++++++++++++++++++++++++++++
>>   4 files changed, 129 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/
>> asm/kvm_rmi.h
>> index 46b0cbe6c202..bf663bb240c4 100644
>> --- a/arch/arm64/include/asm/kvm_rmi.h
>> +++ b/arch/arm64/include/asm/kvm_rmi.h
>> @@ -96,6 +96,10 @@ int kvm_rec_enter(struct kvm_vcpu *vcpu);
>>   int kvm_rec_pre_enter(struct kvm_vcpu *vcpu);
>>   int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_status);
>>   +struct kvm_arm_rmi_populate;
>> +
>> +int kvm_arm_rmi_populate(struct kvm *kvm,
>> +             struct kvm_arm_rmi_populate *arg);
>>   void kvm_realm_unmap_range(struct kvm *kvm,
>>                  unsigned long ipa,
>>                  unsigned long size,
>> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
>> index 1cac6dfc0972..b495dfd3a8b4 100644
>> --- a/arch/arm64/kvm/Kconfig
>> +++ b/arch/arm64/kvm/Kconfig
>> @@ -39,6 +39,7 @@ menuconfig KVM
>>       select GUEST_PERF_EVENTS if PERF_EVENTS
>>       select KVM_GUEST_MEMFD
>>       select KVM_GENERIC_MEMORY_ATTRIBUTES
>> +    select HAVE_KVM_ARCH_GMEM_POPULATE
>>       help
>>         Support hosting virtualized guest machines.
>>   diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index badb94b398bc..43d05da7e694 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -2089,6 +2089,19 @@ int kvm_arch_vm_ioctl(struct file *filp,
>> unsigned int ioctl, unsigned long arg)
>>               return -EFAULT;
>>           return kvm_vm_ioctl_get_reg_writable_masks(kvm, &range);
>>       }
>> +    case KVM_ARM_RMI_POPULATE: {
>> +        struct kvm_arm_rmi_populate req;
>> +        int ret;
>> +
>> +        if (!kvm_is_realm(kvm))
>> +            return -ENXIO;
>> +        if (copy_from_user(&req, argp, sizeof(req)))
>> +            return -EFAULT;
>> +        ret = kvm_arm_rmi_populate(kvm, &req);
>> +        if (copy_to_user(argp, &req, sizeof(req)))
>> +            return -EFAULT;
>> +        return ret;
>> +    }
>>       default:
>>           return -EINVAL;
>>       }
>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index 13eed6f0b9eb..b48f4e12e4e0 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
>> @@ -718,6 +718,80 @@ void kvm_realm_unmap_range(struct kvm *kvm,
>> unsigned long start,
>>           realm_unmap_private_range(kvm, start, end, may_block);
>>   }
>>   +static int realm_create_protected_data_page(struct kvm *kvm,
> 
> minor nit: To align with the RMM ABI, could we rename this to :
> 
>     realm_data_map_init() ?

Makes sense - I have to admit there is a bit of cruft in some of the
names because the spec keeps changing ;)

>> +                        unsigned long ipa,
>> +                        kvm_pfn_t dst_pfn,
>> +                        kvm_pfn_t src_pfn,
>> +                        unsigned long flags)
>> +{
>> +    struct realm *realm = &kvm->arch.realm;
>> +    phys_addr_t rd = virt_to_phys(realm->rd);
>> +    phys_addr_t dst_phys, src_phys;
>> +    int ret;
>> +
>> +    dst_phys = __pfn_to_phys(dst_pfn);
>> +    src_phys = __pfn_to_phys(src_pfn);
>> +
>> +    if (delegate_page(dst_phys))
>> +        return -ENXIO;
>> +
>> +    ret = rmi_rtt_data_map_init(rd, dst_phys, ipa, src_phys, flags);
>> +    if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
>> +        /* Create missing RTTs and retry */
>> +        int level = RMI_RETURN_INDEX(ret);
>> +
>> +        KVM_BUG_ON(level == RMM_RTT_MAX_LEVEL, kvm);
> 
> A buggy VMM can trigger this by calling RMI_POPULATE twice ? Should we
> return -ENXIO here rather ? The delegate_page() above could prevent
> normal cases, but is the VMM allowed to somehow trigger a "pfn" change
> backing the KVM ? Either way, this need not be Fatal ?

I believe KVM_BUG_ON is only fatal to the VM - it won't take down the
host (KVM_BUG_ON_DATA_CORRUPTION() is for that). AFAICT the
delegate_page() check should catch this case, but in the event that it
doesn't then this will kill the VM but otherwise recover.

Of course if it turns out there is a way of a VMM hitting this we might
need to tone down the error handling to something a bit quieter. But I
think it would also be good to get an understanding of how this can happen.

Thanks,
Steve

> Otherwise looks good to me.
> 
> Suzuki
> 
> 
>> +
>> +        ret = realm_create_rtt_levels(realm, ipa, level,
>> +                          RMM_RTT_MAX_LEVEL, NULL);
>> +        if (!ret) {
>> +            ret = rmi_rtt_data_map_init(rd, dst_phys, ipa, src_phys,
>> +                            flags);
>> +        }
>> +    }
>> +
>> +    if (ret) {
>> +        if (WARN_ON(undelegate_page(dst_phys))) {
>> +            /* Undelegate failed, so we leak the page */
>> +            get_page(pfn_to_page(dst_pfn));
>> +        }
>> +    }
>> +
>> +    return ret;
>> +}
>> +
>> +static int populate_region_cb(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>> +                  struct page *src_page, void *opaque)
>> +{
>> +    unsigned long data_flags = *(unsigned long *)opaque;
>> +    phys_addr_t ipa = gfn_to_gpa(gfn);
>> +
>> +    if (!src_page)
>> +        return -EOPNOTSUPP;
>> +
>> +    return realm_create_protected_data_page(kvm, ipa, pfn,
>> +                        page_to_pfn(src_page),
>> +                        data_flags);
>> +}
>> +
>> +static long populate_region(struct kvm *kvm,
>> +                gfn_t base_gfn,
>> +                unsigned long pages,
>> +                u64 uaddr,
>> +                unsigned long data_flags)
>> +{
>> +    long ret = 0;
>> +
>> +    mutex_lock(&kvm->slots_lock);
>> +    mmap_read_lock(current->mm);
>> +    ret = kvm_gmem_populate(kvm, base_gfn, u64_to_user_ptr(uaddr),
>> pages,
>> +                populate_region_cb, &data_flags);
>> +    mmap_read_unlock(current->mm);
>> +    mutex_unlock(&kvm->slots_lock);
>> +
>> +    return ret;
>> +}
>> +
>>   enum ripas_action {
>>       RIPAS_INIT,
>>       RIPAS_SET,
>> @@ -815,6 +889,43 @@ static int realm_ensure_created(struct kvm *kvm)
>>       return -ENXIO;
>>   }
>>   +int kvm_arm_rmi_populate(struct kvm *kvm,
>> +             struct kvm_arm_rmi_populate *args)
>> +{
>> +    unsigned long data_flags = 0;
>> +    unsigned long ipa_start = args->base;
>> +    unsigned long ipa_end = ipa_start + args->size;
>> +    long pages_populated;
>> +    int ret;
>> +
>> +    if (args->reserved ||
>> +        (args->flags & ~KVM_ARM_RMI_POPULATE_FLAGS_MEASURE) ||
>> +        !IS_ALIGNED(ipa_start, PAGE_SIZE) ||
>> +        !IS_ALIGNED(ipa_end, PAGE_SIZE) ||
>> +        !IS_ALIGNED(args->source_uaddr, PAGE_SIZE))
>> +        return -EINVAL;
>> +
>> +    ret = realm_ensure_created(kvm);
>> +    if (ret)
>> +        return ret;
>> +
>> +    if (args->flags & KVM_ARM_RMI_POPULATE_FLAGS_MEASURE)
>> +        data_flags |= RMI_MEASURE_CONTENT;
>> +
>> +    pages_populated = populate_region(kvm, gpa_to_gfn(ipa_start),
>> +                      args->size >> PAGE_SHIFT,
>> +                      args->source_uaddr, data_flags);
>> +
>> +    if (pages_populated < 0)
>> +        return pages_populated;
>> +
>> +    args->size -= pages_populated << PAGE_SHIFT;
>> +    args->source_uaddr += pages_populated << PAGE_SHIFT;
>> +    args->base += pages_populated << PAGE_SHIFT;
>> +
>> +    return 0;
>> +}
>> +
>>   static void kvm_complete_ripas_change(struct kvm_vcpu *vcpu)
>>   {
>>       struct kvm *kvm = vcpu->kvm;
> 

