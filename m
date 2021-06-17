Return-Path: <SRS0=srdq=LL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80F49C2B9F4
	for <kvmarm@archiver.kernel.org>; Thu, 17 Jun 2021 12:38:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 01CCC610CA
	for <kvmarm@archiver.kernel.org>; Thu, 17 Jun 2021 12:38:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 01CCC610CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 817544A523;
	Thu, 17 Jun 2021 08:38:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mu0OczMpFEkr; Thu, 17 Jun 2021 08:38:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 568D64A1B0;
	Thu, 17 Jun 2021 08:38:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C18AF49E93
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 08:38:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6YIuAjfr2rGa for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Jun 2021 08:38:44 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A7DFA407B0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 08:38:44 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B617610A5;
 Thu, 17 Jun 2021 12:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1623933523;
 bh=wxVbBQVNCA7My/C1JNhC1Ucq0HI7253+aqXVm04zWO0=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=kF42sZhghGBLxxBAYG3hM4K3omfHY0CMtTE3gJ8Eeqv1iMLRC1IMlfO9QjPowEiEk
 rPipiEg1rA8EyEU4Ulrf344Ng1nL30JAVdlYZMyamoQNL9oHf4TnVXwE929g0Xe3MP
 c8FAmzELoejQ1NODQ1M7M2yjvMZm2qKnq5O0i6YlSIOqL9eVB+o41Filg4S08pzzfl
 w++htxppZ98T2xSvMXpXHu6Pm0S8dx/N2s2OmD+2dNDwYG+ak2BogG4GKGQV4kniag
 R4mM7tJn8p/nzCbbwEchy5CgyUV8RL72kOg3hcT1DcUTjCe5w+Lq1HurZ3ntJtqWNk
 KgLEE4wFcJjGA==
Date: Thu, 17 Jun 2021 13:38:37 +0100
From: Will Deacon <will@kernel.org>
To: Yanan Wang <wangyanan55@huawei.com>
Subject: Re: [PATCH v7 1/4] KVM: arm64: Introduce two cache maintenance
 callbacks
Message-ID: <20210617123837.GA24457@willie-the-truck>
References: <20210617105824.31752-1-wangyanan55@huawei.com>
 <20210617105824.31752-2-wangyanan55@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210617105824.31752-2-wangyanan55@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Thu, Jun 17, 2021 at 06:58:21PM +0800, Yanan Wang wrote:
> To prepare for performing CMOs for guest stage-2 in the fault handlers
> in pgtable.c, here introduce two cache maintenance callbacks in struct
> kvm_pgtable_mm_ops. We also adjust the comment alignment for the
> existing part but make no real content change at all.
> 
> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 42 +++++++++++++++++-----------
>  1 file changed, 25 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index c3674c47d48c..b6ce34aa44bb 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -27,23 +27,29 @@ typedef u64 kvm_pte_t;
>  
>  /**
>   * struct kvm_pgtable_mm_ops - Memory management callbacks.
> - * @zalloc_page:	Allocate a single zeroed memory page. The @arg parameter
> - *			can be used by the walker to pass a memcache. The
> - *			initial refcount of the page is 1.
> - * @zalloc_pages_exact:	Allocate an exact number of zeroed memory pages. The
> - *			@size parameter is in bytes, and is rounded-up to the
> - *			next page boundary. The resulting allocation is
> - *			physically contiguous.
> - * @free_pages_exact:	Free an exact number of memory pages previously
> - *			allocated by zalloc_pages_exact.
> - * @get_page:		Increment the refcount on a page.
> - * @put_page:		Decrement the refcount on a page. When the refcount
> - *			reaches 0 the page is automatically freed.
> - * @page_count:		Return the refcount of a page.
> - * @phys_to_virt:	Convert a physical address into a virtual address mapped
> - *			in the current context.
> - * @virt_to_phys:	Convert a virtual address mapped in the current context
> - *			into a physical address.
> + * @zalloc_page:		Allocate a single zeroed memory page.
> + *				The @arg parameter can be used by the walker
> + *				to pass a memcache. The initial refcount of
> + *				the page is 1.
> + * @zalloc_pages_exact:		Allocate an exact number of zeroed memory pages.
> + *				The @size parameter is in bytes, and is rounded
> + *				up to the next page boundary. The resulting
> + *				allocation is physically contiguous.
> + * @free_pages_exact:		Free an exact number of memory pages previously
> + *				allocated by zalloc_pages_exact.
> + * @get_page:			Increment the refcount on a page.
> + * @put_page:			Decrement the refcount on a page. When the
> + *				refcount reaches 0 the page is automatically
> + *				freed.
> + * @page_count:			Return the refcount of a page.
> + * @phys_to_virt:		Convert a physical address into a virtual address
> + *				mapped in the current context.
> + * @virt_to_phys:		Convert a virtual address mapped in the current
> + *				context into a physical address.
> + * @clean_invalidate_dcache:	Clean and invalidate the data cache for the
> + *				specified memory address range.

This should probably be explicit about whether this to the PoU/PoC/PoP.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
