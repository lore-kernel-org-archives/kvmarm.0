Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060693451AF
	for <kvmarm@lists.linux.dev>; Thu, 25 Jun 2026 13:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782395638; cv=none; b=prMASc/JynAC6xjUyenK0DzEueItr4jYmp2w72sxrq7QvqsHV97/6g8+tefQLQ5tHil5jQcW/e94U2Bo7BtPuSJmD/UrWQ+7PxkqsPJmBkou9eXMuJj1kAG8KwmEkXpSI7AY1JlnAZiQ7ookacyrJJeM3MvoRM1zuZxV6l5WbLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782395638; c=relaxed/simple;
	bh=TEtUb2t7/GatcjTLqxJxCqQNRI+9vBLfCeDeqCkz0R8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nix/e4Ent6zkD+RQFQV4ACm3HbZNo26Lxkw1TvJh5l+JP+AL/gNly+zG9o2U1dMpDgCxy15c0iercyV7S9x6S3ojqHx+BFv8iq4EqZhj6vPU8ixrUL78TZqndsbGUiBVQbme6p+wR3X30OUT+CWeN1QiG4BiRWCk9x2jvGxc3vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M8UdtDTO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M8UdtDTO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782395636;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F2JG4NFwUS2cEMv5rtucKqmVkk7/NshCHssLA8DLWUk=;
	b=M8UdtDTOjk+NlrV7Q6q/EG0/R+B/9hBwDxYBb+ZrXzoEw4ZldqgSiJPjAsKt1gcorYuEQm
	yz9u5OeT3xXdD40cE2UhsDxieBHvrQz6GU1k6aFoUV13bU/ESRGkqQQqlKML1KvxzF0CuA
	JGDRLU3PFsw5ELhLqC9/m3EYNnbfsuA=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-544-gnaaBFyHNZiDIwiA5W62Lw-1; Thu, 25 Jun 2026 09:53:52 -0400
X-MC-Unique: gnaaBFyHNZiDIwiA5W62Lw-1
X-Mimecast-MFC-AGG-ID: gnaaBFyHNZiDIwiA5W62Lw_1782395631
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5aa7a7ad394so1092421e87.1
        for <kvmarm@lists.linux.dev>; Thu, 25 Jun 2026 06:53:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782395631; x=1783000431;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F2JG4NFwUS2cEMv5rtucKqmVkk7/NshCHssLA8DLWUk=;
        b=AKA1b09sUj9K5xHMMPCwTXf8euXRizqw3GYQv/X6fidtPNOsg/4/xtKSG6d1xaEAby
         vDAfApkxLfIb9g3kF0qnY4j8i65yTwaF/bE+FU8LRrmFGvHP9+nRLJ+sQjqZnsM+vNPG
         5/T858bg2jXYlya+MmiM78I5Abg1ufQBzhnmmqSKnaIerSb62WuEpL3OVKdXfA3b2QHF
         OYQnCHoPfN8KmrGdwYi29erF71EgdvghpDEGmsOIbyUA6EtNRPZf9sp5JLICdyVUOK1j
         nqzWoxLWzvJL5yyioALbJ8nUQCSSF60AuWgVNGiwUsG7sghJvITrDQawiFgaTn4n6dnK
         J6iQ==
X-Forwarded-Encrypted: i=1; AHgh+RolMJcIfotdTCfa20Z/kIyWFra15MjrNRXnhH3YW5Ykpt13IrYfg+xweRMBcZEgvyL0LHq1ZGk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxGgAue4T3S2D9JGEgcoDGjj7gNQyk9+vvCtvHad3/ELXDkEAC+
	tL68pugCKHC5wRvNtGyFz5U4xmK13QEkgfW9+jdudl5a1TuG2x8Ed9wf7PVl3gys5PmIuWT3/DK
	C2ccCEECKpx2hS4X4wrgLVgdVU86jGefxAIRoGywFyGK8O5XP7l7CmWi5gQ==
