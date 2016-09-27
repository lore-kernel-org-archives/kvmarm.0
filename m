From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 02/50] KVM: arm/arm64: Factor out vgic_attr_regs_access
 functionality
Date: Tue, 27 Sep 2016 20:05:10 +0200
Message-ID: <20160927180558.14699-3-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C480F499A1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eY+y0u3Nwisy for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:56:25 -0400 (EDT)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BF8C248531
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:25 -0400 (EDT)
Received: by mail-wm0-f42.google.com with SMTP id l132so190626874wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:05:49 -0700 (PDT)
In-Reply-To: <20160927180558.14699-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

As we are about to deal with multiple data types and situations where
the vgic should not be initialized when doing userspace accesses on the
register attributes, factor out the functionality of
vgic_attr_regs_access into smaller bits which can be reused by a new
function later.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 virt/kvm/arm/vgic/vgic-kvm-device.c | 100 ++++++++++++++++++++++++++----------
 1 file changed, 73 insertions(+), 27 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index 1813f93..19fa331 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -233,6 +233,67 @@ int kvm_register_vgic_device(unsigned long type)
 	return ret;
 }
 
+struct vgic_reg_attr {
+	struct kvm_vcpu *vcpu;
+	gpa_t addr;
+};
+
+static int parse_vgic_v2_attr(struct kvm_device *dev,
+			      struct kvm_device_attr *attr,
+			      struct vgic_reg_attr *reg_attr)
+{
+	int cpuid;
+
+	cpuid = (attr->attr & KVM_DEV_ARM_VGIC_CPUID_MASK) >>
+		 KVM_DEV_ARM_VGIC_CPUID_SHIFT;
+
+	if (cpuid >= atomic_read(&dev->kvm->online_vcpus))
+		return -EINVAL;
+
+	reg_attr->vcpu = kvm_get_vcpu(dev->kvm, cpuid);
+	reg_attr->addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
+
+	return 0;
+}
+
+/* unlocks vcpus from @vcpu_lock_idx and smaller */
+static void unlock_vcpus(struct kvm *kvm, int vcpu_lock_idx)
+{
+	struct kvm_vcpu *tmp_vcpu;
+
+	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
+		tmp_vcpu = kvm_get_vcpu(kvm, vcpu_lock_idx);
+		mutex_unlock(&tmp_vcpu->mutex);
+	}
+}
+
+static void unlock_all_vcpus(struct kvm *kvm)
+{
+	unlock_vcpus(kvm, atomic_read(&kvm->online_vcpus) - 1);
+}
+
+/* Returns true if all vcpus were locked, false otherwise */
+static bool lock_all_vcpus(struct kvm *kvm)
+{
+	struct kvm_vcpu *tmp_vcpu;
+	int c;
+
+	/*
+	 * Any time a vcpu is run, vcpu_load is called which tries to grab the
+	 * vcpu->mutex.  By grabbing the vcpu->mutex of all VCPUs we ensure
+	 * that no other VCPUs are run and fiddle with the vgic state while we
+	 * access it.
+	 */
+	kvm_for_each_vcpu(c, tmp_vcpu, kvm) {
+		if (!mutex_trylock(&tmp_vcpu->mutex)) {
+			unlock_vcpus(kvm, c - 1);
+			return false;
+		}
+	}
+
+	return true;
+}
+
 /** vgic_attr_regs_access: allows user space to read/write VGIC registers
  *
  * @dev: kvm device handle
@@ -245,15 +306,17 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
 				 struct kvm_device_attr *attr,
 				 u32 *reg, bool is_write)
 {
+	struct vgic_reg_attr reg_attr;
 	gpa_t addr;
-	int cpuid, ret, c;
-	struct kvm_vcpu *vcpu, *tmp_vcpu;
-	int vcpu_lock_idx = -1;
+	struct kvm_vcpu *vcpu;
+	int ret;
 
-	cpuid = (attr->attr & KVM_DEV_ARM_VGIC_CPUID_MASK) >>
-		 KVM_DEV_ARM_VGIC_CPUID_SHIFT;
-	vcpu = kvm_get_vcpu(dev->kvm, cpuid);
-	addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
+	ret = parse_vgic_v2_attr(dev, attr, &reg_attr);
+	if (ret)
+		return ret;
+
+	vcpu = reg_attr.vcpu;
+	addr = reg_attr.addr;
 
 	mutex_lock(&dev->kvm->lock);
 
@@ -261,24 +324,11 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
 	if (ret)
 		goto out;
 
-	if (cpuid >= atomic_read(&dev->kvm->online_vcpus)) {
-		ret = -EINVAL;
+	if (!lock_all_vcpus(dev->kvm)) {
+		ret = -EBUSY;
 		goto out;
 	}
 
-	/*
-	 * Any time a vcpu is run, vcpu_load is called which tries to grab the
-	 * vcpu->mutex.  By grabbing the vcpu->mutex of all VCPUs we ensure
-	 * that no other VCPUs are run and fiddle with the vgic state while we
-	 * access it.
-	 */
-	ret = -EBUSY;
-	kvm_for_each_vcpu(c, tmp_vcpu, dev->kvm) {
-		if (!mutex_trylock(&tmp_vcpu->mutex))
-			goto out;
-		vcpu_lock_idx = c;
-	}
-
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
 		ret = vgic_v2_cpuif_uaccess(vcpu, is_write, addr, reg);
@@ -291,12 +341,8 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
 		break;
 	}
 
+	unlock_all_vcpus(dev->kvm);
 out:
-	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
-		tmp_vcpu = kvm_get_vcpu(dev->kvm, vcpu_lock_idx);
-		mutex_unlock(&tmp_vcpu->mutex);
-	}
-
 	mutex_unlock(&dev->kvm->lock);
 	return ret;
 }
-- 
2.9.0
