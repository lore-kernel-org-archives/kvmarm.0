From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v3 4/8] KVM: arm64: vgic-its: Introduce config option to guard
 ITS specific code
Date: Thu,  8 Sep 2016 17:06:46 +0100
Message-ID: <1473350810-10857-5-git-send-email-vladimir.murzin@arm.com>
References: <1473350810-10857-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4E4049B34
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Sep 2016 11:59:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VCHwhbqimbS8 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Sep 2016 11:59:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3C6749B40
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Sep 2016 11:59:40 -0400 (EDT)
In-Reply-To: <1473350810-10857-1-git-send-email-vladimir.murzin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

By now ITS code guarded with KVM_ARM_VGIC_V3 config option which was
introduced to hide everything specific to vgic-v3 from 32-bit world.
We are going to support vgic-v3 in 32-bit world and KVM_ARM_VGIC_V3
will gone, but we don't have support for ITS there yet and we need to
continue keeping ITS away.
Introduce the new config option to prevent ITS code being build in
32-bit mode when support for vgic-v3 is done.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 arch/arm64/kvm/Kconfig              |    4 ++++
 virt/kvm/arm/vgic/vgic-kvm-device.c |    3 +++
 virt/kvm/arm/vgic/vgic-mmio-v3.c    |    2 ++
 virt/kvm/arm/vgic/vgic.h            |    4 ++++
 4 files changed, 13 insertions(+)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 9c9edc9..7ba9164 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -16,6 +16,9 @@ menuconfig VIRTUALIZATION
 
 if VIRTUALIZATION
 
+config KVM_ARM_VGIC_V3_ITS
+	bool
+
 config KVM_ARM_VGIC_V3
 	bool
 
@@ -35,6 +38,7 @@ config KVM
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
 	select KVM_ARM_VGIC_V3
+	select KVM_ARM_VGIC_V3_ITS
 	select KVM_ARM_PMU if HW_PERF_EVENTS
 	select HAVE_KVM_MSI
 	select HAVE_KVM_IRQCHIP
diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index 1813f93..f3811b3 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -223,9 +223,12 @@ int kvm_register_vgic_device(unsigned long type)
 	case KVM_DEV_TYPE_ARM_VGIC_V3:
 		ret = kvm_register_device_ops(&kvm_arm_vgic_v3_ops,
 					      KVM_DEV_TYPE_ARM_VGIC_V3);
+
+#ifdef CONFIG_KVM_ARM_VGIC_V3_ITS
 		if (ret)
 			break;
 		ret = kvm_vgic_register_its_device();
+#endif
 		break;
 #endif
 	}
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 90d8181..acbe691 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -42,6 +42,7 @@ u64 update_64bit_reg(u64 reg, unsigned int offset, unsigned int len,
 	return reg | ((u64)val << lower);
 }
 
+#ifdef CONFIG_KVM_ARM_VGIC_V3_ITS
 bool vgic_has_its(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
@@ -51,6 +52,7 @@ bool vgic_has_its(struct kvm *kvm)
 
 	return dist->has_its;
 }
+#endif
 
 static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
 					    gpa_t addr, unsigned int len)
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 6c4625c..100045f 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -84,11 +84,15 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu);
 int vgic_v3_probe(const struct gic_kvm_info *info);
 int vgic_v3_map_resources(struct kvm *kvm);
 int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
+
+#ifdef CONFIG_KVM_ARM_VGIC_V3_ITS
 int vgic_register_its_iodevs(struct kvm *kvm);
 bool vgic_has_its(struct kvm *kvm);
 int kvm_vgic_register_its_device(void);
 void vgic_enable_lpis(struct kvm_vcpu *vcpu);
 int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
+#endif
+
 #else
 static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
 {
-- 
1.7.9.5
