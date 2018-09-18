From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC v2 16/20] iommu: introduce device fault report API
Date: Tue, 18 Sep 2018 16:24:53 +0200
Message-ID: <20180918142457.3325-17-eric.auger@redhat.com>
References: <20180918142457.3325-1-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 073EB4A0CA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 10:26:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FdJLiWqBAOBX for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Sep 2018 10:26:46 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 740FD4A264
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 10:26:46 -0400 (EDT)
In-Reply-To: <20180918142457.3325-1-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: tianyu.lan@intel.com, marc.zyngier@arm.com, ashok.raj@intel.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

Traditionally, device specific faults are detected and handled within
their own device drivers. When IOMMU is enabled, faults such as DMA
related transactions are detected by IOMMU. There is no generic
reporting mechanism to report faults back to the in-kernel device
driver or the guest OS in case of assigned devices.

Faults detected by IOMMU is based on the transaction's source ID which
can be reported at per device basis, regardless of the device type is a
PCI device or not.

The fault types include recoverable (e.g. page request) and
unrecoverable faults(e.g. access error). In most cases, faults can be
handled by IOMMU drivers internally. The primary use cases are as
follows:
1. page request fault originated from an SVM capable device that is
assigned to guest via vIOMMU. In this case, the first level page tables
are owned by the guest. Page request must be propagated to the guest to
let guest OS fault in the pages then send page response. In this
mechanism, the direct receiver of IOMMU fault notification is VFIO,
which can relay notification events to QEMU or other user space
software.

2. faults need more subtle handling by device drivers. Other than
simply invoke reset function, there are needs to let device driver
handle the fault with a smaller impact.

This patchset is intended to create a generic fault report API such
that it can scale as follows:
- all IOMMU types
- PCI and non-PCI devices
- recoverable and unrecoverable faults
- VFIO and other other in kernel users
- DMA & IRQ remapping (TBD)
The original idea was brought up by David Woodhouse and discussions
summarized at https://lwn.net/Articles/608914/.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
[adapt to new iommu_fault fault field, test fault_param on
 iommu_unregister_device_fault_handler]
---
 drivers/iommu/iommu.c | 153 +++++++++++++++++++++++++++++++++++++++++-
 include/linux/iommu.h |  33 ++++++++-
 2 files changed, 184 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index b2b8f375b169..dd4f3677a9ac 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -618,6 +618,13 @@ int iommu_group_add_device(struct iommu_group *group, struct device *dev)
 		goto err_free_name;
 	}
 
+	dev->iommu_param = kzalloc(sizeof(*dev->iommu_param), GFP_KERNEL);
+	if (!dev->iommu_param) {
+		ret = -ENOMEM;
+		goto err_free_name;
+	}
+	mutex_init(&dev->iommu_param->lock);
+
 	kobject_get(group->devices_kobj);
 
 	dev->iommu_group = group;
@@ -648,6 +655,7 @@ int iommu_group_add_device(struct iommu_group *group, struct device *dev)
 	mutex_unlock(&group->mutex);
 	dev->iommu_group = NULL;
 	kobject_put(group->devices_kobj);
+	kfree(dev->iommu_param);
 err_free_name:
 	kfree(device->name);
 err_remove_link:
@@ -694,7 +702,7 @@ void iommu_group_remove_device(struct device *dev)
 	sysfs_remove_link(&dev->kobj, "iommu_group");
 
 	trace_remove_device_from_group(group->id, dev);
-
+	kfree(dev->iommu_param);
 	kfree(device->name);
 	kfree(device);
 	dev->iommu_group = NULL;
@@ -828,6 +836,149 @@ int iommu_group_unregister_notifier(struct iommu_group *group,
 }
 EXPORT_SYMBOL_GPL(iommu_group_unregister_notifier);
 
