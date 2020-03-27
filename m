Return-Path: <SRS0=88wp=5M=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC9D6C2D0E5
	for <kvmarm@archiver.kernel.org>; Fri, 27 Mar 2020 18:09:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3ED862071B
	for <kvmarm@archiver.kernel.org>; Fri, 27 Mar 2020 18:09:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="wQOLuOxy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3ED862071B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB16C4B087;
	Fri, 27 Mar 2020 14:09:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6Li9egLufgjl; Fri, 27 Mar 2020 14:09:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3FE94B089;
	Fri, 27 Mar 2020 14:09:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DEEA4B089
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Mar 2020 14:09:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fvcchhU+npUW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Mar 2020 14:09:21 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 29F954B087
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Mar 2020 14:09:21 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 035BD2071B;
 Fri, 27 Mar 2020 18:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1585332560;
 bh=zhwEDwgqijCCf3Yv/ZISrfo5qqO4vWvdB2ey3n6lsEk=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=wQOLuOxy5Ad8+KKPsUNDjk0Gb6uM/3sfbIfZrQKmvj3s2f90PnU1B81WnGKSNn45f
 AL4udLBPyCJWoDLrZGzdKVOK0TPQ0wGbBOGtZu3r2VRdMwVekHRFY4YJF5YVnB10gN
 oaZDTLzOvvN+uR4uRET0a/blE6hsiw0ROVR6dF8o=
Date: Fri, 27 Mar 2020 18:09:14 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [RFC PATCH] arm64: unify WORKAROUND_SPECULATIVE_AT_{NVHE,VHE}
Message-ID: <20200327180913.GA10454@willie-the-truck>
References: <20200327143941.195626-1-ascull@google.com>
 <1705907b-234c-6f56-1360-f598c8047d1d@arm.com>
 <20200327174838.GD178422@google.com>
 <e280f3f31bd5edc9db55757fcfa4ec62@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <e280f3f31bd5edc9db55757fcfa4ec62@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: qwandor@google.com, tabba@google.com, Steven Price <steven.price@arm.com>,
 wedsonaf@google.com, dbrazdil@google.com, kernel-team@android.com,
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

On Fri, Mar 27, 2020 at 05:52:59PM +0000, Marc Zyngier wrote:
> On 2020-03-27 17:48, Andrew Scull wrote:
> > Thanks, Steven. Could we look into the EPD* caching microarch details
> > Marc was referring to for these A55 and A76 cores?
> 
> Only the folks that have access to the RTL can tell you, unfortunately.
> 
> Thankfully, there is a bunch of people on Cc that should be able to ping
> the relevant teams and report back...

Yup, otherwise I guess we can throw in the TLB invalidation after setting
the EPDx bits until we have clarity from Arm. We wouldn't need to broadcast
it, so it might not be too bad on performance. If it is, I suppose we could
switch to a reserved VMID?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
