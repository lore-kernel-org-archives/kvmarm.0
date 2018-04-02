From: Peng Hao <peng.hao2@zte.com.cn>
Subject: [PATCH] kvm : arm/arm64 : fix some warningg
Date: Mon, 2 Apr 2018 08:00:36 +0800
Message-ID: <1522627236-3465-1-git-send-email-peng.hao2@zte.com.cn>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: cdall@kernel.org, marc.zyngier@arm.com
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Peng Hao <peng.hao2@zte.com.cn>
List-Id: kvmarm@lists.cs.columbia.edu

fix some "warning: no previous prototype".

Signed-off-by: Peng Hao <peng.hao2@zte.com.cn>
---
 virt/kvm/arm/vgic/vgic-its.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 4650953..881494b 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -177,12 +177,12 @@ struct vgic_its_abi {
 
 #define NR_ITS_ABIS	ARRAY_SIZE(its_table_abi_versions)
 
-inline const struct vgic_its_abi *vgic_its_get_abi(struct vgic_its *its)
+static inline const struct vgic_its_abi *vgic_its_get_abi(struct vgic_its *its)
 {
 	return &its_table_abi_versions[its->abi_rev];
 }
 
-int vgic_its_set_abi(struct vgic_its *its, int rev)
+static int vgic_its_set_abi(struct vgic_its *its, int rev)
 {
 	const struct vgic_its_abi *abi;
 
@@ -1731,7 +1731,7 @@ static void vgic_its_destroy(struct kvm_device *kvm_dev)
 	kfree(its);
 }
 
-int vgic_its_has_attr_regs(struct kvm_device *dev,
+static int vgic_its_has_attr_regs(struct kvm_device *dev,
 			   struct kvm_device_attr *attr)
 {
 	const struct vgic_register_region *region;
@@ -1752,7 +1752,7 @@ int vgic_its_has_attr_regs(struct kvm_device *dev,
 	return 0;
 }
 
-int vgic_its_attr_regs_access(struct kvm_device *dev,
+static int vgic_its_attr_regs_access(struct kvm_device *dev,
 			      struct kvm_device_attr *attr,
 			      u64 *reg, bool is_write)
 {
-- 
1.8.3.1
