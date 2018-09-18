From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 13/13] kvm: selftests: support high GPAs in dirty_log_test
Date: Tue, 18 Sep 2018 19:54:36 +0200
Message-ID: <20180918175436.19742-14-drjones@redhat.com>
References: <20180918175436.19742-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 378644A1D0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 13:55:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SEWv+dTyZVoO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Sep 2018 13:55:25 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0DECF4A254
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 13:55:25 -0400 (EDT)
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
 tools/testing/selftests/kvm/dirty_log_test.c | 65 +++++++++++++++-----
 1 file changed, 50 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 61396882ad4e..d59820cc2d39 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -26,11 +26,8 @@
 /* The memory slot index to track dirty pages */
 #define TEST_MEM_SLOT_INDEX		1
 
-/*
- * GPA offset of the testing memory slot. Must be bigger than the
- * default vm mem slot, which is DEFAULT_GUEST_PHY_PAGES.
- */
-#define TEST_MEM_OFFSET			(1ul << 30) /* 1G */
+/* Default guest test memory offset, 1G */
+#define DEFAULT_GUEST_TEST_MEM		0x40000000
 
 /* How many pages to dirty for each guest loop */
 #define TEST_PAGES_PER_LOOP		1024
@@ -53,6 +50,12 @@ static uint64_t guest_num_pages;
 static uint64_t random_array[TEST_PAGES_PER_LOOP];
 static uint64_t iteration;
 
+/*
+ * GPA offset of the testing memory slot. Must be bigger than
+ * DEFAULT_GUEST_PHY_PAGES.
+ */
+static uint64_t guest_test_mem = DEFAULT_GUEST_TEST_MEM;
+
 /*
  * Continuously write to the first 8 bytes of a random pages within
  * the testing memory region.
@@ -63,7 +66,7 @@ static void guest_code(void)
 
 	while (true) {
 		for (i = 0; i < TEST_PAGES_PER_LOOP; i++) {
-			uint64_t addr = TEST_MEM_OFFSET;
+			uint64_t addr = guest_test_mem;
 			addr += (READ_ONCE(random_array[i]) % guest_num_pages)
 				* guest_page_size;
 			addr &= ~(host_page_size - 1);
@@ -221,20 +224,29 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
 }
 
 static void run_test(enum vm_guest_mode mode, unsigned long iterations,
-		     unsigned long interval)
+		     unsigned long interval, bool top_offset)
 {
-	unsigned int guest_page_shift;
+	unsigned int guest_pa_bits, guest_page_shift;
 	pthread_t vcpu_thread;
 	struct kvm_vm *vm;
+	uint64_t max_gfn;
 	unsigned long *bmap;
 
 	switch (mode) {
 	case VM_MODE_P52V48_4K:
-	case VM_MODE_P40V48_4K:
+		guest_pa_bits = 52;
 		guest_page_shift = 12;
 		break;
 	case VM_MODE_P52V48_64K:
+		guest_pa_bits = 52;
+		guest_page_shift = 16;
+		break;
+	case VM_MODE_P40V48_4K:
+		guest_pa_bits = 40;
+		guest_page_shift = 12;
+		break;
 	case VM_MODE_P40V48_64K:
+		guest_pa_bits = 40;
 		guest_page_shift = 16;
 		break;
 	default:
@@ -243,6 +255,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 
 	DEBUG("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
+	max_gfn = (1ul << (guest_pa_bits - guest_page_shift)) - 1;
 	guest_page_size = (1ul << guest_page_shift);
 	/* 1G of guest page sized pages */
 	guest_num_pages = (1ul << (30 - guest_page_shift));
@@ -250,6 +263,13 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 	host_num_pages = (guest_num_pages * guest_page_size) / host_page_size +
 			 !!((guest_num_pages * guest_page_size) % host_page_size);
 
+	if (top_offset) {
+		guest_test_mem = (max_gfn - guest_num_pages) * guest_page_size;
+		guest_test_mem &= ~(host_page_size - 1);
+	}
+
+	DEBUG("guest test mem offset: 0x%lx\n", guest_test_mem);
+
 	bmap = bitmap_alloc(host_num_pages);
 	host_bmap_track = bitmap_alloc(host_num_pages);
 
