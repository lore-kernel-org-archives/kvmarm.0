Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA9B82E7F0A;
	Mon,  8 Jun 2026 09:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780911384; cv=none; b=XmGbZAf5DpWyGTErPE6FvXpr56Shr75MRfZSwu003KPJUB/cz42T7fum67HmJ3jLGll2Ek94N9LNSg1Ws/3Ov6hPgR+PEr/ikMdzKomdDBU4wYn+tN2h0Fnj/W2lRIKJM0pjVOnG6v9cs/0KDlgGXnne2EjR5ffGl3ZHMoSDxAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780911384; c=relaxed/simple;
	bh=ptBDlnNoQB7aZGMNpR/K2NrWMUcuiU/2bNd4uG2P9Ds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CCBeECzrGVmsDk8i54nxCB3FmGEYvd3iRT4bJc3MS0MnK25ffctO1uYDF5kYwzDmNJBpiqe8s60d1Lrn95zjtpOH8ah+4n9U9A2JvCM++2aXMg0VFK5sjWOoULe1yOmmOF72JFr1owtuNDD+Dtogu4xqTzJCwEJKwbVssY5eBn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=B0aOHrMn; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="B0aOHrMn"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 364782403;
	Mon,  8 Jun 2026 02:36:17 -0700 (PDT)
