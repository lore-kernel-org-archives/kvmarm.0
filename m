Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8123D2C0263
	for <kvmarm@lists.linux.dev>; Tue, 30 Dec 2025 23:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767135757; cv=none; b=rij5mktMleFcMIDl0Zw3/48cAPgmNeCGfn8tThrVk/7NV2IfNmRUfyYJI8zkn6emnewuDIN0Oa6y1yljt96KxFTIxFTQUMuKIP3heAl8+Q1Ha9hfUez6M2VIVauDI2OPjYwN5STufjGUl/jtbhMmG+3XKUt7SRqZG83XdagbAvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767135757; c=relaxed/simple;
	bh=/HuCjXMO8BYhY2cJwTr7wd/hfTFZHB16fDr6+9ntWyE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ExzglFWrvQf3zP2MnHmjE5dt8ZFYRdv1hbfa1mATOYXXX7R63mnyvr+EJMqUG8ILQ+mVS57NkPU0kNe9gTS/PDFyHDa/gIpTePyVJRNmiFyhWEI2CofVZd6cD4hvIhqSnBgciVe1oQSg79svmjP+NBLifMrqgVhPvVUPC0fG7SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tNCoD/f/; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tNCoD/f/"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b6b194cf71so19431474b3a.3
        for <kvmarm@lists.linux.dev>; Tue, 30 Dec 2025 15:02:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767135750; x=1767740550; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=lvDGtOJlZOshVNKy7HhFV38ObB7SdC2/7YpvR2O0iOs=;
        b=tNCoD/f/aXAOW0ZQEhIsAkMpm79vekFy9z+vPbJMIv+keCdD5+FADbwV930kyyXbiq
         +rFN0L5oB1fKPAjf8eNPFfvqf48uF6mcqiMFw4jNLhdwHErTy9icz0FCRC43fwPbrFuk
         2a79Fuq6KjwIfaqT6OyQfWzxrClQpDzZOikPLCDLIAg1GPWsVoKXh24u5AScniug53lW
         m+0KleuP9977jPmDxb9POrcy9/OUDnzOGU138Bv59myPiidTtcw0hUe5hVeq4gR9I9pD
         qkyv18hMIvdrKgswK/e57ohaTq21ylW+CMjImPk9XH3Qt17gpjLFwnUxAwfiSv2VdqYt
         nOlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767135751; x=1767740551;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lvDGtOJlZOshVNKy7HhFV38ObB7SdC2/7YpvR2O0iOs=;
        b=Xy5A+c1nZV1r6YwC7l9VFa/IUyeJzc8GekDWPDBxnAeJyYSyNkL/J9mBEEFg0+M91B
         5BV7f7eaWx5pTGv7hzEpsnlMLiyOtafzFsI0H10yWOmUuKVxyAkHEjBjJmOAm0p9IoJP
         YUGEaeS7aqrZ5qVrkRIolQ7ugdGWFrmnbJi0vj1P1C9/Hg2cmuO7dQchu7Q3jfK15nrB
         A8Ya/1IPJEBKRhMlPgyaWZSKNqhUd00KSPh/NFRX9O/xVLIdHKNGqDj5ggtOfDiLzNG8
         zvHtUUt/L/WxsypPX59iDlosYH06YTW6RxH9Ph2Bg6jhpIdQDiDx3SA+GKw2+0wpMYLH
         mOig==
X-Forwarded-Encrypted: i=1; AJvYcCVfc68hkN8nhy84m4uk2U5Q1M7leOl36jJjUWfEz7QQ73e3DrK52FL80KzxIUquqg+15xorvP4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyaBHYp1zPBKBcrxvvawlf9NiUDp7KdeNj9EOLrOxrgLrGsAoq+
	JCyFJGKF9fH2VLdGuzrSXv4efQS0UtMV5bjVAHYFmj5KYxfB45aOjQqp4hWhukzlsJ1vBNgxErb
	NiRomrw==
