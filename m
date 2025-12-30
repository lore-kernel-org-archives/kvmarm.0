Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4D92E093C
	for <kvmarm@lists.linux.dev>; Tue, 30 Dec 2025 23:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767135750; cv=none; b=s6N6jgvJYA18KuZKSlWZn+o7pZM6sppVkyOQL5nypR3GWTF/w1U2MRZlQPY+UwzPsEv+QRctUm/1C/uclMOCcLbs5hUvDts6FxZQ7/NPH2Zw6Ljm+duTnutaBZYGQUC/xkt6ULTZvAbazHQ3LbPCscuGFRkuDNWwvDCX5jm7WQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767135750; c=relaxed/simple;
	bh=+GnfSi4hdCU01gr9ULMJZhrny8ByifWOa5mQbt/sJCk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JWxkhbEpPzeWgBzL0xJKcHYir6SNNpoDAljKb4PmTLZRdAXI1riskI9cwxb0Dn0SUeG5fdz4f/x9sIJxA5UjrLgGA/MQOTOwLehfR78tiQbvzyUBDWyb1gNBEA70IeW9UViQoUiUyUDx6l3sLOLEgd0rcRCO8FZoj6rxgpnFIBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gI4GuBQk; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gI4GuBQk"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34eb6589ed2so9158205a91.2
        for <kvmarm@lists.linux.dev>; Tue, 30 Dec 2025 15:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767135745; x=1767740545; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=l02CRqI+Ghgr8JnMhLywloG9mLg+BlVpb36VX9/E5wI=;
        b=gI4GuBQk8sAnuYpgXlHkzQFDmwYOhHvTMgsg+nxeKNK80leTaFghlM7w/B1fhSbaZf
         dpwlMn16zEqMrDJas5VGNqLW9aDK3algI8HgIiAeBbB92x5zQgFRzzu5Fz5WpqkDqSw0
         pz0MiawtxtRCgVFsEjp+szWLN3A/klPGIso02uDFqN/66ZLYt6t75IbTzceWnBpesOhG
         GBGOII+a/Gesyjmg2D7XES8PGsrJPCw/M598THyqzukfVvg4l3r05tCvr0fWF1vlUlSa
         /Cl9QzRDmnS3CISb55XFTpnyXDVUmzt4PGRbmPLkQDa0nngSaOZ9WzF4pH9zm5kV5qWH
         ZZEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767135745; x=1767740545;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l02CRqI+Ghgr8JnMhLywloG9mLg+BlVpb36VX9/E5wI=;
        b=FbhCBbBkU2aLa5IAcn2qFWQgHrdqeGrRCV13yu9LEp+kDN11I5SMU9uKLA4AZ3O3Ci
         H6HNFZvyOHL5TWqxJgOe5QA9QIYz31LVK9w3Hshi/OKvSAX1l5uw5XvhhuwadluUHw+9
         92MuitFcne7w6mwNdRbwkwiSOSHOhXat5CYRziqSSREtHw5vy95IeKem4I/l2dPm3n0+
         KMgNitQSEEO5uwhyxIOe4GNSdrfUCA8bJY+K4eV+Ul1M4heR3f71wEdrG+TSl76/Gdbt
         4Hx40RMHLgywtsVDnKwo+wDgfuGSUjaxjdJ7lwE0GWYodivaWydyR4X8WFYdWgqQA36E
         YJug==
X-Forwarded-Encrypted: i=1; AJvYcCXNzTCX6TkriRLLXxN7hUxUDGdcltoT0ToTU/rV1Y4dWjZSMpQTRAMSRWRLvvyWLX6fIl6oHq8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzd4RupEGByE6BCQEqF8Nx+nPhQHzZxwBtSMBYCkZXGonwQqA3B
	O9PMc+g+2AtI71PKEpyHUe0Hk+QAnhBqnTVx4Lk0FaWn2Kwnz3Eku+gtgiLtqJk0o3yakVvbp1/
	cXNkEFw==
