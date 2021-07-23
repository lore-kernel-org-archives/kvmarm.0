Return-Path: <SRS0=3CJn=MP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7190CC432BE
	for <kvmarm@archiver.kernel.org>; Fri, 23 Jul 2021 15:54:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E701A60E8B
	for <kvmarm@archiver.kernel.org>; Fri, 23 Jul 2021 15:54:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E701A60E8B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 624C84B14E;
	Fri, 23 Jul 2021 11:54:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FmdDQJCRpdRO; Fri, 23 Jul 2021 11:54:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C17A4B14F;
	Fri, 23 Jul 2021 11:54:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CFFC4B14C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Jul 2021 11:54:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kohLYMZeB4eC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Jul 2021 11:54:36 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7585B4B12A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Jul 2021 11:54:36 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E4B5613A1;
 Fri, 23 Jul 2021 08:54:35 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D1C443F73D;
 Fri, 23 Jul 2021 08:54:33 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 2/5] KVM: arm64: Avoid mapping size adjustment on
 permission fault
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-mm@kvack.org
References: <20210717095541.1486210-1-maz@kernel.org>
 <20210717095541.1486210-3-maz@kernel.org>
Message-ID: <a8f42fdf-4cbc-ad10-c8cc-cbbf850f85e4@arm.com>
Date: Fri, 23 Jul 2021 16:55:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210717095541.1486210-3-maz@kernel.org>
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

On 7/17/21 10:55 AM, Marc Zyngier wrote:
> Since we only support PMD-sized mappings for THP, getting
> a permission fault on a level that results in a mapping
> being larger than PAGE_SIZE is a sure indication that we have
> already upgraded our mapping to a PMD.
>
> In this case, there is no need to try and parse userspace page
> tables, as the fault information already tells us everything.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/mmu.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index db6314b93e99..c036a480ca27 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1088,9 +1088,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	 * If we are not forced to use page mapping, check if we are
>  	 * backed by a THP and thus use block mapping if possible.
>  	 */
> -	if (vma_pagesize == PAGE_SIZE && !(force_pte || device))
> -		vma_pagesize = transparent_hugepage_adjust(kvm, memslot, hva,
> -							   &pfn, &fault_ipa);
> +	if (vma_pagesize == PAGE_SIZE && !force_pte) {

Looks like now it's possible to call transparent_hugepage_adjust() for devices (if
fault_status != FSC_PERM). Commit 2aa53d68cee6 ("KVM: arm64: Try stage2 block
mapping for host device MMIO") makes a good case for the !device check. Was the
check removed unintentionally?

> +		if (fault_status == FSC_PERM && fault_granule > PAGE_SIZE)
> +			vma_pagesize = fault_granule;
> +		else
> +			vma_pagesize = transparent_hugepage_adjust(kvm, memslot,
> +								   hva, &pfn,
> +								   &fault_ipa);
> +	}

This change makes sense to me - we can only get stage 2 permission faults on a
leaf entry since stage 2 tables don't have the APTable/XNTable/PXNTable bits. The
biggest block mapping size that we support at stage 2 is PMD size (from
transparent_hugepage_adjust()), therefore if fault_granule is larger than
PAGE_SIZE, then it must be PMD_SIZE.

Thanks,

Alex

>  
>  	if (fault_status != FSC_PERM && !device && kvm_has_mte(kvm)) {
>  		/* Check the VMM hasn't introduced a new VM_SHARED VMA */
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
