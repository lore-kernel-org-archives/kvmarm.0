Return-Path: <SRS0=0qdQ=6A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2DB3C352BE
	for <kvmarm@archiver.kernel.org>; Thu, 16 Apr 2020 17:05:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 761D220732
	for <kvmarm@archiver.kernel.org>; Thu, 16 Apr 2020 17:05:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="effOu2Xi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 761D220732
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 018C24B206;
	Thu, 16 Apr 2020 13:05:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q97vOu6kfbue; Thu, 16 Apr 2020 13:05:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD1B84B201;
	Thu, 16 Apr 2020 13:05:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86B154B201
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 13:05:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tf6bj0iQ2ZjW for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Apr 2020 13:05:45 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9674A4B13C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 13:05:45 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4E88F20732;
 Thu, 16 Apr 2020 17:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1587056744;
 bh=yvKxJ0oqI8tAb7XGYBeopy2h/oK1YUZKnUOgcn1sW7c=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=effOu2XiYpIAUEIWQ3do9dPFE/zgnIpN5HBFfHEl1XFwI3GcIBF2htju2SYwTBLtu
 0GqtALsJONiT8hngxN44EXw49w6kRbEHeyskiG39W8gTZizvMt0xUkNi0wESbALG1A
 2JSJFebvJDi0kg/wkOVlvAh9KPgP0Paf2LpAfHJA=
Date: Thu, 16 Apr 2020 18:05:40 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Drop PTE_S2_MEMATTR_MASK
Message-ID: <20200416170539.GC32685@willie-the-truck>
References: <20200415105746.314-1-yuzenghui@huawei.com>
 <20200416163605.091fa6eb@why>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200416163605.091fa6eb@why>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
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

On Thu, Apr 16, 2020 at 04:36:05PM +0100, Marc Zyngier wrote:
> On Wed, 15 Apr 2020 18:57:46 +0800
> Zenghui Yu <yuzenghui@huawei.com> wrote:
> 
> > The only user of PTE_S2_MEMATTR_MASK macro had been removed since
> > commit a501e32430d4 ("arm64: Clean up the default pgprot setting").
> > It has been about six years and no one has used it again.
> > 
> > Let's drop it.
> > 
> > Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> > ---
> >  arch/arm64/include/asm/pgtable-hwdef.h | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
> > index 6bf5e650da78..99315bdca0e6 100644
> > --- a/arch/arm64/include/asm/pgtable-hwdef.h
> > +++ b/arch/arm64/include/asm/pgtable-hwdef.h
> > @@ -190,7 +190,6 @@
> >   * Memory Attribute override for Stage-2 (MemAttr[3:0])
> >   */
> >  #define PTE_S2_MEMATTR(t)	(_AT(pteval_t, (t)) << 2)
> > -#define PTE_S2_MEMATTR_MASK	(_AT(pteval_t, 0xf) << 2)
> >  
> >  /*
> >   * EL2/HYP PTE/PMD definitions
> 
> Looks good to me. Catalin, Will: do you want to take this directly? If
> so please add my:
> 
> Acked-by: Marc Zyngier <maz@kernel.org>
> 
> Otherwise, I'll route it via the KVM tree.

I can take it for 5.8 if it's not urgent.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
