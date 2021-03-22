Return-Path: <SRS0=gWTa=IU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FAE7C433E2
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 15:06:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9B2376198E
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 15:06:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B2376198E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E2074B3B5;
	Mon, 22 Mar 2021 11:06:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O0HQd9ajKsTd; Mon, 22 Mar 2021 11:06:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A9684B414;
	Mon, 22 Mar 2021 11:06:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB63F4B232
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 11:06:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NMXF08tUkdWi for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Mar 2021 11:06:23 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1DD24B237
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 11:06:22 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 87DDB1396;
 Mon, 22 Mar 2021 08:06:22 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C952E3F719;
 Mon, 22 Mar 2021 08:06:21 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: drjones@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH v2 3/6] arm/arm64: Remove unnecessary ISB when
 doing dcache maintenance
Date: Mon, 22 Mar 2021 15:06:38 +0000
Message-Id: <20210322150641.58878-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322150641.58878-1-alexandru.elisei@arm.com>
References: <20210322150641.58878-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: andre.przywara@arm.com
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
2.31.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
