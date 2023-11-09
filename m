Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52753986D
	for <kvmarm@lists.linux.dev>; Thu,  9 Nov 2023 21:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kEyCZCHP"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5af592fed43so17851197b3.2
        for <kvmarm@lists.linux.dev>; Thu, 09 Nov 2023 13:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699563838; x=1700168638; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ebcFSdFa++R257OKZj60sR0YHtuRHuIkQtR+xwo+tiE=;
        b=kEyCZCHPUApUcdfFAiaqrj7nbNwkOZJSyqEWoxpaXTwXvOnvE2x9OxuJKRTfm2d34Z
         45IXhpk6Fqred66s+Jx4AqHE2/lSdOCjrYjQ/E0ffcFTNfj8fknZ2SFt9YTOCFhkGtQr
         mGusXUBnpoWc9PjYKD1uPwXo2bMw7ErjVpdtqfPkuEkn6nL35n/uO0nP7EagFdPoUFy9
         uCTDniMOBcvSzbfC7LL53RpsxdwiUUETdL2lf25wn6zIXeI2uyiZJWEvjV7268qll/kg
         L4ncmF+h5bNbiIertnmxm91V09v+AP3AwBYjgEYuNhQOXczkJHTUk8fI2o/t4Gt/9XbD
         GfSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699563838; x=1700168638;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ebcFSdFa++R257OKZj60sR0YHtuRHuIkQtR+xwo+tiE=;
        b=HLcpVphd4zB+HDHGO3iGuWw+AoFF33dBZAAFxdmkITa69Rt/mujtOxZJEe8lPGCJUf
         i1UtcN/XyeSNRFQKs0h5ftF3RsSi0YD4wX9Q5OgVcLTfELacHGHEq6DH34QGiPOaeUn/
         0aO8xUc5IMsWMR/2hJ6YCyAQFHxBibPNys/HzPOYqq37q+AhxUbvcEnO5oDu3IMBpIKS
         cZqv78YOjBrYP4aUBW57kZ408yUCe3JjAbkxodBoIodN8pvsxnRto1vkU7f0ecXkjOMz
         lB1+qsilGBJQVyJjQ1YuuoNqirg199w8hhnd2aS3UuvYWcDE3UxfJK0sRXV/0Mdhjdf1
         t3Sw==
X-Gm-Message-State: AOJu0YyYyJe4QwWhaBnANkmzSr8RKgpqGydFu3G57F5UdfCUiBjftNM+
	dneuOYj6Q/yIizwaAL6e2PKPjWtmoFOQjg==
X-Google-Smtp-Source: AGHT+IEpMK+w1yaYJDTMb00d7SXUilcTamTn9YrAyFRRyCMycM7ow5u4aT2y4zOC/qHpA+LckxXipp6JbevdfA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:da44:0:b0:d89:dd12:163d with SMTP id
 n65-20020a25da44000000b00d89dd12163dmr155114ybf.1.1699563838720; Thu, 09 Nov
 2023 13:03:58 -0800 (PST)
Date: Thu,  9 Nov 2023 21:03:25 +0000
In-Reply-To: <20231109210325.3806151-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231109210325.3806151-15-amoorthy@google.com>
Subject: [PATCH v6 14/14] KVM: selftests: Handle memory fault exits in demand_paging_test
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

Demonstrate a (very basic) scheme for supporting memory fault exits.

From the vCPU threads:
1. Simply issue UFFDIO_COPY/CONTINUEs in response to memory fault exits,
   with the purpose of establishing the absent mappings. Do so with
   wake_waiters=false to avoid serializing on the userfaultfd wait queue
   locks.

2. When the UFFDIO_COPY/CONTINUE in (1) fails with EEXIST,
   assume that the mapping was already established but is currently
   absent [A] and attempt to populate it using MADV_POPULATE_WRITE.

Issue UFFDIO_COPY/CONTINUEs from the reader threads as well, but with
wake_waiters=true to ensure that any threads sleeping on the uffd are
eventually woken up.

A real VMM would track whether it had already COPY/CONTINUEd pages (eg,
via a bitmap) to avoid calls destined to EEXIST. However, even the
naive approach is enough to demonstrate the performance advantages of
KVM_EXIT_MEMORY_FAULT.

[A] In reality it is much likelier that the vCPU thread simply lost a
    race to establish the mapping for the page.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
Acked-by: James Houghton <jthoughton@google.com>
---
 .../selftests/kvm/demand_paging_test.c        | 245 +++++++++++++-----
 1 file changed, 173 insertions(+), 72 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 61bb2e23bef0..44bdcc7aad87 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -15,6 +15,7 @@
 #include <time.h>
 #include <pthread.h>
 #include <linux/userfaultfd.h>
