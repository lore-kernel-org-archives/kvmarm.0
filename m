From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 09/13] kvm: selftests: port dirty_log_test to aarch64
Date: Tue, 18 Sep 2018 19:54:32 +0200
Message-ID: <20180918175436.19742-10-drjones@redhat.com>
References: <20180918175436.19742-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 751724A252
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 13:55:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sIp43rh-SkG7 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Sep 2018 13:55:08 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1FCF04A20B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 13:55:08 -0400 (EDT)
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

While we're messing with the code for the port and to support guest
page sizes that are less than the host page size, we also make some
code formatting cleanups and apply sync_global_to_guest().

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/.gitignore        |   2 +-
 tools/testing/selftests/kvm/Makefile          |   5 +-
 .../kvm/{x86_64 => }/dirty_log_test.c         | 163 +++++++++---------
 3 files changed, 90 insertions(+), 80 deletions(-)
 rename tools/testing/selftests/kvm/{x86_64 => }/dirty_log_test.c (65%)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 9b3933fb5043..c228400cba07 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -3,4 +3,4 @@
 /x86_64/sync_regs_test
 /x86_64/vmx_tsc_adjust_test
 /x86_64/state_test
-/x86_64/dirty_log_test
+/dirty_log_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index d603d7865cd1..3875639025fe 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -5,13 +5,16 @@ UNAME_M := $(shell uname -m)
 
 LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/ucall.c lib/sparsebit.c
 LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c
+LIBKVM_aarch64 = lib/aarch64/processor.c
 
 TEST_GEN_PROGS_x86_64 = x86_64/set_sregs_test
 TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
 TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
 TEST_GEN_PROGS_x86_64 += x86_64/state_test
-TEST_GEN_PROGS_x86_64 += x86_64/dirty_log_test
+TEST_GEN_PROGS_x86_64 += dirty_log_test
+
+TEST_GEN_PROGS_aarch64 += dirty_log_test
 
 TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(UNAME_M))
 LIBKVM += $(LIBKVM_$(UNAME_M))
diff --git a/tools/testing/selftests/kvm/x86_64/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
similarity index 65%
rename from tools/testing/selftests/kvm/x86_64/dirty_log_test.c
rename to tools/testing/selftests/kvm/dirty_log_test.c
index 395a6e07d37c..d90f1091f687 100644
--- a/tools/testing/selftests/kvm/x86_64/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -17,75 +17,75 @@
 #include "kvm_util.h"
 #include "processor.h"
 
-#define  DEBUG                 printf
+#define DEBUG printf
+
+#define VCPU_ID				1
 
-#define  VCPU_ID                        1
 /* The memory slot index to track dirty pages */
-#define  TEST_MEM_SLOT_INDEX            1
+#define TEST_MEM_SLOT_INDEX		1
+
 /*
  * GPA offset of the testing memory slot. Must be bigger than the
  * default vm mem slot, which is DEFAULT_GUEST_PHY_PAGES.
  */
-#define  TEST_MEM_OFFSET                (1ULL << 30) /* 1G */
+#define TEST_MEM_OFFSET			(1ul << 30) /* 1G */
+
 /* Size of the testing memory slot */
-#define  TEST_MEM_PAGES                 (1ULL << 18) /* 1G for 4K pages */
+#define TEST_MEM_PAGES			(1ul << 18) /* 1G for 4K pages */
+
 /* How many pages to dirty for each guest loop */
-#define  TEST_PAGES_PER_LOOP            1024
+#define TEST_PAGES_PER_LOOP		1024
+
 /* How many host loops to run (one KVM_GET_DIRTY_LOG for each loop) */
-#define  TEST_HOST_LOOP_N               32
+#define TEST_HOST_LOOP_N		32
+
 /* Interval for each host loop (ms) */
-#define  TEST_HOST_LOOP_INTERVAL        10
+#define TEST_HOST_LOOP_INTERVAL		10
 
 /*
- * Guest variables.  We use these variables to share data between host
- * and guest.  There are two copies of the variables, one in host memory
- * (which is unused) and one in guest memory.  When the host wants to
- * access these variables, it needs to call addr_gva2hva() to access the
- * guest copy.
+ * Guest/Host shared variables. Ensure addr_gva2hva() and/or
+ * sync_global_to/from_guest() are used when accessing from
+ * the host. READ/WRITE_ONCE() should also be used with anything
+ * that may change.
  */
-uint64_t guest_random_array[TEST_PAGES_PER_LOOP];
-uint64_t guest_iteration;
-uint64_t guest_page_size;
+static uint64_t host_page_size;
+static uint64_t guest_page_size;
+static uint64_t random_array[TEST_PAGES_PER_LOOP];
+static uint64_t iteration;
 
 /*
- * Writes to the first byte of a random page within the testing memory
- * region continuously.
+ * Continuously write to the first 8 bytes of a random pages within
+ * the testing memory region.
  */
