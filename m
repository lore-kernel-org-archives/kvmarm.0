Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 278503264FC;
	Thu, 25 Jun 2026 15:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782403107; cv=none; b=TBDg40Tbkj+VBUAlPqY4yoBgMGdUgwYq9kWO1Vu6dCP6JAiYPav51WyA0d/RvNZi3miKrVcG/pgNeXocDHd99CmT9ojaQdOT8/AT7qV+9ucDeaP0c9/mXKzzgKVwbYp4weAvWb+I0RJCSc2TN0dKj93iPvLl8jGqXrpvp03RMG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782403107; c=relaxed/simple;
	bh=cejSckmHYWFVCJUKq4/DngHn1oJpjTol/0GlR0BWKBo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sYrg4wM8zEbXMpHmwzpt/vbjpf7W0dikH/Bppn6AWaN8Dv3wYkz8CgiqFMZdpry0mB/vUfH+HII95K/5vvYb/OyAgAUO1nvyFsMHPXUwzJaIwsHEf2cgU66ONqkDCmUyVoIUD9fIWo4Ka6jbkCMegwsuLNlCtfqn5OCE8Fbrzug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iZitS/3B; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iZitS/3B"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9A4D21595;
	Thu, 25 Jun 2026 08:58:18 -0700 (PDT)
Received: from [10.57.25.211] (unknown [10.57.25.211])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 05DA73F632;
	Thu, 25 Jun 2026 08:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782403103; bh=cejSckmHYWFVCJUKq4/DngHn1oJpjTol/0GlR0BWKBo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iZitS/3Bmh8eJQVDplqVlnCkUDvK5JG0GO6fVzF7fXzUL+RNiwRq8lX1y9x3Q9tSs
	 sMyN4z7Jwsl7jHwZz7r+eJnW6Xks0UN2uNgA5V8r9DcxMLtP9zQM7bE9DgLsWREZu6
	 mB9AbW4i4FdKEkctqgNRDsgUpXen4vekPINtTRBU=
Message-ID: <98d2a0f3-b831-466a-8212-5bcf97ad9d8b@arm.com>
Date: Thu, 25 Jun 2026 16:58:18 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 29/44] arm64: RMI: Runtime faulting of memory
Content-Language: en-GB
To: Gavin Shan <gshan@redhat.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
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
 <20260513131757.116630-30-steven.price@arm.com>
 <3359f788-07fa-41a1-9ac7-45c58577c1fa@redhat.com>
 <aiJ6u83O0nVUtPyv@lpieralisi>
 <ecef952b-e8c6-4102-933b-c99c46f14431@redhat.com>
 <aiLes2ecZSr17UwZ@lpieralisi>
 <1e39094f-7fa3-4ef1-be54-53d7a8643506@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <1e39094f-7fa3-4ef1-be54-53d7a8643506@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 25/06/2026 14:53, Gavin Shan wrote:
