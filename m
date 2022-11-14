Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB5DC4332F
	for <kvmarm@archiver.kernel.org>; Mon, 14 Nov 2022 20:59:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DC504B8B9;
	Mon, 14 Nov 2022 15:59:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6skfizBoF5xI; Mon, 14 Nov 2022 15:59:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BAC14B83D;
	Mon, 14 Nov 2022 15:59:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C49974B83D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Nov 2022 15:59:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lc3ZNWOpHeMn for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Nov 2022 15:59:23 -0500 (EST)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BFBB549F53
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Nov 2022 15:59:23 -0500 (EST)
Date: Mon, 14 Nov 2022 20:59:13 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668459563;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=hGeByEF7fiPw7L8RkZy6v3SdTEQDaiCEVE4F9gxaZWU=;
 b=QZGj0VnKfsWs4mmYs5F8K2KzfTrFTlQ11QyOmE6mpMfbFQzlOQCUkNNYmyJ+tD7/0LR3Nk
 VwtMk3HwDmV2fJNzQWGHVnZ6ULtAPfFfWVkHX60MD8aEUxv/aJMhqGhgWY+u2IADU8ax1k
 ZbR1yeBw8FU3uOrTPeENLsM5XOYKJNQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [RFC PATCH 01/12] KVM: arm64: Relax WARN check in
 stage2_make_pte()
Message-ID: <Y3KsIUpKISgYRAV9@google.com>
References: <20221112081714.2169495-1-ricarkol@google.com>
 <20221112081714.2169495-2-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221112081714.2169495-2-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
Cc: ricarkol@gmail.com, kvm@vger.kernel.org, catalin.marinas@arm.com,
 kvmarm@lists.linux.dev, andrew.jones@linux.dev, bgardon@google.com,
 maz@kernel.org, dmatlack@google.com, pbonzini@redhat.com,
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

Hi Ricardo,

On Sat, Nov 12, 2022 at 08:17:03AM +0000, Ricardo Koller wrote:
> stage2_make_pte() throws a warning when used in a non-shared walk, as PTEs
> are not "locked" when walking non-shared. Add a check so it can be used
> non-shared.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

I would very much prefer to leave this WARN as-is. Correct me if I am
wrong, but I do not believe this warning is firing with the existing
code.

While the locking portion doesn't make a whole lot of sense for a
non-shared walk, it is also a magic value that indicates we've already
done the break side of break-before-make. If the warning fires then that
would suggest our break-before-make implementation isn't working as
expected.

--
Thanks,
Oliver

> ---
>  arch/arm64/kvm/hyp/pgtable.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index c12462439e70..b16107bf917c 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -733,7 +733,8 @@ static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t n
>  {
>  	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>  
> -	WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
> +	if (kvm_pgtable_walk_shared(ctx))
> +		WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
>  
>  	if (stage2_pte_is_counted(new))
>  		mm_ops->get_page(ctx->ptep);
> -- 
> 2.38.1.431.g37b22c650d-goog
> 
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
