Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0622928688C
	for <kvmarm@lists.linux.dev>; Thu,  8 Jan 2026 16:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767889968; cv=none; b=im7IvzSlXO7lvUWmTtqFzExKOUP5/Vps506RQn+PUgcVogRaArnl9rPOraoqoSfbTip3ojCTShtiApspFRGzVFiS9cV7XFwUYV9wERj0KvUVk4ONGXFWnfPrurE+jM1hk5k2B4EyHYq2JKUCKral4OhgwepuQzYFJFoEzoG9Y8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767889968; c=relaxed/simple;
	bh=7yODmsYaY+vX4O+5XEmihnIcBCBl0FHhG1aDEp4bOsc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CaBCRgI6xu9vgwmFJAT9LrvqBV8pr0lNijxfpv2z9dK30RLKxTYmfNXpo3CKtZBbvqF67EI/Oi+mzlrdOTaZJRVNvyVvPcATmIhBqFlXJ5RkhEJrbaZinVnXy4LykVfUQXhutw6R//1wm2F+f/QHiDKxfakLUbsMKTvScTRswUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k3Pztu9+; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k3Pztu9+"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c48a76e75so4191975a91.1
        for <kvmarm@lists.linux.dev>; Thu, 08 Jan 2026 08:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767889966; x=1768494766; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P4weczJ0CflKmWmemkjVQLod+ZW9LM2QROk7btr2Pj0=;
        b=k3Pztu9+eXkix4VPbfUpugk6YOOYG7tSxKWJPdHR+PPoHEN9WyTi1Rz5bb1dq+IAv1
         HrKWqv5xfVmTnJs2RFi7PsLAKlPbtSqAEyqLub2CLGukM8SCDetcWp/X9SfZpHYZzD1H
         eAOr19H6CA7HosjUTazvx8Vi7H+XpG2X+ri3qhQ3g/GYhr1hkrx8FkHEycYniZfsiuHV
         swel6E9yyIAc9a/FjsPhlZD3/eT7CkmKNhDpIHsXzn8O+cYxDzNsc0az/moprBo1Wuf+
         BWZ2D0f9yDqG5SiT6ch0OYdVLkzYZYiJ/tMHfWXhmJRJXTMv0Qw+8pa9XmjiDJYJTplt
         XEow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767889966; x=1768494766;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P4weczJ0CflKmWmemkjVQLod+ZW9LM2QROk7btr2Pj0=;
        b=HvJxrlzQQvYJVW4+oU6SATfCn7k1c3xJw3f53fUwH92upKvvDjkHz8XpnOCIVHP4bF
         wcAepi+RCSpnLtOdSW6ZVVxzafmU+J79ksUvfkZdegTZzhYIEp2e1gwwZ5s0F8p7T4PL
         O8HrnC6qSjXFXou270q1aP2BMW4TtW0/Xm8Go7TBRnPOTBUsUgtWW44brwcbobaoH8Ny
         qqKLYg1L7H7JvxbUXrKZ18Mk+K9ua3gV5232KcnonJgj6p5IKXi/U98lknZUM67DW7Xx
         ISXtALuqMrJKO9oLD/YgMjnhnPfFyuqx61lOYBhRWwGXxC+5fA4tSZ58vPiMST9ytVrB
         JF8A==
X-Forwarded-Encrypted: i=1; AJvYcCVb+em1MJcrKcWrKfMx3lbtYbnr03EP/HAPHdpsBsVKOtNhuSPMIefi0ddV3U35XZvKCf8Kr2g=@lists.linux.dev
X-Gm-Message-State: AOJu0YzFzbSHeCsXpz7d6UAnT88CKvXsb+b7GQlhMMc95OFhVd0SSZHd
	vLp6Iw6dDwx53LozNS/1MfI5vPUApj6hEGCtYGwG1eVFCb7zBIRLhJsQX6bexxUJXNnOglRjWdx
	fHeUxHg==
