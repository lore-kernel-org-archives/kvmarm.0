From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 40/50] KVM: arm64: vgic-its: Introduce config option to guard
 ITS specific code
Date: Tue, 27 Sep 2016 20:05:48 +0200
Message-ID: <20160927180558.14699-41-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3242B49BD4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:57:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Tcvs+xVhjQf7 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:57:05 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CF50B49BAF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:57:02 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id b130so27080828wmc.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:06:26 -0700 (PDT)
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

By now ITS code guarded with KVM_ARM_VGIC_V3 config option which was
introduced to hide everything specific to vgic-v3 from 32-bit world.
We are going to support vgic-v3 in 32-bit world and KVM_ARM_VGIC_V3
will gone, but we don't have support for ITS there yet and we need to
continue keeping ITS away.
Introduce the new config option to prevent ITS code being build in
32-bit mode when support for vgic-v3 is done.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/Kconfig              | 4 ++++
 virt/kvm/arm/vgic/vgic-kvm-device.c | 3 +++
 virt/kvm/arm/vgic/vgic-mmio-v3.c    | 2 ++
 virt/kvm/arm/vgic/vgic.h            | 4 ++++
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
index 163b057..89ef9bc 100644
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
2.9.0
