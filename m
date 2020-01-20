Return-Path: <SRS0=lFwt=3J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7820BC33CA1
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jan 2020 13:38:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0B85522314
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jan 2020 13:38:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B85522314
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 86C634AF38;
	Mon, 20 Jan 2020 08:38:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rmfMriwJOdQL; Mon, 20 Jan 2020 08:38:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5936F4AEF5;
	Mon, 20 Jan 2020 08:38:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFB684AECD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jan 2020 08:38:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3bC+SR8Ptz5y for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jan 2020 08:38:32 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3703C4AEBD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jan 2020 08:38:32 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AADBF30E;
 Mon, 20 Jan 2020 05:38:31 -0800 (PST)
Received: from login2.euhpc.arm.com. (login2.euhpc.arm.com [10.6.27.34])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2174D3F52E;
 Mon, 20 Jan 2020 05:38:31 -0800 (PST)
From: Vladimir Murzin <vladimir.murzin@arm.com>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2] ARM: virt: Relax arch timer version check during early boot
Date: Mon, 20 Jan 2020 13:38:18 +0000
Message-Id: <1579527498-31081-1-git-send-email-vladimir.murzin@arm.com>
X-Mailer: git-send-email 2.0.0
Cc: maz@kernel.org, kvmarm@lists.cs.columbia.edu
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Updates to the Generic Timer architecture allow ID_PFR1.GenTimer to
have values other than 0 or 1 while still preserving backward
compatibility. At the moment, Linux is quite strict in the way it
handles this field at early boot and will not configure arch timer if
it doesn't find the value 1.

Since here use ubfx for arch timer version extraction (hyb-stub build
with -march=armv7-a, so it is safe)

To help backports (even though the code was correct at the time of writing)
Fixes: 8ec58be9f3ff ("ARM: virt: arch_timers: enable access to physical timers")
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---

Changelog:

    v1 -> v2
       - Clarify that backward compatibility is preserved (per Marc)

 arch/arm/kernel/hyp-stub.S | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/hyp-stub.S b/arch/arm/kernel/hyp-stub.S
index ae50203..6607fa8 100644
--- a/arch/arm/kernel/hyp-stub.S
+++ b/arch/arm/kernel/hyp-stub.S
@@ -146,10 +146,9 @@ ARM_BE8(orr	r7, r7, #(1 << 25))     @ HSCTLR.EE
 #if !defined(ZIMAGE) && defined(CONFIG_ARM_ARCH_TIMER)
 	@ make CNTP_* and CNTPCT accessible from PL1
 	mrc	p15, 0, r7, c0, c1, 1	@ ID_PFR1
-	lsr	r7, #16
-	and	r7, #0xf
-	cmp	r7, #1
-	bne	1f
+	ubfx	r7, r7, #16, #4
+	teq	r7, #0
+	beq	1f
 	mrc	p15, 4, r7, c14, c1, 0	@ CNTHCTL
 	orr	r7, r7, #3		@ PL1PCEN | PL1PCTEN
 	mcr	p15, 4, r7, c14, c1, 0	@ CNTHCTL
-- 
2.7.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