X-Gm-Gg: AfdE7cmqqjF745cWGME6tWyFYl0Bs2hBB1r5kywMOOOhiFIRDtWnO6AZmM/bIy+esGc
	pFxhl7Cln6GaK+fcfxS2CVPY8So7kcjEwXuL/ICqk1dhM0WtZsA6+8jNPSirp0YS4g/vLZn89lg
	iRzVR4SrC3mIxCFYLDOJYLV4RyLGkWXvTO7On4g0EbH1+dHEimToFy23Unxl1qXnTeiBGuoge7o
	rpzz9OueZhQeYpqpcjEDt3LwPB24k/LjGB6Xl3sDsRoEd7zZ19jB0JiwR0Tdzb7wEiyC1+LNihB
	2MjRk9XVUJmTHum7BIBpNYL5xcLyYicw0bTP6qlz2lYzN7ikkhp2cjx+r0lZrSJOQODHa474LwR
	58Dhqj+Eq5rkX0KUI2sjcwiPgSasKjBJOOtinPb2f3+izatWh5Lidgg==
X-Received: by 2002:a05:6512:6805:b0:5a8:86a8:2e09 with SMTP id 2adb3069b0e04-5aea1f40aecmr867668e87.7.1782395630917;
        Thu, 25 Jun 2026 06:53:50 -0700 (PDT)
X-Received: by 2002:a05:6512:6805:b0:5a8:86a8:2e09 with SMTP id 2adb3069b0e04-5aea1f40aecmr867655e87.7.1782395630346;
        Thu, 25 Jun 2026 06:53:50 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5ad69550febsm2641151e87.25.2026.06.25.06.53.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 06:53:49 -0700 (PDT)
