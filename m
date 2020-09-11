Return-Path: <SRS0=CMxQ=CU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C395C43461
	for <kvmarm@archiver.kernel.org>; Fri, 11 Sep 2020 09:16:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BD33222206
	for <kvmarm@archiver.kernel.org>; Fri, 11 Sep 2020 09:16:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD33222206
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toshiba.co.jp
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC01A4B2BA;
	Fri, 11 Sep 2020 05:16:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ha-UqAVzch9S; Fri, 11 Sep 2020 05:16:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 617264B337;
	Fri, 11 Sep 2020 05:16:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF7A34B19B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2020 04:34:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XcUntnOqd8gd for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Sep 2020 04:34:20 -0400 (EDT)
Received: from mo-csw.securemx.jp (mo-csw1514.securemx.jp [210.130.202.153])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DBE1D4B187
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2020 04:34:19 -0400 (EDT)
Received: by mo-csw.securemx.jp (mx-mo-csw1514) id 08B8Y5k9030833;
 Fri, 11 Sep 2020 17:34:05 +0900
X-Iguazu-Qid: 34tMSeeoTP4KRyiZdN
X-Iguazu-QSIG: v=2; s=0; t=1599813245; q=34tMSeeoTP4KRyiZdN;
 m=HJVq5MQecyHkcBp+H+KkIyrPGsf3z9XQfg7af2mu9Js=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
 by relay.securemx.jp (mx-mr1512) id 08B8Y3dJ018385;
 Fri, 11 Sep 2020 17:34:03 +0900
Received: from enc01.toshiba.co.jp ([106.186.93.100])
 by imx2.toshiba.co.jp  with ESMTP id 08B8Y3xD025049;
 Fri, 11 Sep 2020 17:34:03 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
 by enc01.toshiba.co.jp  with ESMTP id 08B8Y213028891;
 Fri, 11 Sep 2020 17:34:03 +0900
From: Punit Agrawal <punit1.agrawal@toshiba.co.jp>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v2] KVM: arm64: Try PMD block mappings if PUD mappings are
 not supported
References: <20200910133351.118191-1-alexandru.elisei@arm.com>
Date: Fri, 11 Sep 2020 17:34:01 +0900
In-Reply-To: <20200910133351.118191-1-alexandru.elisei@arm.com> (Alexandru
 Elisei's message of "Thu, 10 Sep 2020 14:33:51 +0100")
X-TSB-HOP: ON
Message-ID: <87363oogp2.fsf@kokedama.swc.toshiba.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
X-Mailman-Approved-At: Fri, 11 Sep 2020 05:16:14 -0400
Cc: maz@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
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

Hi Alexandru,

Alexandru Elisei <alexandru.elisei@arm.com> writes:

> When userspace uses hugetlbfs for the VM memory, user_mem_abort() tries to
> use the same block size to map the faulting IPA in stage 2. If stage 2
> cannot the same block mapping because the block size doesn't fit in the
> memslot or the memslot is not properly aligned, user_mem_abort() will fall
> back to a page mapping, regardless of the block size. We can do better for
> PUD backed hugetlbfs by checking if a PMD block mapping is supported before
> deciding to use a page.

I think this was discussed in the past.

I have a vague recollection of there being a problem if the user and
stage 2 mappings go out of sync - can't recall the exact details.

Putting it out there in case anybody else on the thread can recall the
details of the previous discussion (offlist).

Though things may have changed and if it passes testing - then maybe I
am mis-remembering. I'll take a closer look at the patch and shout out
if I notice anything.

Thanks,
Punit

>
> vma_pagesize is an unsigned long, use 1UL instead of 1ULL when assigning
> its value.
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
> Tested on a rockpro64 with 4K pages and hugetlbfs hugepagesz=1G (PUD sized
> block mappings).  First test, guest RAM starts at 0x8100 0000
> (memslot->base_gfn not aligned to 1GB); second test, guest RAM starts at
> 0x8000 0000, but is only 512 MB.  In both cases using PUD mappings is not
> possible because either the memslot base address is not aligned, or the
> mapping would extend beyond the memslot.
>
> Without the changes, user_mem_abort() uses 4K pages to map the guest IPA.
> With the patches, user_mem_abort() uses PMD block mappings (2MB) to map the
> guest RAM, which means less TLB pressure and fewer stage 2 aborts.
>
> Changes since v1 [1]:
> - Rebased on top of Will's stage 2 page table handling rewrite, version 4
>   of the series [2]. His series is missing the patch "KVM: arm64: Update
>   page shift if stage 2 block mapping not supported" and there might be a
>   conflict (it's straightforward to fix).
>
> [1] https://www.spinics.net/lists/arm-kernel/msg834015.html
> [2] https://www.spinics.net/lists/arm-kernel/msg835806.html
>
>  arch/arm64/kvm/mmu.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 1041be1fafe4..39c539d4d4cb 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -776,16 +776,25 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	else
>  		vma_shift = PAGE_SHIFT;
>  
> -	vma_pagesize = 1ULL << vma_shift;
>  	if (logging_active ||
> -	    (vma->vm_flags & VM_PFNMAP) ||
> -	    !fault_supports_stage2_huge_mapping(memslot, hva, vma_pagesize)) {
> +	    (vma->vm_flags & VM_PFNMAP)) {
>  		force_pte = true;
> -		vma_pagesize = PAGE_SIZE;
> +		vma_shift = PAGE_SHIFT;
> +	}
> +
> +	if (vma_shift == PUD_SHIFT &&
> +	    !fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
> +	       vma_shift = PMD_SHIFT;
> +
> +	if (vma_shift == PMD_SHIFT &&
> +	    !fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
> +		force_pte = true;
> +		vma_shift = PAGE_SHIFT;
>  	}
>  
> +	vma_pagesize = 1UL << vma_shift;
>  	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
> -		fault_ipa &= huge_page_mask(hstate_vma(vma));
> +		fault_ipa &= ~(vma_pagesize - 1);
>  
>  	gfn = fault_ipa >> PAGE_SHIFT;
>  	mmap_read_unlock(current->mm);
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
