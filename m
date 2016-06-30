From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 06/18] arm64: KVM: Define HYP offset masks
Date: Thu, 30 Jun 2016 18:40:39 +0100
Message-ID: <1467308451-13365-7-git-send-email-marc.zyngier@arm.com>
References: <1467308451-13365-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1467308451-13365-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Define the two possible HYP VA regions in terms of VA_BITS,
and keep HYP_PAGE_OFFSET_MASK as a temporary compatibility
definition.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 2f1e1ae..5e54323 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -68,8 +68,12 @@
  * functionality is already mapped as part of the main kernel
  * mappings, and none of this applies in that case.
  */
-#define HYP_PAGE_OFFSET_SHIFT	VA_BITS
-#define HYP_PAGE_OFFSET_MASK	((UL(1) << HYP_PAGE_OFFSET_SHIFT) - 1)
+
+#define HYP_PAGE_OFFSET_HIGH_MASK	((UL(1) << VA_BITS) - 1)
+#define HYP_PAGE_OFFSET_LOW_MASK	((UL(1) << (VA_BITS - 1)) - 1)
+
+/* Temporary compat define */
+#define HYP_PAGE_OFFSET_MASK		HYP_PAGE_OFFSET_HIGH_MASK
 
 /*
  * Our virtual mapping for the idmap-ed MMU-enable code. Must be
-- 
2.1.4

