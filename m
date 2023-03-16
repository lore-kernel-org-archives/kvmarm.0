Received: from out-14.mta1.migadu.com (out-14.mta1.migadu.com [95.215.58.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD02AD32
	for <kvmarm@lists.linux.dev>; Thu, 16 Mar 2023 21:14:35 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1679001273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xhgnOJEosH98wdoXReR9wJiedx7z0eEZV5vpcQvw08E=;
	b=iDbC9HZzNWdsKhHOdvki9BYBYAVWsMLr1ci6nNZXaI5+4F95T7AGmAvFl9zqdgRs3hDOH8
	tEj/bid2ED5rQevZ0nsMgMZJcSCbYlTP17Nb8BwypxeEElFZIDwhYnvgAEEDpg3QXumsER
	3Ugoy53xZ6b1faOad4gZ5GrW9mv9e6A=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvmarm@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 4/4] KVM: arm64: Use config_lock to protect vgic state
Date: Thu, 16 Mar 2023 21:14:12 +0000
Message-Id: <20230316211412.2651555-5-oliver.upton@linux.dev>
In-Reply-To: <20230316211412.2651555-1-oliver.upton@linux.dev>
References: <20230316211412.2651555-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Almost all of the vgic state is VM-scoped but accessed from the context
of a vCPU. These accesses were serialized on the kvm->lock which cannot
be nested within a vcpu->mutex critical section.

Move over the vgic state to using the config_lock. Tweak the lock
ordering where necessary to ensure that the config_lock is acquired
after the vcpu->mutex. Acquire the config_lock in kvm_vgic_create() to
avoid a race between the converted flows and GIC creation.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-debug.c      |  8 ++--
 arch/arm64/kvm/vgic/vgic-init.c       | 33 ++++++++++-------
 arch/arm64/kvm/vgic/vgic-its.c        | 29 ++++++---------
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 53 ++++++++++++---------------
 arch/arm64/kvm/vgic/vgic-mmio-v3.c    |  4 +-
 arch/arm64/kvm/vgic/vgic-mmio.c       | 12 +++---
 arch/arm64/kvm/vgic/vgic-v4.c         | 11 +++---
 arch/arm64/kvm/vgic/vgic.c            |  2 +-
 8 files changed, 75 insertions(+), 77 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index 78cde687383c..07aa0437125a 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -85,7 +85,7 @@ static void *vgic_debug_start(struct seq_file *s, loff_t *pos)
 	struct kvm *kvm = s->private;
 	struct vgic_state_iter *iter;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.config_lock);
 	iter = kvm->arch.vgic.iter;
 	if (iter) {
 		iter = ERR_PTR(-EBUSY);
@@ -104,7 +104,7 @@ static void *vgic_debug_start(struct seq_file *s, loff_t *pos)
 	if (end_of_vgic(iter))
 		iter = NULL;
 out:
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.config_lock);
 	return iter;
 }
 
@@ -132,12 +132,12 @@ static void vgic_debug_stop(struct seq_file *s, void *v)
 	if (IS_ERR(v))
 		return;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.config_lock);
 	iter = kvm->arch.vgic.iter;
 	kfree(iter->lpi_array);
 	kfree(iter);
 	kvm->arch.vgic.iter = NULL;
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.config_lock);
 }
 
 static void print_dist_state(struct seq_file *s, struct vgic_dist *dist)
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index cd134db41a57..b1690063e17d 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -74,9 +74,6 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	unsigned long i;
 	int ret;
 
-	if (irqchip_in_kernel(kvm))
-		return -EEXIST;
-
 	/*
 	 * This function is also called by the KVM_CREATE_IRQCHIP handler,
 	 * which had no chance yet to check the availability of the GICv2
@@ -91,6 +88,13 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	if (!lock_all_vcpus(kvm))
 		return ret;
 
+	mutex_lock(&kvm->arch.config_lock);
+
+	if (irqchip_in_kernel(kvm)) {
+		ret = -EEXIST;
+		goto out_unlock;
+	}
+
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (vcpu_has_run_once(vcpu))
 			goto out_unlock;
@@ -118,6 +122,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
 
 out_unlock:
+	mutex_unlock(&kvm->arch.config_lock);
 	unlock_all_vcpus(kvm);
 	return ret;
 }
@@ -227,9 +232,9 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 	 * KVM io device for the redistributor that belongs to this VCPU.
 	 */
 	if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
-		mutex_lock(&vcpu->kvm->lock);
+		mutex_lock(&vcpu->kvm->arch.config_lock);
 		ret = vgic_register_redist_iodev(vcpu);
-		mutex_unlock(&vcpu->kvm->lock);
+		mutex_unlock(&vcpu->kvm->arch.config_lock);
 	}
 	return ret;
 }
