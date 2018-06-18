From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: [PATCH v6 kvmtool 09/13] vfio-pci: add MSI-X support
Date: Mon, 18 Jun 2018 19:42:07 +0100
Message-ID: <20180618184211.43904-10-jean-philippe.brucker@arm.com>
References: <20180618184211.43904-1-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A7734A0D6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jun 2018 14:32:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lWcF-mZNXxHi for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jun 2018 14:31:51 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B99824A0E0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jun 2018 14:31:39 -0400 (EDT)
In-Reply-To: <20180618184211.43904-1-jean-philippe.brucker@arm.com>
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
Cc: lorenzo.pieralisi@arm.com, marc.zyngier@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, alex.williamson@redhat.com, robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Add virtual MSI-X tables for PCI devices, and create IRQFD routes to let
the kernel inject MSIs from a physical device directly into the guest.

It would be tempting to create the MSI routes at init time before starting
vCPUs, when we can afford to exit gracefully. But some of it must be
initialized when the guest requests it.

* On the KVM side, MSIs must be enabled after devices allocate their IRQ
  lines and irqchips are operational, which can happen until late_init.

* On the VFIO side, hardware state of devices may be updated when setting
  up MSIs. For example, when passing a virtio-pci-legacy device to the
  guest:

  (1) The device-specific configuration layout (in BAR0) depends on
      whether MSIs are enabled or not in the device. If they are enabled,
      the device-specific configuration starts at offset 24, otherwise it
      starts at offset 20.
  (2) Linux guest assumes that MSIs are initially disabled (doesn't
      actually check the capability). So it reads the device config at
      offset 20.
  (3) Had we enabled MSIs early, host would have enabled the MSI-X
      capability and device would return the config at offset 24.
  (4) The guest would read junk and explode.

Therefore we have to create MSI-X routes when the guest requests MSIs, and
enable/disable them in VFIO when the guest pokes the MSI-X capability. We
have to follow both physical and virtual state of the capability, which
makes the state machine a bit complex, but I think it works.

An important missing feature is the absence of pending MSI handling. When
a vector or the function is masked, we should rewire the IRQFD to a
special thread that keeps note of pending interrupts (or just poll the
IRQFD before recreating the route?). And when the vector is unmasked, one
MSI should be injected if it was pending. At the moment no MSI is
injected, we simply disconnect the IRQFD and all messages are lost.

Reviewed-by: Punit Agrawal <punit.agrawal@arm.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 include/kvm/vfio.h |  52 ++++
 vfio/pci.c         | 651 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 691 insertions(+), 12 deletions(-)

diff --git a/include/kvm/vfio.h b/include/kvm/vfio.h
index c434703ab..483ba7e42 100644
--- a/include/kvm/vfio.h
+++ b/include/kvm/vfio.h
@@ -1,6 +1,7 @@
 #ifndef KVM__VFIO_H
 #define KVM__VFIO_H
 
+#include "kvm/mutex.h"
 #include "kvm/parse-options.h"
 #include "kvm/pci.h"
 
@@ -24,8 +25,59 @@ enum vfio_device_type {
 	VFIO_DEVICE_PCI,
 };
 
