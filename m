From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v6 15/16] KVM: kvm-vfio: generic forwarding control
Date: Mon, 13 Apr 2015 14:29:30 +0200
Message-ID: <1428928171-18884-16-git-send-email-eric.auger@linaro.org>
References: <1428928171-18884-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 095D64C438
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 08:25:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GTc-iME7sgyQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Apr 2015 08:25:15 -0400 (EDT)
Received: from mail-wi0-f169.google.com (mail-wi0-f169.google.com
 [209.85.212.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7D7804C47B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 08:25:15 -0400 (EDT)
Received: by widjs5 with SMTP id js5so63418487wid.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 05:33:02 -0700 (PDT)
In-Reply-To: <1428928171-18884-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, alex.williamson@redhat.com, pbonzini@redhat.com
Cc: feng.wu@intel.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch introduces a new KVM_DEV_VFIO_DEVICE group.

This is a new control channel which enables KVM to cooperate with
viable VFIO devices.

The patch introduces 2 attributes for this group:
KVM_DEV_VFIO_DEVICE_FORWARD_IRQ, KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ.
Their purpose is to turn a VFIO device IRQ into a forwarded IRQ and
 respectively unset the feature.

The generic part introduced here interact with VFIO, genirq, KVM while
the architecture specific part mostly takes care of the virtual interrupt
controller programming.

Architecture specific implementation is enabled when
__KVM_HAVE_ARCH_KVM_VFIO_FORWARD is set. When not set those
functions are void.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v5 -> v6:
- does not use struct vfio_platform_device handles anymore
- remove DEBUG flags
- rename kvm_vfio_platform_get_irq into kvm_vfio_get_hwirq
- handle returned error values from external functions

v3 -> v4:
- use new kvm_vfio_dev_irq struct
- improve error handling according to Alex comments
- full rework or generic/arch specific split to accomodate for
  unforward that never fails
- kvm_vfio_get_vfio_device and kvm_vfio_put_vfio_device removed from
  that patch file and introduced before (since also used by Feng)
- guard kvm_vfio_control_irq_forward call with
  __KVM_HAVE_ARCH_KVM_VFIO_FORWARD

v2 -> v3:
- add API comments in kvm_host.h
- improve the commit message
- create a private kvm_vfio_fwd_irq struct
- fwd_irq_action replaced by a bool and removal of VFIO_IRQ_CLEANUP. This
  latter action will be handled in vgic.
- add a vfio_device handle argument to kvm_arch_set_fwd_state. The goal is
  to move platform specific stuff in architecture specific code.
- kvm_arch_set_fwd_state renamed into kvm_arch_vfio_set_forward
- increment the ref counter each time we do an IRQ forwarding and decrement
  this latter each time one IRQ forward is unset. Simplifies the whole
  ref counting.
- simplification of list handling: create, search, removal

v1 -> v2:
- __KVM_HAVE_ARCH_KVM_VFIO renamed into __KVM_HAVE_ARCH_KVM_VFIO_FORWARD
- original patch file separated into 2 parts: generic part moved in vfio.c
  and ARM specific part(kvm_arch_set_fwd_state)
---
 include/linux/kvm_host.h |  47 +++++++
 virt/kvm/vfio.c          | 310 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 354 insertions(+), 3 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f4e1829..8f17f87 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1042,6 +1042,15 @@ struct kvm_device_ops {
 		      unsigned long arg);
 };
 
+/* internal self-contained structure describing a forwarded IRQ */
+struct kvm_fwd_irq {
+	struct kvm *kvm; /* VM to inject the GSI into */
+	struct vfio_device *vdev; /* vfio device the IRQ belongs to */
+	__u32 index; /* VFIO device IRQ index */
+	__u32 subindex; /* VFIO device IRQ subindex */
+	__u32 gsi; /* gsi, ie. virtual IRQ number */
+};
+
 void kvm_device_get(struct kvm_device *dev);
 void kvm_device_put(struct kvm_device *dev);
 struct kvm_device *kvm_device_from_filp(struct file *filp);
@@ -1065,6 +1074,44 @@ inline void kvm_arch_resume_guest(struct kvm *kvm) {}
 
 #endif
 
+#ifdef __KVM_HAVE_ARCH_KVM_VFIO_FORWARD
+/**
+ * kvm_arch_set_forward - Sets forwarding for a given IRQ
+ *
+ * @kvm: handle to the VM
+ * @host_irq: physical IRQ number
+ * @guest_irq: virtual IRQ number
+ * returns 0 on success, < 0 on failure
+ */
+int kvm_arch_set_forward(struct kvm *kvm,
+			 unsigned int host_irq, unsigned int guest_irq);
+
+/**
+ * kvm_arch_unset_forward - Unsets forwarding for a given IRQ
+ *
+ * @kvm: handle to the VM
+ * @host_irq: physical IRQ number
+ * @guest_irq: virtual IRQ number
+ * @active: returns whether the IRQ is active
+ */
+void kvm_arch_unset_forward(struct kvm *kvm,
+			    unsigned int host_irq,
+			    unsigned int guest_irq,
+			    bool *active);
+
+#else
+static inline int kvm_arch_set_forward(struct kvm *kvm,
+				       unsigned int host_irq,
+				       unsigned int guest_irq)
+{
+	return -ENOENT;
+}
+static inline void kvm_arch_unset_forward(struct kvm *kvm,
+					  unsigned int host_irq,
+					  unsigned int guest_irq,
+					  bool *active) {}
+#endif
+
 #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
 
 static inline void kvm_vcpu_set_in_spin_loop(struct kvm_vcpu *vcpu, bool val)
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index f4e86d3..cf40a2a 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -19,14 +19,27 @@
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
 #include "vfio.h"
+#include <linux/platform_device.h>
+#include <linux/irq.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
 
 struct kvm_vfio_group {
 	struct list_head node;
 	struct vfio_group *vfio_group;
 };
 
+/* private linkable kvm_fwd_irq struct */
+struct kvm_vfio_fwd_irq_node {
+	struct list_head link;
+	struct kvm_fwd_irq fwd_irq;
+};
+
 struct kvm_vfio {
 	struct list_head group_list;
+	/* list of registered VFIO forwarded IRQs */
+	struct list_head fwd_node_list;
 	struct mutex lock;
 	bool noncoherent;
 };
@@ -328,12 +341,295 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
 	return -ENXIO;
 }
 
