Return-Path: <SRS0=hKGY=6M=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99255C83000
	for <kvmarm@archiver.kernel.org>; Tue, 28 Apr 2020 16:26:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 35AEE206D8
	for <kvmarm@archiver.kernel.org>; Tue, 28 Apr 2020 16:26:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35AEE206D8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=atomide.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FB644B17B;
	Tue, 28 Apr 2020 12:26:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uELIhKgBtAax; Tue, 28 Apr 2020 12:26:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 938484B1E3;
	Tue, 28 Apr 2020 12:26:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FDB04B1C2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2020 12:26:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8HwKZUKvrZkW for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Apr 2020 12:26:14 -0400 (EDT)
Received: from muru.com (muru.com [72.249.23.125])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5142B4B17B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2020 12:26:14 -0400 (EDT)
Received: from atomide.com (localhost [127.0.0.1])
 by muru.com (Postfix) with ESMTPS id 8684180F3;
 Tue, 28 Apr 2020 16:27:02 +0000 (UTC)
Date: Tue, 28 Apr 2020 09:26:11 -0700
From: Tony Lindgren <tony@atomide.com>
To: Michael Mrozek <EvilDragon@openpandora.org>
Subject: Re: Against removing aarch32 kvm host support
Message-ID: <20200428162611.GW43721@atomide.com>
References: <20200428143850.4c8cbd2a@luklap>
 <916b6072a4a2688745a5e3f75c1c8c01@misterjones.org>
 <9c67a3722611d1ec9fe1e8a1fbe65956b32147c3.camel@openpandora.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9c67a3722611d1ec9fe1e8a1fbe65956b32147c3.camel@openpandora.org>
Cc: Marc Zyngier <maz@kernel.org>, Lukas Straub <lukasstraub2@web.de>,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel@pyra-handheld.com
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

* Michael Mrozek <EvilDragon@openpandora.org> [200428 14:27]:
> Am Dienstag, den 28.04.2020, 14:30 +0100 schrieb Marc Zyngier:
> I know we have to accept the decision, but so far, I've known Linux to support
> as many older devices as possible as well - removing KVM Host 32bit support
> would be a step back here.
> 
> Is there a specific reason for that?
> Is it too complex to maintain alongside the aarch64 KVM Host?

I don't know the details, but ideally things would be set up
in a way where folks interested in patching 32-bit arm kvm support
can do so without causing issues for 64-bit kvm development.

That being said, I don't know who might be interested in doing
all the work for that. It's unrealistic to expect Marc to do this
work if he's not using it.

Features that are used get more resources, and features that are
less used end up just bitrotting into a broken state in about
six weeks in the Linux kernel :)

Regards,

Tony
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
