Return-Path: <SRS0=phmX=MT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0324FC4338F
	for <kvmarm@archiver.kernel.org>; Tue, 27 Jul 2021 17:45:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6E2BE60F9C
	for <kvmarm@archiver.kernel.org>; Tue, 27 Jul 2021 17:45:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6E2BE60F9C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CCA3F49FA6;
	Tue, 27 Jul 2021 13:45:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e2y17zbl+Obl; Tue, 27 Jul 2021 13:45:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B506949FE6;
	Tue, 27 Jul 2021 13:45:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22F5A4A1FA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Jul 2021 13:45:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c8mzsSlaFkM9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Jul 2021 13:45:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F229449FA6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Jul 2021 13:45:25 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 44CB11FB;
 Tue, 27 Jul 2021 10:45:25 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F0803F70D;
 Tue, 27 Jul 2021 10:45:23 -0700 (PDT)
Subject: Re: [PATCH v2 5/6] KVM: arm64: Use get_page() instead of kvm_get_pfn()
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-mm@kvack.org
References: <20210726153552.1535838-1-maz@kernel.org>
 <20210726153552.1535838-6-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <21cf5bb7-e70c-345b-be9e-ea009823c255@arm.com>
Date: Tue, 27 Jul 2021 18:46:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210726153552.1535838-6-maz@kernel.org>
Content-Language: en-US
Cc: kernel-team@android.com, Sean Christopherson <seanjc@google.com>,
 Matthew Wilcox <willy@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 7/26/21 4:35 PM, Marc Zyngier wrote:
> When mapping a THP, we are guaranteed that the page isn't reserved,
> and we can safely avoid the kvm_is_reserved_pfn() call.
>
> Replace kvm_get_pfn() with get_page(pfn_to_page()).
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index ebb28dd4f2c9..b303aa143592 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -840,7 +840,7 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
>  		*ipap &= PMD_MASK;
>  		kvm_release_pfn_clean(pfn);
>  		pfn &= ~(PTRS_PER_PMD - 1);
> -		kvm_get_pfn(pfn);
> +		get_page(pfn_to_page(pfn));
>  		*pfnp = pfn;
>  
>  		return PMD_SIZE;

I am not very familiar with the mm subsystem, but I did my best to review this change.

kvm_get_pfn() uses get_page(pfn) if !PageReserved(pfn_to_page(pfn)). I looked at
the documentation for the PG_reserved page flag, and for normal memory, what
looked to me like the most probable situation where that can be set for a
transparent hugepage was for the zero page. Looked at mm/huge_memory.c, and
huge_zero_pfn is allocated via alloc_pages(__GFP_ZERO) (and other flags), which
doesn't call SetPageReserved().

I looked at how a huge page can be mapped from handle_mm_fault and from
khugepaged, and it also looks to like both are using using alloc_pages() to
allocate a new hugepage.

I also did a grep for SetPageReserved(), and there are very few places where that
is called, and none looked like they have anything to do with hugepages.

As far as I can tell, this change is correct, but I think someone who is familiar
with mm would be better suited for reviewing this patch.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
