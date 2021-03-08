Return-Path: <SRS0=mzoY=IG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F15FC433E0
	for <kvmarm@archiver.kernel.org>; Mon,  8 Mar 2021 16:35:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 884EC6522B
	for <kvmarm@archiver.kernel.org>; Mon,  8 Mar 2021 16:35:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 884EC6522B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0ADED4B5FA;
	Mon,  8 Mar 2021 11:35:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2U+yETcM2Jv1; Mon,  8 Mar 2021 11:35:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB30D4B5BC;
	Mon,  8 Mar 2021 11:35:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6EF34B5BC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Mar 2021 11:35:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 19dvph2ZVVn8 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Mar 2021 11:35:02 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5716E4B4FC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Mar 2021 11:35:02 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C22365227;
 Mon,  8 Mar 2021 16:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1615221300;
 bh=/a8q5f9+mgUFjkaLUOWpenLQISW7GAOWifO2INunHhc=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=t5mel8PvzyIhShxoDA+EYt9ooh6ur1wDK1mo2e24m54Zx3cROiOtV0NEhX4/3rRSl
 /TlHqZIXfRKvEQOHpJErHsLES1zBkjwEoExPy6eht2zFRgBtMpqY5ls2zXbjfMo3Pn
 C1J3+tV/nHLvKuNv/hMb/40sr4OIwG0Fg7LZfzb5tYfh6bpBtEUMzd9M/XftoY2IeF
 We5ZbQAUx2VgWHkI4eEwybZK2xxJT+l5Sx7kWe/31C2e2rnE/pjyq0ED4mWGN4oG9d
 bfqXkhSEHSlb5p42qw8nyzwEf1xamImHeIz7i9CtXfsH5iv6hd5MXuAR14aqd1Wx3E
 E8wW/7oQAOKsg==
Date: Mon, 8 Mar 2021 16:34:55 +0000
From: Will Deacon <will@kernel.org>
To: Yanan Wang <wangyanan55@huawei.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Skip the cache flush when coalescing
 tables into a block
Message-ID: <20210308163454.GA26561@willie-the-truck>
References: <20210125141044.380156-1-wangyanan55@huawei.com>
 <20210125141044.380156-3-wangyanan55@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210125141044.380156-3-wangyanan55@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu
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

On Mon, Jan 25, 2021 at 10:10:44PM +0800, Yanan Wang wrote:
> After dirty-logging is stopped for a VM configured with huge mappings,
> KVM will recover the table mappings back to block mappings. As we only
> replace the existing page tables with a block entry and the cacheability
> has not been changed, the cache maintenance opreations can be skipped.
> 
> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
> ---
>  arch/arm64/kvm/mmu.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 8e8549ea1d70..37b427dcbc4f 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -744,7 +744,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  {
>  	int ret = 0;
>  	bool write_fault, writable, force_pte = false;
> -	bool exec_fault;
> +	bool exec_fault, adjust_hugepage;
>  	bool device = false;
>  	unsigned long mmu_seq;
>  	struct kvm *kvm = vcpu->kvm;
> @@ -872,12 +872,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		mark_page_dirty(kvm, gfn);
>  	}
>  
> -	if (fault_status != FSC_PERM && !device)
> +	/*
> +	 * There is no necessity to perform cache maintenance operations if we
> +	 * will only replace the existing table mappings with a block mapping.
> +	 */
> +	adjust_hugepage = fault_granule < vma_pagesize ? true : false;

nit: you don't need the '? true : false' part

That said, your previous patch checks for 'fault_granule > vma_pagesize',
so I'm not sure the local variable helps all that much here because it
obscures the size checks in my opinion. It would be more straight-forward
if we could structure the logic as:


	if (fault_granule < vma_pagesize) {

	} else if (fault_granule > vma_page_size) {

	} else {

	}

With some comments describing what we can infer about the memcache and cache
maintenance requirements for each case.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
