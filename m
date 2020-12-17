Return-Path: <SRS0=/4+A=FV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87376C2BB48
	for <kvmarm@archiver.kernel.org>; Thu, 17 Dec 2020 14:13:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E1BF423975
	for <kvmarm@archiver.kernel.org>; Thu, 17 Dec 2020 14:13:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E1BF423975
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 500784B20B;
	Thu, 17 Dec 2020 09:13:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UL2L1Z11-IDp; Thu, 17 Dec 2020 09:13:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4ACF84B1E8;
	Thu, 17 Dec 2020 09:13:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 436BB4B1E8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Dec 2020 09:13:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MYxLou8QRejj for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Dec 2020 09:13:28 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E060D4B1CD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Dec 2020 09:13:27 -0500 (EST)
From: Catalin Marinas <catalin.marinas@arm.com>
Authentication-Results: mail.kernel.org;
 dkim=permerror (bad message/signature format)
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm64: Work around broken GCC 4.9 handling of "S"
 constraint
Date: Thu, 17 Dec 2020 14:13:23 +0000
Message-Id: <160821437878.18463.2650889396125044729.b4-ty@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201217111135.1536658-1-maz@kernel.org>
References: <20201217111135.1536658-1-maz@kernel.org>
MIME-Version: 1.0
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>
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

On Thu, 17 Dec 2020 11:11:35 +0000, Marc Zyngier wrote:
> GCC 4.9 seems to have a problem with the "S" asm constraint
> when the symbol lives in the same compilation unit, and pretends
> the constraint is impossible:
> 
> $ cat x.c
> void *foo(void)
> {
> 	static int x;
> 	int *addr;
> 	asm("adrp %0, %1" : "=r" (addr) : "S" (&x));
> 	return addr;
> }
> 
> [...]

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64: Work around broken GCC 4.9 handling of "S" constraint
      https://git.kernel.org/arm64/c/9fd339a45be5

-- 
Catalin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
