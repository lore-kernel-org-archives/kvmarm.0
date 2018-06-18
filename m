From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: [PATCH v6 kvmtool 03/13] irq: add irqfd helpers
Date: Mon, 18 Jun 2018 19:42:01 +0100
Message-ID: <20180618184211.43904-4-jean-philippe.brucker@arm.com>
References: <20180618184211.43904-1-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E46C4A0EC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jun 2018 14:31:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nASyb9+-rh8G for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jun 2018 14:31:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3FC64A0D7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jun 2018 14:31:28 -0400 (EDT)
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

Add helpers to add and remove IRQFD routing for both irqchips and MSIs.
We have to make a special case of IRQ lines on ARM where the
initialisation order goes like this:

 (1) Devices reserve their IRQ lines
 (2) VGIC is setup with VGIC_CTRL_INIT (in a late_init call)
 (3) MSIs are reserved lazily, when the guest needs them

Since we cannot setup IRQFD before (2), store the IRQFD routing for IRQ
lines temporarily until we're ready to submit them.

Reviewed-by: Punit Agrawal <punit.agrawal@arm.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 arm/gic.c                    | 76 +++++++++++++++++++++++++++++++++++-
 arm/include/arm-common/gic.h |  6 +++
 hw/pci-shmem.c               |  8 +---
 include/kvm/irq.h            | 17 ++++++++
 irq.c                        | 31 +++++++++++++++
 virtio/net.c                 |  9 +----
 virtio/scsi.c                | 10 ++---
 7 files changed, 135 insertions(+), 22 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 238a75c70..abcbcc091 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -17,6 +17,16 @@ static u64 gic_redists_base;
 static u64 gic_redists_size;
 static u64 gic_msi_base;
 static u64 gic_msi_size = 0;
+static bool vgic_is_init = false;
+
+struct kvm_irqfd_line {
+	unsigned int		gsi;
+	int			trigger_fd;
+	int			resample_fd;
+	struct list_head	list;
+};
+
+static LIST_HEAD(irqfd_lines);
 
 int irqchip_parser(const struct option *opt, const char *arg, int unset)
 {
@@ -38,6 +48,26 @@ int irqchip_parser(const struct option *opt, const char *arg, int unset)
 	return 0;
 }
 
+static int irq__setup_irqfd_lines(struct kvm *kvm)
+{
+	int ret;
+	struct kvm_irqfd_line *line, *tmp;
+
+	list_for_each_entry_safe(line, tmp, &irqfd_lines, list) {
+		ret = irq__common_add_irqfd(kvm, line->gsi, line->trigger_fd,
+					    line->resample_fd);
+		if (ret < 0) {
+			pr_err("Failed to register IRQFD");
+			return ret;
+		}
+
+		list_del(&line->list);
+		free(line);
+	}
+
+	return 0;
+}
+
 static int irq__routing_init(struct kvm *kvm)
 {
 	int r;
@@ -292,7 +322,9 @@ static int gic__init_gic(struct kvm *kvm)
 	kvm->msix_needs_devid = kvm__supports_vm_extension(kvm,
 							   KVM_CAP_MSI_DEVID);
 
-	return 0;
+	vgic_is_init = true;
+
+	return irq__setup_irqfd_lines(kvm);
 }
 late_init(gic__init_gic)
 
@@ -372,3 +404,45 @@ void kvm__irq_trigger(struct kvm *kvm, int irq)
 	kvm__irq_line(kvm, irq, VIRTIO_IRQ_HIGH);
 	kvm__irq_line(kvm, irq, VIRTIO_IRQ_LOW);
 }
