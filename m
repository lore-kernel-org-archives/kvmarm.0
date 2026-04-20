Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FBE3D0912
	for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 21:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776720034; cv=none; b=n4b+EQRlZ+X83jvu725qiGavXEwDqweBNvWof+jOweoMUXPIo9DAJ0ZQgXnlX8klrOkC7bkAL80Yba4fS0skp86YiZKX7qu0P95Rp0DwsTCNMWwH1MuqINm2RAoWCwgh39CUlKOIHcxIJtPHXr4QP51LRn46072PrYPu/Sa/KEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776720034; c=relaxed/simple;
	bh=9msg3zBeYPi/Zq1Ema7rB5P1FNaiMxSubhIpHrISbQw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ml9Y2z746iY0Afc77i1N/wG2J8g6L+3yHMQHIB5YSg3utpCoTf3KpsVlE5q943/xsWABHnJHgW4F5POO7IIoBZzwGXEp6xY9AFJGlbP6Tkxknue7NME0jZoTD5hM0Pc5n3DWBljalK9AfwOSxvkqsVL6GiKQEPEVe4JAOkO5tKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OlgA1IYw; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OlgA1IYw"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35fbaada2f3so6226696a91.0
        for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 14:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776720027; x=1777324827; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TaylwcgVf48kOhELpsI9sN/K9I6TR/YTRK7E4rfY3Gs=;
        b=OlgA1IYwbzjOjZHo48opLRRXxJxVwa3viQH1DnNe3HhmIbAMDQu+0fmmh0IGAyRsz7
         cks+cJOvwtUm6rUjypMEME5lnXHk73WZ42AtUFyFW285wixBJu07k97XnwiNuda3gTqV
         FZ5vlulEUCgN+TgnvKv7zmRvLQ02jtR93nP0VOa3wSn+lWum5S+heGOfkOPIrk/h5IiE
         B/sPIcxoP18v4LrQs/MAjGilnLa666Zh3HtE6xbS7TTAIUzLQI1yAvZic8Eek7cMVcSj
         zdCevkZQGFTKt0+qgpWf/FKukISWaaIVx3DcfOnCHa9uYn26Ev+eYpcv/lVaM/QyXKHz
         5p4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776720027; x=1777324827;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TaylwcgVf48kOhELpsI9sN/K9I6TR/YTRK7E4rfY3Gs=;
        b=Hka4kL/XHid+fijomDUOQxw4k4Px6LAaLm6BxTNKWz3UgVutMRFfX0Up0DrlJbsWNi
         l4fi7tHKyWE3uoocXEO6v6Kvc2XN59j/8sX5Bv2tVv4PC/sLQzvo9C3DgugwU0/z8Ra4
         iNmVsM3Cu2B4uc/ZbfwxO34Ax+9BAvB2+GsvC8LlKdGVBEU6WhNYxkL7XVJnikTU21Py
         sL62F6PSAAuNC0+HV7s/Va95ROTIYBE+3gp+NTyKlAISCp3D+bvZb67yP4jSBgOZPfpC
         yWnkhnsdz9tetRZNC8UNVzdqvrkz3CVTu4DvvwhGgCyCX5oSs3o+8quvhT+/wrvNxFbH
         LbPg==
X-Forwarded-Encrypted: i=1; AFNElJ8fiF2zOmO0JaQjvjS1YQvYG/2JgAwry0eDjFB+fiHEBqdGoa/e4iN2aFu39OnEsMCkRLanaOI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzHqPusjRM0NDcLnPICnUB9vRwj1OSYi4/KBjjPaXxP0IQv3cFl
	MCxOaWT2aWIjL04GkB15nUqt2HdmXKbdgRJiXDOM13C3kbHONiwv2OWhjuHvBBp3yAiNhHgyYwG
	W0WsO4Q==
