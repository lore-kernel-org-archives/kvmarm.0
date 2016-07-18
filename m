From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 02/13] irqchip/gicv3-its: Restore all cacheability attributes
Date: Mon, 18 Jul 2016 16:54:04 +0100
Message-ID: <1468857255-9543-3-git-send-email-marc.zyngier@arm.com>
References: <1468857255-9543-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED2EB412A6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2016 11:48:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XTlGzwwNE20I for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2016 11:48:18 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BBE7411BE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2016 11:48:18 -0400 (EDT)
In-Reply-To: <1468857255-9543-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>, Andre Przywara <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Let's restore some of the #defines that have been savagely dropped
by the introduction of the KVM ITS code, as pointlessly break
other users (including series that are already in -next).

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/linux/irqchip/arm-gic-v3.h | 48 +++++++++++++++++++++++++++++++-------
 1 file changed, 40 insertions(+), 8 deletions(-)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 195fe59..f83e91b 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -146,8 +146,16 @@
 
 #define GICR_PROPBASER_InnerShareable					\
 	GIC_BASER_SHAREABILITY(GICR_PROPBASER, InnerShareable)
-#define GICR_PROPBASER_nC GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, nC)
-#define GICR_PROPBASER_WaWb GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, WaWb)
+
+#define GICR_PROPBASER_nCnB	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, nCnB)
+#define GICR_PROPBASER_nC 	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, nC)
+#define GICR_PROPBASER_RaWt	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, RaWt)
+#define GICR_PROPBASER_RaWb	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, RaWt)
+#define GICR_PROPBASER_WaWt	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, WaWt)
+#define GICR_PROPBASER_WaWb	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, WaWb)
+#define GICR_PROPBASER_RaWaWt	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, RaWaWt)
+#define GICR_PROPBASER_RaWaWb	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, RaWaWb)
+
 #define GICR_PROPBASER_IDBITS_MASK			(0x1f)
 
 #define GICR_PENDBASER_SHAREABILITY_SHIFT		(10)
@@ -163,8 +171,16 @@
 
 #define GICR_PENDBASER_InnerShareable					\
 	GIC_BASER_SHAREABILITY(GICR_PENDBASER, InnerShareable)
-#define GICR_PENDBASER_nC GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, nC)
-#define GICR_PENDBASER_WaWb GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, WaWb)
+
+#define GICR_PENDBASER_nCnB	GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, nCnB)
+#define GICR_PENDBASER_nC 	GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, nC)
+#define GICR_PENDBASER_RaWt	GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, RaWt)
+#define GICR_PENDBASER_RaWb	GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, RaWt)
+#define GICR_PENDBASER_WaWt	GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, WaWt)
+#define GICR_PENDBASER_WaWb	GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, WaWb)
+#define GICR_PENDBASER_RaWaWt	GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, RaWaWt)
+#define GICR_PENDBASER_RaWaWb	GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, RaWaWb)
+
 #define GICR_PENDBASER_PTZ				BIT_ULL(62)
 
 /*
@@ -237,24 +253,40 @@
 
 #define GITS_CBASER_InnerShareable					\
 	GIC_BASER_SHAREABILITY(GITS_CBASER, InnerShareable)
-#define GITS_CBASER_nC GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, nC)
-#define GITS_CBASER_WaWb GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, WaWb)
+
+#define GITS_CBASER_nCnB	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, nCnB)
+#define GITS_CBASER_nC		GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, nC)
+#define GITS_CBASER_RaWt	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, RaWt)
+#define GITS_CBASER_RaWb	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, RaWt)
+#define GITS_CBASER_WaWt	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, WaWt)
+#define GITS_CBASER_WaWb	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, WaWb)
+#define GITS_CBASER_RaWaWt	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, RaWaWt)
+#define GITS_CBASER_RaWaWb	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, RaWaWb)
 
 #define GITS_BASER_NR_REGS		8
 
 #define GITS_BASER_VALID			(1UL << 63)
 #define GITS_BASER_INDIRECT			(1ULL << 62)
+
 #define GITS_BASER_INNER_CACHEABILITY_SHIFT	(59)
 #define GITS_BASER_OUTER_CACHEABILITY_SHIFT	(53)
 #define GITS_BASER_INNER_CACHEABILITY_MASK				\
 	GIC_BASER_CACHEABILITY(GITS_BASER, INNER, MASK)
+#define GITS_BASER_CACHEABILITY_MASK		GITS_BASER_INNER_CACHEABILITY_MASK
 #define GITS_BASER_OUTER_CACHEABILITY_MASK				\
 	GIC_BASER_CACHEABILITY(GITS_BASER, OUTER, MASK)
 #define GITS_BASER_SHAREABILITY_MASK					\
 	GIC_BASER_SHAREABILITY(GITS_BASER, SHAREABILITY_MASK)
 
-#define GITS_BASER_nC GIC_BASER_CACHEABILITY(GITS_BASER, INNER, nC)
-#define GITS_BASER_WaWb GIC_BASER_CACHEABILITY(GITS_BASER, INNER, WaWb)
+#define GITS_BASER_nCnB		GIC_BASER_CACHEABILITY(GITS_BASER, INNER, nCnB)
+#define GITS_BASER_nC		GIC_BASER_CACHEABILITY(GITS_BASER, INNER, nC)
+#define GITS_BASER_RaWt		GIC_BASER_CACHEABILITY(GITS_BASER, INNER, RaWt)
+#define GITS_BASER_RaWb		GIC_BASER_CACHEABILITY(GITS_BASER, INNER, RaWt)
+#define GITS_BASER_WaWt		GIC_BASER_CACHEABILITY(GITS_BASER, INNER, WaWt)
+#define GITS_BASER_WaWb		GIC_BASER_CACHEABILITY(GITS_BASER, INNER, WaWb)
+#define GITS_BASER_RaWaWt	GIC_BASER_CACHEABILITY(GITS_BASER, INNER, RaWaWt)
+#define GITS_BASER_RaWaWb	GIC_BASER_CACHEABILITY(GITS_BASER, INNER, RaWaWb)
+
 #define GITS_BASER_TYPE_SHIFT			(56)
 #define GITS_BASER_TYPE(r)		(((r) >> GITS_BASER_TYPE_SHIFT) & 7)
 #define GITS_BASER_ENTRY_SIZE_SHIFT		(48)
-- 
2.1.4
