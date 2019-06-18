Return-Path: <SRS0=HYBR=UR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C466CC31E5B
	for <kvmarm@archiver.kernel.org>; Tue, 18 Jun 2019 15:18:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 82206213F2
	for <kvmarm@archiver.kernel.org>; Tue, 18 Jun 2019 15:18:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 82206213F2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A79C4A528;
	Tue, 18 Jun 2019 11:18:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NFCxYcAnag5B; Tue, 18 Jun 2019 11:18:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 021944A52A;
	Tue, 18 Jun 2019 11:18:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F77A4A47E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jun 2019 11:18:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RpHmt1pNd6Fa for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jun 2019 11:18:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC9784A50D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jun 2019 11:18:24 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 897912B;
 Tue, 18 Jun 2019 08:18:24 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.105])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A0C1E3F718;
 Tue, 18 Jun 2019 08:18:23 -0700 (PDT)
From: James Morse <james.morse@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 2/2] KVM: arm64: Skip more of the SError vaxorcism
Date: Tue, 18 Jun 2019 16:18:09 +0100
Message-Id: <20190618151809.259038-3-james.morse@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618151809.259038-1-james.morse@arm.com>
References: <20190618151809.259038-1-james.morse@arm.com>
MIME-Version: 1.0
Cc: Marc Zyngier <marc.zyngier@arm.com>
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

During __guest_exit() we need to consume any SError left pending by the
guest so it doesn't contaminate the host. With v8.2 we use the
ESB-instruction. For systems without v8.2, we use dsb+isb and unmask
SError. We do this on every guest exit.

Use the same dsb+isr_el1 trick, this lets us know if an SError is pending
after the dsb, allowing us to skip the isb and self-synchronising PSTATE
write if its not.

This means SError remains masked during KVM's world-switch, so any SError
that occurs during this time is reported by the host, instead of causing
a hyp-panic.

As we're benchmarking this code lets polish the layout. If you give gcc
likely()/unlikely() hints in an if() condition, it shuffles the generated
assembly so that the likely case is immediately after the branch. Lets
do the same here.

Signed-off-by: James Morse <james.morse@arm.com>

Changes since v2:
 * Added isb after the dsb to prevent an early read
---
 arch/arm64/kvm/hyp/entry.S | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 017ec4189a08..269e7b2da1fd 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -162,8 +162,16 @@ alternative_if ARM64_HAS_RAS_EXTN
 	orr	x0, x0, #(1<<ARM_EXIT_WITH_SERROR_BIT)
 1:	ret
 alternative_else
-	// If we have a pending asynchronous abort, now is the
-	// time to find out. From your VAXorcist book, page 666:
+	dsb	sy		// Synchronize against in-flight ld/st
+	isb			// Prevent an early read of side-effect free ISR
+	mrs	x2, isr_el1
+	tbnz	x2, #8, 2f	// ISR_EL1.A
+	ret
+	nop
+2:
+alternative_endif
+	// We know we have a pending asynchronous abort, now is the
+	// time to flush it out. From your VAXorcist book, page 666:
 	// "Threaten me not, oh Evil one!  For I speak with
 	// the power of DEC, and I command thee to show thyself!"
 	mrs	x2, elr_el2
@@ -171,9 +179,7 @@ alternative_else
 	mrs	x4, spsr_el2
 	mov	x5, x0
 
-	dsb	sy		// Synchronize against in-flight ld/st
 	msr	daifclr, #4	// Unmask aborts
-alternative_endif
 
 	// This is our single instruction exception window. A pending
 	// SError is guaranteed to occur at the earliest when we unmask
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
