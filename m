Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7A92C636CB
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 06:31:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 597D061182
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 06:31:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 597D061182
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDA7240856;
	Mon, 19 Jul 2021 02:31:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Aqg501Wr6g-Q; Mon, 19 Jul 2021 02:31:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9ECB940874;
	Mon, 19 Jul 2021 02:31:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A88D540856
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 02:31:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l3jF+umXXxIF for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 02:31:34 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D55C74083E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 02:31:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1626676294;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=+196Kfl7I/cOggKI9/d0VaO8T5ekNSjAsbN7j2ytW0I=;
 b=DYDqEtkDcmtAFVTBbcWk+rI8OW8CkRjagF+0reqs0jXdOJUUqcthFrNiirJyZ/Moj4CioO
 D/CCPH7/vxFxGemBatsgjqw7K9WujauhREZ8A8ptesTxAX6BkQOWRmEzhvYYEeQlsK+jMO
 uyJtSTnL//GagGYepc3kuED0C9CZit4=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-1kYz_NkMM_qizHJn4YazWw-1; Mon, 19 Jul 2021 02:31:33 -0400
X-MC-Unique: 1kYz_NkMM_qizHJn4YazWw-1
Received: by mail-ej1-f69.google.com with SMTP id
 e23-20020a1709062497b0290504bafdd58dso4847795ejb.4
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Jul 2021 23:31:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=+196Kfl7I/cOggKI9/d0VaO8T5ekNSjAsbN7j2ytW0I=;
 b=PUCj3HlCxfBlPF9zdFASnCnwXbC83fUEGGv7klIjrM0TgjSbJZ4MCJ+XjBJOaUh9C8
 qpt0SsqvXq8g/g5VcB7gYIrs+PO6DrHs/rNPC02FrIrhD9MiqS3pDinVtRS5/l5x1peQ
 LTbbYApeDmao6cwnJJNwgDrWdmcLcyrgAUdhoG99+cUtUqpewN7Pts+9/J8Ta6315aVT
 yG4N6siw4Ns7gORYQH7GWZzXXxZYtbO+DkWfXS4emB3t0NBKEDeCCqfoDTt0pqhj00Zz
 Ihb1JMvZTdSDdVqp1ql3YIU4tLXOLOY6iXGGqhEa8DYgJ0Dd/ApOzcmkUKuuWElLiOYX
 5ilw==
X-Gm-Message-State: AOAM533P1OyPapzF+L4NYtbInUqPaTpoKvIldgJVHY0G68kZLduDelQg
 2FBxQyfgPmOBtiI7l7woT8RWqWUwI3B+v7zEZx7PSw0h5Ls2vHgjMuKHFxUe4r4kfnedCG/cBXW
 PuBkqg5x4YjZJzfY2GH/5cb6j
X-Received: by 2002:a17:906:5f99:: with SMTP id
 a25mr26054152eju.101.1626676292015; 
 Sun, 18 Jul 2021 23:31:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwOvrTC0xug9PjA728zKCBsRdaYWyJcTPeNv01/Z04ULpdx8WvrT0arC7Gk/HA8qvC4THAFuA==
X-Received: by 2002:a17:906:5f99:: with SMTP id
 a25mr26054125eju.101.1626676291767; 
 Sun, 18 Jul 2021 23:31:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045?
 ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
 by smtp.gmail.com with ESMTPSA id f20sm5511280ejz.30.2021.07.18.23.31.30
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 18 Jul 2021 23:31:31 -0700 (PDT)
Subject: Re: [PATCH 1/5] KVM: arm64: Walk userspace page tables to compute the
 THP mapping size
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-mm@kvack.org
References: <20210717095541.1486210-1-maz@kernel.org>
 <20210717095541.1486210-2-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c04fc75d-0f2a-3a3f-f698-eaf5e2aa00bd@redhat.com>
Date: Mon, 19 Jul 2021 08:31:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210717095541.1486210-2-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel-team@android.com, Sean Christopherson <seanjc@google.com>,
 Matthew Wilcox <willy@infradead.org>, Will Deacon <will@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
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