+/**
+ * iommu_register_device_fault_handler() - Register a device fault handler
+ * @dev: the device
+ * @handler: the fault handler
+ * @data: private data passed as argument to the handler
+ *
+ * When an IOMMU fault event is received, call this handler with the fault event
+ * and data as argument. The handler should return 0 on success. If the fault is
+ * recoverable (IOMMU_FAULT_PAGE_REQ), the handler can also complete
+ * the fault by calling iommu_page_response() with one of the following
+ * response code:
+ * - IOMMU_PAGE_RESP_SUCCESS: retry the translation
+ * - IOMMU_PAGE_RESP_INVALID: terminate the fault
+ * - IOMMU_PAGE_RESP_FAILURE: terminate the fault and stop reporting
+ *   page faults if possible.
+ *
+ * Return 0 if the fault handler was installed successfully, or an error.
+ */
+int iommu_register_device_fault_handler(struct device *dev,
+					iommu_dev_fault_handler_t handler,
+					void *data)
+{
+	struct iommu_param *param = dev->iommu_param;
+	int ret = 0;
+
+	/*
+	 * Device iommu_param should have been allocated when device is
+	 * added to its iommu_group.
+	 */
+	if (!param)
+		return -EINVAL;
+
+	mutex_lock(&param->lock);
+	/* Only allow one fault handler registered for each device */
+	if (param->fault_param) {
+		ret = -EBUSY;
+		goto done_unlock;
+	}
+
+	get_device(dev);
+	param->fault_param =
+		kzalloc(sizeof(struct iommu_fault_param), GFP_KERNEL);
+	if (!param->fault_param) {
+		put_device(dev);
+		ret = -ENOMEM;
+		goto done_unlock;
+	}
+	mutex_init(&param->fault_param->lock);
+	param->fault_param->handler = handler;
+	param->fault_param->data = data;
+	INIT_LIST_HEAD(&param->fault_param->faults);
+
+done_unlock:
+	mutex_unlock(&param->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iommu_register_device_fault_handler);
+
+/**
+ * iommu_unregister_device_fault_handler() - Unregister the device fault handler
+ * @dev: the device
+ *
+ * Remove the device fault handler installed with
+ * iommu_register_device_fault_handler().
+ *
+ * Return 0 on success, or an error.
+ */
+int iommu_unregister_device_fault_handler(struct device *dev)
+{
+	struct iommu_param *param = dev->iommu_param;
+	int ret = 0;
+
+	if (!param)
+		return -EINVAL;
+
+	mutex_lock(&param->lock);
+
+	if (!param->fault_param)
+		goto unlock;
+
+	/* we cannot unregister handler if there are pending faults */
+	if (!list_empty(&param->fault_param->faults)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	kfree(param->fault_param);
+	param->fault_param = NULL;
+	put_device(dev);
+unlock:
+	mutex_unlock(&param->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iommu_unregister_device_fault_handler);
+
+
+/**
+ * iommu_report_device_fault() - Report fault event to device
+ * @dev: the device
+ * @evt: fault event data
+ *
+ * Called by IOMMU model specific drivers when fault is detected, typically
+ * in a threaded IRQ handler.
+ *
+ * Return 0 on success, or an error.
+ */
+int iommu_report_device_fault(struct device *dev, struct iommu_fault_event *evt)
+{
+	int ret = 0;
+	struct iommu_fault_event *evt_pending;
+	struct iommu_fault_param *fparam;
+
+	/* iommu_param is allocated when device is added to group */
+	if (!dev->iommu_param | !evt)
+		return -EINVAL;
+	/* we only report device fault if there is a handler registered */
+	mutex_lock(&dev->iommu_param->lock);
+	if (!dev->iommu_param->fault_param ||
+		!dev->iommu_param->fault_param->handler) {
+		ret = -EINVAL;
+		goto done_unlock;
+	}
+	fparam = dev->iommu_param->fault_param;
+	if (evt->fault.type == IOMMU_FAULT_PAGE_REQ && evt->fault.last_req) {
+		evt_pending = kmemdup(evt, sizeof(struct iommu_fault_event),
+				GFP_KERNEL);
+		if (!evt_pending) {
+			ret = -ENOMEM;
+			goto done_unlock;
+		}
+		mutex_lock(&fparam->lock);
+		list_add_tail(&evt_pending->list, &fparam->faults);
+		mutex_unlock(&fparam->lock);
+	}
+	ret = fparam->handler(evt, fparam->data);
+done_unlock:
+	mutex_unlock(&dev->iommu_param->lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iommu_report_device_fault);
+
 /**
  * iommu_group_id - Return ID for a group
  * @group: the group to ID
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 7529c14ff506..760752300763 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -276,6 +276,7 @@ struct iommu_device {
  * - DMA remapping and IRQ remapping faults
  *
  * @fault: fault descriptor
+ * @list pending fault event list, used for tracking responses
  * @device_private: if present, uniquely identify device-specific
  *                  private data for an individual page request.
  * @iommu_private: used by the IOMMU driver for storing fault-specific
@@ -283,6 +284,7 @@ struct iommu_device {
  *                 sending the fault response.
  */
 struct iommu_fault_event {
+	struct list_head list;
 	struct iommu_fault fault;
 	u64 device_private;
 	u64 iommu_private;
@@ -292,10 +294,13 @@ struct iommu_fault_event {
  * struct iommu_fault_param - per-device IOMMU fault data
  * @dev_fault_handler: Callback function to handle IOMMU faults at device level
  * @data: handler private data
- *
+ * @faults: holds the pending faults which needs response, e.g. page response.
+ * @lock: protect pending PRQ event list
  */
 struct iommu_fault_param {
 	iommu_dev_fault_handler_t handler;
+	struct list_head faults;
+	struct mutex lock;
 	void *data;
 };
 
@@ -309,6 +314,7 @@ struct iommu_fault_param {
  *	struct iommu_fwspec	*iommu_fwspec;
  */
 struct iommu_param {
+	struct mutex lock;
 	struct iommu_fault_param *fault_param;
 };
 
@@ -409,6 +415,14 @@ extern int iommu_group_register_notifier(struct iommu_group *group,
 					 struct notifier_block *nb);
 extern int iommu_group_unregister_notifier(struct iommu_group *group,
 					   struct notifier_block *nb);
+extern int iommu_register_device_fault_handler(struct device *dev,
+					iommu_dev_fault_handler_t handler,
+					void *data);
+
+extern int iommu_unregister_device_fault_handler(struct device *dev);
+
+extern int iommu_report_device_fault(struct device *dev, struct iommu_fault_event *evt);
+
 extern int iommu_group_id(struct iommu_group *group);
 extern struct iommu_group *iommu_group_get_for_dev(struct device *dev);
 extern struct iommu_domain *iommu_group_default_domain(struct iommu_group *);
@@ -673,6 +687,23 @@ static inline int iommu_group_unregister_notifier(struct iommu_group *group,
 	return 0;
 }
 
+static inline int iommu_register_device_fault_handler(struct device *dev,
+						iommu_dev_fault_handler_t handler,
+						void *data)
+{
+	return -ENODEV;
+}
+
+static inline int iommu_unregister_device_fault_handler(struct device *dev)
+{
+	return 0;
+}
+
+static inline int iommu_report_device_fault(struct device *dev, struct iommu_fault_event *evt)
+{
+	return -ENODEV;
+}
+
 static inline int iommu_group_id(struct iommu_group *group)
 {
 	return -ENODEV;
-- 
2.17.1
