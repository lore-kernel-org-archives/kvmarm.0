From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v4 42/56] KVM: arm/arm64: vgic-new: vgic_kvm_device: implement
 kvm_vgic_addr
Date: Mon, 16 May 2016 10:53:30 +0100
Message-ID: <1463392481-26583-43-git-send-email-andre.przywara@arm.com>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF7EB49B71
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 05:52:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ufpDgUNCgKTt for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2016 05:52:11 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8149049BE5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 05:52:09 -0400 (EDT)
In-Reply-To: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
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

From: Eric Auger <eric.auger@linaro.org>

kvm_vgic_addr is used by the userspace to set the base address of
the following register regions, as seen by the guest:
- distributor(v2 and v3),
- re-distributors (v3),
- CPU interface (v2).

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
Changelog v3 .. v4:
- move overlap check to init time (cannot work with GICv3 here)
- refactor remaining address sanity checks

 include/kvm/vgic/vgic.h             |  2 +
 virt/kvm/arm/vgic/vgic-kvm-device.c | 86 +++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h            |  3 ++
 3 files changed, 91 insertions(+)

diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
index 00e3dca..3689b9b 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -194,6 +194,8 @@ struct vgic_cpu {
 	u64 live_lrs;
 };
 
+int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
+
 int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 			bool level);
 
diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index e153f12..082829a 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -16,10 +16,96 @@
 #include <linux/kvm_host.h>
 #include <kvm/arm_vgic.h>
 #include <linux/uaccess.h>
+#include <asm/kvm_mmu.h>
 #include "vgic.h"
 
 /* common helpers */
 
+static int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
+			     phys_addr_t addr, phys_addr_t alignment)
+{
+	if (addr & ~KVM_PHYS_MASK)
+		return -E2BIG;
+
+	if (!IS_ALIGNED(addr, alignment))
+		return -EINVAL;
+
+	if (!IS_VGIC_ADDR_UNDEF(*ioaddr))
+		return -EEXIST;
+
+	return 0;
+}
+
+/**
+ * kvm_vgic_addr - set or get vgic VM base addresses
+ * @kvm:   pointer to the vm struct
+ * @type:  the VGIC addr type, one of KVM_VGIC_V[23]_ADDR_TYPE_XXX
+ * @addr:  pointer to address value
+ * @write: if true set the address in the VM address space, if false read the
+ *          address
+ *
+ * Set or get the vgic base addresses for the distributor and the virtual CPU
+ * interface in the VM physical address space.  These addresses are properties
+ * of the emulated core/SoC and therefore user space initially knows this
+ * information.
+ * Check them for sanity (alignment, double assignment). We can't check for
+ * overlapping regions in case of a virtual GICv3 here, since we don't know
+ * the number of VCPUs yet, so we defer this check to map_resources().
+ */
+int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
+{
+	int r = 0;
+	struct vgic_dist *vgic = &kvm->arch.vgic;
+	int type_needed;
+	phys_addr_t *addr_ptr, alignment;
+
+	mutex_lock(&kvm->lock);
+	switch (type) {
+	case KVM_VGIC_V2_ADDR_TYPE_DIST:
+		type_needed = KVM_DEV_TYPE_ARM_VGIC_V2;
+		addr_ptr = &vgic->vgic_dist_base;
+		alignment = SZ_4K;
+		break;
+	case KVM_VGIC_V2_ADDR_TYPE_CPU:
+		type_needed = KVM_DEV_TYPE_ARM_VGIC_V2;
+		addr_ptr = &vgic->vgic_cpu_base;
+		alignment = SZ_4K;
+		break;
+#ifdef CONFIG_KVM_ARM_VGIC_V3
+	case KVM_VGIC_V3_ADDR_TYPE_DIST:
+		type_needed = KVM_DEV_TYPE_ARM_VGIC_V3;
+		addr_ptr = &vgic->vgic_dist_base;
+		alignment = SZ_64K;
+		break;
+	case KVM_VGIC_V3_ADDR_TYPE_REDIST:
+		type_needed = KVM_DEV_TYPE_ARM_VGIC_V3;
+		addr_ptr = &vgic->vgic_redist_base;
+		alignment = SZ_64K;
+		break;
+#endif
+	default:
+		r = -ENODEV;
+		goto out;
+	}
+
+	if (vgic->vgic_model != type_needed) {
+		r = -ENODEV;
+		goto out;
+	}
+
+	if (write) {
+		r = vgic_check_ioaddr(kvm, addr_ptr, *addr, alignment);
+		if (!r)
+			*addr_ptr = *addr;
+	} else {
+		*addr = *addr_ptr;
+	}
+
+out:
+	mutex_unlock(&kvm->lock);
+	return r;
+}
+
 static int vgic_set_common_attr(struct kvm_device *dev,
 				struct kvm_device_attr *attr)
 {
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 77b0ab3..6abc9a3 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -19,6 +19,9 @@
 #define PRODUCT_ID_KVM		0x4b	/* ASCII code K */
 #define IMPLEMENTER_ARM		0x43b
 
+#define VGIC_ADDR_UNDEF		(-1)
+#define IS_VGIC_ADDR_UNDEF(_x)  ((_x) == VGIC_ADDR_UNDEF)
+
 #define INTERRUPT_ID_BITS_SPIS	10
 #define VGIC_PRI_BITS		5
 
-- 
2.8.2
