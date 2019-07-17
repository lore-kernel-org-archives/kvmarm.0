Return-Path: <SRS0=U5fj=VO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 744CAC76192
	for <kvmarm@archiver.kernel.org>; Wed, 17 Jul 2019 06:43:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ECE0C217F9
	for <kvmarm@archiver.kernel.org>; Wed, 17 Jul 2019 06:43:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="1Vhrd6HE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECE0C217F9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 623824A562;
	Wed, 17 Jul 2019 02:43:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2HYC1aYCUc5j; Wed, 17 Jul 2019 02:43:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63A974A561;
	Wed, 17 Jul 2019 02:43:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD3BB4A561
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jul 2019 02:43:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Nnbs+fycnXqt for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Jul 2019 02:43:22 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E79C4A530
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jul 2019 02:43:22 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id DE6B120651;
 Wed, 17 Jul 2019 06:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1563345801;
 bh=rpX3FlNAUKO8GVGTnuVeNc+iCU/DRSE4jAZjnlhh6/U=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=1Vhrd6HEP6Ym1QpvFRVB2pgGZDP5qGRMoJkZYzXkAT27BZk5SUBotZROwJh1ayhnO
 A8zUaGmoGJ/E0pJrpvM2gBtZDwuJMN8OGYggKcdz90mSOXoLd7PbT1rTrWua8/6X2p
 Za0+sksAuoM3znqHViWu2lp7dyiSu2O3GUGD4ajs=
Date: Wed, 17 Jul 2019 07:43:15 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] MAINTAINERS: Update my email address to @kernel.org
Message-ID: <20190717064315.tn26dss343iv33oj@willie-the-truck>
References: <20190716174308.17147-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190716174308.17147-1-marc.zyngier@arm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Cc: Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Russell King <linux@arm.linux.org.uk>, maz@kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
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

On Tue, Jul 16, 2019 at 06:43:08PM +0100, Marc Zyngier wrote:
> I will soon lose access to my @arm.com email address, so let's
> update the MAINTAINERS file to point to my @kernel.org address,
> as well as .mailmap for good measure.
> 
> Note that my @arm.com address will still work, but someone else
> will be reading whatever is sent there. Don't say you didn't know!
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
> 
> Notes:
>     Yes, I'm sending this from my ARM address. That's intentional.
>     I'll probably send it as part of a pull request later in the
>     cycle, but that's just so that people know what is coming.
> 
>  .mailmap    | 1 +
>  MAINTAINERS | 8 ++++----
>  2 files changed, 5 insertions(+), 4 deletions(-)

Let's see if you manage a better job of getting people to use your new
address than I have:

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
