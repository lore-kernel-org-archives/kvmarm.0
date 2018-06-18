From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: [PATCH v6 kvmtool 04/13] Extend memory bank API with memory types
Date: Mon, 18 Jun 2018 19:42:02 +0100
Message-ID: <20180618184211.43904-5-jean-philippe.brucker@arm.com>
References: <20180618184211.43904-1-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 49B444A0EC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jun 2018 14:31:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d6TcfFlccTXI for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jun 2018 14:31:30 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3DD74A0D9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jun 2018 14:31:30 -0400 (EDT)
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

Introduce memory types RAM and DEVICE, along with a way for subsystems to
query the global memory banks. This is required by VFIO, which will need
to pin and map guest RAM so that assigned devices can safely do DMA to it.
Depending on the architecture, the physical map is made of either one or
two RAM regions. In addition, this new memory types API paves the way to
reserved memory regions introduced in a subsequent patch.

For the moment we put vesa and ivshmem memory into the DEVICE category, so
they don't have to be pinned. This means that physical devices assigned
with VFIO won't be able to DMA to the vesa frame buffer or ivshmem. In
order to do that, simply changing the type to "RAM" would work. But to
keep the types consistent, it would be better to introduce flags such as
KVM_MEM_TYPE_DMA that would complement both RAM and DEVICE type. We could
then reuse the API for generating firmware information (that is, for x86
bios; DT supports reserved-memory description).

Reviewed-by: Punit Agrawal <punit.agrawal@arm.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 arm/kvm.c         |  2 +-
 hw/pci-shmem.c    |  4 ++--
 hw/vesa.c         |  2 +-
 include/kvm/kvm.h | 44 +++++++++++++++++++++++++++++++++++++++++++-
 kvm.c             | 31 ++++++++++++++++++++++++++++++-
 mips/kvm.c        |  6 +++---
 powerpc/kvm.c     |  2 +-
 x86/kvm.c         |  6 +++---
 8 files changed, 84 insertions(+), 13 deletions(-)

diff --git a/arm/kvm.c b/arm/kvm.c
index 2ab436e8d..b824f637e 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -34,7 +34,7 @@ void kvm__init_ram(struct kvm *kvm)
 	phys_size	= kvm->ram_size;
 	host_mem	= kvm->ram_start;
 
-	err = kvm__register_mem(kvm, phys_start, phys_size, host_mem);
+	err = kvm__register_ram(kvm, phys_start, phys_size, host_mem);
 	if (err)
 		die("Failed to register %lld bytes of memory at physical "
 		    "address 0x%llx [err %d]", phys_size, phys_start, err);
diff --git a/hw/pci-shmem.c b/hw/pci-shmem.c
index 107043e9d..f92bc7554 100644
--- a/hw/pci-shmem.c
+++ b/hw/pci-shmem.c
@@ -387,8 +387,8 @@ int pci_shmem__init(struct kvm *kvm)
 	if (mem == NULL)
 		return -EINVAL;
 
-	kvm__register_mem(kvm, shmem_region->phys_addr, shmem_region->size,
-			  mem);
+	kvm__register_dev_mem(kvm, shmem_region->phys_addr, shmem_region->size,
+			      mem);
 	return 0;
 }
 dev_init(pci_shmem__init);
diff --git a/hw/vesa.c b/hw/vesa.c
index a9a1d3e2c..f3c5114cf 100644
--- a/hw/vesa.c
+++ b/hw/vesa.c
@@ -73,7 +73,7 @@ struct framebuffer *vesa__init(struct kvm *kvm)
 	if (mem == MAP_FAILED)
 		ERR_PTR(-errno);
 
