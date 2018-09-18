From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 10/13] kvm: selftests: introduce new VM mode for 64K pages
Date: Tue, 18 Sep 2018 19:54:33 +0200
Message-ID: <20180918175436.19742-11-drjones@redhat.com>
References: <20180918175436.19742-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B00574A252
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 13:55:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id scafx8nLaj-2 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Sep 2018 13:55:11 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B7494A26B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 13:55:10 -0400 (EDT)
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

Rename VM_MODE_FLAT48PG to be more descriptive of its config and add a
new config that has the same parameters, except with 64K pages.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  7 ++-
 .../selftests/kvm/lib/aarch64/processor.c     |  8 +++-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 47 ++++++++++++-------
 .../selftests/kvm/lib/kvm_util_internal.h     |  1 +
 .../selftests/kvm/lib/x86_64/processor.c      | 10 ++--
 5 files changed, 48 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 752715a78a9b..6e3dff9d9d94 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -34,9 +34,14 @@ typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
 #define DEFAULT_STACK_PGS		5
 
 enum vm_guest_mode {
-	VM_MODE_FLAT48PG,
+	VM_MODE_P52V48_4K,
+	VM_MODE_P52V48_64K,
+	NUM_VM_MODES,
 };
 
+#define vm_guest_mode_string(m) vm_guest_mode_string[m]
+extern const char * const vm_guest_mode_string[];
+
 enum vm_mem_backing_src_type {
 	VM_MEM_SRC_ANONYMOUS,
 	VM_MEM_SRC_ANONYMOUS_THP,
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 871fe2173679..b1dfc0d4b68e 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -226,7 +226,7 @@ struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
 	uint64_t extra_pg_pages = (extra_mem_pages / ptrs_per_4k_pte) * 2;
 	struct kvm_vm *vm;
 
-	vm = vm_create(VM_MODE_FLAT48PG, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages, O_RDWR);
+	vm = vm_create(VM_MODE_P52V48_4K, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages, O_RDWR);
 
 	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
 	vm_vcpu_add_default(vm, vcpuid, guest_code);
@@ -267,10 +267,14 @@ void vcpu_setup(struct kvm_vm *vm, int vcpuid, int pgd_memslot, int gdt_memslot)
 	get_reg(vm, vcpuid, ARM64_SYS_REG(TCR_EL1), &tcr_el1);
 
 	switch (vm->mode) {
-	case VM_MODE_FLAT48PG:
+	case VM_MODE_P52V48_4K:
 		tcr_el1 |= 0ul << 14; /* TG0 = 4KB */
 		tcr_el1 |= 6ul << 32; /* IPS = 52 bits */
 		break;
+	case VM_MODE_P52V48_64K:
+		tcr_el1 |= 1ul << 14; /* TG0 = 64KB */
+		tcr_el1 |= 6ul << 32; /* IPS = 52 bits */
+		break;
 	default:
 		TEST_ASSERT(false, "Unknown guest mode, mode: 0x%x", vm->mode);
 	}
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index b5e9eb7360a2..4d3bb515de17 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -17,7 +17,7 @@
 #include <linux/kernel.h>
 
 #define KVM_UTIL_PGS_PER_HUGEPG 512
-#define KVM_UTIL_MIN_PADDR      0x2000
+#define KVM_UTIL_MIN_PFN	2
 
 /* Aligns x up to the next multiple of size. Size must be a power of 2. */
 static void *align(void *x, size_t size)
@@ -73,11 +73,16 @@ static void vm_open(struct kvm_vm *vm, int perm)
 		"rc: %i errno: %i", vm->fd, errno);
 }
 
+const char * const vm_guest_mode_string[] = {
+	"PA-bits:52, VA-bits:48, 4K pages",
+	"PA-bits:52, VA-bits:48, 64K pages",
+};
+
 /*
  * VM Create
  *
  * Input Args:
- *   mode - VM Mode (e.g. VM_MODE_FLAT48PG)
+ *   mode - VM Mode (e.g. VM_MODE_P52V48_4K)
  *   phy_pages - Physical memory pages
  *   perm - permission
  *
@@ -86,7 +91,7 @@ static void vm_open(struct kvm_vm *vm, int perm)
  * Return:
  *   Pointer to opaque structure that describes the created VM.
  *
- * Creates a VM with the mode specified by mode (e.g. VM_MODE_FLAT48PG).
+ * Creates a VM with the mode specified by mode (e.g. VM_MODE_P52V48_4K).
  * When phy_pages is non-zero, a memory region of phy_pages physical pages
  * is created and mapped starting at guest physical address 0.  The file
  * descriptor to control the created VM is created with the permissions
@@ -105,28 +110,35 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
 
 	/* Setup mode specific traits. */
 	switch (vm->mode) {
-	case VM_MODE_FLAT48PG:
+	case VM_MODE_P52V48_4K:
 		vm->pgtable_levels = 4;
+		vm->pa_bits = 52;
 		vm->va_bits = 48;
 		vm->page_size = 0x1000;
 		vm->page_shift = 12;
-
-		/* Limit to 48-bit canonical virtual addresses. */
-		vm->vpages_valid = sparsebit_alloc();
-		sparsebit_set_num(vm->vpages_valid,
-			0, (1ULL << (48 - 1)) >> vm->page_shift);
-		sparsebit_set_num(vm->vpages_valid,
-			(~((1ULL << (48 - 1)) - 1)) >> vm->page_shift,
-			(1ULL << (48 - 1)) >> vm->page_shift);
-
-		/* Limit physical addresses to 52-bits. */
-		vm->max_gfn = ((1ULL << 52) >> vm->page_shift) - 1;
 		break;
-
+	case VM_MODE_P52V48_64K:
+		vm->pgtable_levels = 3;
+		vm->pa_bits = 52;
+		vm->va_bits = 48;
+		vm->page_size = 0x10000;
+		vm->page_shift = 16;
+		break;
 	default:
 		TEST_ASSERT(false, "Unknown guest mode, mode: 0x%x", mode);
 	}
 
