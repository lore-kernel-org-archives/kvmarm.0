Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D8D4C43217
	for <kvmarm@archiver.kernel.org>; Tue, 11 Oct 2022 01:06:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D7924B647;
	Mon, 10 Oct 2022 21:06:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TLcBxB0hAEgA; Mon, 10 Oct 2022 21:06:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 91D234B63E;
	Mon, 10 Oct 2022 21:06:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C64ED4B62D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 21:06:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QXNa4NL+Q5FF for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Oct 2022 21:06:48 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 478DF4B63B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 21:06:48 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-3538689fc60so118935527b3.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 18:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=nK27oxZIZaGjPLV/PJtdh+6yEDr9lU1hKNnYNecQezc=;
 b=jFtOKkyDlYF8w8FUNwkmEqOK/+TPSeiRrt5XWHWH9ZO6rhBDGUKONEog2fgqp/z7tf
 PHTi21RawmEW3ByWCIODIRiH03gHBlYCgqyf8xnoyZCOO1V5J1tpr+P1UcgJWzEJ8/Vb
 gLnmfRqgE9XBSeCP15UPVlSUeE01d63Cg//phh/EwpCetoHTkSPb1dH1hRsVIHHtQeMS
 1u/L0s3WF7fnNMst9R1gyWSzEmRIRD+vK6lrTh0evqgmx7m/SyTtM6lc4O7Ph1RjsHby
 oGtkVJMRHNVK4qMI3Sg6uCnn8P/meyZm8jqwhtQdTDr39Do8LhGSibRKfQrVDuyDFf05
 p79g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=nK27oxZIZaGjPLV/PJtdh+6yEDr9lU1hKNnYNecQezc=;
 b=oMXxCaxuExokr5vr/O+V6gyMl6abgtsVrs952xHwTL9FTxuj/4MzIq8QnMoBrKw38p
 9sUZTkyssjwSv8NGFvAeKlApSjT1jwbA8TOY8/nCoGl9S0NOHI+ChlWxpKPVHtLX2vrM
 m01WFlZKaeWkkKhpcOH3wURDfln7l9u2RcgBjXsbf+lFHaLJF7wXzG3jE6rhNacKxZLT
 oclieodGuQVYkfHBD3/lIs7QyloQEMzsjfNw2aujoZMJHmjQUaQTnqQSksyQh5eI+jRQ
 OTWDi4S1k5euczr64r4EtN/T7+93XmZyyS+bjiyQ0hnKjdt81bhoYbUw0Zh0YmiLmUwB
 fiog==
X-Gm-Message-State: ACrzQf3uX6+pzaz1gMW+Wh/6JWe+gaumPVCZxNNLZruc2ZNns+f4lpWt
 80AYojYUwjv4zQs4O0LbYXzd1LdTd0ZcuQ==
X-Google-Smtp-Source: AMsMyM40VaGLni1kxYkZaK2TohYo6+kNGQ1bYMHT2Rwvf/TvtUzsEkOivoaKFXAH/sIVMFdGDJLnbS0ekdiaUA==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a5b:912:0:b0:6c0:39c9:91df with SMTP id
 a18-20020a5b0912000000b006c039c991dfmr11713518ybq.268.1665450407941; Mon, 10
 Oct 2022 18:06:47 -0700 (PDT)
Date: Tue, 11 Oct 2022 01:06:21 +0000
In-Reply-To: <20221011010628.1734342-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221011010628.1734342-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221011010628.1734342-8-ricarkol@google.com>
Subject: [PATCH v9 07/14] KVM: selftests: Add vm->memslots[] and enum
 kvm_mem_region_type
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
 andrew.jones@linux.dev
Cc: maz@kernel.org, bgardon@google.com, pbonzini@redhat.com,
 axelrasmussen@google.com, dmatlack@google.com
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
anonymous 4K.  There are a couple of issues with that.  First, tests
willing to differ a bit, like placing page-tables in a different backing
source type must replicate much of what's already done by the vm_create()
functions.  Second, the hardcoded assumption of memslot #0 holding most
things is spread everywhere; this makes it very hard to change.

Fix the above issues by having selftests specify how they want memory to be
laid out. Start by changing ____vm_create() to not create memslot #0; a
test (to come) will specify all memslots used by the VM.  Then, add the
vm->memslots[] array to specify the right memslot for different memory
allocators, e.g.,: lib/elf should use the vm->[MEM_REGION_CODE] memslot.
This will be used as a way to specify the page-tables memslots (to be
backed by huge pages for example).

