Return-Path: <SRS0=CHPd=HD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21BE4C433E0
	for <kvmarm@archiver.kernel.org>; Mon,  1 Feb 2021 13:46:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5F75C64E7A
	for <kvmarm@archiver.kernel.org>; Mon,  1 Feb 2021 13:46:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F75C64E7A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B8AF94B32B;
	Mon,  1 Feb 2021 08:46:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uGNhBm05gpzd; Mon,  1 Feb 2021 08:45:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C2DA4B33E;
	Mon,  1 Feb 2021 08:45:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 218274B33E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2021 08:45:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mTQ1RKZuTODc for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Feb 2021 08:45:57 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E67EA4B32B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2021 08:45:56 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9FAC864D99;
 Mon,  1 Feb 2021 13:45:55 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l6ZWb-00BHWZ-EK; Mon, 01 Feb 2021 13:45:53 +0000
MIME-Version: 1.0
Date: Mon, 01 Feb 2021 13:45:53 +0000
From: Marc Zyngier <maz@kernel.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: arm64: gen-hyprel.c:40:10: fatal error: generated/autoconf.h: No
 such file or directory
In-Reply-To: <CA+G9fYvzh5GEssPJHM=r2TVUKOhsFJ8jqrY+pP4t7+jF8ctz9A@mail.gmail.com>
References: <CA+G9fYvzh5GEssPJHM=r2TVUKOhsFJ8jqrY+pP4t7+jF8ctz9A@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <5f072f84c7c9b03ded810e56687935b2@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: naresh.kamboju@linaro.org, linux-next@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 lkft-triage@lists.linaro.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, sfr@canb.auug.org.au, arnd@arndb.de,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 catalin.marinas@arm.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
 kvm list <kvm@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org,
 Linux-Next Mailing List <linux-next@vger.kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On 2021-02-01 13:38, Naresh Kamboju wrote:
> Linux next 20210201 tag arm64 builds failed.
> kernel config attached to this email.
> 
> BAD:    next-20210201
> GOOD: next-20210129
> 
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=arm64
> CROSS_COMPILE=aarch64-linux-gnu- 'CC=sccache aarch64-linux-gnu-gcc'
> 'HOSTCC=sccache gcc'
> arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:40:10: fatal error:
> generated/autoconf.h: No such file or directory
>    40 | #include <generated/autoconf.h>
>       |          ^~~~~~~~~~~~~~~~~~~~~~
> compilation terminated.
> 
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

Could you please check with the fix suggested at [1]?

Thanks,

         M.

[1] https://lore.kernel.org/r/20210201104251.5foc64qq3ewgnhuz@google.com
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
