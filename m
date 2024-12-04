Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4E52066E1
	for <kvmarm@lists.linux.dev>; Wed,  4 Dec 2024 19:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733339668; cv=none; b=UK1vTBk14FulJL6OX/ZF2vSRj/w5TzqpLzQp5I0suebm+8xQDEt9a453LCeMPC3UVVAoildu4DXE1q1tEo4q8JgyGRim/06UHzko7hlpYxXiHpkm5+PJAc6cLPUTrdHk0VvD1wWHwR8O5clPx8T6g9IlNQp7eAmI6MXpXI42yzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733339668; c=relaxed/simple;
	bh=A6jKxWMEyzNXeBvP9WXeKRc07i7+f1O3415UFp2+nGs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ce3W+aOYR48BWTsEdKCD/GRCbCHynnkTjTSkQb3QZ79J9UgIN1eZsP5uVrzXZcrWrCygkhr+vxhAt1bQ2CpsC3QTtoDvD5/2vSe4RUvO+B6T8JIeaaoQUqE9TqJQUneEmy9VoqsJRmUz04h2bDcEEqStTZ3m4OzyIt9F+PsTVSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=et2wxn/P; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="et2wxn/P"
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-71d4a8ede26so110415a34.1
        for <kvmarm@lists.linux.dev>; Wed, 04 Dec 2024 11:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733339665; x=1733944465; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KKPTY6BDHY4CW5kRnLCY0vf32xyzYU5qegQAP5cDTvQ=;
        b=et2wxn/PeE4FHlkOrei6N0z7W8hrH10L8SWXxeS+GGaKrqbupgwUMk11OosWRXa5KW
         AqsbhMTn65necRRoRIYBeYL4fjSay31/kd7dakBXkX0fgsV6QLVki3zfkuaXE3S4eoPZ
         oSR3C2HNPkOg0R9GdkCbfkdGBJpMSyN/HGGe+ysBG50h+ulKFpJUAvrrAyLNhsGNHxaE
         3/qTMtqqRrw+vjGRzLDxYTAeEU7Bff9ILKYyW7a66ONEQ2IS66Fwt0pbtQBWdu0XblNW
         9MggZPUu423EscMbWYhj2bmCivugBM1FQKsX/WBvoiiBAQKeceEp1+8bfTjMA6WfTwd+
         CzjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733339665; x=1733944465;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KKPTY6BDHY4CW5kRnLCY0vf32xyzYU5qegQAP5cDTvQ=;
        b=EA3hlQ3twaavzPWaKiMrzvvz7ZCpZ6fWrcBgy7CB7aDBWhttUwCI6A45bLFBd1GZzP
         LIZQveue0YENGQBMZNhBjQS8IWCN3siwW2ww0BFia3eHUnFbIg1jpdzESndPOGZUnaEM
         59LhGhoS+95MtWQ4m90cR8k1hGwpFJ0kA7giMwVxLn0ia1mi+ZYZJbXdVGRV3mDcNvNV
         LISjYjxEEpAv76kuJXICNJ7mwXrbyGBSZGSxChCvjlcZJ0lIjH6B9Jvsy5OW93Id8MSc
         imr6X6LxhxxFGtYT1reOG3fpHCFhAa3fc7YxIXlYV6QMqUaPvfwjiWO32sg+b2N5THkD
         chGQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRJA7JwHQCUvZaUK8p6fjh2KdPH7FDeQPQcNmhuOWK3UerNJPn3FNd3zOhqcsB8jKPXrmHw7w=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywmp6OW6i7J9WEnj+9RDb1Y1rVPrsfje0Id4h+DOC5gpxnWurzf
	TFYxAlndFXenZybdzD+6kA99QJmSqNcs4KxZD16xUazkQrDU2jylt8zDFC8u7Czsj+vg+MLfI35
	zQJLC92W6mQ/Bn7dwGA==
X-Google-Smtp-Source: AGHT+IGRmJAl02GEWZ0VoWDM6bNhmNgX+yqmM2tYJtx0vayqcYvuWF0Zwi1GxJiTBLfcAQSnK2xzxxMPkd5JZHvn
X-Received: from uabix20.prod.google.com ([2002:a05:6130:6514:b0:85b:6555:97ec])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6358:5bc8:b0:1ca:c972:190d with SMTP id e5c5f4694b2df-1caeabfbddamr693736855d.25.1733339664949;
 Wed, 04 Dec 2024 11:14:24 -0800 (PST)
