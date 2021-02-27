Return-Path: <SRS0=piq7=H5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3B68C433E6
	for <kvmarm@archiver.kernel.org>; Sat, 27 Feb 2021 10:41:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 97DCF64EC0
	for <kvmarm@archiver.kernel.org>; Sat, 27 Feb 2021 10:41:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 97DCF64EC0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3660B4B43A;
	Sat, 27 Feb 2021 05:41:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NoXvhQrHtkOk; Sat, 27 Feb 2021 05:41:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 140F34B432;
	Sat, 27 Feb 2021 05:41:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F94E4B3E9
 for <kvmarm@lists.cs.columbia.edu>; Sat, 27 Feb 2021 05:41:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xzCdXfORCrvD for <kvmarm@lists.cs.columbia.edu>;
 Sat, 27 Feb 2021 05:41:51 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 621394B427
 for <kvmarm@lists.cs.columbia.edu>; Sat, 27 Feb 2021 05:41:51 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B0F1111D4;
 Sat, 27 Feb 2021 02:41:50 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1AF5E3F73B;
 Sat, 27 Feb 2021 02:41:49 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: drjones@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH 3/6] arm/arm64: Remove unnecessary ISB when
 doing dcache maintenance
Date: Sat, 27 Feb 2021 10:41:58 +0000
Message-Id: <20210227104201.14403-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210227104201.14403-1-alexandru.elisei@arm.com>
References: <20210227104201.14403-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

The dcache_by_line_op macro executes a DSB to complete the cache
maintenance operations. According to ARM DDI 0487G.a, page B2-150:

"In addition, no instruction that appears in program order after the DSB
instruction can alter any state of the system or perform any part of its
functionality until the DSB completes other than:

- Being fetched from memory and decoded.
- Reading the general-purpose, SIMD and floating-point, Special-purpose, or
  System registers that are directly or indirectly read without causing
  side-effects."

Similar definition for ARM in ARM DDI 0406C.d, page A3-150:

"In addition, no instruction that appears in program order after the DSB
instruction can execute until the DSB completes."

This means that we don't need the ISB to prevent reordering of the cache
maintenance instructions.

We are also not doing icache maintenance, where an ISB would be required
for the PE to discard instructions speculated before the invalidation.

In conclusion, the ISB is unnecessary, so remove it.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/cstart.S   | 1 -
 arm/cstart64.S | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arm/cstart.S b/arm/cstart.S
index 954748b00f64..2d62c1e6d40d 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -212,7 +212,6 @@ asm_mmu_disable:
 	ldr	r1, [r1]
 	sub	r1, r1, r0
 	dcache_by_line_op dccimvac, sy, r0, r1, r2, r3
-	isb
 
 	mov     pc, lr
 
diff --git a/arm/cstart64.S b/arm/cstart64.S
index 046bd3914098..c1deff842f03 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -219,7 +219,6 @@ asm_mmu_disable:
 	ldr	x1, [x1, :lo12:__phys_end]
 	sub	x1, x1, x0
 	dcache_by_line_op civac, sy, x0, x1, x2, x3
-	isb
 
 	ret
 
-- 
2.30.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
