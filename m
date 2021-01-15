Return-Path: <SRS0=f0/l=GS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86FB2C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 10:23:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EA932236FB
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 10:23:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA932236FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63D704B19E;
	Fri, 15 Jan 2021 05:23:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oVgYFAi+DKc1; Fri, 15 Jan 2021 05:23:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 556C34B177;
	Fri, 15 Jan 2021 05:23:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C69744B177
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 05:23:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gSOmgZmsBZgK for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2021 05:23:42 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B880C4B141
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 05:23:42 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 621BE235F9;
 Fri, 15 Jan 2021 10:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1610706221;
 bh=c/+XqWLmQTEyndmY4XhHmEat6eBL2W+LzNHlJg1xGlc=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=GQwIacPmjs/aOm4bQ1rFpzSRDHy739OTYVDLZinf3vIbt7XaORjK14OSbDSdGh6Ij
 7DOaM4QxtaG0JZsU18PjC4KvQa6bGICy8UpXQw29+cxhdYimqTY9stfbshm+JhT/cf
 O821VSuzWQTvjgPq0kr+fXNYeQ1z207Ns8XMzOb7LQpsEu+vFr1+8V8TLI0u9i7PFs
 Z5bY3BeoxFG57wfFcqto6uPrpKzc3NlFGlVWKMEO+wX9/J5iLo2exKI16IJ1DGDZdB
 3c4P0oFfKYtWfyHSPqCxayXwV4nWDUlKHeBadwhZArU4E9Q7ZPhnmoyQNBaIjUW+aX
 q5yeMNOO4fmBw==
Date: Fri, 15 Jan 2021 10:23:35 +0000
From: Will Deacon <will@kernel.org>
To: Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH] kvm: arm64: Properly align the end address of table walk
Message-ID: <20210115102334.GA14167@willie-the-truck>
References: <20210115095307.12912-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210115095307.12912-1-zhukeqian1@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Daniel Lezcano <daniel.lezcano@linaro.org>, linux-kernel@vger.kernel.org,
 Alexios Zavras <alexios.zavras@intel.com>, Marc Zyngier <maz@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Robin Murphy <robin.murphy@arm.com>,
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

On Fri, Jan 15, 2021 at 05:53:07PM +0800, Keqian Zhu wrote:
> When align the end address, ought to use its original value.
> 
> Fixes: b1e57de62cfb ("KVM: arm64: Add stand-alone page-table walker infrastructure")
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index bdf8e55ed308..670b0ef12440 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -296,7 +296,7 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  	struct kvm_pgtable_walk_data walk_data = {
>  		.pgt	= pgt,
>  		.addr	= ALIGN_DOWN(addr, PAGE_SIZE),
> -		.end	= PAGE_ALIGN(walk_data.addr + size),
> +		.end	= PAGE_ALIGN(addr + size),
>  		.walker	= walker,

Hmm, this is a change in behaviour, no (consider the case where both 'addr'
and 'size' are misaligned)? The current code is consistent with the
kerneldoc in asm/kvm_pgtable.h, so I don't see the motivation to change it.

Did you hit a bug somewhere?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
