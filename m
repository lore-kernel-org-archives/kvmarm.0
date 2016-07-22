From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 42/55] KVM: arm64: vgic-its: Enable ITS emulation as a virtual
 MSI controller
Date: Fri, 22 Jul 2016 18:28:59 +0100
Message-ID: <1469208552-4155-43-git-send-email-marc.zyngier@arm.com>
References: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0732349B79
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:24:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Mcb2s2bIBcEX for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2016 13:24:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDC4649BF3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:24:53 -0400 (EDT)
In-Reply-To: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
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
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

Now that all ITS emulation functionality is in place, we advertise
MSI functionality to userland and also the ITS device to the guest - if
userland has configured that.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Tested-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 Documentation/virtual/kvm/api.txt   |  2 +-
 arch/arm64/kvm/Kconfig              |  1 +
 arch/arm64/kvm/Makefile             |  1 +
 arch/arm64/kvm/reset.c              |  6 ++++++
 include/kvm/arm_vgic.h              |  5 +++++
 virt/kvm/arm/vgic/vgic-init.c       |  3 +++
 virt/kvm/arm/vgic/vgic-kvm-device.c |  3 +++
 virt/kvm/arm/vgic/vgic-mmio-v3.c    | 14 ++++++++++----
 virt/kvm/arm/vgic/vgic.c            |  8 ++++++++
 virt/kvm/arm/vgic/vgic.h            |  6 ++++++
 10 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 6551311..07049ea 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2162,7 +2162,7 @@ after pausing the vcpu, but before it is resumed.
 4.71 KVM_SIGNAL_MSI
 
 Capability: KVM_CAP_SIGNAL_MSI
-Architectures: x86
+Architectures: x86 arm64
 Type: vm ioctl
 Parameters: struct kvm_msi (in)
 Returns: >0 on delivery, 0 if guest blocked the MSI, and -1 on error
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index aa2e34e..9d2eff0 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -36,6 +36,7 @@ config KVM
 	select HAVE_KVM_IRQFD
 	select KVM_ARM_VGIC_V3
 	select KVM_ARM_PMU if HW_PERF_EVENTS
+	select HAVE_KVM_MSI
 	---help---
 	  Support hosting virtualized guest machines.
 	  We don't support KVM with 16K page tables yet, due to the multiple
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index f00b2cd..a5b9664 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -29,5 +29,6 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v2.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v3.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-kvm-device.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-its.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
 kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index e95d4f6..5bc4608 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -86,6 +86,12 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VCPU_ATTRIBUTES:
 		r = 1;
 		break;
+	case KVM_CAP_MSI_DEVID:
+		if (!kvm)
+			r = -EINVAL;
+		else
+			r = kvm->arch.vgic.msis_require_devid;
+		break;
 	default:
 		r = 0;
 	}
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index a6ca326..4e63a07 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -163,6 +163,9 @@ struct vgic_dist {
 	/* vGIC model the kernel emulates for the guest (GICv2 or GICv3) */
 	u32			vgic_model;
 
+	/* Do injected MSIs require an additional device ID? */
+	bool			msis_require_devid;
+
 	int			nr_spis;
 
 	/* TODO: Consider moving to global state */
@@ -308,4 +311,6 @@ static inline int kvm_vgic_get_max_vcpus(void)
 	return kvm_vgic_global_state.max_gic_vcpus;
 }
 
+int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi);
+
 #endif /* __KVM_ARM_VGIC_H */
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 535e713..01a60dc 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -258,6 +258,9 @@ int vgic_init(struct kvm *kvm)
 	if (ret)
 		goto out;
 
+	if (vgic_has_its(kvm))
+		dist->msis_require_devid = true;
+
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_vgic_vcpu_init(vcpu);
 
diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index 561d2ba..1813f93 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -223,6 +223,9 @@ int kvm_register_vgic_device(unsigned long type)
 	case KVM_DEV_TYPE_ARM_VGIC_V3:
 		ret = kvm_register_device_ops(&kvm_arm_vgic_v3_ops,
 					      KVM_DEV_TYPE_ARM_VGIC_V3);
+		if (ret)
+			break;
+		ret = kvm_vgic_register_its_device();
 		break;
 #endif
 	}
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 84a301d..ff668e0 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -66,7 +66,12 @@ static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
 	case GICD_TYPER:
 		value = vcpu->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
 		value = (value >> 5) - 1;
-		value |= (INTERRUPT_ID_BITS_SPIS - 1) << 19;
+		if (vgic_has_its(vcpu->kvm)) {
+			value |= (INTERRUPT_ID_BITS_ITS - 1) << 19;
+			value |= GICD_TYPER_LPIS;
+		} else {
+			value |= (INTERRUPT_ID_BITS_SPIS - 1) << 19;
+		}
 		break;
 	case GICD_IIDR:
 		value = (PRODUCT_ID_KVM << 24) | (IMPLEMENTER_ARM << 0);
@@ -163,9 +168,8 @@ static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
 
 	vgic_cpu->lpis_enabled = val & GICR_CTLR_ENABLE_LPIS;
 
-	if (!was_enabled && vgic_cpu->lpis_enabled) {
-		/* Eventually do something */
-	}
+	if (!was_enabled && vgic_cpu->lpis_enabled)
+		vgic_enable_lpis(vcpu);
 }
 
 static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
@@ -179,6 +183,8 @@ static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
 	value |= ((target_vcpu_id & 0xffff) << 8);
 	if (target_vcpu_id == atomic_read(&vcpu->kvm->online_vcpus) - 1)
 		value |= GICR_TYPER_LAST;
+	if (vgic_has_its(vcpu->kvm))
+		value |= GICR_TYPER_PLPIS;
 
 	return extract_bytes(value, addr & 7, len);
 }
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 53299fc..424cb9c 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -718,3 +718,11 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq)
 
 	return map_is_active;
 }
+
+int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi)
+{
+	if (vgic_has_its(kvm))
+		return vgic_its_inject_msi(kvm, msi);
+	else
+		return -ENODEV;
+}
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 9d557f2..9d40d7b 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -77,6 +77,7 @@ int vgic_v3_probe(const struct gic_kvm_info *info);
 int vgic_v3_map_resources(struct kvm *kvm);
 int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
 bool vgic_has_its(struct kvm *kvm);
+int kvm_vgic_register_its_device(void);
 void vgic_enable_lpis(struct kvm_vcpu *vcpu);
 int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
 #else
@@ -136,6 +137,11 @@ static inline bool vgic_has_its(struct kvm *kvm)
 	return false;
 }
 
+static inline int kvm_vgic_register_its_device(void)
+{
+	return -ENODEV;
+}
+
 static inline void vgic_enable_lpis(struct kvm_vcpu *vcpu)
 {
 }
-- 
2.8.1