-	kvm__register_mem(kvm, VESA_MEM_ADDR, VESA_MEM_SIZE, mem);
+	kvm__register_dev_mem(kvm, VESA_MEM_ADDR, VESA_MEM_SIZE, mem);
 
 	vesafb = (struct framebuffer) {
 		.width			= VESA_WIDTH,
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 90463b8c3..19f7d265c 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -34,6 +34,14 @@ enum {
 	KVM_VMSTATE_PAUSED,
 };
 
+enum kvm_mem_type {
+	KVM_MEM_TYPE_RAM	= 1 << 0,
+	KVM_MEM_TYPE_DEVICE	= 1 << 1,
+
+	KVM_MEM_TYPE_ALL	= KVM_MEM_TYPE_RAM
+				| KVM_MEM_TYPE_DEVICE
+};
+
 struct kvm_ext {
 	const char *name;
 	int code;
@@ -44,6 +52,7 @@ struct kvm_mem_bank {
 	u64			guest_phys_addr;
 	void			*host_addr;
 	u64			size;
+	enum kvm_mem_type	type;
 };
 
 struct kvm {
@@ -90,7 +99,22 @@ void kvm__irq_line(struct kvm *kvm, int irq, int level);
 void kvm__irq_trigger(struct kvm *kvm, int irq);
 bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data, int direction, int size, u32 count);
 bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data, u32 len, u8 is_write);
-int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size, void *userspace_addr);
+int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size, void *userspace_addr,
+		      enum kvm_mem_type type);
+static inline int kvm__register_ram(struct kvm *kvm, u64 guest_phys, u64 size,
+				    void *userspace_addr)
+{
+	return kvm__register_mem(kvm, guest_phys, size, userspace_addr,
+				 KVM_MEM_TYPE_RAM);
+}
+
+static inline int kvm__register_dev_mem(struct kvm *kvm, u64 guest_phys,
+					u64 size, void *userspace_addr)
+{
+	return kvm__register_mem(kvm, guest_phys, size, userspace_addr,
+				 KVM_MEM_TYPE_DEVICE);
+}
+
 int kvm__register_mmio(struct kvm *kvm, u64 phys_addr, u64 phys_addr_len, bool coalesce,
 		       void (*mmio_fn)(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len, u8 is_write, void *ptr),
 			void *ptr);
@@ -117,6 +141,24 @@ u64 host_to_guest_flat(struct kvm *kvm, void *ptr);
 bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 				 const char *kernel_cmdline);
 
+static inline const char *kvm_mem_type_to_string(enum kvm_mem_type type)
+{
+	switch (type) {
+	case KVM_MEM_TYPE_ALL:
+		return "(all)";
+	case KVM_MEM_TYPE_RAM:
+		return "RAM";
+	case KVM_MEM_TYPE_DEVICE:
+		return "device";
+	}
+
+	return "???";
+}
+
+int kvm__for_each_mem_bank(struct kvm *kvm, enum kvm_mem_type type,
+			   int (*fun)(struct kvm *kvm, struct kvm_mem_bank *bank, void *data),
+			   void *data);
+
 /*
  * Debugging
  */
diff --git a/kvm.c b/kvm.c
index f8f2fdc2c..e9c3c5fcb 100644
--- a/kvm.c
+++ b/kvm.c
@@ -182,7 +182,8 @@ core_exit(kvm__exit);
  * memory regions to it. Therefore, be careful if you use this function for
  * registering memory regions for emulating hardware.
  */