X-Received: from pldt14.prod.google.com ([2002:a17:903:40ce:b0:2b4:5ded:6ecb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2fc8:b0:35d:a542:2dc4
 with SMTP id 98e67ed59e1d1-3614047a7b8mr16878211a91.21.1776720027270; Mon, 20
 Apr 2026 14:20:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 20 Apr 2026 14:19:56 -0700
In-Reply-To: <20260420212004.3938325-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260420212004.3938325-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
Message-ID: <20260420212004.3938325-12-seanjc@google.com>
Subject: [PATCH v3 11/19] KVM: selftests: Drop "vaddr_" from APIs that
 allocate memory for a given VM
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that KVM selftests use gva_t instead of vm_vaddr_t, drop "vaddr_" from
the core memory allocation APIs as the information is extraneous and does
more harm than good.  E.g. the APIs don't _just_ allocate virtual memory,
they allocate backing physical memory and install mappings in the guest
page tables.  And as proven by kmalloc() and malloc(), developers generally
expect that allocations come with a working virtual address.

Opportunistically clean up the function comment for vm_alloc(), and drop
the misleading and superfluous comments for its wrappers.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/arm64/vgic_irq.c  |  4 +-
 .../testing/selftests/kvm/include/kvm_util.h  | 16 ++--
 .../selftests/kvm/lib/arm64/processor.c       | 10 +--
 tools/testing/selftests/kvm/lib/elf.c         |  3 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 84 +++++--------------
 .../selftests/kvm/lib/loongarch/processor.c   | 13 +--
 .../selftests/kvm/lib/riscv/processor.c       |  6 +-
 .../selftests/kvm/lib/s390/processor.c        |  2 +-
 .../testing/selftests/kvm/lib/ucall_common.c  |  4 +-
 tools/testing/selftests/kvm/lib/x86/hyperv.c  |  8 +-
 .../testing/selftests/kvm/lib/x86/processor.c | 12 +--
 tools/testing/selftests/kvm/lib/x86/svm.c     |  8 +-
 tools/testing/selftests/kvm/lib/x86/vmx.c     | 16 ++--
 tools/testing/selftests/kvm/s390/memop.c      | 12 +--
 tools/testing/selftests/kvm/s390/tprot.c      |  4 +-
 tools/testing/selftests/kvm/x86/amx_test.c    |  6 +-
 tools/testing/selftests/kvm/x86/cpuid_test.c  |  2 +-
 .../testing/selftests/kvm/x86/hyperv_clock.c  |  2 +-
 .../testing/selftests/kvm/x86/hyperv_evmcs.c  |  2 +-
 .../kvm/x86/hyperv_extended_hypercalls.c      |  4 +-
 .../selftests/kvm/x86/hyperv_features.c       |  6 +-
 tools/testing/selftests/kvm/x86/hyperv_ipi.c  |  2 +-
 .../selftests/kvm/x86/hyperv_svm_test.c       |  2 +-
 .../selftests/kvm/x86/hyperv_tlb_flush.c      |  6 +-
 .../selftests/kvm/x86/kvm_clock_test.c        |  2 +-
 .../selftests/kvm/x86/sev_smoke_test.c        |  4 +-
 .../kvm/x86/svm_nested_soft_inject_test.c     |  2 +-
 .../selftests/kvm/x86/xapic_ipi_test.c        |  2 +-
 28 files changed, 102 insertions(+), 142 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_irq.c b/tools/testing/selftests/kvm/arm64/vgic_irq.c
index 8a9dd79123d4..5e231998617e 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_irq.c
@@ -771,7 +771,7 @@ static void test_vgic(u32 nr_irqs, bool level_sensitive, bool eoi_split)
 	vcpu_init_descriptor_tables(vcpu);
 
 	/* Setup the guest args page (so it gets the args). */
-	args_gva = vm_vaddr_alloc_page(vm);
+	args_gva = vm_alloc_page(vm);
 	memcpy(addr_gva2hva(vm, args_gva), &args, sizeof(args));
 	vcpu_args_set(vcpu, 1, args_gva);
 
@@ -997,7 +997,7 @@ static void test_vgic_two_cpus(void *gcode)
 	vcpu_init_descriptor_tables(vcpus[1]);
 
 	/* Setup the guest args page (so it gets the args). */
-	args_gva = vm_vaddr_alloc_page(vm);
+	args_gva = vm_alloc_page(vm);
 	memcpy(addr_gva2hva(vm, args_gva), &args, sizeof(args));
 	vcpu_args_set(vcpus[0], 2, args_gva, 0);
 	vcpu_args_set(vcpus[1], 2, args_gva, 1);
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 676e3ccb1462..8f7afc34ea8d 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -716,14 +716,14 @@ void vm_mem_region_delete(struct kvm_vm *vm, u32 slot);
 struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, u32 vcpu_id);
 void vm_populate_vaddr_bitmap(struct kvm_vm *vm);
 gva_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz, gva_t vaddr_min);
-gva_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, gva_t vaddr_min);
-gva_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, gva_t vaddr_min,
-		       enum kvm_mem_region_type type);
-gva_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz, gva_t vaddr_min,
-			    enum kvm_mem_region_type type);
-gva_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
-gva_t __vm_vaddr_alloc_page(struct kvm_vm *vm, enum kvm_mem_region_type type);
-gva_t vm_vaddr_alloc_page(struct kvm_vm *vm);
+gva_t vm_alloc(struct kvm_vm *vm, size_t sz, gva_t vaddr_min);
+gva_t __vm_alloc(struct kvm_vm *vm, size_t sz, gva_t vaddr_min,
+		 enum kvm_mem_region_type type);
+gva_t vm_alloc_shared(struct kvm_vm *vm, size_t sz, gva_t vaddr_min,
+		      enum kvm_mem_region_type type);
+gva_t vm_alloc_pages(struct kvm_vm *vm, int nr_pages);
+gva_t __vm_alloc_page(struct kvm_vm *vm, enum kvm_mem_region_type type);
+gva_t vm_alloc_page(struct kvm_vm *vm);
 
 void virt_map(struct kvm_vm *vm, u64 vaddr, u64 paddr,
 	      unsigned int npages);
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 7ba3a48911e3..c4f0e37f2907 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -422,9 +422,9 @@ static struct kvm_vcpu *__aarch64_vcpu_add(struct kvm_vm *vm, u32 vcpu_id,
 
 	stack_size = vm->page_size == 4096 ? DEFAULT_STACK_PGS * vm->page_size :
 					     vm->page_size;
-	stack_vaddr = __vm_vaddr_alloc(vm, stack_size,
-				       DEFAULT_ARM64_GUEST_STACK_VADDR_MIN,
-				       MEM_REGION_DATA);
+	stack_vaddr = __vm_alloc(vm, stack_size,
+				 DEFAULT_ARM64_GUEST_STACK_VADDR_MIN,
+				 MEM_REGION_DATA);
 
 	aarch64_vcpu_setup(vcpu, init);
 
@@ -536,8 +536,8 @@ void route_exception(struct ex_regs *regs, int vector)
 
 void vm_init_descriptor_tables(struct kvm_vm *vm)
 {
-	vm->handlers = __vm_vaddr_alloc(vm, sizeof(struct handlers),
-					vm->page_size, MEM_REGION_DATA);
+	vm->handlers = __vm_alloc(vm, sizeof(struct handlers), vm->page_size,
+				  MEM_REGION_DATA);
 
 	*(gva_t *)addr_gva2hva(vm, (gva_t)(&exception_handlers)) = vm->handlers;
 }
diff --git a/tools/testing/selftests/kvm/lib/elf.c b/tools/testing/selftests/kvm/lib/elf.c
index 0f2710cda9d8..2288480f4e1e 100644
--- a/tools/testing/selftests/kvm/lib/elf.c
+++ b/tools/testing/selftests/kvm/lib/elf.c
@@ -162,8 +162,7 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
 		seg_vend |= vm->page_size - 1;
 		size_t seg_size = seg_vend - seg_vstart + 1;
 
-		gva_t vaddr = __vm_vaddr_alloc(vm, seg_size, seg_vstart,
-						    MEM_REGION_CODE);
+		gva_t vaddr = __vm_alloc(vm, seg_size, seg_vstart, MEM_REGION_CODE);
 		TEST_ASSERT(vaddr == seg_vstart, "Unable to allocate "
 			"virtual memory for segment at requested min addr,\n"
 			"  segment idx: %u\n"
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 050ae9c92681..b304c0e54837 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1450,8 +1450,8 @@ gva_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz, gva_t vaddr_min)
 	return pgidx_start * vm->page_size;
 }
 