+
+int gic__add_irqfd(struct kvm *kvm, unsigned int gsi, int trigger_fd,
+		   int resample_fd)
+{
+	struct kvm_irqfd_line *line;
+
+	if (vgic_is_init)
+		return irq__common_add_irqfd(kvm, gsi, trigger_fd, resample_fd);
+
+	/* Postpone the routing setup until we have a distributor */
+	line = malloc(sizeof(*line));
+	if (!line)
+		return -ENOMEM;
+
+	*line = (struct kvm_irqfd_line) {
+		.gsi		= gsi,
+		.trigger_fd	= trigger_fd,
+		.resample_fd	= resample_fd,
+	};
+	list_add(&line->list, &irqfd_lines);
+
+	return 0;
+}
+
+void gic__del_irqfd(struct kvm *kvm, unsigned int gsi, int trigger_fd)
+{
+	struct kvm_irqfd_line *line;
+
+	if (vgic_is_init) {
+		irq__common_del_irqfd(kvm, gsi, trigger_fd);
+		return;
+	}
+
+	list_for_each_entry(line, &irqfd_lines, list) {
+		if (line->gsi != gsi)
+			continue;
+
+		list_del(&line->list);
+		free(line);
+		break;
+	}
+}
diff --git a/arm/include/arm-common/gic.h b/arm/include/arm-common/gic.h
index ae253c059..1125d601f 100644
--- a/arm/include/arm-common/gic.h
+++ b/arm/include/arm-common/gic.h
@@ -37,4 +37,10 @@ int gic__create(struct kvm *kvm, enum irqchip_type type);
 int gic__create_gicv2m_frame(struct kvm *kvm, u64 msi_frame_addr);
 void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type);
 
+int gic__add_irqfd(struct kvm *kvm, unsigned int gsi, int trigger_fd,
+		   int resample_fd);
+void gic__del_irqfd(struct kvm *kvm, unsigned int gsi, int trigger_fd);
+#define irq__add_irqfd gic__add_irqfd
+#define irq__del_irqfd gic__del_irqfd
+
 #endif /* ARM_COMMON__GIC_H */
