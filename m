From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 08/14] KVM: arm64: Fix ICH_ELRSR_EL2 sysreg naming
Date: Thu, 24 Jan 2019 15:00:26 +0100
Message-ID: <20190124140032.8588-9-christoffer.dall@arm.com>
References: <20190124140032.8588-1-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 682524A416
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 09:01:02 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WQ+R+Ue+fTHC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jan 2019 09:01:01 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4885D4A3D2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 09:00:56 -0500 (EST)
In-Reply-To: <20190124140032.8588-1-christoffer.dall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

We previously incorrectly named the define for this system register.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 arch/arm/include/asm/arch_gicv3.h | 4 ++--
 arch/arm64/include/asm/sysreg.h   | 2 +-
 virt/kvm/arm/hyp/vgic-v3-sr.c     | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/arch_gicv3.h b/arch/arm/include/asm/arch_gicv3.h
index 0bd530702118..bdc87700def2 100644
--- a/arch/arm/include/asm/arch_gicv3.h
+++ b/arch/arm/include/asm/arch_gicv3.h
@@ -54,7 +54,7 @@
 #define ICH_VTR				__ACCESS_CP15(c12, 4, c11, 1)
 #define ICH_MISR			__ACCESS_CP15(c12, 4, c11, 2)
 #define ICH_EISR			__ACCESS_CP15(c12, 4, c11, 3)
-#define ICH_ELSR			__ACCESS_CP15(c12, 4, c11, 5)
+#define ICH_ELRSR			__ACCESS_CP15(c12, 4, c11, 5)
 #define ICH_VMCR			__ACCESS_CP15(c12, 4, c11, 7)
 
 #define __LR0(x)			__ACCESS_CP15(c12, 4, c12, x)
@@ -151,7 +151,7 @@ CPUIF_MAP(ICH_HCR, ICH_HCR_EL2)
 CPUIF_MAP(ICH_VTR, ICH_VTR_EL2)
 CPUIF_MAP(ICH_MISR, ICH_MISR_EL2)
 CPUIF_MAP(ICH_EISR, ICH_EISR_EL2)
-CPUIF_MAP(ICH_ELSR, ICH_ELSR_EL2)
+CPUIF_MAP(ICH_ELRSR, ICH_ELRSR_EL2)
 CPUIF_MAP(ICH_VMCR, ICH_VMCR_EL2)
 CPUIF_MAP(ICH_AP0R3, ICH_AP0R3_EL2)
 CPUIF_MAP(ICH_AP0R2, ICH_AP0R2_EL2)
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 72dc4c011014..3e5650903d6d 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -426,7 +426,7 @@
 #define SYS_ICH_VTR_EL2			sys_reg(3, 4, 12, 11, 1)
 #define SYS_ICH_MISR_EL2		sys_reg(3, 4, 12, 11, 2)
 #define SYS_ICH_EISR_EL2		sys_reg(3, 4, 12, 11, 3)
-#define SYS_ICH_ELSR_EL2		sys_reg(3, 4, 12, 11, 5)
+#define SYS_ICH_ELRSR_EL2		sys_reg(3, 4, 12, 11, 5)
 #define SYS_ICH_VMCR_EL2		sys_reg(3, 4, 12, 11, 7)
 
 #define __SYS__LR0_EL2(x)		sys_reg(3, 4, 12, 12, x)
diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index 9652c453480f..264d92da3240 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -226,7 +226,7 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 		int i;
 		u32 elrsr;
 
-		elrsr = read_gicreg(ICH_ELSR_EL2);
+		elrsr = read_gicreg(ICH_ELRSR_EL2);
 
 		write_gicreg(cpu_if->vgic_hcr & ~ICH_HCR_EN, ICH_HCR_EL2);
 
-- 
2.18.0
