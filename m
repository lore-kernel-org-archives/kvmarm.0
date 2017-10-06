From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 25/26] KVM: arm/arm64: GICv4: Prevent heterogenous systems
 from using GICv4
Date: Fri,  6 Oct 2017 16:34:00 +0100
Message-ID: <20171006153401.5481-26-marc.zyngier@arm.com>
References: <20171006153401.5481-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60B0249D0F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Oct 2017 11:34:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rcqdSO5PJ97r for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Oct 2017 11:34:28 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4B5D49D63
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Oct 2017 11:34:27 -0400 (EDT)
In-Reply-To: <20171006153401.5481-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

The GICv4 architecture doesn't prevent CPUs implementing GICv4 to
cohabit with CPUs limited to GICv3 in the same system.

This is mad (the scheduler would have to be made aware of the v4
capability), and we're certainly not going to support this any
time soon. So let's check that all online CPUs are GICv4 capable,
and disable the functionnality if not.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/linux/irqchip/arm-gic-v3.h |  2 ++
 virt/kvm/arm/vgic/vgic-v3.c        | 27 +++++++++++++++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 1ea576c8126f..dfa4a51643d6 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -532,6 +532,8 @@
 #define ICH_VTR_SEIS_MASK		(1 << ICH_VTR_SEIS_SHIFT)
 #define ICH_VTR_A3V_SHIFT		21
 #define ICH_VTR_A3V_MASK		(1 << ICH_VTR_A3V_SHIFT)
+#define ICH_VTR_nV4_SHIFT		20
+#define ICH_VTR_nV4_MASK		(1 << ICH_VTR_nV4_SHIFT)
 
 #define ICC_IAR1_EL1_SPURIOUS		0x3ff
 
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 405733678c2f..da99df50a818 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -466,9 +466,19 @@ static int __init early_gicv4_enable(char *buf)
 }
 early_param("kvm-arm.vgic_v4_enable", early_gicv4_enable);
 
+static void vgic_check_v4_cpuif(void *param)
+{
+	u32 ich_vtr_el2 = kvm_call_hyp(__vgic_v3_get_ich_vtr_el2);
+	bool *v4 = param;
+
+	*v4 = !(ich_vtr_el2 & ICH_VTR_nV4_MASK);
+	if (!*v4)
+		kvm_info("CPU%d is not GICv4 capable\n", smp_processor_id());
+}
+
 /**
  * vgic_v3_probe - probe for a GICv3 compatible interrupt controller in DT
- * @node:	pointer to the DT node
+ * @info:	pointer to the firmware-agnostic GIC information
  *
  * Returns 0 if a GICv3 has been found, returns an error code otherwise
  */
@@ -485,8 +495,21 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
 	kvm_vgic_global_state.can_emulate_gicv2 = false;
 	kvm_vgic_global_state.ich_vtr_el2 = ich_vtr_el2;
 
-	/* GICv4 support? */
+	/*
+	 * GICv4 support? We need to check on all CPUs in case of some
+	 * extremely creative form of big-little brain damage...
+	 */
 	if (info->has_v4) {
+		int cpu;
+
+		for_each_online_cpu(cpu) {
+			bool enable;
+
+			smp_call_function_single(cpu, vgic_check_v4_cpuif,
+						 &enable, 1);
+			gicv4_enable = gicv4_enable && enable;
+		}
+
 		kvm_vgic_global_state.has_gicv4 = gicv4_enable;
 		kvm_info("GICv4 support %sabled\n",
 			 gicv4_enable ? "en" : "dis");
-- 
2.14.1
