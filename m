Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 855D8C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  1 Dec 2021 12:04:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 07CC84B1F8;
	Wed,  1 Dec 2021 07:04:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XxGOes-o2M9C; Wed,  1 Dec 2021 07:04:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E468A4B1E6;
	Wed,  1 Dec 2021 07:04:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 406084B1EF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 07:04:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kCXd1H7EJdMZ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Dec 2021 07:04:45 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B84814B1DD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 07:04:45 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 5C8BCB81DC7;
 Wed,  1 Dec 2021 12:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16EB9C53FCD;
 Wed,  1 Dec 2021 12:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1638360283;
 bh=Z8F4hu+2UX8yZ3oAmURSAWeQYhXWQ7dstt/xYNG5yCs=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=WK5UFODjBFou61gFuWRa8OrDvuAgUZRSgSOIWyydOZWPe0qKanM4gsaBNA9PKHMc2
 3lBcySaBPMRUGxwHk5LExBfAz23nNGgkPSZjBbOvLPkwgda3L+cOh0T8O7OIclGUqC
 n6E+mr8+lC2Q+aSxjXO6D/voqqoMGFXIlcFKB0EBMN3BZQ09JbyI/QQeghsTSaWlhK
 f4ROUJc8fWbRjJ9rlUKbgr214CMyExFGCPFp16IuzXc4Xg/ajIf+gdskbqNjkh4XiZ
 MLcjz6niF0oVV2dzQ31jcuhzOGIPJt/reQMlTkpw1fZ5TTzTsF72YLkBzLLQpyknux
 F0nlNHHKjdcdA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1msOLp-0097Ab-6Z; Wed, 01 Dec 2021 12:04:41 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 1/6] KVM: arm64: Reorder vcpu flag definitions
Date: Wed,  1 Dec 2021 12:04:31 +0000
Message-Id: <20211201120436.389756-2-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211201120436.389756-1-maz@kernel.org>
References: <20211201120436.389756-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, qperret@google.com,
 will@kernel.org, broonie@kernel.org, yuzenghui@huawei.com,
 kernel-team@android.com
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
index 2a5f7f38006f..3bfd30137ce2 100644
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
