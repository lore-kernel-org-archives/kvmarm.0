From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 05/13] kvm: selftests: tidy up kvm_util
Date: Tue, 18 Sep 2018 19:54:28 +0200
Message-ID: <20180918175436.19742-6-drjones@redhat.com>
References: <20180918175436.19742-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A17074A20B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 13:54:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OTG8R2ZTI0uY for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Sep 2018 13:54:54 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9BBB94A255
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 13:54:54 -0400 (EDT)
In-Reply-To: <20180918175436.19742-1-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Tidy up kvm-util code: code/comment formatting, remove unused code,
and move x86 specific code out. We also move vcpu_dump() out of
common code, because not all arches (AArch64) have KVM_GET_REGS.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  77 ++--
 .../selftests/kvm/include/x86_64/processor.h  |  16 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 372 +++++-------------
 .../selftests/kvm/lib/kvm_util_internal.h     |  22 +-
 .../selftests/kvm/lib/x86_64/processor.c      | 179 +++++++++
 .../selftests/kvm/x86_64/dirty_log_test.c     |   1 +
 6 files changed, 337 insertions(+), 330 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 607f68ba4ceb..fcde5cf48d06 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -17,12 +17,6 @@
 
 #include "sparsebit.h"
 
-/*
- * Memslots can't cover the gfn starting at this gpa otherwise vCPUs can't be
- * created. Only applies to VMs using EPT.
- */
-#define KVM_DEFAULT_IDENTITY_MAP_ADDRESS 0xfffbc000ul
-
 
 /* Callers of kvm_util only have an incomplete/opaque description of the
  * structure kvm_util is using to maintain the state of a VM.
@@ -33,11 +27,11 @@ typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address */
 typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
 
 /* Minimum allocated guest virtual and physical addresses */
-#define KVM_UTIL_MIN_VADDR 0x2000
+#define KVM_UTIL_MIN_VADDR		0x2000
 
 #define DEFAULT_GUEST_PHY_PAGES		512
 #define DEFAULT_GUEST_STACK_VADDR_MIN	0xab6000
-#define DEFAULT_STACK_PGS               5
+#define DEFAULT_STACK_PGS		5
 
 enum vm_guest_mode {
 	VM_MODE_FLAT48PG,
@@ -57,15 +51,15 @@ void kvm_vm_restart(struct kvm_vm *vmp, int perm);
 void kvm_vm_release(struct kvm_vm *vmp);
 void kvm_vm_get_dirty_log(struct kvm_vm *vm, int slot, void *log);
 
-int kvm_memcmp_hva_gva(void *hva,
-	struct kvm_vm *vm, const vm_vaddr_t gva, size_t len);
+int kvm_memcmp_hva_gva(void *hva, struct kvm_vm *vm, const vm_vaddr_t gva,
+		       size_t len);
 
 void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename,
-	uint32_t data_memslot, uint32_t pgd_memslot);
+		     uint32_t data_memslot, uint32_t pgd_memslot);
 
 void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent);
-void vcpu_dump(FILE *stream, struct kvm_vm *vm,
-	uint32_t vcpuid, uint8_t indent);
+void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid,
+	       uint8_t indent);
 
 void vm_create_irqchip(struct kvm_vm *vm);
 
@@ -74,13 +68,14 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 	uint64_t guest_paddr, uint32_t slot, uint64_t npages,
 	uint32_t flags);
 
-void vcpu_ioctl(struct kvm_vm *vm,
-	uint32_t vcpuid, unsigned long ioctl, void *arg);
+void vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long ioctl,
+		void *arg);
 void vm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
 void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
-void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid, int pgd_memslot, int gdt_memslot);
+void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid, int pgd_memslot,
+		 int gdt_memslot);
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
-	uint32_t data_memslot, uint32_t pgd_memslot);
+			  uint32_t data_memslot, uint32_t pgd_memslot);
 void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	      size_t size, uint32_t pgd_memslot);
 void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa);
@@ -92,53 +87,33 @@ struct kvm_run *vcpu_state(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
 int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_set_mp_state(struct kvm_vm *vm, uint32_t vcpuid,
-	struct kvm_mp_state *mp_state);
-void vcpu_regs_get(struct kvm_vm *vm,
-	uint32_t vcpuid, struct kvm_regs *regs);
-void vcpu_regs_set(struct kvm_vm *vm,
-	uint32_t vcpuid, struct kvm_regs *regs);
+		       struct kvm_mp_state *mp_state);
+void vcpu_regs_get(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_regs *regs);
+void vcpu_regs_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_regs *regs);
 void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...);
-void vcpu_sregs_get(struct kvm_vm *vm,
-	uint32_t vcpuid, struct kvm_sregs *sregs);
-void vcpu_sregs_set(struct kvm_vm *vm,
-	uint32_t vcpuid, struct kvm_sregs *sregs);
-int _vcpu_sregs_set(struct kvm_vm *vm,
-	uint32_t vcpuid, struct kvm_sregs *sregs);
+void vcpu_sregs_get(struct kvm_vm *vm, uint32_t vcpuid,
+		    struct kvm_sregs *sregs);
+void vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid,
+		    struct kvm_sregs *sregs);
+int _vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid,
+		    struct kvm_sregs *sregs);
 void vcpu_events_get(struct kvm_vm *vm, uint32_t vcpuid,
-			  struct kvm_vcpu_events *events);
+		     struct kvm_vcpu_events *events);
 void vcpu_events_set(struct kvm_vm *vm, uint32_t vcpuid,
-			  struct kvm_vcpu_events *events);
+		     struct kvm_vcpu_events *events);
 
 const char *exit_reason_str(unsigned int exit_reason);
 
 void virt_pgd_alloc(struct kvm_vm *vm, uint32_t pgd_memslot);
 void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
