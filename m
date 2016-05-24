From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 41/59] KVM: arm/arm64: vgic-new: vgic_kvm_device: KVM device ops registration
Date: Tue, 24 May 2016 11:09:35 +0200
Message-ID: <1464080993-10884-42-git-send-email-christoffer.dall@linaro.org>
References: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@linaro.org>

This patch introduces the skeleton for the KVM device operations
associated to KVM_DEV_TYPE_ARM_VGIC_V2 and KVM_DEV_TYPE_ARM_VGIC_V3.

At that stage kvm_vgic_create is stubbed.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
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
2.1.2.330.g565301e.dirty

