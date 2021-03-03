Return-Path: <SRS0=lGHe=IB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4EFCC433E0
	for <kvmarm@archiver.kernel.org>; Wed,  3 Mar 2021 21:13:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1E85F64EF8
	for <kvmarm@archiver.kernel.org>; Wed,  3 Mar 2021 21:13:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E85F64EF8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F4DD4B58F;
	Wed,  3 Mar 2021 16:13:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JkoEiy1hd4lF; Wed,  3 Mar 2021 16:13:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0AB34B502;
	Wed,  3 Mar 2021 16:13:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 776CA4B4BC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Mar 2021 16:13:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6uSMDeXJ6B1T for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Mar 2021 16:13:35 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E9FF84B12E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Mar 2021 16:13:34 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1E2E64EC4;
 Wed,  3 Mar 2021 21:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1614806011;
 bh=La069RJVv7lSY65LoO9v4vrFVi06mMCWoGSs5E3bs80=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=ChLlPyKWb/dzGDPuABC1x/e5vhIYdLeTFGQHCU75XumX71T2cxBhQEizAyGm5ILbm
 OnH9//VdNR4ieq71aPR0gWq9xb0G3ZBbVggXbZofYmjYpoMNmOI8IJ0ntQr2dYgLBZ
 +lIIDL2g/ErngnPuC2K9axtXikrtjiaf3WOov/Z7CVUxWeX/eWOjS9BbUlqA+akLsq
 ZkaUQGyFfOM7Ci7sFgOLIflfcwAi3BH2ksW5Ll34EfE9d3INdakvVlGPjIisiXUFWJ
 PdoSNU3rotHuwS+YPkG/wSdwQZRsQ1/ETLAau5/hmNkPeKL/DX/8DYdr8o9e3W/ub+
 KsUcvRP1waJdg==
Date: Wed, 3 Mar 2021 21:13:26 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Fix unaligned addr case in mmu walking
Message-ID: <20210303211325.GA20055@willie-the-truck>
References: <20210303024225.2591-1-justin.he@arm.com>
 <20210303112934.GA18452@willie-the-truck>
 <87mtvkys1y.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87mtvkys1y.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Jia He <justin.he@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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

On Wed, Mar 03, 2021 at 07:07:37PM +0000, Marc Zyngier wrote:
> From e0524b41a71e0f17d6dc8f197e421e677d584e72 Mon Sep 17 00:00:00 2001
> From: Jia He <justin.he@arm.com>
> Date: Wed, 3 Mar 2021 10:42:25 +0800
> Subject: [PATCH] KVM: arm64: Fix range alignment when walking page tables
> 
> When walking the page tables at a given level, and if the start
> address for the range isn't aligned for that level, we propagate
> the misalignment on each iteration at that level.
> 
> This results in the walker ignoring a number of entries (depending
> on the original misalignment) on each subsequent iteration.
> 
> Properly aligning the address at the before the next iteration

"at the before the next" ???

> addresses the issue.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Howard Zhang <Howard.Zhang@arm.com>
> Signed-off-by: Jia He <justin.he@arm.com>
> Fixes: b1e57de62cfb ("KVM: arm64: Add stand-alone page-table walker infrastructure")
> [maz: rewrite commit message]
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20210303024225.2591-1-justin.he@arm.com
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 4d177ce1d536..124cd2f93020 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -223,7 +223,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
>  		goto out;
>  
>  	if (!table) {
> -		data->addr += kvm_granule_size(level);
> +		data->addr = ALIGN(data->addr, kvm_granule_size(level));
>  		goto out;
>  	}

If Jia is happy with it, please feel free to add:

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
