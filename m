From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v9 02/17] KVM: arm/arm64: check return value for
 kvm_register_vgic_device
Date: Wed, 13 Jul 2016 02:58:54 +0100
Message-ID: <20160713015909.28793-3-andre.przywara@arm.com>
References: <20160713015909.28793-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3FA649B42
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2016 21:53:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NFn-Zju09CCG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jul 2016 21:53:04 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E22BE49B30
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2016 21:53:03 -0400 (EDT)
In-Reply-To: <20160713015909.28793-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

kvm_register_device_ops() can return an error, so lets check its return
value and propagate this up the call chain.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/arm/vgic/vgic-kvm-device.c | 15 +++++++++------
 virt/kvm/arm/vgic/vgic-v2.c         | 11 ++++++++---
 virt/kvm/arm/vgic/vgic-v3.c         | 15 +++++++++++++--
 virt/kvm/arm/vgic/vgic.h            |  2 +-
 4 files changed, 31 insertions(+), 12 deletions(-)

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
index e31405e..079bf67 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -332,20 +332,25 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
 	vtr = readl_relaxed(kvm_vgic_global_state.vctrl_base + GICH_VTR);
 	kvm_vgic_global_state.nr_lr = (vtr & 0x3f) + 1;
 
+	ret = kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V2);
+	if (ret) {
+		kvm_err("Cannot register GICv2 KVM device\n");
+		iounmap(kvm_vgic_global_state.vctrl_base);
+		return ret;
+	}
+
 	ret = create_hyp_io_mappings(kvm_vgic_global_state.vctrl_base,
 				     kvm_vgic_global_state.vctrl_base +
 					 resource_size(&info->vctrl),
 				     info->vctrl.start);
-
 	if (ret) {
 		kvm_err("Cannot map VCTRL into hyp\n");
+		kvm_unregister_device_ops(KVM_DEV_TYPE_ARM_VGIC_V2);
 		iounmap(kvm_vgic_global_state.vctrl_base);
 		return ret;
 	}
 
 	kvm_vgic_global_state.can_emulate_gicv2 = true;
-	kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V2);
-
 	kvm_vgic_global_state.vcpu_base = info->vcpu.start;
 	kvm_vgic_global_state.type = VGIC_V2;
 	kvm_vgic_global_state.max_gic_vcpus = VGIC_V2_MAX_CPUS;
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 346b4ad..e48a22e 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -296,6 +296,7 @@ out:
 int vgic_v3_probe(const struct gic_kvm_info *info)
 {
 	u32 ich_vtr_el2 = kvm_call_hyp(__vgic_v3_get_ich_vtr_el2);
+	int ret;
 
 	/*
 	 * The ListRegs field is 5 bits, but there is a architectural
@@ -319,12 +320,22 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
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
2.9.0