-	uint32_t pgd_memslot);
-vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm,
-	vm_paddr_t paddr_min, uint32_t memslot);
-
-struct kvm_cpuid2 *kvm_get_supported_cpuid(void);
-void vcpu_set_cpuid(
-	struct kvm_vm *vm, uint32_t vcpuid, struct kvm_cpuid2 *cpuid);
-
-struct kvm_cpuid_entry2 *
-kvm_get_supported_cpuid_index(uint32_t function, uint32_t index);
-
-static inline struct kvm_cpuid_entry2 *
-kvm_get_supported_cpuid_entry(uint32_t function)
-{
-	return kvm_get_supported_cpuid_index(function, 0);
-}
+		 uint32_t pgd_memslot);
+vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
+			     uint32_t memslot);
 
 struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_size,
 				 void *guest_code);
 void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code);
 
-typedef void (*vmx_guest_code_t)(vm_vaddr_t vmxon_vaddr,
-				 vm_paddr_t vmxon_paddr,
-				 vm_vaddr_t vmcs_vaddr,
-				 vm_paddr_t vmcs_paddr);
-
 struct kvm_userspace_memory_region *
 kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
 				 uint64_t end);
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index bb76e8db9b2b..edec2aad2440 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -305,7 +305,21 @@ static inline unsigned long get_xmm(int n)
 
 struct kvm_x86_state;
 struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid);
-void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *state);
+void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid,
+		     struct kvm_x86_state *state);
+
+struct kvm_cpuid2 *kvm_get_supported_cpuid(void);
+void vcpu_set_cpuid(struct kvm_vm *vm, uint32_t vcpuid,
+		    struct kvm_cpuid2 *cpuid);
+
+struct kvm_cpuid_entry2 *
+kvm_get_supported_cpuid_index(uint32_t function, uint32_t index);
+
+static inline struct kvm_cpuid_entry2 *
+kvm_get_supported_cpuid_entry(uint32_t function)
+{
+	return kvm_get_supported_cpuid_index(function, 0);
+}
 
 /*
  * Basic CPU control in CR0
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 107622ce2b8c..19649ad6e015 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -16,8 +16,6 @@
 #include <sys/stat.h>
 #include <linux/kernel.h>
 
-#define KVM_DEV_PATH "/dev/kvm"
-
 #define KVM_UTIL_PGS_PER_HUGEPG 512
 #define KVM_UTIL_MIN_PADDR      0x2000
 
@@ -30,7 +28,8 @@ static void *align(void *x, size_t size)
 	return (void *) (((size_t) x + mask) & ~mask);
 }
 
-/* Capability
+/*
+ * Capability
  *
  * Input Args:
  *   cap - Capability
@@ -69,13 +68,13 @@ static void vm_open(struct kvm_vm *vm, int perm)
 	if (vm->kvm_fd < 0)
 		exit(KSFT_SKIP);
 
-	/* Create VM. */
 	vm->fd = ioctl(vm->kvm_fd, KVM_CREATE_VM, NULL);
 	TEST_ASSERT(vm->fd >= 0, "KVM_CREATE_VM ioctl failed, "
 		"rc: %i errno: %i", vm->fd, errno);
 }
 
-/* VM Create
+/*
+ * VM Create
  *
  * Input Args:
  *   mode - VM Mode (e.g. VM_MODE_FLAT48PG)
@@ -98,7 +97,6 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
 	struct kvm_vm *vm;
 	int kvm_fd;
 
-	/* Allocate memory. */
 	vm = calloc(1, sizeof(*vm));
 	TEST_ASSERT(vm != NULL, "Insufficent Memory");
 
@@ -136,7 +134,8 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
 	return vm;
 }
 
-/* VM Restart
+/*
+ * VM Restart
  *
  * Input Args:
  *   vm - VM that has been released before
@@ -163,7 +162,8 @@ void kvm_vm_restart(struct kvm_vm *vmp, int perm)
 			    "  rc: %i errno: %i\n"
 			    "  slot: %u flags: 0x%x\n"
 			    "  guest_phys_addr: 0x%lx size: 0x%lx",
-			    ret, errno, region->region.slot, region->region.flags,
+			    ret, errno, region->region.slot,
+			    region->region.flags,
 			    region->region.guest_phys_addr,
 			    region->region.memory_size);
 	}
@@ -179,7 +179,8 @@ void kvm_vm_get_dirty_log(struct kvm_vm *vm, int slot, void *log)
 		    strerror(-ret));
 }
 
-/* Userspace Memory Region Find
+/*
+ * Userspace Memory Region Find
  *
  * Input Args:
  *   vm - Virtual Machine
@@ -197,8 +198,8 @@ void kvm_vm_get_dirty_log(struct kvm_vm *vm, int slot, void *log)
  * of the regions is returned.  Null is returned only when no overlapping
  * region exists.
  */