Received: from [10.57.28.93] (unknown [10.57.28.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D15903F86F;
	Mon,  8 Jun 2026 02:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780911382; bh=ptBDlnNoQB7aZGMNpR/K2NrWMUcuiU/2bNd4uG2P9Ds=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=B0aOHrMn1wQ+AD09z+YNbPv8pr9VNorpnZTqJwtmXy0P+tLj7cuVkyrJFuQH2Ho7a
	 Aukof9amQe7l9icSEd2yyrwS90+GV17g7rkZYQdIEEkU0rYs83LJ7/xS0op07+C9RC
	 f0ntwypkLUd6sc2M1qkm19hj/WmlJnvrcfArIbIo=
Message-ID: <0c71b4b8-ad0b-4a24-9f4a-180b2aaacdb6@arm.com>
Date: Mon, 8 Jun 2026 10:36:14 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 26/44] arm64: RMI: Allow populating initial contents
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
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
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve
 <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-27-steven.price@arm.com>
 <ea4be6c5-9506-4253-80c5-c76c9ac3b77d@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <ea4be6c5-9506-4253-80c5-c76c9ac3b77d@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 28/05/2026 06:30, Gavin Shan wrote:
> Hi Steve,
> 
> On 5/13/26 11:17 PM, Steven Price wrote:
>> The VMM needs to populate the realm with some data before starting (e.g.
>> a kernel and initrd). This is measured by the RMM and used as part of
>> the attestation later on.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v13:
>>   * Rename realm_create_protected_data_page() to realm_data_map_init().
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
>>   arch/arm64/kvm/rmi.c             | 106 +++++++++++++++++++++++++++++++
>>   4 files changed, 124 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/
>> asm/kvm_rmi.h
>> index 007249a13dbc..a2b6bc412a22 100644
>> --- a/arch/arm64/include/asm/kvm_rmi.h
>> +++ b/arch/arm64/include/asm/kvm_rmi.h
>> @@ -88,6 +88,10 @@ int kvm_rec_enter(struct kvm_vcpu *vcpu);
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
>> index 4e16719fda22..d0cd011cf672 100644
>> --- a/arch/arm64/kvm/Kconfig
>> +++ b/arch/arm64/kvm/Kconfig
>> @@ -38,6 +38,7 @@ menuconfig KVM
>>       select GUEST_PERF_EVENTS if PERF_EVENTS
>>       select KVM_GUEST_MEMFD
>>       select KVM_GENERIC_MEMORY_ATTRIBUTES
>> +    select HAVE_KVM_ARCH_GMEM_POPULATE
>>       help
>>         Support hosting virtualized guest machines.
>>   diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index ed88a203b892..073ba9181da9 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -2131,6 +2131,19 @@ int kvm_arch_vm_ioctl(struct file *filp,
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
> 
> s/return ret/return 0; The variable 'ret' can be dropped.

kvm_arm_rmi_populate() may return an error though. E.g. if the
"reserved" field is set then it's kvm_arm_rmi_populate() that detects
that and returns -EINVAL.

>>       default:
>>           return -EINVAL;
>>       }
>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index a89873a5eb77..209087bcf399 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
>> @@ -486,6 +486,75 @@ void kvm_realm_unmap_range(struct kvm *kvm,
>> unsigned long start,
>>           realm_unmap_private_range(kvm, start, end, may_block);
>>   }
>>   +static int realm_data_map_init(struct kvm *kvm, unsigned long ipa,
>> +                   kvm_pfn_t dst_pfn, kvm_pfn_t src_pfn,
>> +                   unsigned long flags)
>> +{
>> +    struct realm *realm = &kvm->arch.realm;
>> +    phys_addr_t rd = virt_to_phys(realm->rd);
>> +    phys_addr_t dst_phys, src_phys;
>> +    int ret;
>> +
>> +    dst_phys = __pfn_to_phys(dst_pfn);
>> +    src_phys = __pfn_to_phys(src_pfn);
>> +
>> +    if (rmi_delegate_page(dst_phys))
>> +        return -ENXIO;
>> +
>> +    ret = rmi_rtt_data_map_init(rd, dst_phys, ipa, src_phys, flags);
>> +    if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
>> +        /* Create missing RTTs and retry */
>> +        int level = RMI_RETURN_INDEX(ret);
>> +
>> +        KVM_BUG_ON(level == KVM_PGTABLE_LAST_LEVEL, kvm);
> 
>         KVM_BUG_ON(level >= KVM_PGTABLE_LAST_LEVEL, kvm);

Ack.

>> +        ret = realm_create_rtt_levels(realm, ipa, level,
>> +                          KVM_PGTABLE_LAST_LEVEL, NULL);
>> +        if (!ret) {
>> +            ret = rmi_rtt_data_map_init(rd, dst_phys, ipa, src_phys,
>> +                            flags);
>> +        }
>> +    }
>> +
>> +    if (ret) {
>> +        if (WARN_ON(rmi_undelegate_page(dst_phys))) {
>> +            /* Undelegate failed, so we leak the page */
>> +            get_page(pfn_to_page(dst_pfn));
>> +        }
>> +    }
>> +
> 
>     if (ret && WARN_ON(rmi_undelegate_page(dst_phys)) {
>         /* Leak the page that fails to be undelegated */
>         get_page(pfn_to_page(dst_pfn));
>     }

Ack

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
>> +    return realm_data_map_init(kvm, ipa, pfn, page_to_pfn(src_page),
>> +                   data_flags);
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
>> +    ret = kvm_gmem_populate(kvm, base_gfn, u64_to_user_ptr(uaddr),
>> pages,
>> +                populate_region_cb, &data_flags);
>> +    mutex_unlock(&kvm->slots_lock);
>> +
>> +    return ret;
>> +}
>> +
>>   enum ripas_action {
>>       RIPAS_INIT,
>>       RIPAS_SET,
>> @@ -574,6 +643,43 @@ static int realm_ensure_created(struct kvm *kvm)
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
> 
> There are more conditions missed here:
> 
>     args->size == 0, return 0;
>     args->base + args->size < args->base, return -EINVAL;  // wrapped range

Good catch. args->size == 0 can trigger a WARN_ON currently. I'll put
the "return 0" after the realm_ensure_created() call so the behaviour
matches.

I don't think the wrapped range is quite such a problem - but detecting
it and rejecting it early seems like a good idea.

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
> 
> pages_populaged is 'unsigned long', this function returns a 'int' value.

pages_populated is *signed* long. This is handling an error code - so if
it's negative we expect the error code to be between -1 and -MAX_ERRNO
which should easily fit within the 'int' return.

For positive values we continue below (encoding the potentially larger
number in the args outputs) and return 0.

Thanks,
Steve

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
> Thanks,
> Gavin
> 