Message-ID: <1e39094f-7fa3-4ef1-be54-53d7a8643506@redhat.com>
Date: Thu, 25 Jun 2026 23:53:32 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 29/44] arm64: RMI: Runtime faulting of memory
To: Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
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
 <20260513131757.116630-30-steven.price@arm.com>
 <3359f788-07fa-41a1-9ac7-45c58577c1fa@redhat.com>
 <aiJ6u83O0nVUtPyv@lpieralisi>
 <ecef952b-e8c6-4102-933b-c99c46f14431@redhat.com>
 <aiLes2ecZSr17UwZ@lpieralisi>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <aiLes2ecZSr17UwZ@lpieralisi>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2VN9mRdp662e0jyAjHhAfJESmHEioINEB_9peN2Zf7M_1782395631
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/6/26 12:35 AM, Lorenzo Pieralisi wrote:
> On Fri, Jun 05, 2026 at 06:11:11PM +1000, Gavin Shan wrote:
>> On 6/5/26 5:28 PM, Lorenzo Pieralisi wrote:
>>> On Fri, Jun 05, 2026 at 04:23:15PM +1000, Gavin Shan wrote:
>>>
>>> [...]
>>>
>>>>> +static int realm_map_ipa(struct kvm *kvm, phys_addr_t ipa,
>>>>> +			 kvm_pfn_t pfn, unsigned long map_size,
>>>>> +			 enum kvm_pgtable_prot prot,
>>>>> +			 struct kvm_mmu_memory_cache *memcache)
>>>>> +{
>>>>> +	struct realm *realm = &kvm->arch.realm;
>>>>> +
>>>>> +	/*
>>>>> +	 * Write permission is required for now even though it's possible to
>>>>> +	 * map unprotected pages (granules) as read-only. It's impossible to
>>>>> +	 * map protected pages (granules) as read-only.
>>>>> +	 */
>>>>> +	if (WARN_ON(!(prot & KVM_PGTABLE_PROT_W)))
>>>>> +		return -EFAULT;
>>>>> +
>>>>
>>>> I'm a bit concerned with this. We don't have KVM_PGTABLE_PROT_W set in @prot
>>>> if the stage2 fault is raised due to memory read. With -EFAULT returned to VMM
>>>> (e.g. QEMU), the vCPU continuous execution is stopped and system won't be
>>>> working any more.
>>>>
>>>>> +	ipa = ALIGN_DOWN(ipa, PAGE_SIZE);
>>>>> +	if (!kvm_realm_is_private_address(realm, ipa))
>>>>> +		return realm_map_non_secure(realm, ipa, pfn, map_size, prot,
>>>>> +					    memcache);
>>>>> +
>>>>> +	return realm_map_protected(kvm, ipa, pfn, map_size, memcache);
>>>>> +}
>>>>> +
>>>>>     static bool kvm_vma_is_cacheable(struct vm_area_struct *vma)
>>>>>     {
>>>>>     	switch (FIELD_GET(PTE_ATTRINDX_MASK, pgprot_val(vma->vm_page_prot))) {
>>>>> @@ -1604,27 +1641,52 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
>>>>>     	bool write_fault, exec_fault;
>>>>>     	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
>>>>>     	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>>>>> -	struct kvm_pgtable *pgt = s2fd->vcpu->arch.hw_mmu->pgt;
>>>>> +	struct kvm_vcpu *vcpu = s2fd->vcpu;
>>>>> +	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
>>>>> +	gpa_t gpa = kvm_gpa_from_fault(vcpu->kvm, s2fd->fault_ipa);
>>>>>     	unsigned long mmu_seq;
>>>>>     	struct page *page;
>>>>> -	struct kvm *kvm = s2fd->vcpu->kvm;
>>>>> +	struct kvm *kvm = vcpu->kvm;
>>>>>     	void *memcache;
>>>>>     	kvm_pfn_t pfn;
>>>>>     	gfn_t gfn;
>>>>>     	int ret;
>>>>> -	memcache = get_mmu_memcache(s2fd->vcpu);
>>>>> -	ret = topup_mmu_memcache(s2fd->vcpu, memcache);
>>>>> +	if (kvm_is_realm(vcpu->kvm)) {
>>>>> +		/* check for memory attribute mismatch */
>>>>> +		bool is_priv_gfn = kvm_mem_is_private(kvm, gpa >> PAGE_SHIFT);
>>>>> +		/*
>>>>> +		 * For Realms, the shared address is an alias of the private
>>>>> +		 * PA with the top bit set. Thus if the fault address matches
>>>>> +		 * the GPA then it is the private alias.
>>>>> +		 */
>>>>> +		bool is_priv_fault = (gpa == s2fd->fault_ipa);
>>>>> +
>>>>> +		if (is_priv_gfn != is_priv_fault) {
>>>>> +			kvm_prepare_memory_fault_exit(vcpu, gpa, PAGE_SIZE,
>>>>> +						      kvm_is_write_fault(vcpu),
>>>>> +						      false,
>>>>> +						      is_priv_fault);
>>>>> +			/*
>>>>> +			 * KVM_EXIT_MEMORY_FAULT requires an return code of
>>>>> +			 * -EFAULT, see the API documentation
>>>>> +			 */
>>>>> +			return -EFAULT;
>>>>> +		}
>>>>> +	}
>>>>> +
>>>>> +	memcache = get_mmu_memcache(vcpu);
>>>>> +	ret = topup_mmu_memcache(vcpu, memcache);
>>>>>     	if (ret)
>>>>>     		return ret;
>>>>>     	if (s2fd->nested)
>>>>>     		gfn = kvm_s2_trans_output(s2fd->nested) >> PAGE_SHIFT;
>>>>>     	else
>>>>> -		gfn = s2fd->fault_ipa >> PAGE_SHIFT;
>>>>> +		gfn = gpa >> PAGE_SHIFT;
>>>>> -	write_fault = kvm_is_write_fault(s2fd->vcpu);
>>>>> -	exec_fault = kvm_vcpu_trap_is_exec_fault(s2fd->vcpu);
>>>>> +	write_fault = kvm_is_write_fault(vcpu);
>>>>> +	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
>>>>>     	VM_WARN_ON_ONCE(write_fault && exec_fault);
>>>>> @@ -1634,7 +1696,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
>>>>>     	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, gfn, &pfn, &page, NULL);
>>>>>     	if (ret) {
>>>>> -		kvm_prepare_memory_fault_exit(s2fd->vcpu, s2fd->fault_ipa, PAGE_SIZE,
>>>>> +		kvm_prepare_memory_fault_exit(vcpu, gpa, PAGE_SIZE,
>>>>>     					      write_fault, exec_fault, false);
>>>>>     		return ret;
>>>>>     	}
>>>>> @@ -1654,14 +1716,20 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
>>>>>     	kvm_fault_lock(kvm);
>>>>>     	if (mmu_invalidate_retry(kvm, mmu_seq)) {
>>>>>     		ret = -EAGAIN;
>>>>> -		goto out_unlock;
>>>>> +		goto out_release_page;
>>>>> +	}
>>>>> +
>>>>> +	if (kvm_is_realm(kvm)) {
>>>>> +		ret = realm_map_ipa(kvm, s2fd->fault_ipa, pfn,
>>>>> +				    PAGE_SIZE, KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W, memcache);
>>>>> +		goto out_release_page;
>>>>>     	}
>>>>>     	ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
>>>>>     						 __pfn_to_phys(pfn), prot,
>>>>>     						 memcache, flags);
>>>>> -out_unlock:
>>>>> +out_release_page:
>>>>>     	kvm_release_faultin_page(kvm, page, !!ret, prot & KVM_PGTABLE_PROT_W);
>>>>>     	kvm_fault_unlock(kvm);
>>>>> @@ -1847,7 +1915,7 @@ static int kvm_s2_fault_get_vma_info(const struct kvm_s2_fault_desc *s2fd,
>>>>>     	 * mapping size to ensure we find the right PFN and lay down the
>>>>>     	 * mapping in the right place.
>>>>>     	 */
>>>>> -	s2vi->gfn = ALIGN_DOWN(s2fd->fault_ipa, s2vi->vma_pagesize) >> PAGE_SHIFT;
>>>>> +	s2vi->gfn = kvm_gpa_from_fault(kvm, ALIGN_DOWN(s2fd->fault_ipa, s2vi->vma_pagesize)) >> PAGE_SHIFT;
>>>>>     	s2vi->mte_allowed = kvm_vma_mte_allowed(vma);
>>>>> @@ -2056,6 +2124,9 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>>>>>     		prot &= ~KVM_NV_GUEST_MAP_SZ;
>>>>>     		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, gfn_to_gpa(gfn),
>>>>>     								 prot, flags);
>>>>> +	} else if (kvm_is_realm(kvm)) {
>>>>> +		ret = realm_map_ipa(kvm, s2fd->fault_ipa, pfn, mapping_size,
>>>>> +				    prot, memcache);
>>>>>     	} else {
>>>>>     		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, gfn_to_gpa(gfn), mapping_size,
>>>>>     							 __pfn_to_phys(pfn), prot,
>>>>
>>>> For the case kvm_is_realm(), need we adjust 's2fd->fault_ipa' for the sake of
>>>> huge pages. In kvm_s2_fault_map(), @gfn and @pfn may have been adjusted by
>>>> transparent_hugepage_adjust() to be aligned with huge page size. If the
>>>> adjustment happened in transparent_hugepage_adjust(), we need to align
>>>> s2fd->fault_ipa down to the huge page size either.
>>>
>>> All of the above + some RMM changes are needed to get QEmu VMM going
>>> with anon pages guest memory backing - currently testing various
>>> configurations in the background.
>>>
>>
>> I tried to rebase Jean's latest QEMU series [1] to upstream QEMU, and found
>> that memory slots backed by THP are broken. With THP disabled on the host and
>> other fixes (mentioned in my prevous replies) applied on the top of this (v14)
>> series, I'm able to boot a realm guest with rebased QEMU series [2], plus more
>> fxies on the top.
>>
>> [1] https://git.codelinaro.org/linaro/dcap/qemu.git  (branch: cca/latest)
>> [2] https://git.qemu.org/git/qemu.git                (branch: cca/gavin)
>>
>> Lorenzo, You may be saying there is someone making QEMU to support ARM/CCA?
> 
> Mathieu and I are working on that yes and with Steven/Suzuki to fix the THP
> issues you pointed out above.
> 
>> If so, I'm not sure if there is a QEMU repository for me to try?
> 
> We should be able to submit patches by end of June - we shall let you know
> whether we can make something available earlier.
> 

Not sure if there are other known issues in this series. It seems the stage2
page fault handling on the shared space isn't working well. In my test, the
vring (struct vring_desc) of virtio-net-pci is updated by the guest, and the
data isn't seen by QEMU, I'm suspecting if the host-page-frame-number is properly
resolved in the s2 page fault handler for shared (unprotected) space.

- I rebased Jean's latest qemu branch to the upstream qemu;

- On the host, which is emulated by qemu/tcg, the THP (transparent huge page) is
   disabled.

- On the guest, I can see the virtio vring (struct vring_desc) is updated. The
   S1 page-table entry looks correct because the corresponding physical address
   0x10046880000 is a sane shared (unprotected) space address.

   [   52.094143] software IO TLB: Memory encryption is active and system is using DMA bounce buffers
   [   52.289746] virtqueue_add_desc_split: desc[0]@0xffff000006880000, [00000100b983f000  00000640  0002  0001]
   [   52.432150] PTE 0x00e8010046880707 at address 0xffff000006880000

- On the host, the s2 page-table-entry is unmapped due to attribute transition (private -> shared).
   A subsequent S2 page fault is raised against the adress and the s2 page-table-entry is built.

   [  109.259077] ====> realm_unmap_shared_range: tracked_unprot_addr=0x10046880000
   [  109.260249] realm_unmap_shared_range: unmapped shared range at 0x10046880000
   [  109.317786] realm_unmap_shared_range: unmapped shared range at 0x10046880000
   [  109.629939] ====> kvm_handle_guest_abort: fault_ipa=0x10046880000, esr=0x92000007
   [  109.630245] realm_map_non_secure: ipa=0x10046880000, pfn=0xb8b59, size=0x1000, prot=0xf
   [  109.630331] realm_map_non_secure: ipa=0x10046880000, ipa_top=0x10046881000, flags=0x1e0001, range_desc=0xb8b59004

- On QEMU, the updated vring (struct vring_desc) at GPA 0x46880000 isn't seen. All the
   data in that adress are zeros.

   ====> virtqueue_split_pop: vdev=<virtio-net>, sz=0x38, queue_index=0x0, vq->vring.num=0x100
   virtqueue_split_pop: last_avail_idx=0x0, head=0x0
   address_space_read_cached_slow: cache@0xffff1c036440, addr=0x0, buf=0xffffeee34880, len=0x10
   address_space_read_cached_slow: cache: ptr=0x0, xlat=0x10046880000, len=0x1000, mrs=<realm-dma-region>, is_write=no
   address_space_read_cached_slow: translated to mr=<mach-virt.ram>, mr_addr=0x6880000, l=0x10
   flatview_read_continue_step: mr=<mach-virt.ram>, host=0xffff23e00000, mr_addr=0x6880000, ram_ptr=0xffff2a680000
   virtqueue_split_pop: desc: 0000000000000000 - 00000000 - 00000000 - 00000000
   qemu-system-aarch64: virtio: zero sized buffers are not allowed


Thanks,
Gavin

