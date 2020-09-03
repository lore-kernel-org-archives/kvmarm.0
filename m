Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5270DC433E2
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 03:58:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BD47120716
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 03:58:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bVlZJYCX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD47120716
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30CF44B312;
	Wed,  2 Sep 2020 23:58:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F54Pq+oTVrbi; Wed,  2 Sep 2020 23:58:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 090464B30A;
	Wed,  2 Sep 2020 23:58:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0CE14B30A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 23:58:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sRqs3n9lZjeQ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2020 23:58:05 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 116384B308
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 23:58:05 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599105484;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=YCdi2zrJcpqfRm+LNHjqqq/SWGwHguRwqUW57r1zgM0=;
 b=bVlZJYCX68WgO3SQ2YEPsfRIjYhHm+bZYf8q74nz8qoVPsDjeQBma/eelWnPVa3atAeAAP
 PxKz0OsFN54e4XT2ANRX/5R5LjN+16RsX/9M7gZdubZjq461fc+zJCOpUj12cdv2tulTYp
 5uiFr2yOscB54YgxtL8tfMNruYf8meU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-PLneH7_DOUmEZfmdjJ3KIg-1; Wed, 02 Sep 2020 23:58:03 -0400
X-MC-Unique: PLneH7_DOUmEZfmdjJ3KIg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 807B01005E66;
 Thu,  3 Sep 2020 03:58:01 +0000 (UTC)
Received: from [10.64.54.159] (vpn2-54-159.bne.redhat.com [10.64.54.159])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D1E717049D;
 Thu,  3 Sep 2020 03:57:58 +0000 (UTC)
Subject: Re: [PATCH v3 07/21] KVM: arm64: Convert kvm_phys_addr_ioremap() to
 generic page-table API
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-8-will@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <c088650b-7c07-4768-ba54-d5f69e60e59e@redhat.com>
Date: Thu, 3 Sep 2020 13:57:56 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200825093953.26493-8-will@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kernel-team@android.com, linux-arm-kernel@lists.infradead.org
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

On 8/25/20 7:39 PM, Will Deacon wrote:
> Convert kvm_phys_addr_ioremap() to use kvm_pgtable_stage2_map() instead
> of stage2_set_pte().
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/kvm/hyp/pgtable.c | 14 +-------------
>   arch/arm64/kvm/mmu.c         | 29 ++++++++++++-----------------
>   2 files changed, 13 insertions(+), 30 deletions(-)
> 
Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 41ee8f3c0369..6f65d3841ec9 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -439,18 +439,6 @@ struct stage2_map_data {
>   	struct kvm_mmu_memory_cache	*memcache;
>   };
>   
> -static kvm_pte_t *stage2_memcache_alloc_page(struct stage2_map_data *data)
> -{
> -	kvm_pte_t *ptep = NULL;
> -	struct kvm_mmu_memory_cache *mc = data->memcache;
> -
> -	/* Allocated with GFP_PGTABLE_USER, so no need to zero */
> -	if (mc && mc->nobjs)
> -		ptep = mc->objects[--mc->nobjs];
> -
> -	return ptep;
> -}
> -
>   static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
>   				    struct stage2_map_data *data)
>   {
> @@ -531,7 +519,7 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>   	if (WARN_ON(level == KVM_PGTABLE_MAX_LEVELS - 1))
>   		return -EINVAL;
>   
> -	childp = stage2_memcache_alloc_page(data);
> +	childp = kvm_mmu_memory_cache_alloc(data->memcache);
>   	if (!childp)
>   		return -ENOMEM;
>   
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 4607e9ca60a2..33146d3dc93a 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1154,35 +1154,30 @@ static int stage2_pudp_test_and_clear_young(pud_t *pud)
>   int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>   			  phys_addr_t pa, unsigned long size, bool writable)
>   {
> -	phys_addr_t addr, end;
> +	phys_addr_t addr;
>   	int ret = 0;
> -	unsigned long pfn;
>   	struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, NULL, };
> +	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
> +	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
> +				     KVM_PGTABLE_PROT_R |
> +				     (writable ? KVM_PGTABLE_PROT_W : 0);
>   
> -	end = (guest_ipa + size + PAGE_SIZE - 1) & PAGE_MASK;
> -	pfn = __phys_to_pfn(pa);
> -
> -	for (addr = guest_ipa; addr < end; addr += PAGE_SIZE) {
> -		pte_t pte = kvm_pfn_pte(pfn, PAGE_S2_DEVICE);
> -
> -		if (writable)
> -			pte = kvm_s2pte_mkwrite(pte);
> -
> +	for (addr = guest_ipa; addr < guest_ipa + size; addr += PAGE_SIZE) {
>   		ret = kvm_mmu_topup_memory_cache(&cache,
>   						 kvm_mmu_cache_min_pages(kvm));
>   		if (ret)
> -			goto out;
> +			break;
> +
>   		spin_lock(&kvm->mmu_lock);
> -		ret = stage2_set_pte(&kvm->arch.mmu, &cache, addr, &pte,
> -				     KVM_S2PTE_FLAG_IS_IOMAP);
> +		ret = kvm_pgtable_stage2_map(pgt, addr, PAGE_SIZE, pa, prot,
> +					     &cache);
>   		spin_unlock(&kvm->mmu_lock);
>   		if (ret)
> -			goto out;
> +			break;
>   
> -		pfn++;
> +		pa += PAGE_SIZE;
>   	}
>   
> -out:
>   	kvm_mmu_free_memory_cache(&cache);
>   	return ret;
>   }
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
