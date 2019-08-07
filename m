Return-Path: <SRS0=czFP=WD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F6BAC32751
	for <kvmarm@archiver.kernel.org>; Wed,  7 Aug 2019 15:11:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BF5E0218FE
	for <kvmarm@archiver.kernel.org>; Wed,  7 Aug 2019 15:11:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF5E0218FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38AAF4A51C;
	Wed,  7 Aug 2019 11:11:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RwLNe5uprnkt; Wed,  7 Aug 2019 11:11:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 033864A520;
	Wed,  7 Aug 2019 11:11:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59E9F4A520
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Aug 2019 11:11:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8WujsXLiGBUr for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Aug 2019 11:11:30 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BDEE4A51C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Aug 2019 11:11:30 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF218344;
 Wed,  7 Aug 2019 08:11:29 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id
 BFA9E3F706; Wed,  7 Aug 2019 08:11:28 -0700 (PDT)
Subject: Re: [PATCH] arm64: KVM: hyp: debug-sr: Mark expected switch
 fall-throughs
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <20190807141857.GA4198@embeddedor>
From: Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <b0b04024-9568-7b51-1bef-7030dd66f727@kernel.org>
Date: Wed, 7 Aug 2019 16:11:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190807141857.GA4198@embeddedor>
Content-Language: en-US
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
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

On 07/08/2019 15:18, Gustavo A. R. Silva wrote:
> Mark switch cases where we are expecting to fall through.
> 
> This patch fixes the following warnings (Building: allmodconfig arm64):
> 
> arch/arm64/kvm/hyp/debug-sr.c:20:19: warning: this statement may fall through [-Wimplicit-fallthrough=]
> arch/arm64/kvm/hyp/debug-sr.c:21:19: warning: this statement may fall through [-Wimplicit-fallthrough=]
> arch/arm64/kvm/hyp/debug-sr.c:22:19: warning: this statement may fall through [-Wimplicit-fallthrough=]
> arch/arm64/kvm/hyp/debug-sr.c:23:19: warning: this statement may fall through [-Wimplicit-fallthrough=]
> arch/arm64/kvm/hyp/debug-sr.c:24:19: warning: this statement may fall through [-Wimplicit-fallthrough=]
> arch/arm64/kvm/hyp/debug-sr.c:25:19: warning: this statement may fall through [-Wimplicit-fallthrough=]
> arch/arm64/kvm/hyp/debug-sr.c:26:18: warning: this statement may fall through [-Wimplicit-fallthrough=]
> arch/arm64/kvm/hyp/debug-sr.c:27:18: warning: this statement may fall through [-Wimplicit-fallthrough=]
> arch/arm64/kvm/hyp/debug-sr.c:28:18: warning: this statement may fall through [-Wimplicit-fallthrough=]
> arch/arm64/kvm/hyp/debug-sr.c:29:18: warning: this statement may fall through [-Wimplicit-fallthrough=]
> arch/arm64/kvm/hyp/debug-sr.c:30:18: warning: this statement may fall through [-Wimplicit-fallthrough=]
> arch/arm64/kvm/hyp/debug-sr.c:31:18: warning: this statement may fall through [-Wimplicit-fallthrough=]
> arch/arm64/kvm/hyp/debug-sr.c:32:18: warning: this statement may fall through [-Wimplicit-fallthrough=]
> arch/arm64/kvm/hyp/debug-sr.c:33:18: warning: this statement may fall through [-Wimplicit-fallthrough=]
> arch/arm64/kvm/hyp/debug-sr.c:34:18: warning: this statement may fall through [-Wimplicit-fallthrough=]
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Already fixed (together with all the other KVM/arm warnings/bugs), and
pull request sent to Paolo.

Thanks,

	M.
-- 
Jazz is not dead, it just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
