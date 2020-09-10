Return-Path: <SRS0=WCH4=CT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 519ACC07548
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 10:54:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AC57D21D7E
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 10:54:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="lr18JbvI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC57D21D7E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F09524B241;
	Thu, 10 Sep 2020 06:54:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I+ONUoFBT5ek; Thu, 10 Sep 2020 06:54:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFA484B26E;
	Thu, 10 Sep 2020 06:54:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B2A164B245
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 06:54:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yEgfB3Y0-yX5 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Sep 2020 06:54:14 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C40B74B241
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 06:54:14 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A5E8720872;
 Thu, 10 Sep 2020 10:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599735253;
 bh=/9fxCNTeG0p5T33rcr7qlqTsh0KmjrfXRkR29TMbHXo=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=lr18JbvI0H1neQnQIZkwI2FXuO4Z4uarUPH76CrjZTDsHAME+8rNMHcd0EmDFW2mK
 Xsjkun8bAzfnVk+qNsumGrmt3HMyRCFo72Zqk7RdPzeqWnYvg5PqC/zc5N3EinMRp/
 BlY1ZnW1ize6jcQeXdBfgxwRZvNVWQl8SUyjdwvE=
Date: Thu, 10 Sep 2020 11:54:09 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v4 19/21] KVM: arm64: Remove unused page-table code
Message-ID: <20200910105408.GB17887@willie-the-truck>
References: <20200907152344.12978-1-will@kernel.org>
 <20200907152344.12978-20-will@kernel.org>
 <6674b70b99e82fb8084f801bfca84f37@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6674b70b99e82fb8084f801bfca84f37@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Catalin Marinas <catalin.marinas@arm.com>, kernel-team@android.com,
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

On Tue, Sep 08, 2020 at 11:33:35AM +0100, Marc Zyngier wrote:
> On 2020-09-07 16:23, Will Deacon wrote:
> > diff --git a/arch/arm64/include/asm/pgtable-hwdef.h
> > b/arch/arm64/include/asm/pgtable-hwdef.h
> > index 1a989353144e..bb97d464f42b 100644
> > --- a/arch/arm64/include/asm/pgtable-hwdef.h
> > +++ b/arch/arm64/include/asm/pgtable-hwdef.h
> > @@ -172,23 +172,6 @@
> >  #define PTE_ATTRINDX(t)		(_AT(pteval_t, (t)) << 2)
> >  #define PTE_ATTRINDX_MASK	(_AT(pteval_t, 7) << 2)
> > 
> > -/*
> > - * 2nd stage PTE definitions
> > - */
> > -#define PTE_S2_RDONLY		(_AT(pteval_t, 1) << 6)   /* HAP[2:1] */
> > -#define PTE_S2_RDWR		(_AT(pteval_t, 3) << 6)   /* HAP[2:1] */
> > -#define PTE_S2_XN		(_AT(pteval_t, 2) << 53)  /* XN[1:0] */
> > -#define PTE_S2_SW_RESVD		(_AT(pteval_t, 15) << 55) /* Reserved for SW
> > */
> > -
> > -#define PMD_S2_RDONLY		(_AT(pmdval_t, 1) << 6)   /* HAP[2:1] */
> > -#define PMD_S2_RDWR		(_AT(pmdval_t, 3) << 6)   /* HAP[2:1] */
> > -#define PMD_S2_XN		(_AT(pmdval_t, 2) << 53)  /* XN[1:0] */
> > -#define PMD_S2_SW_RESVD		(_AT(pmdval_t, 15) << 55) /* Reserved for SW
> > */
> > -
> > -#define PUD_S2_RDONLY		(_AT(pudval_t, 1) << 6)   /* HAP[2:1] */
> > -#define PUD_S2_RDWR		(_AT(pudval_t, 3) << 6)   /* HAP[2:1] */
> > -#define PUD_S2_XN		(_AT(pudval_t, 2) << 53)  /* XN[1:0] */
> > -
> >  /*
> >   * Memory Attribute override for Stage-2 (MemAttr[3:0])
> >   */
> 
> This breaks the (still out of tree) NV patches, which use some of
> these definitions as part of the architectural S2 PTW.
> 
> I can either keep a KVM-private copy, or revert this hunk. What do
> you think?

I'd be inclined to stick a private copy in your .c file, and perhaps we can
try to move NV over to the new page-table code in the future (which will
definitely need some extensions to handle the walk).

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
