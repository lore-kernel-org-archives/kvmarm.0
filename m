From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v5 02/13] KVM: arm/arm64: check return value for kvm_register_vgic_device
Date: Fri,  3 Jun 2016 15:02:41 +0100
Message-ID: <1464962572-3925-3-git-send-email-andre.przywara@arm.com>
References: <1464962572-3925-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1464962572-3925-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

kvm_register_device_ops() can return an error, so lets check its return
value and propagate this up the call chain.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/arm/vgic/vgic-kvm-device.c | 15 +++++++++------
 virt/kvm/arm/vgic/vgic-v2.c         |  7 ++++++-
 virt/kvm/arm/vgic/vgic-v3.c         | 15 +++++++++++++--
 virt/kvm/arm/vgic/vgic.h            |  2 +-
 4 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index 0130c4b..2f24f13 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -210,20 +210,24 @@ static void vgic_destroy(struct kvm_device *dev)
 	kfree(dev);
 }
 
-void kvm_register_vgic_device(unsigned long type)
+int kvm_register_vgic_device(unsigned long type)
 {
+	int ret = -ENODEV;
+
 	switch (type) {
 	case KVM_DEV_TYPE_ARM_VGIC_V2:
-		kvm_register_device_ops(&kvm_arm_vgic_v2_ops,
-					KVM_DEV_TYPE_ARM_VGIC_V2);
+		ret = kvm_register_device_ops(&kvm_arm_vgic_v2_ops,
+					      KVM_DEV_TYPE_ARM_VGIC_V2);
 		break;
 #ifdef CONFIG_KVM_ARM_VGIC_V3
 	case KVM_DEV_TYPE_ARM_VGIC_V3:
-		kvm_register_device_ops(&kvm_arm_vgic_v3_ops,
-					KVM_DEV_TYPE_ARM_VGIC_V3);
+		ret = kvm_register_device_ops(&kvm_arm_vgic_v3_ops,
+					      KVM_DEV_TYPE_ARM_VGIC_V3);
 		break;
 #endif
 	}
+
+	return ret;
 }
 
 /** vgic_attr_regs_access: allows user space to read/write VGIC registers
@@ -428,4 +432,3 @@ struct kvm_device_ops kvm_arm_vgic_v3_ops = {
 };
 
 #endif /* CONFIG_KVM_ARM_VGIC_V3 */
-
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 8ad42c2..423bef1 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -340,7 +340,12 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
 	}
 
 	kvm_vgic_global_state.can_emulate_gicv2 = true;
-	kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V2);
+	ret = kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V2);
+	if (ret) {
+		kvm_err("Cannot register GICv2 KVM device\n");
+		iounmap(kvm_vgic_global_state.vctrl_base);
+		return ret;
+	}
 
 	kvm_vgic_global_state.vcpu_base = info->vcpu.start;
 	kvm_vgic_global_state.type = VGIC_V2;
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 336a461..dea9a98 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -292,6 +292,7 @@ out:
 int vgic_v3_probe(const struct gic_kvm_info *info)
 {
 	u32 ich_vtr_el2 = kvm_call_hyp(__vgic_v3_get_ich_vtr_el2);
+	int ret;
 
 	/*
 	 * The ListRegs field is 5 bits, but there is a architectural
@@ -315,12 +316,22 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
 	} else {
 		kvm_vgic_global_state.vcpu_base = info->vcpu.start;
 		kvm_vgic_global_state.can_emulate_gicv2 = true;
-		kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V2);
+		ret = kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V2);
+		if (ret) {
+			kvm_err("Cannot register GICv2 KVM device.\n");
+			return ret;
+		}
 		kvm_info("vgic-v2@%llx\n", info->vcpu.start);
 	}
+	ret = kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V3);
+	if (ret) {
+		kvm_err("Cannot register GICv3 KVM device.\n");
+		kvm_unregister_device_ops(KVM_DEV_TYPE_ARM_VGIC_V2);
+		return ret;
+	}
+
 	if (kvm_vgic_global_state.vcpu_base == 0)
 		kvm_info("disabling GICv2 emulation\n");
-	kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V3);
 
 	kvm_vgic_global_state.vctrl_base = NULL;
 	kvm_vgic_global_state.type = VGIC_V3;
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 7b300ca..c752152 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -124,7 +124,7 @@ static inline int vgic_register_redist_iodevs(struct kvm *kvm,
 }
 #endif
 
-void kvm_register_vgic_device(unsigned long type);
+int kvm_register_vgic_device(unsigned long type);
 int vgic_lazy_init(struct kvm *kvm);
 int vgic_init(struct kvm *kvm);
 
-- 
2.8.2