+/* MSI/MSI-X capability enabled */
+#define VFIO_PCI_MSI_STATE_ENABLED	(1 << 0)
+/* MSI/MSI-X capability or individual vector masked */
+#define VFIO_PCI_MSI_STATE_MASKED	(1 << 1)
+/* MSI-X capability has no vector enabled yet */
+#define VFIO_PCI_MSI_STATE_EMPTY	(1 << 2)
+
+struct vfio_pci_msi_entry {
+	struct msix_table		config;
+	int				gsi;
+	int				eventfd;
+	u8				phys_state;
+	u8				virt_state;
+};
+
+struct vfio_pci_msix_table {
+	size_t				size;
+	unsigned int			bar;
+	u32				guest_phys_addr;
+};
+
+struct vfio_pci_msix_pba {
+	size_t				size;
+	off_t				offset; /* in VFIO device fd */
+	unsigned int			bar;
+	u32				guest_phys_addr;
+};
+
+/* Common data for MSI and MSI-X */
+struct vfio_pci_msi_common {
+	off_t				pos;
+	u8				virt_state;
+	u8				phys_state;
+	struct mutex			mutex;
+	struct vfio_irq_info		info;
+	struct vfio_irq_set		*irq_set;
+	size_t				nr_entries;
+	struct vfio_pci_msi_entry	*entries;
+};
+
+#define VFIO_PCI_IRQ_MODE_INTX		(1 << 0)
+#define VFIO_PCI_IRQ_MODE_MSI		(1 << 1)
+#define VFIO_PCI_IRQ_MODE_MSIX		(1 << 2)
+
 struct vfio_pci_device {
 	struct pci_device_header	hdr;
+
+	unsigned long			irq_modes;
+	int				intx_fd;
+	unsigned int			intx_gsi;
+	struct vfio_pci_msi_common	msix;
+	struct vfio_pci_msix_table	msix_table;
+	struct vfio_pci_msix_pba	msix_pba;
 };
 
 struct vfio_region {
diff --git a/vfio/pci.c b/vfio/pci.c
index 6b157cfa3..b27de8548 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -5,6 +5,8 @@
 
 #include <sys/ioctl.h>
 #include <sys/eventfd.h>
+#include <sys/resource.h>
+#include <sys/time.h>
 
 /* Wrapper around UAPI vfio_irq_set */
 struct vfio_irq_eventfd {
@@ -12,6 +14,318 @@ struct vfio_irq_eventfd {
 	int			fd;
 };
 
+#define msi_is_enabled(state)		((state) & VFIO_PCI_MSI_STATE_ENABLED)
+#define msi_is_masked(state)		((state) & VFIO_PCI_MSI_STATE_MASKED)
+#define msi_is_empty(state)		((state) & VFIO_PCI_MSI_STATE_EMPTY)
+
+#define msi_update_state(state, val, bit)				\
+	(state) = (val) ? (state) | bit : (state) & ~bit;
+#define msi_set_enabled(state, val)					\
+	msi_update_state(state, val, VFIO_PCI_MSI_STATE_ENABLED)
+#define msi_set_masked(state, val)					\
+	msi_update_state(state, val, VFIO_PCI_MSI_STATE_MASKED)
+#define msi_set_empty(state, val)					\
+	msi_update_state(state, val, VFIO_PCI_MSI_STATE_EMPTY)
+
+static void vfio_pci_disable_intx(struct kvm *kvm, struct vfio_device *vdev);
+
+static int vfio_pci_enable_msis(struct kvm *kvm, struct vfio_device *vdev)
+{
+	size_t i;
+	int ret = 0;
+	int *eventfds;
+	struct vfio_pci_device *pdev = &vdev->pci;
+	struct vfio_pci_msi_common *msis = &pdev->msix;
+	struct vfio_irq_eventfd single = {
+		.irq = {
+			.argsz	= sizeof(single),
+			.flags	= VFIO_IRQ_SET_DATA_EVENTFD |
+				  VFIO_IRQ_SET_ACTION_TRIGGER,
+			.index	= msis->info.index,
+			.count	= 1,
+		},
+	};
+
+	if (!msi_is_enabled(msis->virt_state))
+		return 0;
+
+	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_INTX) {
+		/*
+		 * PCI (and VFIO) forbids enabling INTx, MSI or MSIX at the same
+		 * time. Since INTx has to be enabled from the start (we don't
+		 * have a reliable way to know when the user starts using it),
+		 * disable it now.
+		 */
+		vfio_pci_disable_intx(kvm, vdev);
+		/* Permanently disable INTx */
+		pdev->irq_modes &= ~VFIO_PCI_IRQ_MODE_INTX;
+	}
+
+	eventfds = (void *)msis->irq_set + sizeof(struct vfio_irq_set);
+
+	/*
+	 * Initial registration of the full range. This enables the physical
+	 * MSI/MSI-X capability, which might have desired side effects. For
+	 * instance when assigning virtio legacy devices, enabling the MSI
+	 * capability modifies the config space layout!
+	 *
+	 * As an optimization, only update MSIs when guest unmasks the
+	 * capability. This greatly reduces the initialization time for Linux
+	 * guest with 2048+ MSIs. Linux guest starts by enabling the MSI-X cap
+	 * masked, then fills individual vectors, then unmasks the whole
+	 * function. So we only do one VFIO ioctl when enabling for the first
+	 * time, and then one when unmasking.
+	 *
+	 * phys_state is empty when it is enabled but no vector has been
+	 * registered via SET_IRQS yet.
+	 */
+	if (!msi_is_enabled(msis->phys_state) ||
+	    (!msi_is_masked(msis->virt_state) &&
+	     msi_is_empty(msis->phys_state))) {
+		bool empty = true;
+
+		for (i = 0; i < msis->nr_entries; i++) {
+			eventfds[i] = msis->entries[i].gsi >= 0 ?
+				      msis->entries[i].eventfd : -1;
+
+			if (eventfds[i] >= 0)
+				empty = false;
+		}
+
+		ret = ioctl(vdev->fd, VFIO_DEVICE_SET_IRQS, msis->irq_set);
+		if (ret < 0) {
+			perror("VFIO_DEVICE_SET_IRQS(multi)");
+			return ret;
+		}
+
+		msi_set_enabled(msis->phys_state, true);
+		msi_set_empty(msis->phys_state, empty);
+
+		return 0;
+	}
+
+	if (msi_is_masked(msis->virt_state)) {
+		/* TODO: if phys_state is not empty nor masked, mask all vectors */
+		return 0;
+	}
+
+	/* Update individual vectors to avoid breaking those in use */
+	for (i = 0; i < msis->nr_entries; i++) {
+		struct vfio_pci_msi_entry *entry = &msis->entries[i];
+		int fd = entry->gsi >= 0 ? entry->eventfd : -1;
+
+		if (fd == eventfds[i])
+			continue;
+
+		single.irq.start = i;
+		single.fd = fd;
+
+		ret = ioctl(vdev->fd, VFIO_DEVICE_SET_IRQS, &single);
+		if (ret < 0) {
+			perror("VFIO_DEVICE_SET_IRQS(single)");
+			break;
+		}
+
+		eventfds[i] = fd;
+
+		if (msi_is_empty(msis->phys_state) && fd >= 0)
+			msi_set_empty(msis->phys_state, false);
+	}
+
+	return ret;
+}
+
+static int vfio_pci_disable_msis(struct kvm *kvm, struct vfio_device *vdev)
+{
+	int ret;
+	struct vfio_pci_device *pdev = &vdev->pci;
+	struct vfio_pci_msi_common *msis = &pdev->msix;
+	struct vfio_irq_set irq_set = {
+		.argsz	= sizeof(irq_set),
+		.flags 	= VFIO_IRQ_SET_DATA_NONE | VFIO_IRQ_SET_ACTION_TRIGGER,
+		.index 	= msis->info.index,
+		.start 	= 0,
+		.count	= 0,
+	};
+
+	if (!msi_is_enabled(msis->phys_state))
+		return 0;
+
+	ret = ioctl(vdev->fd, VFIO_DEVICE_SET_IRQS, &irq_set);
+	if (ret < 0) {
+		perror("VFIO_DEVICE_SET_IRQS(NONE)");
+		return ret;
+	}
+
+	msi_set_enabled(msis->phys_state, false);
+	msi_set_empty(msis->phys_state, true);
+
+	return 0;
+}
+
+static int vfio_pci_update_msi_entry(struct kvm *kvm, struct vfio_device *vdev,
+				     struct vfio_pci_msi_entry *entry)
+{
+	int ret;
+
+	if (entry->eventfd < 0) {
+		entry->eventfd = eventfd(0, 0);
+		if (entry->eventfd < 0) {
+			ret = -errno;
+			vfio_dev_err(vdev, "cannot create eventfd");
+			return ret;
+		}
+	}
+
+	/* Allocate IRQ if necessary */
+	if (entry->gsi < 0) {
+		int ret = irq__add_msix_route(kvm, &entry->config.msg,
+					      vdev->dev_hdr.dev_num << 3);
+		if (ret < 0) {
+			vfio_dev_err(vdev, "cannot create MSI-X route");
+			return ret;
+		}
+		entry->gsi = ret;
+	} else {
+		irq__update_msix_route(kvm, entry->gsi, &entry->config.msg);
+	}
+
+	/*
+	 * MSI masking is unimplemented in VFIO, so we have to handle it by
+	 * disabling/enabling IRQ route instead. We do it on the KVM side rather
+	 * than VFIO, because:
+	 * - it is 8x faster
+	 * - it allows to decouple masking logic from capability state.
+	 * - in masked state, after removing irqfd route, we could easily plug
+	 *   the eventfd in a local handler, in order to serve Pending Bit reads
+	 *   to the guest.
+	 *
+	 * So entry->phys_state is masked when there is no active irqfd route.
+	 */
+	if (msi_is_masked(entry->virt_state) == msi_is_masked(entry->phys_state))
+		return 0;
+
+	if (msi_is_masked(entry->phys_state)) {
+		ret = irq__add_irqfd(kvm, entry->gsi, entry->eventfd, -1);
+		if (ret < 0) {
+			vfio_dev_err(vdev, "cannot setup irqfd");
+			return ret;
+		}
+	} else {
+		irq__del_irqfd(kvm, entry->gsi, entry->eventfd);
+	}
+
+	msi_set_masked(entry->phys_state, msi_is_masked(entry->virt_state));
+
+	return 0;
+}
+
+static void vfio_pci_msix_pba_access(struct kvm_cpu *vcpu, u64 addr, u8 *data,
+				     u32 len, u8 is_write, void *ptr)
+{
+	struct vfio_pci_device *pdev = ptr;
+	struct vfio_pci_msix_pba *pba = &pdev->msix_pba;
+	u64 offset = addr - pba->guest_phys_addr;
+	struct vfio_device *vdev = container_of(pdev, struct vfio_device, pci);
+
+	if (is_write)
+		return;
+
+	/*
+	 * TODO: emulate PBA. Hardware MSI-X is never masked, so reading the PBA
+	 * is completely useless here. Note that Linux doesn't use PBA.
+	 */
+	if (pread(vdev->fd, data, len, pba->offset + offset) != (ssize_t)len)
+		vfio_dev_err(vdev, "cannot access MSIX PBA\n");
+}
+
+static void vfio_pci_msix_table_access(struct kvm_cpu *vcpu, u64 addr, u8 *data,
+				       u32 len, u8 is_write, void *ptr)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct vfio_pci_msi_entry *entry;
+	struct vfio_pci_device *pdev = ptr;
+	struct vfio_device *vdev = container_of(pdev, struct vfio_device, pci);
+
+	u64 offset = addr - pdev->msix_table.guest_phys_addr;
+
+	size_t vector = offset / PCI_MSIX_ENTRY_SIZE;
+	off_t field = offset % PCI_MSIX_ENTRY_SIZE;
+
+	/*
+	 * PCI spec says that software must use aligned 4 or 8 bytes accesses
+	 * for the MSI-X tables.
+	 */
+	if ((len != 4 && len != 8) || addr & (len - 1)) {
+		vfio_dev_warn(vdev, "invalid MSI-X table access");
+		return;
+	}
+
+	entry = &pdev->msix.entries[vector];
+
+	mutex_lock(&pdev->msix.mutex);
+
+	if (!is_write) {
+		memcpy(data, (void *)&entry->config + field, len);
+		goto out_unlock;
+	}
+
+	memcpy((void *)&entry->config + field, data, len);
+
+	/*
+	 * Check if access touched the vector control register, which is at the
+	 * end of the MSI-X entry.
+	 */
+	if (field + len <= PCI_MSIX_ENTRY_VECTOR_CTRL)
+		goto out_unlock;
+
+	msi_set_masked(entry->virt_state, entry->config.ctrl &
+		       PCI_MSIX_ENTRY_CTRL_MASKBIT);
+
+	if (vfio_pci_update_msi_entry(kvm, vdev, entry) < 0)
+		/* Not much we can do here. */
+		vfio_dev_err(vdev, "failed to configure MSIX vector %zu", vector);
+
+	/* Update the physical capability if necessary */
+	if (vfio_pci_enable_msis(kvm, vdev))
+		vfio_dev_err(vdev, "cannot enable MSIX");
+
+out_unlock:
+	mutex_unlock(&pdev->msix.mutex);
+}
+
+static void vfio_pci_msix_cap_write(struct kvm *kvm,
+				    struct vfio_device *vdev, u8 off,
+				    void *data, int sz)
+{
+	struct vfio_pci_device *pdev = &vdev->pci;
+	off_t enable_pos = PCI_MSIX_FLAGS + 1;
+	bool enable;
+	u16 flags;
+
+	off -= pdev->msix.pos;
+
+	/* Check if access intersects with the MSI-X Enable bit */
+	if (off > enable_pos || off + sz <= enable_pos)
+		return;
+
+	/* Read byte that contains the Enable bit */
+	flags = *(u8 *)(data + enable_pos - off) << 8;
+
+	mutex_lock(&pdev->msix.mutex);
+
+	msi_set_masked(pdev->msix.virt_state, flags & PCI_MSIX_FLAGS_MASKALL);
+	enable = flags & PCI_MSIX_FLAGS_ENABLE;
+	msi_set_enabled(pdev->msix.virt_state, enable);
+
+	if (enable && vfio_pci_enable_msis(kvm, vdev))
+		vfio_dev_err(vdev, "cannot enable MSIX");
+	else if (!enable && vfio_pci_disable_msis(kvm, vdev))
+		vfio_dev_err(vdev, "cannot disable MSIX");
+
+	mutex_unlock(&pdev->msix.mutex);
+}
+
 static void vfio_pci_cfg_read(struct kvm *kvm, struct pci_device_header *pci_hdr,
 			      u8 offset, void *data, int sz)
 {
@@ -46,29 +360,102 @@ static void vfio_pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hd
 		vfio_dev_warn(vdev, "Failed to write %d bytes to Configuration Space at 0x%x",
 			      sz, offset);
 
+	/* Handle MSI write now, since it might update the hardware capability */
+	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSIX)
+		vfio_pci_msix_cap_write(kvm, vdev, offset, data, sz);
+
 	if (pread(vdev->fd, base + offset, sz, info->offset + offset) != sz)
 		vfio_dev_warn(vdev, "Failed to read %d bytes from Configuration Space at 0x%x",
 			      sz, offset);
 }
 
