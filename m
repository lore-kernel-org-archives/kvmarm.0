From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 06/25] irqchip/gic-v3: Add missing system register definitions
Date: Thu,  9 Feb 2017 14:59:04 +0000
Message-ID: <1486652363-7696-7-git-send-email-marc.zyngier@arm.com>
References: <1486652363-7696-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1486652363-7696-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@redhat.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, Pavel Fedin <p.fedin@samsung.com>, Shanker Donthineni <shankerd@codeaurora.org>, Jintack Lim <jintack@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>

Define register definitions for ICH_VMCR_EL2, ICC_CTLR_EL1 and
ICH_VTR_EL2, ICC_BPR0_EL1, ICC_BPR1_EL1 registers.

Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/linux/irqchip/arm-gic-v3.h | 43 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 2 deletions(-)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index e808f8a..7f6d904 100644
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
2.1.4
