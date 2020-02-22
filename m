Return-Path: <SRS0=wpbN=4K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 793DAC35671
	for <kvmarm@archiver.kernel.org>; Sat, 22 Feb 2020 19:17:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 35BB220702
	for <kvmarm@archiver.kernel.org>; Sat, 22 Feb 2020 19:17:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=yoshi.email header.i=@yoshi.email header.b="RVAIacea"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35BB220702
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=yoshi.email
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D12414AF6F;
	Sat, 22 Feb 2020 14:17:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@yoshi.email
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oaabcYFApR1J; Sat, 22 Feb 2020 14:17:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA2D34AF72;
	Sat, 22 Feb 2020 14:17:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56C7C4AEF5
 for <kvmarm@lists.cs.columbia.edu>; Sat, 22 Feb 2020 09:40:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C6lmPWnSed4t for <kvmarm@lists.cs.columbia.edu>;
 Sat, 22 Feb 2020 09:40:41 -0500 (EST)
Received: from mail-gateway-shared10.cyon.net (mail-gateway-shared10.cyon.net
 [194.126.200.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 378574AEDD
 for <kvmarm@lists.cs.columbia.edu>; Sat, 22 Feb 2020 09:40:41 -0500 (EST)
Received: from s054.cyon.net ([149.126.4.63])
 by mail-gateway-shared10.cyon.net with esmtpsa
 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256) (Exim)
 (envelope-from <takashi@yoshi.email>) id 1j5VxJ-0001zS-N4
 for kvmarm@lists.cs.columbia.edu; Sat, 22 Feb 2020 15:40:39 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=yoshi.email
 ; s=default;
 h=Content-Transfer-Encoding:Content-Type:MIME-Version:References
 :In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=pY8QHspx3GjurZhopnwNDDR9kkSIXqX19Xrqh436IEY=; b=RVAIacea5JXySvXDZ/XPBnrpCC
 Y7j3kbj1i62sZwbvRVhYg8YlM+KKazyyoqSybS19W5Vb+AwWjakqPE/Xhr9ZB4p7FTFOHltRmjF1G
 6wLKBF9UW6aBu4itascnuSs9lb9WteYeO4OxeVihTdnDSi1jgY4cijRZOISsrx95Z5GcTaxEXXhtC
 xc54+Ies8Y2fuom7QTReHakdF9+VBHu218KWX9v1H8Qr0Kvt8Dbdzv00tScZBBew+p9WB827mRzBF
 Kkpr/y/rbb7fvI5rFkd35QwqwFhqAr7J9C7R0NGO3YRcEcC2Br3y8mV0kVw6UsFhQ0pL5JD3akk3b
 cO36zGgA==;
Received: from [10.20.10.233] (port=37274 helo=mail.cyon.ch)
 by s054.cyon.net with esmtpa (Exim 4.92)
 (envelope-from <takashi@yoshi.email>)
 id 1j5VxI-006jaL-BJ; Sat, 22 Feb 2020 15:40:32 +0100
Date: Sat, 22 Feb 2020 15:40:30 +0100
From: Takashi Yoshi <takashi@yoshi.email>
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Removing support for 32bit KVM/arm host
Message-ID: <20200222154030.5625fa5f.takashi@yoshi.email>
In-Reply-To: <20200210141324.21090-1-maz@kernel.org>
References: <20200210141324.21090-1-maz@kernel.org>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; armv7a-unknown-linux-gnueabihf)
MIME-Version: 1.0
X-AntiAbuse: This header was added to track abuse,
 please include it with any abuse report
X-AntiAbuse: Primary Hostname - s054.cyon.net
X-AntiAbuse: Original Domain - lists.cs.columbia.edu
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - yoshi.email
X-Get-Message-Sender-Via: s054.cyon.net: authenticated_id: takashi@yoshi.email
X-Authenticated-Sender: s054.cyon.net: takashi@yoshi.email
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-OutGoing-Spam-Status: No, score=-1.1
X-Mailman-Approved-At: Sat, 22 Feb 2020 14:17:35 -0500
Cc: Anders Berg <anders.berg@lsi.com>, Russell King <linux@arm.linux.org.uk>,
 Arnd Bergmann <arnd@arndb.de>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>
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

Hi

I found this mailing list thread and would like to express my opinion
and dependence on KVM/arm32.

I hope that I'm not too late already.


On Monday, 10.02.2020, 14:13 +0000 Marc Zyngier wrote:
> KVM/arm was merged just over 7 years ago, and has lived a very quiet
> life so far. It mostly works if you're prepared to deal with its
> limitations, it has been a good prototype for the arm64 version,
> but it suffers a few problems:
> 
> - It is incomplete (no debug support, no PMU)
> - It hasn't followed any of the architectural evolutions
> - It has zero users (I don't count myself here)

I might not be an important user, but I have been for multiple years
and still am a regular user of KVM/arm32 on different devices.

I use KVM on my Tegra K1 Chromebook for app development and have
multiple SBCs at home on which I run VMs on using KVM+libvirt.

Sure, neither of these devices has many resources available, but they
are working fine. I would love to keep them in service since I haven't
found arm64-based replacements that don't require hours upon hours of
tinkering to just get a basic OS installation running with a mainline
kernel.

As an example that they can still be of use in 2020 I'd like to point
out that one of the SBCs is running my DNS resolver, LDAP server,
RSS reader, IRC bouncer, and shared todo list just fine, each in their
separate VM.

> - It is more and more getting in the way of new arm64 developments
> 
> So here it is: unless someone screams and shows that they rely on
> KVM/arm to be maintained upsteam, I'll remove 32bit host support
> form the tree.

*scream*

> One of the reasons that makes me confident nobody is
> using it is that I never receive *any* bug report. Yes, it is
> perfect.

This assumption is deeply flawed. Most users (including me) are not
subscribed to this mailing list and will never find this thread at all.
I myself stumbled upon this discussion just by chance while I was
browsing the web trying to find something completely unrelated.

I've been using KVM on x86, ppc and arm for many years, yet I never
felt the need to report a bug on the mailing list.
(This is to be interpreted as a compliment to the great work the devs
of KVM have done!)

Just going by the number of bugs reported on a developers mailing list
is not going to paint an accurate picture.

I am convinced that I'm not the only one relying on KVM/arm32 in the
mainline kernel and would ask you to please reconsider keeping arm32 in
the mainline kernel for a few more years until adequate arm64
replacements are available on the market and have gained proper support
in the mainline kernel.

I myself unfortunately do neither have the knowledge nor resources to
help with development in KVM or maintaining a non-mainline kernel.

> But if you depend on KVM/arm being available in mainline, please
> shout.
> 
> To reiterate: 32bit guest support for arm64 stays, of course. Only
> 32bit host goes. Once this is merged, I plan to move virt/kvm/arm to
> arm64, and cleanup all the now unnecessary abstractions.
> 
> The patches have been generated with the -D option to avoid spamming
> everyone with huge diffs, and there is a kvm-arm/goodbye branch in
> my kernel.org repository.
> 
> [...]

Thanks for your understanding.

Kind regards

- Yoshi
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