X-Google-Smtp-Source: AGHT+IFl+E4iBtLvuy29ZNl15W5f+YM/yuQ6NLYMRsjb6K6O2MuWbmEY/dD/ZgE2AJbg2gFPgmlYtjYuvMQ=
X-Received: from pfbem48.prod.google.com ([2002:a05:6a00:3770:b0:7f9:3450:d9b0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:420b:b0:7e8:4471:ae55
 with SMTP id d2e1a72fcca58-7ff6745678amr28709155b3a.33.1767135750526; Tue, 30
 Dec 2025 15:02:30 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 15:01:50 -0800
In-Reply-To: <20251230230150.4150236-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230230150.4150236-22-seanjc@google.com>
Subject: [PATCH v4 21/21] KVM: selftests: Test READ=>WRITE dirty logging
 behavior for shadow MMU
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
	linux-kernel@vger.kernel.org, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Update the nested dirty log test to validate KVM's handling of READ faults
when dirty logging is enabled.  Specifically, set the Dirty bit in the
guest PTEs used to map L2 GPAs, so that KVM will create writable SPTEs
when handling L2 read faults.  When handling read faults in the shadow MMU,
KVM opportunistically creates a writable SPTE if the mapping can be
writable *and* the gPTE is dirty (or doesn't support the Dirty bit), i.e.
if KVM doesn't need to intercept writes in order to emulate Dirty-bit
updates.

To actually test the L2 READ=>WRITE sequence, e.g. without masking a false
pass by other test activity, route the READ=>WRITE and WRITE=>WRITE
sequences to separate L1 pages, and differentiate between "marked dirty
due to a WRITE access/fault" and "marked dirty due to creating a writable
SPTE for a READ access/fault".  The updated sequence exposes the bug fixed
by KVM commit 1f4e5fc83a42 ("KVM: x86: fix nested guest live migration
with PML") when the guest performs a READ=>WRITE sequence.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86/processor.h     |   1 +
 .../testing/selftests/kvm/lib/x86/processor.c |   7 ++
 .../selftests/kvm/x86/nested_dirty_log_test.c | 115 +++++++++++++-----
 3 files changed, 90 insertions(+), 33 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index ab29b1c7ed2d..8945c9eea704 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1483,6 +1483,7 @@ bool kvm_cpu_has_tdp(void);
 void tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr, uint64_t size);
 void tdp_identity_map_default_memslots(struct kvm_vm *vm);
 void tdp_identity_map_1g(struct kvm_vm *vm,  uint64_t addr, uint64_t size);
+uint64_t *tdp_get_pte(struct kvm_vm *vm, uint64_t l2_gpa);
 
 /*
  * Basic CPU control in CR0
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index ab869a98bbdc..fab18e9be66c 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -390,6 +390,13 @@ static uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm,
 	return virt_get_pte(vm, mmu, pte, vaddr, PG_LEVEL_4K);
 }
 
+uint64_t *tdp_get_pte(struct kvm_vm *vm, uint64_t l2_gpa)
+{
+	int level = PG_LEVEL_4K;
+
+	return __vm_get_page_table_entry(vm, &vm->stage2_mmu, l2_gpa, &level);
+}
+
 uint64_t *vm_get_pte(struct kvm_vm *vm, uint64_t vaddr)
 {
 	int level = PG_LEVEL_4K;
diff --git a/tools/testing/selftests/kvm/x86/nested_dirty_log_test.c b/tools/testing/selftests/kvm/x86/nested_dirty_log_test.c
index 89d2e86a0db9..1e7c1ed917e1 100644
--- a/tools/testing/selftests/kvm/x86/nested_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_dirty_log_test.c
@@ -17,29 +17,39 @@
 
 /* The memory slot index to track dirty pages */
 #define TEST_MEM_SLOT_INDEX		1
-#define TEST_MEM_PAGES			3
+#define TEST_MEM_PAGES			4
 
 /* L1 guest test virtual memory offset */
-#define GUEST_TEST_MEM			0xc0000000
+#define GUEST_TEST_MEM1			0xc0000000
+#define GUEST_TEST_MEM2			0xc0002000
 
 /* L2 guest test virtual memory offset */
 #define NESTED_TEST_MEM1		0xc0001000
-#define NESTED_TEST_MEM2		0xc0002000
+#define NESTED_TEST_MEM2		0xc0003000
 
 #define L2_GUEST_STACK_SIZE 64
 
+#define TEST_SYNC_PAGE_MASK	0xfull
+#define TEST_SYNC_READ_FAULT	BIT(4)
+#define TEST_SYNC_WRITE_FAULT	BIT(5)
+#define TEST_SYNC_NO_FAULT	BIT(6)
+
 static void l2_guest_code(u64 *a, u64 *b)
 {
 	READ_ONCE(*a);
+	GUEST_SYNC(0 | TEST_SYNC_READ_FAULT);
 	WRITE_ONCE(*a, 1);
-	GUEST_SYNC(true);
-	GUEST_SYNC(false);
+	GUEST_SYNC(0 | TEST_SYNC_WRITE_FAULT);
+	READ_ONCE(*a);
+	GUEST_SYNC(0 | TEST_SYNC_NO_FAULT);
 
 	WRITE_ONCE(*b, 1);
-	GUEST_SYNC(true);
+	GUEST_SYNC(2 | TEST_SYNC_WRITE_FAULT);
 	WRITE_ONCE(*b, 1);
-	GUEST_SYNC(true);
-	GUEST_SYNC(false);
+	GUEST_SYNC(2 | TEST_SYNC_WRITE_FAULT);
+	READ_ONCE(*b);
+	GUEST_SYNC(2 | TEST_SYNC_NO_FAULT);
+	GUEST_SYNC(2 | TEST_SYNC_NO_FAULT);
 
 	/* Exit to L1 and never come back.  */
 	vmcall();
@@ -53,7 +63,7 @@ static void l2_guest_code_tdp_enabled(void)
 static void l2_guest_code_tdp_disabled(void)
 {
 	/* Access the same L1 GPAs as l2_guest_code_tdp_enabled() */
-	l2_guest_code((u64 *)GUEST_TEST_MEM, (u64 *)GUEST_TEST_MEM);
+	l2_guest_code((u64 *)GUEST_TEST_MEM1, (u64 *)GUEST_TEST_MEM2);
 }
 
 void l1_vmx_code(struct vmx_pages *vmx)
@@ -72,9 +82,11 @@ void l1_vmx_code(struct vmx_pages *vmx)
 
 	prepare_vmcs(vmx, l2_rip, &l2_guest_stack[L2_GUEST_STACK_SIZE]);
 
-	GUEST_SYNC(false);
+	GUEST_SYNC(0 | TEST_SYNC_NO_FAULT);
+	GUEST_SYNC(2 | TEST_SYNC_NO_FAULT);
 	GUEST_ASSERT(!vmlaunch());
-	GUEST_SYNC(false);
+	GUEST_SYNC(0 | TEST_SYNC_NO_FAULT);
+	GUEST_SYNC(2 | TEST_SYNC_NO_FAULT);
 	GUEST_ASSERT_EQ(vmreadz(VM_EXIT_REASON), EXIT_REASON_VMCALL);
 	GUEST_DONE();
 }
@@ -91,9 +103,11 @@ static void l1_svm_code(struct svm_test_data *svm)
 
 	generic_svm_setup(svm, l2_rip, &l2_guest_stack[L2_GUEST_STACK_SIZE]);
 
-	GUEST_SYNC(false);
+	GUEST_SYNC(0 | TEST_SYNC_NO_FAULT);
+	GUEST_SYNC(2 | TEST_SYNC_NO_FAULT);
 	run_guest(svm->vmcb, svm->vmcb_gpa);
-	GUEST_SYNC(false);
+	GUEST_SYNC(0 | TEST_SYNC_NO_FAULT);
+	GUEST_SYNC(2 | TEST_SYNC_NO_FAULT);
 	GUEST_ASSERT_EQ(svm->vmcb->control.exit_code, SVM_EXIT_VMMCALL);
 	GUEST_DONE();
 }
@@ -106,6 +120,11 @@ static void l1_guest_code(void *data)
 		l1_svm_code(data);
 }
 
+static uint64_t test_read_host_page(uint64_t *host_test_mem, int page_nr)
+{
+	return host_test_mem[PAGE_SIZE * page_nr / sizeof(*host_test_mem)];
+}
+
 static void test_dirty_log(bool nested_tdp)
 {
 	vm_vaddr_t nested_gva = 0;
@@ -133,32 +152,45 @@ static void test_dirty_log(bool nested_tdp)
 
 	/* Add an extra memory slot for testing dirty logging */
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
-				    GUEST_TEST_MEM,
+				    GUEST_TEST_MEM1,
 				    TEST_MEM_SLOT_INDEX,
 				    TEST_MEM_PAGES,
 				    KVM_MEM_LOG_DIRTY_PAGES);
 
 	/*
-	 * Add an identity map for GVA range [0xc0000000, 0xc0002000).  This
+	 * Add an identity map for GVA range [0xc0000000, 0xc0004000).  This
 	 * affects both L1 and L2.  However...
 	 */
-	virt_map(vm, GUEST_TEST_MEM, GUEST_TEST_MEM, TEST_MEM_PAGES);
+	virt_map(vm, GUEST_TEST_MEM1, GUEST_TEST_MEM1, TEST_MEM_PAGES);
 
 	/*
-	 * ... pages in the L2 GPA range [0xc0001000, 0xc0003000) will map to
-	 * 0xc0000000.
+	 * ... pages in the L2 GPA ranges [0xc0001000, 0xc0002000) and
+	 * [0xc0003000, 0xc0004000) will map to 0xc0000000 and 0xc0001000
+	 * respectively.
 	 *
 	 * When TDP is disabled, the L2 guest code will still access the same L1
 	 * GPAs as the TDP enabled case.
+	 *
+	 * Set the Dirty bit in the PTEs used by L2 so that KVM will create
+	 * writable SPTEs when handling read faults (if the Dirty bit isn't
+	 * set, KVM must intercept the next write to emulate the Dirty bit
+	 * update).
 	 */
 	if (nested_tdp) {
 		tdp_identity_map_default_memslots(vm);
-		tdp_map(vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, PAGE_SIZE);
-		tdp_map(vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, PAGE_SIZE);
+		tdp_map(vm, NESTED_TEST_MEM1, GUEST_TEST_MEM1, PAGE_SIZE);
+		tdp_map(vm, NESTED_TEST_MEM2, GUEST_TEST_MEM2, PAGE_SIZE);
+
+
+		*tdp_get_pte(vm, NESTED_TEST_MEM1) |= PTE_DIRTY_MASK(&vm->stage2_mmu);
+		*tdp_get_pte(vm, NESTED_TEST_MEM2) |= PTE_DIRTY_MASK(&vm->stage2_mmu);
+	} else {
+		*vm_get_pte(vm, GUEST_TEST_MEM1) |= PTE_DIRTY_MASK(&vm->mmu);
+		*vm_get_pte(vm, GUEST_TEST_MEM2) |= PTE_DIRTY_MASK(&vm->mmu);
 	}
 
 	bmap = bitmap_zalloc(TEST_MEM_PAGES);
-	host_test_mem = addr_gpa2hva(vm, GUEST_TEST_MEM);
+	host_test_mem = addr_gpa2hva(vm, GUEST_TEST_MEM1);
 
 	while (!done) {
 		memset(host_test_mem, 0xaa, TEST_MEM_PAGES * PAGE_SIZE);
@@ -169,25 +201,42 @@ static void test_dirty_log(bool nested_tdp)
 		case UCALL_ABORT:
 			REPORT_GUEST_ASSERT(uc);
 			/* NOT REACHED */
-		case UCALL_SYNC:
+		case UCALL_SYNC: {
+			int page_nr = uc.args[1] & TEST_SYNC_PAGE_MASK;
+			int i;
+
 			/*
 			 * The nested guest wrote at offset 0x1000 in the memslot, but the
 			 * dirty bitmap must be filled in according to L1 GPA, not L2.
 			 */
 			kvm_vm_get_dirty_log(vm, TEST_MEM_SLOT_INDEX, bmap);
-			if (uc.args[1]) {
-				TEST_ASSERT(test_bit(0, bmap), "Page 0 incorrectly reported clean");
-				TEST_ASSERT(host_test_mem[0] == 1, "Page 0 not written by guest");
-			} else {
-				TEST_ASSERT(!test_bit(0, bmap), "Page 0 incorrectly reported dirty");
-				TEST_ASSERT(host_test_mem[0] == 0xaaaaaaaaaaaaaaaaULL, "Page 0 written by guest");
+
+			/*
+			 * If a fault is expected, the page should be dirty
+			 * as the Dirty bit is set in the gPTE.  KVM should
+			 * create a writable SPTE even on a read fault, *and*
+			 * KVM must mark the GFN as dirty when doing so.
+			 */
+			TEST_ASSERT(test_bit(page_nr, bmap) == !(uc.args[1] & TEST_SYNC_NO_FAULT),
+				    "Page %u incorrectly reported %s on %s fault", page_nr,
+				    test_bit(page_nr, bmap) ? "dirty" : "clean",
+				    uc.args[1] & TEST_SYNC_NO_FAULT ? "no" :
+				    uc.args[1] & TEST_SYNC_READ_FAULT ? "read" : "write");
+
+			for (i = 0; i < TEST_MEM_PAGES; i++) {
+				if (i == page_nr && uc.args[1] & TEST_SYNC_WRITE_FAULT)
+					TEST_ASSERT(test_read_host_page(host_test_mem, i) == 1,
+						    "Page %u not written by guest", i);
+				else
+					TEST_ASSERT(test_read_host_page(host_test_mem, i) == 0xaaaaaaaaaaaaaaaaULL,
+						    "Page %u written by guest", i);
+
+				if (i != page_nr)
+					TEST_ASSERT(!test_bit(i, bmap),
+						    "Page %u incorrectly reported dirty", i);
 			}
-
-			TEST_ASSERT(!test_bit(1, bmap), "Page 1 incorrectly reported dirty");
-			TEST_ASSERT(host_test_mem[PAGE_SIZE / 8] == 0xaaaaaaaaaaaaaaaaULL, "Page 1 written by guest");
-			TEST_ASSERT(!test_bit(2, bmap), "Page 2 incorrectly reported dirty");
-			TEST_ASSERT(host_test_mem[PAGE_SIZE*2 / 8] == 0xaaaaaaaaaaaaaaaaULL, "Page 2 written by guest");
 			break;
+		}
 		case UCALL_DONE:
 			done = true;
 			break;
-- 
2.52.0.351.gbe84eed79e-goog

