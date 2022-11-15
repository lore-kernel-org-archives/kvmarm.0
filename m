Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FD01C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 15 Nov 2022 13:25:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C63AA4B8DD;
	Tue, 15 Nov 2022 08:25:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lovK+C1L5lyU; Tue, 15 Nov 2022 08:25:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A25024B8DE;
	Tue, 15 Nov 2022 08:25:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9BF14B8DC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2022 08:25:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QSHNtTmr-mNm for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Nov 2022 08:25:41 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B5DD54B8BD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2022 08:25:41 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 69FC06175C;
 Tue, 15 Nov 2022 13:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE73C433C1;
 Tue, 15 Nov 2022 13:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1668518739;
 bh=UM+NUCSnWPwBJSvEkj5YDlxzvPW4Tgd7hH1Drivd2Zs=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=RqZ9uF5m3XKPVewGy4ALND0OQ3MGnKSHjy6twsxd/uCbC94LRX+4P51B1H4QaTxRD
 I0Yy/vswyh50t4VuZYD3hnnTuBbwyd9XFlu5LQWYWY6iS80PIzaXUij+A35UJcrEiX
 aXt8nrrXToBs78xY5yW0ngDQDtSEWbkMBKGpeTs4P8num13y4kByCOzf8c7Lcxb6RS
 YLaeuzgyKOo/3hSbvu/kps+pUtZyMu45nNRH4G5UBCYrbTrFI3F5mWR5nTzMfImfGw
 JQrrE0Z15YULA9373JtK5yDZxF583FEM8EGEUErB24fKur2C12EhbLj+CNG5/SGOr8
 vRjFt987RBnYQ==
Date: Tue, 15 Nov 2022 13:25:34 +0000
From: Will Deacon <will@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 1/1] KVM: arm64: Use a separate function for hyp stage-1
 walks
Message-ID: <20221115132532.GA524@willie-the-truck>
References: <20221114201127.1814794-1-oliver.upton@linux.dev>
 <20221114201127.1814794-2-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221114201127.1814794-2-oliver.upton@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Mon, Nov 14, 2022 at 08:11:27PM +0000, Oliver Upton wrote:
> A subsequent change to the page table walkers adds RCU protection for
> walking stage-2 page tables. KVM uses a global lock to serialize hyp
> stage-1 walks, meaning RCU protection is quite meaningless for
> protecting hyp stage-1 walkers.
> 
> Add a new helper, kvm_pgtable_hyp_walk(), for use when walking hyp
> stage-1 tables. Call directly into __kvm_pgtable_walk() as table
> concatenation is not a supported feature at stage-1.
> 
> No functional change intended.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 24 ++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/setup.c      |  2 +-
>  arch/arm64/kvm/hyp/pgtable.c         | 18 +++++++++++++++---
>  3 files changed, 40 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index a874ce0ce7b5..43b2f1882e11 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -596,6 +596,30 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
>  int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  		     struct kvm_pgtable_walker *walker);
>  
> +/**
> + * kvm_pgtable_hyp_walk() - Walk a hyp stage-1 page-table.
> + * @pgt:	Page-table structure initialized by kvm_pgtable_hyp_init().
> + * @addr:	Input address for the start of the walk.
> + * @size:	Size of the range to walk.
> + * @walker:	Walker callback description.
> + *
> + * The offset of @addr within a page is ignored and @size is rounded-up to
> + * the next page boundary.
> + *
> + * The walker will walk the page-table entries corresponding to the input
> + * address range specified, visiting entries according to the walker flags.
> + * Invalid entries are treated as leaf entries. Leaf entries are reloaded
> + * after invoking the walker callback, allowing the walker to descend into
> + * a newly installed table.
> + *
> + * Returning a negative error code from the walker callback function will
> + * terminate the walk immediately with the same error code.
> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +int kvm_pgtable_hyp_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
> +			 struct kvm_pgtable_walker *walker);

Hmm, this feels like slightly the wrong abstraction to me -- there's nothing
hyp-specific about the problem being solved, it's just that the only user
is for hyp walks.

Could we instead rework 'struct kvm_pgtable' slightly so that the existing
'flags' field is no-longer stage-2 specific and includes a KVM_PGTABLE_LOCKED
flag which could be set by kvm_pgtable_hyp_init()?

That way the top-level API remains unchanged and the existing callers will
continue to work.

Cheers,

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
