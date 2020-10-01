Return-Path: <SRS0=046z=DI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84DFCC4727C
	for <kvmarm@archiver.kernel.org>; Thu,  1 Oct 2020 12:28:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DDF0C2087D
	for <kvmarm@archiver.kernel.org>; Thu,  1 Oct 2020 12:28:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="R+6pgUx1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDF0C2087D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 57F6D4B300;
	Thu,  1 Oct 2020 08:28:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id j5++JjcmEpv5; Thu,  1 Oct 2020 08:28:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D4A54B303;
	Thu,  1 Oct 2020 08:28:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5507C4B2FD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Oct 2020 08:28:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RkNgJsu2Wqs3 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Oct 2020 08:28:47 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3524A4B2F8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Oct 2020 08:28:47 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5C5282087D;
 Thu,  1 Oct 2020 12:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1601555326;
 bh=2G4KQGBkH0ZzuyyHWBGZvRU+lHyI2UfSVgymrWTOHpg=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=R+6pgUx1U00BYyDzGVaywzFyyFbWcYmcjPfu+ELEZQSUeqtaCyFMX9+wNNZGaQNAX
 QYOvk4W/je7GyOilaSgafT55hVCxrooJKOboPJ3+KWjbewsSC8HlTmFwz9T1oEaFdG
 EnNnDIz2W61VlGznONE2w+QEVet4dqFDyScvQwv0=
Date: Thu, 1 Oct 2020 13:28:41 +0100
From: Will Deacon <will@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v5 00/21] KVM: arm64: Rewrite page-table code and fault
 handling
Message-ID: <20201001122840.GA18789@willie-the-truck>
References: <20200911132529.19844-1-will@kernel.org>
 <4d89869a-3c36-eadf-ba44-0a65a1fa7d19@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4d89869a-3c36-eadf-ba44-0a65a1fa7d19@arm.com>
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

Hi Alex,

On Thu, Oct 01, 2020 at 11:21:43AM +0100, Alexandru Elisei wrote:
> On 9/11/20 2:25 PM, Will Deacon wrote:
> > It's me again, with version five of the KVM page-table rework previously
> > seen at:
> >
> >   v1: https://lore.kernel.org/r/20200730153406.25136-1-will@kernel.org
> >   v2: https://lore.kernel.org/r/20200818132818.16065-1-will@kernel.org
> >   v3: https://lore.kernel.org/r/20200825093953.26493-1-will@kernel.org
> >   v4: https://lore.kernel.org/r/20200907152344.12978-1-will@kernel.org
> >
> > Changes since v4 include:
> >
> >   * Add comments to the kerneldoc describing alignment behaviour for
> >     addresses and size parameters
> >   * Fix formatting of IPA size messages
> >   * Fix handling of unaligned addresses in kvm_phys_addr_ioremap()
> >   * Add DSB after zeroing stage-2 PGD pages
> >   * Add reviewer tags
> >
> > Once again, thanks to Alex, Gavin and Andrew for their comments.
> 
> I didn't realize that there won't be another iteration of the series. I reviewed
> all the patches with the exception of patch #5 ("KVM: arm64: Use generic allocator
> for hyp stage-1 page-tables") because I don't know much about what needs to mapped
> at EL2 stage 1, everything else looks alright to me. If the commit message can be
> modified, you can add my Reviewed-by tag to the series (sans #5); it's fine if
> that's not possible.

The patches ended up in kvmarm/next as the remaining comments were pretty
minor, so I've just been sending patches on top to clear up the leftovers
(e.g. passing the TLBI level when handling a stage-2 permission fault).

Cheers for your review, the series definitely ended up in a much better
shape for it. The hyp code is a walk in the park compared with the stage-2
parts, so don't worry about skipping that.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