+#include <linux/mman.h>
 #include <sys/syscall.h>
 
 #include "kvm_util.h"
@@ -31,36 +32,102 @@ static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
 static size_t demand_paging_size;
 static char *guest_data_prototype;
 
+static int num_uffds;
+static size_t uffd_region_size;
+static struct uffd_desc **uffd_descs;
+/*
+ * Delay when demand paging is performed through userfaultfd or directly by
+ * vcpu_worker in the case of an annotated memory fault.
+ */
+static useconds_t uffd_delay;
+static int uffd_mode;
+
+
+static int handle_uffd_page_request(int uffd_mode, int uffd, uint64_t hva,
+				    bool is_vcpu);
+
+static void madv_write_or_err(uint64_t gpa)
+{
+	int r;
+	void *hva = addr_gpa2hva(memstress_args.vm, gpa);
+
+	r = madvise(hva, demand_paging_size, MADV_POPULATE_WRITE);
+	TEST_ASSERT(r == 0,
+		    "MADV_POPULATE_WRITE on hva 0x%lx (gpa 0x%lx) fail, errno %i\n",
+		    (uintptr_t) hva, gpa, errno);
+}
+
+static void ready_page(uint64_t gpa)
+{
+	int r, uffd;
+
+	/*
+	 * This test only registers memslot 1 w/ userfaultfd. Any accesses outside
+	 * the registered ranges should fault in the physical pages through
+	 * MADV_POPULATE_WRITE.
+	 */
+	if ((gpa < memstress_args.gpa)
+		|| (gpa >= memstress_args.gpa + memstress_args.size)) {
+		madv_write_or_err(gpa);
+	} else {
+		if (uffd_delay)
+			usleep(uffd_delay);
+
+		uffd = uffd_descs[(gpa - memstress_args.gpa) / uffd_region_size]->uffd;
+
+		r = handle_uffd_page_request(uffd_mode, uffd,
+					     (uint64_t) addr_gpa2hva(memstress_args.vm, gpa), true);
+
+		if (r == EEXIST)
+			madv_write_or_err(gpa);
+	}
+}
+
 static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 {
 	struct kvm_vcpu *vcpu = vcpu_args->vcpu;
 	int vcpu_idx = vcpu_args->vcpu_idx;
 	struct kvm_run *run = vcpu->run;
-	struct timespec start;
-	struct timespec ts_diff;
+	struct timespec last_start;
+	struct timespec total_runtime = {};
 	int ret;
-
-	clock_gettime(CLOCK_MONOTONIC, &start);
-
-	/* Let the guest access its memory */
-	ret = _vcpu_run(vcpu);
-	TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
-	if (get_ucall(vcpu, NULL) != UCALL_SYNC) {
-		TEST_ASSERT(false,
-			    "Invalid guest sync status: exit_reason=%s\n",
-			    exit_reason_str(run->exit_reason));
+	u64 num_memory_fault_exits = 0;
+	bool annotated_memory_fault = false;
+
+	while (true) {
+		clock_gettime(CLOCK_MONOTONIC, &last_start);
+		/* Let the guest access its memory */
+		ret = _vcpu_run(vcpu);
+		annotated_memory_fault = errno == EFAULT
+					 && run->exit_reason == KVM_EXIT_MEMORY_FAULT;
+		TEST_ASSERT(ret == 0 || annotated_memory_fault,
+			    "vcpu_run failed: %d\n", ret);
+
+		total_runtime = timespec_add(total_runtime,
+					     timespec_elapsed(last_start));
+		if (ret != 0 && get_ucall(vcpu, NULL) != UCALL_SYNC) {
+
+			if (annotated_memory_fault) {
+				++num_memory_fault_exits;
+				ready_page(run->memory_fault.gpa);
+				continue;
+			}
+
+			TEST_ASSERT(false,
+				    "Invalid guest sync status: exit_reason=%s\n",
+				    exit_reason_str(run->exit_reason));
+		}
+		break;
 	}
-
-	ts_diff = timespec_elapsed(start);
-	PER_VCPU_DEBUG("vCPU %d execution time: %ld.%.9lds\n", vcpu_idx,
-		       ts_diff.tv_sec, ts_diff.tv_nsec);
+	PER_VCPU_DEBUG("vCPU %d execution time: %ld.%.9lds, %d memory fault exits\n",
+		       vcpu_idx, total_runtime.tv_sec, total_runtime.tv_nsec,
+		       num_memory_fault_exits);
 }
 
-static int handle_uffd_page_request(int uffd_mode, int uffd,
-		struct uffd_msg *msg)
+static int handle_uffd_page_request(int uffd_mode, int uffd, uint64_t hva,
+				    bool is_vcpu)
 {
 	pid_t tid = syscall(__NR_gettid);
-	uint64_t addr = msg->arg.pagefault.address;
 	struct timespec start;
 	struct timespec ts_diff;
 	int r;
@@ -71,16 +138,15 @@ static int handle_uffd_page_request(int uffd_mode, int uffd,
 		struct uffdio_copy copy;
 
 		copy.src = (uint64_t)guest_data_prototype;
-		copy.dst = addr;
+		copy.dst = hva;
 		copy.len = demand_paging_size;
-		copy.mode = 0;
+		copy.mode = is_vcpu ? UFFDIO_COPY_MODE_DONTWAKE : 0;
 
-		r = ioctl(uffd, UFFDIO_COPY, &copy);
 		/*
-		 * With multiple vCPU threads fault on a single page and there are
-		 * multiple readers for the UFFD, at least one of the UFFDIO_COPYs
-		 * will fail with EEXIST: handle that case without signaling an
-		 * error.
+		 * With multiple vCPU threads and at least one of multiple reader threads
+		 * or vCPU memory faults, multiple vCPUs accessing an absent page will
+		 * almost certainly cause some thread doing the UFFDIO_COPY here to get
+		 * EEXIST: make sure to allow that case.
 		 *
 		 * Note that this also suppress any EEXISTs occurring from,
 		 * e.g., the first UFFDIO_COPY/CONTINUEs on a page. That never
@@ -88,23 +154,24 @@ static int handle_uffd_page_request(int uffd_mode, int uffd,
 		 * some external state to correctly surface EEXISTs to userspace
 		 * (or prevent duplicate COPY/CONTINUEs in the first place).
 		 */
-		if (r == -1 && errno != EEXIST) {
-			pr_info("Failed UFFDIO_COPY in 0x%lx from thread %d, errno = %d\n",
-				addr, tid, errno);
-			return r;
-		}
+		r = ioctl(uffd, UFFDIO_COPY, &copy);
+		TEST_ASSERT(r == 0 || errno == EEXIST,
+			    "Thread 0x%x failed UFFDIO_COPY on hva 0x%lx, errno = %d",
+			    tid, hva, errno);
 	} else if (uffd_mode == UFFDIO_REGISTER_MODE_MINOR) {
+		/* The comments in the UFFDIO_COPY branch also apply here. */
 		struct uffdio_continue cont = {0};
 
-		cont.range.start = addr;
+		cont.range.start = hva;
 		cont.range.len = demand_paging_size;
+		cont.mode = is_vcpu ? UFFDIO_CONTINUE_MODE_DONTWAKE : 0;
 
 		r = ioctl(uffd, UFFDIO_CONTINUE, &cont);
 		/*
-		 * With multiple vCPU threads fault on a single page and there are
-		 * multiple readers for the UFFD, at least one of the UFFDIO_COPYs
-		 * will fail with EEXIST: handle that case without signaling an
-		 * error.
+		 * With multiple vCPU threads and at least one of multiple reader threads
+		 * or vCPU memory faults, multiple vCPUs accessing an absent page will
+		 * almost certainly cause some thread doing the UFFDIO_COPY here to get
+		 * EEXIST: make sure to allow that case.
 		 *
 		 * Note that this also suppress any EEXISTs occurring from,
 		 * e.g., the first UFFDIO_COPY/CONTINUEs on a page. That never
@@ -112,32 +179,54 @@ static int handle_uffd_page_request(int uffd_mode, int uffd,
 		 * some external state to correctly surface EEXISTs to userspace
 		 * (or prevent duplicate COPY/CONTINUEs in the first place).
 		 */
-		if (r == -1 && errno != EEXIST) {
-			pr_info("Failed UFFDIO_CONTINUE in 0x%lx, thread %d, errno = %d\n",
-				addr, tid, errno);
-			return r;
-		}
+		TEST_ASSERT(r == 0 || errno == EEXIST,
+			    "Thread 0x%x failed UFFDIO_CONTINUE on hva 0x%lx, errno = %d",
+			    tid, hva, errno);
 	} else {
 		TEST_FAIL("Invalid uffd mode %d", uffd_mode);
 	}
 
+	/*
+	 * If the above UFFDIO_COPY/CONTINUE failed with EEXIST, waiting threads
+	 * will not have been woken: wake them here.
+	 */
+	if (!is_vcpu && r != 0) {
+		struct uffdio_range range = {
+			.start = hva,
+			.len = demand_paging_size
+		};
+		r = ioctl(uffd, UFFDIO_WAKE, &range);
+		TEST_ASSERT(r == 0,
+			    "Thread 0x%x failed UFFDIO_WAKE on hva 0x%lx, errno = %d",
+			    tid, hva, errno);
+	}
+
 	ts_diff = timespec_elapsed(start);
 
 	PER_PAGE_DEBUG("UFFD page-in %d \t%ld ns\n", tid,
 		       timespec_to_ns(ts_diff));
 	PER_PAGE_DEBUG("Paged in %ld bytes at 0x%lx from thread %d\n",
-		       demand_paging_size, addr, tid);
+		       demand_paging_size, hva, tid);
 
 	return 0;
 }
 