X-Google-Smtp-Source: AGHT+IGdzi4L+tULZgNB2XZI1GCuJkpL9VP6/Muf2M4d65NarSlafnhFOOOyBjKAOuvQIqtL04yY0e8Tvtc=
X-Received: from pjbsw11.prod.google.com ([2002:a17:90b:2c8b:b0:34a:bf4e:cb5c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3c90:b0:35f:26b2:2f94
 with SMTP id adf61e73a8af0-376a9acefcdmr33777508637.46.1767135745424; Tue, 30
 Dec 2025 15:02:25 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 15:01:47 -0800
In-Reply-To: <20251230230150.4150236-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230230150.4150236-19-seanjc@google.com>
Subject: [PATCH v4 18/21] KVM: selftests: Extend vmx_dirty_log_test to cover SVM
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

From: Yosry Ahmed <yosry.ahmed@linux.dev>

Generalize the code in vmx_dirty_log_test.c by adding SVM-specific L1
code, doing some renaming (e.g. EPT -> TDP), and having setup code for
both SVM and VMX in test_dirty_log().

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |  2 +-
 ...rty_log_test.c => nested_dirty_log_test.c} | 73 ++++++++++++++-----
 2 files changed, 54 insertions(+), 21 deletions(-)
 rename tools/testing/selftests/kvm/x86/{vmx_dirty_log_test.c => nested_dirty_log_test.c} (71%)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index ba5c2b643efa..8f14213ddef1 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -89,6 +89,7 @@ TEST_GEN_PROGS_x86 += x86/kvm_buslock_test
 TEST_GEN_PROGS_x86 += x86/monitor_mwait_test
 TEST_GEN_PROGS_x86 += x86/msrs_test
 TEST_GEN_PROGS_x86 += x86/nested_close_kvm_test
+TEST_GEN_PROGS_x86 += x86/nested_dirty_log_test
 TEST_GEN_PROGS_x86 += x86/nested_emulation_test
 TEST_GEN_PROGS_x86 += x86/nested_exceptions_test
 TEST_GEN_PROGS_x86 += x86/nested_invalid_cr3_test
@@ -115,7 +116,6 @@ TEST_GEN_PROGS_x86 += x86/ucna_injection_test
 TEST_GEN_PROGS_x86 += x86/userspace_io_test
 TEST_GEN_PROGS_x86 += x86/userspace_msr_exit_test
 TEST_GEN_PROGS_x86 += x86/vmx_apic_access_test
-TEST_GEN_PROGS_x86 += x86/vmx_dirty_log_test
 TEST_GEN_PROGS_x86 += x86/vmx_exception_with_invalid_guest_state
 TEST_GEN_PROGS_x86 += x86/vmx_msrs_test
 TEST_GEN_PROGS_x86 += x86/vmx_invalid_nested_guest_state
diff --git a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86/nested_dirty_log_test.c
similarity index 71%
rename from tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
rename to tools/testing/selftests/kvm/x86/nested_dirty_log_test.c
index 032ab8bf60a4..89d2e86a0db9 100644
--- a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_dirty_log_test.c
@@ -12,6 +12,7 @@
 #include "test_util.h"
 #include "kvm_util.h"
 #include "processor.h"
+#include "svm_util.h"
 #include "vmx.h"
 
 /* The memory slot index to track dirty pages */
@@ -25,6 +26,8 @@
 #define NESTED_TEST_MEM1		0xc0001000
 #define NESTED_TEST_MEM2		0xc0002000
 
+#define L2_GUEST_STACK_SIZE 64
+
 static void l2_guest_code(u64 *a, u64 *b)
 {
 	READ_ONCE(*a);
@@ -42,20 +45,19 @@ static void l2_guest_code(u64 *a, u64 *b)
 	vmcall();
 }
 
-static void l2_guest_code_ept_enabled(void)
+static void l2_guest_code_tdp_enabled(void)
 {
 	l2_guest_code((u64 *)NESTED_TEST_MEM1, (u64 *)NESTED_TEST_MEM2);
 }
 
-static void l2_guest_code_ept_disabled(void)
+static void l2_guest_code_tdp_disabled(void)
 {
-	/* Access the same L1 GPAs as l2_guest_code_ept_enabled() */
+	/* Access the same L1 GPAs as l2_guest_code_tdp_enabled() */
 	l2_guest_code((u64 *)GUEST_TEST_MEM, (u64 *)GUEST_TEST_MEM);
 }
 
-void l1_guest_code(struct vmx_pages *vmx)
+void l1_vmx_code(struct vmx_pages *vmx)
 {
-#define L2_GUEST_STACK_SIZE 64
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
 	void *l2_rip;
 
@@ -64,22 +66,49 @@ void l1_guest_code(struct vmx_pages *vmx)
 	GUEST_ASSERT(load_vmcs(vmx));
 
 	if (vmx->eptp_gpa)
-		l2_rip = l2_guest_code_ept_enabled;
+		l2_rip = l2_guest_code_tdp_enabled;
 	else
-		l2_rip = l2_guest_code_ept_disabled;
+		l2_rip = l2_guest_code_tdp_disabled;
 
 	prepare_vmcs(vmx, l2_rip, &l2_guest_stack[L2_GUEST_STACK_SIZE]);
 
 	GUEST_SYNC(false);
 	GUEST_ASSERT(!vmlaunch());
 	GUEST_SYNC(false);
-	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
+	GUEST_ASSERT_EQ(vmreadz(VM_EXIT_REASON), EXIT_REASON_VMCALL);
 	GUEST_DONE();
 }
 
-static void test_vmx_dirty_log(bool enable_ept)
+static void l1_svm_code(struct svm_test_data *svm)
 {
-	vm_vaddr_t vmx_pages_gva = 0;
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	void *l2_rip;
+
+	if (svm->ncr3_gpa)
+		l2_rip = l2_guest_code_tdp_enabled;
+	else
+		l2_rip = l2_guest_code_tdp_disabled;
+
+	generic_svm_setup(svm, l2_rip, &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	GUEST_SYNC(false);
+	run_guest(svm->vmcb, svm->vmcb_gpa);
+	GUEST_SYNC(false);
+	GUEST_ASSERT_EQ(svm->vmcb->control.exit_code, SVM_EXIT_VMMCALL);
+	GUEST_DONE();
+}
+
+static void l1_guest_code(void *data)
+{
+	if (this_cpu_has(X86_FEATURE_VMX))
+		l1_vmx_code(data);
+	else
+		l1_svm_code(data);
+}
+
+static void test_dirty_log(bool nested_tdp)
+{
+	vm_vaddr_t nested_gva = 0;
 	unsigned long *bmap;
 	uint64_t *host_test_mem;
 
@@ -88,15 +117,19 @@ static void test_vmx_dirty_log(bool enable_ept)
 	struct ucall uc;
 	bool done = false;
 
-	pr_info("Nested EPT: %s\n", enable_ept ? "enabled" : "disabled");
+	pr_info("Nested TDP: %s\n", nested_tdp ? "enabled" : "disabled");
 
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
-	if (enable_ept)
+	if (nested_tdp)
 		vm_enable_tdp(vm);
 
-	vcpu_alloc_vmx(vm, &vmx_pages_gva);
-	vcpu_args_set(vcpu, 1, vmx_pages_gva);
+	if (kvm_cpu_has(X86_FEATURE_VMX))
+		vcpu_alloc_vmx(vm, &nested_gva);
+	else
+		vcpu_alloc_svm(vm, &nested_gva);
+
+	vcpu_args_set(vcpu, 1, nested_gva);
 
 	/* Add an extra memory slot for testing dirty logging */
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
@@ -115,10 +148,10 @@ static void test_vmx_dirty_log(bool enable_ept)
 	 * ... pages in the L2 GPA range [0xc0001000, 0xc0003000) will map to
 	 * 0xc0000000.
 	 *
-	 * When EPT is disabled, the L2 guest code will still access the same L1
-	 * GPAs as the EPT enabled case.
+	 * When TDP is disabled, the L2 guest code will still access the same L1
+	 * GPAs as the TDP enabled case.
 	 */
-	if (enable_ept) {
+	if (nested_tdp) {
 		tdp_identity_map_default_memslots(vm);
 		tdp_map(vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, PAGE_SIZE);
 		tdp_map(vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, PAGE_SIZE);
@@ -166,12 +199,12 @@ static void test_vmx_dirty_log(bool enable_ept)
 
 int main(int argc, char *argv[])
 {
-	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX) || kvm_cpu_has(X86_FEATURE_SVM));
 
-	test_vmx_dirty_log(/*enable_ept=*/false);
+	test_dirty_log(/*nested_tdp=*/false);
 
 	if (kvm_cpu_has_tdp())
-		test_vmx_dirty_log(/*enable_ept=*/true);
+		test_dirty_log(/*nested_tdp=*/true);
 
 	return 0;
 }
-- 
2.52.0.351.gbe84eed79e-goog

