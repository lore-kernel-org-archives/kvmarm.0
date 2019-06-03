Return-Path: <SRS0=VRSS=UC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18398C04AB5
	for <kvmarm@archiver.kernel.org>; Mon,  3 Jun 2019 11:12:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 96DED247FB
	for <kvmarm@archiver.kernel.org>; Mon,  3 Jun 2019 11:12:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 96DED247FB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13F074A4E8;
	Mon,  3 Jun 2019 07:12:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gyfU6IDbBifd; Mon,  3 Jun 2019 07:12:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA4EA4A3B2;
	Mon,  3 Jun 2019 07:12:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11DEB4A3B2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Jun 2019 07:12:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VgaoSUgyqapw for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Jun 2019 07:12:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B543A4A319
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Jun 2019 07:12:26 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 327D3A78;
 Mon,  3 Jun 2019 04:12:26 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 874683F5AF;
 Mon,  3 Jun 2019 04:12:24 -0700 (PDT)
Date: Mon, 3 Jun 2019 12:12:22 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH kvmtool v3 6/9] arm/arm64: Factor out ptrauth vcpu
 feature setup
Message-ID: <20190603111221.GK28398@e103592.cambridge.arm.com>
References: <1559229194-3036-1-git-send-email-Dave.Martin@arm.com>
 <1559229194-3036-7-git-send-email-Dave.Martin@arm.com>
 <20190531180436.118450c5@donnerap.cambridge.arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190531180436.118450c5@donnerap.cambridge.arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: Christoffer Dall <cdall@kernel.org>, Marc Zyngier <marc.zyngier@arm.com>,
 Will Deacon <will.deacon@arm.com>,
 Kristina Martsenko <kristina.martsenko@arm.com>,
 Zhang Lei <zhang.lei@jp.fujitsu.com>,
 Amit Daniel Kachhap <amit.kachhap@arm.com>, kvmarm@lists.cs.columbia.edu,
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

On Fri, May 31, 2019 at 06:04:36PM +0100, Andre Przywara wrote:
> On Thu, 30 May 2019 16:13:11 +0100
> Dave Martin <Dave.Martin@arm.com> wrote:
> 
> > In the interest of readability, factor out the vcpu feature setup
> > for ptrauth into a separate function.
> > 
> > Also, because aarch32 doesn't have this feature or the related
> > command line options anyway, move the actual code into aarch64/.
> > 
> > Since ARM_VCPU_PTRAUTH_FEATURE is only there to make the ptrauth
> > feature setup code compile on arm, it is no longer needed: inline
> > and remove it.
> 
> I am not sure this is useful as a separate patch, so can we just merge
> this into 5/9?

Could be.  I wanted to keep the changes against Amit's original patch
clear for now, so it's easier for him to review.

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