-static gva_t ____vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, gva_t vaddr_min,
-				enum kvm_mem_region_type type, bool protected)
+static gva_t ____vm_alloc(struct kvm_vm *vm, size_t sz, gva_t vaddr_min,
+			  enum kvm_mem_region_type type, bool protected)
 {
 	u64 pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
 
@@ -1476,84 +1476,44 @@ static gva_t ____vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, gva_t vaddr_min,
 	return vaddr_start;
 }
 
-gva_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, gva_t vaddr_min,
-		       enum kvm_mem_region_type type)
+gva_t __vm_alloc(struct kvm_vm *vm, size_t sz, gva_t vaddr_min,
+		 enum kvm_mem_region_type type)
 {
-	return ____vm_vaddr_alloc(vm, sz, vaddr_min, type,
-				  vm_arch_has_protected_memory(vm));
+	return ____vm_alloc(vm, sz, vaddr_min, type,
+			    vm_arch_has_protected_memory(vm));
 }
 
-gva_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz, gva_t vaddr_min,
-			    enum kvm_mem_region_type type)
+gva_t vm_alloc_shared(struct kvm_vm *vm, size_t sz, gva_t vaddr_min,
+		      enum kvm_mem_region_type type)
 {
-	return ____vm_vaddr_alloc(vm, sz, vaddr_min, type, false);
+	return ____vm_alloc(vm, sz, vaddr_min, type, false);
 }
 
 /*
- * VM Virtual Address Allocate
- *
- * Input Args:
- *   vm - Virtual Machine
- *   sz - Size in bytes
- *   vaddr_min - Minimum starting virtual address
- *
- * Output Args: None
- *
- * Return:
- *   Starting guest virtual address
- *
- * Allocates at least sz bytes within the virtual address space of the vm
- * given by vm.  The allocated bytes are mapped to a virtual address >=
- * the address given by vaddr_min.  Note that each allocation uses a
- * a unique set of pages, with the minimum real allocation being at least
- * a page. The allocated physical space comes from the TEST_DATA memory region.
+ * Allocates at least sz bytes within the virtual address space of the VM
+ * given by @vm.  The allocated bytes are mapped to a virtual address >= the
+ * address given by @vaddr_min.  Note that each allocation uses a a unique set
+ * of pages, with the minimum real allocation being at least a page. The
+ * allocated physical space comes from the TEST_DATA memory region.
  */
-gva_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, gva_t vaddr_min)
+gva_t vm_alloc(struct kvm_vm *vm, size_t sz, gva_t vaddr_min)
 {
-	return __vm_vaddr_alloc(vm, sz, vaddr_min, MEM_REGION_TEST_DATA);
+	return __vm_alloc(vm, sz, vaddr_min, MEM_REGION_TEST_DATA);
 }
 
-/*
- * VM Virtual Address Allocate Pages
- *
- * Input Args:
- *   vm - Virtual Machine
- *
- * Output Args: None
- *
- * Return:
- *   Starting guest virtual address
- *
- * Allocates at least N system pages worth of bytes within the virtual address
- * space of the vm.
- */
-gva_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages)
+gva_t vm_alloc_pages(struct kvm_vm *vm, int nr_pages)
 {
-	return vm_vaddr_alloc(vm, nr_pages * getpagesize(), KVM_UTIL_MIN_VADDR);
+	return vm_alloc(vm, nr_pages * getpagesize(), KVM_UTIL_MIN_VADDR);
 }
 
-gva_t __vm_vaddr_alloc_page(struct kvm_vm *vm, enum kvm_mem_region_type type)
+gva_t __vm_alloc_page(struct kvm_vm *vm, enum kvm_mem_region_type type)
 {
-	return __vm_vaddr_alloc(vm, getpagesize(), KVM_UTIL_MIN_VADDR, type);
+	return __vm_alloc(vm, getpagesize(), KVM_UTIL_MIN_VADDR, type);
 }
 
-/*
- * VM Virtual Address Allocate Page
- *
- * Input Args:
- *   vm - Virtual Machine
- *
- * Output Args: None
- *
- * Return:
- *   Starting guest virtual address
- *
- * Allocates at least one system page worth of bytes within the virtual address
- * space of the vm.
- */
-gva_t vm_vaddr_alloc_page(struct kvm_vm *vm)
+gva_t vm_alloc_page(struct kvm_vm *vm)
 {
-	return vm_vaddr_alloc_pages(vm, 1);
+	return vm_alloc_pages(vm, 1);
 }
 
 /*
diff --git a/tools/testing/selftests/kvm/lib/loongarch/processor.c b/tools/testing/selftests/kvm/lib/loongarch/processor.c
index 2982196db3b2..318520f1f1b9 100644
--- a/tools/testing/selftests/kvm/lib/loongarch/processor.c
+++ b/tools/testing/selftests/kvm/lib/loongarch/processor.c
@@ -206,8 +206,9 @@ void vm_init_descriptor_tables(struct kvm_vm *vm)
 {
 	void *addr;
 
-	vm->handlers = __vm_vaddr_alloc(vm, sizeof(struct handlers),
-			LOONGARCH_GUEST_STACK_VADDR_MIN, MEM_REGION_DATA);
+	vm->handlers = __vm_alloc(vm, sizeof(struct handlers),
+				  LOONGARCH_GUEST_STACK_VADDR_MIN,
+				  MEM_REGION_DATA);
 
 	addr = addr_gva2hva(vm, vm->handlers);
 	memset(addr, 0, vm->page_size);
@@ -354,8 +355,8 @@ void loongarch_vcpu_setup(struct kvm_vcpu *vcpu)
 	loongarch_set_csr(vcpu, LOONGARCH_CSR_STLBPGSIZE, PS_DEFAULT_SIZE);
 
 	/* LOONGARCH_CSR_KS1 is used for exception stack */
