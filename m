From: vijay.kilari@gmail.com
Subject: [PATCH v10 4/8] irqchip/gic-v3: Add missing system register
 definitions
Date: Thu,  1 Dec 2016 12:39:43 +0530
Message-ID: <1480576187-5012-5-git-send-email-vijay.kilari@gmail.com>
References: <1480576187-5012-1-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B64A4055D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2016 02:09:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kkLe0HBz0lnV for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Dec 2016 02:09:28 -0500 (EST)
Received: from mail-pg0-f68.google.com (mail-pg0-f68.google.com [74.125.83.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2082A40693
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2016 02:09:28 -0500 (EST)
Received: by mail-pg0-f68.google.com with SMTP id p66so3749495pga.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2016 23:10:19 -0800 (PST)
In-Reply-To: <1480576187-5012-1-git-send-email-vijay.kilari@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, peter.maydell@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Vijaya Kumar K <Vijaya.Kumar@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>

Define register definitions for ICH_VMCR_EL2, ICC_CTLR_EL1 and
ICH_VTR_EL2, ICC_BPR0_EL1, ICC_BPR1_EL1 registers.

Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
---
 include/linux/irqchip/arm-gic-v3.h | 43 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 2 deletions(-)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 0deea34..b4f8287 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -352,8 +352,30 @@
 /*
  * CPU interface registers
  */
-#define ICC_CTLR_EL1_EOImode_drop_dir	(0U << 1)
-#define ICC_CTLR_EL1_EOImode_drop	(1U << 1)
+#define ICC_CTLR_EL1_EOImode_SHIFT	(1)
+#define ICC_CTLR_EL1_EOImode_drop_dir	(0U << ICC_CTLR_EL1_EOImode_SHIFT)
+#define ICC_CTLR_EL1_EOImode_drop	(1U << ICC_CTLR_EL1_EOImode_SHIFT)
+#define ICC_CTLR_EL1_EOImode_MASK	(1 << ICC_CTLR_EL1_EOImode_SHIFT)
+#define ICC_CTLR_EL1_CBPR_SHIFT		0
+#define ICC_CTLR_EL1_CBPR_MASK		(1 << ICC_CTLR_EL1_CBPR_SHIFT)
+#define ICC_CTLR_EL1_PRI_BITS_SHIFT	8
+#define ICC_CTLR_EL1_PRI_BITS_MASK	(0x7 << ICC_CTLR_EL1_PRI_BITS_SHIFT)
+#define ICC_CTLR_EL1_ID_BITS_SHIFT	11
+#define ICC_CTLR_EL1_ID_BITS_MASK	(0x7 << ICC_CTLR_EL1_ID_BITS_SHIFT)
+#define ICC_CTLR_EL1_SEIS_SHIFT		14
+#define ICC_CTLR_EL1_SEIS_MASK		(0x1 << ICC_CTLR_EL1_SEIS_SHIFT)
+#define ICC_CTLR_EL1_A3V_SHIFT		15
+#define ICC_CTLR_EL1_A3V_MASK		(0x1 << ICC_CTLR_EL1_A3V_SHIFT)
+#define ICC_PMR_EL1_SHIFT		0
+#define ICC_PMR_EL1_MASK		(0xff << ICC_PMR_EL1_SHIFT)
+#define ICC_BPR0_EL1_SHIFT		0
+#define ICC_BPR0_EL1_MASK		(0x7 << ICC_BPR0_EL1_SHIFT)
+#define ICC_BPR1_EL1_SHIFT		0
+#define ICC_BPR1_EL1_MASK		(0x7 << ICC_BPR1_EL1_SHIFT)
+#define ICC_IGRPEN0_EL1_SHIFT		0
+#define ICC_IGRPEN0_EL1_MASK		(1 << ICC_IGRPEN0_EL1_SHIFT)
+#define ICC_IGRPEN1_EL1_SHIFT		0
+#define ICC_IGRPEN1_EL1_MASK		(1 << ICC_IGRPEN1_EL1_SHIFT)
 #define ICC_SRE_EL1_SRE			(1U << 0)
 
 /*
@@ -384,12 +406,29 @@
 
 #define ICH_VMCR_CTLR_SHIFT		0
 #define ICH_VMCR_CTLR_MASK		(0x21f << ICH_VMCR_CTLR_SHIFT)
+#define ICH_VMCR_CBPR_SHIFT		4
+#define ICH_VMCR_CBPR_MASK		(1 << ICH_VMCR_CBPR_SHIFT)
+#define ICH_VMCR_EOIM_SHIFT		9
+#define ICH_VMCR_EOIM_MASK		(1 << ICH_VMCR_EOIM_SHIFT)
 #define ICH_VMCR_BPR1_SHIFT		18
 #define ICH_VMCR_BPR1_MASK		(7 << ICH_VMCR_BPR1_SHIFT)
 #define ICH_VMCR_BPR0_SHIFT		21
 #define ICH_VMCR_BPR0_MASK		(7 << ICH_VMCR_BPR0_SHIFT)
 #define ICH_VMCR_PMR_SHIFT		24
 #define ICH_VMCR_PMR_MASK		(0xffUL << ICH_VMCR_PMR_SHIFT)
+#define ICH_VMCR_ENG0_SHIFT		0
+#define ICH_VMCR_ENG0_MASK		(1 << ICH_VMCR_ENG0_SHIFT)
+#define ICH_VMCR_ENG1_SHIFT		1
+#define ICH_VMCR_ENG1_MASK		(1 << ICH_VMCR_ENG1_SHIFT)
+
+#define ICH_VTR_PRI_BITS_SHIFT		29
+#define ICH_VTR_PRI_BITS_MASK		(7 << ICH_VTR_PRI_BITS_SHIFT)
+#define ICH_VTR_ID_BITS_SHIFT		23
+#define ICH_VTR_ID_BITS_MASK		(7 << ICH_VTR_ID_BITS_SHIFT)
+#define ICH_VTR_SEIS_SHIFT		22
+#define ICH_VTR_SEIS_MASK		(1 << ICH_VTR_SEIS_SHIFT)
+#define ICH_VTR_A3V_SHIFT		21
+#define ICH_VTR_A3V_MASK		(1 << ICH_VTR_A3V_SHIFT)
 
 #define ICC_IAR1_EL1_SPURIOUS		0x3ff
 
-- 
1.9.1