+	/* Limit to VA-bit canonical virtual addresses. */
+	vm->vpages_valid = sparsebit_alloc();
+	sparsebit_set_num(vm->vpages_valid,
+		0, (1ULL << (vm->va_bits - 1)) >> vm->page_shift);
+	sparsebit_set_num(vm->vpages_valid,
+		(~((1ULL << (vm->va_bits - 1)) - 1)) >> vm->page_shift,
+		(1ULL << (vm->va_bits - 1)) >> vm->page_shift);
+
+	/* Limit physical addresses to PA-bits. */
+	vm->max_gfn = ((1ULL << vm->pa_bits) >> vm->page_shift) - 1;
+
 	/* Allocate and setup memory for guest. */
 	vm->vpages_mapped = sparsebit_alloc();
 	if (phy_pages != 0)
@@ -845,7 +857,8 @@ vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
 		pages--, vaddr += vm->page_size) {
 		vm_paddr_t paddr;
 
-		paddr = vm_phy_page_alloc(vm, KVM_UTIL_MIN_PADDR, data_memslot);
+		paddr = vm_phy_page_alloc(vm,
+				KVM_UTIL_MIN_PFN * vm->page_size, data_memslot);
 
 		virt_pg_map(vm, vaddr, paddr, pgd_memslot);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util_internal.h b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
index 813145f3e4b9..5e05fb98dc62 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util_internal.h
+++ b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
@@ -47,6 +47,7 @@ struct kvm_vm {
 	int kvm_fd;
 	int fd;
 	unsigned int pgtable_levels;
+	unsigned int pa_bits;
 	unsigned int va_bits;
 	unsigned int page_size;
 	unsigned int page_shift;
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index d96b5f9cc344..7092d1389dda 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -231,7 +231,7 @@ void virt_pgd_alloc(struct kvm_vm *vm, uint32_t pgd_memslot)
 {
 	int rc;
 
-	TEST_ASSERT(vm->mode == VM_MODE_FLAT48PG, "Attempt to use "
+	TEST_ASSERT(vm->mode == VM_MODE_P52V48_4K, "Attempt to use "
 		"unknown or unsupported guest mode, mode: 0x%x", vm->mode);
 
 	/* If needed, create page map l4 table. */
@@ -264,7 +264,7 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	uint16_t index[4];
 	struct pageMapL4Entry *pml4e;
 
-	TEST_ASSERT(vm->mode == VM_MODE_FLAT48PG, "Attempt to use "
+	TEST_ASSERT(vm->mode == VM_MODE_P52V48_4K, "Attempt to use "
 		"unknown or unsupported guest mode, mode: 0x%x", vm->mode);
 
 	TEST_ASSERT((vaddr % vm->page_size) == 0,
@@ -551,7 +551,7 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 	struct pageTableEntry *pte;
 	void *hva;
 
-	TEST_ASSERT(vm->mode == VM_MODE_FLAT48PG, "Attempt to use "
+	TEST_ASSERT(vm->mode == VM_MODE_P52V48_4K, "Attempt to use "
 		"unknown or unsupported guest mode, mode: 0x%x", vm->mode);
 
 	index[0] = (gva >> 12) & 0x1ffu;
@@ -624,7 +624,7 @@ void vcpu_setup(struct kvm_vm *vm, int vcpuid, int pgd_memslot, int gdt_memslot)
 	kvm_setup_gdt(vm, &sregs.gdt, gdt_memslot, pgd_memslot);
 
 	switch (vm->mode) {
-	case VM_MODE_FLAT48PG:
+	case VM_MODE_P52V48_4K:
 		sregs.cr0 = X86_CR0_PE | X86_CR0_NE | X86_CR0_PG;
 		sregs.cr4 |= X86_CR4_PAE | X86_CR4_OSFXSR;
 		sregs.efer |= (EFER_LME | EFER_LMA | EFER_NX);
@@ -873,7 +873,7 @@ struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
 	uint64_t extra_pg_pages = extra_mem_pages / 512 * 2;
 
 	/* Create VM */
-	vm = vm_create(VM_MODE_FLAT48PG,
+	vm = vm_create(VM_MODE_P52V48_4K,
 		       DEFAULT_GUEST_PHY_PAGES + extra_pg_pages,
 		       O_RDWR);
 
-- 
2.17.1
