From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v5 40/57] KVM: arm/arm64: vgic-new: vgic_kvm_device: KVM device ops registration
Date: Thu, 19 May 2016 19:08:19 +0100
Message-ID: <1463681316-23039-41-git-send-email-andre.przywara@arm.com>
References: <1463681316-23039-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1463681316-23039-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@linaro.org>

This patch introduces the skeleton for the KVM device operations
associated to KVM_DEV_TYPE_ARM_VGIC_V2 and KVM_DEV_TYPE_ARM_VGIC_V3.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
Changelog v1 .. v2:
- rename vgic_kvm_device.c to vgic-kvm-device.c

Changelog v2 .. v3:
- replace inclusion of vgic/vgic.h with arm_vgic.h
- add kvm_register_vgic_device() prototype to this patch

 virt/kvm/arm/vgic/vgic-kvm-device.c | 108 ++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h            |   2 +
 2 files changed, 110 insertions(+)
 create mode 100644 virt/kvm/arm/vgic/vgic-kvm-device.c

diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
new file mode 100644
index 0000000..ff332f3
--- /dev/null
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -0,0 +1,108 @@
+/*
+ * VGIC: KVM DEVICE API
+ *
+ * Copyright (C) 2015 ARM Ltd.
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#include <linux/kvm_host.h>
+#include <kvm/arm_vgic.h>
+
+/* common helpers */
+
+static int vgic_create(struct kvm_device *dev, u32 type)
+{
+	return kvm_vgic_create(dev->kvm, type);
+}
+
+static void vgic_destroy(struct kvm_device *dev)
+{
+	kfree(dev);
+}
+
+void kvm_register_vgic_device(unsigned long type)
+{
+	switch (type) {
+	case KVM_DEV_TYPE_ARM_VGIC_V2:
+		kvm_register_device_ops(&kvm_arm_vgic_v2_ops,
+					KVM_DEV_TYPE_ARM_VGIC_V2);
+		break;
+#ifdef CONFIG_KVM_ARM_VGIC_V3
+	case KVM_DEV_TYPE_ARM_VGIC_V3:
+		kvm_register_device_ops(&kvm_arm_vgic_v3_ops,
+					KVM_DEV_TYPE_ARM_VGIC_V3);
+		break;
+#endif
+	}
+}
+
+/* V2 ops */
+
+static int vgic_v2_set_attr(struct kvm_device *dev,
+			    struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
+
+static int vgic_v2_get_attr(struct kvm_device *dev,
+			    struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
+
+static int vgic_v2_has_attr(struct kvm_device *dev,
+			    struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
+
+struct kvm_device_ops kvm_arm_vgic_v2_ops = {
+	.name = "kvm-arm-vgic-v2",
+	.create = vgic_create,
+	.destroy = vgic_destroy,
+	.set_attr = vgic_v2_set_attr,
+	.get_attr = vgic_v2_get_attr,
+	.has_attr = vgic_v2_has_attr,
+};
+
+/* V3 ops */
+
+#ifdef CONFIG_KVM_ARM_VGIC_V3
+
+static int vgic_v3_set_attr(struct kvm_device *dev,
+			    struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
+
+static int vgic_v3_get_attr(struct kvm_device *dev,
+			    struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
+
+static int vgic_v3_has_attr(struct kvm_device *dev,
+			    struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
+
+struct kvm_device_ops kvm_arm_vgic_v3_ops = {
+	.name = "kvm-arm-vgic-v3",
+	.create = vgic_create,
+	.destroy = vgic_destroy,
+	.set_attr = vgic_v3_set_attr,
+	.get_attr = vgic_v3_get_attr,
+	.has_attr = vgic_v3_has_attr,
+};
+
+#endif /* CONFIG_KVM_ARM_VGIC_V3 */
+
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 44c6a1b..77b0ab3 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -73,4 +73,6 @@ static inline int vgic_register_redist_iodevs(struct kvm *kvm,
 }
 #endif
 
+void kvm_register_vgic_device(unsigned long type);
+
 #endif
-- 
2.8.2

