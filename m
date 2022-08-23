Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F62C3F6B0
	for <kvmarm@archiver.kernel.org>; Tue, 23 Aug 2022 23:47:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3DCA4C54A;
	Tue, 23 Aug 2022 19:47:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I18FaS3qPXRa; Tue, 23 Aug 2022 19:47:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3409B4C5CB;
	Tue, 23 Aug 2022 19:47:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E6E64C5FE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 19:47:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z28mZIefedPM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Aug 2022 19:47:46 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 99E474C5F6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 19:47:46 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-333f0d49585so261433797b3.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 16:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc;
 bh=6BH6KLd+hL88vpnVHphl8CS/6RfpXfVURPFpUepCn4U=;
 b=KmJgsELCM1z96XGo7TUbw2aTQWAUcNM9BB9uGhYNRnfXQbGnMATwNlbBMOnNsM4vD3
 QDNUe6GzIlAF1/OCq2lQIRfDCe+u2Xha5WxNkyVZOVKMHFCD3rQSrdnImCTWagWcalLa
 2jsXzR/sS6bc5L8vu5yrtVxo/AjiqOGfhIB980bFUkCJ3KezzF6mlt8PTSarwqnizNbB
 eZjbbis1F60LUaS0XrQu2b8f2yn/nvXYStoCm0G/ahXTu6p3ClduuslkxbFH9YhgU+f5
 FDFa1rwsHMQf3B0fjHFZkckSS0ybZsZxDnLJVLUA4l34holMOE1aJoqrckcsJSSI2SkD
 JxJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc;
 bh=6BH6KLd+hL88vpnVHphl8CS/6RfpXfVURPFpUepCn4U=;
 b=V0CJ1BGqsUppguZmLfUHzI8wn4nOGZO7/KNyDpGSS7M31MRzr5q5OukWm7jYItZL8M
 nVCp/wkk9kZJDkAOl7VNYlhLvOUKxye5GeatEHt3H/UO6HwTWMZ+3FmoXe54lcqX0oIW
 0E78bvQEL0zxqPx3S/V8/CBV85gTqmrmKcJgrhPeaQzxYm0fcqackQHSgGYRK5e1L4qt
 /5t/DzH9BOSjaBP08L7k0z4jSKNjmlCs+l5Xi5AcVRG4MYYZqTstAx7rpVelT6TXILdi
 HHjxzeINtxH7CnWBkrTUMnl3GQeHNgKTB7oT2Ddf6dC9Usj2sEwQxdJxuiXLu9sV107n
 jUWA==
X-Gm-Message-State: ACgBeo3Bx3/ehW1gZjdaTK3fvB0eeiPKaeMlEZ58SfFjl8CGaUg1z+4v
 J5kVUbPk3wG96u638L66BYYDI0PwRrrL1A==
X-Google-Smtp-Source: AA6agR5vVgvHOl0FaB8weoMIKOVE3E/UORWZcj2ZAWnpoXhDBseIEr2zDcp3o7er3gV3X2WdZ/jb/8dbTAkvlg==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:4fc7:0:b0:33d:985b:c194 with SMTP id
 d190-20020a814fc7000000b0033d985bc194mr3156560ywb.370.1661298466279; Tue, 23
 Aug 2022 16:47:46 -0700 (PDT)
Date: Tue, 23 Aug 2022 23:47:21 +0000
In-Reply-To: <20220823234727.621535-1-ricarkol@google.com>
Message-Id: <20220823234727.621535-8-ricarkol@google.com>
Mime-Version: 1.0
References: <20220823234727.621535-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v5 07/13] KVM: selftests: Change ____vm_create() to take
 struct kvm_vm_mem_params
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
Cc: dmatclack@google.com, maz@kernel.org, bgardon@google.com,
 pbonzini@redhat.com, axelrasmussen@google.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

The vm_create() helpers are hardcoded to place most page types (code,
page-tables, stacks, etc) in the same memslot #0, and always backed with
anonymous 4K.  There are a couple of issues with that.  First, tests willing to
differ a bit, like placing page-tables in a different backing source type must
replicate much of what's already done by the vm_create() functions.  Second,
the hardcoded assumption of memslot #0 holding most things is spreaded
everywhere; this makes it very hard to change.