+static ssize_t vfio_pci_cap_size(struct pci_cap_hdr *cap_hdr)
+{
+	switch (cap_hdr->type) {
+	case PCI_CAP_ID_MSIX:
+		return PCI_CAP_MSIX_SIZEOF;
+	default:
+		pr_err("unknown PCI capability 0x%x", cap_hdr->type);
+		return 0;
+	}
+}
+
+static int vfio_pci_add_cap(struct vfio_device *vdev, u8 *virt_hdr,
+			    struct pci_cap_hdr *cap, off_t pos)
+{
+	struct pci_cap_hdr *last;
+	struct pci_device_header *hdr = &vdev->pci.hdr;
+
+	cap->next = 0;
+
+	if (!hdr->capabilities) {
+		hdr->capabilities = pos;
+		hdr->status |= PCI_STATUS_CAP_LIST;
+	} else {
+		last = PCI_CAP(virt_hdr, hdr->capabilities);
+
+		while (last->next)
+			last = PCI_CAP(virt_hdr, last->next);
+
+		last->next = pos;
+	}
+
+	memcpy(virt_hdr + pos, cap, vfio_pci_cap_size(cap));
+
+	return 0;
+}
+
 static int vfio_pci_parse_caps(struct vfio_device *vdev)
 {
+	int ret;
+	size_t size;
+	u8 pos, next;
+	struct pci_cap_hdr *cap;
+	u8 virt_hdr[PCI_DEV_CFG_SIZE];
 	struct vfio_pci_device *pdev = &vdev->pci;
 
 	if (!(pdev->hdr.status & PCI_STATUS_CAP_LIST))
 		return 0;
 
+	memset(virt_hdr, 0, PCI_DEV_CFG_SIZE);
+
+	pos = pdev->hdr.capabilities & ~3;
+
 	pdev->hdr.status &= ~PCI_STATUS_CAP_LIST;
 	pdev->hdr.capabilities = 0;
 
-	/* TODO: install virtual capabilities */
+	for (; pos; pos = next) {
+		if (pos >= PCI_DEV_CFG_SIZE) {
+			vfio_dev_warn(vdev, "ignoring cap outside of config space");
+			return -EINVAL;
+		}
+
+		cap = PCI_CAP(&pdev->hdr, pos);
+		next = cap->next;
+
+		switch (cap->type) {
+		case PCI_CAP_ID_MSIX:
+			ret = vfio_pci_add_cap(vdev, virt_hdr, cap, pos);
+			if (ret)
+				return ret;
+
+			pdev->msix.pos = pos;
+			pdev->irq_modes |= VFIO_PCI_IRQ_MODE_MSIX;
+			break;
+		}
+	}
+
+	/* Wipe remaining capabilities */
+	pos = PCI_STD_HEADER_SIZEOF;
+	size = PCI_DEV_CFG_SIZE - PCI_STD_HEADER_SIZEOF;
+	memcpy((void *)&pdev->hdr + pos, virt_hdr + pos, size);
 
 	return 0;
 }
 
 static int vfio_pci_parse_cfg_space(struct vfio_device *vdev)
 {
-	ssize_t sz = PCI_STD_HEADER_SIZEOF;
+	ssize_t sz = PCI_DEV_CFG_SIZE;
 	struct vfio_region_info *info;
 	struct vfio_pci_device *pdev = &vdev->pci;
 
@@ -89,6 +476,7 @@ static int vfio_pci_parse_cfg_space(struct vfio_device *vdev)
 		return -EINVAL;
 	}
 