-static struct userspace_mem_region *userspace_mem_region_find(
-	struct kvm_vm *vm, uint64_t start, uint64_t end)
+static struct userspace_mem_region *
+userspace_mem_region_find(struct kvm_vm *vm, uint64_t start, uint64_t end)
 {
 	struct userspace_mem_region *region;
 
@@ -214,7 +215,8 @@ static struct userspace_mem_region *userspace_mem_region_find(
 	return NULL;
 }
 
-/* KVM Userspace Memory Region Find
+/*
+ * KVM Userspace Memory Region Find
  *
  * Input Args:
  *   vm - Virtual Machine
@@ -242,7 +244,8 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
 	return &region->region;
 }
 
-/* VCPU Find
+/*
+ * VCPU Find
  *
  * Input Args:
  *   vm - Virtual Machine
@@ -257,8 +260,7 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
  * returns a pointer to it.  Returns NULL if the VM doesn't contain a VCPU
  * for the specified vcpuid.
  */
-struct vcpu *vcpu_find(struct kvm_vm *vm,
-	uint32_t vcpuid)
+struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid)
 {
 	struct vcpu *vcpup;
 
@@ -270,7 +272,8 @@ struct vcpu *vcpu_find(struct kvm_vm *vm,
 	return NULL;
 }
 
-/* VM VCPU Remove
+/*
+ * VM VCPU Remove
  *
  * Input Args:
  *   vm - Virtual Machine
@@ -307,11 +310,9 @@ void kvm_vm_release(struct kvm_vm *vmp)
 {
 	int ret;
 
-	/* Free VCPUs. */
 	while (vmp->vcpu_head)
 		vm_vcpu_rm(vmp, vmp->vcpu_head->id);
 
-	/* Close file descriptor for the VM. */
 	ret = close(vmp->fd);
 	TEST_ASSERT(ret == 0, "Close of vm fd failed,\n"
 		"  vmp->fd: %i rc: %i errno: %i", vmp->fd, ret, errno);
@@ -321,7 +322,8 @@ void kvm_vm_release(struct kvm_vm *vmp)
 		"  vmp->kvm_fd: %i rc: %i errno: %i", vmp->kvm_fd, ret, errno);
 }
 
-/* Destroys and frees the VM pointed to by vmp.
+/*
+ * Destroys and frees the VM pointed to by vmp.
  */
 void kvm_vm_free(struct kvm_vm *vmp)
 {
@@ -360,7 +362,8 @@ void kvm_vm_free(struct kvm_vm *vmp)
 	free(vmp);
 }
 
-/* Memory Compare, host virtual to guest virtual
+/*
+ * Memory Compare, host virtual to guest virtual
  *
  * Input Args:
  *   hva - Starting host virtual address
@@ -382,23 +385,25 @@ void kvm_vm_free(struct kvm_vm *vmp)
  * a length of len, to the guest bytes starting at the guest virtual
  * address given by gva.
  */
