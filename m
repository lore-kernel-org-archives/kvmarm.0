From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v5 10/10] KVM: arm/arm64: vgic-its: Implement KVM_DEV_ARM_ITS_CTRL_RESET
Date: Mon, 23 Oct 2017 16:08:29 +0200
Message-ID: <1508767709-15256-11-git-send-email-eric.auger@redhat.com>
References: <1508767709-15256-1-git-send-email-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1508767709-15256-1-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@linaro.org, peter.maydell@linaro.org, andre.przywara@arm.com, wanghaibin.wang@huawei.com
Cc: wu.wubin@huawei.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On reset we clear the valid bits of GITS_CBASER and GITS_BASER<n>.
We also clear command queue registers and free the cache (device,
collection, and lpi lists).

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

---

v2 -> v3:
- added Christoffer's R-b
---
 arch/arm/include/uapi/asm/kvm.h   |  1 +
 arch/arm64/include/uapi/asm/kvm.h |  1 +
 virt/kvm/arm/vgic/vgic-its.c      | 18 ++++++++++++++++++
 3 files changed, 20 insertions(+)

diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index 5db2d4c..7ef0c06 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -215,6 +215,7 @@ struct kvm_arch_memory_slot {
 #define   KVM_DEV_ARM_ITS_SAVE_TABLES		1
 #define   KVM_DEV_ARM_ITS_RESTORE_TABLES	2
 #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
+#define   KVM_DEV_ARM_ITS_CTRL_RESET		4
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 9f3ca24..b5306ce 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -227,6 +227,7 @@ struct kvm_arch_memory_slot {
 #define   KVM_DEV_ARM_ITS_SAVE_TABLES           1
 #define   KVM_DEV_ARM_ITS_RESTORE_TABLES        2
 #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
+#define   KVM_DEV_ARM_ITS_CTRL_RESET		4
 
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index bdfceb4..64b6b04 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -2395,6 +2395,19 @@ static int vgic_its_commit_v0(struct vgic_its *its)
 	return 0;
 }
 
+static void vgic_its_reset(struct kvm *kvm, struct vgic_its *its)
+{
+	/* We need to keep the ABI specific field values */
+	its->baser_coll_table &= ~GITS_BASER_VALID;
+	its->baser_device_table &= ~GITS_BASER_VALID;
+	its->cbaser = 0;
+	its->creadr = 0;
+	its->cwriter = 0;
+	its->enabled = 0;
+	vgic_its_free_device_list(kvm, its);
+	vgic_its_free_collection_list(kvm, its);
+}
+
 static int vgic_its_has_attr(struct kvm_device *dev,
 			     struct kvm_device_attr *attr)
 {
@@ -2409,6 +2422,8 @@ static int vgic_its_has_attr(struct kvm_device *dev,
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
 			return 0;
+		case KVM_DEV_ARM_ITS_CTRL_RESET:
+			return 0;
 		case KVM_DEV_ARM_ITS_SAVE_TABLES:
 			return 0;
 		case KVM_DEV_ARM_ITS_RESTORE_TABLES:
@@ -2453,6 +2468,9 @@ static int vgic_its_set_attr(struct kvm_device *dev,
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
 			/* Nothing to do */
 			return 0;
+		case KVM_DEV_ARM_ITS_CTRL_RESET:
+			vgic_its_reset(dev->kvm, its);
+			return 0;
 		case KVM_DEV_ARM_ITS_SAVE_TABLES:
 			return abi->save_tables(its);
 		case KVM_DEV_ARM_ITS_RESTORE_TABLES:
-- 
2.5.5