X-Google-Smtp-Source: AGHT+IE52p68bfcsN1dFtZpJ3rbWKn9Teo6CB2P4bpjVKJkGE0poIQ7b/YVeU0+kM07hg/nx48xC5EXqdCA=
X-Received: from pjbgk8.prod.google.com ([2002:a17:90b:1188:b0:340:7740:281c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3852:b0:343:b610:901c
 with SMTP id 98e67ed59e1d1-34f68cb9036mr7160126a91.26.1767889966231; Thu, 08
 Jan 2026 08:32:46 -0800 (PST)
Date: Thu, 8 Jan 2026 08:32:44 -0800
In-Reply-To: <t7dcszq3quhqprdcqz7keykxbmqf62pdelqrkeilpbmsrnuji5@a3lplybmlbwf>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com> <20251230230150.4150236-22-seanjc@google.com>
 <t7dcszq3quhqprdcqz7keykxbmqf62pdelqrkeilpbmsrnuji5@a3lplybmlbwf>
Message-ID: <aV_cLAlz4v1VOkDt@google.com>
Subject: Re: [PATCH v4 21/21] KVM: selftests: Test READ=>WRITE dirty logging
 behavior for shadow MMU
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 02, 2026, Yosry Ahmed wrote:
> On Tue, Dec 30, 2025 at 03:01:50PM -0800, Sean Christopherson wrote:
> >  	WRITE_ONCE(*b, 1);
> > -	GUEST_SYNC(true);
> > +	GUEST_SYNC(2 | TEST_SYNC_WRITE_FAULT);
> >  	WRITE_ONCE(*b, 1);
> > -	GUEST_SYNC(true);
> > -	GUEST_SYNC(false);
> > +	GUEST_SYNC(2 | TEST_SYNC_WRITE_FAULT);
> > +	READ_ONCE(*b);
> > +	GUEST_SYNC(2 | TEST_SYNC_NO_FAULT);
> > +	GUEST_SYNC(2 | TEST_SYNC_NO_FAULT);
> 
> Instead of hardcoding 0 and 2 here, which IIUC correspond to the
> physical addresses 0xc0000000 and 0xc0002000, as well as indices in
> host_test_mem, can we make the overall definitions a bit more intuitive?
> 
> For example:
> 
> #define GUEST_GPA_START		0xc0000000
> #define GUEST_PAGE1_IDX		0
> #define GUEST_PAGE2_IDX		1
> #define GUEST_GPA_PAGE1		(GUEST_GPA_START + GUEST_PAGE1_IDX * PAGE_SIZE)
> #define GUEST_GPA_PAGE2		(GUEST_GPA_START + GUEST_PAGE2_IDX * PAGE_SIZE)
> 
> /* Mapped to GUEST_GPA_PAGE1 and GUEST_GPA_PAGE2 */
> #define GUEST_GVA_PAGE1		0xd0000000
> #define GUEST_GVA_PAGE2		0xd0002000
> 
> /* Mapped to GUEST_GPA_PAGE1 and GUEST_GPA_PAGE2 using TDP in L1 */
> #define GUEST_GVA_NESTED_PAGE1  0xd0001000
> #define GUEST_GVA_NESTED_PAGE2	0xd0003000
> 
> Then in L2 code, we can explicitly take in the GVA of page1 and page2
> and use the definitions above in the GUEST_SYNC() calls, for example:
> 
> static void l2_guest_code(u64 *page1_gva, u64 *page2_gva)
> {
>         READ_ONCE(*page1_gva);
>         GUEST_SYNC(GUEST_PAGE1_IDX | TEST_SYNC_READ_FAULT);
>         WRITE_ONCE(*page1_gva, 1);
>         GUEST_SYNC(GUEST_PAGE1_IDX | TEST_SYNC_WRITE_FAULT);
> 	...
> }
> 
> and we can explicitly read page1 and page2 from the host (instead of
> using host_test_mem).
> 
> Alternatively, we can pass in the guest GVA directly into GUEST_SYNC(),
> and use the lower bits for TEST_SYNC_READ_FAULT, TEST_SYNC_WRITE_FAULT,
> and TEST_SYNC_NO_FAULT.
>
> WDYT?

I fiddled with this a bunch and came up with the below.  It's more or less what
you're suggesting, but instead of interleaving the aliases, it simply puts them
at a higher base.  That makes pulling the page frame number out of the GVA much
cleaner, as it's simply arithmetic instead of weird masking and shifting magic.

--
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 7 Jan 2026 14:38:32 -0800
Subject: [PATCH] KVM: selftests: Test READ=>WRITE dirty logging behavior for
 shadow MMU

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
with PML") when the guest performs a READ=>WRITE sequence with dirty guest
PTEs.

Opportunistically tweak and rename the address macros, and add comments,
to make it more obvious what the test is doing.  E.g. NESTED_TEST_MEM1
vs. GUEST_TEST_MEM doesn't make it all that obvious that the test is
creating aliases in both the L2 GPA and GVA address spaces, but only when
L1 is using TDP to run L2.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86/processor.h     |   1 +
 .../testing/selftests/kvm/lib/x86/processor.c |   7 +
 .../selftests/kvm/x86/nested_dirty_log_test.c | 188 +++++++++++++-----
 3 files changed, 145 insertions(+), 51 deletions(-)

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
index 89d2e86a0db9..6f4f7a8209be 100644
--- a/tools/testing/selftests/kvm/x86/nested_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_dirty_log_test.c
@@ -17,29 +17,53 @@
 
 /* The memory slot index to track dirty pages */
 #define TEST_MEM_SLOT_INDEX		1
-#define TEST_MEM_PAGES			3
 
-/* L1 guest test virtual memory offset */
-#define GUEST_TEST_MEM			0xc0000000
+/*
+ * Allocate four pages total.  Two pages are used to verify that the KVM marks
+ * the accessed page/GFN as marked dirty, but not the "other" page.  Times two
+ * so that each "normal" page can be accessed from L2 via an aliased L2 GVA+GPA
+ * (when TDP is enabled), to verify KVM marks _L1's_ page/GFN as dirty (to
+ * detect failures, L2 => L1 GPAs can't be identity mapped in the TDP page
+ * tables, as marking L2's GPA dirty would get a false pass if L1 == L2).
+ */
+#define TEST_MEM_PAGES			4
 
-/* L2 guest test virtual memory offset */
-#define NESTED_TEST_MEM1		0xc0001000
-#define NESTED_TEST_MEM2		0xc0002000
+#define TEST_MEM_BASE			0xc0000000
+#define TEST_MEM_ALIAS_BASE		0xc0002000
+
+#define TEST_GUEST_ADDR(base, idx)	((base) + (idx) * PAGE_SIZE)
+
+#define TEST_GVA(idx)			TEST_GUEST_ADDR(TEST_MEM_BASE, idx)
+#define TEST_GPA(idx)			TEST_GUEST_ADDR(TEST_MEM_BASE, idx)
+
+#define TEST_HVA(vm, idx)		addr_gpa2hva(vm, TEST_GPA(idx))
 
 #define L2_GUEST_STACK_SIZE 64
 
-static void l2_guest_code(u64 *a, u64 *b)
+/* Use the page offset bits to communicate the access+fault type. */
+#define TEST_SYNC_READ_FAULT		BIT(0)
+#define TEST_SYNC_WRITE_FAULT		BIT(1)
+#define TEST_SYNC_NO_FAULT		BIT(2)
+
+static void l2_guest_code(vm_vaddr_t base)
 {
-	READ_ONCE(*a);
-	WRITE_ONCE(*a, 1);
-	GUEST_SYNC(true);
-	GUEST_SYNC(false);
+	vm_vaddr_t page0 = TEST_GUEST_ADDR(base, 0);
+	vm_vaddr_t page1 = TEST_GUEST_ADDR(base, 1);
 
-	WRITE_ONCE(*b, 1);
-	GUEST_SYNC(true);
-	WRITE_ONCE(*b, 1);
-	GUEST_SYNC(true);
-	GUEST_SYNC(false);
+	READ_ONCE(*(u64 *)page0);
+	GUEST_SYNC(page0 | TEST_SYNC_READ_FAULT);
+	WRITE_ONCE(*(u64 *)page0, 1);
+	GUEST_SYNC(page0 | TEST_SYNC_WRITE_FAULT);
+	READ_ONCE(*(u64 *)page0);
+	GUEST_SYNC(page0 | TEST_SYNC_NO_FAULT);
+
+	WRITE_ONCE(*(u64 *)page1, 1);
+	GUEST_SYNC(page1 | TEST_SYNC_WRITE_FAULT);
+	WRITE_ONCE(*(u64 *)page1, 1);
+	GUEST_SYNC(page1 | TEST_SYNC_WRITE_FAULT);
+	READ_ONCE(*(u64 *)page1);
+	GUEST_SYNC(page1 | TEST_SYNC_NO_FAULT);
+	GUEST_SYNC(page1 | TEST_SYNC_NO_FAULT);
 
 	/* Exit to L1 and never come back.  */
 	vmcall();
@@ -47,13 +71,22 @@ static void l2_guest_code(u64 *a, u64 *b)
 
 static void l2_guest_code_tdp_enabled(void)
 {
-	l2_guest_code((u64 *)NESTED_TEST_MEM1, (u64 *)NESTED_TEST_MEM2);
+	/*
+	 * Use the aliased virtual addresses when running with TDP to verify
+	 * that KVM correctly handles the case where a page is dirtied via a
+	 * different GPA than would be used by L1.
+	 */
+	l2_guest_code(TEST_MEM_ALIAS_BASE);
 }
 
 static void l2_guest_code_tdp_disabled(void)
 {
-	/* Access the same L1 GPAs as l2_guest_code_tdp_enabled() */
-	l2_guest_code((u64 *)GUEST_TEST_MEM, (u64 *)GUEST_TEST_MEM);
+	/*
+	 * Use the "normal" virtual addresses when running without TDP enabled,
+	 * in which case L2 will use the same page tables as L1, and thus needs
+	 * to use the same virtual addresses that are mapped into L1.
+	 */
+	l2_guest_code(TEST_MEM_BASE);
 }
 
 void l1_vmx_code(struct vmx_pages *vmx)
@@ -72,9 +105,9 @@ void l1_vmx_code(struct vmx_pages *vmx)
 
 	prepare_vmcs(vmx, l2_rip, &l2_guest_stack[L2_GUEST_STACK_SIZE]);
 
-	GUEST_SYNC(false);
+	GUEST_SYNC(TEST_SYNC_NO_FAULT);
 	GUEST_ASSERT(!vmlaunch());
-	GUEST_SYNC(false);
+	GUEST_SYNC(TEST_SYNC_NO_FAULT);
 	GUEST_ASSERT_EQ(vmreadz(VM_EXIT_REASON), EXIT_REASON_VMCALL);
 	GUEST_DONE();
 }
@@ -91,9 +124,9 @@ static void l1_svm_code(struct svm_test_data *svm)
 
 	generic_svm_setup(svm, l2_rip, &l2_guest_stack[L2_GUEST_STACK_SIZE]);
 
-	GUEST_SYNC(false);
+	GUEST_SYNC(TEST_SYNC_NO_FAULT);
 	run_guest(svm->vmcb, svm->vmcb_gpa);
-	GUEST_SYNC(false);
+	GUEST_SYNC(TEST_SYNC_NO_FAULT);
 	GUEST_ASSERT_EQ(svm->vmcb->control.exit_code, SVM_EXIT_VMMCALL);
 	GUEST_DONE();
 }
@@ -106,12 +139,66 @@ static void l1_guest_code(void *data)
 		l1_svm_code(data);
 }
 
