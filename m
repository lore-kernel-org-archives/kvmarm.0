From: Steven Price <steven.price@arm.com>
Subject: [RFC PATCH v2 12/12] KVM: arm64: Export LPT using PV_TIME device
Date: Wed, 12 Dec 2018 15:02:26 +0000
Message-ID: <20181212150226.38051-13-steven.price@arm.com>
References: <20181212150226.38051-1-steven.price@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 184634A384
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Dec 2018 10:03:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i0fpO73VYD2X for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Dec 2018 10:03:22 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77FE64A38D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Dec 2018 10:03:20 -0500 (EST)
In-Reply-To: <20181212150226.38051-1-steven.price@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Price <steven.price@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Extend the PV_TIME device to allow setting up Live Physical Time and
saving/restoring the state necessary for migration.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/uapi/asm/kvm.h |  2 ++
 virt/kvm/arm/pvtime.c             | 55 +++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index e1d42ff35430..d3b0d70cdd9f 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -310,8 +310,10 @@ struct kvm_vcpu_events {
 /* Device Control API: PV_TIME */
 #define KVM_DEV_ARM_PV_TIME_PADDR	0
 #define  KVM_DEV_ARM_PV_TIME_ST		0
+#define  KVM_DEV_ARM_PV_TIME_LPT	1
 #define KVM_DEV_ARM_PV_TIME_STATE_SIZE	1
 #define KVM_DEV_ARM_PV_TIME_STATE	2
+#define KVM_DEV_ARM_PV_TIME_FREQUENCY	3
 
 #endif
 
diff --git a/virt/kvm/arm/pvtime.c b/virt/kvm/arm/pvtime.c
index e033f55e3ee4..345798aebebf 100644
--- a/virt/kvm/arm/pvtime.c
+++ b/virt/kvm/arm/pvtime.c
@@ -25,6 +25,14 @@ static int kvm_arm_pvtime_create(struct kvm_device *dev, u32 type)
 	if (!pvtime->st)
 		return -ENOMEM;
 
+	pvtime->lpt = (void *)get_zeroed_page(GFP_KERNEL);
+	if (!pvtime->lpt) {
+		free_pages_exact(pvtime->st, max_stolen_size());
+		return -ENOMEM;
+	}
+
+	pvtime->lpt_fpv = arch_timer_get_rate();
+
 	return 0;
 }
 