-	val = __vm_vaddr_alloc(vm, vm->page_size,
-			LOONGARCH_GUEST_STACK_VADDR_MIN, MEM_REGION_DATA);
+	val = __vm_alloc(vm, vm->page_size, LOONGARCH_GUEST_STACK_VADDR_MIN,
+			 MEM_REGION_DATA);
 	TEST_ASSERT(val != 0,  "No memory for exception stack");
 	val = val + vm->page_size;
 	loongarch_set_csr(vcpu, LOONGARCH_CSR_KS1, val);
@@ -378,8 +379,8 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, u32 vcpu_id)
 
 	vcpu = __vm_vcpu_add(vm, vcpu_id);
 	stack_size = vm->page_size;
-	stack_vaddr = __vm_vaddr_alloc(vm, stack_size,
-			LOONGARCH_GUEST_STACK_VADDR_MIN, MEM_REGION_DATA);
+	stack_vaddr = __vm_alloc(vm, stack_size,
+				 LOONGARCH_GUEST_STACK_VADDR_MIN, MEM_REGION_DATA);
 	TEST_ASSERT(stack_vaddr != 0,  "No memory for vm stack");
 
 	loongarch_vcpu_setup(vcpu);
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index 7336d5a20419..38eb8302922a 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -322,7 +322,7 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, u32 vcpu_id)
 
 	stack_size = vm->page_size == 4096 ? DEFAULT_STACK_PGS * vm->page_size :
 					     vm->page_size;
-	stack_vaddr = __vm_vaddr_alloc(vm, stack_size,
+	stack_vaddr = __vm_alloc(vm, stack_size,
 				       DEFAULT_RISCV_GUEST_STACK_VADDR_MIN,
 				       MEM_REGION_DATA);
 
@@ -449,8 +449,8 @@ void vcpu_init_vector_tables(struct kvm_vcpu *vcpu)
 
 void vm_init_vector_tables(struct kvm_vm *vm)
 {
-	vm->handlers = __vm_vaddr_alloc(vm, sizeof(struct handlers),
-				   vm->page_size, MEM_REGION_DATA);
+	vm->handlers = __vm_alloc(vm, sizeof(struct handlers), vm->page_size,
+				  MEM_REGION_DATA);
 
 	*(gva_t *)addr_gva2hva(vm, (gva_t)(&exception_handlers)) = vm->handlers;
 }
diff --git a/tools/testing/selftests/kvm/lib/s390/processor.c b/tools/testing/selftests/kvm/lib/s390/processor.c
index d35f23a4db12..4ae0a39f426f 100644
--- a/tools/testing/selftests/kvm/lib/s390/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390/processor.c
@@ -171,7 +171,7 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, u32 vcpu_id)
 	TEST_ASSERT(vm->page_size == PAGE_SIZE, "Unsupported page size: 0x%x",
 		    vm->page_size);
 
-	stack_vaddr = __vm_vaddr_alloc(vm, stack_size,
+	stack_vaddr = __vm_alloc(vm, stack_size,
 				       DEFAULT_GUEST_STACK_VADDR_MIN,
 				       MEM_REGION_DATA);
 
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index b16b5c5b3a1e..4a8a5bc40a45 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -32,8 +32,8 @@ void ucall_init(struct kvm_vm *vm, gpa_t mmio_gpa)
 	gva_t vaddr;
 	int i;
 
-	vaddr = vm_vaddr_alloc_shared(vm, sizeof(*hdr), KVM_UTIL_MIN_VADDR,
-				      MEM_REGION_DATA);
+	vaddr = vm_alloc_shared(vm, sizeof(*hdr), KVM_UTIL_MIN_VADDR,
+				MEM_REGION_DATA);
 	hdr = (struct ucall_header *)addr_gva2hva(vm, vaddr);
 	memset(hdr, 0, sizeof(*hdr));
 
diff --git a/tools/testing/selftests/kvm/lib/x86/hyperv.c b/tools/testing/selftests/kvm/lib/x86/hyperv.c
index c2806bed43c9..d200c5c26e2e 100644
--- a/tools/testing/selftests/kvm/lib/x86/hyperv.c
+++ b/tools/testing/selftests/kvm/lib/x86/hyperv.c
@@ -78,21 +78,21 @@ bool kvm_hv_cpu_has(struct kvm_x86_cpu_feature feature)
 struct hyperv_test_pages *vcpu_alloc_hyperv_test_pages(struct kvm_vm *vm,
 						       gva_t *p_hv_pages_gva)
 {
-	gva_t hv_pages_gva = vm_vaddr_alloc_page(vm);
+	gva_t hv_pages_gva = vm_alloc_page(vm);
 	struct hyperv_test_pages *hv = addr_gva2hva(vm, hv_pages_gva);
 
 	/* Setup of a region of guest memory for the VP Assist page. */
-	hv->vp_assist = (void *)vm_vaddr_alloc_page(vm);
+	hv->vp_assist = (void *)vm_alloc_page(vm);
 	hv->vp_assist_hva = addr_gva2hva(vm, (uintptr_t)hv->vp_assist);
 	hv->vp_assist_gpa = addr_gva2gpa(vm, (uintptr_t)hv->vp_assist);
 
 	/* Setup of a region of guest memory for the partition assist page. */
-	hv->partition_assist = (void *)vm_vaddr_alloc_page(vm);
+	hv->partition_assist = (void *)vm_alloc_page(vm);
 	hv->partition_assist_hva = addr_gva2hva(vm, (uintptr_t)hv->partition_assist);
 	hv->partition_assist_gpa = addr_gva2gpa(vm, (uintptr_t)hv->partition_assist);
 
 	/* Setup of a region of guest memory for the enlightened VMCS. */
-	hv->enlightened_vmcs = (void *)vm_vaddr_alloc_page(vm);
+	hv->enlightened_vmcs = (void *)vm_alloc_page(vm);
 	hv->enlightened_vmcs_hva = addr_gva2hva(vm, (uintptr_t)hv->enlightened_vmcs);
 	hv->enlightened_vmcs_gpa = addr_gva2gpa(vm, (uintptr_t)hv->enlightened_vmcs);
 
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 723a5200c4bb..50848112932c 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -746,10 +746,10 @@ static void vm_init_descriptor_tables(struct kvm_vm *vm)
 	struct kvm_segment seg;
 	int i;
 
-	vm->arch.gdt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
-	vm->arch.idt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
-	vm->handlers = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
-	vm->arch.tss = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
+	vm->arch.gdt = __vm_alloc_page(vm, MEM_REGION_DATA);
+	vm->arch.idt = __vm_alloc_page(vm, MEM_REGION_DATA);
+	vm->handlers = __vm_alloc_page(vm, MEM_REGION_DATA);
+	vm->arch.tss = __vm_alloc_page(vm, MEM_REGION_DATA);
 
 	/* Handlers have the same address in both address spaces.*/
 	for (i = 0; i < NUM_INTERRUPTS; i++)
@@ -828,7 +828,7 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, u32 vcpu_id)
 	gva_t stack_vaddr;
 	struct kvm_vcpu *vcpu;
 
-	stack_vaddr = __vm_vaddr_alloc(vm, DEFAULT_STACK_PGS * getpagesize(),
+	stack_vaddr = __vm_alloc(vm, DEFAULT_STACK_PGS * getpagesize(),
 				       DEFAULT_GUEST_STACK_VADDR_MIN,
 				       MEM_REGION_DATA);
 
@@ -844,7 +844,7 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, u32 vcpu_id)
 	 * may need to subtract 4 bytes instead of 8 bytes.
 	 */
 	TEST_ASSERT(IS_ALIGNED(stack_vaddr, PAGE_SIZE),
-		    "__vm_vaddr_alloc() did not provide a page-aligned address");
+		    "__vm_alloc() did not provide a page-aligned address");
 	stack_vaddr -= 8;
 
 	vcpu = __vm_vcpu_add(vm, vcpu_id);
