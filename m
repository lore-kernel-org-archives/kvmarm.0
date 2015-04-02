From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 22/27] KVM: arm/arm64: implement kvm_io_bus MMIO handling for the VGIC
Date: Thu,  2 Apr 2015 11:05:26 +0100
Message-ID: <1427969131-8445-23-git-send-email-marc.zyngier@arm.com>
References: <1427969131-8445-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1427969131-8445-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

Currently we use a lot of VGIC specific code to do the MMIO
dispatching.
Use the previous reworks to add kvm_io_bus style MMIO handlers.

Those are not yet called by the MMIO abort handler, also the actual
VGIC emulator function do not make use of it yet, but will be enabled
with the following patches.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_vgic.h |   9 ++++
 virt/kvm/arm/vgic.c    | 129 +++++++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic.h    |   7 +++
 3 files changed, 145 insertions(+)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 9092fad..f90140c 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -24,6 +24,7 @@
 #include <linux/irqreturn.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
+#include <kvm/iodev.h>
 
 #define VGIC_NR_IRQS_LEGACY	256
 #define VGIC_NR_SGIS		16
@@ -147,6 +148,14 @@ struct vgic_vm_ops {
 	int	(*map_resources)(struct kvm *, const struct vgic_params *);
 };
 
+struct vgic_io_device {
+	gpa_t addr;
+	int len;
+	const struct vgic_io_range *reg_ranges;
+	struct kvm_vcpu *redist_vcpu;
+	struct kvm_io_device dev;
+};
+
 struct vgic_dist {
 	spinlock_t		lock;
 	bool			in_kernel;
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 8802ad7..e968179 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -32,6 +32,8 @@
 #include <asm/kvm_arm.h>
 #include <asm/kvm_mmu.h>
 #include <trace/events/kvm.h>
+#include <asm/kvm.h>
+#include <kvm/iodev.h>
 
 /*
  * How the whole thing works (courtesy of Christoffer Dall):
@@ -837,6 +839,66 @@ bool vgic_handle_mmio_range(struct kvm_vcpu *vcpu, struct kvm_run *run,
 }
 
 /**
+ * vgic_handle_mmio_access - handle an in-kernel MMIO access
+ * This is called by the read/write KVM IO device wrappers below.
+ * @vcpu:	pointer to the vcpu performing the access
+ * @this:	pointer to the KVM IO device in charge
+ * @addr:	guest physical address of the access
+ * @len:	size of the access
+ * @val:	pointer to the data region
+ * @is_write:	read or write access
+ *
+ * returns true if the MMIO access could be performed
+ */
+static int vgic_handle_mmio_access(struct kvm_vcpu *vcpu,
+				   struct kvm_io_device *this, gpa_t addr,
+				   int len, void *val, bool is_write)
+{
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	struct vgic_io_device *iodev = container_of(this,
+						    struct vgic_io_device, dev);
+	struct kvm_run *run = vcpu->run;
+	const struct vgic_io_range *range;
+	struct kvm_exit_mmio mmio;
+	bool updated_state;
+	gpa_t offset;
+
+	offset = addr - iodev->addr;
+	range = vgic_find_range(iodev->reg_ranges, len, offset);
+	if (unlikely(!range || !range->handle_mmio)) {
+		pr_warn("Unhandled access %d %08llx %d\n", is_write, addr, len);
+		return -ENXIO;
+	}
+
+	mmio.phys_addr = addr;
+	mmio.len = len;
+	mmio.is_write = is_write;
+	if (is_write)
+		memcpy(mmio.data, val, len);
+	mmio.private = iodev->redist_vcpu;
+
+	spin_lock(&dist->lock);
+	offset -= range->base;
+	if (vgic_validate_access(dist, range, offset)) {
+		updated_state = call_range_handler(vcpu, &mmio, offset, range);
+		if (!is_write)
+			memcpy(val, mmio.data, len);
+	} else {
+		if (!is_write)
+			memset(val, 0, len);
+		updated_state = false;
+	}
+	spin_unlock(&dist->lock);
+	kvm_prepare_mmio(run, &mmio);
+	kvm_handle_mmio_return(vcpu, run);
+
+	if (updated_state)
+		vgic_kick_vcpus(vcpu->kvm);
+
+	return 0;
+}
+
+/**
  * vgic_handle_mmio - handle an in-kernel MMIO access for the GIC emulation
  * @vcpu:      pointer to the vcpu performing the access
  * @run:       pointer to the kvm_run structure
@@ -860,6 +922,73 @@ bool vgic_handle_mmio(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	return vcpu->kvm->arch.vgic.vm_ops.handle_mmio(vcpu, run, mmio);
 }
 
+static int vgic_handle_mmio_read(struct kvm_vcpu *vcpu,
+				 struct kvm_io_device *this,
+				 gpa_t addr, int len, void *val)
+{
+	return vgic_handle_mmio_access(vcpu, this, addr, len, val, false);
+}
+
+static int vgic_handle_mmio_write(struct kvm_vcpu *vcpu,
+				  struct kvm_io_device *this,
+				  gpa_t addr, int len, const void *val)
+{
+	return vgic_handle_mmio_access(vcpu, this, addr, len, (void *)val,
+				       true);
+}
+
+struct kvm_io_device_ops vgic_io_ops = {
+	.read	= vgic_handle_mmio_read,
+	.write	= vgic_handle_mmio_write,
+};
+
+/**
+ * vgic_register_kvm_io_dev - register VGIC register frame on the KVM I/O bus
+ * @kvm:            The VM structure pointer
+ * @base:           The (guest) base address for the register frame
+ * @len:            Length of the register frame window
+ * @ranges:         Describing the handler functions for each register
+ * @redist_vcpu_id: The VCPU ID to pass on to the handlers on call
+ * @iodev:          Points to memory to be passed on to the handler
+ *
+ * @iodev stores the parameters of this function to be usable by the handler
+ * respectively the dispatcher function (since the KVM I/O bus framework lacks
+ * an opaque parameter). Initialization is done in this function, but the
+ * reference should be valid and unique for the whole VGIC lifetime.
+ * If the register frame is not mapped for a specific VCPU, pass -1 to
+ * @redist_vcpu_id.
+ */
+int vgic_register_kvm_io_dev(struct kvm *kvm, gpa_t base, int len,
+			     const struct vgic_io_range *ranges,
+			     int redist_vcpu_id,
+			     struct vgic_io_device *iodev)
+{
+	struct kvm_vcpu *vcpu = NULL;
+	int ret;
+
+	if (redist_vcpu_id >= 0)
+		vcpu = kvm_get_vcpu(kvm, redist_vcpu_id);
+
+	iodev->addr		= base;
+	iodev->len		= len;
+	iodev->reg_ranges	= ranges;
+	iodev->redist_vcpu	= vcpu;
+
+	kvm_iodevice_init(&iodev->dev, &vgic_io_ops);
+
+	mutex_lock(&kvm->slots_lock);
+
+	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, base, len,
+				      &iodev->dev);
+	mutex_unlock(&kvm->slots_lock);
+
+	/* Mark the iodev as invalid if registration fails. */
+	if (ret)
+		iodev->dev.ops = NULL;
+
+	return ret;
+}
+
 static int vgic_nr_shared_irqs(struct vgic_dist *dist)
 {
 	return dist->nr_irqs - VGIC_NR_PRIVATE_IRQS;
diff --git a/virt/kvm/arm/vgic.h b/virt/kvm/arm/vgic.h
index 01aa622..28fa3aa 100644
--- a/virt/kvm/arm/vgic.h
+++ b/virt/kvm/arm/vgic.h
@@ -20,6 +20,8 @@
 #ifndef __KVM_VGIC_H__
 #define __KVM_VGIC_H__
 
+#include <kvm/iodev.h>
+
 #define VGIC_ADDR_UNDEF		(-1)
 #define IS_VGIC_ADDR_UNDEF(_x)  ((_x) == VGIC_ADDR_UNDEF)
 
@@ -82,6 +84,11 @@ struct vgic_io_range {
 			    phys_addr_t offset);
 };
 
+int vgic_register_kvm_io_dev(struct kvm *kvm, gpa_t base, int len,
+			     const struct vgic_io_range *ranges,
+			     int redist_id,
+			     struct vgic_io_device *iodev);
+
 static inline bool is_in_range(phys_addr_t addr, unsigned long len,
 			       phys_addr_t baseaddr, unsigned long size)
 {
-- 
2.1.4

