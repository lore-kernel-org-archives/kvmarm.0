Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D05234AB01
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 01:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790558760; cv=none; b=BM1qvLzV40tp557CeBk2py2oA/8tcJULOosXFB+JEIotZcoHoLxYmkQl26JS0VcC8f5xo+7cZPUOACA3+ANfFMvVzC4dyrR4UKH6hZ7oAF9xqvuv7C6bhBuCC9UYJyutTLLAkXiZ070x1KxXcGTwqhjeEPU1wHqyIk9ugUf5kpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790558760; c=relaxed/simple;
	bh=RY6S03TOxdk7YcqX4Yg73s+8eCzzGITcvu+SuGkR7h0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=fMare8vWVd34LX3Ee0oIQlsVBDzC7nGgw7X8eqVc8NkdlY69ZpVHxXdBetxLsX8ii7R+f79Ig1UHFTT5e0FhAQo8qdDPNM+WIpU7757bU1h/nuHR6OBYXQM7sVMQekTCxbJJlum5IjMTlTjKdcWPUEaBS4DycRxaG9KdOBQztlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T74AtHbA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T74AtHbA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790558757;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7xS7zO4nj0VCsPgTpHEmqK4ZxRngLi3abTyf8d8xaBI=;
	b=T74AtHbAPLvbiq6hoqqTnXGyTNlEZoTfBpLLGy3KUc+n3/IWVa7gjrdxHMvXb6zPMSGGXg
	WmBNf0a7pgihIAtXXXi7VAB4M+KyD7Rrvqq8KgsNYeT+bBamqze8ODvEkqDd4MBiGmCc+i
	cTK7/EosHj6OALaxHhZ8S3WjgWnk9z8=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-81-o04kx3yXPauGnlrCFiILzA-1; Sun, 27 Sep 2026 21:25:55 -0400
X-MC-Unique: o04kx3yXPauGnlrCFiILzA-1
X-Mimecast-MFC-AGG-ID: o04kx3yXPauGnlrCFiILzA_1790558755
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-39aee9b4cf2so4458516a91.0
        for <kvmarm@lists.linux.dev>; Sun, 27 Sep 2026 18:25:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790558755; x=1791163555;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7xS7zO4nj0VCsPgTpHEmqK4ZxRngLi3abTyf8d8xaBI=;
        b=FEZTQtWfamEA5e3G357fRcpfjNZt4mlghyQE1nV1k4Rk8rzoLzTqixSV6JmsR8RaAh
         L/AI2MvKFx74QbAiWfDE543Z0cyA0mNleb1vh8SUmK3v2o7f4Hg73F7arH4nV5Do7z7X
         9yTYru3+RJ1hrHxxj5JZqETtRVa5kpXtqoC2U0+drKh/Cr2rMFB+8h44andMwKsp+IwE
         C+OLpckt93XnUuFZ0NDVpMdvdlycMwHnnalkLgfH6bNJDYx+ba45LLTzzZZLj0j3K6O1
         lcNox2uq4KVHaxMrgPOtXjG2Ktj3cYGPpESjhzDxviz6AN9YGqg7/RHQF1fMCeRhh7++
         Whww==
X-Forwarded-Encrypted: i=1; AKwUvBzLHTkd0qdSSl5TYLb0mB19F2A1uAJVGkrI4AsrFy9Ou5dlgr32HDUNs2yfvfFGYWILxSAoSsM=@lists.linux.dev
X-Gm-Message-State: AFq9FYIbCRIh7sA9twA0//Y2KkpD2Rxoc5XpRFkgRhj5ASyfUD71LwCD
	g61VxcfyeuCZEkwgb72nhMeQemk2P1HAbzhgo41XCWCs9a/vPd8r+Y2ls7pQRYqRaeHZTKVSulc
	ItW2oBvJWqr4CkpcVJCB8tyCCM76O0WS6/H4K/KqlTf/LcVJj92b8dlcojw==
X-Gm-Gg: AYBFou057TNC5wiDIBdbhyn+rhcJ92RgTN+dFZ1CtPem7NJOM1jMpzlSDC5ylHZo1uX
	D3zJF0GSJ9RFui/gw7QfTUqw8Kev+IT4FoIc7mggtCInB0Q+39eWe211p4cmzXMU0wunubguSaJ
	vmsEruu5LqzdSmJxmNUj6eo/weSDpct6YveRO9SmQHjZnSHrNFBXno7sI7rNqqB4bI/YOmBxs0J
	MPGj12m5HxJA80Usc+Qw+UuW0VdDJywkzEFawQ0y+vEgsxmcfSf1Z6X7ZjBrSrZBRMGfWI9uci4
	KewNHsHf+VUvmdDINtd5zlDdsHEvdXf/2jkalrOkgNq+89jrPrtFlqHrrmU3VccRaGTYUFkaqnf
	oKYaUMyubLvHvtyHErA7u7p85J3W+3zdA9enAiHK9ag==
