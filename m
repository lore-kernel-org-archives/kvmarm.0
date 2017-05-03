From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 17/31] KVM: arm64: vgic-v3: Enable trapping of Group-1 system
 registers
Date: Wed,  3 May 2017 11:45:52 +0100
Message-ID: <20170503104606.19342-18-marc.zyngier@arm.com>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBC8740C72
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 06:43:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a5AXZ+lVCH0J for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 May 2017 06:43:37 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1964440BE3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 06:43:37 -0400 (EDT)
In-Reply-To: <20170503104606.19342-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

In order to be able to trap Group-1 GICv3 system registers, we need to
set ICH_HCR_EL2.TALL1 begore entering the guest. This is conditionnaly
done after having restored the guest's state, and cleared on exit.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/linux/irqchip/arm-gic-v3.h | 1 +
 virt/kvm/arm/hyp/vgic-v3-sr.c      | 7 +++++++
 virt/kvm/arm/vgic/vgic-v3.c        | 4 ++++
 3 files changed, 12 insertions(+)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index c56d9bc2c904..a1739843343e 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -403,6 +403,7 @@
 
 #define ICH_HCR_EN			(1 << 0)
 #define ICH_HCR_UIE			(1 << 1)
+#define ICH_HCR_TALL1			(1 << 12)
 #define ICH_HCR_EOIcount_SHIFT		27
 #define ICH_HCR_EOIcount_MASK		(0x1f << ICH_HCR_EOIcount_SHIFT)
 
diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index a521e105ade1..a27671b1e9af 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -257,6 +257,9 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 			cpu_if->vgic_ap1r[0] = __vgic_v3_read_ap1rn(0);
 		}
 	} else {
+		if (static_branch_unlikely(&vgic_v3_cpuif_trap))
+			write_gicreg(0, ICH_HCR_EL2);
+
 		cpu_if->vgic_elrsr = 0xffff;
 		cpu_if->vgic_ap0r[0] = 0;
 		cpu_if->vgic_ap0r[1] = 0;
@@ -329,6 +332,10 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 
 		for (i = 0; i < used_lrs; i++)
 			__gic_v3_set_lr(cpu_if->vgic_lr[i], i);
+	} else {
+		/* Always write ICH_HCR_EL2 to enable trapping */
+		if (static_branch_unlikely(&vgic_v3_cpuif_trap))
+			write_gicreg(cpu_if->vgic_hcr, ICH_HCR_EL2);
 	}
 
 	/*
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 063526443781..547b8374fb64 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -21,6 +21,8 @@
 
 #include "vgic.h"
 
+static bool group1_trap;
+
 void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
@@ -239,6 +241,8 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
 
 	/* Get the show on the road... */
 	vgic_v3->vgic_hcr = ICH_HCR_EN;
+	if (group1_trap)
+		vgic_v3->vgic_hcr |= ICH_HCR_TALL1;
 }
 
 /* check for overlapping regions and for regions crossing the end of memory */
-- 
2.11.0
