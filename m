Return-Path: <SRS0=Ct8k=AO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23C82C433E0
	for <kvmarm@archiver.kernel.org>; Fri,  3 Jul 2020 12:08:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9F3C52088E
	for <kvmarm@archiver.kernel.org>; Fri,  3 Jul 2020 12:07:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZWokXalU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F3C52088E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 484F54B185;
	Fri,  3 Jul 2020 08:07:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PRGbh0fpUlxT; Fri,  3 Jul 2020 08:07:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38EDE4B165;
	Fri,  3 Jul 2020 08:07:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C916D4B163
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2020 08:07:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LyjSOY-H2O+X for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jul 2020 08:07:55 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7027B4B161
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2020 08:07:55 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 99EB2207D4;
 Fri,  3 Jul 2020 12:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1593778074;
 bh=nUh9op6CAi0IxgUhuOMPaGPv8W0mnewfQsFgLajKM8Q=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=ZWokXalUsEEfKxEaYWHe/VpbopWzUYcyJ4zepSldCNmsSsiiH8ltKSHNVgRIWa0uY
 C2nz+c2xriblDEx6x+1Ufpv95aHv5UqXZmkXBi/xabSVE02/ZVo+WViIgK8tSQCQip
 1ifUGemUJwM7wQgRe0A0U6TojMLaLbJ01JloK4Rk=
From: Will Deacon <will@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvm@vger.kernel.org
Subject: Re: [PATCH] kvmtool: arm64: Report missing support for 32bit guests
Date: Fri,  3 Jul 2020 13:07:48 +0100
Message-Id: <159377741751.260263.15198073437610178444.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200701142002.51654-1-suzuki.poulose@arm.com>
References: <20200701142002.51654-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Cc: Will Deacon <will@kernel.org>, catalin.marinas@arm.com,
 andre.przywara@arm.com, Sami Mujawar <sami.mujawar@arm.com>,
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

On Wed, 1 Jul 2020 15:20:02 +0100, Suzuki K Poulose wrote:
> When the host doesn't support 32bit guests, the kvmtool fails
> without a proper message on what is wrong. i.e,
> 
>  $ lkvm run -c 1 Image --aarch32
>   # lkvm run -k Image -m 256 -c 1 --name guest-105618
>   Fatal: Unable to initialise vcpu
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] kvmtool: arm64: Report missing support for 32bit guests
      https://git.kernel.org/will/kvmtool/c/351d931f496a

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
