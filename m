From: Peng Hao <peng.hao2@zte.com.cn>
Subject: [PATCH]  kvm/arm : remove unnecessary local variable
Date: Tue, 25 Dec 2018 12:56:15 +0800
Message-ID: <1545713775-69870-1-git-send-email-peng.hao2@zte.com.cn>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: christoffer.dall@arm.com, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, Peng Hao <peng.hao2@zte.com.cn>
List-Id: kvmarm@lists.cs.columbia.edu

Remove unnecessary local variable in vgic_set_common_attr

Signed-off-by: Peng Hao <peng.hao2@zte.com.cn>
---
 virt/kvm/arm/vgic/vgic-kvm-device.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index 114dce9..53e5df7 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -163,7 +163,7 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
 static int vgic_set_common_attr(struct kvm_device *dev,
 				struct kvm_device_attr *attr)
 {
-	int r;
+	int r = 0;
 
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR: {
@@ -180,7 +180,6 @@ static int vgic_set_common_attr(struct kvm_device *dev,
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS: {
 		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
 		u32 val;
-		int ret = 0;
 
 		if (get_user(val, uaddr))
 			return -EFAULT;
@@ -199,14 +198,14 @@ static int vgic_set_common_attr(struct kvm_device *dev,
 		mutex_lock(&dev->kvm->lock);
 
 		if (vgic_ready(dev->kvm) || dev->kvm->arch.vgic.nr_spis)
-			ret = -EBUSY;
+			r = -EBUSY;
 		else
 			dev->kvm->arch.vgic.nr_spis =
 				val - VGIC_NR_PRIVATE_IRQS;
 
 		mutex_unlock(&dev->kvm->lock);
 
-		return ret;
+		return r;
 	}
 	case KVM_DEV_ARM_VGIC_GRP_CTRL: {
 		switch (attr->attr) {
-- 
1.8.3.1