+static void test_handle_ucall_sync(struct kvm_vm *vm, u64 arg,
+				   unsigned long *bmap)
+{
+	vm_vaddr_t gva = arg & ~(PAGE_SIZE - 1);
+	int page_nr, i;
+
+	/*
+	 * Extract the page number of underlying physical page, which is also
+	 * the _L1_ page number.  The dirty bitmap _must_ be updated based on
+	 * the L1 GPA, not L2 GPA, i.e. whether or not L2 used an aliased GPA
+	 * (i.e. if TDP enabled for L2) is irrelevant with respect to the dirty
+	 * bitmap and which underlying physical page is accessed.
+	 *
+	 * Note, gva will be '0' if there was no access, i.e. if the purpose of
+	 * the sync is to verify all pages are clean.
+	 */
+	if (!gva)
+		page_nr = 0;
+	else if (gva >= TEST_MEM_ALIAS_BASE)
+		page_nr = (gva - TEST_MEM_ALIAS_BASE) >> PAGE_SHIFT;
+	else
+		page_nr = (gva - TEST_MEM_BASE) >> PAGE_SHIFT;
+	TEST_ASSERT(page_nr == 0 || page_nr == 1,
+		    "Test bug, unexpected frame number '%u' for arg = %lx", page_nr, arg);
+	TEST_ASSERT(gva || (arg & TEST_SYNC_NO_FAULT),
+		    "Test bug, gva must be valid if a fault is expected");
+
+	kvm_vm_get_dirty_log(vm, TEST_MEM_SLOT_INDEX, bmap);
+
+	/*
+	 * Check all pages to verify the correct physical page was modified (or
+	 * not), and that all pages are clean/dirty as expected.
+	 *
+	 * If a fault of any kind is expected, the target page should be dirty
+	 * as the Dirty bit is set in the gPTE.  KVM should create a writable
+	 * SPTE even on a read fault, *and* KVM must mark the GFN as dirty
+	 * when doing so.
+	 */
+	for (i = 0; i < TEST_MEM_PAGES; i++) {
+		if (i == page_nr && arg & TEST_SYNC_WRITE_FAULT)
+			TEST_ASSERT(*(u64 *)TEST_HVA(vm, i) == 1,
+				    "Page %u incorrectly not written by guest", i);
+		else
+			TEST_ASSERT(*(u64 *)TEST_HVA(vm, i) == 0xaaaaaaaaaaaaaaaaULL,
+				    "Page %u incorrectly written by guest", i);
+
+		if (i == page_nr && !(arg & TEST_SYNC_NO_FAULT))
+			TEST_ASSERT(test_bit(i, bmap),
+				    "Page %u incorrectly reported clean on %s fault",
+				    i, arg & TEST_SYNC_READ_FAULT ? "read" : "write");
+		else
+			TEST_ASSERT(!test_bit(i, bmap),
+				    "Page %u incorrectly reported dirty", i);
+	}
+}
+
 static void test_dirty_log(bool nested_tdp)
 {
 	vm_vaddr_t nested_gva = 0;
 	unsigned long *bmap;
-	uint64_t *host_test_mem;
-
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct ucall uc;
@@ -133,35 +220,50 @@ static void test_dirty_log(bool nested_tdp)
 
 	/* Add an extra memory slot for testing dirty logging */
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
-				    GUEST_TEST_MEM,
+				    TEST_MEM_BASE,
 				    TEST_MEM_SLOT_INDEX,
 				    TEST_MEM_PAGES,
 				    KVM_MEM_LOG_DIRTY_PAGES);
 
 	/*
-	 * Add an identity map for GVA range [0xc0000000, 0xc0002000).  This
+	 * Add an identity map for GVA range [0xc0000000, 0xc0004000).  This
 	 * affects both L1 and L2.  However...
 	 */
