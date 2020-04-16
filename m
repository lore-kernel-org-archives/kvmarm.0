Return-Path: <SRS0=0qdQ=6A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75245C2BB85
	for <kvmarm@archiver.kernel.org>; Thu, 16 Apr 2020 15:36:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 011792223D
	for <kvmarm@archiver.kernel.org>; Thu, 16 Apr 2020 15:36:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="hieNu+iG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 011792223D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BFB44B116;
	Thu, 16 Apr 2020 11:36:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GD8MGdiQMDgC; Thu, 16 Apr 2020 11:36:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FFA74B12B;
	Thu, 16 Apr 2020 11:36:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9485B4B0F7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 11:36:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id inHB17WYNSve for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Apr 2020 11:36:09 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AF2AB4B0F5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 11:36:09 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 96ED822242;
 Thu, 16 Apr 2020 15:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1587051368;
 bh=qBOX0iZTskqyG9+OVlBWyVCjnXKcHvEcHViiJIZo0uM=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=hieNu+iGSZzJ3N6YlbIBvYAhnyx8PcCzroMmKoBq+Grm18Cj7SkbOIFvR1Xil2LaB
 9AyomDD0uJ/Xbf2bqVdCQl8LOalDvNbi49WHX9dN2C4CXqYMuYWgaJ0XVEuZZY//Bc
 PbhihFe9vTPCGQ/tdzNJq+FNiuc4UffvGnJwLJiA=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jP6Yg-003utE-Rp; Thu, 16 Apr 2020 16:36:07 +0100
Date: Thu, 16 Apr 2020 16:36:05 +0100
From: Marc Zyngier <maz@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Drop PTE_S2_MEMATTR_MASK
Message-ID: <20200416163605.091fa6eb@why>
In-Reply-To: <20200415105746.314-1-yuzenghui@huawei.com>
References: <20200415105746.314-1-yuzenghui@huawei.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 catalin.marinas@arm.com, will@kernel.org, wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: catalin.marinas@arm.com, linux-kernel@vger.kernel.org, will@kernel.org,
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

On Wed, 15 Apr 2020 18:57:46 +0800
Zenghui Yu <yuzenghui@huawei.com> wrote:

> The only user of PTE_S2_MEMATTR_MASK macro had been removed since
> commit a501e32430d4 ("arm64: Clean up the default pgprot setting").
> It has been about six years and no one has used it again.
> 
> Let's drop it.
> 
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>  arch/arm64/include/asm/pgtable-hwdef.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
> index 6bf5e650da78..99315bdca0e6 100644
> --- a/arch/arm64/include/asm/pgtable-hwdef.h
> +++ b/arch/arm64/include/asm/pgtable-hwdef.h
> @@ -190,7 +190,6 @@
>   * Memory Attribute override for Stage-2 (MemAttr[3:0])
>   */
>  #define PTE_S2_MEMATTR(t)	(_AT(pteval_t, (t)) << 2)
> -#define PTE_S2_MEMATTR_MASK	(_AT(pteval_t, 0xf) << 2)
>  
>  /*
>   * EL2/HYP PTE/PMD definitions

Looks good to me. Catalin, Will: do you want to take this directly? If
so please add my:

Acked-by: Marc Zyngier <maz@kernel.org>

Otherwise, I'll route it via the KVM tree.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