There is no functional change intended. The current commit lays out memory
exactly as before. A future commit will change the allocators to get the
region they should be using, e.g.,: like the page table allocators using
the pt memslot.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 26 +++++++++++++++++--
 tools/testing/selftests/kvm/lib/kvm_util.c    | 18 +++++++------
 2 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index a9264ed22cca..6442aa9e9061 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -65,6 +65,14 @@ struct userspace_mem_regions {
 	DECLARE_HASHTABLE(slot_hash, 9);
 };
 
+enum kvm_mem_region_type {
+	MEM_REGION_CODE,
+	MEM_REGION_DATA,
+	MEM_REGION_PT,
+	MEM_REGION_TEST_DATA,
+	NR_MEM_REGIONS,
+};
+
 struct kvm_vm {
 	int mode;
 	unsigned long type;
@@ -93,6 +101,13 @@ struct kvm_vm {
 	int stats_fd;
 	struct kvm_stats_header stats_header;
 	struct kvm_stats_desc *stats_desc;
+
+	/*
+	 * KVM region slots. These are the default memslots used by page
+	 * allocators, e.g., lib/elf uses the memslots[MEM_REGION_CODE]
+	 * memslot.
+	 */
+	uint32_t memslots[NR_MEM_REGIONS];
 };
 
 
@@ -105,6 +120,13 @@ struct kvm_vm {
 struct userspace_mem_region *
 memslot2region(struct kvm_vm *vm, uint32_t memslot);
 
+static inline struct userspace_mem_region *vm_get_mem_region(struct kvm_vm *vm,
+							     enum kvm_mem_region_type type)
+{
+	assert(type < NR_MEM_REGIONS);
+	return memslot2region(vm, vm->memslots[type]);
+}
+
 /* Minimum allocated guest virtual and physical addresses */
 #define KVM_UTIL_MIN_VADDR		0x2000
 #define KVM_GUEST_PAGE_TABLE_MIN_PADDR	0x180000
@@ -647,13 +669,13 @@ vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
  * __vm_create() does NOT create vCPUs, @nr_runnable_vcpus is used purely to
  * calculate the amount of memory needed for per-vCPU data, e.g. stacks.
  */
-struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages);
+struct kvm_vm *____vm_create(enum vm_guest_mode mode);
 struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
 			   uint64_t nr_extra_pages);
 
 static inline struct kvm_vm *vm_create_barebones(void)
 {
-	return ____vm_create(VM_MODE_DEFAULT, 0);
+	return ____vm_create(VM_MODE_DEFAULT);
 }
 
 static inline struct kvm_vm *vm_create(uint32_t nr_runnable_vcpus)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 6affce47e899..f3dfa4e9ee0f 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -185,13 +185,10 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
 _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
 	       "Missing new mode params?");
 
-struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
+struct kvm_vm *____vm_create(enum vm_guest_mode mode)
 {
 	struct kvm_vm *vm;
 
-	pr_debug("%s: mode='%s' pages='%ld'\n", __func__,
-		 vm_guest_mode_string(mode), nr_pages);
-
 	vm = calloc(1, sizeof(*vm));
 	TEST_ASSERT(vm != NULL, "Insufficient Memory");
 
@@ -287,9 +284,6 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
 
 	/* Allocate and setup memory for guest. */
 	vm->vpages_mapped = sparsebit_alloc();
-	if (nr_pages != 0)
-		vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
-					    0, 0, nr_pages, 0);
 
 	return vm;
 }
@@ -335,8 +329,16 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
 	uint64_t nr_pages = vm_nr_pages_required(mode, nr_runnable_vcpus,
 						 nr_extra_pages);
 	struct kvm_vm *vm;
+	int i;
+
+	pr_debug("%s: mode='%s' pages='%ld'\n", __func__,
+		 vm_guest_mode_string(mode), nr_pages);
+
+	vm = ____vm_create(mode);
 
-	vm = ____vm_create(mode, nr_pages);
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, nr_pages, 0);
+	for (i = 0; i < NR_MEM_REGIONS; i++)
+		vm->memslots[i] = 0;
 
 	kvm_vm_elf_load(vm, program_invocation_name);
 
-- 
2.38.0.rc1.362.ged0d419d3c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
