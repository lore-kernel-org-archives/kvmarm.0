Return-Path: <SRS0=dAAB=IC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FE96C433DB
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 14:06:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F248F64F0A
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 14:06:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F248F64F0A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8301D4B644;
	Thu,  4 Mar 2021 09:06:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d3ah-WPmmKLY; Thu,  4 Mar 2021 09:06:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F6064B5FE;
	Thu,  4 Mar 2021 09:06:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1D184B4DC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 09:06:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I-KONu0txcCx for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Mar 2021 09:06:09 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ACC224B4A0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 09:06:09 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id E38AB64EEC;
 Thu,  4 Mar 2021 14:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1614866768;
 bh=1dXhPHcdLiOgxzEHJx0A7ZK7YsqkFUlqYImM4D6WVdg=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=NlGpZRnGSxPTSr+AY8pgAiSms8x+YYKquffA2x0ApYgl6yRgalGYhrmrc37OzlIzp
 VZ2GtuxlvDh6p9HWHthhiPHMU0iIZ3SvZdMa3NP70IeJpkoKEPAdVh9+ZSR/eK9UV1
 iv5u1/Lh692rC4Lb0j4PJvNC0anvYYeEXaTlFNkM7m8fbX1lWrYBQX/gfqqvrXOBfv
 9BB0kxeL3AfbJ1jApFr0Q8sUP0dwn7Tyl2stprU0dST8dGjtdlLlo4Eh3++eXZ2MB6
 872gei5nFmauoLJYvc1deoe8SvrJMPjWQrpfBRVajyPmOU6MFyMJAJzaMobejqYHuk
 RRRgyPIJzCFTw==
Date: Thu, 4 Mar 2021 14:06:02 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v3 06/32] KVM: arm64: Factor memory allocation out of
 pgtable.c
Message-ID: <20210304140602.GC21229@willie-the-truck>
References: <20210302150002.3685113-1-qperret@google.com>
 <20210302150002.3685113-7-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210302150002.3685113-7-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 seanjc@google.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Tue, Mar 02, 2021 at 02:59:36PM +0000, Quentin Perret wrote:
> In preparation for enabling the creation of page-tables at EL2, factor
> all memory allocation out of the page-table code, hence making it
> re-usable with any compatible memory allocator.
> 
> No functional changes intended.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 41 +++++++++++-
>  arch/arm64/kvm/hyp/pgtable.c         | 98 +++++++++++++++++-----------
>  arch/arm64/kvm/mmu.c                 | 66 ++++++++++++++++++-
>  3 files changed, 163 insertions(+), 42 deletions(-)

Just a few nits:

> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 8886d43cfb11..3c306f90f7da 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -13,17 +13,50 @@
>  
>  typedef u64 kvm_pte_t;
>  
> +/**
> + * struct kvm_pgtable_mm_ops - Memory management callbacks.
> + * @zalloc_page:	Allocate a single zeroed memory page. The @arg parameter
> + *			can be used by the walker to pass a memcache. The
> + *			initial refcount of the page is 1.
> + * @zalloc_pages_exact:	Allocate an exact number of zeroed memory pages. The
> + *			@size parameter is in bytes, it is automatically rounded
> + *			to PAGE_SIZE and the resulting allocation is physically
> + *			contiguous.

It's not clear to me whether "it is automatically rounded to PAGE_SIZE"
means that the caller or the callee does the rounding. If it's the caller,
maybe it would be better to pass the number of pages as an 'npages' argument
instead of the size in bytes?

> + * @free_pages_exact:	Free an exact number of memory pages, to free memory
> + *			allocated with zalloc_pages_exact.

"Free an exact number of memory pages previously allocated by
 zalloc_pages_exact()"


> + * @get_page:		Increment the refcount on a page.
> + * @put_page:		Decrement the refcount on a page. When the refcount
> + *			reaches 0 the page is automatically freed.
> + * @page_count:		Return the refcount of a page.
> + * @phys_to_virt:	Convert a physical address into a virtual address as
> + *			accessible in the current context.

s/as accessible/mapped/

With those changes:

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
