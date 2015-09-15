From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
Subject: [PATCH 11/15] arm64: Cleanup VTCR_EL2 computation
Date: Tue, 15 Sep 2015 16:41:20 +0100
Message-ID: <1442331684-28818-12-git-send-email-suzuki.poulose@arm.com>
References: <1442331684-28818-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CABE641CC1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2015 11:40:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ohOe2ZDVb0Tq for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2015 11:40:49 -0400 (EDT)
Received: from eu-smtp-delivery-143.mimecast.com
 (eu-smtp-delivery-143.mimecast.com [146.101.78.143])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 21B3641338
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2015 11:40:47 -0400 (EDT)
In-Reply-To: <1442331684-28818-1-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, ard.biesheuvel@linaro.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin.Marinas@arm.com, Will.Deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>

No functional changes. Group the common bits for VCTR_EL2
initialisation for better readability. The granule size
and the entry level are controlled by the page size.

Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index bdf139e..699554d 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -138,6 +138,9 @@
  * The magic numbers used for VTTBR_X in this patch can be found in Tables
  * D4-23 and D4-25 in ARM DDI 0487A.b.
  */
+#define VTCR_EL2_COMMON_BITS	(VTCR_EL2_SH0_INNER | VTCR_EL2_ORGN0_WBWA | \
+				 VTCR_EL2_IRGN0_WBWA | VTCR_EL2_T0SZ_40B)
+
 #ifdef CONFIG_ARM64_64K_PAGES
 /*
  * Stage2 translation configuration:
@@ -145,9 +148,8 @@
  * 64kB pages (TG0 = 1)
  * 2 level page tables (SL = 1)
  */
-#define VTCR_EL2_FLAGS		(VTCR_EL2_TG0_64K | VTCR_EL2_SH0_INNER | \
-				 VTCR_EL2_ORGN0_WBWA | VTCR_EL2_IRGN0_WBWA | \
-				 VTCR_EL2_SL0_LVL1 | VTCR_EL2_T0SZ_40B)
+#define VTCR_EL2_FLAGS		(VTCR_EL2_TG0_64K | VTCR_EL2_SL0_LVL1 | \
+				 VTCR_EL2_COMMON_BITS)
 #define VTTBR_X		(38 - VTCR_EL2_T0SZ_40B)
 #else
 /*
@@ -156,9 +158,8 @@
  * 4kB pages (TG0 = 0)
  * 3 level page tables (SL = 1)
  */
-#define VTCR_EL2_FLAGS		(VTCR_EL2_TG0_4K | VTCR_EL2_SH0_INNER | \
-				 VTCR_EL2_ORGN0_WBWA | VTCR_EL2_IRGN0_WBWA | \
-				 VTCR_EL2_SL0_LVL1 | VTCR_EL2_T0SZ_40B)
+#define VTCR_EL2_FLAGS		(VTCR_EL2_TG0_4K | VTCR_EL2_SL0_LVL1 | \
+				 VTCR_EL2_COMMON_BITS)
 #define VTTBR_X		(37 - VTCR_EL2_T0SZ_40B)
 #endif
 
-- 
1.7.9.5
