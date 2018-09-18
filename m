From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 06/13] kvm: selftests: add vm_phy_pages_alloc
Date: Tue, 18 Sep 2018 19:54:29 +0200
Message-ID: <20180918175436.19742-7-drjones@redhat.com>
References: <20180918175436.19742-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC7DB4A23E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 13:54:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QdTE-pXUtwVX for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Sep 2018 13:54:57 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DB2444A1FE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 13:54:56 -0400 (EDT)
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

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 60 ++++++++++++-------
 2 files changed, 39 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index fcde5cf48d06..752715a78a9b 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -109,6 +109,8 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 		 uint32_t pgd_memslot);
 vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 			     uint32_t memslot);
+vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+			      vm_paddr_t paddr_min, uint32_t memslot);
 
 struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_size,
 				 void *guest_code);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 19649ad6e015..ea5e5ea316de 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1354,10 +1354,11 @@ const char *exit_reason_str(unsigned int exit_reason)
 }
 
 /*
- * Physical Page Allocate
+ * Physical Contiguous Page Allocator
  *
  * Input Args:
  *   vm - Virtual Machine
+ *   num - number of pages
  *   paddr_min - Physical address minimum
  *   memslot - Memory region to allocate page from
  *
@@ -1366,16 +1367,18 @@ const char *exit_reason_str(unsigned int exit_reason)
  * Return:
  *   Starting physical address
  *
- * Within the VM specified by vm, locates an available physical page
- * at or above paddr_min.  If found, the page is marked as in use
- * and its address is returned.  A TEST_ASSERT failure occurs if no
- * page is available at or above paddr_min.
+ * Within the VM specified by vm, locates a range of available physical
+ * pages at or above paddr_min. If found, the pages are marked as in use
+ * and thier base address is returned. A TEST_ASSERT failure occurs if
+ * not enough pages are available at or above paddr_min.
  */
-vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
-			     uint32_t memslot)
+vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+			      vm_paddr_t paddr_min, uint32_t memslot)
 {
 	struct userspace_mem_region *region;
-	sparsebit_idx_t pg;
+	sparsebit_idx_t pg, base;
+
+	TEST_ASSERT(num > 0, "Must allocate at least one page");
 
 	TEST_ASSERT((paddr_min % vm->page_size) == 0, "Min physical address "
 		"not divisible by page size.\n"
@@ -1383,25 +1386,36 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 		paddr_min, vm->page_size);
 
 	region = memslot2region(vm, memslot);
-	pg = paddr_min >> vm->page_shift;
-
-	/* Locate next available physical page at or above paddr_min. */
-	if (!sparsebit_is_set(region->unused_phy_pages, pg)) {
-		pg = sparsebit_next_set(region->unused_phy_pages, pg);
-		if (pg == 0) {
-			fprintf(stderr, "No guest physical page available, "
-				"paddr_min: 0x%lx page_size: 0x%x memslot: %u\n",
-				paddr_min, vm->page_size, memslot);
-			fputs("---- vm dump ----\n", stderr);
-			vm_dump(stderr, vm, 2);
-			abort();
+	base = pg = paddr_min >> vm->page_shift;
+
+	do {
+		for (; pg < base + num; ++pg) {
+			if (!sparsebit_is_set(region->unused_phy_pages, pg)) {
+				base = pg = sparsebit_next_set(region->unused_phy_pages, pg);
+				break;
+			}
 		}
+	} while (pg && pg != base + num);
+
+	if (pg == 0) {
+		fprintf(stderr, "No guest physical page available, "
+			"paddr_min: 0x%lx page_size: 0x%x memslot: %u\n",
+			paddr_min, vm->page_size, memslot);
+		fputs("---- vm dump ----\n", stderr);
+		vm_dump(stderr, vm, 2);
+		abort();
 	}
 
-	/* Specify page as in use and return its address. */
-	sparsebit_clear(region->unused_phy_pages, pg);
+	for (pg = base; pg < base + num; ++pg)
+		sparsebit_clear(region->unused_phy_pages, pg);
+
+	return base * vm->page_size;
+}
 
-	return pg * vm->page_size;
+vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
+			     uint32_t memslot)
+{
+	return vm_phy_pages_alloc(vm, 1, paddr_min, memslot);
 }
 
 /*
-- 
2.17.1
