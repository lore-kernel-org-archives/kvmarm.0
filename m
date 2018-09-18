From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 11/13] kvm: selftests: dirty_log_test: also test 64K pages on
 aarch64
Date: Tue, 18 Sep 2018 19:54:34 +0200
Message-ID: <20180918175436.19742-12-drjones@redhat.com>
References: <20180918175436.19742-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55FE64A27C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 13:55:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8JVw3VSE2OZe for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Sep 2018 13:55:13 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 77E2C4A20B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 13:55:12 -0400 (EDT)
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
 tools/testing/selftests/kvm/dirty_log_test.c | 183 ++++++++++++++-----
 1 file changed, 137 insertions(+), 46 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index d90f1091f687..3afc7d607a2e 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -5,6 +5,8 @@
  * Copyright (C) 2018, Red Hat, Inc.
  */
 
+#define _GNU_SOURCE /* for program_invocation_name */
+
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
@@ -30,9 +32,6 @@
  */
 #define TEST_MEM_OFFSET			(1ul << 30) /* 1G */
 
-/* Size of the testing memory slot */
-#define TEST_MEM_PAGES			(1ul << 18) /* 1G for 4K pages */
-
 /* How many pages to dirty for each guest loop */
 #define TEST_PAGES_PER_LOOP		1024
 
@@ -50,6 +49,7 @@
  */
 static uint64_t host_page_size;
 static uint64_t guest_page_size;
+static uint64_t guest_num_pages;
 static uint64_t random_array[TEST_PAGES_PER_LOOP];
 static uint64_t iteration;
 