+/**
+ * kvm_vfio_find_fwd_irq - checks whether a forwarded IRQ already is
+ * registered in the list of forwarded IRQs
+ *
+ * @kv: handle to the kvm-vfio device
+ * @fwd: handle to the forwarded irq struct
+ * In the positive returns the handle to its node in the kvm-vfio
+ * forwarded IRQ list, returns NULL otherwise.
+ * Must be called with kv->lock hold.
+ */
+static struct kvm_vfio_fwd_irq_node *kvm_vfio_find_fwd_irq(
+				struct kvm_vfio *kv,
+				struct kvm_fwd_irq *fwd)
+{
+	struct kvm_vfio_fwd_irq_node *node;
+
+	list_for_each_entry(node, &kv->fwd_node_list, link) {
+		if ((node->fwd_irq.index == fwd->index) &&
+		    (node->fwd_irq.subindex == fwd->subindex) &&
+		    (node->fwd_irq.vdev == fwd->vdev))
+			return node;
+	}
+	return NULL;
+}
+/**
+ * kvm_vfio_register_fwd_irq - Allocates, populates and registers a
+ * forwarded IRQ
+ *
+ * @kv: handle to the kvm-vfio device
+ * @fwd: handle to the forwarded irq struct
+ * In case of success returns a handle to the new list node,
+ * NULL otherwise.
+ * Must be called with kv->lock hold.
+ */
+static struct kvm_vfio_fwd_irq_node *kvm_vfio_register_fwd_irq(
+				struct kvm_vfio *kv,
+				struct kvm_fwd_irq *fwd)
+{
+	struct kvm_vfio_fwd_irq_node *node;
+
+	node = kmalloc(sizeof(*node), GFP_KERNEL);
+	if (!node)
+		return ERR_PTR(-ENOMEM);
+
+	node->fwd_irq = *fwd;
+
+	list_add(&node->link, &kv->fwd_node_list);
+
+	return node;
+}
+
+/**
+ * kvm_vfio_unregister_fwd_irq - unregisters and frees a forwarded IRQ
+ *
+ * @node: handle to the node struct
+ * Must be called with kv->lock hold.
+ */
+static void kvm_vfio_unregister_fwd_irq(struct kvm_vfio_fwd_irq_node *node)
+{
+	list_del(&node->link);
+	kvm_vfio_put_vfio_device(node->fwd_irq.vdev);
+	kfree(node);
+}
+
+static int kvm_vfio_get_hwirq(struct vfio_device *vdev, int index)
+{
+	int hwirq;
+	struct platform_device *platdev;
+	struct device *dev = kvm_vfio_external_base_device(vdev);
+
+	if (dev->bus == &platform_bus_type) {
+		platdev = to_platform_device(dev);
+		hwirq = platform_get_irq(platdev, index);
+		return hwirq;
+	} else
+		return -EINVAL;
+}
+
+/**
+ * kvm_vfio_set_forward - turns a VFIO device IRQ into a forwarded IRQ
+ * @kv: handle to the kvm-vfio device
+ * @fd: file descriptor of the vfio device the IRQ belongs to
+ * @fwd: handle to the forwarded irq struct
+ *
+ * Registers and turns an IRQ as forwarded. The operation only is allowed
+ * if the IRQ is not in progress (active at interrupt controller level or
+ * auto-masked by the handler). In case the user-space masked the IRQ,
+ * the operation will fail too.
+ * returns:
+ * -EAGAIN if the IRQ is in progress or VFIO masked
+ * -EEXIST if the IRQ is already registered as forwarded
+ * -ENOMEM on memory shortage
+ */
+static int kvm_vfio_set_forward(struct kvm_vfio *kv, int fd,
+				struct kvm_fwd_irq *fwd)
+{
+	int ret = -EAGAIN;
+	struct kvm_vfio_fwd_irq_node *node;
+	struct vfio_device *vdev = fwd->vdev;
+	int index = fwd->index;
+	int host_irq = kvm_vfio_get_hwirq(fwd->vdev, fwd->index);
+	bool active;
+
+	kvm_arch_halt_guest(fwd->kvm);
+
+	disable_irq(host_irq);
+
+	active = kvm_vfio_external_is_active(vdev, index, 0, 0);
+
+	if (active)
+		goto out;
+
+	node = kvm_vfio_register_fwd_irq(kv, fwd);
+	if (IS_ERR(node)) {
+		ret = PTR_ERR(node);
+		goto out;
+	}
+
+	ret = kvm_vfio_external_set_automasked(vdev, index, 0, 0, false);
+	if (ret)
+		goto out;
+
+	ret = kvm_arch_set_forward(fwd->kvm, host_irq, fwd->gsi);
+
+out:
+	enable_irq(host_irq);
+
+	kvm_arch_resume_guest(fwd->kvm);
+
+	return ret;
+}
+
+/**
+ * kvm_vfio_unset_forward - Sets a VFIO device IRQ as non forwarded
+ * @kv: handle to the kvm-vfio device
+ * @node: handle to the node to unset
+ *
+ * Calls the architecture specific implementation of set_forward and
+ * unregisters the IRQ from the forwarded IRQ list.
+ */
+static void kvm_vfio_unset_forward(struct kvm_vfio *kv,
+				   struct kvm_vfio_fwd_irq_node *node)
+{
+	struct kvm_fwd_irq fwd = node->fwd_irq;
+	int host_irq = kvm_vfio_get_hwirq(fwd.vdev, fwd.index);
+	int index = fwd.index;
+	struct vfio_device *vdev = fwd.vdev;
+	bool active = false;
+
+	kvm_arch_halt_guest(fwd.kvm);
+
+	disable_irq(host_irq);
+
+	kvm_arch_unset_forward(fwd.kvm, host_irq, fwd.gsi, &active);
+
+	if (active)
+		kvm_vfio_external_mask(vdev, index, 0, 0);
+
+	kvm_vfio_external_set_automasked(vdev, index, 0, 0, true);
+	enable_irq(host_irq);
+
+	kvm_arch_resume_guest(fwd.kvm);
+
+	kvm_vfio_unregister_fwd_irq(node);
+}
+
+static int kvm_vfio_control_irq_forward(struct kvm_device *kdev, long attr,
+					int32_t __user *argp)
+{
+	struct kvm_vfio_dev_irq user_fwd_irq;
+	struct kvm_fwd_irq fwd;
+	struct vfio_device *vdev;
+	struct kvm_vfio *kv = kdev->private;
+	struct kvm_vfio_fwd_irq_node *node;
+	unsigned long minsz;
+	int ret = 0;
+	u32 *gsi = NULL;
+	size_t size;
+
+	minsz = offsetofend(struct kvm_vfio_dev_irq, count);
+
+	if (copy_from_user(&user_fwd_irq, argp, minsz))
+		return -EFAULT;
+
+	if (user_fwd_irq.argsz < minsz)
+		return -EINVAL;
+
+	vdev = kvm_vfio_get_vfio_device(user_fwd_irq.fd);
+	if (IS_ERR(vdev))
+		return PTR_ERR(vdev);
+
+	ret = kvm_vfio_get_hwirq(vdev, user_fwd_irq.index);
+	if (ret < 0)
+		goto error;
+
+	size = sizeof(__u32);
+	if (user_fwd_irq.argsz - minsz < size) {
+		ret = -EINVAL;
+		goto error;
+	}
+
+	gsi = memdup_user((void __user *)((unsigned long)argp + minsz), size);
+	if (IS_ERR(gsi)) {
+		ret = PTR_ERR(gsi);
+		goto error;
+	}
+
+	fwd.vdev =  vdev;
+	fwd.kvm =  kdev->kvm;
+	fwd.index = user_fwd_irq.index;
+	fwd.subindex = 0;
+	fwd.gsi = *gsi;
+
+	node = kvm_vfio_find_fwd_irq(kv, &fwd);
+
+	switch (attr) {
+	case KVM_DEV_VFIO_DEVICE_FORWARD_IRQ:
+		if (node) {
+			ret = -EEXIST;
+			goto error;
+		}
+		mutex_lock(&kv->lock);
+		ret = kvm_vfio_set_forward(kv, user_fwd_irq.fd, &fwd);
+		mutex_unlock(&kv->lock);
+		break;
+	case KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ:
+		if (!node) {
+			ret = -ENOENT;
+			goto error;
+		}
+		mutex_lock(&kv->lock);
+		kvm_vfio_unset_forward(kv, node);
+		mutex_unlock(&kv->lock);
+		kvm_vfio_put_vfio_device(vdev);
+		ret = 0;
+		break;
+	}
+
+	kfree(gsi);
+error:
+	if (ret < 0)
+		kvm_vfio_put_vfio_device(vdev);
+	return ret;
+}
+
+static int kvm_vfio_set_device(struct kvm_device *kdev, long attr, u64 arg)
+{
+	int32_t __user *argp = (int32_t __user *)(unsigned long)arg;
+	int ret;
+
+	switch (attr) {
+#ifdef __KVM_HAVE_ARCH_KVM_VFIO_FORWARD
+	case KVM_DEV_VFIO_DEVICE_FORWARD_IRQ:
+	case KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ:
+		ret = kvm_vfio_control_irq_forward(kdev, attr, argp);
+		break;
+#endif
+	default:
+		ret = -ENXIO;
+	}
+	return ret;
+}
+
+/**
+ * kvm_vfio_clean_fwd_irq - Unset forwarding state of all
+ * registered forwarded IRQs and free their list nodes.
+ * @kv: kvm-vfio device
+ *
+ * Loop on all registered device/IRQ combos, reset the non forwarded state,
+ * void the lists and release the reference
+ */
+static int kvm_vfio_clean_fwd_irq(struct kvm_vfio *kv)
+{
+	struct kvm_vfio_fwd_irq_node *node, *tmp;
+
+	list_for_each_entry_safe(node, tmp, &kv->fwd_node_list, link) {
+		kvm_vfio_unset_forward(kv, node);
+	}
+	return 0;
+}
+
 static int kvm_vfio_set_attr(struct kvm_device *dev,
 			     struct kvm_device_attr *attr)
 {
 	switch (attr->group) {
 	case KVM_DEV_VFIO_GROUP:
 		return kvm_vfio_set_group(dev, attr->attr, attr->addr);
+	case KVM_DEV_VFIO_DEVICE:
+		return kvm_vfio_set_device(dev, attr->attr, attr->addr);
 	}
 
 	return -ENXIO;
@@ -349,10 +645,17 @@ static int kvm_vfio_has_attr(struct kvm_device *dev,
 		case KVM_DEV_VFIO_GROUP_DEL:
 			return 0;
 		}
-
 		break;
+#ifdef __KVM_HAVE_ARCH_KVM_VFIO_FORWARD
+	case KVM_DEV_VFIO_DEVICE:
+		switch (attr->attr) {
+		case KVM_DEV_VFIO_DEVICE_FORWARD_IRQ:
+		case KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ:
+			return 0;
+		}
+		break;
+#endif
 	}
-
 	return -ENXIO;
 }
 
@@ -366,7 +669,7 @@ static void kvm_vfio_destroy(struct kvm_device *dev)
 		list_del(&kvg->node);
 		kfree(kvg);
 	}
-
+	kvm_vfio_clean_fwd_irq(kv);
 	kvm_vfio_update_coherency(dev);
 
 	kfree(kv);
@@ -398,6 +701,7 @@ static int kvm_vfio_create(struct kvm_device *dev, u32 type)
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&kv->group_list);
+	INIT_LIST_HEAD(&kv->fwd_node_list);
 	mutex_init(&kv->lock);
 
 	dev->private = kv;
-- 
1.9.1