-int kvm_memcmp_hva_gva(void *hva,
-	struct kvm_vm *vm, vm_vaddr_t gva, size_t len)
+int kvm_memcmp_hva_gva(void *hva, struct kvm_vm *vm, vm_vaddr_t gva, size_t len)
 {
 	size_t amt;
 
-	/* Compare a batch of bytes until either a match is found
+	/*
+	 * Compare a batch of bytes until either a match is found
 	 * or all the bytes have been compared.
 	 */
 	for (uintptr_t offset = 0; offset < len; offset += amt) {
 		uintptr_t ptr1 = (uintptr_t)hva + offset;
 
-		/* Determine host address for guest virtual address
+		/*
+		 * Determine host address for guest virtual address
 		 * at offset.
 		 */
 		uintptr_t ptr2 = (uintptr_t)addr_gva2hva(vm, gva + offset);
 
-		/* Determine amount to compare on this pass.
+		/*
+		 * Determine amount to compare on this pass.
 		 * Don't allow the comparsion to cross a page boundary.
 		 */
 		amt = len - offset;
@@ -410,7 +415,8 @@ int kvm_memcmp_hva_gva(void *hva,
 		assert((ptr1 >> vm->page_shift) == ((ptr1 + amt - 1) >> vm->page_shift));
 		assert((ptr2 >> vm->page_shift) == ((ptr2 + amt - 1) >> vm->page_shift));
 
-		/* Perform the comparison.  If there is a difference
+		/*
+		 * Perform the comparison.  If there is a difference
 		 * return that result to the caller, otherwise need
 		 * to continue on looking for a mismatch.
 		 */
@@ -419,109 +425,15 @@ int kvm_memcmp_hva_gva(void *hva,
 			return ret;
 	}
 
-	/* No mismatch found.  Let the caller know the two memory
+	/*
+	 * No mismatch found.  Let the caller know the two memory
 	 * areas are equal.
 	 */
 	return 0;
 }
 
-/* Allocate an instance of struct kvm_cpuid2
- *
- * Input Args: None
- *
- * Output Args: None
- *
- * Return: A pointer to the allocated struct. The caller is responsible
- * for freeing this struct.
- *
- * Since kvm_cpuid2 uses a 0-length array to allow a the size of the
- * array to be decided at allocation time, allocation is slightly
- * complicated. This function uses a reasonable default length for
- * the array and performs the appropriate allocation.
- */
-static struct kvm_cpuid2 *allocate_kvm_cpuid2(void)
-{
-	struct kvm_cpuid2 *cpuid;
-	int nent = 100;
-	size_t size;
-
-	size = sizeof(*cpuid);
-	size += nent * sizeof(struct kvm_cpuid_entry2);
-	cpuid = malloc(size);
-	if (!cpuid) {
-		perror("malloc");
-		abort();
-	}
-
-	cpuid->nent = nent;
-
-	return cpuid;
-}
-
-/* KVM Supported CPUID Get
- *
- * Input Args: None
- *
- * Output Args:
- *
- * Return: The supported KVM CPUID
- *
- * Get the guest CPUID supported by KVM.
- */
-struct kvm_cpuid2 *kvm_get_supported_cpuid(void)
-{
-	static struct kvm_cpuid2 *cpuid;
-	int ret;
-	int kvm_fd;
-
-	if (cpuid)
-		return cpuid;
-
-	cpuid = allocate_kvm_cpuid2();
-	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
-	if (kvm_fd < 0)
-		exit(KSFT_SKIP);
-
-	ret = ioctl(kvm_fd, KVM_GET_SUPPORTED_CPUID, cpuid);
-	TEST_ASSERT(ret == 0, "KVM_GET_SUPPORTED_CPUID failed %d %d\n",
-		    ret, errno);
-
-	close(kvm_fd);
-	return cpuid;
-}
-
-/* Locate a cpuid entry.
- *
- * Input Args:
- *   cpuid: The cpuid.
- *   function: The function of the cpuid entry to find.
- *
- * Output Args: None
- *
- * Return: A pointer to the cpuid entry. Never returns NULL.
- */
-struct kvm_cpuid_entry2 *
-kvm_get_supported_cpuid_index(uint32_t function, uint32_t index)
-{
-	struct kvm_cpuid2 *cpuid;
-	struct kvm_cpuid_entry2 *entry = NULL;
-	int i;
-
-	cpuid = kvm_get_supported_cpuid();
-	for (i = 0; i < cpuid->nent; i++) {
-		if (cpuid->entries[i].function == function &&
-		    cpuid->entries[i].index == index) {
-			entry = &cpuid->entries[i];
-			break;
-		}
-	}
-
-	TEST_ASSERT(entry, "Guest CPUID entry not found: (EAX=%x, ECX=%x).",
-		    function, index);
-	return entry;
-}
-
-/* VM Userspace Memory Region Add
+/*
+ * VM Userspace Memory Region Add
  *
  * Input Args:
  *   vm - Virtual Machine
@@ -563,7 +475,8 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 		"  vm->max_gfn: 0x%lx vm->page_size: 0x%x",
 		guest_paddr, npages, vm->max_gfn, vm->page_size);
 
-	/* Confirm a mem region with an overlapping address doesn't
+	/*
+	 * Confirm a mem region with an overlapping address doesn't
 	 * already exist.
 	 */
 	region = (struct userspace_mem_region *) userspace_mem_region_find(
@@ -654,7 +567,8 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 	vm->userspace_mem_region_head = region;
 }
 
-/* Memslot to region
+/*
+ * Memslot to region
  *
  * Input Args:
  *   vm - Virtual Machine
@@ -668,8 +582,8 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
  *   on error (e.g. currently no memory region using memslot as a KVM
  *   memory slot ID).
  */
-static struct userspace_mem_region *memslot2region(struct kvm_vm *vm,
-	uint32_t memslot)
+static struct userspace_mem_region *
+memslot2region(struct kvm_vm *vm, uint32_t memslot)
 {
 	struct userspace_mem_region *region;
 
@@ -689,7 +603,8 @@ static struct userspace_mem_region *memslot2region(struct kvm_vm *vm,
 	return region;
 }
 
-/* VM Memory Region Flags Set
+/*
+ * VM Memory Region Flags Set
  *
  * Input Args:
  *   vm - Virtual Machine
@@ -707,7 +622,6 @@ void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags)
 	int ret;
 	struct userspace_mem_region *region;
 
-	/* Locate memory region. */
 	region = memslot2region(vm, slot);
 
 	region->region.flags = flags;
@@ -719,7 +633,8 @@ void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags)
 		ret, errno, slot, flags);
 }
 
-/* VCPU mmap Size
+/*
+ * VCPU mmap Size
  *
  * Input Args: None
  *
@@ -749,7 +664,8 @@ static int vcpu_mmap_sz(void)
 	return ret;
 }
 
-/* VM VCPU Add
+/*
+ * VM VCPU Add
  *
  * Input Args:
  *   vm - Virtual Machine
@@ -762,7 +678,8 @@ static int vcpu_mmap_sz(void)
  * Creates and adds to the VM specified by vm and virtual CPU with
  * the ID given by vcpuid.
  */
-void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid, int pgd_memslot, int gdt_memslot)
+void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid, int pgd_memslot,
+		 int gdt_memslot)
 {
 	struct vcpu *vcpu;
 
@@ -800,7 +717,8 @@ void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid, int pgd_memslot, int gdt_me
 	vcpu_setup(vm, vcpuid, pgd_memslot, gdt_memslot);
 }
 
-/* VM Virtual Address Unused Gap
+/*
+ * VM Virtual Address Unused Gap
  *
  * Input Args:
  *   vm - Virtual Machine
@@ -820,14 +738,14 @@ void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid, int pgd_memslot, int gdt_me
  * sz unallocated bytes >= vaddr_min is available.
  */
 static vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
-	vm_vaddr_t vaddr_min)
+				      vm_vaddr_t vaddr_min)
 {
 	uint64_t pages = (sz + vm->page_size - 1) >> vm->page_shift;
 
 	/* Determine lowest permitted virtual page index. */
 	uint64_t pgidx_start = (vaddr_min + vm->page_size - 1) >> vm->page_shift;
 	if ((pgidx_start * vm->page_size) < vaddr_min)
-			goto no_va_found;
+		goto no_va_found;
 
 	/* Loop over section with enough valid virtual page indexes. */
 	if (!sparsebit_is_set_num(vm->vpages_valid,
@@ -886,7 +804,8 @@ static vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
 	return pgidx_start * vm->page_size;
 }
 
-/* VM Virtual Address Allocate
+/*
+ * VM Virtual Address Allocate
  *
  * Input Args:
  *   vm - Virtual Machine
@@ -907,13 +826,14 @@ static vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
  * a page.
  */
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
-	uint32_t data_memslot, uint32_t pgd_memslot)
+			  uint32_t data_memslot, uint32_t pgd_memslot)
 {
 	uint64_t pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
 
 	virt_pgd_alloc(vm, pgd_memslot);
 
-	/* Find an unused range of virtual page addresses of at least
+	/*
+	 * Find an unused range of virtual page addresses of at least
 	 * pages in length.
 	 */
 	vm_vaddr_t vaddr_start = vm_vaddr_unused_gap(vm, sz, vaddr_min);
@@ -967,7 +887,8 @@ void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	}
 }
 