+static int handle_uffd_page_request_from_uffd(int uffd_mode, int uffd,
+					      struct uffd_msg *msg)
+{
+	TEST_ASSERT(msg->event == UFFD_EVENT_PAGEFAULT,
+		    "Received uffd message with event %d != UFFD_EVENT_PAGEFAULT",
+		    msg->event);
+	return handle_uffd_page_request(uffd_mode, uffd,
+					msg->arg.pagefault.address, false);
+}
+
 struct test_params {
-	int uffd_mode;
 	bool single_uffd;
-	useconds_t uffd_delay;
 	int readers_per_uffd;
 	enum vm_mem_backing_src_type src_type;
 	bool partition_vcpu_memory_access;
+	bool memfault_exits;
 };
 
 static void prefault_mem(void *alias, uint64_t len)
@@ -155,16 +244,22 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 {
 	struct memstress_vcpu_args *vcpu_args;
 	struct test_params *p = arg;
-	struct uffd_desc **uffd_descs = NULL;
 	struct timespec start;
 	struct timespec ts_diff;
 	struct kvm_vm *vm;
-	int i, num_uffds = 0;
+	int i;
 	double vcpu_paging_rate;
-	uint64_t uffd_region_size;
+	uint32_t slot_flags = 0;
+	bool uffd_memfault_exits = uffd_mode && p->memfault_exits;
 
-	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1, 0,
-				 p->src_type, p->partition_vcpu_memory_access);
+	if (uffd_memfault_exits) {
+		TEST_ASSERT(kvm_has_cap(KVM_CAP_EXIT_ON_MISSING) > 0,
+					"KVM does not have KVM_CAP_EXIT_ON_MISSING");
+		slot_flags = KVM_MEM_EXIT_ON_MISSING;
+	}
+
+	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size,
+				 1, slot_flags, p->src_type, p->partition_vcpu_memory_access);
 
 	demand_paging_size = get_backing_src_pagesz(p->src_type);
 