Fix the above issues by having selftests specify how they want memory to be
laid out: define the memory regions to use for code, pt (page-tables), and
data. Introduce a new structure, struct kvm_vm_mem_params, that defines: guest
mode, a list of memory region descriptions, and some fields specifying what
regions to use for code, pt, and data.

There is no functional change intended. The current commit adds a default
struct kvm_vm_mem_params that lays out memory exactly as before. The next
commit will change the allocators to get the region they should be using,
e.g.,: like the page table allocators using the pt memslot.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 61 ++++++++++++++++-
 .../selftests/kvm/lib/aarch64/processor.c     |  3 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 65 +++++++++++++++++--
 3 files changed, 119 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index b2dbe253d4d0..abe6c4e390ff 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -93,6 +93,16 @@ struct kvm_vm {
 	int stats_fd;
 	struct kvm_stats_header stats_header;
 	struct kvm_stats_desc *stats_desc;
+
+	/*
+	 * KVM region slots. These are the default memslots used by page
+	 * allocators, e.g., lib/elf uses the code memslot.
+	 */
+	struct {
+		uint32_t code;
+		uint32_t pt;
+		uint32_t data;
+	} memslot;
 };
 
 
@@ -105,6 +115,21 @@ struct kvm_vm {
 struct userspace_mem_region *
 memslot2region(struct kvm_vm *vm, uint32_t memslot);
 
+inline struct userspace_mem_region *vm_get_code_region(struct kvm_vm *vm)
+{
+	return memslot2region(vm, vm->memslot.code);
+}
+
+inline struct userspace_mem_region *vm_get_pt_region(struct kvm_vm *vm)
+{
+	return memslot2region(vm, vm->memslot.pt);
+}
+
+inline struct userspace_mem_region *vm_get_data_region(struct kvm_vm *vm)
+{
+	return memslot2region(vm, vm->memslot.data);
+}
+
 /* Minimum allocated guest virtual and physical addresses */
 #define KVM_UTIL_MIN_VADDR		0x2000
 #define KVM_GUEST_PAGE_TABLE_MIN_PADDR	0x180000
@@ -637,19 +662,51 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 			      vm_paddr_t paddr_min, uint32_t memslot);
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
 
+#define MEM_PARAMS_MAX_MEMSLOTS 3
+
+struct kvm_vm_mem_params {
+	enum vm_guest_mode mode;
+
+	struct {
+		enum vm_mem_backing_src_type src_type;
+		uint64_t guest_paddr;
+		/*
+		 * KVM region slot (same meaning as in struct
+		 * kvm_userspace_memory_region).
+		 */
+		uint32_t slot;
+		uint64_t npages;
+		uint32_t flags;
+		bool enabled;
+	} region[MEM_PARAMS_MAX_MEMSLOTS];
+
+	/* Indexes into the above array. */
+	struct {
+		uint16_t code;
+		uint16_t pt;
+		uint16_t data;
+	} region_idx;
+};
+
+extern struct kvm_vm_mem_params kvm_vm_mem_default;
+
 /*
  * ____vm_create() does KVM_CREATE_VM and little else.  __vm_create() also
  * loads the test binary into guest memory and creates an IRQ chip (x86 only).
  * __vm_create() does NOT create vCPUs, @nr_runnable_vcpus is used purely to
  * calculate the amount of memory needed for per-vCPU data, e.g. stacks.
  */
-struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages);
+struct kvm_vm *____vm_create(struct kvm_vm_mem_params *mem_params);
 struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
 			   uint64_t nr_extra_pages);
 
 static inline struct kvm_vm *vm_create_barebones(void)
 {
-	return ____vm_create(VM_MODE_DEFAULT, 0);
+	struct kvm_vm_mem_params params_wo_memslots = {
+		.mode = kvm_vm_mem_default.mode,
+	};
+
+	return ____vm_create(&params_wo_memslots);
 }
 
 static inline struct kvm_vm *vm_create(uint32_t nr_runnable_vcpus)
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 26f0eccff6fe..5a31dc85d054 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -508,7 +508,8 @@ void aarch64_get_supported_page_sizes(uint32_t ipa,
  */
 void __attribute__((constructor)) init_guest_modes(void)
 {
-       guest_modes_append_default();
+	guest_modes_append_default();
+	kvm_vm_mem_default.mode = VM_MODE_DEFAULT;
 }
 
 void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 5a9f080ff888..91b42d6b726b 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -143,12 +143,41 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
 _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
 	       "Missing new mode params?");
 
-struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
+/* A single memslot #0 for code, data, and page tables. */
+struct kvm_vm_mem_params kvm_vm_mem_default = {
+#if defined(__aarch64__)
+	/* arm64 is the only arch without a true default mode. */
+	.mode = NUM_VM_MODES,
+#else
+	.mode = VM_MODE_DEFAULT,
+#endif
+	.region[0] = {
+		.src_type = VM_MEM_SRC_ANONYMOUS,
+		.guest_paddr = 0,
+		.slot = 0,
+		/*
+		 * 4mb when page size is 4kb. Note that vm_nr_pages_required(),
+		 * the function used by most tests to calculate guest memory
+		 * requirements uses around ~520 pages for more tests.
+		 */
+		.npages = 1024,
+		.flags = 0,
+		.enabled = true,
+	},
+	.region_idx = {
+		.code = 0,
+		.pt = 0,
+		.data = 0,
+	},
+};
+
+struct kvm_vm *____vm_create(struct kvm_vm_mem_params *mem_params)
 {
+	enum vm_guest_mode mode = mem_params->mode;
 	struct kvm_vm *vm;
+	int idx;
 
-	pr_debug("%s: mode='%s' pages='%ld'\n", __func__,
-		 vm_guest_mode_string(mode), nr_pages);
+	pr_debug("%s: mode='%s'\n", __func__, vm_guest_mode_string(mode));
 
 	vm = calloc(1, sizeof(*vm));
 	TEST_ASSERT(vm != NULL, "Insufficient Memory");
@@ -245,9 +274,28 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
 
 	/* Allocate and setup memory for guest. */
 	vm->vpages_mapped = sparsebit_alloc();
-	if (nr_pages != 0)
-		vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
-					    0, 0, nr_pages, 0);
+
+	/* Setup the code, pt, and data memslots according to the spec */
+	for (idx = 0; idx < MEM_PARAMS_MAX_MEMSLOTS; idx++) {
+		if (!mem_params->region[idx].enabled)
+			continue;
+
+		vm_userspace_mem_region_add(vm,
+			mem_params->region[idx].src_type,
+			mem_params->region[idx].guest_paddr,
+			mem_params->region[idx].slot,
+			mem_params->region[idx].npages,
+			mem_params->region[idx].flags);
+	}
+
+	TEST_ASSERT(mem_params->region_idx.code < MEM_PARAMS_MAX_MEMSLOTS &&
+		    mem_params->region_idx.pt < MEM_PARAMS_MAX_MEMSLOTS &&
+		    mem_params->region_idx.data < MEM_PARAMS_MAX_MEMSLOTS,
+		    "region_idx should be valid indexes\n");
+
+	vm->memslot.code = mem_params->region[mem_params->region_idx.code].slot;
+	vm->memslot.pt = mem_params->region[mem_params->region_idx.pt].slot;
+	vm->memslot.data = mem_params->region[mem_params->region_idx.data].slot;
 
 	return vm;
 }
@@ -292,9 +340,12 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
 {
 	uint64_t nr_pages = vm_nr_pages_required(mode, nr_runnable_vcpus,
 						 nr_extra_pages);
+	struct kvm_vm_mem_params mem_params = kvm_vm_mem_default;
 	struct kvm_vm *vm;
 
-	vm = ____vm_create(mode, nr_pages);
+	mem_params.region[0].npages = nr_pages;
+	mem_params.mode = mode;
+	vm = ____vm_create(&mem_params);
 
 	kvm_vm_elf_load(vm, program_invocation_name);
 
-- 
2.37.1.595.g718a3a8f04-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