diff --git a/tools/testing/selftests/kvm/lib/x86/svm.c b/tools/testing/selftests/kvm/lib/x86/svm.c
index 620bdc5d3cc2..3b01605ab016 100644
--- a/tools/testing/selftests/kvm/lib/x86/svm.c
+++ b/tools/testing/selftests/kvm/lib/x86/svm.c
@@ -30,18 +30,18 @@ u64 rflags;
 struct svm_test_data *
 vcpu_alloc_svm(struct kvm_vm *vm, gva_t *p_svm_gva)
 {
-	gva_t svm_gva = vm_vaddr_alloc_page(vm);
+	gva_t svm_gva = vm_alloc_page(vm);
 	struct svm_test_data *svm = addr_gva2hva(vm, svm_gva);
 
-	svm->vmcb = (void *)vm_vaddr_alloc_page(vm);
+	svm->vmcb = (void *)vm_alloc_page(vm);
 	svm->vmcb_hva = addr_gva2hva(vm, (uintptr_t)svm->vmcb);
 	svm->vmcb_gpa = addr_gva2gpa(vm, (uintptr_t)svm->vmcb);
 
-	svm->save_area = (void *)vm_vaddr_alloc_page(vm);
+	svm->save_area = (void *)vm_alloc_page(vm);
 	svm->save_area_hva = addr_gva2hva(vm, (uintptr_t)svm->save_area);
 	svm->save_area_gpa = addr_gva2gpa(vm, (uintptr_t)svm->save_area);
 
-	svm->msr = (void *)vm_vaddr_alloc_page(vm);
+	svm->msr = (void *)vm_alloc_page(vm);
 	svm->msr_hva = addr_gva2hva(vm, (uintptr_t)svm->msr);
 	svm->msr_gpa = addr_gva2gpa(vm, (uintptr_t)svm->msr);
 	memset(svm->msr_hva, 0, getpagesize());
diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index b2f83c3f7f16..67642759e4a0 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -81,37 +81,37 @@ void vm_enable_ept(struct kvm_vm *vm)
 struct vmx_pages *
 vcpu_alloc_vmx(struct kvm_vm *vm, gva_t *p_vmx_gva)
 {
-	gva_t vmx_gva = vm_vaddr_alloc_page(vm);
+	gva_t vmx_gva = vm_alloc_page(vm);
 	struct vmx_pages *vmx = addr_gva2hva(vm, vmx_gva);
 
 	/* Setup of a region of guest memory for the vmxon region. */
-	vmx->vmxon = (void *)vm_vaddr_alloc_page(vm);
+	vmx->vmxon = (void *)vm_alloc_page(vm);
 	vmx->vmxon_hva = addr_gva2hva(vm, (uintptr_t)vmx->vmxon);
 	vmx->vmxon_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->vmxon);
 
 	/* Setup of a region of guest memory for a vmcs. */
-	vmx->vmcs = (void *)vm_vaddr_alloc_page(vm);
+	vmx->vmcs = (void *)vm_alloc_page(vm);
 	vmx->vmcs_hva = addr_gva2hva(vm, (uintptr_t)vmx->vmcs);
 	vmx->vmcs_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->vmcs);
 
 	/* Setup of a region of guest memory for the MSR bitmap. */
-	vmx->msr = (void *)vm_vaddr_alloc_page(vm);
+	vmx->msr = (void *)vm_alloc_page(vm);
 	vmx->msr_hva = addr_gva2hva(vm, (uintptr_t)vmx->msr);
 	vmx->msr_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->msr);
 	memset(vmx->msr_hva, 0, getpagesize());
 
 	/* Setup of a region of guest memory for the shadow VMCS. */
-	vmx->shadow_vmcs = (void *)vm_vaddr_alloc_page(vm);
+	vmx->shadow_vmcs = (void *)vm_alloc_page(vm);
 	vmx->shadow_vmcs_hva = addr_gva2hva(vm, (uintptr_t)vmx->shadow_vmcs);
 	vmx->shadow_vmcs_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->shadow_vmcs);
 
 	/* Setup of a region of guest memory for the VMREAD and VMWRITE bitmaps. */