+	/* Read standard headers and capabilities */
 	if (pread(vdev->fd, &pdev->hdr, sz, info->offset) != sz) {
 		vfio_dev_err(vdev, "failed to read %zd bytes of Config Space", sz);
 		return -EIO;
@@ -103,6 +491,9 @@ static int vfio_pci_parse_cfg_space(struct vfio_device *vdev)
 		return -EOPNOTSUPP;
 	}
 
+	if (pdev->hdr.irq_pin)
+		pdev->irq_modes |= VFIO_PCI_IRQ_MODE_INTX;
+
 	vfio_pci_parse_caps(vdev);
 
 	return 0;
@@ -112,6 +503,7 @@ static int vfio_pci_fixup_cfg_space(struct vfio_device *vdev)
 {
 	int i;
 	ssize_t hdr_sz;
+	struct msix_cap *msix;
 	struct vfio_region_info *info;
 	struct vfio_pci_device *pdev = &vdev->pci;
 
@@ -144,6 +536,22 @@ static int vfio_pci_fixup_cfg_space(struct vfio_device *vdev)
 	 */
 	pdev->hdr.exp_rom_bar = 0;
 
+	/* Plumb in our fake MSI-X capability, if we have it. */
+	msix = pci_find_cap(&pdev->hdr, PCI_CAP_ID_MSIX);
+	if (msix) {
+		/* Add a shortcut to the PBA region for the MMIO handler */
+		int pba_index = VFIO_PCI_BAR0_REGION_INDEX + pdev->msix_pba.bar;
+		pdev->msix_pba.offset = vdev->regions[pba_index].info.offset +
+					(msix->pba_offset & PCI_MSIX_PBA_OFFSET);
+
+		/* Tidy up the capability */
+		msix->table_offset &= PCI_MSIX_TABLE_BIR;
+		msix->pba_offset &= PCI_MSIX_PBA_BIR;
+		if (pdev->msix_table.bar == pdev->msix_pba.bar)
+			msix->pba_offset |= pdev->msix_table.size &
+					    PCI_MSIX_PBA_OFFSET;
+	}
+
 	/* Install our fake Configuration Space */
 	info = &vdev->regions[VFIO_PCI_CONFIG_REGION_INDEX].info;
 	hdr_sz = PCI_DEV_CFG_SIZE;
@@ -164,11 +572,84 @@ static int vfio_pci_fixup_cfg_space(struct vfio_device *vdev)
 	return 0;
 }
 
