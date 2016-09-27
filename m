From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 37/50] arm64: KVM: Use static keys for selecting the GIC backend
Date: Tue, 27 Sep 2016 20:05:45 +0200
Message-ID: <20160927180558.14699-38-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB9E049BAA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:57:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XkxLJtzZSccK for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:57:05 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4256C49BB6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:57:00 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id w84so190368760wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:06:23 -0700 (PDT)
In-Reply-To: <20160927180558.14699-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Vladimir Murzin <vladimir.murzin@arm.com>

Currently GIC backend is selected via alternative framework and this
is fine. We are going to introduce vgic-v3 to 32-bit world and there
we don't have patching framework in hand, so we can either check
support for GICv3 every time we need to choose which backend to use or
try to optimise it by using static keys. The later looks quite
promising because we can share logic involved in selecting GIC backend
between architectures if both uses static keys.

This patch moves arm64 from alternative to static keys framework for
selecting GIC backend. For that we embed static key into vgic_global
and enable the key during vgic initialisation based on what has
already been exposed by the host GIC driver.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp/switch.c   | 21 +++++++++++----------
 include/kvm/arm_vgic.h        |  4 ++++
 virt/kvm/arm/vgic/vgic-init.c |  4 ++++
 virt/kvm/arm/vgic/vgic.c      |  2 +-
 4 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 731519c..83037cd 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -16,6 +16,8 @@
  */
 
 #include <linux/types.h>
+#include <linux/jump_label.h>
+
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
@@ -136,17 +138,13 @@ static void __hyp_text __deactivate_vm(struct kvm_vcpu *vcpu)
 	write_sysreg(0, vttbr_el2);
 }
 
-static hyp_alternate_select(__vgic_call_save_state,
-			    __vgic_v2_save_state, __vgic_v3_save_state,
-			    ARM64_HAS_SYSREG_GIC_CPUIF);
-
-static hyp_alternate_select(__vgic_call_restore_state,
-			    __vgic_v2_restore_state, __vgic_v3_restore_state,
-			    ARM64_HAS_SYSREG_GIC_CPUIF);
-
 static void __hyp_text __vgic_save_state(struct kvm_vcpu *vcpu)
 {
-	__vgic_call_save_state()(vcpu);
+	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+		__vgic_v3_save_state(vcpu);
+	else
+		__vgic_v2_save_state(vcpu);
+
 	write_sysreg(read_sysreg(hcr_el2) & ~HCR_INT_OVERRIDE, hcr_el2);
 }
 
@@ -159,7 +157,10 @@ static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
 	val |= vcpu->arch.irq_lines;
 	write_sysreg(val, hcr_el2);
 
-	__vgic_call_restore_state()(vcpu);
+	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+		__vgic_v3_restore_state(vcpu);
+	else
+		__vgic_v2_restore_state(vcpu);
 }
 
 static bool __hyp_text __true_value(void)
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index bb46c03..8d22adc 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -24,6 +24,7 @@
 #include <linux/types.h>
 #include <kvm/iodev.h>
 #include <linux/list.h>
+#include <linux/jump_label.h>
 
 #define VGIC_V3_MAX_CPUS	255
 #define VGIC_V2_MAX_CPUS	8
@@ -67,6 +68,9 @@ struct vgic_global {
 
 	/* Only needed for the legacy KVM_CREATE_IRQCHIP */
 	bool			can_emulate_gicv2;
+
+	/* GIC system register CPU interface */
+	struct static_key_false gicv3_cpuif;
 };
 
 extern struct vgic_global kvm_vgic_global_state;
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 83777c1..8cebfbc 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -405,6 +405,10 @@ int kvm_vgic_hyp_init(void)
 		break;
 	case GIC_V3:
 		ret = vgic_v3_probe(gic_kvm_info);
+		if (!ret) {
+			static_branch_enable(&kvm_vgic_global_state.gicv3_cpuif);
+			kvm_info("GIC system register CPU interface enabled\n");
+		}
 		break;
 	default:
 		ret = -ENODEV;
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index e83b7fe..8a529a7 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -29,7 +29,7 @@
 #define DEBUG_SPINLOCK_BUG_ON(p)
 #endif
 
-struct vgic_global __section(.hyp.text) kvm_vgic_global_state;
+struct vgic_global __section(.hyp.text) kvm_vgic_global_state = {.gicv3_cpuif = STATIC_KEY_FALSE_INIT,};
 
 /*
  * Locking order is always:
-- 
2.9.0
