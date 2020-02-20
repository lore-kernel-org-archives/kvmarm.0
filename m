Return-Path: <SRS0=1iKH=4I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9038C11D05
	for <kvmarm@archiver.kernel.org>; Thu, 20 Feb 2020 13:15:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4745A208C4
	for <kvmarm@archiver.kernel.org>; Thu, 20 Feb 2020 13:15:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="t0so2L4y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4745A208C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF6214AEFC;
	Thu, 20 Feb 2020 08:15:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GXDXt3rwaGZv; Thu, 20 Feb 2020 08:15:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D76F04AEB1;
	Thu, 20 Feb 2020 08:15:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD5294AC7C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Feb 2020 08:15:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0ROZp8v7sKlQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Feb 2020 08:15:12 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 943FE4AC70
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Feb 2020 08:15:12 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 47520206ED;
 Thu, 20 Feb 2020 13:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1582204511;
 bh=GBYBc5/faaisNgLYson35enBOGC+Q1UvdM6+pUdc8O8=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=t0so2L4yh+HxAPZONaJIbQajjtbOQuEvn6N7oU46SIcmoB3Yude7mAJ0xs+GZObbg
 Z6zqzFJmZKGh9vGXlOoaZC/zGFwTNSlhgY34KSV3LOMDmq23fLVJjOFKifKkl4M+vl
 4HHbUC8SB6aGlO/FF8gWeNll27iSp5LXqhUFZ6tM=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j4lfZ-006jVo-Ix; Thu, 20 Feb 2020 13:15:09 +0000
MIME-Version: 1.0
Date: Thu, 20 Feb 2020 13:15:09 +0000
From: Marc Zyngier <maz@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC PATCH 0/5] Removing support for 32bit KVM/arm host
In-Reply-To: <621a0a92-6432-6c3e-cb69-0b601764fa69@samsung.com>
References: <CGME20200210141344eucas1p25a6da0b0251931ef3659397a6f34c0c3@eucas1p2.samsung.com>
 <20200210141324.21090-1-maz@kernel.org>
 <621a0a92-6432-6c3e-cb69-0b601764fa69@samsung.com>
Message-ID: <43446bd5e884ae92f243799cbe748871@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: m.szyprowski@samsung.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, vladimir.murzin@arm.com, linux@arm.linux.org.uk,
 arnd@arndb.de, suzuki.poulose@arm.com, qperret@google.com,
 Christoffer.Dall@arm.com, james.morse@arm.com, pbonzini@redhat.com,
 will@kernel.org, julien.thierry.kdev@gmail.com, krzk@kernel.org,
 b.zolnierkie@samsung.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org,
 Arnd Bergmann <arnd@arndb.de>, Krzysztof Kozlowski <krzk@kernel.org>,
 Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marek,

On 2020-02-20 12:44, Marek Szyprowski wrote:
> Hi Marc,
> 
> On 10.02.2020 15:13, Marc Zyngier wrote:
>> KVM/arm was merged just over 7 years ago, and has lived a very quiet
>> life so far. It mostly works if you're prepared to deal with its
>> limitations, it has been a good prototype for the arm64 version,
>> but it suffers a few problems:
>> 
>> - It is incomplete (no debug support, no PMU)
>> - It hasn't followed any of the architectural evolutions
>> - It has zero users (I don't count myself here)
>> - It is more and more getting in the way of new arm64 developments
> 
> That is a bit sad information. Mainline Exynos finally got everything
> that was needed to run it on the quite popular Samsung Exynos5422-based
> Odroid XU4/HC1/MC1 boards. According to the Odroid related forums it is
> being used. We also use it internally at Samsung.

Something like "too little, too late" springs to mind, but let's be
constructive. Is anyone using it in a production environment, where
they rely on the latest mainline kernel having KVM support?

The current proposal is to still have KVM support in 5.6, as well as
ongoing support for stable kernels. If that's not enough, can you please
explain your precise use case?

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