+static int vfio_pci_create_msix_table(struct kvm *kvm,
+				      struct vfio_pci_device *pdev)
+{
+	int ret;
+	size_t i;
+	size_t mmio_size;
+	size_t nr_entries;
+	struct vfio_pci_msi_entry *entries;
+	struct vfio_pci_msix_pba *pba = &pdev->msix_pba;
+	struct vfio_pci_msix_table *table = &pdev->msix_table;
+	struct msix_cap *msix = PCI_CAP(&pdev->hdr, pdev->msix.pos);
+
+	table->bar = msix->table_offset & PCI_MSIX_TABLE_BIR;
+	pba->bar = msix->pba_offset & PCI_MSIX_TABLE_BIR;
+
+	/*
+	 * KVM needs memory regions to be multiple of and aligned on PAGE_SIZE.
+	 */
+	nr_entries = (msix->ctrl & PCI_MSIX_FLAGS_QSIZE) + 1;
+	table->size = ALIGN(nr_entries * PCI_MSIX_ENTRY_SIZE, PAGE_SIZE);
+	pba->size = ALIGN(DIV_ROUND_UP(nr_entries, 64), PAGE_SIZE);
+
+	entries = calloc(nr_entries, sizeof(struct vfio_pci_msi_entry));
+	if (!entries)
+		return -ENOMEM;
+
+	for (i = 0; i < nr_entries; i++)
+		entries[i].config.ctrl = PCI_MSIX_ENTRY_CTRL_MASKBIT;
+
+	/*
+	 * To ease MSI-X cap configuration in case they share the same BAR,
+	 * collapse table and pending array. The size of the BAR regions must be
+	 * powers of two.
+	 */
+	mmio_size = roundup_pow_of_two(table->size + pba->size);
+	table->guest_phys_addr = pci_get_io_space_block(mmio_size);
+	if (!table->guest_phys_addr) {
+		pr_err("cannot allocate IO space");
+		ret = -ENOMEM;
+		goto out_free;
+	}
+	pba->guest_phys_addr = table->guest_phys_addr + table->size;
+
+	ret = kvm__register_mmio(kvm, table->guest_phys_addr, table->size,
+				 false, vfio_pci_msix_table_access, pdev);
+	if (ret < 0)
+		goto out_free;
+
+	/*
+	 * We could map the physical PBA directly into the guest, but it's
+	 * likely smaller than a page, and we can only hand full pages to the
+	 * guest. Even though the PCI spec disallows sharing a page used for
+	 * MSI-X with any other resource, it allows to share the same page
+	 * between MSI-X table and PBA. For the sake of isolation, create a
+	 * virtual PBA.
+	 */
+	ret = kvm__register_mmio(kvm, pba->guest_phys_addr, pba->size, false,
+				 vfio_pci_msix_pba_access, pdev);
+	if (ret < 0)
+		goto out_free;
+
+	pdev->msix.entries = entries;
+	pdev->msix.nr_entries = nr_entries;
+
+	return 0;
+
+out_free:
+	free(entries);
+
+	return ret;
+}
+
 static int vfio_pci_configure_bar(struct kvm *kvm, struct vfio_device *vdev,
 				  size_t nr)
 {
 	int ret;
 	size_t map_size;
+	struct vfio_pci_device *pdev = &vdev->pci;
 	struct vfio_region *region = &vdev->regions[nr];
 
 	if (nr >= vdev->info.num_regions)
@@ -190,6 +671,17 @@ static int vfio_pci_configure_bar(struct kvm *kvm, struct vfio_device *vdev,
 	if (!region->info.size)
 		return 0;
 
+	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSIX) {
+		/* Trap and emulate MSI-X table */
+		if (nr == pdev->msix_table.bar) {
+			region->guest_phys_addr = pdev->msix_table.guest_phys_addr;
+			return 0;
+		} else if (nr == pdev->msix_pba.bar) {
+			region->guest_phys_addr = pdev->msix_pba.guest_phys_addr;
+			return 0;
+		}
+	}
+
 	/* Grab some MMIO space in the guest */
 	map_size = ALIGN(region->info.size, PAGE_SIZE);
 	region->guest_phys_addr = pci_get_io_space_block(map_size);
@@ -218,6 +710,12 @@ static int vfio_pci_configure_dev_regions(struct kvm *kvm,
 	if (ret)
 		return ret;
 
+	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSIX) {
+		ret = vfio_pci_create_msix_table(kvm, pdev);
+		if (ret)
+			return ret;
+	}
+
 	for (i = VFIO_PCI_BAR0_REGION_INDEX; i <= VFIO_PCI_BAR5_REGION_INDEX; ++i) {
 		/* Ignore top half of 64-bit BAR */
 		if (i % 2 && is_64bit)
@@ -237,6 +735,122 @@ static int vfio_pci_configure_dev_regions(struct kvm *kvm,
 	return vfio_pci_fixup_cfg_space(vdev);
 }
 
+/*
+ * Attempt to update the FD limit, if opening an eventfd for each IRQ vector
+ * would hit the limit. Which is likely to happen when a device uses 2048 MSIs.
+ */
+static int vfio_pci_reserve_irq_fds(size_t num)
+{
+	/*
+	 * I counted around 27 fds under normal load. Let's add 100 for good
+	 * measure.
+	 */
+	static size_t needed = 128;
+	struct rlimit fd_limit, new_limit;
+
+	needed += num;
+
+	if (getrlimit(RLIMIT_NOFILE, &fd_limit)) {
+		perror("getrlimit(RLIMIT_NOFILE)");
+		return 0;
+	}
+
+	if (fd_limit.rlim_cur >= needed)
+		return 0;
+
+	new_limit.rlim_cur = needed;
+
+	if (fd_limit.rlim_max < needed)
+		/* Try to bump hard limit (root only) */
+		new_limit.rlim_max = needed;
+	else
+		new_limit.rlim_max = fd_limit.rlim_max;
+
+	if (setrlimit(RLIMIT_NOFILE, &new_limit)) {
+		perror("setrlimit(RLIMIT_NOFILE)");
+		pr_warning("not enough FDs for full MSI-X support (estimated need: %zu)",
+			   (size_t)(needed - fd_limit.rlim_cur));
+	}
+
+	return 0;
+}
+
+static int vfio_pci_init_msis(struct kvm *kvm, struct vfio_device *vdev,
+			     struct vfio_pci_msi_common *msis)
+{
+	int ret;
+	size_t i;
+	int *eventfds;
+	size_t irq_set_size;
+	struct vfio_pci_msi_entry *entry;
+	size_t nr_entries = msis->nr_entries;
+
+	ret = ioctl(vdev->fd, VFIO_DEVICE_GET_IRQ_INFO, &msis->info);
+	if (ret || &msis->info.count == 0) {
+		vfio_dev_err(vdev, "no MSI reported by VFIO");
+		return -ENODEV;
+	}
+
+	if (!(msis->info.flags & VFIO_IRQ_INFO_EVENTFD)) {
+		vfio_dev_err(vdev, "interrupt not EVENTFD capable");
+		return -EINVAL;
+	}
+
+	if (msis->info.count != nr_entries) {
+		vfio_dev_err(vdev, "invalid number of MSIs reported by VFIO");
+		return -EINVAL;
+	}
+
+	mutex_init(&msis->mutex);
+
+	vfio_pci_reserve_irq_fds(nr_entries);
+
+	irq_set_size = sizeof(struct vfio_irq_set) + nr_entries * sizeof(int);
+	msis->irq_set = malloc(irq_set_size);
+	if (!msis->irq_set)
+		return -ENOMEM;
+
+	*msis->irq_set = (struct vfio_irq_set) {
+		.argsz	= irq_set_size,
+		.flags 	= VFIO_IRQ_SET_DATA_EVENTFD |
+			  VFIO_IRQ_SET_ACTION_TRIGGER,
+		.index 	= msis->info.index,
+		.start 	= 0,
+		.count 	= nr_entries,
+	};
+
+	eventfds = (void *)msis->irq_set + sizeof(struct vfio_irq_set);
+
+	for (i = 0; i < nr_entries; i++) {
+		entry = &msis->entries[i];
+		entry->gsi = -1;
+		entry->eventfd = -1;
+		msi_set_masked(entry->virt_state, true);
+		msi_set_masked(entry->phys_state, true);
+		eventfds[i] = -1;
+	}
+
+	return 0;
+}
+
+static void vfio_pci_disable_intx(struct kvm *kvm, struct vfio_device *vdev)
+{
+	struct vfio_pci_device *pdev = &vdev->pci;
+	int gsi = pdev->intx_gsi;
+	struct vfio_irq_set irq_set = {
+		.argsz	= sizeof(irq_set),
+		.flags	= VFIO_IRQ_SET_DATA_NONE | VFIO_IRQ_SET_ACTION_TRIGGER,
+		.index	= VFIO_PCI_INTX_IRQ_INDEX,
+	};
+
+	pr_debug("user requested MSI, disabling INTx %d", gsi);
+
+	ioctl(vdev->fd, VFIO_DEVICE_SET_IRQS, &irq_set);
+	irq__del_irqfd(kvm, gsi, pdev->intx_fd);
+
+	close(pdev->intx_fd);
+}
+
 static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev)
 {
 	int ret;
@@ -251,6 +865,8 @@ static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev)
 		.index = VFIO_PCI_INTX_IRQ_INDEX,
 	};
 