-/* Address VM Physical to Host Virtual
+/*
+ * Address VM Physical to Host Virtual
  *
  * Input Args:
  *   vm - Virtual Machine
@@ -999,7 +920,8 @@ void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa)
 	return NULL;
 }
 
-/* Address Host Virtual to VM Physical
+/*
+ * Address Host Virtual to VM Physical
  *
  * Input Args:
  *   vm - Virtual Machine
@@ -1033,7 +955,8 @@ vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva)
 	return -1;
 }
 
-/* VM Create IRQ Chip
+/*
+ * VM Create IRQ Chip
  *
  * Input Args:
  *   vm - Virtual Machine
@@ -1055,7 +978,8 @@ void vm_create_irqchip(struct kvm_vm *vm)
 	vm->has_irqchip = true;
 }
 
-/* VM VCPU State
+/*
+ * VM VCPU State
  *
  * Input Args:
  *   vm - Virtual Machine
@@ -1077,7 +1001,8 @@ struct kvm_run *vcpu_state(struct kvm_vm *vm, uint32_t vcpuid)
 	return vcpu->state;
 }
 
-/* VM VCPU Run
+/*
+ * VM VCPU Run
  *
  * Input Args:
  *   vm - Virtual Machine
@@ -1103,13 +1028,14 @@ int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid)
 	int rc;
 
 	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
-        do {
+	do {
 		rc = ioctl(vcpu->fd, KVM_RUN, NULL);
 	} while (rc == -1 && errno == EINTR);
 	return rc;
 }
 
-/* VM VCPU Set MP State
+/*
+ * VM VCPU Set MP State
  *
  * Input Args:
  *   vm - Virtual Machine
@@ -1124,7 +1050,7 @@ int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid)
  * by mp_state.
  */
 void vcpu_set_mp_state(struct kvm_vm *vm, uint32_t vcpuid,
-	struct kvm_mp_state *mp_state)
+		       struct kvm_mp_state *mp_state)
 {
 	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
 	int ret;
@@ -1136,7 +1062,8 @@ void vcpu_set_mp_state(struct kvm_vm *vm, uint32_t vcpuid,
 		"rc: %i errno: %i", ret, errno);
 }
 
-/* VM VCPU Regs Get
+/*
+ * VM VCPU Regs Get
  *
  * Input Args:
  *   vm - Virtual Machine
@@ -1150,21 +1077,20 @@ void vcpu_set_mp_state(struct kvm_vm *vm, uint32_t vcpuid,
  * Obtains the current register state for the VCPU specified by vcpuid
  * and stores it at the location given by regs.
  */
-void vcpu_regs_get(struct kvm_vm *vm,
-	uint32_t vcpuid, struct kvm_regs *regs)
+void vcpu_regs_get(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_regs *regs)
 {
 	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
 	int ret;
 
 	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
 
-	/* Get the regs. */
 	ret = ioctl(vcpu->fd, KVM_GET_REGS, regs);
 	TEST_ASSERT(ret == 0, "KVM_GET_REGS failed, rc: %i errno: %i",
 		ret, errno);
 }
 
-/* VM VCPU Regs Set
+/*
+ * VM VCPU Regs Set
  *
  * Input Args:
  *   vm - Virtual Machine
@@ -1178,99 +1104,46 @@ void vcpu_regs_get(struct kvm_vm *vm,
  * Sets the regs of the VCPU specified by vcpuid to the values
  * given by regs.
  */
-void vcpu_regs_set(struct kvm_vm *vm,
-	uint32_t vcpuid, struct kvm_regs *regs)
+void vcpu_regs_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_regs *regs)
 {
 	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
 	int ret;
 
 	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
 
-	/* Set the regs. */
 	ret = ioctl(vcpu->fd, KVM_SET_REGS, regs);
 	TEST_ASSERT(ret == 0, "KVM_SET_REGS failed, rc: %i errno: %i",
 		ret, errno);
 }
 
 void vcpu_events_get(struct kvm_vm *vm, uint32_t vcpuid,
-			  struct kvm_vcpu_events *events)
+		     struct kvm_vcpu_events *events)
 {
 	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
 	int ret;
 
 	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
 
-	/* Get the regs. */
 	ret = ioctl(vcpu->fd, KVM_GET_VCPU_EVENTS, events);
 	TEST_ASSERT(ret == 0, "KVM_GET_VCPU_EVENTS, failed, rc: %i errno: %i",
 		ret, errno);
 }
 
 void vcpu_events_set(struct kvm_vm *vm, uint32_t vcpuid,
-			  struct kvm_vcpu_events *events)
+		     struct kvm_vcpu_events *events)
 {
 	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
 	int ret;
 
 	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
 
-	/* Set the regs. */
 	ret = ioctl(vcpu->fd, KVM_SET_VCPU_EVENTS, events);
 	TEST_ASSERT(ret == 0, "KVM_SET_VCPU_EVENTS, failed, rc: %i errno: %i",
 		ret, errno);
 }
 