-void guest_code(void)
+static void guest_code(void)
 {
-	int i = 0;
-	uint64_t volatile *array = guest_random_array;
-	uint64_t volatile *guest_addr;
+	int i;
 
 	while (true) {
 		for (i = 0; i < TEST_PAGES_PER_LOOP; i++) {
-			/*
-			 * Write to the first 8 bytes of a random page
-			 * on the testing memory region.
-			 */
-			guest_addr = (uint64_t *)
-			    (TEST_MEM_OFFSET +
-			     (array[i] % TEST_MEM_PAGES) * guest_page_size);
-			*guest_addr = guest_iteration;
+			uint64_t addr = TEST_MEM_OFFSET;
+			addr += (READ_ONCE(random_array[i]) % TEST_MEM_PAGES)
+				* guest_page_size;
+			addr &= ~(host_page_size - 1);
+			*(uint64_t *)addr = READ_ONCE(iteration);
 		}
+
 		/* Tell the host that we need more random numbers */
 		GUEST_SYNC(1);
 	}
 }
 
-/*
- * Host variables.  These variables should only be used by the host
- * rather than the guest.
- */
-bool host_quit;
+/* Host variables */
+static bool host_quit;
 
 /* Points to the test VM memory region on which we track dirty logs */
-void *host_test_mem;
+static void *host_test_mem;
+static uint64_t host_num_pages;
 
 /* For statistics only */
-uint64_t host_dirty_count;
-uint64_t host_clear_count;
-uint64_t host_track_next_count;
+static uint64_t host_dirty_count;
+static uint64_t host_clear_count;
+static uint64_t host_track_next_count;
 
 /*
  * We use this bitmap to track some pages that should have its dirty
@@ -94,39 +94,34 @@ uint64_t host_track_next_count;
  * page bit is cleared in the latest bitmap, then the system must
  * report that write in the next get dirty log call.
  */
-unsigned long *host_bmap_track;
+static unsigned long *host_bmap_track;
 
-void generate_random_array(uint64_t *guest_array, uint64_t size)
+static void generate_random_array(uint64_t *guest_array, uint64_t size)
 {
 	uint64_t i;
 
-	for (i = 0; i < size; i++) {
+	for (i = 0; i < size; i++)
 		guest_array[i] = random();
-	}
 }
 
