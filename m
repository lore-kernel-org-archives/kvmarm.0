Return-Path: <SRS0=A5dY=CQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD51C433E2
	for <kvmarm@archiver.kernel.org>; Mon,  7 Sep 2020 09:27:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AC4522078E
	for <kvmarm@archiver.kernel.org>; Mon,  7 Sep 2020 09:27:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="vnrcJtYn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC4522078E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2831B4B53C;
	Mon,  7 Sep 2020 05:27:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bTjRR4JhUb29; Mon,  7 Sep 2020 05:27:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A58D4B5AD;
	Mon,  7 Sep 2020 05:27:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DFCC4B57A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2020 05:27:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id McYX05Q8DDMJ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Sep 2020 05:27:14 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 306A74B53C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2020 05:27:14 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A0F102078E;
 Mon,  7 Sep 2020 09:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599470833;
 bh=hJWrA9tKtigjNIijRLJIjv4iQzq64DARn5nahcbSs9A=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=vnrcJtYntKO63kJrLXURoI2DXvoh/ps8mT8LqVzFvuzg/nEbkEpl5GIEdaPP2r4V5
 4ywa4ucbSpJWVgviN3Nd7nFnY7njwMnMQsrQQRmbmCl8rf1IsgzURg4xpro0gsprI6
 Li7OKhpjWuKMMAspjyPv83UAHIhhGEu0gxjJLhII=
Date: Mon, 7 Sep 2020 10:27:08 +0100
From: Will Deacon <will@kernel.org>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v3 00/21] KVM: arm64: Rewrite page-table code and fault
 handling
Message-ID: <20200907092707.GA11883@willie-the-truck>
References: <20200825093953.26493-1-will@kernel.org>
 <f7e20f9c-e14e-5314-f78f-1d73743da84c@redhat.com>
 <3f13fc6e-7234-6c53-cfaa-a5052fcabe6d@redhat.com>
 <29ec59b6-ca36-1bd0-0d19-097ecb999bb2@redhat.com>
 <20200903121651.GA7412@willie-the-truck>
 <5aa43d21-30a1-68c8-2620-60a25e4edfa2@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5aa43d21-30a1-68c8-2620-60a25e4edfa2@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On Fri, Sep 04, 2020 at 10:51:58AM +1000, Gavin Shan wrote:
> On 9/3/20 10:16 PM, Will Deacon wrote:
> > Can you try the diff below, please? I think we can end up sticking down a
> > huge-page-sized mapping at an unaligned address, which causes us both to
> > overmap and also to fail to use the huge granule for a block mapping.
> > 
> 
> Since the the following changes have been folded to v4, I reran the test cases
> on v4 and everything works fine.

That's great news, thanks! I'll post that lot later today, assuming I finish
reading email before it gets dark.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