-/* VM VCPU Args Set
- *
- * Input Args:
- *   vm - Virtual Machine
- *   vcpuid - VCPU ID
- *   num - number of arguments
- *   ... - arguments, each of type uint64_t
- *
- * Output Args: None
- *
- * Return: None
- *
- * Sets the first num function input arguments to the values
- * given as variable args.  Each of the variable args is expected to
- * be of type uint64_t.
- */
-void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...)
-{
-	va_list ap;
-	struct kvm_regs regs;
-
-	TEST_ASSERT(num >= 1 && num <= 6, "Unsupported number of args,\n"
-		    "  num: %u\n",
-		    num);
-
-	va_start(ap, num);
-	vcpu_regs_get(vm, vcpuid, &regs);
-
-	if (num >= 1)
-		regs.rdi = va_arg(ap, uint64_t);
-
-	if (num >= 2)
-		regs.rsi = va_arg(ap, uint64_t);
-
-	if (num >= 3)
-		regs.rdx = va_arg(ap, uint64_t);
-
-	if (num >= 4)
-		regs.rcx = va_arg(ap, uint64_t);
-
-	if (num >= 5)
-		regs.r8 = va_arg(ap, uint64_t);
-
-	if (num >= 6)
-		regs.r9 = va_arg(ap, uint64_t);
-
-	vcpu_regs_set(vm, vcpuid, &regs);
-	va_end(ap);
-}
-
-/* VM VCPU System Regs Get
+/*
+ * VM VCPU System Regs Get
  *
  * Input Args:
  *   vm - Virtual Machine
@@ -1284,22 +1157,20 @@ void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...)
  * Obtains the current system register state for the VCPU specified by
  * vcpuid and stores it at the location given by sregs.
  */
-void vcpu_sregs_get(struct kvm_vm *vm,
-	uint32_t vcpuid, struct kvm_sregs *sregs)
+void vcpu_sregs_get(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_sregs *sregs)
 {
 	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
 	int ret;
 
 	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
 
-	/* Get the regs. */
-	/* Get the regs. */
 	ret = ioctl(vcpu->fd, KVM_GET_SREGS, sregs);
 	TEST_ASSERT(ret == 0, "KVM_GET_SREGS failed, rc: %i errno: %i",
 		ret, errno);
 }
 
-/* VM VCPU System Regs Set
+/*
+ * VM VCPU System Regs Set
  *
  * Input Args:
  *   vm - Virtual Machine
@@ -1313,27 +1184,25 @@ void vcpu_sregs_get(struct kvm_vm *vm,
  * Sets the system regs of the VCPU specified by vcpuid to the values
  * given by sregs.
  */
-void vcpu_sregs_set(struct kvm_vm *vm,
-	uint32_t vcpuid, struct kvm_sregs *sregs)
+void vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_sregs *sregs)
 {
 	int ret = _vcpu_sregs_set(vm, vcpuid, sregs);
 	TEST_ASSERT(ret == 0, "KVM_RUN IOCTL failed, "
 		"rc: %i errno: %i", ret, errno);
 }
 
-int _vcpu_sregs_set(struct kvm_vm *vm,
-	uint32_t vcpuid, struct kvm_sregs *sregs)
+int _vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_sregs *sregs)
 {
 	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
 	int ret;
 
 	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
 
-	/* Get the regs. */
 	return ioctl(vcpu->fd, KVM_SET_SREGS, sregs);
 }
 
-/* VCPU Ioctl
+/*
+ * VCPU Ioctl
  *
  * Input Args:
  *   vm - Virtual Machine
@@ -1345,8 +1214,8 @@ int _vcpu_sregs_set(struct kvm_vm *vm,
  *
  * Issues an arbitrary ioctl on a VCPU fd.
  */
-void vcpu_ioctl(struct kvm_vm *vm,
-	uint32_t vcpuid, unsigned long cmd, void *arg)
+void vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid,
+		unsigned long cmd, void *arg)
 {
 	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
 	int ret;
@@ -1358,7 +1227,8 @@ void vcpu_ioctl(struct kvm_vm *vm,
 		cmd, ret, errno, strerror(errno));
 }
 
-/* VM Ioctl
+/*
+ * VM Ioctl
  *
  * Input Args:
  *   vm - Virtual Machine
@@ -1378,7 +1248,8 @@ void vm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg)
 		cmd, ret, errno, strerror(errno));
 }
 
-/* VM Dump
+/*
+ * VM Dump
  *
  * Input Args:
  *   vm - Virtual Machine
@@ -1425,38 +1296,6 @@ void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 		vcpu_dump(stream, vm, vcpu->id, indent + 2);
 }
 
-/* VM VCPU Dump
- *
- * Input Args:
- *   vm - Virtual Machine
- *   vcpuid - VCPU ID
- *   indent - Left margin indent amount
- *
- * Output Args:
- *   stream - Output FILE stream
- *
- * Return: None
- *
- * Dumps the current state of the VCPU specified by vcpuid, within the VM
- * given by vm, to the FILE stream given by stream.
- */
-void vcpu_dump(FILE *stream, struct kvm_vm *vm,
-	uint32_t vcpuid, uint8_t indent)
-{
-		struct kvm_regs regs;
-		struct kvm_sregs sregs;
-
-		fprintf(stream, "%*scpuid: %u\n", indent, "", vcpuid);
-
-		fprintf(stream, "%*sregs:\n", indent + 2, "");
-		vcpu_regs_get(vm, vcpuid, &regs);
-		regs_dump(stream, &regs, indent + 4);
-
-		fprintf(stream, "%*ssregs:\n", indent + 2, "");
-		vcpu_sregs_get(vm, vcpuid, &sregs);
-		sregs_dump(stream, &sregs, indent + 4);
-}
-
 /* Known KVM exit reasons */
 static struct exit_reason {
 	unsigned int reason;
@@ -1487,7 +1326,8 @@ static struct exit_reason {
 #endif
 };
 
-/* Exit Reason String
+/*
+ * Exit Reason String
  *
  * Input Args:
  *   exit_reason - Exit reason
@@ -1513,7 +1353,8 @@ const char *exit_reason_str(unsigned int exit_reason)
 	return "Unknown";
 }
 
-/* Physical Page Allocate
+/*
+ * Physical Page Allocate
  *
  * Input Args:
  *   vm - Virtual Machine
@@ -1530,8 +1371,8 @@ const char *exit_reason_str(unsigned int exit_reason)
  * and its address is returned.  A TEST_ASSERT failure occurs if no
  * page is available at or above paddr_min.
  */
-vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm,
-	vm_paddr_t paddr_min, uint32_t memslot)
+vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
+			     uint32_t memslot)
 {
 	struct userspace_mem_region *region;
 	sparsebit_idx_t pg;
@@ -1541,17 +1382,15 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm,
 		"  paddr_min: 0x%lx page_size: 0x%x",
 		paddr_min, vm->page_size);
 