-void *vcpu_worker(void *data)
+static void *vcpu_worker(void *data)
 {
 	int ret;
-	uint64_t loops, *guest_array, pages_count = 0;
 	struct kvm_vm *vm = data;
+	uint64_t *guest_array;
+	uint64_t pages_count = 0;
 	struct kvm_run *run;
 	struct ucall uc;
 
 	run = vcpu_state(vm, VCPU_ID);
 
-	/* Retrieve the guest random array pointer and cache it */
-	guest_array = addr_gva2hva(vm, (vm_vaddr_t)guest_random_array);
-
-	DEBUG("VCPU starts\n");
-
+	guest_array = addr_gva2hva(vm, (vm_vaddr_t)random_array);
 	generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
 
 	while (!READ_ONCE(host_quit)) {
-		/* Let the guest to dirty these random pages */
+		/* Let the guest dirty the random pages */
 		ret = _vcpu_run(vm, VCPU_ID);
-		if (run->exit_reason == KVM_EXIT_IO &&
-		    get_ucall(vm, VCPU_ID, &uc) == UCALL_SYNC) {
+		if (get_ucall(vm, VCPU_ID, &uc) == UCALL_SYNC) {
 			pages_count += TEST_PAGES_PER_LOOP;
 			generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
 		} else {
@@ -137,18 +132,18 @@ void *vcpu_worker(void *data)
 		}
 	}
 
-	DEBUG("VCPU exits, dirtied %"PRIu64" pages\n", pages_count);
+	DEBUG("Dirtied %"PRIu64" pages\n", pages_count);
 
 	return NULL;
 }
 
-void vm_dirty_log_verify(unsigned long *bmap, uint64_t iteration)
+static void vm_dirty_log_verify(unsigned long *bmap)
 {
 	uint64_t page;
-	uint64_t volatile *value_ptr;
+	uint64_t *value_ptr;
 
-	for (page = 0; page < TEST_MEM_PAGES; page++) {
-		value_ptr = host_test_mem + page * getpagesize();
+	for (page = 0; page < host_num_pages; page++) {
+		value_ptr = host_test_mem + page * host_page_size;
 
 		/* If this is a special page that we were tracking... */
 		if (test_and_clear_bit(page, host_bmap_track)) {
@@ -208,7 +203,7 @@ void vm_dirty_log_verify(unsigned long *bmap, uint64_t iteration)
 	}
 }
 
-void help(char *name)
+static void help(char *name)
 {
 	puts("");
 	printf("usage: %s [-i iterations] [-I interval] [-h]\n", name);
@@ -225,9 +220,9 @@ int main(int argc, char *argv[])
 {
 	pthread_t vcpu_thread;
 	struct kvm_vm *vm;
-	uint64_t volatile *psize, *iteration;
-	unsigned long *bmap, iterations = TEST_HOST_LOOP_N,
-	    interval = TEST_HOST_LOOP_INTERVAL;
+	unsigned long iterations = TEST_HOST_LOOP_N;
+	unsigned long interval = TEST_HOST_LOOP_INTERVAL;
+	unsigned long *bmap;
 	int opt;
 
 	while ((opt = getopt(argc, argv, "hi:I:")) != -1) {
@@ -245,16 +240,21 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	TEST_ASSERT(iterations > 2, "Iteration must be bigger than zero\n");
-	TEST_ASSERT(interval > 0, "Interval must be bigger than zero");
+	TEST_ASSERT(iterations > 2, "Iterations must be greater than two");
+	TEST_ASSERT(interval > 0, "Interval must be greater than zero");
 
 	DEBUG("Test iterations: %"PRIu64", interval: %"PRIu64" (ms)\n",
 	      iterations, interval);
 
 	srandom(time(0));
 
-	bmap = bitmap_alloc(TEST_MEM_PAGES);
-	host_bmap_track = bitmap_alloc(TEST_MEM_PAGES);
+	guest_page_size = 4096;
+	host_page_size = getpagesize();
+	host_num_pages = (TEST_MEM_PAGES * guest_page_size) / host_page_size +
+			 !!((TEST_MEM_PAGES * guest_page_size) % host_page_size);
+
+	bmap = bitmap_alloc(host_num_pages);
+	host_bmap_track = bitmap_alloc(host_num_pages);
 
 	vm = vm_create_default(VCPU_ID, TEST_MEM_PAGES, guest_code);
 
@@ -264,32 +264,38 @@ int main(int argc, char *argv[])
 				    TEST_MEM_SLOT_INDEX,
 				    TEST_MEM_PAGES,
 				    KVM_MEM_LOG_DIRTY_PAGES);
-	/* Cache the HVA pointer of the region */
-	host_test_mem = addr_gpa2hva(vm, (vm_paddr_t)TEST_MEM_OFFSET);
 
 	/* Do 1:1 mapping for the dirty track memory slot */
 	virt_map(vm, TEST_MEM_OFFSET, TEST_MEM_OFFSET,
-		 TEST_MEM_PAGES * getpagesize(), 0);
+		 TEST_MEM_PAGES * guest_page_size, 0);
+
+	/* Cache the HVA pointer of the region */
+	host_test_mem = addr_gpa2hva(vm, (vm_paddr_t)TEST_MEM_OFFSET);
 
+#ifdef __x86_64__
 	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+#endif
+#ifdef __aarch64__
+	ucall_init(vm, UCALL_MMIO, NULL);
+#endif
 
-	/* Tell the guest about the page size on the system */
-	psize = addr_gva2hva(vm, (vm_vaddr_t)&guest_page_size);
-	*psize = getpagesize();
+	/* Tell the guest about the page sizes */
+	sync_global_to_guest(vm, host_page_size);
+	sync_global_to_guest(vm, guest_page_size);
 
 	/* Start the iterations */
-	iteration = addr_gva2hva(vm, (vm_vaddr_t)&guest_iteration);
-	*iteration = 1;
+	iteration = 1;
+	sync_global_to_guest(vm, iteration);
 
-	/* Start dirtying pages */
 	pthread_create(&vcpu_thread, NULL, vcpu_worker, vm);
 
-	while (*iteration < iterations) {
+	while (iteration < iterations) {
 		/* Give the vcpu thread some time to dirty some pages */
 		usleep(interval * 1000);
 		kvm_vm_get_dirty_log(vm, TEST_MEM_SLOT_INDEX, bmap);
-		vm_dirty_log_verify(bmap, *iteration);
-		(*iteration)++;
+		vm_dirty_log_verify(bmap);
+		iteration++;
+		sync_global_to_guest(vm, iteration);
 	}
 
 	/* Tell the vcpu thread to quit */
@@ -302,6 +308,7 @@ int main(int argc, char *argv[])
 
 	free(bmap);
 	free(host_bmap_track);
+	ucall_uninit(vm);
 	kvm_vm_free(vm);
 
 	return 0;
-- 
2.17.1