-int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size, void *userspace_addr)
+int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
+		      void *userspace_addr, enum kvm_mem_type type)
 {
 	struct kvm_userspace_memory_region mem;
 	struct kvm_mem_bank *bank;
@@ -196,6 +197,7 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size, void *userspace
 	bank->guest_phys_addr		= guest_phys;
 	bank->host_addr			= userspace_addr;
 	bank->size			= size;
+	bank->type			= type;
 
 	mem = (struct kvm_userspace_memory_region) {
 		.slot			= kvm->mem_slots++,
@@ -245,6 +247,33 @@ u64 host_to_guest_flat(struct kvm *kvm, void *ptr)
 	return 0;
 }
 
+/*
+ * Iterate over each registered memory bank. Call @fun for each bank with @data
+ * as argument. @type is a bitmask that allows to filter banks according to
+ * their type.
+ *
+ * If one call to @fun returns a non-zero value, stop iterating and return the
+ * value. Otherwise, return zero.
+ */
+int kvm__for_each_mem_bank(struct kvm *kvm, enum kvm_mem_type type,
+			   int (*fun)(struct kvm *kvm, struct kvm_mem_bank *bank, void *data),
+			   void *data)
+{
+	int ret;
+	struct kvm_mem_bank *bank;
+
+	list_for_each_entry(bank, &kvm->mem_banks, list) {
+		if (type != KVM_MEM_TYPE_ALL && !(bank->type & type))
+			continue;
+
+		ret = fun(kvm, bank, data);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
 int kvm__recommended_cpus(struct kvm *kvm)
 {
 	int ret;
diff --git a/mips/kvm.c b/mips/kvm.c
index 24bd65076..211770da0 100644
--- a/mips/kvm.c
+++ b/mips/kvm.c
@@ -28,21 +28,21 @@ void kvm__init_ram(struct kvm *kvm)
 		phys_size  = kvm->ram_size;
 		host_mem   = kvm->ram_start;
 
-		kvm__register_mem(kvm, phys_start, phys_size, host_mem);
+		kvm__register_ram(kvm, phys_start, phys_size, host_mem);
 	} else {
 		/* one region for memory that fits below MMIO range */
 		phys_start = 0;
 		phys_size  = KVM_MMIO_START;
 		host_mem   = kvm->ram_start;
 
-		kvm__register_mem(kvm, phys_start, phys_size, host_mem);
+		kvm__register_ram(kvm, phys_start, phys_size, host_mem);
 
 		/* one region for rest of memory */
 		phys_start = KVM_MMIO_START + KVM_MMIO_SIZE;
 		phys_size  = kvm->ram_size - KVM_MMIO_START;
 		host_mem   = kvm->ram_start + KVM_MMIO_START;
 
-		kvm__register_mem(kvm, phys_start, phys_size, host_mem);
+		kvm__register_ram(kvm, phys_start, phys_size, host_mem);
 	}
 }
 
diff --git a/powerpc/kvm.c b/powerpc/kvm.c
index c738c1d61..702d67dca 100644
--- a/powerpc/kvm.c
+++ b/powerpc/kvm.c
@@ -79,7 +79,7 @@ void kvm__init_ram(struct kvm *kvm)
 		    "overlaps MMIO!\n",
 		    phys_size);
 
-	kvm__register_mem(kvm, phys_start, phys_size, host_mem);
+	kvm__register_ram(kvm, phys_start, phys_size, host_mem);
 }
 
 void kvm__arch_set_cmdline(char *cmdline, bool video)
diff --git a/x86/kvm.c b/x86/kvm.c
index d8751e9a5..3e0f0b743 100644
--- a/x86/kvm.c
+++ b/x86/kvm.c
@@ -98,7 +98,7 @@ void kvm__init_ram(struct kvm *kvm)
 		phys_size  = kvm->ram_size;
 		host_mem   = kvm->ram_start;
 
-		kvm__register_mem(kvm, phys_start, phys_size, host_mem);
+		kvm__register_ram(kvm, phys_start, phys_size, host_mem);
 	} else {
 		/* First RAM range from zero to the PCI gap: */
 
@@ -106,7 +106,7 @@ void kvm__init_ram(struct kvm *kvm)
 		phys_size  = KVM_32BIT_GAP_START;
 		host_mem   = kvm->ram_start;
 
-		kvm__register_mem(kvm, phys_start, phys_size, host_mem);
+		kvm__register_ram(kvm, phys_start, phys_size, host_mem);
 
 		/* Second RAM range from 4GB to the end of RAM: */
 
@@ -114,7 +114,7 @@ void kvm__init_ram(struct kvm *kvm)
 		phys_size  = kvm->ram_size - phys_start;
 		host_mem   = kvm->ram_start + phys_start;
 
-		kvm__register_mem(kvm, phys_start, phys_size, host_mem);
+		kvm__register_ram(kvm, phys_start, phys_size, host_mem);
 	}
 }
 
-- 
2.17.0