-	/* Locate memory region. */
 	region = memslot2region(vm, memslot);
-
-	/* Locate next available physical page at or above paddr_min. */
 	pg = paddr_min >> vm->page_shift;
 
+	/* Locate next available physical page at or above paddr_min. */
 	if (!sparsebit_is_set(region->unused_phy_pages, pg)) {
 		pg = sparsebit_next_set(region->unused_phy_pages, pg);
 		if (pg == 0) {
 			fprintf(stderr, "No guest physical page available, "
-				"paddr_min: 0x%lx page_size: 0x%x memslot: %u",
+				"paddr_min: 0x%lx page_size: 0x%x memslot: %u\n",
 				paddr_min, vm->page_size, memslot);
 			fputs("---- vm dump ----\n", stderr);
 			vm_dump(stderr, vm, 2);
@@ -1565,7 +1404,8 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm,
 	return pg * vm->page_size;
 }
 
-/* Address Guest Virtual to Host Virtual
+/*
+ * Address Guest Virtual to Host Virtual
  *
  * Input Args:
  *   vm - Virtual Machine
diff --git a/tools/testing/selftests/kvm/lib/kvm_util_internal.h b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
index 0278315cd930..62b9dc1926dc 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util_internal.h
+++ b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
@@ -11,18 +11,19 @@
 
 #include "sparsebit.h"
 
+#define KVM_DEV_PATH		"/dev/kvm"
+
 #ifndef BITS_PER_BYTE
-#define BITS_PER_BYTE           8
+#define BITS_PER_BYTE		8
 #endif
 
 #ifndef BITS_PER_LONG
-#define BITS_PER_LONG (BITS_PER_BYTE * sizeof(long))
+#define BITS_PER_LONG		(BITS_PER_BYTE * sizeof(long))
 #endif
 
 #define DIV_ROUND_UP(n, d)	(((n) + (d) - 1) / (d))
-#define BITS_TO_LONGS(nr)       DIV_ROUND_UP(nr, BITS_PER_LONG)
+#define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_LONG)
 
-/* Concrete definition of struct kvm_vm. */
 struct userspace_mem_region {
 	struct userspace_mem_region *next, *prev;
 	struct kvm_userspace_memory_region region;
@@ -52,7 +53,6 @@ struct kvm_vm {
 	struct userspace_mem_region *userspace_mem_region_head;
 	struct sparsebit *vpages_valid;
 	struct sparsebit *vpages_mapped;
-
 	bool has_irqchip;
 	bool pgd_created;
 	vm_paddr_t pgd;
@@ -60,13 +60,11 @@ struct kvm_vm {
 	vm_vaddr_t tss;
 };
 
-struct vcpu *vcpu_find(struct kvm_vm *vm,
-	uint32_t vcpuid);
-void vcpu_setup(struct kvm_vm *vm, int vcpuid, int pgd_memslot, int gdt_memslot);
+struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid);
+void vcpu_setup(struct kvm_vm *vm, int vcpuid, int pgd_memslot,
+		int gdt_memslot);
 void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent);
-void regs_dump(FILE *stream, struct kvm_regs *regs,
-	uint8_t indent);
-void sregs_dump(FILE *stream, struct kvm_sregs *sregs,
-	uint8_t indent);
+void regs_dump(FILE *stream, struct kvm_regs *regs, uint8_t indent);
+void sregs_dump(FILE *stream, struct kvm_sregs *sregs, uint8_t indent);
 
 #endif /* SELFTEST_KVM_UTIL_INTERNAL_H */
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 79c2c5c203c0..d96b5f9cc344 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -672,6 +672,102 @@ void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
 	vcpu_set_mp_state(vm, vcpuid, &mp_state);
 }
 