On 17/07/21 11:55, Marc Zyngier wrote:
> We currently rely on the kvm_is_transparent_hugepage() helper to
> discover whether a given page has the potential to be mapped as
> a block mapping.
> 
> However, this API doesn't really give un everything we want:
> - we don't get the size: this is not crucial today as we only
>    support PMD-sized THPs, but we'd like to have larger sizes
>    in the future
> - we're the only user left of the API, and there is a will
>    to remove it altogether
> 
> To address the above, implement a simple walker using the existing
> page table infrastructure, and plumb it into transparent_hugepage_adjust().
> No new page sizes are supported in the process.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

If it's okay for you to reuse the KVM page walker that's fine of course, 
but the arch/x86/mm functions lookup_address_in_{mm,pgd} are mostly 
machine-independent and it may make sense to move them to mm/.

That would also allow reusing the x86 function host_pfn_mapping_level.

Paolo

> ---
>   arch/arm64/kvm/mmu.c | 46 ++++++++++++++++++++++++++++++++++++++++----
>   1 file changed, 42 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 3155c9e778f0..db6314b93e99 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -433,6 +433,44 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
>   	return 0;
>   }
>   
> +static struct kvm_pgtable_mm_ops kvm_user_mm_ops = {
> +	/* We shouldn't need any other callback to walk the PT */
> +	.phys_to_virt		= kvm_host_va,
> +};
> +
> +struct user_walk_data {
> +	u32	level;
> +};
> +
> +static int user_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> +		       enum kvm_pgtable_walk_flags flag, void * const arg)
> +{
> +	struct user_walk_data *data = arg;
> +
> +	data->level = level;
> +	return 0;
> +}
> +
> +static int get_user_mapping_size(struct kvm *kvm, u64 addr)
> +{
> +	struct user_walk_data data;
> +	struct kvm_pgtable pgt = {
> +		.pgd		= (kvm_pte_t *)kvm->mm->pgd,
> +		.ia_bits	= VA_BITS,
> +		.start_level	= 4 - CONFIG_PGTABLE_LEVELS,
> +		.mm_ops		= &kvm_user_mm_ops,
> +	};
> +	struct kvm_pgtable_walker walker = {
> +		.cb		= user_walker,
> +		.flags		= KVM_PGTABLE_WALK_LEAF,
> +		.arg		= &data,
> +	};
> +
> +	kvm_pgtable_walk(&pgt, ALIGN_DOWN(addr, PAGE_SIZE), PAGE_SIZE, &walker);
> +
> +	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(data.level));
> +}
> +
>   static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
>   	.zalloc_page		= stage2_memcache_zalloc_page,
>   	.zalloc_pages_exact	= kvm_host_zalloc_pages_exact,
> @@ -780,7 +818,7 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
>    * Returns the size of the mapping.
>    */
>   static unsigned long
> -transparent_hugepage_adjust(struct kvm_memory_slot *memslot,
> +transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
>   			    unsigned long hva, kvm_pfn_t *pfnp,
>   			    phys_addr_t *ipap)
>   {
> @@ -791,8 +829,8 @@ transparent_hugepage_adjust(struct kvm_memory_slot *memslot,
>   	 * sure that the HVA and IPA are sufficiently aligned and that the
>   	 * block map is contained within the memslot.
>   	 */
> -	if (kvm_is_transparent_hugepage(pfn) &&
> -	    fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
> +	if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE) &&
> +	    get_user_mapping_size(kvm, hva) >= PMD_SIZE) {
>   		/*
>   		 * The address we faulted on is backed by a transparent huge
>   		 * page.  However, because we map the compound huge page and
> @@ -1051,7 +1089,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	 * backed by a THP and thus use block mapping if possible.
>   	 */
>   	if (vma_pagesize == PAGE_SIZE && !(force_pte || device))
> -		vma_pagesize = transparent_hugepage_adjust(memslot, hva,
> +		vma_pagesize = transparent_hugepage_adjust(kvm, memslot, hva,
>   							   &pfn, &fault_ipa);
>   
>   	if (fault_status != FSC_PERM && !device && kvm_has_mte(kvm)) {
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