X-Received: by 2002:a17:90b:5846:b0:392:ca3b:370a with SMTP id 98e67ed59e1d1-3a098aec734mr9582708a91.2.1790558754477;
        Sun, 27 Sep 2026 18:25:54 -0700 (PDT)
X-Received: by 2002:a17:90b:5846:b0:392:ca3b:370a with SMTP id 98e67ed59e1d1-3a098aec734mr9582689a91.2.1790558753896;
        Sun, 27 Sep 2026 18:25:53 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0974ec5d0sm25876788a91.4.2026.09.27.18.25.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Sep 2026 18:25:53 -0700 (PDT)
Message-ID: <df7e9870-1176-4679-bd79-807c0d87a4f2@redhat.com>
Date: Mon, 28 Sep 2026 11:25:46 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 09/20] KVM: arm64: Add VM specific callback for S2 MMU
 operations
From: Gavin Shan <gshan@redhat.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260920212845.707-1-suzuki.poulose@arm.com>
 <20260920212845.707-10-suzuki.poulose@arm.com>
 <647ae455-4175-4070-a40e-d2d89f18971f@redhat.com>
In-Reply-To: <647ae455-4175-4070-a40e-d2d89f18971f@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Cw6tvrITfUo0bH3HD_iTxzdjB6bnWjE77Rmp201ivQI_1790558755
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/28/26 11:09 AM, Gavin Shan wrote:
> On 9/21/26 7:28 AM, Suzuki K Poulose wrote:
>> Add VM type specific S2 MMU operation backends which can be initialized per
>> VM flavor, to keep the handling cleaner.
>>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>   arch/arm64/include/asm/kvm_host.h |  15 ++++
>>   arch/arm64/kvm/mmu.c              | 137 +++++++++++++++++++++++++-----
>>   2 files changed, 131 insertions(+), 21 deletions(-)
>>
> 
> Apart from the comments from Jonathan, some nitpicks and questions below.
> 
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 149f4582c8b6a..7664d8b8cce5a 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -155,6 +155,19 @@ struct kvm_vcpu_ops {
>>       void (*vcpu_put)(struct kvm_vcpu *vcpu);
>>   };
>> +struct kvm_gfn_range;
>> +
>> +struct kvm_vm_s2_ops {
>> +    bool (*vm_age_gfn)(struct kvm *kvm, struct kvm_gfn_range *range);
>> +    bool (*vm_test_age_gfn)(struct kvm *kvm, struct kvm_gfn_range *range);
>> +    int (*vm_flush_remote_tlbs)(struct kvm *kvm);
>> +    int (*vm_flush_remote_tlbs_range)(struct kvm *kvm, gfn_t gfn,
>> +                      u64 nr_pages);
>> +    void (*vm_stage2_unmap_range)(struct kvm_s2_mmu *mmu,
>> +                      phys_addr_t start, u64 size,
>> +                      bool may_block);
>> +};
>> +
>>   struct kvm_s2_mmu {
>>       struct kvm_vmid vmid;
>> @@ -332,6 +345,8 @@ struct kvm_arch {
>>        */
>>       u64 fgu[__NR_FGT_GROUP_IDS__];
>> +    const struct kvm_vm_s2_ops *vm_s2_ops;
>> +
>>       /*
>>        * Stage 2 paging state for VMs with nested S2 using a virtual
>>        * VMID.
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 03f2017a7404a..d97a4a1bca23f 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -37,6 +37,8 @@ static unsigned long __ro_after_init io_map_base;
>>   #define KVM_PGT_FN(fn)        (!is_protected_kvm_enabled() ? fn : p ## fn)
>> +static int kvm_vm_init_vm_s2_ops(struct kvm *kvm);
>> +
>>   static phys_addr_t __stage2_range_addr_end(phys_addr_t addr, phys_addr_t end,
>>                          phys_addr_t size)
>>   {
>> @@ -166,6 +168,18 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
>>       return memslot->dirty_bitmap && !(memslot->flags & KVM_MEM_READONLY);
>>   }
>> +static int pkvm_flush_remote_tlbs(struct kvm *kvm)
>> +{
>> +    kvm_call_hyp_nvhe(__pkvm_tlb_flush_vmid, kvm->arch.pkvm.handle);
>> +    return 0;
>> +}
>> +
>> +static int kvm_vm_flush_remote_tlbs(struct kvm *kvm)
>> +{
>> +    kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
>> +    return 0;
>> +}
>> +
>>   /**
>>    * kvm_arch_flush_remote_tlbs() - flush all VM TLB entries for v7/8
>>    * @kvm:    pointer to kvm structure.
>> @@ -174,26 +188,36 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
>>    */
>>   int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>>   {
>> -    if (is_protected_kvm_enabled())
>> -        kvm_call_hyp_nvhe(__pkvm_tlb_flush_vmid, kvm->arch.pkvm.handle);
>> -    else
>> -        kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
>> -    return 0;
>> +    if (!kvm->arch.vm_s2_ops->vm_flush_remote_tlbs)
>> +        return 1;
> 
> For the return value, I'm wandering if 0 should be returned. More details
> can be found below.
> 
>> +    return kvm->arch.vm_s2_ops->vm_flush_remote_tlbs(kvm);
>>   }
>> -int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
>> -                      gfn_t gfn, u64 nr_pages)
>> +static int pkvm_flush_remote_tlbs_range(struct kvm *kvm,
>> +                    gfn_t gfn, u64 nr_pages)
>> +{
>> +    return pkvm_flush_remote_tlbs(kvm);
>> +}
>> +
>> +static int kvm_vm_flush_remote_tlbs_range(struct kvm *kvm,
>> +                     gfn_t gfn, u64 nr_pages)
>>   {
>>       u64 size = nr_pages << PAGE_SHIFT;
>>       u64 addr = gfn << PAGE_SHIFT;
>> -    if (is_protected_kvm_enabled())
>> -        kvm_call_hyp_nvhe(__pkvm_tlb_flush_vmid, kvm->arch.pkvm.handle);
>> -    else
>> -        kvm_tlb_flush_vmid_range(&kvm->arch.mmu, addr, size);
>> +    kvm_tlb_flush_vmid_range(&kvm->arch.mmu, addr, size);
>>       return 0;
>>   }
>> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
>> +                     gfn_t gfn, u64 nr_pages)
>> +{
>> +    if (!kvm->arch.vm_s2_ops->vm_flush_remote_tlbs_range)
>> +        return 1;
>> +
> 
> Realm would the only case where vm_s2_ops->vm_flush_remote_{tlbs, tlbs_range)
> are NULL. On request to flush remote TLBs by kvm_flush_remote_tlbs_range(), it
> ends up with event KVM_REQ_TLB_FLUSH queued for each vCPU. How this queued event
> is linked to a remote TLB flush for realm? The problem is TLBs are owned by EL2
> realm and there are no RMI calls for the management. So I'm wandering we should
> return 0 here?
> 

vm_s2_ops->vm_flush_remote_{tlbs, tlbs_range} are added in PATCH[14] where 0 is
returned for both function. So I guess needn't this check at all?

	 if (!kvm->arch.vm_s2_ops->vm_flush_remote_tlbs_range)

>> +    return kvm->arch.vm_s2_ops->vm_flush_remote_tlbs_range(kvm, gfn, nr_pages);
>> +}
>> +
>>   static void *stage2_memcache_zalloc_page(void *arg)
>>   {
>>       struct kvm_mmu_memory_cache *mc = arg;
>> @@ -337,13 +361,20 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
>>                      may_block));
>>   }
>> +static void kvm_vm_stage2_unmap_range(struct kvm_s2_mmu *mmu,
>> +                      phys_addr_t start,
>> +                      u64 size, bool may_block)
>> +{
>> +    __unmap_stage2_range(mmu, start, size, may_block);
>> +}
>> +
>>   void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
>>                   u64 size, bool may_block)
>>   {
>> -    if (kvm_vm_is_protected(kvm_s2_mmu_to_kvm(mmu)))
>> -        return;
>> +    struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>> -    __unmap_stage2_range(mmu, start, size, may_block);
>> +    if (kvm->arch.vm_s2_ops->vm_stage2_unmap_range)
>> +        kvm->arch.vm_s2_ops->vm_stage2_unmap_range(mmu, start, size, may_block);
>>   }
>>   void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
>> @@ -983,6 +1014,12 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>>       int cpu, err;
>>       struct kvm_pgtable *pgt;
>> +    /* Initialize the VM ops for the VM instance for the first time */
>> +    if (mmu == &kvm->arch.mmu) {
>> +        err = kvm_vm_init_vm_s2_ops(kvm);
>> +        if (err)
>> +            return err;
>> +    }
>>       /*
>>        * If we already have our page tables in place, and that the
>>        * MMU context is the canonical one, we have a bug somewhere,
>> @@ -2447,34 +2484,46 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>>       return false;
>>   }
>> -bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>> +static bool kvm_vm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>>   {
>>       u64 size = (range->end - range->start) << PAGE_SHIFT;
>> -    if (!kvm->arch.mmu.pgt || kvm_vm_is_protected(kvm))
>> -        return false;
>> -
>>       return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
>>                              range->start << PAGE_SHIFT,
>>                              size, true);
>> +}
>> +
>> +bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>> +{
>> +    if (!kvm->arch.mmu.pgt || !kvm->arch.vm_s2_ops->vm_age_gfn)
>> +        return false;
>> +
>> +    return kvm->arch.vm_s2_ops->vm_age_gfn(kvm, range);
>>       /*
>>        * TODO: Handle nested_mmu structures here using the reverse mapping in
>>        * a later version of patch series.
>>        */
>>   }
>> -bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>> +static bool kvm_vm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>>   {
>>       u64 size = (range->end - range->start) << PAGE_SHIFT;
>> -    if (!kvm->arch.mmu.pgt || kvm_vm_is_protected(kvm))
>> -        return false;
>>       return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
>>                              range->start << PAGE_SHIFT,
>>                              size, false);
>>   }
>> +bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>> +{
>> +
>> +    if (!kvm->arch.mmu.pgt || !kvm->arch.vm_s2_ops->vm_test_age_gfn)
>> +        return false;
>> +
>> +    return kvm->arch.vm_s2_ops->vm_test_age_gfn(kvm, range);
>> +}
>> +
>>   phys_addr_t kvm_mmu_get_httbr(void)
>>   {
>>       return __pa(hyp_pgtable->pgd);
>> @@ -2796,3 +2845,49 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled)
>>       trace_kvm_toggle_cache(*vcpu_pc(vcpu), was_enabled, now_enabled);
>>   }
>> +
>> +static const struct kvm_vm_s2_ops protected_pkvm_vm_s2_ops = {
>> +    .vm_flush_remote_tlbs        = pkvm_flush_remote_tlbs,
>> +    .vm_flush_remote_tlbs_range    = pkvm_flush_remote_tlbs_range,
>> +    /*
>> +     * Not supported for Protected VMs under pKVM
>> +     * .vm_age_gfn
>> +     * .vm_test_age_gfn
>> +     * .vm_stage2_unmap_range
>> +     */
>> +};
>> +
>> +static const struct kvm_vm_s2_ops pkvm_vm_s2_ops = {
>> +    .vm_flush_remote_tlbs        = pkvm_flush_remote_tlbs,
>> +    .vm_flush_remote_tlbs_range    = pkvm_flush_remote_tlbs_range,
>> +    .vm_age_gfn            = kvm_vm_age_gfn,
>> +    .vm_test_age_gfn        = kvm_vm_test_age_gfn,
>> +    .vm_stage2_unmap_range        = kvm_vm_stage2_unmap_range,
>> +};
>> +
>> +static const struct kvm_vm_s2_ops kvm_default_vm_s2_ops = {
>> +    .vm_flush_remote_tlbs        = kvm_vm_flush_remote_tlbs,
>> +    .vm_flush_remote_tlbs_range    = kvm_vm_flush_remote_tlbs_range,
>> +    .vm_age_gfn            = kvm_vm_age_gfn,
>> +    .vm_test_age_gfn        = kvm_vm_test_age_gfn,
>> +    .vm_stage2_unmap_range        = kvm_vm_stage2_unmap_range,
>> +};
>> +
>> +#define KVM_VM_S2_OPS(flavor, ops)        \
>> +        [flavor] = ops
> 
> Parentheses are needed, to be consistent with KVM_VCPU_OPS at least.
> 
> #define KVM_VM_S2_OPS(flavor, ops)        \
>          [(flavor)] = (ops)
> 
> Actually, KVM_{VCPU, VM_S2}_OPS() can be combined to one in kvm_host.h as below.
> 
> #define KVM_FLAVOR_OPS() [(flavor)] = (ops)
> 
>> +static const struct kvm_vm_s2_ops *arm64_vm_s2_ops[] = {
>> +    KVM_VM_S2_OPS(VM_VHE, &kvm_default_vm_s2_ops),
>> +    KVM_VM_S2_OPS(VM_NVHE, &kvm_default_vm_s2_ops),
>> +    KVM_VM_S2_OPS(VM_PKVM, &pkvm_vm_s2_ops),
>> +    KVM_VM_S2_OPS(VM_PROTECTED_PKVM, &protected_pkvm_vm_s2_ops),
>> +};
>> +
>> +static int kvm_vm_init_vm_s2_ops(struct kvm *kvm)
>> +{
>> +    BUILD_BUG_ON(ARRAY_SIZE(arm64_vm_s2_ops) != VM_FLAVOR_MAX);
>> +
>> +    kvm->arch.vm_s2_ops = arm64_vm_s2_ops[kvm->arch.vm_flavor];
>> +    if (WARN_ON(!kvm->arch.vm_s2_ops))
>> +        return -EINVAL;
>> +    return 0;
>> +}

Thanks,
Gavin