-	vmx->vmread = (void *)vm_vaddr_alloc_page(vm);
+	vmx->vmread = (void *)vm_alloc_page(vm);
 	vmx->vmread_hva = addr_gva2hva(vm, (uintptr_t)vmx->vmread);
 	vmx->vmread_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->vmread);
 	memset(vmx->vmread_hva, 0, getpagesize());
 
-	vmx->vmwrite = (void *)vm_vaddr_alloc_page(vm);
+	vmx->vmwrite = (void *)vm_alloc_page(vm);
 	vmx->vmwrite_hva = addr_gva2hva(vm, (uintptr_t)vmx->vmwrite);
 	vmx->vmwrite_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->vmwrite);
 	memset(vmx->vmwrite_hva, 0, getpagesize());
@@ -390,7 +390,7 @@ bool kvm_cpu_has_ept(void)
 
 void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm)
 {
-	vmx->apic_access = (void *)vm_vaddr_alloc_page(vm);
+	vmx->apic_access = (void *)vm_alloc_page(vm);
 	vmx->apic_access_hva = addr_gva2hva(vm, (uintptr_t)vmx->apic_access);
 	vmx->apic_access_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->apic_access);
 }
diff --git a/tools/testing/selftests/kvm/s390/memop.c b/tools/testing/selftests/kvm/s390/memop.c
index 9855b5bfb5ed..0244848621b3 100644
--- a/tools/testing/selftests/kvm/s390/memop.c
+++ b/tools/testing/selftests/kvm/s390/memop.c
@@ -880,8 +880,8 @@ static void test_copy_key_fetch_prot_override(void)
 	struct test_default t = test_default_init(guest_copy_key_fetch_prot_override);
 	gva_t guest_0_page, guest_last_page;
 
