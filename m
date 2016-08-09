From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v2 2/2] KVM: Protect device ops->create and list_add with
 kvm->lock
Date: Tue,  9 Aug 2016 19:13:01 +0200
Message-ID: <20160809171301.24283-3-christoffer.dall@linaro.org>
References: <20160809171301.24283-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E8A349B46
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2016 13:04:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gbZTBPqtvynb for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2016 13:04:11 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A415349B47
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2016 13:04:11 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id d196so6683430wmd.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Aug 2016 10:11:19 -0700 (PDT)
In-Reply-To: <20160809171301.24283-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org
Cc: Andre Przywara <andre.przywara@arm.com>, paulus@ozlabs.org, borntraeger@de.ibm.com, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

KVM devices were manipulating list data structures without any form of
synchronization, and some implementations of the create operations also
suffered from a lack of synchronization.

Now when we've split the xics create operation into create and init, we
can hold the kvm->lock mutex while calling the create operation and when
manipulating the devices list.

The error path in the generic code gets slightly ugly because we have to
take the mutex again and delete the device from the list, but holding
the mutex during anon_inode_getfd or releasing/locking the mutex in the
common non-error path seemed wrong.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---

Notes:
    Changes since v1:
     - Added comment to create op in struct kvm_device_ops

 arch/arm/kvm/arm.c             |  6 +++++-
 arch/powerpc/kvm/book3s_xics.c |  2 --
 include/linux/kvm_host.h       |  6 ++++++
 virt/kvm/arm/vgic/vgic-init.c  | 17 ++++-------------
 virt/kvm/kvm_main.c            | 13 ++++++++++++-
 5 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index d94bb90..75f130e 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -1009,9 +1009,13 @@ long kvm_arch_vm_ioctl(struct file *filp,
 
 	switch (ioctl) {
 	case KVM_CREATE_IRQCHIP: {
+		int ret;
 		if (!vgic_present)
 			return -ENXIO;
-		return kvm_vgic_create(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
+		mutex_lock(&kvm->lock);
+		ret = kvm_vgic_create(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
+		mutex_unlock(&kvm->lock);
+		return ret;
 	}
 	case KVM_ARM_SET_DEVICE_ADDR: {
 		struct kvm_arm_device_addr dev_addr;
diff --git a/arch/powerpc/kvm/book3s_xics.c b/arch/powerpc/kvm/book3s_xics.c
index f2def8e..05aa113 100644
--- a/arch/powerpc/kvm/book3s_xics.c
+++ b/arch/powerpc/kvm/book3s_xics.c
@@ -1329,12 +1329,10 @@ static int kvmppc_xics_create(struct kvm_device *dev, u32 type)
 	xics->kvm = kvm;
 
 	/* Already there ? */
-	mutex_lock(&kvm->lock);
 	if (kvm->arch.xics)
 		ret = -EEXIST;
 	else
 		kvm->arch.xics = xics;
-	mutex_unlock(&kvm->lock);
 
 	if (ret) {
 		kfree(xics);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d3c9b82..9c28b4d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1113,6 +1113,12 @@ struct kvm_device {
 /* create, destroy, and name are mandatory */
 struct kvm_device_ops {
 	const char *name;
+
+	/*
+	 * create is called holding kvm->lock and any operations not suitable
+	 * to do while holding the lock should be deferred to init (see
+	 * below).
+	 */
 	int (*create)(struct kvm_device *dev, u32 type);
 
 	/*
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index fb4b0a7..83777c1 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -73,12 +73,8 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	int i, vcpu_lock_idx = -1, ret;
 	struct kvm_vcpu *vcpu;
 
-	mutex_lock(&kvm->lock);
-
-	if (irqchip_in_kernel(kvm)) {
-		ret = -EEXIST;
-		goto out;
-	}
+	if (irqchip_in_kernel(kvm))
+		return -EEXIST;
 
 	/*
 	 * This function is also called by the KVM_CREATE_IRQCHIP handler,
@@ -87,10 +83,8 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	 * the proper checks already.
 	 */
 	if (type == KVM_DEV_TYPE_ARM_VGIC_V2 &&
-		!kvm_vgic_global_state.can_emulate_gicv2) {
-		ret = -ENODEV;
-		goto out;
-	}
+		!kvm_vgic_global_state.can_emulate_gicv2)
+		return -ENODEV;
 
 	/*
 	 * Any time a vcpu is run, vcpu_load is called which tries to grab the
@@ -138,9 +132,6 @@ out_unlock:
 		vcpu = kvm_get_vcpu(kvm, vcpu_lock_idx);
 		mutex_unlock(&vcpu->mutex);
 	}
-
-out:
-	mutex_unlock(&kvm->lock);
 	return ret;
 }
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ae64245..1950782 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -696,6 +696,11 @@ static void kvm_destroy_devices(struct kvm *kvm)
 {
 	struct kvm_device *dev, *tmp;
 
+	/*
+	 * We do not need to take the kvm->lock here, because nobody else
+	 * has a reference to the struct kvm at this point and therefore
+	 * cannot access the devices list anyhow.
+	 */
 	list_for_each_entry_safe(dev, tmp, &kvm->devices, vm_node) {
 		list_del(&dev->vm_node);
 		dev->ops->destroy(dev);
@@ -2832,11 +2837,15 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
 	dev->ops = ops;
 	dev->kvm = kvm;
 
+	mutex_lock(&kvm->lock);
 	ret = ops->create(dev, cd->type);
 	if (ret < 0) {
+		mutex_unlock(&kvm->lock);
 		kfree(dev);
 		return ret;
 	}
+	list_add(&dev->vm_node, &kvm->devices);
+	mutex_unlock(&kvm->lock);
 
 	if (ops->init)
 		ops->init(dev);
@@ -2844,10 +2853,12 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
 	ret = anon_inode_getfd(ops->name, &kvm_device_fops, dev, O_RDWR | O_CLOEXEC);
 	if (ret < 0) {
 		ops->destroy(dev);
+		mutex_lock(&kvm->lock);
+		list_del(&dev->vm_node);
+		mutex_unlock(&kvm->lock);
 		return ret;
 	}
 
-	list_add(&dev->vm_node, &kvm->devices);
 	kvm_get_kvm(kvm);
 	cd->fd = ret;
 	return 0;
-- 
2.9.0