@@ -173,21 +268,21 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		    "Failed to allocate buffer for guest data pattern");
 	memset(guest_data_prototype, 0xAB, demand_paging_size);
 
-	if (p->uffd_mode == UFFDIO_REGISTER_MODE_MINOR) {
-		num_uffds = p->single_uffd ? 1 : nr_vcpus;
-		for (i = 0; i < num_uffds; i++) {
-			vcpu_args = &memstress_args.vcpu_args[i];
-			prefault_mem(addr_gpa2alias(vm, vcpu_args->gpa),
-				     vcpu_args->pages * memstress_args.guest_page_size);
-		}
-	}
-
-	if (p->uffd_mode) {
+	if (uffd_mode) {
 		num_uffds = p->single_uffd ? 1 : nr_vcpus;
 		uffd_region_size = nr_vcpus * guest_percpu_mem_size / num_uffds;
 
+		if (uffd_mode == UFFDIO_REGISTER_MODE_MINOR) {
+			for (i = 0; i < num_uffds; i++) {
+				vcpu_args = &memstress_args.vcpu_args[i];
+				prefault_mem(addr_gpa2alias(vm, vcpu_args->gpa),
+					     uffd_region_size);
+			}
+		}
+
 		uffd_descs = malloc(num_uffds * sizeof(struct uffd_desc *));
-		TEST_ASSERT(uffd_descs, "Memory allocation failed");
+		TEST_ASSERT(uffd_descs, "Failed to allocate uffd descriptors");
+
 		for (i = 0; i < num_uffds; i++) {
 			struct memstress_vcpu_args *vcpu_args;
 			void *vcpu_hva;
@@ -201,10 +296,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 			 * requests.
 			 */
 			uffd_descs[i] = uffd_setup_demand_paging(
-				p->uffd_mode, p->uffd_delay, vcpu_hva,
+				uffd_mode, uffd_delay, vcpu_hva,
 				uffd_region_size,
 				p->readers_per_uffd,
-				&handle_uffd_page_request);
+				&handle_uffd_page_request_from_uffd);
 		}
 	}
 