Date: Wed,  4 Dec 2024 19:13:45 +0000
In-Reply-To: <20241204191349.1730936-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241204191349.1730936-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241204191349.1730936-11-jthoughton@google.com>
Subject: [PATCH v1 10/13] KVM: selftests: Add KVM Userfault mode to demand_paging_test
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, Wang@google.com, Wei W <wei.w.wang@intel.com>, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Add a way for the KVM_RUN loop to handle -EFAULT exits when they are for
KVM_MEMORY_EXIT_FLAG_USERFAULT. In this case, preemptively handle the
UFFDIO_COPY or UFFDIO_CONTINUE if userfaultfd is also in use. This saves
the trip through the userfaultfd poll/read/WAKE loop.

When preemptively handling UFFDIO_COPY/CONTINUE, do so with
MODE_DONTWAKE, as there will not be a thread to wake. If a thread *does*
take the userfaultfd slow path, we will get a regular userfault, and we
will call handle_uffd_page_request() which will do a full wake-up. In
the EEXIST case, a wake-up will not occur. Make sure to call UFFDIO_WAKE
explicitly in this case.

When handling KVM userfaults, make sure to set the bitmap with
memory_order_release. Although it wouldn't affect the functionality of
the test (because memstress doesn't actually require any particular
guest memory contents), it is what userspace normally needs to do.

Add `-k` to set the test to use KVM Userfault.

Add the vm_mem_region_set_flags_userfault() helper for setting
`userfault_bitmap` and KVM_MEM_USERFAULT at the same time.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 .../selftests/kvm/demand_paging_test.c        | 139 +++++++++++++++++-
 .../testing/selftests/kvm/include/kvm_util.h  |   5 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  40 ++++-
 3 files changed, 176 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 315f5c9037b4..e7ea1c57264d 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -12,7 +12,9 @@
 #include <time.h>
 #include <pthread.h>
 #include <linux/userfaultfd.h>
+#include <linux/bitmap.h>
 #include <sys/syscall.h>
+#include <stdatomic.h>
 
 #include "kvm_util.h"
 #include "test_util.h"
@@ -24,11 +26,21 @@
 #ifdef __NR_userfaultfd
 
 static int nr_vcpus = 1;
+static int num_uffds;
 static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
 
 static size_t demand_paging_size;
+static size_t host_page_size;
 static char *guest_data_prototype;
 
+static struct {
+	bool enabled;
+	int uffd_mode; /* set if userfaultfd is also in use */
+	struct uffd_desc **uffd_descs;
+} kvm_userfault_data;
+
+static void resolve_kvm_userfault(u64 gpa, u64 size);
+
 static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 {
 	struct kvm_vcpu *vcpu = vcpu_args->vcpu;
@@ -41,8 +53,22 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 	clock_gettime(CLOCK_MONOTONIC, &start);
 
 	/* Let the guest access its memory */
+restart:
 	ret = _vcpu_run(vcpu);
-	TEST_ASSERT(ret == 0, "vcpu_run failed: %d", ret);
+	if (ret < 0 && errno == EFAULT && kvm_userfault_data.enabled) {
+		/* Check for userfault. */
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_MEMORY_FAULT,
+			    "Got invalid exit reason: %x", run->exit_reason);
+		TEST_ASSERT(run->memory_fault.flags ==
+			    KVM_MEMORY_EXIT_FLAG_USERFAULT,
+			    "Got invalid memory fault exit: %llx",
+			    run->memory_fault.flags);
+		resolve_kvm_userfault(run->memory_fault.gpa,
+				      run->memory_fault.size);
+		goto restart;
+	} else
+		TEST_ASSERT(ret == 0, "vcpu_run failed: %d", ret);
+
 	if (get_ucall(vcpu, NULL) != UCALL_SYNC) {
 		TEST_ASSERT(false,
 			    "Invalid guest sync status: exit_reason=%s",
@@ -54,11 +80,10 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 		       ts_diff.tv_sec, ts_diff.tv_nsec);
 }
 
