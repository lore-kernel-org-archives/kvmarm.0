Return-Path: <SRS0=6KZ/=XZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06187C35280
	for <kvmarm@archiver.kernel.org>; Mon, 30 Sep 2019 14:54:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BC0F5218DE
	for <kvmarm@archiver.kernel.org>; Mon, 30 Sep 2019 14:54:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC0F5218DE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09A284A704;
	Mon, 30 Sep 2019 10:54:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uxeiLge43G+f; Mon, 30 Sep 2019 10:54:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09A174A705;
	Mon, 30 Sep 2019 10:54:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 208174A6FE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Sep 2019 10:54:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LFwk2xq4CHwV for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Sep 2019 10:54:02 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 282124A528
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Sep 2019 10:54:02 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 6B7AF301A893;
 Mon, 30 Sep 2019 14:54:01 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DB9AB5C223;
 Mon, 30 Sep 2019 14:53:59 +0000 (UTC)
Date: Mon, 30 Sep 2019 16:53:57 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH 2/3] lib: arm/arm64: Add function to clear
 the PTE_USER bit
Message-ID: <20190930145357.o7pq5ysttui2pjjm@kamzik.brq.redhat.com>
References: <20190930142508.25102-1-alexandru.elisei@arm.com>
 <20190930142508.25102-3-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190930142508.25102-3-alexandru.elisei@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.45]); Mon, 30 Sep 2019 14:54:01 +0000 (UTC)
Cc: kvm@vger.kernel.org, andre.przywara@arm.com, maz@kernel.org,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
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

On Mon, Sep 30, 2019 at 03:25:07PM +0100, Alexandru Elisei wrote:
> The PTE_USER bit (AP[1]) in a page entry means that lower privilege levels
> (EL0, on arm64, or PL0, on arm) can read and write from that memory
> location [1][2]. On arm64, it also implies PXN (Privileged execute-never)
> when is set [3]. Add a function to clear the bit which we can use when we
> want to execute code from that page or the prevent access from lower
> exception levels.
> 
> Make it available to arm too, in case someone needs it at some point.
> 
> [1] ARM DDI 0406C.d, Table B3-6
> [2] ARM DDI 0487E.a, table D5-28
> [3] ARM DDI 0487E.a, table D5-33
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/arm/asm/mmu-api.h |  1 +
>  lib/arm/mmu.c         | 15 +++++++++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
> index df3ccf7bc7e0..8fe85ba31ec9 100644
> --- a/lib/arm/asm/mmu-api.h
> +++ b/lib/arm/asm/mmu-api.h
> @@ -22,4 +22,5 @@ extern void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
>  extern void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
>  			       phys_addr_t phys_start, phys_addr_t phys_end,
>  			       pgprot_t prot);
> +extern void mmu_clear_user(unsigned long vaddr);
>  #endif
> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> index 3d38c8397f5a..78db22e6af14 100644
> --- a/lib/arm/mmu.c
> +++ b/lib/arm/mmu.c
> @@ -217,3 +217,18 @@ unsigned long __phys_to_virt(phys_addr_t addr)
>  	assert(!mmu_enabled() || __virt_to_phys(addr) == addr);
>  	return addr;
>  }
> +
> +void mmu_clear_user(unsigned long vaddr)
> +{
> +	pgd_t *pgtable;
> +	pteval_t *pte;
> +
> +	if (!mmu_enabled())
> +		return;
> +
> +	pgtable = current_thread_info()->pgtable;
> +	pte = get_pte(pgtable, vaddr);
> +
> +	*pte &= ~PTE_USER;
> +	flush_tlb_page(vaddr);
> +}
> -- 
> 2.20.1
>

This is fine, but I think you could just export get_pte() and then
implement the PTE_USER clearing in the cache unit test instead. Anyway,

Reviewed-by: Andrew Jones <drjones@redhat.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
