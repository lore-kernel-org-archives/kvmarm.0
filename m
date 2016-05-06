From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 44/55] KVM: arm/arm64: vgic-new: Export register access
 interface
Date: Fri,  6 May 2016 11:45:57 +0100
Message-ID: <1462531568-9799-45-git-send-email-andre.przywara@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2407849B36
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2016 06:44:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n6Wo9SQCuAeR for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 May 2016 06:44:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AED349BA2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2016 06:44:06 -0400 (EDT)
In-Reply-To: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Userland can access the emulated GIC to save and restore its state
for initialization or migration purposes.
The kvm_io_bus API requires an absolute gpa, which does not fit the
KVM_DEV_ARM_VGIC_GRP_DIST_REGS user API, that only provides relative
offsets. So we provide a wrapper to plug into our MMIO framework and
find the respective register handler.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Changelog v1 .. v2:
- adapt to new MMIO framework
- handle endianess explicitly

Changelog v2 .. v3:
- wrap accessor function for easier reusage later
- moved from earlier in the series

 virt/kvm/arm/vgic/vgic-mmio-v2.c | 36 ++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h         |  2 ++
 2 files changed, 38 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index cf8fee9..c453e6f 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -280,3 +280,39 @@ int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
 
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
index a4397f9..bc5750e 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -37,6 +37,8 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
 void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr);
 void vgic_v2_set_underflow(struct kvm_vcpu *vcpu);
 int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr);
+int vgic_v2_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
+			 int offset, u32 *val);
 int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
 			     enum vgic_type);
 
-- 
2.7.3
