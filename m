Return-Path: <SRS0=88wp=5M=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05332C43331
	for <kvmarm@archiver.kernel.org>; Fri, 27 Mar 2020 17:53:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8674D2072F
	for <kvmarm@archiver.kernel.org>; Fri, 27 Mar 2020 17:53:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="KSeYpGA6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8674D2072F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C70C4B089;
	Fri, 27 Mar 2020 13:53:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Vmk1olYGAp2N; Fri, 27 Mar 2020 13:53:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CE3E4B088;
	Fri, 27 Mar 2020 13:53:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA2CA4B088
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Mar 2020 13:53:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K+9o56Nbe1QN for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Mar 2020 13:53:02 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A4B0F4AEDC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Mar 2020 13:53:02 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 862042072F;
 Fri, 27 Mar 2020 17:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1585331581;
 bh=hDjqaL0X3nrh5jBH9jkSsUvxSlT36Iz84f9JS0CCci8=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=KSeYpGA6t09aDn999+h+fGxkfZNcXlyiWjd92rsrYpDJ0bUPPPxfRMPEw9OICYnSX
 aWut34lUw0bCh2vfkxnkS7tp3j4cqPp5v5hwzZhQ5onGBEVKdLl52tisz41IIBY4HO
 Q188C4cuHe/ORNvSnxb0iv829EKq3/4zVTjAajsY=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jHtAB-00GGLg-Mf; Fri, 27 Mar 2020 17:52:59 +0000
MIME-Version: 1.0
Date: Fri, 27 Mar 2020 17:52:59 +0000
From: Marc Zyngier <maz@kernel.org>
To: Andrew Scull <ascull@google.com>
Subject: Re: [RFC PATCH] arm64: unify WORKAROUND_SPECULATIVE_AT_{NVHE,VHE}
In-Reply-To: <20200327174838.GD178422@google.com>
References: <20200327143941.195626-1-ascull@google.com>
 <1705907b-234c-6f56-1360-f598c8047d1d@arm.com>
 <20200327174838.GD178422@google.com>
Message-ID: <e280f3f31bd5edc9db55757fcfa4ec62@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: ascull@google.com, steven.price@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 qperret@google.com, dbrazdil@google.com, qwandor@google.com, tabba@google.com,
 wedsonaf@google.com, kernel-team@android.com, James.Morse@arm.com,
 Suzuki.Poulose@arm.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: qwandor@google.com, Will Deacon <will@kernel.org>,
 Steven Price <steven.price@arm.com>, wedsonaf@google.com, tabba@google.com,
 dbrazdil@google.com, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Andrew,

On 2020-03-27 17:48, Andrew Scull wrote:
> Thanks, Steven. Could we look into the EPD* caching microarch details
> Marc was referring to for these A55 and A76 cores?

Only the folks that have access to the RTL can tell you, unfortunately.

Thankfully, there is a bunch of people on Cc that should be able to ping
the relevant teams and report back...

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