@@ -250,7 +255,6 @@ static void kvm_vgic_vcpu_enable(struct kvm_vcpu *vcpu)
  * The function is generally called when nr_spis has been explicitly set
  * by the guest through the KVM DEVICE API. If not nr_spis is set to 256.
  * vgic_initialized() returns true when this function has succeeded.
- * Must be called with kvm->lock held!
  */
 int vgic_init(struct kvm *kvm)
 {
@@ -259,6 +263,8 @@ int vgic_init(struct kvm *kvm)
 	int ret = 0, i;
 	unsigned long idx;
 
+	lockdep_assert_held(&kvm->arch.config_lock);
+
 	if (vgic_initialized(kvm))
 		return 0;
 
@@ -373,12 +379,13 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
 	vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
 }
 
-/* To be called with kvm->lock held */
 static void __kvm_vgic_destroy(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
 
+	lockdep_assert_held(&kvm->arch.config_lock);
+
 	vgic_debug_destroy(kvm);
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
@@ -389,9 +396,9 @@ static void __kvm_vgic_destroy(struct kvm *kvm)
 
 void kvm_vgic_destroy(struct kvm *kvm)
 {
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.config_lock);
 	__kvm_vgic_destroy(kvm);
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.config_lock);
 }
 
 /**
@@ -414,9 +421,9 @@ int vgic_lazy_init(struct kvm *kvm)
 		if (kvm->arch.vgic.vgic_model != KVM_DEV_TYPE_ARM_VGIC_V2)
 			return -EBUSY;
 
-		mutex_lock(&kvm->lock);
+		mutex_lock(&kvm->arch.config_lock);
 		ret = vgic_init(kvm);
-		mutex_unlock(&kvm->lock);
+		mutex_unlock(&kvm->arch.config_lock);
 	}
 
 	return ret;
@@ -441,7 +448,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 	if (likely(vgic_ready(kvm)))
 		return 0;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.config_lock);
 	if (vgic_ready(kvm))
 		goto out;
 
@@ -459,7 +466,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 		dist->ready = true;
 
 out:
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.config_lock);
 	return ret;
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 2642e9ce2819..ca55065102e7 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2043,7 +2043,10 @@ static int vgic_its_attr_regs_access(struct kvm_device *dev,
 	if (offset & align)
 		return -EINVAL;
 
-	mutex_lock(&dev->kvm->lock);
+	if (!lock_all_vcpus(dev->kvm))
+		return -EBUSY;
+
+	mutex_lock(&dev->kvm->arch.config_lock);
 
 	if (IS_VGIC_ADDR_UNDEF(its->vgic_its_base)) {
 		ret = -ENXIO;
@@ -2058,11 +2061,6 @@ static int vgic_its_attr_regs_access(struct kvm_device *dev,
 		goto out;
 	}
 
-	if (!lock_all_vcpus(dev->kvm)) {
-		ret = -EBUSY;
-		goto out;
-	}
-
 	addr = its->vgic_its_base + offset;
 
 	len = region->access_flags & VGIC_ACCESS_64bit ? 8 : 4;
@@ -2076,9 +2074,9 @@ static int vgic_its_attr_regs_access(struct kvm_device *dev,
 	} else {
 		*reg = region->its_read(dev->kvm, its, addr, len);
 	}
-	unlock_all_vcpus(dev->kvm);
 out:
-	mutex_unlock(&dev->kvm->lock);
+	mutex_unlock(&dev->kvm->arch.config_lock);
+	unlock_all_vcpus(dev->kvm);
 	return ret;
 }
 
@@ -2748,14 +2746,11 @@ static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
 	if (attr == KVM_DEV_ARM_VGIC_CTRL_INIT) /* Nothing to do */
 		return 0;
 
-	mutex_lock(&kvm->lock);
-	mutex_lock(&its->its_lock);
-
-	if (!lock_all_vcpus(kvm)) {
-		mutex_unlock(&its->its_lock);
-		mutex_unlock(&kvm->lock);
+	if (!lock_all_vcpus(kvm))
 		return -EBUSY;
-	}
+
+	mutex_lock(&kvm->arch.config_lock);
+	mutex_lock(&its->its_lock);
 
 	switch (attr) {
 	case KVM_DEV_ARM_ITS_CTRL_RESET:
@@ -2769,9 +2764,9 @@ static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
 		break;
 	}
 
