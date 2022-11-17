Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A78BC4332F
	for <kvmarm@archiver.kernel.org>; Thu, 17 Nov 2022 17:50:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C51354B775;
	Thu, 17 Nov 2022 12:50:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id L9PjNsnNBDmw; Thu, 17 Nov 2022 12:50:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A38DD4B7D7;
	Thu, 17 Nov 2022 12:50:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18E984B775
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2022 12:50:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rdHh7P9bwaJp for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Nov 2022 12:50:01 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2A9074B75C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2022 12:50:01 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 9209BB8216C;
 Thu, 17 Nov 2022 17:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15822C433C1;
 Thu, 17 Nov 2022 17:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1668707398;
 bh=WnRGHqZfDipdxaPWHgzJwBRqCoXDbebGZ2a9CcK4lgg=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=B8AjFdPgkkWoCHq1oGzAGQ3fg1O6kA7JNCWqx453/ZV1hY7uhaIR6saF72jCBJz6M
 iGPpqk7s3wnxY5r7EI9WXN082NZC4tfJwTEMNpbYXzWJ65WyWT3uwuskTXDr6HgIlV
 NsxO6tRY/RcvBWGwv0mrfpU6EbeySXW1bVGh62KefYP6KXc1WGcuQofSnLHABb3jku
 yQtCqSo9nXDcQXBN1U/LK/qq+eY8PYUKB6rf5RtTBimX4/DF+kSkPLI7WJqHCgTzQb
 ssOmZbZv7iM2eL+VbTm0RmgyLzPFk1m/LjXL/y6QSwWUtdrodw5vuUIzABgDj+EuqA
 X8MyCZc69n2QQ==
Date: Thu, 17 Nov 2022 17:49:52 +0000
From: Will Deacon <will@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v3 2/2] KVM: arm64: Don't acquire RCU read lock for
 exclusive table walks
Message-ID: <20221117174951.GA2916@willie-the-truck>
References: <20221116165655.2649475-1-oliver.upton@linux.dev>
 <20221116165655.2649475-3-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221116165655.2649475-3-oliver.upton@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org,
 Marek Szyprowski <m.szyprowski@samsung.com>
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

On Wed, Nov 16, 2022 at 04:56:55PM +0000, Oliver Upton wrote:
> Marek reported a BUG resulting from the recent parallel faults changes,
> as the hyp stage-1 map walker attempted to allocate table memory while
> holding the RCU read lock:
> 
>   BUG: sleeping function called from invalid context at
>   include/linux/sched/mm.h:274
>   in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
>   preempt_count: 0, expected: 0
>   RCU nest depth: 1, expected: 0
>   2 locks held by swapper/0/1:
>     #0: ffff80000a8a44d0 (kvm_hyp_pgd_mutex){+.+.}-{3:3}, at:
>   __create_hyp_mappings+0x80/0xc4
>     #1: ffff80000a927720 (rcu_read_lock){....}-{1:2}, at:
>   kvm_pgtable_walk+0x0/0x1f4
>   CPU: 2 PID: 1 Comm: swapper/0 Not tainted 6.1.0-rc3+ #5918
>   Hardware name: Raspberry Pi 3 Model B (DT)
>   Call trace:
>     dump_backtrace.part.0+0xe4/0xf0
>     show_stack+0x18/0x40
>     dump_stack_lvl+0x8c/0xb8
>     dump_stack+0x18/0x34
>     __might_resched+0x178/0x220
>     __might_sleep+0x48/0xa0
>     prepare_alloc_pages+0x178/0x1a0
>     __alloc_pages+0x9c/0x109c
>     alloc_page_interleave+0x1c/0xc4
>     alloc_pages+0xec/0x160
>     get_zeroed_page+0x1c/0x44
>     kvm_hyp_zalloc_page+0x14/0x20
>     hyp_map_walker+0xd4/0x134
>     kvm_pgtable_visitor_cb.isra.0+0x38/0x5c
>     __kvm_pgtable_walk+0x1a4/0x220
>     kvm_pgtable_walk+0x104/0x1f4
>     kvm_pgtable_hyp_map+0x80/0xc4
>     __create_hyp_mappings+0x9c/0xc4
>     kvm_mmu_init+0x144/0x1cc
>     kvm_arch_init+0xe4/0xef4
>     kvm_init+0x3c/0x3d0
>     arm_init+0x20/0x30
>     do_one_initcall+0x74/0x400
>     kernel_init_freeable+0x2e0/0x350
>     kernel_init+0x24/0x130
>     ret_from_fork+0x10/0x20
> 
> Since the hyp stage-1 table walkers are serialized by kvm_hyp_pgd_mutex,
> RCU protection really doesn't add anything. Don't acquire the RCU read
> lock for an exclusive walk. While at it, add a warning which codifies
> the lack of support for shared walks in the hypervisor code.
> 
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 22 ++++++++++++++++------
>  arch/arm64/kvm/hyp/pgtable.c         |  4 ++--
>  2 files changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index f23af693e3c5..a07fc5e35a8c 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -229,8 +229,16 @@ static inline kvm_pte_t *kvm_dereference_pteref(struct kvm_pgtable_walker *walke
>  	return pteref;
>  }
>  
> -static inline void kvm_pgtable_walk_begin(void) {}
> -static inline void kvm_pgtable_walk_end(void) {}
> +static inline void kvm_pgtable_walk_begin(struct kvm_pgtable_walker *walker)
> +{
> +	/*
> +	 * Due to the lack of RCU (or a similar protection scheme), only
> +	 * non-shared table walkers are allowed in the hypervisor.
> +	 */
> +	WARN_ON(walker->flags & KVM_PGTABLE_WALK_SHARED);
> +}

I think it would be better to propagate the error to the caller rather
than WARN here. Since you're rejigging things anyway, can you have this
function return int?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
