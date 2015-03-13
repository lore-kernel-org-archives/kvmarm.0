From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 01/12] KVM: Redesign kvm_io_bus_ API to pass VCPU structure to
 the callbacks.
Date: Fri, 13 Mar 2015 16:10:01 +0000
Message-ID: <1426263012-22935-2-git-send-email-andre.przywara@arm.com>
References: <1426263012-22935-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BE3D48C49
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Mar 2015 12:03:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cRrNPlglaJpr for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Mar 2015 12:03:49 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A01048C37
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Mar 2015 12:03:48 -0400 (EDT)
In-Reply-To: <1426263012-22935-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, pbonzini@redhat.com
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>

This is needed in e.g. ARM vGIC emulation, where the MMIO handling
depends on the VCPU that does the access.

Signed-off-by: Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Paolo Bonzini <pbonzini at redhat.com>
---
 arch/powerpc/kvm/mpic.c    |   10 ++++++----
 arch/powerpc/kvm/powerpc.c |    4 ++--
 arch/s390/kvm/diag.c       |    2 +-
 arch/x86/kvm/i8254.c       |   14 +++++++++-----
 arch/x86/kvm/i8259.c       |   12 ++++++------
 arch/x86/kvm/ioapic.c      |    8 ++++----
 arch/x86/kvm/lapic.c       |    4 ++--
 arch/x86/kvm/vmx.c         |    2 +-
 arch/x86/kvm/x86.c         |   13 +++++++------
 include/linux/kvm_host.h   |   10 +++++-----
 virt/kvm/coalesced_mmio.c  |    5 +++--
 virt/kvm/eventfd.c         |    4 ++--
 virt/kvm/iodev.h           |   23 +++++++++++++++--------
 virt/kvm/kvm_main.c        |   32 ++++++++++++++++----------------
 14 files changed, 79 insertions(+), 64 deletions(-)

diff --git a/arch/powerpc/kvm/mpic.c b/arch/powerpc/kvm/mpic.c
index 39b3a8f..8542f07 100644
--- a/arch/powerpc/kvm/mpic.c
+++ b/arch/powerpc/kvm/mpic.c
@@ -1374,8 +1374,9 @@ static int kvm_mpic_write_internal(struct openpic *opp, gpa_t addr, u32 val)
 	return -ENXIO;
 }
 
