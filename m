Return-Path: <SRS0=VRSS=UC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BC18C04AB5
	for <kvmarm@archiver.kernel.org>; Mon,  3 Jun 2019 14:07:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 192F5279BD
	for <kvmarm@archiver.kernel.org>; Mon,  3 Jun 2019 14:07:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 192F5279BD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BC054A4E8;
	Mon,  3 Jun 2019 10:07:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id alB8ofDzWmb1; Mon,  3 Jun 2019 10:07:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A7474A4BD;
	Mon,  3 Jun 2019 10:07:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 022DA4A409
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Jun 2019 10:07:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XUH8qURRzQjz for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Jun 2019 10:07:10 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2B744A2E7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Jun 2019 10:07:10 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1E51515A2;
 Mon,  3 Jun 2019 07:07:10 -0700 (PDT)
Received: from fuggles.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 73AA43F246;
 Mon,  3 Jun 2019 07:07:08 -0700 (PDT)
Date: Mon, 3 Jun 2019 15:07:06 +0100
From: Will Deacon <will.deacon@arm.com>
To: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH kvmtool v3 5/9] KVM: arm/arm64: Add a vcpu feature for
 pointer authentication
Message-ID: <20190603140706.GB28296@fuggles.cambridge.arm.com>
References: <1559229194-3036-1-git-send-email-Dave.Martin@arm.com>
 <1559229194-3036-6-git-send-email-Dave.Martin@arm.com>
 <20190531180416.3e87f5ad@donnerap.cambridge.arm.com>
 <20190603112302.GN28398@e103592.cambridge.arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190603112302.GN28398@e103592.cambridge.arm.com>
User-Agent: Mutt/1.11.1+86 (6f28e57d73f2) ()
Cc: Christoffer Dall <cdall@kernel.org>, Marc Zyngier <marc.zyngier@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
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

On Mon, Jun 03, 2019 at 12:23:03PM +0100, Dave Martin wrote:
> On Fri, May 31, 2019 at 06:04:16PM +0100, Andre Przywara wrote:
> > On Thu, 30 May 2019 16:13:10 +0100
> > Dave Martin <Dave.Martin@arm.com> wrote:
> > 
> > > From: Amit Daniel Kachhap <amit.kachhap@arm.com>
> > > 
> > > This patch adds a runtime capabality for KVM tool to enable Arm64 8.3
> > > Pointer Authentication in guest kernel. Two vcpu features
> > > KVM_ARM_VCPU_PTRAUTH_[ADDRESS/GENERIC] are supplied together to enable
> > > Pointer Authentication in KVM guest after checking the capability.
> > > 
> > > Command line options --enable-ptrauth and --disable-ptrauth are added
> > > to use this feature. However, if those options are not provided then
> > > also this feature is enabled if host supports this capability.
> > 
> > I don't really get the purpose of two options, I think that's quite
> > confusing. Should the first one either be dropped at all or called
> > something with "force"?
> > 
> > I guess the idea is to fail if pointer auth isn't available, but the
> > option is supplied?
> > 
> > Or maybe have one option with parameters?
> > --ptrauth[,=enable,=disable]
> 
> So, I was following two principles here, either or both of which may be
> bogus:
> 
> 1) There should be a way to determine whether KVM turns a given feature
> on or off (instead of magically defaulting to something).
> 
> 2) To a first approaximation, kvmtool should allow each major KVM ABI
> feature to be exercised.
> 
> 3) By default, kvmtool should offer the maximum feature set possible to
> the guest.
> 
> 
> (3) is well established, but (1) and (2) may be open to question?
> 
> If we hold to both principles, it makes sense to have options
> functionally equivalent to what I suggested (where KVM provides the
> control in the first place), but there may be more convenient ways
> to respell the options.
> 
> If we really can't decide, maybe it's better to drop the options
> altogether until we have a real use case.
> 
> I've found the options very useful for testing and debugging on the SVE
> side, but I can't comment on ptrauth.  Maybe someone else has a view?

I'd prefer to drop them, to be honest. Whilst they may have been useful
during SVE development, it's not clear to me that they will continue to
be as useful now that things should be settling down. It's probably useful
to print out any features that we've explicitly enabled (or failed to
enable), but I'd stop there for the time being.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
