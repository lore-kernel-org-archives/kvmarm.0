From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 16/27] KVM: arm64: vgic-v3: Enable trapping of Group-0
 system registers
Date: Fri,  9 Jun 2017 12:49:45 +0100
Message-ID: <20170609114956.25963-17-marc.zyngier@arm.com>
References: <20170609114956.25963-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32C1F40905
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Jun 2017 07:46:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y+odhMr-n0p4 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Jun 2017 07:46:23 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6B6F40430
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Jun 2017 07:46:22 -0400 (EDT)
In-Reply-To: <20170609114956.25963-1-marc.zyngier@arm.com>
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

In order to be able to trap Group-0 GICv3 system registers, we need to
set ICH_HCR_EL2.TALL0 begore entering the guest. This is conditionnaly
done after having restored the guest's state, and cleared on exit.

Tested-by: Alexander Graf <agraf@suse.de>
Acked-by: David Daney <david.daney@cavium.com>
Acked-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/linux/irqchip/arm-gic-v3.h | 1 +
 virt/kvm/arm/vgic/vgic-v3.c        | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 03b5a28bb2d0..46a1e0943cf8 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -417,6 +417,7 @@
 
 #define ICH_HCR_EN			(1 << 0)
 #define ICH_HCR_UIE			(1 << 1)
+#define ICH_HCR_TALL0			(1 << 11)
 #define ICH_HCR_TALL1			(1 << 12)
 #define ICH_HCR_EOIcount_SHIFT		27
 #define ICH_HCR_EOIcount_MASK		(0x1f << ICH_HCR_EOIcount_SHIFT)
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index df55818f095c..06773b985b4e 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -21,6 +21,7 @@
 
 #include "vgic.h"
 
+static bool group0_trap;
 static bool group1_trap;
 
 void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
@@ -241,6 +242,8 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
 
 	/* Get the show on the road... */
 	vgic_v3->vgic_hcr = ICH_HCR_EN;
+	if (group0_trap)
+		vgic_v3->vgic_hcr |= ICH_HCR_TALL0;
 	if (group1_trap)
 		vgic_v3->vgic_hcr |= ICH_HCR_TALL1;
 }
@@ -473,7 +476,7 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
 	if (kvm_vgic_global_state.vcpu_base == 0)
 		kvm_info("disabling GICv2 emulation\n");
 
-	if (group1_trap) {
+	if (group0_trap || group1_trap) {
 		kvm_info("GICv3 sysreg trapping enabled (reduced performance)\n");
 		static_branch_enable(&vgic_v3_cpuif_trap);
 	}
-- 
2.11.0
