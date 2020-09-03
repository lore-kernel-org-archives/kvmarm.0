Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06919C433E2
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 04:13:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 79CE52071B
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 04:13:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GWIJHder"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 79CE52071B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8A074B340;
	Thu,  3 Sep 2020 00:13:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8-HXXsepL5CB; Thu,  3 Sep 2020 00:13:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 997894B346;
	Thu,  3 Sep 2020 00:13:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC4CF4B337
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 00:13:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iQtYkLPxfSHC for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 00:13:38 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E9F74B346
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 00:13:38 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599106417;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Rq+RcL/kflZe/rFvjt0kr+ANZbQ/zGvh9W2eFhHJr7Y=;
 b=GWIJHder+gnOYKt5o2U+aNGtEarzfl33UaNPVK7rqpTF3mLCqHPTjHe9GTHHrbau648s0/
 ZJA0F+5aatqqnkrG/MB0hWAzWN50waUACcRVd1no8R4V6V2X4FYtDKcWHl6rMqq6RY6fwA
 aAAQRkZyU6MaqWOPwfuCV98VQh6FakM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-TZCb7spnM5a_QkW7fp29ag-1; Thu, 03 Sep 2020 00:13:34 -0400
X-MC-Unique: TZCb7spnM5a_QkW7fp29ag-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D5F61DE00;
 Thu,  3 Sep 2020 04:13:32 +0000 (UTC)
Received: from [10.64.54.159] (vpn2-54-159.bne.redhat.com [10.64.54.159])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D69691002D5A;
 Thu,  3 Sep 2020 04:13:29 +0000 (UTC)
Subject: Re: [PATCH v3 08/21] KVM: arm64: Convert kvm_set_spte_hva() to
 generic page-table API
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-9-will@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <98ceab8b-d612-2111-121f-2a43febab7ea@redhat.com>
Date: Thu, 3 Sep 2020 14:13:28 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200825093953.26493-9-will@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

Hi Will,

On 8/25/20 7:39 PM, Will Deacon wrote:
> Convert kvm_set_spte_hva() to use kvm_pgtable_stage2_map() instead
> of stage2_set_pte().
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/kvm/mmu.c | 23 ++++++++++-------------
>   1 file changed, 10 insertions(+), 13 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 33146d3dc93a..704b471a48ce 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1911,28 +1911,27 @@ int kvm_unmap_hva_range(struct kvm *kvm,
>   
>   static int kvm_set_spte_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
>   {
> -	pte_t *pte = (pte_t *)data;
> +	kvm_pfn_t *pfn = (kvm_pfn_t *)data;
>   
>   	WARN_ON(size != PAGE_SIZE);
> +
>   	/*
> -	 * We can always call stage2_set_pte with KVM_S2PTE_FLAG_LOGGING_ACTIVE
> -	 * flag clear because MMU notifiers will have unmapped a huge PMD before
> -	 * calling ->change_pte() (which in turn calls kvm_set_spte_hva()) and
> -	 * therefore stage2_set_pte() never needs to clear out a huge PMD
> -	 * through this calling path.
> +	 * The MMU notifiers will have unmapped a huge PMD before calling
> +	 * ->change_pte() (which in turn calls kvm_set_spte_hva()) and
> +	 * therefore we never need to clear out a huge PMD through this
> +	 * calling path and a memcache is not required.
>   	 */
> -	stage2_set_pte(&kvm->arch.mmu, NULL, gpa, pte, 0);
> +	kvm_pgtable_stage2_map(kvm->arch.mmu.pgt, gpa, PAGE_SIZE,
> +			       __pfn_to_phys(*pfn), KVM_PGTABLE_PROT_R, NULL);
>   	return 0;
>   }
>   
> -
>   int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
>   {
>   	unsigned long end = hva + PAGE_SIZE;
>   	kvm_pfn_t pfn = pte_pfn(pte);
> -	pte_t stage2_pte;
>   
> -	if (!kvm->arch.mmu.pgd)
> +	if (!kvm->arch.mmu.pgt)
>   		return 0;
>   
>   	trace_kvm_set_spte_hva(hva);
> @@ -1942,9 +1941,7 @@ int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
>   	 * just like a translation fault and clean the cache to the PoC.
>   	 */
>   	clean_dcache_guest_page(pfn, PAGE_SIZE);
> -	stage2_pte = kvm_pfn_pte(pfn, PAGE_S2);
> -	handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &stage2_pte);
> -
> +	handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &pfn);
>   	return 0;
>   }
>   
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
