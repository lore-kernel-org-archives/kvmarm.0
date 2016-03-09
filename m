From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 76/95] arm64: KVM: Introduce per-vcpu kvm device controls
Date: Wed,  9 Mar 2016 07:31:10 +0000
Message-ID: <1457508689-19672-77-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFABA41145
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:35:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aJuVbq8ErzYX for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:35:22 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4324C49B9E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:35:22 -0500 (EST)
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

In some cases it needs to get/set attributes specific to a vcpu and so
needs something else than ONE_REG.

Let's copy the KVM_DEVICE approach, and define the respective ioctls
for the vcpu file descriptor.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Acked-by: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 Documentation/virtual/kvm/api.txt          | 10 +++---
 Documentation/virtual/kvm/devices/vcpu.txt |  8 +++++
 arch/arm/kvm/arm.c                         | 55 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/reset.c                     |  1 +
 include/uapi/linux/kvm.h                   |  1 +
 5 files changed, 71 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/virtual/kvm/devices/vcpu.txt

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 9684f8d..cb2ef0b 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2507,8 +2507,9 @@ struct kvm_create_device {
 
 4.80 KVM_SET_DEVICE_ATTR/KVM_GET_DEVICE_ATTR
 
-Capability: KVM_CAP_DEVICE_CTRL, KVM_CAP_VM_ATTRIBUTES for vm device
-Type: device ioctl, vm ioctl
+Capability: KVM_CAP_DEVICE_CTRL, KVM_CAP_VM_ATTRIBUTES for vm device,
+  KVM_CAP_VCPU_ATTRIBUTES for vcpu device
+Type: device ioctl, vm ioctl, vcpu ioctl
 Parameters: struct kvm_device_attr
 Returns: 0 on success, -1 on error
 Errors:
@@ -2533,8 +2534,9 @@ struct kvm_device_attr {
 
 4.81 KVM_HAS_DEVICE_ATTR
 
-Capability: KVM_CAP_DEVICE_CTRL, KVM_CAP_VM_ATTRIBUTES for vm device
-Type: device ioctl, vm ioctl
+Capability: KVM_CAP_DEVICE_CTRL, KVM_CAP_VM_ATTRIBUTES for vm device,
+  KVM_CAP_VCPU_ATTRIBUTES for vcpu device
+Type: device ioctl, vm ioctl, vcpu ioctl
 Parameters: struct kvm_device_attr
 Returns: 0 on success, -1 on error
 Errors:
diff --git a/Documentation/virtual/kvm/devices/vcpu.txt b/Documentation/virtual/kvm/devices/vcpu.txt
new file mode 100644
index 0000000..3cc59c5
--- /dev/null
+++ b/Documentation/virtual/kvm/devices/vcpu.txt
@@ -0,0 +1,8 @@
+Generic vcpu interface
+====================================
+
+The virtual cpu "device" also accepts the ioctls KVM_SET_DEVICE_ATTR,
+KVM_GET_DEVICE_ATTR, and KVM_HAS_DEVICE_ATTR. The interface uses the same struct
+kvm_device_attr as other devices, but targets VCPU-wide settings and controls.
+
+The groups and attributes per virtual cpu, if any, are architecture specific.
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 9d133df..1662323 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -828,11 +828,51 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int kvm_arm_vcpu_set_attr(struct kvm_vcpu *vcpu,
+				 struct kvm_device_attr *attr)
+{
+	int ret = -ENXIO;
+
+	switch (attr->group) {
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+static int kvm_arm_vcpu_get_attr(struct kvm_vcpu *vcpu,
+				 struct kvm_device_attr *attr)
+{
+	int ret = -ENXIO;
+
+	switch (attr->group) {
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+static int kvm_arm_vcpu_has_attr(struct kvm_vcpu *vcpu,
+				 struct kvm_device_attr *attr)
+{
+	int ret = -ENXIO;
+
+	switch (attr->group) {
+	default:
+		break;
+	}
+
+	return ret;
+}
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
 	struct kvm_vcpu *vcpu = filp->private_data;
 	void __user *argp = (void __user *)arg;
+	struct kvm_device_attr attr;
 
 	switch (ioctl) {
 	case KVM_ARM_VCPU_INIT: {
@@ -875,6 +915,21 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 			return -E2BIG;
 		return kvm_arm_copy_reg_indices(vcpu, user_list->reg);
 	}
+	case KVM_SET_DEVICE_ATTR: {
+		if (copy_from_user(&attr, argp, sizeof(attr)))
+			return -EFAULT;
+		return kvm_arm_vcpu_set_attr(vcpu, &attr);
+	}
+	case KVM_GET_DEVICE_ATTR: {
+		if (copy_from_user(&attr, argp, sizeof(attr)))
+			return -EFAULT;
+		return kvm_arm_vcpu_get_attr(vcpu, &attr);
+	}
+	case KVM_HAS_DEVICE_ATTR: {
+		if (copy_from_user(&attr, argp, sizeof(attr)))
+			return -EFAULT;
+		return kvm_arm_vcpu_has_attr(vcpu, &attr);
+	}
 	default:
 		return -EINVAL;
 	}
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index cf4f28a..9677bf0 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -81,6 +81,7 @@ int kvm_arch_dev_ioctl_check_extension(long ext)
 		r = kvm_arm_support_pmu_v3();
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG:
+	case KVM_CAP_VCPU_ATTRIBUTES:
 		r = 1;
 		break;
 	default:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index dc16d30..50f44a2 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -851,6 +851,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_HYPERV_SYNIC 123
 #define KVM_CAP_S390_RI 124
 #define KVM_CAP_ARM_PMU_V3 125
+#define KVM_CAP_VCPU_ATTRIBUTES 126
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.1.4