-	virt_map(vm, GUEST_TEST_MEM, GUEST_TEST_MEM, TEST_MEM_PAGES);
+	virt_map(vm, TEST_MEM_BASE, TEST_MEM_BASE, TEST_MEM_PAGES);
 
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
+		vm_vaddr_t gva0 = TEST_GUEST_ADDR(TEST_MEM_ALIAS_BASE, 0);
+		vm_vaddr_t gva1 = TEST_GUEST_ADDR(TEST_MEM_ALIAS_BASE, 1);
+
 		tdp_identity_map_default_memslots(vm);
-		tdp_map(vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, PAGE_SIZE);
-		tdp_map(vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, PAGE_SIZE);
+		tdp_map(vm, gva0, TEST_GPA(0), PAGE_SIZE);
+		tdp_map(vm, gva1, TEST_GPA(1), PAGE_SIZE);
+
+		*tdp_get_pte(vm, gva0) |= PTE_DIRTY_MASK(&vm->stage2_mmu);
+		*tdp_get_pte(vm, gva1) |= PTE_DIRTY_MASK(&vm->stage2_mmu);
+	} else {
+		*vm_get_pte(vm, TEST_GVA(0)) |= PTE_DIRTY_MASK(&vm->mmu);
+		*vm_get_pte(vm, TEST_GVA(1)) |= PTE_DIRTY_MASK(&vm->mmu);
 	}
 
 	bmap = bitmap_zalloc(TEST_MEM_PAGES);