-	unlock_all_vcpus(kvm);
 	mutex_unlock(&its->its_lock);
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.config_lock);
+	unlock_all_vcpus(kvm);
 	return ret;
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index edeac2380591..d5f8a81d6a92 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -46,7 +46,7 @@ int kvm_set_legacy_vgic_v2_addr(struct kvm *kvm, struct kvm_arm_device_addr *dev
 	struct vgic_dist *vgic = &kvm->arch.vgic;
 	int r;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.config_lock);
 	switch (FIELD_GET(KVM_ARM_DEVICE_TYPE_MASK, dev_addr->id)) {
 	case KVM_VGIC_V2_ADDR_TYPE_DIST:
 		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
@@ -68,7 +68,7 @@ int kvm_set_legacy_vgic_v2_addr(struct kvm *kvm, struct kvm_arm_device_addr *dev
 		r = -ENODEV;
 	}
 
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.config_lock);
 
 	return r;
 }
@@ -102,7 +102,7 @@ static int kvm_vgic_addr(struct kvm *kvm, struct kvm_device_attr *attr, bool wri
 		if (get_user(addr, uaddr))
 			return -EFAULT;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.config_lock);
 	switch (attr->attr) {
 	case KVM_VGIC_V2_ADDR_TYPE_DIST:
 		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
@@ -191,7 +191,7 @@ static int kvm_vgic_addr(struct kvm *kvm, struct kvm_device_attr *attr, bool wri
 	}
 
 out:
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.config_lock);
 
 	if (!r && !write)
 		r =  put_user(addr, uaddr);
@@ -227,7 +227,7 @@ static int vgic_set_common_attr(struct kvm_device *dev,
 		    (val & 31))
 			return -EINVAL;
 
-		mutex_lock(&dev->kvm->lock);
+		mutex_lock(&dev->kvm->arch.config_lock);
 
 		if (vgic_ready(dev->kvm) || dev->kvm->arch.vgic.nr_spis)
 			ret = -EBUSY;
@@ -235,16 +235,16 @@ static int vgic_set_common_attr(struct kvm_device *dev,
 			dev->kvm->arch.vgic.nr_spis =
 				val - VGIC_NR_PRIVATE_IRQS;
 
-		mutex_unlock(&dev->kvm->lock);
+		mutex_unlock(&dev->kvm->arch.config_lock);
 
 		return ret;
 	}
 	case KVM_DEV_ARM_VGIC_GRP_CTRL: {
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
-			mutex_lock(&dev->kvm->lock);
+			mutex_lock(&dev->kvm->arch.config_lock);
 			r = vgic_init(dev->kvm);
-			mutex_unlock(&dev->kvm->lock);
+			mutex_unlock(&dev->kvm->arch.config_lock);
 			return r;
 		case KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES:
 			/*
@@ -254,15 +254,14 @@ static int vgic_set_common_attr(struct kvm_device *dev,
 			 */
 			if (vgic_check_type(dev->kvm, KVM_DEV_TYPE_ARM_VGIC_V3))
 				return -ENXIO;
-			mutex_lock(&dev->kvm->lock);
 
-			if (!lock_all_vcpus(dev->kvm)) {
-				mutex_unlock(&dev->kvm->lock);
+			if (!lock_all_vcpus(dev->kvm))
 				return -EBUSY;
-			}
+
+			mutex_lock(&dev->kvm->arch.config_lock);
 			r = vgic_v3_save_pending_tables(dev->kvm);
+			mutex_unlock(&dev->kvm->arch.config_lock);
 			unlock_all_vcpus(dev->kvm);
-			mutex_unlock(&dev->kvm->lock);
 			return r;
 		}
 		break;
@@ -409,17 +408,15 @@ static int vgic_v2_attr_regs_access(struct kvm_device *dev,
 		if (get_user(val, uaddr))
 			return -EFAULT;
 
-	mutex_lock(&dev->kvm->lock);
+	if (!lock_all_vcpus(dev->kvm))
+		return -EBUSY;
+
+	mutex_lock(&dev->kvm->arch.config_lock);
 
 	ret = vgic_init(dev->kvm);
 	if (ret)
 		goto out;
 
-	if (!lock_all_vcpus(dev->kvm)) {
-		ret = -EBUSY;
-		goto out;
-	}
-
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
 		ret = vgic_v2_cpuif_uaccess(vcpu, is_write, addr, &val);
@@ -432,9 +429,9 @@ static int vgic_v2_attr_regs_access(struct kvm_device *dev,
 		break;
 	}
 
-	unlock_all_vcpus(dev->kvm);
 out:
-	mutex_unlock(&dev->kvm->lock);
+	mutex_unlock(&dev->kvm->arch.config_lock);
+	unlock_all_vcpus(dev->kvm);
 
 	if (!ret && !is_write)
 		ret = put_user(val, uaddr);
@@ -567,14 +564,12 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 			return -EFAULT;
 	}
 
-	mutex_lock(&dev->kvm->lock);
+	if (!lock_all_vcpus(dev->kvm))
+		return -EBUSY;
 