-	guest_0_page = vm_vaddr_alloc(t.kvm_vm, PAGE_SIZE, 0);
-	guest_last_page = vm_vaddr_alloc(t.kvm_vm, PAGE_SIZE, last_page_addr);
+	guest_0_page = vm_alloc(t.kvm_vm, PAGE_SIZE, 0);
+	guest_last_page = vm_alloc(t.kvm_vm, PAGE_SIZE, last_page_addr);
 	if (guest_0_page != 0 || guest_last_page != last_page_addr) {
 		print_skip("did not allocate guest pages at required positions");
 		goto out;
@@ -919,8 +919,8 @@ static void test_errors_key_fetch_prot_override_not_enabled(void)
 	struct test_default t = test_default_init(guest_copy_key_fetch_prot_override);
 	gva_t guest_0_page, guest_last_page;
 
-	guest_0_page = vm_vaddr_alloc(t.kvm_vm, PAGE_SIZE, 0);
-	guest_last_page = vm_vaddr_alloc(t.kvm_vm, PAGE_SIZE, last_page_addr);
+	guest_0_page = vm_alloc(t.kvm_vm, PAGE_SIZE, 0);
+	guest_last_page = vm_alloc(t.kvm_vm, PAGE_SIZE, last_page_addr);
 	if (guest_0_page != 0 || guest_last_page != last_page_addr) {
 		print_skip("did not allocate guest pages at required positions");
 		goto out;
@@ -940,8 +940,8 @@ static void test_errors_key_fetch_prot_override_enabled(void)
 	struct test_default t = test_default_init(guest_copy_key_fetch_prot_override);
 	gva_t guest_0_page, guest_last_page;
 
-	guest_0_page = vm_vaddr_alloc(t.kvm_vm, PAGE_SIZE, 0);
-	guest_last_page = vm_vaddr_alloc(t.kvm_vm, PAGE_SIZE, last_page_addr);
+	guest_0_page = vm_alloc(t.kvm_vm, PAGE_SIZE, 0);
+	guest_last_page = vm_alloc(t.kvm_vm, PAGE_SIZE, last_page_addr);
 	if (guest_0_page != 0 || guest_last_page != last_page_addr) {
 		print_skip("did not allocate guest pages at required positions");
 		goto out;
diff --git a/tools/testing/selftests/kvm/s390/tprot.c b/tools/testing/selftests/kvm/s390/tprot.c
index e021e198b28e..8054d2b178f0 100644
--- a/tools/testing/selftests/kvm/s390/tprot.c
+++ b/tools/testing/selftests/kvm/s390/tprot.c
@@ -146,7 +146,7 @@ static enum stage perform_next_stage(int *i, bool mapped_0)
 		/*
 		 * Some fetch protection override tests require that page 0
 		 * be mapped, however, when the hosts tries to map that page via
-		 * vm_vaddr_alloc, it may happen that some other page gets mapped
+		 * vm_alloc, it may happen that some other page gets mapped
 		 * instead.
 		 * In order to skip these tests we detect this inside the guest
 		 */
@@ -219,7 +219,7 @@ int main(int argc, char *argv[])
 	mprotect(addr_gva2hva(vm, (gva_t)pages), PAGE_SIZE * 2, PROT_READ);
 	HOST_SYNC(vcpu, TEST_SIMPLE);
 
-	guest_0_page = vm_vaddr_alloc(vm, PAGE_SIZE, 0);
+	guest_0_page = vm_alloc(vm, PAGE_SIZE, 0);
 	if (guest_0_page != 0) {
 		/* Use NO_TAP so we don't get a PASS print */
 		HOST_SYNC_NO_TAP(vcpu, STAGE_INIT_FETCH_PROT_OVERRIDE);
diff --git a/tools/testing/selftests/kvm/x86/amx_test.c b/tools/testing/selftests/kvm/x86/amx_test.c
index 9ecf7515442b..4e63da2b1889 100644
--- a/tools/testing/selftests/kvm/x86/amx_test.c
+++ b/tools/testing/selftests/kvm/x86/amx_test.c
@@ -263,15 +263,15 @@ int main(int argc, char *argv[])
 	vcpu_regs_get(vcpu, &regs1);
 
 	/* amx cfg for guest_code */
-	amx_cfg = vm_vaddr_alloc_page(vm);
+	amx_cfg = vm_alloc_page(vm);
 	memset(addr_gva2hva(vm, amx_cfg), 0x0, getpagesize());
 
 	/* amx tiledata for guest_code */
-	tiledata = vm_vaddr_alloc_pages(vm, 2);
+	tiledata = vm_alloc_pages(vm, 2);
 	memset(addr_gva2hva(vm, tiledata), rand() | 1, 2 * getpagesize());
 
 	/* XSAVE state for guest_code */
-	xstate = vm_vaddr_alloc_pages(vm, DIV_ROUND_UP(XSAVE_SIZE, PAGE_SIZE));
+	xstate = vm_alloc_pages(vm, DIV_ROUND_UP(XSAVE_SIZE, PAGE_SIZE));
 	memset(addr_gva2hva(vm, xstate), 0, PAGE_SIZE * DIV_ROUND_UP(XSAVE_SIZE, PAGE_SIZE));
 	vcpu_args_set(vcpu, 3, amx_cfg, tiledata, xstate);
 
diff --git a/tools/testing/selftests/kvm/x86/cpuid_test.c b/tools/testing/selftests/kvm/x86/cpuid_test.c
index 3c45249a42c4..ef0ddd240887 100644
--- a/tools/testing/selftests/kvm/x86/cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86/cpuid_test.c
@@ -143,7 +143,7 @@ static void run_vcpu(struct kvm_vcpu *vcpu, int stage)
 struct kvm_cpuid2 *vcpu_alloc_cpuid(struct kvm_vm *vm, gva_t *p_gva, struct kvm_cpuid2 *cpuid)
 {
 	int size = sizeof(*cpuid) + cpuid->nent * sizeof(cpuid->entries[0]);
-	gva_t gva = vm_vaddr_alloc(vm, size, KVM_UTIL_MIN_VADDR);
+	gva_t gva = vm_alloc(vm, size, KVM_UTIL_MIN_VADDR);
 	struct kvm_cpuid2 *guest_cpuids = addr_gva2hva(vm, gva);
 
 	memcpy(guest_cpuids, cpuid, size);
diff --git a/tools/testing/selftests/kvm/x86/hyperv_clock.c b/tools/testing/selftests/kvm/x86/hyperv_clock.c
index 6bb1ca11256f..c083cea546dc 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_clock.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_clock.c
@@ -218,7 +218,7 @@ int main(void)
 
 	vcpu_set_hv_cpuid(vcpu);
 
-	tsc_page_gva = vm_vaddr_alloc_page(vm);
+	tsc_page_gva = vm_alloc_page(vm);
 	memset(addr_gva2hva(vm, tsc_page_gva), 0x0, getpagesize());
 	TEST_ASSERT((addr_gva2gpa(vm, tsc_page_gva) & (getpagesize() - 1)) == 0,
 		"TSC page has to be page aligned");
diff --git a/tools/testing/selftests/kvm/x86/hyperv_evmcs.c b/tools/testing/selftests/kvm/x86/hyperv_evmcs.c
index 061d9e1f02c0..c7fa114aee20 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_evmcs.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_evmcs.c
@@ -246,7 +246,7 @@ int main(int argc, char *argv[])
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
-	hcall_page = vm_vaddr_alloc_pages(vm, 1);
+	hcall_page = vm_alloc_pages(vm, 1);
 	memset(addr_gva2hva(vm, hcall_page), 0x0,  getpagesize());
 
 	vcpu_set_hv_cpuid(vcpu);
diff --git a/tools/testing/selftests/kvm/x86/hyperv_extended_hypercalls.c b/tools/testing/selftests/kvm/x86/hyperv_extended_hypercalls.c
index be7a2a631789..ae047db7b1be 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_extended_hypercalls.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_extended_hypercalls.c
@@ -57,11 +57,11 @@ int main(void)
 	vcpu_set_hv_cpuid(vcpu);
 
 	/* Hypercall input */
-	hcall_in_page = vm_vaddr_alloc_pages(vm, 1);
+	hcall_in_page = vm_alloc_pages(vm, 1);
 	memset(addr_gva2hva(vm, hcall_in_page), 0x0, vm->page_size);
 
 	/* Hypercall output */
-	hcall_out_page = vm_vaddr_alloc_pages(vm, 1);
+	hcall_out_page = vm_alloc_pages(vm, 1);
 	memset(addr_gva2hva(vm, hcall_out_page), 0x0, vm->page_size);
 
 	vcpu_args_set(vcpu, 3, addr_gva2gpa(vm, hcall_in_page),
diff --git a/tools/testing/selftests/kvm/x86/hyperv_features.c b/tools/testing/selftests/kvm/x86/hyperv_features.c
index 52dbd52ce606..7347f1fe5157 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_features.c
@@ -141,7 +141,7 @@ static void guest_test_msrs_access(void)
 	while (true) {
 		vm = vm_create_with_one_vcpu(&vcpu, guest_msr);
 
-		msr_gva = vm_vaddr_alloc_page(vm);
+		msr_gva = vm_alloc_page(vm);
 		memset(addr_gva2hva(vm, msr_gva), 0x0, getpagesize());
 		msr = addr_gva2hva(vm, msr_gva);
 
@@ -530,10 +530,10 @@ static void guest_test_hcalls_access(void)
 		vm = vm_create_with_one_vcpu(&vcpu, guest_hcall);
 
 		/* Hypercall input/output */
-		hcall_page = vm_vaddr_alloc_pages(vm, 2);
+		hcall_page = vm_alloc_pages(vm, 2);
 		memset(addr_gva2hva(vm, hcall_page), 0x0, 2 * getpagesize());
 
-		hcall_params = vm_vaddr_alloc_page(vm);
+		hcall_params = vm_alloc_page(vm);
 		memset(addr_gva2hva(vm, hcall_params), 0x0, getpagesize());
 		hcall = addr_gva2hva(vm, hcall_params);
 
diff --git a/tools/testing/selftests/kvm/x86/hyperv_ipi.c b/tools/testing/selftests/kvm/x86/hyperv_ipi.c
index beafcfa4043a..771535f9aad3 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_ipi.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_ipi.c
@@ -253,7 +253,7 @@ int main(int argc, char *argv[])
 	vm = vm_create_with_one_vcpu(&vcpu[0], sender_guest_code);
 
 	/* Hypercall input/output */
-	hcall_page = vm_vaddr_alloc_pages(vm, 2);
+	hcall_page = vm_alloc_pages(vm, 2);
 	memset(addr_gva2hva(vm, hcall_page), 0x0, 2 * getpagesize());
 
 
diff --git a/tools/testing/selftests/kvm/x86/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86/hyperv_svm_test.c
index 77b774b5041c..7a62f6a9d606 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_svm_test.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_svm_test.c
@@ -165,7 +165,7 @@ int main(int argc, char *argv[])
 	vcpu_alloc_svm(vm, &nested_gva);
 	vcpu_alloc_hyperv_test_pages(vm, &hv_pages_gva);
 
-	hcall_page = vm_vaddr_alloc_pages(vm, 1);
+	hcall_page = vm_alloc_pages(vm, 1);
 	memset(addr_gva2hva(vm, hcall_page), 0x0,  getpagesize());
 
 	vcpu_args_set(vcpu, 3, nested_gva, hv_pages_gva, addr_gva2gpa(vm, hcall_page));
diff --git a/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c b/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
index a4fb63112cac..6adf76574921 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
@@ -593,11 +593,11 @@ int main(int argc, char *argv[])
 	vm = vm_create_with_one_vcpu(&vcpu[0], sender_guest_code);
 
 	/* Test data page */
-	test_data_page = vm_vaddr_alloc_page(vm);
+	test_data_page = vm_alloc_page(vm);
 	data = (struct test_data *)addr_gva2hva(vm, test_data_page);
 
 	/* Hypercall input/output */
-	data->hcall_gva = vm_vaddr_alloc_pages(vm, 2);
+	data->hcall_gva = vm_alloc_pages(vm, 2);
 	data->hcall_gpa = addr_gva2gpa(vm, data->hcall_gva);
 	memset(addr_gva2hva(vm, data->hcall_gva), 0x0, 2 * PAGE_SIZE);
 
@@ -606,7 +606,7 @@ int main(int argc, char *argv[])
 	 * and the test will swap their mappings. The third page keeps the indication
 	 * about the current state of mappings.
 	 */
-	data->test_pages = vm_vaddr_alloc_pages(vm, NTEST_PAGES + 1);
+	data->test_pages = vm_alloc_pages(vm, NTEST_PAGES + 1);
 	for (i = 0; i < NTEST_PAGES; i++)
 		memset(addr_gva2hva(vm, data->test_pages + PAGE_SIZE * i),
 		       (u8)(i + 1), PAGE_SIZE);
diff --git a/tools/testing/selftests/kvm/x86/kvm_clock_test.c b/tools/testing/selftests/kvm/x86/kvm_clock_test.c
index 2b8a3feee1f8..5ad4aeb8e373 100644
--- a/tools/testing/selftests/kvm/x86/kvm_clock_test.c
+++ b/tools/testing/selftests/kvm/x86/kvm_clock_test.c
@@ -147,7 +147,7 @@ int main(void)
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_main);
 
-	pvti_gva = vm_vaddr_alloc(vm, getpagesize(), 0x10000);
+	pvti_gva = vm_alloc(vm, getpagesize(), 0x10000);
 	pvti_gpa = addr_gva2gpa(vm, pvti_gva);
 	vcpu_args_set(vcpu, 2, pvti_gpa, pvti_gva);
 
diff --git a/tools/testing/selftests/kvm/x86/sev_smoke_test.c b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
index 4e037795dc33..1a49ee391586 100644
--- a/tools/testing/selftests/kvm/x86/sev_smoke_test.c
+++ b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
@@ -115,8 +115,8 @@ static void test_sync_vmsa(u32 type, u64 policy)
 	struct kvm_xsave __attribute__((aligned(64))) xsave = { 0 };
 
 	vm = vm_sev_create_with_one_vcpu(type, guest_code_xsave, &vcpu);
-	gva = vm_vaddr_alloc_shared(vm, PAGE_SIZE, KVM_UTIL_MIN_VADDR,
-				    MEM_REGION_TEST_DATA);
+	gva = vm_alloc_shared(vm, PAGE_SIZE, KVM_UTIL_MIN_VADDR,
+			      MEM_REGION_TEST_DATA);
 	hva = addr_gva2hva(vm, gva);
 
 	vcpu_args_set(vcpu, 1, gva);
diff --git a/tools/testing/selftests/kvm/x86/svm_nested_soft_inject_test.c b/tools/testing/selftests/kvm/x86/svm_nested_soft_inject_test.c
index 5fefb319d9be..f72f11d4c4f8 100644
--- a/tools/testing/selftests/kvm/x86/svm_nested_soft_inject_test.c
+++ b/tools/testing/selftests/kvm/x86/svm_nested_soft_inject_test.c
@@ -161,7 +161,7 @@ static void run_test(bool is_nmi)
 	if (!is_nmi) {
 		void *idt, *idt_alt;
 
-		idt_alt_vm = vm_vaddr_alloc_page(vm);
+		idt_alt_vm = vm_alloc_page(vm);
 		idt_alt = addr_gva2hva(vm, idt_alt_vm);
 		idt = addr_gva2hva(vm, vm->arch.idt);
 		memcpy(idt_alt, idt, getpagesize());
diff --git a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
index 3df6df2a1b55..d2e2410f748b 100644
--- a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
+++ b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
@@ -414,7 +414,7 @@ int main(int argc, char *argv[])
 
 	params[1].vcpu = vm_vcpu_add(vm, 1, sender_guest_code);
 
-	test_data_page_vaddr = vm_vaddr_alloc_page(vm);
+	test_data_page_vaddr = vm_alloc_page(vm);
 	data = addr_gva2hva(vm, test_data_page_vaddr);
 	memset(data, 0, sizeof(*data));
 	params[0].data = data;
-- 
2.54.0.rc1.555.g9c883467ad-goog