+	vfio_pci_reserve_irq_fds(2);
+
 	ret = ioctl(vdev->fd, VFIO_DEVICE_GET_IRQ_INFO, &irq_info);
 	if (ret || irq_info.count == 0) {
 		vfio_dev_err(vdev, "no INTx reported by VFIO");
@@ -319,6 +935,10 @@ static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev)
 		goto err_remove_event;
 	}
 
+	pdev->intx_fd = trigger_fd;
+	/* Guest is going to ovewrite our irq_line... */
+	pdev->intx_gsi = gsi;
+
 	return 0;
 
 err_remove_event:
@@ -338,20 +958,23 @@ err_close:
 
 static int vfio_pci_configure_dev_irqs(struct kvm *kvm, struct vfio_device *vdev)
 {
+	int ret = 0;
 	struct vfio_pci_device *pdev = &vdev->pci;
 
-	struct vfio_irq_info irq_info = {
-		.argsz = sizeof(irq_info),
-		.index = VFIO_PCI_INTX_IRQ_INDEX,
-	};
-
-	if (!pdev->hdr.irq_pin) {
-		/* TODO: add MSI support */
-		vfio_dev_err(vdev, "INTx not available, MSI-X not implemented");
-		return -ENOSYS;
+	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSIX) {
+		pdev->msix.info = (struct vfio_irq_info) {
+			.argsz = sizeof(pdev->msix.info),
+			.index = VFIO_PCI_MSIX_IRQ_INDEX,
+		};
+		ret = vfio_pci_init_msis(kvm, vdev, &pdev->msix);
+		if (ret)
+			return ret;
 	}
 
-	return vfio_pci_enable_intx(kvm, vdev);
+	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_INTX)
+		ret = vfio_pci_enable_intx(kvm, vdev);
+
+	return ret;
 }
 
 int vfio_pci_setup_device(struct kvm *kvm, struct vfio_device *vdev)
@@ -387,9 +1010,13 @@ int vfio_pci_setup_device(struct kvm *kvm, struct vfio_device *vdev)
 void vfio_pci_teardown_device(struct kvm *kvm, struct vfio_device *vdev)
 {
 	size_t i;
+	struct vfio_pci_device *pdev = &vdev->pci;
 
 	for (i = 0; i < vdev->info.num_regions; i++)
 		vfio_unmap_region(kvm, &vdev->regions[i]);
 
 	device__unregister(&vdev->dev_hdr);
+
+	free(pdev->msix.irq_set);
+	free(pdev->msix.entries);
 }
-- 
2.17.0