-	if (unlikely(!vgic_initialized(dev->kvm))) {
-		ret = -EBUSY;
-		goto out;
-	}
+	mutex_lock(&dev->kvm->arch.config_lock);
 
-	if (!lock_all_vcpus(dev->kvm)) {
+	if (unlikely(!vgic_initialized(dev->kvm))) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -609,9 +604,9 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 		break;
 	}
 
-	unlock_all_vcpus(dev->kvm);
 out:
-	mutex_unlock(&dev->kvm->lock);
+	mutex_unlock(&dev->kvm->arch.config_lock);
+	unlock_all_vcpus(dev->kvm);
 
 	if (!ret && uaccess && !is_write) {
 		u32 __user *uaddr = (u32 __user *)(unsigned long)attr->addr;
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 91201f743033..472b18ac92a2 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -111,7 +111,7 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
 	case GICD_CTLR: {
 		bool was_enabled, is_hwsgi;
 
-		mutex_lock(&vcpu->kvm->lock);
+		mutex_lock(&vcpu->kvm->arch.config_lock);
 
 		was_enabled = dist->enabled;
 		is_hwsgi = dist->nassgireq;
@@ -139,7 +139,7 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
 		else if (!was_enabled && dist->enabled)
 			vgic_kick_vcpus(vcpu->kvm);
 
-		mutex_unlock(&vcpu->kvm->lock);
+		mutex_unlock(&vcpu->kvm->arch.config_lock);
 		break;
 	}
 	case GICD_TYPER:
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index e67b3b2c8044..1939c94e0b24 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -530,13 +530,13 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	u32 val;
 
-	mutex_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->arch.config_lock);
 	vgic_access_active_prepare(vcpu, intid);
 
 	val = __vgic_mmio_read_active(vcpu, addr, len);
 
 	vgic_access_active_finish(vcpu, intid);
-	mutex_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->arch.config_lock);
 
 	return val;
 }
@@ -625,13 +625,13 @@ void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 
-	mutex_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->arch.config_lock);
 	vgic_access_active_prepare(vcpu, intid);
 
 	__vgic_mmio_write_cactive(vcpu, addr, len, val);
 
 	vgic_access_active_finish(vcpu, intid);
-	mutex_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->arch.config_lock);
 }
 
 int vgic_mmio_uaccess_write_cactive(struct kvm_vcpu *vcpu,
@@ -662,13 +662,13 @@ void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 
-	mutex_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->arch.config_lock);
 	vgic_access_active_prepare(vcpu, intid);
 
 	__vgic_mmio_write_sactive(vcpu, addr, len, val);
 
 	vgic_access_active_finish(vcpu, intid);
-	mutex_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->arch.config_lock);
 }
 
 int vgic_mmio_uaccess_write_sactive(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index a413718be92b..3bb003478060 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -232,9 +232,8 @@ int vgic_v4_request_vpe_irq(struct kvm_vcpu *vcpu, int irq)
  * @kvm:	Pointer to the VM being initialized
  *
  * We may be called each time a vITS is created, or when the
- * vgic is initialized. This relies on kvm->lock to be
- * held. In both cases, the number of vcpus should now be
- * fixed.
+ * vgic is initialized. In both cases, the number of vcpus
+ * should now be fixed.
  */
 int vgic_v4_init(struct kvm *kvm)
 {
@@ -243,6 +242,8 @@ int vgic_v4_init(struct kvm *kvm)
 	int nr_vcpus, ret;
 	unsigned long i;
 
+	lockdep_assert_held(&kvm->arch.config_lock);
+
 	if (!kvm_vgic_global_state.has_gicv4)
 		return 0; /* Nothing to see here... move along. */
 
@@ -309,14 +310,14 @@ int vgic_v4_init(struct kvm *kvm)
 /**
  * vgic_v4_teardown - Free the GICv4 data structures
  * @kvm:	Pointer to the VM being destroyed
- *
- * Relies on kvm->lock to be held.
  */
 void vgic_v4_teardown(struct kvm *kvm)
 {
 	struct its_vm *its_vm = &kvm->arch.vgic.its_vm;
 	int i;
 
+	lockdep_assert_held(&kvm->arch.config_lock);
+
 	if (!its_vm->vpes)
 		return;
 
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index d97e6080b421..afea64f60086 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -23,7 +23,7 @@ struct vgic_global kvm_vgic_global_state __ro_after_init = {
 
 /*
  * Locking order is always:
- * kvm->lock (mutex)
+ * kvm->arch.config_lock (mutex)
  *   its->cmd_lock (mutex)
  *     its->its_lock (mutex)
  *       vgic_cpu->ap_list_lock		must be taken with IRQs disabled
-- 
2.40.0.rc1.284.g88254d51c5-goog

