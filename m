Return-Path: <SRS0=/McF=PJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41612C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 21 Oct 2021 15:11:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E5A74610A2
	for <kvmarm@archiver.kernel.org>; Thu, 21 Oct 2021 15:11:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E5A74610A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 910134B17C;
	Thu, 21 Oct 2021 11:11:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 889rj541Wbo2; Thu, 21 Oct 2021 11:11:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A03D4B1BC;
	Thu, 21 Oct 2021 11:11:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8625B4B119
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Oct 2021 11:11:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XG8R-hQA9dk4 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Oct 2021 11:11:34 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D7A744B126
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Oct 2021 11:11:34 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4CF4960F57;
 Thu, 21 Oct 2021 15:11:32 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mdZj8-000jKD-Gs; Thu, 21 Oct 2021 16:11:30 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/4] KVM: arm64: Reorder vcpu flag definitions
Date: Thu, 21 Oct 2021 16:11:21 +0100
Message-Id: <20211021151124.3098113-2-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211021151124.3098113-1-maz@kernel.org>
References: <20211021151124.3098113-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, qperret@google.com,
 will@kernel.org, broonie@kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>, broonie@kernel.org
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

The vcpu arch flags are in an interesting, semi random order.
As I have made the mistake of reusing a flag once, let's rework
this in an order that I find a bit less confusing.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d0221fb69a60..f856ab63f092 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -417,14 +417,12 @@ struct kvm_vcpu_arch {
 #define KVM_ARM64_VCPU_SVE_FINALIZED	(1 << 6) /* SVE config completed */
 #define KVM_ARM64_GUEST_HAS_PTRAUTH	(1 << 7) /* PTRAUTH exposed to guest */
 #define KVM_ARM64_PENDING_EXCEPTION	(1 << 8) /* Exception pending */
+/*
+ * Overlaps with KVM_ARM64_EXCEPT_MASK on purpose so that it can't be
+ * set together with an exception...
+ */
+#define KVM_ARM64_INCREMENT_PC		(1 << 9) /* Increment PC */
 #define KVM_ARM64_EXCEPT_MASK		(7 << 9) /* Target EL/MODE */
-#define KVM_ARM64_DEBUG_STATE_SAVE_SPE	(1 << 12) /* Save SPE context if active  */
-#define KVM_ARM64_DEBUG_STATE_SAVE_TRBE	(1 << 13) /* Save TRBE context if active  */
-
-#define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
-				 KVM_GUESTDBG_USE_SW_BP | \
-				 KVM_GUESTDBG_USE_HW | \
-				 KVM_GUESTDBG_SINGLESTEP)
 /*
  * When KVM_ARM64_PENDING_EXCEPTION is set, KVM_ARM64_EXCEPT_MASK can
  * take the following values:
@@ -442,11 +440,13 @@ struct kvm_vcpu_arch {
 #define KVM_ARM64_EXCEPT_AA64_EL1	(0 << 11)
 #define KVM_ARM64_EXCEPT_AA64_EL2	(1 << 11)
 
-/*
- * Overlaps with KVM_ARM64_EXCEPT_MASK on purpose so that it can't be
- * set together with an exception...
- */
-#define KVM_ARM64_INCREMENT_PC		(1 << 9) /* Increment PC */
+#define KVM_ARM64_DEBUG_STATE_SAVE_SPE	(1 << 12) /* Save SPE context if active  */
+#define KVM_ARM64_DEBUG_STATE_SAVE_TRBE	(1 << 13) /* Save TRBE context if active  */
+
+#define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
+				 KVM_GUESTDBG_USE_SW_BP | \
+				 KVM_GUESTDBG_USE_HW | \
+				 KVM_GUESTDBG_SINGLESTEP)
 
 #define vcpu_has_sve(vcpu) (system_supports_sve() &&			\
 			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
