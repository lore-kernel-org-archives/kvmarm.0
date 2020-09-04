Return-Path: <SRS0=jshR=CN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 354A1C433E2
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 00:47:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9EB4E20709
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 00:47:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b/4h8IoK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9EB4E20709
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BC7B4B325;
	Thu,  3 Sep 2020 20:47:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PGXQUvGCcNmx; Thu,  3 Sep 2020 20:47:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C635B4B313;
	Thu,  3 Sep 2020 20:47:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 471A24B300
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 20:47:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BTu-U7XQMEff for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 20:47:53 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3552B4B1DF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 20:47:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599180473;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=KTcbwlmbLZcxBb2ixiKGKOyx6lIAu2uHdHm7k/8vpaU=;
 b=b/4h8IoK48qHzzHXr9fIdsRHt95DHL3XeFL7yIg8hvJlbx9Pd60u5hKOa1lyudYOQfFdGO
 z4N8sN5EQRYeLy/WRE/uzwMJlPie4EyacrqO2BHB7c6vkg7S6Qu15I5grl7SAbWaAjK+4X
 Xe/flpIt8KHtBJh4oRW5DqTtSK11s/I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-fkO2PFWNMcieKIC-6q4oVQ-1; Thu, 03 Sep 2020 20:47:49 -0400
X-MC-Unique: fkO2PFWNMcieKIC-6q4oVQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93A36107464E;
 Fri,  4 Sep 2020 00:47:47 +0000 (UTC)
Received: from [10.64.54.159] (vpn2-54-159.bne.redhat.com [10.64.54.159])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AB1C5D9CC;
 Fri,  4 Sep 2020 00:47:43 +0000 (UTC)
Subject: Re: [PATCH v3 06/21] KVM: arm64: Add support for stage-2
 map()/unmap() in generic page-table
To: Will Deacon <will@kernel.org>
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-7-will@kernel.org>
 <4cb1fbc9-c20d-35f1-c0cc-da21c0562f0a@redhat.com>
 <20200903123032.GB7412@willie-the-truck>
 <20200903161540.GA7770@willie-the-truck>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <c654e747-8f91-c4cb-58e3-bbbe122fdb86@redhat.com>
Date: Fri, 4 Sep 2020 10:47:40 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200903161540.GA7770@willie-the-truck>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Will,

On 9/4/20 2:15 AM, Will Deacon wrote:
> On Thu, Sep 03, 2020 at 01:30:32PM +0100, Will Deacon wrote:
>> On Thu, Sep 03, 2020 at 09:18:27PM +1000, Gavin Shan wrote:
>>> On 8/25/20 7:39 PM, Will Deacon wrote:
>>>> +static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
>>>> +				      kvm_pte_t *ptep,
>>>> +				      struct stage2_map_data *data)
>>>> +{
>>>> +	int ret = 0;
>>>> +
>>>> +	if (!data->anchor)
>>>> +		return 0;
>>>> +
>>>> +	free_page((unsigned long)kvm_pte_follow(*ptep));
>>>> +	put_page(virt_to_page(ptep));
>>>> +
>>>> +	if (data->anchor == ptep) {
>>>> +		data->anchor = NULL;
>>>> +		ret = stage2_map_walk_leaf(addr, end, level, ptep, data);
>>>> +	}
>>>> +
>>>> +	return ret;
>>>> +}
>>>> +
>>>
>>> As discussed in another thread, *ptep has been invalidated in stage2_map_walk_table_pre().
>>> It means *ptep has value of zero. The following call to free_page() is going to release
>>> the page frame corresponding to physical address 0x0. It's not correct. We might cache
>>> the original value of this page table entry so that it can be used here.
>>
>> Ah, yes, I see what you mean. But it's odd that I haven't run into this
>> myself, so let me try to reproduce the issue first. Another solution is
>> to invalidate the table entry only by clearing the valid bit of the pte,
>> rather than zapping the entire thing to 0, which can be done later when we
>> clear the anchor.
> 
> Ok! There are a couple of issues here:
> 
>    1. As you point out, the kvm_pte_follow() above ends up chasing a zeroed
>       pte.
> 
>    2. The reason I'm not seeing this in testing is because the dirty logging
>       code isn't hitting the table -> block case as it should. This is
>       because I'm not handling permission faults properly when a write
>       hits a read-only block entry. In this case, we need to collapse the
>       entry if logging is active.
> 
> Diff below seems to clear all of this up. I'll fold it in for v4.
> 
> Thanks for reporting the problem and helping to debug it.
> 

I saw these changes have been fold to v4. So tried v4 directly and hugetlbfs
works fine with the changes. Thanks for the fixes.

> --->8
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index dc76fdf31be3..9328830e9464 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -155,8 +155,8 @@ static kvm_pte_t *kvm_pte_follow(kvm_pte_t pte)
>   
>   static void kvm_set_invalid_pte(kvm_pte_t *ptep)
>   {
> -       kvm_pte_t pte = 0;
> -       WRITE_ONCE(*ptep, pte);
> +       kvm_pte_t pte = *ptep;
> +       WRITE_ONCE(*ptep, pte & ~KVM_PTE_VALID);
>   }
>   
>   static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp)
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index f28e03dcb897..10b73da6abb2 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -737,11 +737,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>          bool exec_fault;
>          bool device = false;
>          unsigned long mmu_seq;
> -       gfn_t gfn = fault_ipa >> PAGE_SHIFT;
>          struct kvm *kvm = vcpu->kvm;
>          struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
>          struct vm_area_struct *vma;
>          short vma_shift;
> +       gfn_t gfn;
>          kvm_pfn_t pfn;
>          bool logging_active = memslot_is_logging(memslot);
>          unsigned long vma_pagesize;
> @@ -780,10 +780,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>          }
>   
>          if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
> -               gfn = (fault_ipa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
> +               fault_ipa &= huge_page_mask(hstate_vma(vma));
> +
> +       gfn = fault_ipa >> PAGE_SHIFT;
>          mmap_read_unlock(current->mm);
>   
> -       if (fault_status != FSC_PERM) {
> +       /*
> +        * Permission faults just need to update the existing leaf entry,
> +        * and so normally don't require allocations from the memcache. The
> +        * only exception to this is when dirty logging is enabled at runtime
> +        * and a write fault needs to collapse a block entry into a table.
> +        */
> +       if (fault_status != FSC_PERM || (logging_active && write_fault)) {
>                  ret = kvm_mmu_topup_memory_cache(memcache,
>                                                   kvm_mmu_cache_min_pages(kvm));
>                  if (ret)
> @@ -854,7 +862,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>          else if (cpus_have_const_cap(ARM64_HAS_CACHE_DIC))
>                  prot |= KVM_PGTABLE_PROT_X;
>   
> -       if (fault_status == FSC_PERM) {
> +       if (fault_status == FSC_PERM && !(logging_active && writable)) {
>                  ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
>          } else {
>                  ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
> 

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