-static int handle_uffd_page_request(int uffd_mode, int uffd,
-		struct uffd_msg *msg)
+static int resolve_uffd_page_request(int uffd_mode, int uffd, uint64_t addr,
+				     bool wake)
 {
 	pid_t tid = syscall(__NR_gettid);
-	uint64_t addr = msg->arg.pagefault.address;
 	struct timespec start;
 	struct timespec ts_diff;
 	int r;
@@ -71,7 +96,7 @@ static int handle_uffd_page_request(int uffd_mode, int uffd,
 		copy.src = (uint64_t)guest_data_prototype;
 		copy.dst = addr;
 		copy.len = demand_paging_size;
-		copy.mode = 0;
+		copy.mode = wake ? 0 : UFFDIO_COPY_MODE_DONTWAKE;
 
 		r = ioctl(uffd, UFFDIO_COPY, &copy);
 		/*
@@ -96,6 +121,7 @@ static int handle_uffd_page_request(int uffd_mode, int uffd,
 
 		cont.range.start = addr;
 		cont.range.len = demand_paging_size;
+		cont.mode = wake ? 0 : UFFDIO_CONTINUE_MODE_DONTWAKE;
 
 		r = ioctl(uffd, UFFDIO_CONTINUE, &cont);
 		/*
@@ -119,6 +145,20 @@ static int handle_uffd_page_request(int uffd_mode, int uffd,
 		TEST_FAIL("Invalid uffd mode %d", uffd_mode);
 	}
 
+	if (r < 0 && wake) {
+		/*
+		 * No wake-up occurs when UFFDIO_COPY/CONTINUE fails, but we
+		 * have a thread waiting. Wake it up.
+		 */
+		struct uffdio_range range = {0};
+
+		range.start = addr;
+		range.len = demand_paging_size;
+
+		TEST_ASSERT(ioctl(uffd, UFFDIO_WAKE, &range) == 0,
+			    "UFFDIO_WAKE failed: 0x%lx", addr);
+	}
+
 	ts_diff = timespec_elapsed(start);
 
 	PER_PAGE_DEBUG("UFFD page-in %d \t%ld ns\n", tid,
@@ -129,6 +169,58 @@ static int handle_uffd_page_request(int uffd_mode, int uffd,
 	return 0;
 }
 
+static int handle_uffd_page_request(int uffd_mode, int uffd,
+				    struct uffd_msg *msg)
+{
+	uint64_t addr = msg->arg.pagefault.address;
+
+	return resolve_uffd_page_request(uffd_mode, uffd, addr, true);
+}
+
+static void resolve_kvm_userfault(u64 gpa, u64 size)
+{
+	struct kvm_vm *vm = memstress_args.vm;
+	struct userspace_mem_region *region;
+	unsigned long *bitmap_chunk;
+	u64 page, gpa_offset;
+
+	region = (struct userspace_mem_region *) userspace_mem_region_find(
+		vm, gpa, (gpa + size - 1));
+
+	if (kvm_userfault_data.uffd_mode) {
+		/*
+		 * Resolve userfaults early, without needing to read them
+		 * off the userfaultfd.
+		 */
+		uint64_t hva = (uint64_t)addr_gpa2hva(vm, gpa);
+		struct uffd_desc **descs = kvm_userfault_data.uffd_descs;
+		int i, fd;
+
+		for (i = 0; i < num_uffds; ++i)
+			if (hva >= (uint64_t)descs[i]->va_start &&
+			    hva < (uint64_t)descs[i]->va_end)
+				break;
+
+		TEST_ASSERT(i < num_uffds,
+			    "Did not find userfaultfd for hva: %lx", hva);
+
+		fd = kvm_userfault_data.uffd_descs[i]->uffd;
+		resolve_uffd_page_request(kvm_userfault_data.uffd_mode, fd,
+					  hva, false);
+	} else {
+		uint64_t hva = (uint64_t)addr_gpa2hva(vm, gpa);
+
+		memcpy((char *)hva, guest_data_prototype, demand_paging_size);
+	}
+
+	gpa_offset = gpa - region->region.guest_phys_addr;
+	page = gpa_offset / host_page_size;
+	bitmap_chunk = (unsigned long *)region->region.userfault_bitmap +
+		       page / BITS_PER_LONG;
+	atomic_fetch_and_explicit(bitmap_chunk,
+			~(1ul << (page % BITS_PER_LONG)), memory_order_release);
+}
+
 struct test_params {
 	int uffd_mode;
 	bool single_uffd;
@@ -136,6 +228,7 @@ struct test_params {
 	int readers_per_uffd;
 	enum vm_mem_backing_src_type src_type;
 	bool partition_vcpu_memory_access;
+	bool kvm_userfault;
 };
 
 static void prefault_mem(void *alias, uint64_t len)
@@ -149,6 +242,25 @@ static void prefault_mem(void *alias, uint64_t len)
 	}
 }
 
+static void enable_userfault(struct kvm_vm *vm, int slots)
+{
+	for (int i = 0; i < slots; ++i) {
+		int slot = MEMSTRESS_MEM_SLOT_INDEX + i;
+		struct userspace_mem_region *region;
+		unsigned long *userfault_bitmap;
+		int flags = KVM_MEM_USERFAULT;
+
+		region = memslot2region(vm, slot);
+		userfault_bitmap = bitmap_zalloc(region->mmap_size /
+						 host_page_size);
+		/* everything is userfault initially */
+		memset(userfault_bitmap, -1, region->mmap_size / host_page_size / CHAR_BIT);
+		printf("Setting bitmap: %p\n", userfault_bitmap);
+		vm_mem_region_set_flags_userfault(vm, slot, flags,
+						  userfault_bitmap);
+	}
+}
+
 static void run_test(enum vm_guest_mode mode, void *arg)
 {
 	struct memstress_vcpu_args *vcpu_args;
@@ -159,12 +271,13 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct timespec ts_diff;
 	double vcpu_paging_rate;
 	struct kvm_vm *vm;
-	int i, num_uffds = 0;
+	int i;
 
 	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
 				 p->src_type, p->partition_vcpu_memory_access);
 
 	demand_paging_size = get_backing_src_pagesz(p->src_type);
+	host_page_size = getpagesize();
 
 	guest_data_prototype = malloc(demand_paging_size);
 	TEST_ASSERT(guest_data_prototype,
@@ -208,6 +321,14 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		}
 	}
 