> On 6/6/26 12:35 AM, Lorenzo Pieralisi wrote:
>> On Fri, Jun 05, 2026 at 06:11:11PM +1000, Gavin Shan wrote:
>>> On 6/5/26 5:28 PM, Lorenzo Pieralisi wrote:
>>>> On Fri, Jun 05, 2026 at 04:23:15PM +1000, Gavin Shan wrote:
>>>>
>>>> [...]
>>>>
>>>>>> +static int realm_map_ipa(struct kvm *kvm, phys_addr_t ipa,
>>>>>> +             kvm_pfn_t pfn, unsigned long map_size,
>>>>>> +             enum kvm_pgtable_prot prot,
>>>>>> +             struct kvm_mmu_memory_cache *memcache)
>>>>>> +{
>>>>>> +    struct realm *realm = &kvm->arch.realm;
>>>>>> +
>>>>>> +    /*
>>>>>> +     * Write permission is required for now even though it's 
>>>>>> possible to
>>>>>> +     * map unprotected pages (granules) as read-only. It's 
>>>>>> impossible to
>>>>>> +     * map protected pages (granules) as read-only.
>>>>>> +     */
>>>>>> +    if (WARN_ON(!(prot & KVM_PGTABLE_PROT_W)))
>>>>>> +        return -EFAULT;
>>>>>> +
>>>>>
>>>>> I'm a bit concerned with this. We don't have KVM_PGTABLE_PROT_W set 
>>>>> in @prot
>>>>> if the stage2 fault is raised due to memory read. With -EFAULT 
>>>>> returned to VMM
>>>>> (e.g. QEMU), the vCPU continuous execution is stopped and system 
>>>>> won't be
>>>>> working any more.
>>>>>
>>>>>> +    ipa = ALIGN_DOWN(ipa, PAGE_SIZE);
>>>>>> +    if (!kvm_realm_is_private_address(realm, ipa))
>>>>>> +        return realm_map_non_secure(realm, ipa, pfn, map_size, prot,
>>>>>> +                        memcache);
>>>>>> +
>>>>>> +    return realm_map_protected(kvm, ipa, pfn, map_size, memcache);
>>>>>> +}
>>>>>> +
>>>>>>     static bool kvm_vma_is_cacheable(struct vm_area_struct *vma)
>>>>>>     {
>>>>>>         switch (FIELD_GET(PTE_ATTRINDX_MASK, pgprot_val(vma- 
>>>>>> >vm_page_prot))) {
>>>>>> @@ -1604,27 +1641,52 @@ static int gmem_abort(const struct 
>>>>>> kvm_s2_fault_desc *s2fd)
>>>>>>         bool write_fault, exec_fault;
>>>>>>         enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
>>>>>>         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>>>>>> -    struct kvm_pgtable *pgt = s2fd->vcpu->arch.hw_mmu->pgt;
>>>>>> +    struct kvm_vcpu *vcpu = s2fd->vcpu;
>>>>>> +    struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
>>>>>> +    gpa_t gpa = kvm_gpa_from_fault(vcpu->kvm, s2fd->fault_ipa);
>>>>>>         unsigned long mmu_seq;
>>>>>>         struct page *page;
>>>>>> -    struct kvm *kvm = s2fd->vcpu->kvm;
>>>>>> +    struct kvm *kvm = vcpu->kvm;
>>>>>>         void *memcache;
>>>>>>         kvm_pfn_t pfn;
>>>>>>         gfn_t gfn;
>>>>>>         int ret;
>>>>>> -    memcache = get_mmu_memcache(s2fd->vcpu);
>>>>>> -    ret = topup_mmu_memcache(s2fd->vcpu, memcache);
>>>>>> +    if (kvm_is_realm(vcpu->kvm)) {
>>>>>> +        /* check for memory attribute mismatch */
>>>>>> +        bool is_priv_gfn = kvm_mem_is_private(kvm, gpa >> 
>>>>>> PAGE_SHIFT);
>>>>>> +        /*
>>>>>> +         * For Realms, the shared address is an alias of the private
>>>>>> +         * PA with the top bit set. Thus if the fault address 
>>>>>> matches
>>>>>> +         * the GPA then it is the private alias.
>>>>>> +         */
>>>>>> +        bool is_priv_fault = (gpa == s2fd->fault_ipa);
>>>>>> +
>>>>>> +        if (is_priv_gfn != is_priv_fault) {
>>>>>> +            kvm_prepare_memory_fault_exit(vcpu, gpa, PAGE_SIZE,
>>>>>> +                              kvm_is_write_fault(vcpu),
>>>>>> +                              false,
>>>>>> +                              is_priv_fault);
>>>>>> +            /*
>>>>>> +             * KVM_EXIT_MEMORY_FAULT requires an return code of
>>>>>> +             * -EFAULT, see the API documentation
>>>>>> +             */
>>>>>> +            return -EFAULT;
>>>>>> +        }
>>>>>> +    }
>>>>>> +
>>>>>> +    memcache = get_mmu_memcache(vcpu);
>>>>>> +    ret = topup_mmu_memcache(vcpu, memcache);
>>>>>>         if (ret)
>>>>>>             return ret;
>>>>>>         if (s2fd->nested)
>>>>>>             gfn = kvm_s2_trans_output(s2fd->nested) >> PAGE_SHIFT;
>>>>>>         else
>>>>>> -        gfn = s2fd->fault_ipa >> PAGE_SHIFT;
>>>>>> +        gfn = gpa >> PAGE_SHIFT;
>>>>>> -    write_fault = kvm_is_write_fault(s2fd->vcpu);
>>>>>> -    exec_fault = kvm_vcpu_trap_is_exec_fault(s2fd->vcpu);
>>>>>> +    write_fault = kvm_is_write_fault(vcpu);
>>>>>> +    exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
>>>>>>         VM_WARN_ON_ONCE(write_fault && exec_fault);
>>>>>> @@ -1634,7 +1696,7 @@ static int gmem_abort(const struct 
>>>>>> kvm_s2_fault_desc *s2fd)
>>>>>>         ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, gfn, &pfn, 
>>>>>> &page, NULL);
>>>>>>         if (ret) {
>>>>>> -        kvm_prepare_memory_fault_exit(s2fd->vcpu, s2fd- 
>>>>>> >fault_ipa, PAGE_SIZE,
>>>>>> +        kvm_prepare_memory_fault_exit(vcpu, gpa, PAGE_SIZE,
>>>>>>                               write_fault, exec_fault, false);
>>>>>>             return ret;
>>>>>>         }
>>>>>> @@ -1654,14 +1716,20 @@ static int gmem_abort(const struct 
>>>>>> kvm_s2_fault_desc *s2fd)
>>>>>>         kvm_fault_lock(kvm);
>>>>>>         if (mmu_invalidate_retry(kvm, mmu_seq)) {
>>>>>>             ret = -EAGAIN;
>>>>>> -        goto out_unlock;
>>>>>> +        goto out_release_page;
>>>>>> +    }
>>>>>> +
>>>>>> +    if (kvm_is_realm(kvm)) {
>>>>>> +        ret = realm_map_ipa(kvm, s2fd->fault_ipa, pfn,
>>>>>> +                    PAGE_SIZE, KVM_PGTABLE_PROT_R | 
>>>>>> KVM_PGTABLE_PROT_W, memcache);
>>>>>> +        goto out_release_page;
>>>>>>         }
>>>>>>         ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd- 
>>>>>> >fault_ipa, PAGE_SIZE,
>>>>>>                              __pfn_to_phys(pfn), prot,
>>>>>>                              memcache, flags);
>>>>>> -out_unlock:
>>>>>> +out_release_page:
>>>>>>         kvm_release_faultin_page(kvm, page, !!ret, prot & 
>>>>>> KVM_PGTABLE_PROT_W);
>>>>>>         kvm_fault_unlock(kvm);
>>>>>> @@ -1847,7 +1915,7 @@ static int kvm_s2_fault_get_vma_info(const 
>>>>>> struct kvm_s2_fault_desc *s2fd,
>>>>>>          * mapping size to ensure we find the right PFN and lay 
>>>>>> down the
>>>>>>          * mapping in the right place.
>>>>>>          */
>>>>>> -    s2vi->gfn = ALIGN_DOWN(s2fd->fault_ipa, s2vi->vma_pagesize) 
>>>>>> >> PAGE_SHIFT;
>>>>>> +    s2vi->gfn = kvm_gpa_from_fault(kvm, ALIGN_DOWN(s2fd- 
>>>>>> >fault_ipa, s2vi->vma_pagesize)) >> PAGE_SHIFT;
>>>>>>         s2vi->mte_allowed = kvm_vma_mte_allowed(vma);
>>>>>> @@ -2056,6 +2124,9 @@ static int kvm_s2_fault_map(const struct 
>>>>>> kvm_s2_fault_desc *s2fd,
>>>>>>             prot &= ~KVM_NV_GUEST_MAP_SZ;
>>>>>>             ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, 
>>>>>> gfn_to_gpa(gfn),
>>>>>>                                      prot, flags);
>>>>>> +    } else if (kvm_is_realm(kvm)) {
>>>>>> +        ret = realm_map_ipa(kvm, s2fd->fault_ipa, pfn, mapping_size,
>>>>>> +                    prot, memcache);
>>>>>>         } else {
>>>>>>             ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, 
>>>>>> gfn_to_gpa(gfn), mapping_size,
>>>>>>                                  __pfn_to_phys(pfn), prot,
>>>>>
>>>>> For the case kvm_is_realm(), need we adjust 's2fd->fault_ipa' for 
>>>>> the sake of
>>>>> huge pages. In kvm_s2_fault_map(), @gfn and @pfn may have been 
>>>>> adjusted by
>>>>> transparent_hugepage_adjust() to be aligned with huge page size. If 
>>>>> the
>>>>> adjustment happened in transparent_hugepage_adjust(), we need to align
>>>>> s2fd->fault_ipa down to the huge page size either.
>>>>
>>>> All of the above + some RMM changes are needed to get QEmu VMM going
>>>> with anon pages guest memory backing - currently testing various
>>>> configurations in the background.
>>>>
>>>
>>> I tried to rebase Jean's latest QEMU series [1] to upstream QEMU, and 
>>> found
>>> that memory slots backed by THP are broken. With THP disabled on the 
>>> host and
>>> other fixes (mentioned in my prevous replies) applied on the top of 
>>> this (v14)
>>> series, I'm able to boot a realm guest with rebased QEMU series [2], 
>>> plus more
>>> fxies on the top.
>>>
>>> [1] https://git.codelinaro.org/linaro/dcap/qemu.git  (branch: cca/ 
>>> latest)
>>> [2] https://git.qemu.org/git/qemu.git                (branch: cca/gavin)
>>>
>>> Lorenzo, You may be saying there is someone making QEMU to support 
>>> ARM/CCA?
>>
>> Mathieu and I are working on that yes and with Steven/Suzuki to fix 
>> the THP
>> issues you pointed out above.
>>
>>> If so, I'm not sure if there is a QEMU repository for me to try?
>>
>> We should be able to submit patches by end of June - we shall let you 
>> know
>> whether we can make something available earlier.
>>
> 
> Not sure if there are other known issues in this series. It seems the 
> stage2
> page fault handling on the shared space isn't working well. In my test, the
> vring (struct vring_desc) of virtio-net-pci is updated by the guest, and 
> the
> data isn't seen by QEMU, I'm suspecting if the host-page-frame-number is 
> properly
> resolved in the s2 page fault handler for shared (unprotected) space.
> 
> - I rebased Jean's latest qemu branch to the upstream qemu;
> 
> - On the host, which is emulated by qemu/tcg, the THP (transparent huge 
> page) is
>    disabled.
> 
> - On the guest, I can see the virtio vring (struct vring_desc) is 
> updated. The
>    S1 page-table entry looks correct because the corresponding physical 
> address
>    0x10046880000 is a sane shared (unprotected) space address.
> 
>    [   52.094143] software IO TLB: Memory encryption is active and 
> system is using DMA bounce buffers
>    [   52.289746] virtqueue_add_desc_split: desc[0]@0xffff000006880000, 
> [00000100b983f000  00000640  0002  0001]
>    [   52.432150] PTE 0x00e8010046880707 at address 0xffff000006880000
> 
> - On the host, the s2 page-table-entry is unmapped due to attribute 
> transition (private -> shared).
>    A subsequent S2 page fault is raised against the adress and the s2 
> page-table-entry is built.
> 
>    [  109.259077] ====> realm_unmap_shared_range: 
> tracked_unprot_addr=0x10046880000
>    [  109.260249] realm_unmap_shared_range: unmapped shared range at 
> 0x10046880000
>    [  109.317786] realm_unmap_shared_range: unmapped shared range at 
> 0x10046880000
>    [  109.629939] ====> kvm_handle_guest_abort: fault_ipa=0x10046880000, 
> esr=0x92000007
>    [  109.630245] realm_map_non_secure: ipa=0x10046880000, pfn=0xb8b59, 
> size=0x1000, prot=0xf
>    [  109.630331] realm_map_non_secure: ipa=0x10046880000, 
> ipa_top=0x10046881000, flags=0x1e0001, range_desc=0xb8b59004

Are you able to correlate the order of the transitions and the Guest
access with RMM log ? We haven't seen this from our end. We are aware
of permission fault issues with Unprotected IPA when backing the memslot
with MAP_PRIVATE areas. But this looks different.

Lorenzo, have you run into this ?

Suzuki


> 
> - On QEMU, the updated vring (struct vring_desc) at GPA 0x46880000 isn't 
> seen. All the
>    data in that adress are zeros.
> 
>    ====> virtqueue_split_pop: vdev=<virtio-net>, sz=0x38, 
> queue_index=0x0, vq->vring.num=0x100
>    virtqueue_split_pop: last_avail_idx=0x0, head=0x0
>    address_space_read_cached_slow: cache@0xffff1c036440, addr=0x0, 
> buf=0xffffeee34880, len=0x10
>    address_space_read_cached_slow: cache: ptr=0x0, xlat=0x10046880000, 
> len=0x1000, mrs=<realm-dma-region>, is_write=no
>    address_space_read_cached_slow: translated to mr=<mach-virt.ram>, 
> mr_addr=0x6880000, l=0x10
>    flatview_read_continue_step: mr=<mach-virt.ram>, host=0xffff23e00000, 
> mr_addr=0x6880000, ram_ptr=0xffff2a680000
>    virtqueue_split_pop: desc: 0000000000000000 - 00000000 - 00000000 - 
> 00000000
>    qemu-system-aarch64: virtio: zero sized buffers are not allowed
> 
> 
> Thanks,
> Gavin
> 

