Return-Path: <SRS0=rJEk=G7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2CE6C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 28 Jan 2021 20:11:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3A79C64DFF
	for <kvmarm@archiver.kernel.org>; Thu, 28 Jan 2021 20:11:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A79C64DFF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AF114B21F;
	Thu, 28 Jan 2021 15:11:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e1lec9aegRJ5; Thu, 28 Jan 2021 15:11:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 48D714B222;
	Thu, 28 Jan 2021 15:11:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 187AB4B201
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2021 15:11:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oiFPW5ZnYU7T for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Jan 2021 15:11:08 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1EED94B1C8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2021 15:11:08 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id B83FD64E01;
 Thu, 28 Jan 2021 20:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1611864666;
 bh=zHMQgiO9iZW35Wo0flSjRRcYy/YjyzJRscd21DnHzGs=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=dbfw7DkPSaQ1HKLDpvsBwtHmG7PMn5Ot7V2hI0loUfjG84JvFf9+txbcJL0HAVO73
 mN4EpJCmzYhjLSOquS+KAht9Ey72t6Ik8ZsAj0gnae8Qn2Jw1w5xlKSajtGBM7bCI7
 7S7agkShiRY4+cJm61QQUZVedzhqwgDGodP1qsc/4Eptvb9ejZqmzGqfCRvTImmYEP
 VYiqrkeHCVPReEmntRwV+xNj3n6FRyrHibbOTri+eOgdtuZAssiKHzt1rA35ThYYVG
 IYfsxqVIm1n7mzFPsZAcwv/R3+rdZb7fZXCV5g2gGf2BrB+8hxSeKkixfz8GerI1zB
 hm6eGtSzX/HGw==
Date: Thu, 28 Jan 2021 20:11:02 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Move __hyp_set_vectors out of .hyp.text
Message-ID: <20210128201101.GA3016@willie-the-truck>
References: <20210128173850.2478161-1-qperret@google.com>
 <d64f85c885701719d5f607c3d2f12600@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d64f85c885701719d5f607c3d2f12600@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: catalin.marinas@arm.com, kernel-team@android.com,
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

On Thu, Jan 28, 2021 at 06:11:52PM +0000, Marc Zyngier wrote:
> On 2021-01-28 17:38, Quentin Perret wrote:
> > The .hyp.text section is supposed to be reserved for the nVHE EL2 code.
> > However, there is currently one occurrence of EL1 executing code located
> > in .hyp.text when calling __hyp_{re}set_vectors(), which happen to sit
> > next to the EL2 stub vectors. While not a problem yet, such patterns
> > will cause issues when removing the host kernel from the TCB, so a
> > cleaner split would be preferable.
> > 
> > Fix this by delimiting the end of the .hyp.text section in hyp-stub.S.
> > 
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/kernel/hyp-stub.S | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
> > index 160f5881a0b7..8a60f9c586bb 100644
> > --- a/arch/arm64/kernel/hyp-stub.S
> > +++ b/arch/arm64/kernel/hyp-stub.S
> > @@ -85,6 +85,8 @@ SYM_CODE_END(\label)
> >  	invalid_vector	el1_fiq_invalid
> >  	invalid_vector	el1_error_invalid
> > 
> > +	.popsection
> > +
> >  /*
> >   * __hyp_set_vectors: Call this after boot to set the initial
> > hypervisor
> >   * vectors as part of hypervisor installation.  On an SMP system, this
> > should
> 
> Thanks for tracking this one down, Quentin.
> 
> Catalin, Will: should you want to take this one via the arm64 tree,
> please add my
> 
> Acked-by: Marc Zyngier <maz:kernel.org>

Cheers, I'll pick this up for 5.12 with your Ack.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