@@ -218,7 +313,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	ts_diff = timespec_elapsed(start);
 	pr_info("All vCPU threads joined\n");
 
-	if (p->uffd_mode) {
+	if (uffd_mode) {
 		/* Tell the user fault fd handler threads to quit */
 		for (i = 0; i < num_uffds; i++)
 			uffd_stop_demand_paging(uffd_descs[i]);
@@ -239,7 +334,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	memstress_destroy_vm(vm);
 
 	free(guest_data_prototype);
-	if (p->uffd_mode)
+	if (uffd_mode)
 		free(uffd_descs);
 }
 
@@ -248,7 +343,8 @@ static void help(char *name)
 	puts("");
 	printf("usage: %s [-h] [-m vm_mode] [-u uffd_mode] [-a]\n"
 		   "          [-d uffd_delay_usec] [-r readers_per_uffd] [-b memory]\n"
-		   "          [-s type] [-v vcpus] [-c cpu_list] [-o]\n", name);
+		   "          [-s type] [-v vcpus] [-c cpu_list] [-o] [-w] \n",
+	       name);
 	guest_modes_help();
 	printf(" -u: use userfaultfd to handle vCPU page faults. Mode is a\n"
 	       "     UFFD registration mode: 'MISSING' or 'MINOR'.\n");
@@ -260,6 +356,7 @@ static void help(char *name)
 	       "     FD handler to simulate demand paging\n"
 	       "     overheads. Ignored without -u.\n");
 	printf(" -r: Set the number of reader threads per uffd.\n");
+	printf(" -w: Enable kvm cap for memory fault exits.\n");
 	printf(" -b: specify the size of the memory region which should be\n"
 	       "     demand paged by each vCPU. e.g. 10M or 3G.\n"
 	       "     Default: 1G\n");
@@ -280,29 +377,30 @@ int main(int argc, char *argv[])
 		.partition_vcpu_memory_access = true,
 		.readers_per_uffd = 1,
 		.single_uffd = false,
+		.memfault_exits = false,
 	};
 	int opt;
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "ahom:u:d:b:s:v:c:r:")) != -1) {
+	while ((opt = getopt(argc, argv, "ahowm:u:d:b:s:v:c:r:")) != -1) {
 		switch (opt) {
 		case 'm':
 			guest_modes_cmdline(optarg);
 			break;
 		case 'u':
 			if (!strcmp("MISSING", optarg))
-				p.uffd_mode = UFFDIO_REGISTER_MODE_MISSING;
+				uffd_mode = UFFDIO_REGISTER_MODE_MISSING;
 			else if (!strcmp("MINOR", optarg))
-				p.uffd_mode = UFFDIO_REGISTER_MODE_MINOR;
-			TEST_ASSERT(p.uffd_mode, "UFFD mode must be 'MISSING' or 'MINOR'.");
+				uffd_mode = UFFDIO_REGISTER_MODE_MINOR;
+			TEST_ASSERT(uffd_mode, "UFFD mode must be 'MISSING' or 'MINOR'.");
 			break;
 		case 'a':
 			p.single_uffd = true;
 			break;
 		case 'd':
-			p.uffd_delay = strtoul(optarg, NULL, 0);
-			TEST_ASSERT(p.uffd_delay >= 0, "A negative UFFD delay is not supported.");
+			uffd_delay = strtoul(optarg, NULL, 0);
+			TEST_ASSERT(uffd_delay >= 0, "A negative UFFD delay is not supported.");
 			break;
 		case 'b':
 			guest_percpu_mem_size = parse_size(optarg);
@@ -328,6 +426,9 @@ int main(int argc, char *argv[])
 				    "Invalid number of readers per uffd %d: must be >=1",
 				    p.readers_per_uffd);
 			break;
+		case 'w':
+			p.memfault_exits = true;
+			break;
 		case 'h':
 		default:
 			help(argv[0]);
@@ -335,7 +436,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	if (p.uffd_mode == UFFDIO_REGISTER_MODE_MINOR &&
+	if (uffd_mode == UFFDIO_REGISTER_MODE_MINOR &&
 	    !backing_src_is_shared(p.src_type)) {
 		TEST_FAIL("userfaultfd MINOR mode requires shared memory; pick a different -s");
 	}
-- 
2.42.0.869.gea05f2083d-goog