diff --git a/hw/pci-shmem.c b/hw/pci-shmem.c
index 512b5b069..107043e9d 100644
--- a/hw/pci-shmem.c
+++ b/hw/pci-shmem.c
@@ -127,7 +127,6 @@ static void callback_mmio_msix(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len
 int pci_shmem__get_local_irqfd(struct kvm *kvm)
 {
 	int fd, gsi, r;
-	struct kvm_irqfd irqfd;
 
 	if (local_fd == 0) {
 		fd = eventfd(0, 0);
@@ -143,12 +142,7 @@ int pci_shmem__get_local_irqfd(struct kvm *kvm)
 			gsi = pci_shmem_pci_device.irq_line;
 		}
 
-		irqfd = (struct kvm_irqfd) {
-			.fd = fd,
-			.gsi = gsi,
-		};
-
-		r = ioctl(kvm->vm_fd, KVM_IRQFD, &irqfd);
+		r = irq__add_irqfd(kvm, gsi, fd, -1);
 		if (r < 0)
 			return r;
 
diff --git a/include/kvm/irq.h b/include/kvm/irq.h
index 8ba8b7405..2a3f8c9dc 100644
--- a/include/kvm/irq.h
+++ b/include/kvm/irq.h
@@ -7,6 +7,7 @@
 #include <linux/list.h>
 #include <linux/kvm.h>
 
+#include "kvm/kvm-arch.h"
 #include "kvm/msi.h"
 
 struct kvm;
@@ -35,4 +36,20 @@ void irq__update_msix_route(struct kvm *kvm, u32 gsi, struct msi_msg *msg);
 bool irq__can_signal_msi(struct kvm *kvm);
 int irq__signal_msi(struct kvm *kvm, struct kvm_msi *msi);
 
+/*
+ * The function takes two eventfd arguments, trigger_fd and resample_fd. If
+ * resample_fd is <= 0, resampling is disabled and the IRQ is edge-triggered
+ */
+int irq__common_add_irqfd(struct kvm *kvm, unsigned int gsi, int trigger_fd,
+			   int resample_fd);
+void irq__common_del_irqfd(struct kvm *kvm, unsigned int gsi, int trigger_fd);
+
+#ifndef irq__add_irqfd
+#define irq__add_irqfd irq__common_add_irqfd
+#endif
+
+#ifndef irq__del_irqfd
+#define irq__del_irqfd irq__common_del_irqfd
+#endif
+
 #endif
diff --git a/irq.c b/irq.c
index c89604cc1..cdcf99233 100644
--- a/irq.c
+++ b/irq.c
@@ -170,6 +170,37 @@ void irq__update_msix_route(struct kvm *kvm, u32 gsi, struct msi_msg *msg)
 		die_perror("KVM_SET_GSI_ROUTING");
 }
 
+int irq__common_add_irqfd(struct kvm *kvm, unsigned int gsi, int trigger_fd,
+			   int resample_fd)
+{
+	struct kvm_irqfd irqfd = {
+		.fd		= trigger_fd,
+		.gsi		= gsi,
+		.flags		= resample_fd > 0 ? KVM_IRQFD_FLAG_RESAMPLE : 0,
+		.resamplefd	= resample_fd,
+	};
+
+	/* If we emulate MSI routing, translate the MSI to the corresponding IRQ */
+	if (msi_routing_ops->translate_gsi)
+		irqfd.gsi = msi_routing_ops->translate_gsi(kvm, gsi);
+
+	return ioctl(kvm->vm_fd, KVM_IRQFD, &irqfd);
+}
+
+void irq__common_del_irqfd(struct kvm *kvm, unsigned int gsi, int trigger_fd)
+{
+	struct kvm_irqfd irqfd = {
+		.fd		= trigger_fd,
+		.gsi		= gsi,
+		.flags		= KVM_IRQFD_FLAG_DEASSIGN,
+	};
+
+	if (msi_routing_ops->translate_gsi)
+		irqfd.gsi = msi_routing_ops->translate_gsi(kvm, gsi);
+
+	ioctl(kvm->vm_fd, KVM_IRQFD, &irqfd);
+}
+
 int __attribute__((weak)) irq__exit(struct kvm *kvm)
 {
 	free(irq_routing);
diff --git a/virtio/net.c b/virtio/net.c
index 419a5e301..f95258caa 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -602,23 +602,18 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
 {
 	struct net_dev *ndev = dev;
-	struct kvm_irqfd irq;
 	struct vhost_vring_file file;
 	int r;
 
 	if (ndev->vhost_fd == 0)
 		return;
 
-	irq = (struct kvm_irqfd) {
-		.gsi	= gsi,
-		.fd	= eventfd(0, 0),
-	};
 	file = (struct vhost_vring_file) {
 		.index	= vq,
-		.fd	= irq.fd,
+		.fd	= eventfd(0, 0),
 	};
 
-	r = ioctl(kvm->vm_fd, KVM_IRQFD, &irq);
+	r = irq__add_irqfd(kvm, gsi, file.fd, -1);
 	if (r < 0)
 		die_perror("KVM_IRQFD failed");
 
diff --git a/virtio/scsi.c b/virtio/scsi.c
index 58d2353a1..a429ac85a 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -1,6 +1,7 @@
 #include "kvm/virtio-scsi.h"
 #include "kvm/virtio-pci-dev.h"
 #include "kvm/disk-image.h"
+#include "kvm/irq.h"
 #include "kvm/kvm.h"
 #include "kvm/pci.h"
 #include "kvm/ioeventfd.h"
@@ -97,22 +98,17 @@ static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
 {
 	struct vhost_vring_file file;
 	struct scsi_dev *sdev = dev;
-	struct kvm_irqfd irq;
 	int r;
 
 	if (sdev->vhost_fd == 0)
 		return;
 
-	irq = (struct kvm_irqfd) {
-		.gsi	= gsi,
-		.fd	= eventfd(0, 0),
-	};
 	file = (struct vhost_vring_file) {
 		.index	= vq,
-		.fd	= irq.fd,
+		.fd	= eventfd(0, 0),
 	};
 
-	r = ioctl(kvm->vm_fd, KVM_IRQFD, &irq);
+	r = irq__add_irqfd(kvm, gsi, file.fd, -1);
 	if (r < 0)
 		die_perror("KVM_IRQFD failed");
 
-- 
2.17.0
