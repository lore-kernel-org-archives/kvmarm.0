Return-Path: <SRS0=SKU0=4G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74908C3404B
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 19:59:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3721924672
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 19:59:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3721924672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E6E764AF54;
	Tue, 18 Feb 2020 14:59:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Gv+csRgij0T3; Tue, 18 Feb 2020 14:59:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB0B64AF63;
	Tue, 18 Feb 2020 14:59:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 817144AF48
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 14:59:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id soN4rvbSFJvl for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Feb 2020 14:59:16 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70FE74AF92
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 14:59:16 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3B29BFEC;
 Tue, 18 Feb 2020 11:59:16 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B0ECB3F68F;
 Tue, 18 Feb 2020 11:59:15 -0800 (PST)
From: Mark Brown <broonie@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 10/18] arm64: head: Annotate stext and preserve_boot_args as
 code
Date: Tue, 18 Feb 2020 19:58:34 +0000
Message-Id: <20200218195842.34156-11-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200218195842.34156-1-broonie@kernel.org>
References: <20200218195842.34156-1-broonie@kernel.org>
MIME-Version: 1.0
Cc: Mark Brown <broonie@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
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

In an effort to clarify and simplify the annotation of assembly
functions new macros have been introduced. These replace ENTRY and
ENDPROC with two different annotations for normal functions and those
with unusual calling conventions.  Neither stext nor preserve_boot_args
is called with the usual AAPCS calling conventions and they should
therefore be annotated as code.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/head.S | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 716c946c98e9..c334863991e7 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -105,7 +105,7 @@ pe_header:
 	 *  x24        __primary_switch() .. relocate_kernel()
 	 *                                        current RELR displacement
 	 */
-ENTRY(stext)
+SYM_CODE_START(stext)
 	bl	preserve_boot_args
 	bl	el2_setup			// Drop to EL1, w0=cpu_boot_mode
 	adrp	x23, __PHYS_OFFSET
@@ -120,12 +120,12 @@ ENTRY(stext)
 	 */
 	bl	__cpu_setup			// initialise processor
 	b	__primary_switch
-ENDPROC(stext)
+SYM_CODE_END(stext)
 
 /*
  * Preserve the arguments passed by the bootloader in x0 .. x3
  */
-preserve_boot_args:
+SYM_CODE_START_LOCAL(preserve_boot_args)
 	mov	x21, x0				// x21=FDT
 
 	adr_l	x0, boot_args			// record the contents of
@@ -137,7 +137,7 @@ preserve_boot_args:
 
 	mov	x1, #0x20			// 4 x 8 bytes
 	b	__inval_dcache_area		// tail call
-ENDPROC(preserve_boot_args)
+SYM_CODE_END(preserve_boot_args)
 
 /*
  * Macro to create a table entry to the next page.
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
