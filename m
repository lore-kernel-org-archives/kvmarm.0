Return-Path: <SRS0=ZPOc=UJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1695C31E44
	for <kvmarm@archiver.kernel.org>; Mon, 10 Jun 2019 16:24:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 77F7A20859
	for <kvmarm@archiver.kernel.org>; Mon, 10 Jun 2019 16:24:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 77F7A20859
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30D7B4A528;
	Mon, 10 Jun 2019 12:24:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AnZubK-FoPAL; Mon, 10 Jun 2019 12:24:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C749A4A52D;
	Mon, 10 Jun 2019 12:24:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97B574A522
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jun 2019 12:24:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TQSFOqM7dz6T for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Jun 2019 12:24:43 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1B6A4A51F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jun 2019 12:24:43 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5BBD8C15;
 Mon, 10 Jun 2019 09:24:43 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.105])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3DF763F246;
 Mon, 10 Jun 2019 09:24:42 -0700 (PDT)
From: James Morse <james.morse@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 3/6] KVM: arm64: Make indirect vectors preamble behaviour
 symmetric
Date: Mon, 10 Jun 2019 17:24:24 +0100
Message-Id: <20190610162427.115910-4-james.morse@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190610162427.115910-1-james.morse@arm.com>
References: <20190610162427.115910-1-james.morse@arm.com>
MIME-Version: 1.0
Cc: Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
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

The KVM indirect vectors support is a little complicated. Different CPUs
may use different exception vectors for KVM that are generated at boot.
Adding new instructions involves checking all the possible combinations
do the right thing.

To make changes here easier to review lets state what we expect of the
preamble:
  1. The first vector run, must always run the preamble.
  2. Patching the head or tail of the vector shouldn't remove
     preamble instructions.

Today, this is easy as we only have one instruction in the preamble.
Change the unpatched tail of the indirect vector so that it always
runs this, regardless of patching.

Signed-off-by: James Morse <james.morse@arm.com>
---
New for v2.

 arch/arm64/kvm/hyp/hyp-entry.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index c7f9d5e271a9..5f0412f124a3 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -286,7 +286,7 @@ ENDPROC(__kvm_hyp_vector)
 /*
  * The default sequence is to directly branch to the KVM vectors,
  * using the computed offset. This applies for VHE as well as
- * !ARM64_HARDEN_EL2_VECTORS.
+ * !ARM64_HARDEN_EL2_VECTORS. The first vector must always run the preamble.
  *
  * For ARM64_HARDEN_EL2_VECTORS configurations, this gets replaced
  * with:
@@ -302,8 +302,8 @@ ENDPROC(__kvm_hyp_vector)
  * See kvm_patch_vector_branch for details.
  */
 alternative_cb	kvm_patch_vector_branch
-	b	__kvm_hyp_vector + (1b - 0b)
-	nop
+	stp	x0, x1, [sp, #-16]!
+	b	__kvm_hyp_vector + (1b - 0b + KVM_VECTOR_PREAMBLE)
 	nop
 	nop
 	nop
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