-static int kvm_mpic_read(struct kvm_io_device *this, gpa_t addr,
-			 int len, void *ptr)
+static int kvm_mpic_read(struct kvm_vcpu *vcpu,
+			 struct kvm_io_device *this,
+			 gpa_t addr, int len, void *ptr)
 {
 	struct openpic *opp = container_of(this, struct openpic, mmio);
 	int ret;
@@ -1415,8 +1416,9 @@ static int kvm_mpic_read(struct kvm_io_device *this, gpa_t addr,
 	return ret;
 }
 
-static int kvm_mpic_write(struct kvm_io_device *this, gpa_t addr,
-			  int len, const void *ptr)
+static int kvm_mpic_write(struct kvm_vcpu *vcpu,
+			  struct kvm_io_device *this,
+			  gpa_t addr, int len, const void *ptr)
 {
 	struct openpic *opp = container_of(this, struct openpic, mmio);
 	int ret;
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 27c0fac..24bfe40 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -807,7 +807,7 @@ int kvmppc_handle_load(struct kvm_run *run, struct kvm_vcpu *vcpu,
 
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 
-	ret = kvm_io_bus_read(vcpu->kvm, KVM_MMIO_BUS, run->mmio.phys_addr,
+	ret = kvm_io_bus_read(vcpu, KVM_MMIO_BUS, run->mmio.phys_addr,
 			      bytes, &run->mmio.data);
 
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
@@ -880,7 +880,7 @@ int kvmppc_handle_store(struct kvm_run *run, struct kvm_vcpu *vcpu,
 
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 
-	ret = kvm_io_bus_write(vcpu->kvm, KVM_MMIO_BUS, run->mmio.phys_addr,
+	ret = kvm_io_bus_write(vcpu, KVM_MMIO_BUS, run->mmio.phys_addr,
 			       bytes, &run->mmio.data);
 
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
index 9254aff..329ec75 100644
--- a/arch/s390/kvm/diag.c
+++ b/arch/s390/kvm/diag.c
@@ -213,7 +213,7 @@ static int __diag_virtio_hypercall(struct kvm_vcpu *vcpu)
 	 * - gpr 3 contains the virtqueue index (passed as datamatch)
 	 * - gpr 4 contains the index on the bus (optionally)
 	 */
-	ret = kvm_io_bus_write_cookie(vcpu->kvm, KVM_VIRTIO_CCW_NOTIFY_BUS,
+	ret = kvm_io_bus_write_cookie(vcpu, KVM_VIRTIO_CCW_NOTIFY_BUS,
 				      vcpu->run->s.regs.gprs[2] & 0xffffffff,
 				      8, &vcpu->run->s.regs.gprs[3],
 				      vcpu->run->s.regs.gprs[4]);
diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 298781d..4dce6f8 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -443,7 +443,8 @@ static inline int pit_in_range(gpa_t addr)
 		(addr < KVM_PIT_BASE_ADDRESS + KVM_PIT_MEM_LENGTH));
 }
 
-static int pit_ioport_write(struct kvm_io_device *this,
+static int pit_ioport_write(struct kvm_vcpu *vcpu,
+				struct kvm_io_device *this,
 			    gpa_t addr, int len, const void *data)
 {
 	struct kvm_pit *pit = dev_to_pit(this);
@@ -519,7 +520,8 @@ static int pit_ioport_write(struct kvm_io_device *this,
 	return 0;
 }
 
-static int pit_ioport_read(struct kvm_io_device *this,
+static int pit_ioport_read(struct kvm_vcpu *vcpu,
+			   struct kvm_io_device *this,
 			   gpa_t addr, int len, void *data)
 {
 	struct kvm_pit *pit = dev_to_pit(this);
@@ -589,7 +591,8 @@ static int pit_ioport_read(struct kvm_io_device *this,
 	return 0;
 }
 
-static int speaker_ioport_write(struct kvm_io_device *this,
+static int speaker_ioport_write(struct kvm_vcpu *vcpu,
+				struct kvm_io_device *this,
 				gpa_t addr, int len, const void *data)
 {
 	struct kvm_pit *pit = speaker_to_pit(this);
@@ -606,8 +609,9 @@ static int speaker_ioport_write(struct kvm_io_device *this,
 	return 0;
 }
 
-static int speaker_ioport_read(struct kvm_io_device *this,
-			       gpa_t addr, int len, void *data)
+static int speaker_ioport_read(struct kvm_vcpu *vcpu,
+				   struct kvm_io_device *this,
+				   gpa_t addr, int len, void *data)
 {
 	struct kvm_pit *pit = speaker_to_pit(this);
 	struct kvm_kpit_state *pit_state = &pit->pit_state;
diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index cc31f7c..8ff4eaa 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -528,42 +528,42 @@ static int picdev_read(struct kvm_pic *s,
 	return 0;
 }
 
-static int picdev_master_write(struct kvm_io_device *dev,
+static int picdev_master_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 			       gpa_t addr, int len, const void *val)
 {
 	return picdev_write(container_of(dev, struct kvm_pic, dev_master),
 			    addr, len, val);
 }
 
-static int picdev_master_read(struct kvm_io_device *dev,
+static int picdev_master_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 			      gpa_t addr, int len, void *val)
 {
 	return picdev_read(container_of(dev, struct kvm_pic, dev_master),
 			    addr, len, val);
 }
 
-static int picdev_slave_write(struct kvm_io_device *dev,
+static int picdev_slave_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 			      gpa_t addr, int len, const void *val)
 {
 	return picdev_write(container_of(dev, struct kvm_pic, dev_slave),
 			    addr, len, val);
 }
 
-static int picdev_slave_read(struct kvm_io_device *dev,
+static int picdev_slave_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 			     gpa_t addr, int len, void *val)
 {
 	return picdev_read(container_of(dev, struct kvm_pic, dev_slave),
 			    addr, len, val);
 }
 
-static int picdev_eclr_write(struct kvm_io_device *dev,
+static int picdev_eclr_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 			     gpa_t addr, int len, const void *val)
 {
 	return picdev_write(container_of(dev, struct kvm_pic, dev_eclr),
 			    addr, len, val);
 }
 
-static int picdev_eclr_read(struct kvm_io_device *dev,
+static int picdev_eclr_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 			    gpa_t addr, int len, void *val)
 {
 	return picdev_read(container_of(dev, struct kvm_pic, dev_eclr),
diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index b1947e0..8bf2e49 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -498,8 +498,8 @@ static inline int ioapic_in_range(struct kvm_ioapic *ioapic, gpa_t addr)
 		 (addr < ioapic->base_address + IOAPIC_MEM_LENGTH)));
 }
 
-static int ioapic_mmio_read(struct kvm_io_device *this, gpa_t addr, int len,
-			    void *val)
+static int ioapic_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
+				gpa_t addr, int len, void *val)
 {
 	struct kvm_ioapic *ioapic = to_ioapic(this);
 	u32 result;
@@ -541,8 +541,8 @@ static int ioapic_mmio_read(struct kvm_io_device *this, gpa_t addr, int len,
 	return 0;
 }
 
-static int ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, int len,
-			     const void *val)
+static int ioapic_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
+				 gpa_t addr, int len, const void *val)
 {
 	struct kvm_ioapic *ioapic = to_ioapic(this);
 	u32 data;
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e55b5fc..ba57bb7 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1038,7 +1038,7 @@ static int apic_mmio_in_range(struct kvm_lapic *apic, gpa_t addr)
 	    addr < apic->base_address + LAPIC_MMIO_LENGTH;
 }
 
-static int apic_mmio_read(struct kvm_io_device *this,
+static int apic_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
 			   gpa_t address, int len, void *data)
 {
 	struct kvm_lapic *apic = to_lapic(this);
@@ -1358,7 +1358,7 @@ static int apic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 	return ret;
 }
 
-static int apic_mmio_write(struct kvm_io_device *this,
+static int apic_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
 			    gpa_t address, int len, const void *data)
 {
 	struct kvm_lapic *apic = to_lapic(this);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f7b20b4..317da9b 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5822,7 +5822,7 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
 	gpa_t gpa;
 
 	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
-	if (!kvm_io_bus_write(vcpu->kvm, KVM_FAST_MMIO_BUS, gpa, 0, NULL)) {
+	if (!kvm_io_bus_write(vcpu, KVM_FAST_MMIO_BUS, gpa, 0, NULL)) {
 		skip_emulated_instruction(vcpu);
 		return 1;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bd7a70b..5573d63 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4115,8 +4115,8 @@ static int vcpu_mmio_write(struct kvm_vcpu *vcpu, gpa_t addr, int len,
 	do {
 		n = min(len, 8);
 		if (!(vcpu->arch.apic &&
-		      !kvm_iodevice_write(&vcpu->arch.apic->dev, addr, n, v))
-		    && kvm_io_bus_write(vcpu->kvm, KVM_MMIO_BUS, addr, n, v))
+		      !kvm_iodevice_write(vcpu, &vcpu->arch.apic->dev, addr, n, v))
+		    && kvm_io_bus_write(vcpu, KVM_MMIO_BUS, addr, n, v))
 			break;
 		handled += n;
 		addr += n;
@@ -4135,8 +4135,9 @@ static int vcpu_mmio_read(struct kvm_vcpu *vcpu, gpa_t addr, int len, void *v)
 	do {
 		n = min(len, 8);
 		if (!(vcpu->arch.apic &&
-		      !kvm_iodevice_read(&vcpu->arch.apic->dev, addr, n, v))
-		    && kvm_io_bus_read(vcpu->kvm, KVM_MMIO_BUS, addr, n, v))
+		      !kvm_iodevice_read(vcpu, &vcpu->arch.apic->dev,
+					 addr, n, v))
+		    && kvm_io_bus_read(vcpu, KVM_MMIO_BUS, addr, n, v))
 			break;
 		trace_kvm_mmio(KVM_TRACE_MMIO_READ, n, addr, *(u64 *)v);
 		handled += n;
@@ -4630,10 +4631,10 @@ static int kernel_pio(struct kvm_vcpu *vcpu, void *pd)
 	int r;
 
 	if (vcpu->arch.pio.in)
-		r = kvm_io_bus_read(vcpu->kvm, KVM_PIO_BUS, vcpu->arch.pio.port,
+		r = kvm_io_bus_read(vcpu, KVM_PIO_BUS, vcpu->arch.pio.port,
 				    vcpu->arch.pio.size, pd);
 	else
-		r = kvm_io_bus_write(vcpu->kvm, KVM_PIO_BUS,
+		r = kvm_io_bus_write(vcpu, KVM_PIO_BUS,
 				     vcpu->arch.pio.port, vcpu->arch.pio.size,
 				     pd);
 	return r;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ae9c720..9605e46 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -165,12 +165,12 @@ enum kvm_bus {
 	KVM_NR_BUSES
 };
 
-int kvm_io_bus_write(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
+int kvm_io_bus_write(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 		     int len, const void *val);
-int kvm_io_bus_write_cookie(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
-			    int len, const void *val, long cookie);
-int kvm_io_bus_read(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr, int len,
-		    void *val);
+int kvm_io_bus_write_cookie(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx,
+			    gpa_t addr, int len, const void *val, long cookie);
+int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
+		    int len, void *val);
 int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 			    int len, struct kvm_io_device *dev);
 int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 00d8642..c831a40 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -60,8 +60,9 @@ static int coalesced_mmio_has_room(struct kvm_coalesced_mmio_dev *dev)
 	return 1;
 }
 
-static int coalesced_mmio_write(struct kvm_io_device *this,
-				gpa_t addr, int len, const void *val)
+static int coalesced_mmio_write(struct kvm_vcpu *vcpu,
+				struct kvm_io_device *this, gpa_t addr,
+				int len, const void *val)
 {
 	struct kvm_coalesced_mmio_dev *dev = to_mmio(this);
 	struct kvm_coalesced_mmio_ring *ring = dev->kvm->coalesced_mmio_ring;
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index fc5f43e..26c72f3 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -715,8 +715,8 @@ ioeventfd_in_range(struct _ioeventfd *p, gpa_t addr, int len, const void *val)
 
 /* MMIO/PIO writes trigger an event if the addr/val match */
 static int
-ioeventfd_write(struct kvm_io_device *this, gpa_t addr, int len,
-		const void *val)
+ioeventfd_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
+		int len, const void *val)
 {
 	struct _ioeventfd *p = to_ioeventfd(this);
 
diff --git a/virt/kvm/iodev.h b/virt/kvm/iodev.h
index 12fd3ca..9ef709c 100644
--- a/virt/kvm/iodev.h
+++ b/virt/kvm/iodev.h
@@ -20,6 +20,7 @@
 #include <asm/errno.h>
 
 struct kvm_io_device;
+struct kvm_vcpu;
 
 /**
  * kvm_io_device_ops are called under kvm slots_lock.
@@ -27,11 +28,13 @@ struct kvm_io_device;
  * or non-zero to have it passed to the next device.
  **/
 struct kvm_io_device_ops {
-	int (*read)(struct kvm_io_device *this,
+	int (*read)(struct kvm_vcpu *vcpu,
+		    struct kvm_io_device *this,
 		    gpa_t addr,
 		    int len,
 		    void *val);
-	int (*write)(struct kvm_io_device *this,
+	int (*write)(struct kvm_vcpu *vcpu,
+		     struct kvm_io_device *this,
 		     gpa_t addr,
 		     int len,
 		     const void *val);
@@ -49,16 +52,20 @@ static inline void kvm_iodevice_init(struct kvm_io_device *dev,
 	dev->ops = ops;
 }
 
-static inline int kvm_iodevice_read(struct kvm_io_device *dev,
-				    gpa_t addr, int l, void *v)
+static inline int kvm_iodevice_read(struct kvm_vcpu *vcpu,
+				    struct kvm_io_device *dev, gpa_t addr,
+				    int l, void *v)
 {
-	return dev->ops->read ? dev->ops->read(dev, addr, l, v) : -EOPNOTSUPP;
+	return dev->ops->read ? dev->ops->read(vcpu, dev, addr, l, v)
+				: -EOPNOTSUPP;
 }
 
-static inline int kvm_iodevice_write(struct kvm_io_device *dev,
-				     gpa_t addr, int l, const void *v)
+static inline int kvm_iodevice_write(struct kvm_vcpu *vcpu,
+				     struct kvm_io_device *dev, gpa_t addr,
+				     int l, const void *v)
 {
-	return dev->ops->write ? dev->ops->write(dev, addr, l, v) : -EOPNOTSUPP;
+	return dev->ops->write ? dev->ops->write(vcpu, dev, addr, l, v)
+				 : -EOPNOTSUPP;
 }
 
 static inline void kvm_iodevice_destructor(struct kvm_io_device *dev)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a109370..ce86493 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2997,7 +2997,7 @@ static int kvm_io_bus_get_first_dev(struct kvm_io_bus *bus,
 	return off;
 }
 
-static int __kvm_io_bus_write(struct kvm_io_bus *bus,
+static int __kvm_io_bus_write(struct kvm_vcpu *vcpu, struct kvm_io_bus *bus,
 			      struct kvm_io_range *range, const void *val)
 {
 	int idx;
@@ -3008,7 +3008,7 @@ static int __kvm_io_bus_write(struct kvm_io_bus *bus,
 
 	while (idx < bus->dev_count &&
 		kvm_io_bus_cmp(range, &bus->range[idx]) == 0) {
-		if (!kvm_iodevice_write(bus->range[idx].dev, range->addr,
+		if (!kvm_iodevice_write(vcpu, bus->range[idx].dev, range->addr,
 					range->len, val))
 			return idx;
 		idx++;
@@ -3018,7 +3018,7 @@ static int __kvm_io_bus_write(struct kvm_io_bus *bus,
 }
 
 /* kvm_io_bus_write - called under kvm->slots_lock */
-int kvm_io_bus_write(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
+int kvm_io_bus_write(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 		     int len, const void *val)
 {
 	struct kvm_io_bus *bus;
@@ -3030,14 +3030,14 @@ int kvm_io_bus_write(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 		.len = len,
 	};
 
-	bus = srcu_dereference(kvm->buses[bus_idx], &kvm->srcu);
-	r = __kvm_io_bus_write(bus, &range, val);
+	bus = srcu_dereference(vcpu->kvm->buses[bus_idx], &kvm->srcu);
+	r = __kvm_io_bus_write(vcpu, bus, &range, val);
 	return r < 0 ? r : 0;
 }
 
 /* kvm_io_bus_write_cookie - called under kvm->slots_lock */
-int kvm_io_bus_write_cookie(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
-			    int len, const void *val, long cookie)
+int kvm_io_bus_write_cookie(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx,
+			    gpa_t addr, int len, const void *val, long cookie)
 {
 	struct kvm_io_bus *bus;
 	struct kvm_io_range range;
@@ -3047,12 +3047,12 @@ int kvm_io_bus_write_cookie(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 		.len = len,
 	};
 
-	bus = srcu_dereference(kvm->buses[bus_idx], &kvm->srcu);
+	bus = srcu_dereference(vcpu->kvm->buses[bus_idx], &kvm->srcu);
 
 	/* First try the device referenced by cookie. */
 	if ((cookie >= 0) && (cookie < bus->dev_count) &&
 	    (kvm_io_bus_cmp(&range, &bus->range[cookie]) == 0))
-		if (!kvm_iodevice_write(bus->range[cookie].dev, addr, len,
+		if (!kvm_iodevice_write(vcpu, bus->range[cookie].dev, addr, len,
 					val))
 			return cookie;
 
@@ -3060,11 +3060,11 @@ int kvm_io_bus_write_cookie(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 	 * cookie contained garbage; fall back to search and return the
 	 * correct cookie value.
 	 */
-	return __kvm_io_bus_write(bus, &range, val);
+	return __kvm_io_bus_write(vcpu, bus, &range, val);
 }
 
-static int __kvm_io_bus_read(struct kvm_io_bus *bus, struct kvm_io_range *range,
-			     void *val)
+static int __kvm_io_bus_read(struct kvm_vcpu *vcpu, struct kvm_io_bus *bus,
+			     struct kvm_io_range *range, void *val)
 {
 	int idx;
 
@@ -3074,7 +3074,7 @@ static int __kvm_io_bus_read(struct kvm_io_bus *bus, struct kvm_io_range *range,
 
 	while (idx < bus->dev_count &&
 		kvm_io_bus_cmp(range, &bus->range[idx]) == 0) {
-		if (!kvm_iodevice_read(bus->range[idx].dev, range->addr,
+		if (!kvm_iodevice_read(vcpu, bus->range[idx].dev, range->addr,
 				       range->len, val))
 			return idx;
 		idx++;
@@ -3085,7 +3085,7 @@ static int __kvm_io_bus_read(struct kvm_io_bus *bus, struct kvm_io_range *range,
 EXPORT_SYMBOL_GPL(kvm_io_bus_write);
 
 /* kvm_io_bus_read - called under kvm->slots_lock */
-int kvm_io_bus_read(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
+int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 		    int len, void *val)
 {
 	struct kvm_io_bus *bus;
@@ -3097,8 +3097,8 @@ int kvm_io_bus_read(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 		.len = len,
 	};
 
-	bus = srcu_dereference(kvm->buses[bus_idx], &kvm->srcu);
-	r = __kvm_io_bus_read(bus, &range, val);
+	bus = srcu_dereference(vcpu->kvm->buses[bus_idx], &kvm->srcu);
+	r = __kvm_io_bus_read(vcpu, bus, &range, val);
 	return r < 0 ? r : 0;
 }
 
-- 
1.7.9.5
