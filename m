From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: [PATCH v6 kvmtool 12/13] Introduce reserved memory regions
Date: Mon, 18 Jun 2018 19:42:10 +0100
Message-ID: <20180618184211.43904-13-jean-philippe.brucker@arm.com>
References: <20180618184211.43904-1-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 12DD54A119
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jun 2018 14:32:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DnydpY+-2XVA for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jun 2018 14:31:52 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE0D84A0E3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jun 2018 14:31:44 -0400 (EDT)
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

When passing devices to the guest, there might be address ranges
unavailable to the device. For instance, if address 0x10000000 corresponds
to an MSI doorbell, any transaction from a device to that address will be
directed to the MSI controller and might not even reach the IOMMU. In that
case 0x10000000 is reserved by the physical IOMMU in the guest's physical
space.

This patch introduces a simple API to register reserved ranges of
addresses that should not or cannot be provided to the guest. For the
moment it only checks that a reserved range does not overlap any user
memory (we don't consider MMIO) and aborts otherwise.

It should be possible instead to poke holes in the guest-physical memory
map and report them via the architecture's preferred route:
* ARM and PowerPC can add reserved-memory nodes to the DT they provide to
  the guest.
* x86 could poke holes in the memory map reported with e820. This requires
  to postpone creating the memory map until at least VFIO is initialized.
* MIPS could describe the reserved ranges with the "memmap=mm$ss" kernel
  parameter.

This would also require to call KVM_SET_USER_MEMORY_REGION for all memory
regions at the end of kvmtool initialisation. Extra care should be taken
to ensure we don't break any architecture, since they currently rely on
having a linear address space with at most two memory blocks.

This patch doesn't implement any address space carving. If an abort is
encountered, user can try to rebuild kvmtool with different addresses or
change its IOMMU resv regions if possible.

Reviewed-by: Punit Agrawal <punit.agrawal@arm.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 include/kvm/kvm.h | 10 +++++++
 kvm.c             | 68 +++++++++++++++++++++++++++++++++++++----------
 2 files changed, 64 insertions(+), 14 deletions(-)

diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 19f7d265c..1edacfdfc 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -37,9 +37,11 @@ enum {
 enum kvm_mem_type {
 	KVM_MEM_TYPE_RAM	= 1 << 0,
 	KVM_MEM_TYPE_DEVICE	= 1 << 1,
+	KVM_MEM_TYPE_RESERVED	= 1 << 2,
 
 	KVM_MEM_TYPE_ALL	= KVM_MEM_TYPE_RAM
 				| KVM_MEM_TYPE_DEVICE
+				| KVM_MEM_TYPE_RESERVED
 };
 
 struct kvm_ext {
@@ -115,6 +117,12 @@ static inline int kvm__register_dev_mem(struct kvm *kvm, u64 guest_phys,
 				 KVM_MEM_TYPE_DEVICE);
 }
 
+static inline int kvm__reserve_mem(struct kvm *kvm, u64 guest_phys, u64 size)
+{
+	return kvm__register_mem(kvm, guest_phys, size, NULL,
+				 KVM_MEM_TYPE_RESERVED);
+}
+
 int kvm__register_mmio(struct kvm *kvm, u64 phys_addr, u64 phys_addr_len, bool coalesce,
 		       void (*mmio_fn)(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len, u8 is_write, void *ptr),
 			void *ptr);
@@ -150,6 +158,8 @@ static inline const char *kvm_mem_type_to_string(enum kvm_mem_type type)
 		return "RAM";
 	case KVM_MEM_TYPE_DEVICE:
 		return "device";
+	case KVM_MEM_TYPE_RESERVED:
+		return "reserved";
 	}
 
 	return "???";
diff --git a/kvm.c b/kvm.c
index e9c3c5fcb..7de825a9d 100644
--- a/kvm.c
+++ b/kvm.c
@@ -177,18 +177,55 @@ int kvm__exit(struct kvm *kvm)
 }
 core_exit(kvm__exit);
 
-/*
- * Note: KVM_SET_USER_MEMORY_REGION assumes that we don't pass overlapping
- * memory regions to it. Therefore, be careful if you use this function for
- * registering memory regions for emulating hardware.
- */
 int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
 		      void *userspace_addr, enum kvm_mem_type type)
 {
 	struct kvm_userspace_memory_region mem;
+	struct kvm_mem_bank *merged = NULL;
 	struct kvm_mem_bank *bank;
 	int ret;
 
+	/* Check for overlap */
+	list_for_each_entry(bank, &kvm->mem_banks, list) {
+		u64 bank_end = bank->guest_phys_addr + bank->size - 1;
+		u64 end = guest_phys + size - 1;
+		if (guest_phys > bank_end || end < bank->guest_phys_addr)
+			continue;
+
+		/* Merge overlapping reserved regions */
+		if (bank->type == KVM_MEM_TYPE_RESERVED &&
+		    type == KVM_MEM_TYPE_RESERVED) {
+			bank->guest_phys_addr = min(bank->guest_phys_addr, guest_phys);
+			bank->size = max(bank_end, end) - bank->guest_phys_addr + 1;
+
+			if (merged) {
+				/*
+				 * This is at least the second merge, remove
+				 * previous result.
+				 */
+				list_del(&merged->list);
+				free(merged);
+			}
+
+			guest_phys = bank->guest_phys_addr;
+			size = bank->size;
+			merged = bank;
+
+			/* Keep checking that we don't overlap another region */
+			continue;
+		}
+
+		pr_err("%s region [%llx-%llx] would overlap %s region [%llx-%llx]",
+		       kvm_mem_type_to_string(type), guest_phys, guest_phys + size - 1,
+		       kvm_mem_type_to_string(bank->type), bank->guest_phys_addr,
+		       bank->guest_phys_addr + bank->size - 1);
+
+		return -EINVAL;
+	}
+
+	if (merged)
+		return 0;
+
 	bank = malloc(sizeof(*bank));
 	if (!bank)
 		return -ENOMEM;
@@ -199,18 +236,21 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
 	bank->size			= size;
 	bank->type			= type;
 
-	mem = (struct kvm_userspace_memory_region) {
-		.slot			= kvm->mem_slots++,
-		.guest_phys_addr	= guest_phys,
-		.memory_size		= size,
-		.userspace_addr		= (unsigned long)userspace_addr,
-	};
+	if (type != KVM_MEM_TYPE_RESERVED) {
+		mem = (struct kvm_userspace_memory_region) {
+			.slot			= kvm->mem_slots++,
+			.guest_phys_addr	= guest_phys,
+			.memory_size		= size,
+			.userspace_addr		= (unsigned long)userspace_addr,
+		};
 
-	ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION, &mem);
-	if (ret < 0)
-		return -errno;
+		ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION, &mem);
+		if (ret < 0)
+			return -errno;
+	}
 
 	list_add(&bank->list, &kvm->mem_banks);
+
 	return 0;
 }
 
-- 
2.17.0