@@ -257,17 +277,17 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 
 	/* Add an extra memory slot for testing dirty logging */
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
-				    TEST_MEM_OFFSET,
+				    guest_test_mem,
 				    TEST_MEM_SLOT_INDEX,
 				    guest_num_pages,
 				    KVM_MEM_LOG_DIRTY_PAGES);
 
 	/* Do 1:1 mapping for the dirty track memory slot */
-	virt_map(vm, TEST_MEM_OFFSET, TEST_MEM_OFFSET,
+	virt_map(vm, guest_test_mem, guest_test_mem,
 		 guest_num_pages * guest_page_size, 0);
 
 	/* Cache the HVA pointer of the region */
-	host_test_mem = addr_gpa2hva(vm, (vm_paddr_t)TEST_MEM_OFFSET);
+	host_test_mem = addr_gpa2hva(vm, (vm_paddr_t)guest_test_mem);
 
 #ifdef __x86_64__
 	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
@@ -279,6 +299,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 	/* Export the shared variables to the guest */
 	sync_global_to_guest(vm, host_page_size);
 	sync_global_to_guest(vm, guest_page_size);
+	sync_global_to_guest(vm, guest_test_mem);
 	sync_global_to_guest(vm, guest_num_pages);
 
 	/* Start the iterations */
@@ -337,12 +358,17 @@ static void help(char *name)
 	int i;
 
 	puts("");
-	printf("usage: %s [-h] [-i iterations] [-I interval] [-m mode]\n", name);
+	printf("usage: %s [-h] [-i iterations] [-I interval] "
+	       "[-o offset] [-t] [-m mode]\n", name);
 	puts("");
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
 	       TEST_HOST_LOOP_N);
 	printf(" -I: specify interval in ms (default: %"PRIu64" ms)\n",
 	       TEST_HOST_LOOP_INTERVAL);
+	printf(" -o: guest test memory offset (default: 0x%lx)\n",
+	       DEFAULT_GUEST_TEST_MEM);
+	printf(" -t: map guest test memory at the top of the allowed "
+	       "physical address range\n");
 	printf(" -m: specify the guest mode ID to test "
 	       "(default: test all supported modes)\n"
 	       "     This option may be used multiple times.\n"
@@ -362,10 +388,11 @@ int main(int argc, char *argv[])
 	unsigned long iterations = TEST_HOST_LOOP_N;
 	unsigned long interval = TEST_HOST_LOOP_INTERVAL;
 	bool mode_selected = false;
+	bool top_offset = false;
 	unsigned int mode;
 	int opt, i;
 
-	while ((opt = getopt(argc, argv, "hi:I:m:")) != -1) {
+	while ((opt = getopt(argc, argv, "hi:I:o:tm:")) != -1) {
 		switch (opt) {
 		case 'i':
 			iterations = strtol(optarg, NULL, 10);
@@ -373,6 +400,12 @@ int main(int argc, char *argv[])
 		case 'I':
 			interval = strtol(optarg, NULL, 10);
 			break;
+		case 'o':
+			guest_test_mem = strtoull(optarg, NULL, 0);
+			break;
+		case 't':
+			top_offset = true;
+			break;
 		case 'm':
 			if (!mode_selected) {
 				for (i = 0; i < NUM_VM_MODES; ++i)
@@ -393,6 +426,8 @@ int main(int argc, char *argv[])
 
 	TEST_ASSERT(iterations > 2, "Iterations must be greater than two");
 	TEST_ASSERT(interval > 0, "Interval must be greater than zero");
+	TEST_ASSERT(!top_offset || guest_test_mem == DEFAULT_GUEST_TEST_MEM,
+		    "Cannot use both -o [offset] and -t at the same time");
 
 	DEBUG("Test iterations: %"PRIu64", interval: %"PRIu64" (ms)\n",
 	      iterations, interval);
@@ -406,7 +441,7 @@ int main(int argc, char *argv[])
 			    "Guest mode ID %d (%s) not supported.",
 			    vm_guest_modes[i].mode,
 			    vm_guest_mode_string(vm_guest_modes[i].mode));
-		run_test(vm_guest_modes[i].mode, iterations, interval);
+		run_test(vm_guest_modes[i].mode, iterations, interval, top_offset);
 	}
 
 	return 0;
-- 
2.17.1
