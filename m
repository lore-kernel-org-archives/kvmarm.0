From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 47/59] KVM: arm/arm64: vgic-new: Export register access interface
Date: Tue, 24 May 2016 11:09:41 +0200
Message-ID: <1464080993-10884-48-git-send-email-christoffer.dall@linaro.org>
References: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Userland can access the emulated GIC to save and restore its state
for initialization or migration purposes.
The kvm_io_bus API requires an absolute gpa, which does not fit the
KVM_DEV_ARM_VGIC_GRP_DIST_REGS user API, that only provides relative
offsets. So we provide a wrapper to plug into our MMIO framework and
find the respective register handler.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/arm/vgic/vgic-mmio-v2.c | 36 ++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h         |  2 ++
 2 files changed, 38 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index 7189690..a255122 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -296,3 +296,39 @@ int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
 
 	return -ENXIO;
 }
+
+/*
+ * When userland tries to access the VGIC register handlers, we need to
+ * create a usable struct vgic_io_device to be passed to the handlers and we
+ * have to set up a buffer similar to what would have happened if a guest MMIO
+ * access occurred, including doing endian conversions on BE systems.
+ */
+static int vgic_uaccess(struct kvm_vcpu *vcpu, struct vgic_io_device *dev,
+			bool is_write, int offset, u32 *val)
+{
+	unsigned int len = 4;
+	u8 buf[4];
+	int ret;
+
+	if (is_write) {
+		vgic_data_host_to_mmio_bus(buf, len, *val);
+		ret = kvm_io_gic_ops.write(vcpu, &dev->dev, offset, len, buf);
+	} else {
+		ret = kvm_io_gic_ops.read(vcpu, &dev->dev, offset, len, buf);
+		if (!ret)
+			*val = vgic_data_mmio_bus_to_host(buf, len);
+	}
+
+	return ret;
+}
+
+int vgic_v2_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
+			 int offset, u32 *val)
+{
+	struct vgic_io_device dev = {
+		.regions = vgic_v2_dist_registers,
+		.nr_regions = ARRAY_SIZE(vgic_v2_dist_registers),
+	};
+
+	return vgic_uaccess(vcpu, &dev, is_write, offset, val);
+}
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index a264c5f..f826026 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -38,6 +38,8 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
 void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr);
 void vgic_v2_set_underflow(struct kvm_vcpu *vcpu);
 int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr);
+int vgic_v2_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
+			 int offset, u32 *val);
 int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
 			     enum vgic_type);
 
-- 
2.1.2.330.g565301e.dirty