+/* Allocate an instance of struct kvm_cpuid2
+ *
+ * Input Args: None
+ *
+ * Output Args: None
+ *
+ * Return: A pointer to the allocated struct. The caller is responsible
+ * for freeing this struct.
+ *
+ * Since kvm_cpuid2 uses a 0-length array to allow a the size of the
+ * array to be decided at allocation time, allocation is slightly
+ * complicated. This function uses a reasonable default length for
+ * the array and performs the appropriate allocation.
+ */
+static struct kvm_cpuid2 *allocate_kvm_cpuid2(void)
+{
+	struct kvm_cpuid2 *cpuid;
+	int nent = 100;
+	size_t size;
+
+	size = sizeof(*cpuid);
+	size += nent * sizeof(struct kvm_cpuid_entry2);
+	cpuid = malloc(size);
+	if (!cpuid) {
+		perror("malloc");
+		abort();
+	}
+
+	cpuid->nent = nent;
+
+	return cpuid;
+}
+
+/* KVM Supported CPUID Get
+ *
+ * Input Args: None
+ *
+ * Output Args:
+ *
+ * Return: The supported KVM CPUID
+ *
+ * Get the guest CPUID supported by KVM.
+ */
+struct kvm_cpuid2 *kvm_get_supported_cpuid(void)
+{
+	static struct kvm_cpuid2 *cpuid;
+	int ret;
+	int kvm_fd;
+
+	if (cpuid)
+		return cpuid;
+
+	cpuid = allocate_kvm_cpuid2();
+	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
+	if (kvm_fd < 0)
+		exit(KSFT_SKIP);
+
+	ret = ioctl(kvm_fd, KVM_GET_SUPPORTED_CPUID, cpuid);
+	TEST_ASSERT(ret == 0, "KVM_GET_SUPPORTED_CPUID failed %d %d\n",
+		    ret, errno);
+
+	close(kvm_fd);
+	return cpuid;
+}
+
+/* Locate a cpuid entry.
+ *
+ * Input Args:
+ *   cpuid: The cpuid.
+ *   function: The function of the cpuid entry to find.
+ *
+ * Output Args: None
+ *
+ * Return: A pointer to the cpuid entry. Never returns NULL.
+ */
+struct kvm_cpuid_entry2 *
+kvm_get_supported_cpuid_index(uint32_t function, uint32_t index)
+{
+	struct kvm_cpuid2 *cpuid;
+	struct kvm_cpuid_entry2 *entry = NULL;
+	int i;
+
+	cpuid = kvm_get_supported_cpuid();
+	for (i = 0; i < cpuid->nent; i++) {
+		if (cpuid->entries[i].function == function &&
+		    cpuid->entries[i].index == index) {
+			entry = &cpuid->entries[i];
+			break;
+		}
+	}
+
+	TEST_ASSERT(entry, "Guest CPUID entry not found: (EAX=%x, ECX=%x).",
+		    function, index);
+	return entry;
+}
+
 /* VM VCPU CPUID Set
  *
  * Input Args:
@@ -698,6 +794,57 @@ void vcpu_set_cpuid(struct kvm_vm *vm,
 		    rc, errno);
 
 }
+
+/* VM VCPU Args Set
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   vcpuid - VCPU ID
+ *   num - number of arguments
+ *   ... - arguments, each of type uint64_t
+ *
+ * Output Args: None
+ *
+ * Return: None
+ *
+ * Sets the first num function input arguments to the values
+ * given as variable args.  Each of the variable args is expected to
+ * be of type uint64_t.
+ */
+void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...)
+{
+	va_list ap;
+	struct kvm_regs regs;
+
+	TEST_ASSERT(num >= 1 && num <= 6, "Unsupported number of args,\n"
+		    "  num: %u\n",
+		    num);
+
+	va_start(ap, num);
+	vcpu_regs_get(vm, vcpuid, &regs);
+
+	if (num >= 1)
+		regs.rdi = va_arg(ap, uint64_t);
+
+	if (num >= 2)
+		regs.rsi = va_arg(ap, uint64_t);
+
+	if (num >= 3)
+		regs.rdx = va_arg(ap, uint64_t);
+
+	if (num >= 4)
+		regs.rcx = va_arg(ap, uint64_t);
+
+	if (num >= 5)
+		regs.r8 = va_arg(ap, uint64_t);
+
+	if (num >= 6)
+		regs.r9 = va_arg(ap, uint64_t);
+
+	vcpu_regs_set(vm, vcpuid, &regs);
+	va_end(ap);
+}
+
 /* Create a VM with reasonable defaults
  *
  * Input Args:
@@ -742,6 +889,38 @@ struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
 	return vm;
 }
 
+/*
+ * VM VCPU Dump
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   vcpuid - VCPU ID
+ *   indent - Left margin indent amount
+ *
+ * Output Args:
+ *   stream - Output FILE stream
+ *
+ * Return: None
+ *
+ * Dumps the current state of the VCPU specified by vcpuid, within the VM
+ * given by vm, to the FILE stream given by stream.
+ */
+void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
+{
+	struct kvm_regs regs;
+	struct kvm_sregs sregs;
+
+	fprintf(stream, "%*scpuid: %u\n", indent, "", vcpuid);
+
+	fprintf(stream, "%*sregs:\n", indent + 2, "");
+	vcpu_regs_get(vm, vcpuid, &regs);
+	regs_dump(stream, &regs, indent + 4);
+
+	fprintf(stream, "%*ssregs:\n", indent + 2, "");
+	vcpu_sregs_get(vm, vcpuid, &sregs);
+	sregs_dump(stream, &sregs, indent + 4);
+}
+
 struct kvm_x86_state {
 	struct kvm_vcpu_events events;
 	struct kvm_mp_state mp_state;
diff --git a/tools/testing/selftests/kvm/x86_64/dirty_log_test.c b/tools/testing/selftests/kvm/x86_64/dirty_log_test.c
index 7cf3e4ae6046..395a6e07d37c 100644
--- a/tools/testing/selftests/kvm/x86_64/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86_64/dirty_log_test.c
@@ -15,6 +15,7 @@
 
 #include "test_util.h"
 #include "kvm_util.h"
+#include "processor.h"
 
 #define  DEBUG                 printf
 
-- 
2.17.1