+	if (p->kvm_userfault) {
+		TEST_REQUIRE(kvm_has_cap(KVM_CAP_USERFAULT));
+		kvm_userfault_data.enabled = true;
+		kvm_userfault_data.uffd_mode = p->uffd_mode;
+		kvm_userfault_data.uffd_descs = uffd_descs;
+		enable_userfault(vm, 1);
+	}
+
 	pr_info("Finished creating vCPUs and starting uffd threads\n");
 
 	clock_gettime(CLOCK_MONOTONIC, &start);
@@ -265,6 +386,7 @@ static void help(char *name)
 	printf(" -v: specify the number of vCPUs to run.\n");
 	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
 	       "     them into a separate region of memory for each vCPU.\n");
+	printf(" -k: Use KVM Userfault\n");
 	puts("");
 	exit(0);
 }
@@ -283,7 +405,7 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "ahom:u:d:b:s:v:c:r:")) != -1) {
+	while ((opt = getopt(argc, argv, "ahokm:u:d:b:s:v:c:r:")) != -1) {
 		switch (opt) {
 		case 'm':
 			guest_modes_cmdline(optarg);
@@ -326,6 +448,9 @@ int main(int argc, char *argv[])
 				    "Invalid number of readers per uffd %d: must be >=1",
 				    p.readers_per_uffd);
 			break;
+		case 'k':
+			p.kvm_userfault = true;
+			break;
 		case 'h':
 		default:
 			help(argv[0]);
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index bc7c242480d6..7fec3559aa64 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -582,6 +582,8 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		uint64_t guest_paddr, uint32_t slot, uint64_t npages,
 		uint32_t flags, int guest_memfd_fd, uint64_t guest_memfd_offset);
+struct userspace_mem_region *
+userspace_mem_region_find(struct kvm_vm *vm, uint64_t start, uint64_t end);
 
 #ifndef vm_arch_has_protected_memory
 static inline bool vm_arch_has_protected_memory(struct kvm_vm *vm)
@@ -591,6 +593,9 @@ static inline bool vm_arch_has_protected_memory(struct kvm_vm *vm)
 #endif
 
 void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
+void vm_mem_region_set_flags_userfault(struct kvm_vm *vm, uint32_t slot,
+				       uint32_t flags,
+				       unsigned long *userfault_bitmap);
 void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
 struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9603f99d3247..7195dd3db5df 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -634,7 +634,7 @@ void kvm_parse_vcpu_pinning(const char *pcpus_string, uint32_t vcpu_to_pcpu[],
  * of the regions is returned.  Null is returned only when no overlapping
  * region exists.
  */
-static struct userspace_mem_region *
+struct userspace_mem_region *
 userspace_mem_region_find(struct kvm_vm *vm, uint64_t start, uint64_t end)
 {
 	struct rb_node *node;
@@ -1149,6 +1149,44 @@ void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags)
 		ret, errno, slot, flags);
 }
 
+/*
+ * VM Memory Region Flags Set with a userfault bitmap
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   flags - Flags for the memslot
+ *   userfault_bitmap - The bitmap to use for KVM_MEM_USERFAULT
+ *
+ * Output Args: None
+ *
+ * Return: None
+ *
+ * Sets the flags of the memory region specified by the value of slot,
+ * to the values given by flags. This helper adds a way to provide a
+ * userfault_bitmap.
+ */
+void vm_mem_region_set_flags_userfault(struct kvm_vm *vm, uint32_t slot,
+				       uint32_t flags,
+				       unsigned long *userfault_bitmap)
+{
+	int ret;
+	struct userspace_mem_region *region;
+
+	region = memslot2region(vm, slot);
+
+	TEST_ASSERT(!userfault_bitmap ^ (flags & KVM_MEM_USERFAULT),
+		    "KVM_MEM_USERFAULT must be specified with a bitmap");
+
+	region->region.flags = flags;
+	region->region.userfault_bitmap = (__u64)userfault_bitmap;
+
+	ret = __vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION2, &region->region);
+
+	TEST_ASSERT(ret == 0, "KVM_SET_USER_MEMORY_REGION2 IOCTL failed,\n"
+		"  rc: %i errno: %i slot: %u flags: 0x%x",
+		ret, errno, slot, flags);
+}
+
 /*
  * VM Memory Region Move
  *
-- 
2.47.0.338.g60cca15819-goog