-	host_test_mem = addr_gpa2hva(vm, GUEST_TEST_MEM);
 
 	while (!done) {
-		memset(host_test_mem, 0xaa, TEST_MEM_PAGES * PAGE_SIZE);
+		memset(TEST_HVA(vm, 0), 0xaa, TEST_MEM_PAGES * PAGE_SIZE);
+
 		vcpu_run(vcpu);
 		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
@@ -170,23 +272,7 @@ static void test_dirty_log(bool nested_tdp)
 			REPORT_GUEST_ASSERT(uc);
 			/* NOT REACHED */
 		case UCALL_SYNC:
-			/*
-			 * The nested guest wrote at offset 0x1000 in the memslot, but the
-			 * dirty bitmap must be filled in according to L1 GPA, not L2.
-			 */
-			kvm_vm_get_dirty_log(vm, TEST_MEM_SLOT_INDEX, bmap);
-			if (uc.args[1]) {
-				TEST_ASSERT(test_bit(0, bmap), "Page 0 incorrectly reported clean");
-				TEST_ASSERT(host_test_mem[0] == 1, "Page 0 not written by guest");
-			} else {
-				TEST_ASSERT(!test_bit(0, bmap), "Page 0 incorrectly reported dirty");
-				TEST_ASSERT(host_test_mem[0] == 0xaaaaaaaaaaaaaaaaULL, "Page 0 written by guest");
-			}
-
-			TEST_ASSERT(!test_bit(1, bmap), "Page 1 incorrectly reported dirty");
-			TEST_ASSERT(host_test_mem[PAGE_SIZE / 8] == 0xaaaaaaaaaaaaaaaaULL, "Page 1 written by guest");
-			TEST_ASSERT(!test_bit(2, bmap), "Page 2 incorrectly reported dirty");
-			TEST_ASSERT(host_test_mem[PAGE_SIZE*2 / 8] == 0xaaaaaaaaaaaaaaaaULL, "Page 2 written by guest");
+			test_handle_ucall_sync(vm, uc.args[1], bmap);
 			break;
 		case UCALL_DONE:
 			done = true;

base-commit: 3cd487701a911d0e317bf31e79fe07bba5fa9995
--
