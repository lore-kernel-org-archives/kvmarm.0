From: vijay.kilari@gmail.com
Subject: [PATCH v9 11/11] arm: vgic: Save and restore GICv3 CPU interface regs
 for AArch32
Date: Wed, 23 Nov 2016 18:31:58 +0530
Message-ID: <1479906118-15832-12-git-send-email-vijay.kilari@gmail.com>
References: <1479906118-15832-1-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23451409C6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2016 08:02:02 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZdZ4Wiv5ysoE for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Nov 2016 08:02:01 -0500 (EST)
Received: from mail-pg0-f67.google.com (mail-pg0-f67.google.com [74.125.83.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D8EEE40C35
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2016 08:02:00 -0500 (EST)
Received: by mail-pg0-f67.google.com with SMTP id e9so1089843pgc.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2016 05:02:41 -0800 (PST)
In-Reply-To: <1479906118-15832-1-git-send-email-vijay.kilari@gmail.com>
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

Use coproc_reg infrastructure to save and restore CPU
interface register of GICv3 for AArch32 host.

Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
---
 arch/arm/kvm/Makefile                  |   2 +
 virt/kvm/arm/vgic/vgic-coproc-reg-v3.c | 155 +++++++++++++++++++++++++++++++++
 2 files changed, 157 insertions(+)

diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index d571243..451e666 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -32,6 +32,8 @@ obj-y += $(KVM)/arm/vgic/vgic-mmio.o
 obj-y += $(KVM)/arm/vgic/vgic-mmio-v2.o
 obj-y += $(KVM)/arm/vgic/vgic-mmio-v3.o
 obj-y += $(KVM)/arm/vgic/vgic-kvm-device.o
+obj-y += $(KVM)/arm/vgic/vgic-sys-reg-common.o
+obj-y += $(KVM)/arm/vgic/vgic-coproc-reg-v3.o
 obj-y += $(KVM)/arm/vgic/vgic-its.o
 obj-y += $(KVM)/irqchip.o
 obj-y += $(KVM)/arm/arch_timer.o
diff --git a/virt/kvm/arm/vgic/vgic-coproc-reg-v3.c b/virt/kvm/arm/vgic/vgic-coproc-reg-v3.c
new file mode 100644
index 0000000..25d00e5
--- /dev/null
+++ b/virt/kvm/arm/vgic/vgic-coproc-reg-v3.c
@@ -0,0 +1,155 @@
+/*
+ * VGIC system registers handling functions
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <kvm/arm_vgic.h>
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_arm.h>
+
+#include "vgic.h"
+#include "coproc.h"
+
+#define ACCESS_COPROC_REG(REG)						\
+static bool access_gic_##REG##_coproc_reg(struct kvm_vcpu *vcpu,	\
+				   struct coproc_params *p,		\
+				   const struct coproc_reg *r)		\
+{									\
+	return  access_gic_##REG##_reg(vcpu, p->is_write, &p->Rt1);	\
+}
+
+ACCESS_COPROC_REG(ctlr)
+ACCESS_COPROC_REG(pmr)
+ACCESS_COPROC_REG(bpr0)
+ACCESS_COPROC_REG(bpr1)
+ACCESS_COPROC_REG(sre)
+ACCESS_COPROC_REG(grpen0)
+ACCESS_COPROC_REG(grpen1)
+
+#define ACCESS_COPROC_APNR_REG(REG)					\
+static bool access_gic_##REG##_coproc_reg(struct kvm_vcpu *vcpu,	\
+				   struct coproc_params *p,		\
+				   const struct coproc_reg *r)		\
+{									\
+	u8 idx = p->Op2 & 3;						\
+									\
+	return access_gic_##REG##_reg(vcpu, p->is_write, idx, &p->Rt1);	\
+}
+
+ACCESS_COPROC_APNR_REG(ap0r)
+ACCESS_COPROC_APNR_REG(ap1r)
+
+static const struct coproc_reg gic_v3_icc_coproc_reg_descs[] = {
+	/* ICC_PMR_EL1 */
+	{ CRn(0), CRm(6), Op1(0), Op2(0), is32, access_gic_pmr_coproc_reg },
+	/* ICC_BPR0_EL1 */
+	{ CRn(12), CRm(8), Op1(0), Op2(3), is32, access_gic_bpr0_coproc_reg },
+	/* ICC_AP0R0_EL1 */
+	{ CRn(12), CRm(8), Op1(0), Op2(4), is32, access_gic_ap0r_coproc_reg },
+	/* ICC_AP0R1_EL1 */
+	{ CRn(12), CRm(8), Op1(0), Op2(5), is32, access_gic_ap0r_coproc_reg },
+	/* ICC_AP0R2_EL1 */
+	{ CRn(12), CRm(8), Op1(0), Op2(6), is32, access_gic_ap0r_coproc_reg },
+	/* ICC_AP0R3_EL1 */
+	{ CRn(12), CRm(8), Op1(0), Op2(7), is32, access_gic_ap0r_coproc_reg },
+	/* ICC_AP1R0_EL1 */
+	{ CRn(12), CRm(9), Op1(0), Op2(0), is32, access_gic_ap1r_coproc_reg },
+	/* ICC_AP1R1_EL1 */
+	{ CRn(12), CRm(9), Op1(0), Op2(1), is32, access_gic_ap1r_coproc_reg },
+	/* ICC_AP1R2_EL1 */
+	{ CRn(12), CRm(9), Op1(0), Op2(2), is32, access_gic_ap1r_coproc_reg },
+	/* ICC_AP1R3_EL1 */
+	{ CRn(12), CRm(9), Op1(0), Op2(3), is32, access_gic_ap1r_coproc_reg },
+	/* ICC_BPR1_EL1 */
+	{ CRn(12), CRm(12), Op1(0), Op2(3), is32, access_gic_bpr1_coproc_reg },
+	/* ICC_CTLR_EL1 */
+	{ CRn(12), CRm(12), Op1(0), Op2(4), is32, access_gic_ctlr_coproc_reg },
+	/* ICC_SRE_EL1 */
+	{ CRn(12), CRm(12), Op1(0), Op2(5), is32, access_gic_sre_coproc_reg },
+	/* ICC_IGRPEN0_EL1 */
+	{ CRn(12), CRm(12), Op1(0), Op2(6), is32,
+	  access_gic_grpen0_coproc_reg },
+	/* ICC_GRPEN1_EL1 */
+	{ CRn(12), CRm(12), Op1(0), Op2(7), is32,
+	  access_gic_grpen1_coproc_reg },
+};
+
+
+#define KVM_DEV_ARM_VGIC_COPROC_MASK 0x3fff
+
+/* As per Documentation/virtual/kvm/devices/arm-vgic-v3.txt,
+ * CPUREGs id is passed in AArch64 system register encoding format.
+ * Format to COPROC register format for AArch32 mode before using.
+ */
+static u64 vgic_to_cpreg(u64 id)
+{
+	u64 cpreg = 0;
+
+	id = id & KVM_DEV_ARM_VGIC_COPROC_MASK;
+	cpreg = ((id & KVM_REG_ARM_VGIC_SYSREG_OP2_MASK) >>
+		  KVM_REG_ARM_VGIC_SYSREG_OP2_SHIFT) <<
+		  KVM_REG_ARM_32_OPC2_SHIFT;
+	cpreg |= ((id & KVM_REG_ARM_VGIC_SYSREG_CRM_MASK) >>
+		  KVM_REG_ARM_VGIC_SYSREG_CRM_SHIFT) << KVM_REG_ARM_CRM_SHIFT;
+	cpreg |= ((id & KVM_REG_ARM_VGIC_SYSREG_CRN_MASK) >>
+		   KVM_REG_ARM_VGIC_SYSREG_CRN_SHIFT) <<
+		   KVM_REG_ARM_32_CRN_SHIFT;
+	cpreg |= ((id & KVM_REG_ARM_VGIC_SYSREG_OP1_MASK) >>
+		   KVM_REG_ARM_VGIC_SYSREG_OP1_SHIFT) << KVM_REG_ARM_OPC1_SHIFT;
+	id |= (KVM_REG_ARM_COPROC_MASK | KVM_REG_SIZE_U32);
+
+	return cpreg;
+}
+
+int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
+				 u64 *reg)
+{
+	struct coproc_params params;
+	u64 cpreg = vgic_to_cpreg(id);
+
+	params.Rt1 = *reg;
+	params.is_write = is_write;
+	params.is_64bit = false;
+
+	if (find_coproc_reg_by_id(cpreg, &params, gic_v3_icc_coproc_reg_descs,
+				  ARRAY_SIZE(gic_v3_icc_coproc_reg_descs)))
+		return 0;
+
+	return -ENOENT;
+}
+
+int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write, u64 id,
+				u64 *reg)
+{
+	struct coproc_params params;
+	const struct coproc_reg *r;
+	u64 cpreg = vgic_to_cpreg(id);
+
+	if (is_write)
+		params.Rt1 = *reg;
+	params.is_write = is_write;
+	params.is_64bit = false;
+
+	r = find_coproc_reg_by_id(cpreg, &params, gic_v3_icc_coproc_reg_descs,
+				  ARRAY_SIZE(gic_v3_icc_coproc_reg_descs));
+	if (!r)
+		return -ENXIO;
+
+	if (!r->access(vcpu, &params, r))
+		return -EINVAL;
+
+	if (!is_write)
+		*reg = params.Rt1;
+
+	return 0;
+}
-- 
1.9.1