@@ -64,7 +64,7 @@ static void guest_code(void)
 	while (true) {
 		for (i = 0; i < TEST_PAGES_PER_LOOP; i++) {
 			uint64_t addr = TEST_MEM_OFFSET;
-			addr += (READ_ONCE(random_array[i]) % TEST_MEM_PAGES)
+			addr += (READ_ONCE(random_array[i]) % guest_num_pages)
 				* guest_page_size;
 			addr &= ~(host_page_size - 1);
 			*(uint64_t *)addr = READ_ONCE(iteration);
@@ -141,8 +141,10 @@ static void vm_dirty_log_verify(unsigned long *bmap)
 {
 	uint64_t page;
 	uint64_t *value_ptr;
+	uint64_t step = host_page_size >= guest_page_size ? 1 :
+				guest_page_size / host_page_size;
 
-	for (page = 0; page < host_num_pages; page++) {
+	for (page = 0; page < host_num_pages; page += step) {
 		value_ptr = host_test_mem + page * host_page_size;
 
 		/* If this is a special page that we were tracking... */
@@ -203,71 +205,64 @@ static void vm_dirty_log_verify(unsigned long *bmap)
 	}
 }
 
-static void help(char *name)
+static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
+				uint64_t extra_mem_pages, void *guest_code)
 {
-	puts("");
-	printf("usage: %s [-i iterations] [-I interval] [-h]\n", name);
-	puts("");
-	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
-	       TEST_HOST_LOOP_N);
-	printf(" -I: specify interval in ms (default: %"PRIu64" ms)\n",
-	       TEST_HOST_LOOP_INTERVAL);
-	puts("");
-	exit(0);
+	struct kvm_vm *vm;
+	uint64_t extra_pg_pages = extra_mem_pages / 512 * 2;
+
+	vm = vm_create(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages, O_RDWR);
+	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
+#ifdef __x86_64__
+	vm_create_irqchip(vm);
+#endif
+	vm_vcpu_add_default(vm, vcpuid, guest_code);
+	return vm;
 }
 
-int main(int argc, char *argv[])
+static void run_test(enum vm_guest_mode mode, unsigned long iterations,
+		     unsigned long interval)
 {
+	unsigned int guest_page_shift;
 	pthread_t vcpu_thread;
 	struct kvm_vm *vm;
-	unsigned long iterations = TEST_HOST_LOOP_N;
-	unsigned long interval = TEST_HOST_LOOP_INTERVAL;
 	unsigned long *bmap;
-	int opt;
 
-	while ((opt = getopt(argc, argv, "hi:I:")) != -1) {
-		switch (opt) {
-		case 'i':
-			iterations = strtol(optarg, NULL, 10);
-			break;
-		case 'I':
-			interval = strtol(optarg, NULL, 10);
-			break;
-		case 'h':
-		default:
-			help(argv[0]);
-			break;
-		}
+	switch (mode) {
+	case VM_MODE_P52V48_4K:
+		guest_page_shift = 12;
+		break;
+	case VM_MODE_P52V48_64K:
+		guest_page_shift = 16;
+		break;
+	default:
+		TEST_ASSERT(false, "Unknown guest mode, mode: 0x%x", mode);
 	}
 
-	TEST_ASSERT(iterations > 2, "Iterations must be greater than two");
-	TEST_ASSERT(interval > 0, "Interval must be greater than zero");
-
-	DEBUG("Test iterations: %"PRIu64", interval: %"PRIu64" (ms)\n",
-	      iterations, interval);
-
-	srandom(time(0));
+	DEBUG("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
-	guest_page_size = 4096;
+	guest_page_size = (1ul << guest_page_shift);
+	/* 1G of guest page sized pages */
+	guest_num_pages = (1ul << (30 - guest_page_shift));
 	host_page_size = getpagesize();
-	host_num_pages = (TEST_MEM_PAGES * guest_page_size) / host_page_size +
-			 !!((TEST_MEM_PAGES * guest_page_size) % host_page_size);
+	host_num_pages = (guest_num_pages * guest_page_size) / host_page_size +
+			 !!((guest_num_pages * guest_page_size) % host_page_size);
 
 	bmap = bitmap_alloc(host_num_pages);
 	host_bmap_track = bitmap_alloc(host_num_pages);
 
-	vm = vm_create_default(VCPU_ID, TEST_MEM_PAGES, guest_code);
+	vm = create_vm(mode, VCPU_ID, guest_num_pages, guest_code);
 
 	/* Add an extra memory slot for testing dirty logging */
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
 				    TEST_MEM_OFFSET,
 				    TEST_MEM_SLOT_INDEX,
-				    TEST_MEM_PAGES,
+				    guest_num_pages,
 				    KVM_MEM_LOG_DIRTY_PAGES);
 
 	/* Do 1:1 mapping for the dirty track memory slot */
 	virt_map(vm, TEST_MEM_OFFSET, TEST_MEM_OFFSET,
-		 TEST_MEM_PAGES * guest_page_size, 0);
+		 guest_num_pages * guest_page_size, 0);
 
 	/* Cache the HVA pointer of the region */
 	host_test_mem = addr_gpa2hva(vm, (vm_paddr_t)TEST_MEM_OFFSET);
@@ -279,13 +274,18 @@ int main(int argc, char *argv[])
 	ucall_init(vm, UCALL_MMIO, NULL);
 #endif
 
-	/* Tell the guest about the page sizes */
+	/* Export the shared variables to the guest */
 	sync_global_to_guest(vm, host_page_size);
 	sync_global_to_guest(vm, guest_page_size);
+	sync_global_to_guest(vm, guest_num_pages);
 
 	/* Start the iterations */
 	iteration = 1;
 	sync_global_to_guest(vm, iteration);
+	host_quit = false;
+	host_dirty_count = 0;
+	host_clear_count = 0;
+	host_track_next_count = 0;
 
 	pthread_create(&vcpu_thread, NULL, vcpu_worker, vm);
 
@@ -310,6 +310,97 @@ int main(int argc, char *argv[])
 	free(host_bmap_track);
 	ucall_uninit(vm);
 	kvm_vm_free(vm);
+}
+
+static struct vm_guest_modes {
+	enum vm_guest_mode mode;
+	bool supported;
+	bool enabled;
+} vm_guest_modes[NUM_VM_MODES] = {
+	{ VM_MODE_P52V48_4K,	1, 1, },
+#ifdef __aarch64__
+	{ VM_MODE_P52V48_64K,	1, 1, },
+#else
+	{ VM_MODE_P52V48_64K,	0, 0, },
+#endif
+};
+
+static void help(char *name)
+{
+	int i;
+
+	puts("");
+	printf("usage: %s [-h] [-i iterations] [-I interval] [-m mode]\n", name);
+	puts("");
+	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
+	       TEST_HOST_LOOP_N);
+	printf(" -I: specify interval in ms (default: %"PRIu64" ms)\n",
+	       TEST_HOST_LOOP_INTERVAL);
+	printf(" -m: specify the guest mode ID to test "
+	       "(default: test all supported modes)\n"
+	       "     This option may be used multiple times.\n"
+	       "     Guest mode IDs:\n");
+	for (i = 0; i < NUM_VM_MODES; ++i) {
+		printf("         %d:    %s%s\n",
+		       vm_guest_modes[i].mode,
+		       vm_guest_mode_string(vm_guest_modes[i].mode),
+		       vm_guest_modes[i].supported ? " (supported)" : "");
+	}
+	puts("");
+	exit(0);
+}
+
+int main(int argc, char *argv[])
+{
+	unsigned long iterations = TEST_HOST_LOOP_N;
+	unsigned long interval = TEST_HOST_LOOP_INTERVAL;
+	bool mode_selected = false;
+	unsigned int mode;
+	int opt, i;
+
+	while ((opt = getopt(argc, argv, "hi:I:m:")) != -1) {
+		switch (opt) {
+		case 'i':
+			iterations = strtol(optarg, NULL, 10);
+			break;
+		case 'I':
+			interval = strtol(optarg, NULL, 10);
+			break;
+		case 'm':
+			if (!mode_selected) {
+				for (i = 0; i < NUM_VM_MODES; ++i)
+					vm_guest_modes[i].enabled = 0;
+				mode_selected = true;
+			}
+			mode = strtoul(optarg, NULL, 10);
+			TEST_ASSERT(mode < NUM_VM_MODES,
+				    "Guest mode ID %d too big", mode);
+			vm_guest_modes[mode].enabled = 1;
+			break;
+		case 'h':
+		default:
+			help(argv[0]);
+			break;
+		}
+	}
+
+	TEST_ASSERT(iterations > 2, "Iterations must be greater than two");
+	TEST_ASSERT(interval > 0, "Interval must be greater than zero");
+
+	DEBUG("Test iterations: %"PRIu64", interval: %"PRIu64" (ms)\n",
+	      iterations, interval);
+
+	srandom(time(0));
+
+	for (i = 0; i < NUM_VM_MODES; ++i) {
+		if (!vm_guest_modes[i].enabled)
+			continue;
+		TEST_ASSERT(vm_guest_modes[i].supported,
+			    "Guest mode ID %d (%s) not supported.",
+			    vm_guest_modes[i].mode,
+			    vm_guest_mode_string(vm_guest_modes[i].mode));
+		run_test(vm_guest_modes[i].mode, iterations, interval);
+	}
 
 	return 0;
 }
-- 
2.17.1
