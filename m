From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 3/3] arm64: KVM: Fix outdated comment about VTCR_EL2.PS
Date: Tue, 10 Mar 2015 19:07:01 +0000
Message-ID: <1426014421-5579-4-git-send-email-marc.zyngier@arm.com>
References: <1426014421-5579-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EECE748502
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Mar 2015 15:00:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JgPhobJS9-5j for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Mar 2015 15:00:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A2D9484FC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Mar 2015 15:00:53 -0400 (EDT)
In-Reply-To: <1426014421-5579-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Commit 87366d8cf7b3 ("arm64: Add boot time configuration of
Intermediate Physical Address size") removed the hardcoded setting
of VTCR_EL2.PS to use ID_AA64MMFR0_EL1.PARange instead, but didn't
remove the (now rather misleading) comment.

Fix the comments to match reality (at least for the next few minutes).

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 94674eb..54bb4ba 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -129,6 +129,9 @@
  * 40 bits wide (T0SZ = 24).  Systems with a PARange smaller than 40 bits are
  * not known to exist and will break with this configuration.
  *
+ * VTCR_EL2.PS is extracted from ID_AA64MMFR0_EL1.PARange at boot time
+ * (see hyp-init.S).
+ *
  * Note that when using 4K pages, we concatenate two first level page tables
  * together.
  *
@@ -138,7 +141,6 @@
 #ifdef CONFIG_ARM64_64K_PAGES
 /*
  * Stage2 translation configuration:
- * 40bits output (PS = 2)
  * 40bits input  (T0SZ = 24)
  * 64kB pages (TG0 = 1)
  * 2 level page tables (SL = 1)
@@ -150,7 +152,6 @@
 #else
 /*
  * Stage2 translation configuration:
- * 40bits output (PS = 2)
  * 40bits input  (T0SZ = 24)
  * 4kB pages (TG0 = 0)
  * 3 level page tables (SL = 1)
-- 
2.1.4