@@ -32,8 +40,10 @@ static void kvm_arm_pvtime_destroy(struct kvm_device *dev)
 {
 	struct kvm_arch_pvtime *pvtime = &dev->kvm->arch.pvtime;
 
+	pvtime->lpt_base = GPA_INVALID;
 	pvtime->st_base = GPA_INVALID;
 	free_pages_exact(pvtime->st, max_stolen_size());
+	free_page((unsigned long)pvtime->lpt);
 }
 
 static int pvtime_map_pages(struct kvm *kvm, gpa_t guest_paddr,
@@ -50,6 +60,10 @@ static int pvtime_save_state(struct kvm *kvm, u64 type, void __user *user)
 	size_t size;
 
 	switch (type) {
+	case KVM_DEV_ARM_PV_TIME_LPT:
+		source = kvm->arch.pvtime.lpt;
+		size = sizeof(struct pvclock_vm_time_info);
+		break;
 	case KVM_DEV_ARM_PV_TIME_ST:
 		source = kvm->arch.pvtime.st;
 		size = sizeof(struct pvclock_vcpu_stolen_time_info) *
@@ -70,6 +84,10 @@ static int pvtime_restore_state(struct kvm *kvm, u64 type, void __user *user)
 	size_t size;
 
 	switch (type) {
+	case KVM_DEV_ARM_PV_TIME_LPT:
+		dest = kvm->arch.pvtime.lpt;
+		size = sizeof(struct pvclock_vm_time_info);
+		break;
 	case KVM_DEV_ARM_PV_TIME_ST:
 		dest = kvm->arch.pvtime.st;
 		size = sizeof(struct pvclock_vcpu_stolen_time_info) *
@@ -91,6 +109,7 @@ static int kvm_arm_pvtime_set_attr(struct kvm_device *dev,
 	struct kvm_arch_pvtime *pvtime = &dev->kvm->arch.pvtime;
 	u64 __user *user = (u64 __user *)attr->addr;
 	u64 paddr;
+	u32 frequency;
 	int ret;
 
 	switch (attr->group) {
@@ -100,6 +119,15 @@ static int kvm_arm_pvtime_set_attr(struct kvm_device *dev,
 		if (paddr & 63)
 			return -EINVAL;
 		switch (attr->attr) {
+		case KVM_DEV_ARM_PV_TIME_LPT:
+			if (pvtime->lpt_base != GPA_INVALID)
+				return -EEXIST;
+			ret = pvtime_map_pages(dev->kvm, paddr, pvtime->lpt,
+					PAGE_SIZE);
+			if (ret)
+				return ret;
+			pvtime->lpt_base = paddr;
+			return kvm_arm_update_lpt_sequence(dev->kvm);
 		case KVM_DEV_ARM_PV_TIME_ST:
 			if (pvtime->st_base != GPA_INVALID)
 				return -EEXIST;
@@ -111,6 +139,13 @@ static int kvm_arm_pvtime_set_attr(struct kvm_device *dev,
 			return 0;
 		}
 		break;
+	case KVM_DEV_ARM_PV_TIME_FREQUENCY:
+		if (attr->attr != KVM_DEV_ARM_PV_TIME_LPT)
+			break;
+		if (get_user(frequency, user))
+			return -EFAULT;
+		pvtime->lpt_fpv = frequency;
+		return kvm_arm_update_lpt_sequence(dev->kvm);
 	case KVM_DEV_ARM_PV_TIME_STATE_SIZE:
 		return -EPERM;
 	case KVM_DEV_ARM_PV_TIME_STATE:
@@ -128,14 +163,27 @@ static int kvm_arm_pvtime_get_attr(struct kvm_device *dev,
 	switch (attr->group) {
 	case KVM_DEV_ARM_PV_TIME_PADDR:
 		switch (attr->attr) {
+		case KVM_DEV_ARM_PV_TIME_LPT:
+			if (put_user(dev->kvm->arch.pvtime.lpt_base, user))
+				return -EFAULT;
+			return 0;
 		case KVM_DEV_ARM_PV_TIME_ST:
 			if (put_user(dev->kvm->arch.pvtime.st_base, user))
 				return -EFAULT;
 			return 0;
 		}
 		break;
+	case KVM_DEV_ARM_PV_TIME_FREQUENCY:
+		if (attr->attr != KVM_DEV_ARM_PV_TIME_LPT)
+			break;
+		if (put_user(dev->kvm->arch.pvtime.lpt_fpv, user))
+			return -EFAULT;
+		return 0;
 	case KVM_DEV_ARM_PV_TIME_STATE_SIZE:
 		switch (attr->attr) {
+		case KVM_DEV_ARM_PV_TIME_LPT:
+			size = sizeof(struct pvclock_vm_time_info);
+			break;
 		case KVM_DEV_ARM_PV_TIME_ST:
 			size = sizeof(struct pvclock_vcpu_stolen_time_info);
 			size *= atomic_read(&dev->kvm->online_vcpus);
@@ -160,10 +208,17 @@ static int kvm_arm_pvtime_has_attr(struct kvm_device *dev,
 	case KVM_DEV_ARM_PV_TIME_STATE_SIZE:
 	case KVM_DEV_ARM_PV_TIME_STATE:
 		switch (attr->attr) {
+		case KVM_DEV_ARM_PV_TIME_LPT:
 		case KVM_DEV_ARM_PV_TIME_ST:
 			return 0;
 		}
 		break;
+	case KVM_DEV_ARM_PV_TIME_FREQUENCY:
+		switch (attr->attr) {
+		case KVM_DEV_ARM_PV_TIME_LPT:
+			return 0;
+		}
+		break;
 	}
 	return -ENXIO;
 }
-- 
2.19.2
