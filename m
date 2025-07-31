Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB07A26980F
	for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 21:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753996814; cv=none; b=VzY1WUBh8oEUdnEvxAhTLb02UkH7kMAVOj2tR+fWrdpAxVuxRwgVb9ULVVdpWy5w37oaY86tUnbh4chpfy+PqHk8zV8tWSRQP4RmzdkeJExWpDSF8XJgBFBuASirH4noFyxSXwG87O9pVly6Bntad10Vz/hUc4M7ZmsxjwXhSko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753996814; c=relaxed/simple;
	bh=z88O2lrYkvcqZ1E563Jq76LF6hJrJnuWvQzFZiV3AzY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RYdXdjtKGSshe88mMCfc31E9rFgM+HgHTs3GZ6zytFHddO3Phrn4r421waJv4k5DA2lgZdMPTjc+g3r/twF49eKyzzP0+2a9SEj/6mSRSxVTzOx+GgFYBEFhVCj1ZyQ8t8ss6Mlvgwhrr1QuMS/UlnkEhM6+u0YZE1odfT7TO6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4OzvHHCD; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4OzvHHCD"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31ea430d543so147967a91.3
        for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 14:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753996812; x=1754601612; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S7whMSj4GW59YuO3bK58f0y4iIovKl3vCWboamrKQYI=;
        b=4OzvHHCDHCY4IjJZXQ94WLC+YjPKDSB+OvLwtzVYb+6Bo5gfsCL4gh/YWDUsoUmQdj
         0GPvqXu+TeAXqZ+RrwEH06lfzhtkpwFPEnuJ2Db21hVk1L134BbrQbj3Lk2mTqsyiS50
         jU43TJ+P1kGS+tnAJFhxfOlxv44ZO8JkPq+2wDQe3b/Yh/6W0sB56PRNy3v/OGt90Mc/
         9ewNO2RLF51MZ8ueOJL2G6437ktyKLPPMFud1XQlpr8A/TNZ+O7ebKwvDdo87zFhMYmv
         dzBHUHxdHoQWDR31MN6UtWUaznoXA8TuWaM3j9Avgex3xtBJBQx4FhNj0234YXzylOdF
         k9dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753996812; x=1754601612;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S7whMSj4GW59YuO3bK58f0y4iIovKl3vCWboamrKQYI=;
        b=Qco/0qQYFQkWoPWFCuGJpRCZYMkMRgcyhLKhhUVyI2mgC27JpFKgEST2C4COgWLAkj
         UxP94704PQ0e6F5HyjMEB+dJkHEWVlkKQpy442qNlaXy8jCW2kB3lVpoVtXE0Ip50eA6
         WsGYsmCcIiG4ygt1wplWCh+93+eXnxOO2DrdZbWhIyAe+2/aJSmfb5QGxNSgpWwpVibR
         68u7pv9l/CnQyEN95rXaalJjSlIYQUUbFmYtyqIKsQmFDa2/kKTRxOzyZQYL8FJRuaXa
         5TD7SjijCKmLvJWXjek8tyuTl8xklLUCCOp1+T5AFk0ZwJLzYL9kzYtU1LvwuTQVqmr+
         dMFA==
X-Forwarded-Encrypted: i=1; AJvYcCVHYGFxCLbI0I19uVLYx6h96npQWZRl81kw3oCRQ3eZ6kOIGmzUKcplgrSIgutX1+eDt/h29wA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzg+4lagSBga+h7LGasHJiU1YE/6uWU69pqqAgvnw83XgCkMobt
	AW/2uwRQx8aQhHXkTTMzcc5RM8+rxYWShLN3O21ZqbDRYl/BUCxUyc79Sg3NdjquHmbbvPSIFmS
	e189DnySKXrgTAA==
X-Google-Smtp-Source: AGHT+IG3d5WxcS5Lhh7Yi0TSfL5o13oztWxshjglDCP/OQyqEPXNyDBcj9eLVkgSsHcYZ16+/AhhWRYIXQGu9A==
X-Received: from pjbsr13.prod.google.com ([2002:a17:90b:4e8d:b0:311:d79d:e432])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:6c4:b0:31f:44a:229c with SMTP id 98e67ed59e1d1-31f5dde6ae1mr13618876a91.12.1753996812385;
 Thu, 31 Jul 2025 14:20:12 -0700 (PDT)
Date: Thu, 31 Jul 2025 21:20:03 +0000
In-Reply-To: <20250731212004.1437336-1-jiaqiyan@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250731212004.1437336-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250731212004.1437336-4-jiaqiyan@google.com>
Subject: [PATCH v1 3/4] KVM: selftests: Test injecting external abort with ISS
From: Jiaqi Yan <jiaqiyan@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	shuah@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	rananta@google.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"

Test userspace can use KVM_SET_VCPU_EVENTS to inject an external
instruction or data abort with customized ISS if provided.

The test injects fake external aborts without real instruction or
data abort happening to VCPU, and only certain ESR_EL1 bits are
expected and asserted.

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 tools/arch/arm64/include/uapi/asm/kvm.h       |   7 +-
 .../selftests/kvm/arm64/external_aborts.c     | 191 +++++++++++++++---
 .../testing/selftests/kvm/arm64/inject_iabt.c |  98 +++++++++
 3 files changed, 264 insertions(+), 32 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/arm64/inject_iabt.c

diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/include/uapi/asm/kvm.h
index ed5f3892674c7..406d6e67df822 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -184,11 +184,14 @@ struct kvm_vcpu_events {
 		__u8 serror_pending;
 		__u8 serror_has_esr;
 		__u8 ext_dabt_pending;
+		__u8 ext_iabt_pending;
+		__u8 ext_abt_has_esr;
 		/* Align it to 8 bytes */
-		__u8 pad[5];
+		__u8 pad[3];
 		__u64 serror_esr;
+		__u64 ext_abt_esr;
 	} exception;
-	__u32 reserved[12];
+	__u32 reserved[10];
 };
 
 struct kvm_arm_copy_mte_tags {
diff --git a/tools/testing/selftests/kvm/arm64/external_aborts.c b/tools/testing/selftests/kvm/arm64/external_aborts.c
index 062bf84cced13..a6396ff4f84da 100644
--- a/tools/testing/selftests/kvm/arm64/external_aborts.c
+++ b/tools/testing/selftests/kvm/arm64/external_aborts.c
@@ -9,10 +9,14 @@
 
 #define MMIO_ADDR		0x8000000ULL
 #define EXPECTED_SERROR_ISS	(ESR_ELx_ISV | 0x1d1ed)
+#define FAKE_DABT_ISS		(ESR_ELx_ISV | ESR_ELx_SAS | ESR_ELx_SF | \
+				 ESR_ELx_AR | ESR_ELx_CM | ESR_ELx_FnV | \
+				 ESR_ELx_EA)
+#define FAKE_IABT_ISS		(ESR_ELx_ISV | ESR_ELx_FnV | ESR_ELx_EA)
 
 static u64 expected_abort_pc;
 
-static void expect_sea_handler(struct ex_regs *regs)
+static void expect_dabt_handler(struct ex_regs *regs)
 {
 	u64 esr = read_sysreg(esr_el1);
 
@@ -23,19 +27,60 @@ static void expect_sea_handler(struct ex_regs *regs)
 	GUEST_DONE();
 }
 
+static void expect_dabt_esr_handler(struct ex_regs *regs)
+{
+	u64 esr = read_sysreg(esr_el1);
+
+	GUEST_PRINTF("Handling guest instruction abort\n");
+	GUEST_PRINTF("  ESR_EL1=%#lx\n", esr);
+
+	GUEST_ASSERT_EQ(ESR_ELx_EC(esr), ESR_ELx_EC_DABT_CUR);
+	GUEST_ASSERT_EQ(esr & ESR_ELx_FSC_TYPE, ESR_ELx_FSC_EXTABT);
+	GUEST_ASSERT_EQ(esr & FAKE_DABT_ISS, FAKE_DABT_ISS);
+
+	GUEST_DONE();
+}
+
+static void expect_iabt_esr_handler(struct ex_regs *regs)
+{
+	u64 esr = read_sysreg(esr_el1);
+
+	GUEST_PRINTF("Handling guest instruction abort\n");
+	GUEST_PRINTF("  ESR_EL1=%#lx\n", esr);
+
+	GUEST_ASSERT_EQ(ESR_ELx_EC(esr), ESR_ELx_EC_IABT_CUR);
+	GUEST_ASSERT_EQ(esr & ESR_ELx_FSC_TYPE, ESR_ELx_FSC_EXTABT);
+	GUEST_ASSERT_EQ(esr & FAKE_IABT_ISS, FAKE_IABT_ISS);
+
+	GUEST_DONE();
+}
+
 static void unexpected_dabt_handler(struct ex_regs *regs)
 {
 	GUEST_FAIL("Unexpected data abort at PC: %lx\n", regs->pc);
 }
 
-static struct kvm_vm *vm_create_with_dabt_handler(struct kvm_vcpu **vcpu, void *guest_code,
-						  handler_fn dabt_handler)
+static void unexpected_iabt_handler(struct ex_regs *regs)
+{
+	GUEST_FAIL("Unexpected instruction abort at PC: %lx\n", regs->pc);
+}
+
+static struct kvm_vm *vm_create_with_extabt_handler(struct kvm_vcpu **vcpu,
+						    void *guest_code,
+						    handler_fn dabt_handler,
+						    handler_fn iabt_handler)
 {
 	struct kvm_vm *vm = vm_create_with_one_vcpu(vcpu, guest_code);
 
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(*vcpu);
-	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT, ESR_ELx_EC_DABT_CUR, dabt_handler);
+
+	if (dabt_handler)
+		vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
+					ESR_ELx_EC_DABT_CUR, dabt_handler);
+	if (iabt_handler)
+		vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
+					ESR_ELx_EC_IABT_CUR, iabt_handler);
 
 	virt_map(vm, MMIO_ADDR, MMIO_ADDR, 1);
 
@@ -50,6 +95,26 @@ static void vcpu_inject_sea(struct kvm_vcpu *vcpu)
 	vcpu_events_set(vcpu, &events);
 }
 
+static void vcpu_inject_dabt_esr(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_events events = {};
+
+	events.exception.ext_dabt_pending = true;
+	events.exception.ext_abt_has_esr = true;
+	events.exception.ext_abt_esr = FAKE_DABT_ISS;
+	vcpu_events_set(vcpu, &events);
+}
+
+static void vcpu_inject_iabt_esr(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_events events = {};
+
+	events.exception.ext_iabt_pending = true;
+	events.exception.ext_abt_has_esr = true;
+	events.exception.ext_abt_esr = FAKE_IABT_ISS;
+	vcpu_events_set(vcpu, &events);
+}
+
 static bool vcpu_has_ras(struct kvm_vcpu *vcpu)
 {
 	u64 pfr0 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1));
@@ -79,17 +144,24 @@ static void __vcpu_run_expect(struct kvm_vcpu *vcpu, unsigned int cmd)
 {
 	struct ucall uc;
 
-	vcpu_run(vcpu);
-	switch (get_ucall(vcpu, &uc)) {
-	case UCALL_ABORT:
-		REPORT_GUEST_ASSERT(uc);
-		break;
-	default:
-		if (uc.cmd == cmd)
-			return;
-
-		TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
-	}
+	do {
+		vcpu_run(vcpu);
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		case UCALL_PRINTF:
+			ksft_print_msg("From guest: %s", uc.buffer);
+			break;
+		default:
+			if (uc.cmd == cmd) {
+				ksft_print_msg("Expect ucall: %lu\n", uc.cmd);
+				return;
+			}
+
+			TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
+		}
+	} while (true);
 }
 
 static void vcpu_run_expect_done(struct kvm_vcpu *vcpu)
@@ -122,8 +194,10 @@ static noinline void test_mmio_abort_guest(void)
 static void test_mmio_abort(void)
 {
 	struct kvm_vcpu *vcpu;
-	struct kvm_vm *vm = vm_create_with_dabt_handler(&vcpu, test_mmio_abort_guest,
-							expect_sea_handler);
+	struct kvm_vm *vm = vm_create_with_extabt_handler(&vcpu,
+							  test_mmio_abort_guest,
+							  expect_dabt_handler,
+							  unexpected_iabt_handler);
 	struct kvm_run *run = vcpu->run;
 
 	vcpu_run(vcpu);
@@ -157,8 +231,10 @@ static void test_mmio_nisv_guest(void)
 static void test_mmio_nisv(void)
 {
 	struct kvm_vcpu *vcpu;
-	struct kvm_vm *vm = vm_create_with_dabt_handler(&vcpu, test_mmio_nisv_guest,
-							unexpected_dabt_handler);
+	struct kvm_vm *vm = vm_create_with_extabt_handler(&vcpu,
+							  test_mmio_nisv_guest,
+							  unexpected_dabt_handler,
+							  unexpected_iabt_handler);
 
 	TEST_ASSERT(_vcpu_run(vcpu), "Expected nonzero return code from KVM_RUN");
 	TEST_ASSERT_EQ(errno, ENOSYS);
@@ -173,8 +249,10 @@ static void test_mmio_nisv(void)
 static void test_mmio_nisv_abort(void)
 {
 	struct kvm_vcpu *vcpu;
-	struct kvm_vm *vm = vm_create_with_dabt_handler(&vcpu, test_mmio_nisv_guest,
-							expect_sea_handler);
+	struct kvm_vm *vm = vm_create_with_extabt_handler(&vcpu,
+							  test_mmio_nisv_guest,
+							  expect_dabt_handler,
+							  unexpected_iabt_handler);
 	struct kvm_run *run = vcpu->run;
 
 	vm_enable_cap(vm, KVM_CAP_ARM_NISV_TO_USER, 1);
@@ -205,8 +283,10 @@ static void test_serror_masked_guest(void)
 static void test_serror_masked(void)
 {
 	struct kvm_vcpu *vcpu;
-	struct kvm_vm *vm = vm_create_with_dabt_handler(&vcpu, test_serror_masked_guest,
-							unexpected_dabt_handler);
+	struct kvm_vm *vm = vm_create_with_extabt_handler(&vcpu,
+							  test_serror_masked_guest,
+							  unexpected_dabt_handler,
+							  unexpected_iabt_handler);
 
 	vm_install_exception_handler(vm, VECTOR_ERROR_CURRENT, unexpected_serror_handler);
 
@@ -240,8 +320,10 @@ static void test_serror_guest(void)
 static void test_serror(void)
 {
 	struct kvm_vcpu *vcpu;
-	struct kvm_vm *vm = vm_create_with_dabt_handler(&vcpu, test_serror_guest,
-							unexpected_dabt_handler);
+	struct kvm_vm *vm = vm_create_with_extabt_handler(&vcpu,
+							  test_serror_guest,
+							  unexpected_dabt_handler,
+							  unexpected_iabt_handler);
 
 	vm_install_exception_handler(vm, VECTOR_ERROR_CURRENT, expect_serror_handler);
 
@@ -264,8 +346,10 @@ static void test_serror_emulated_guest(void)
 static void test_serror_emulated(void)
 {
 	struct kvm_vcpu *vcpu;
-	struct kvm_vm *vm = vm_create_with_dabt_handler(&vcpu, test_serror_emulated_guest,
-							unexpected_dabt_handler);
+	struct kvm_vm *vm = vm_create_with_extabt_handler(&vcpu,
+							  test_serror_emulated_guest,
+							  unexpected_dabt_handler,
+							  unexpected_iabt_handler);
 
 	vm_install_exception_handler(vm, VECTOR_ERROR_CURRENT, expect_serror_handler);
 
@@ -290,8 +374,10 @@ static void test_mmio_ease_guest(void)
 static void test_mmio_ease(void)
 {
 	struct kvm_vcpu *vcpu;
-	struct kvm_vm *vm = vm_create_with_dabt_handler(&vcpu, test_mmio_ease_guest,
-							unexpected_dabt_handler);
+	struct kvm_vm *vm = vm_create_with_extabt_handler(&vcpu,
+							  test_mmio_ease_guest,
+							  unexpected_dabt_handler,
+							  unexpected_iabt_handler);
 	struct kvm_run *run = vcpu->run;
 	u64 pfr1;
 
@@ -305,7 +391,7 @@ static void test_mmio_ease(void)
 	 * SCTLR2_ELx.EASE changes the exception vector to the SError vector but
 	 * doesn't further modify the exception context (e.g. ESR_ELx, FAR_ELx).
 	 */
-	vm_install_exception_handler(vm, VECTOR_ERROR_CURRENT, expect_sea_handler);
+	vm_install_exception_handler(vm, VECTOR_ERROR_CURRENT, expect_dabt_handler);
 
 	vcpu_run(vcpu);
 	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_MMIO);
@@ -318,6 +404,49 @@ static void test_mmio_ease(void)
 	kvm_vm_free(vm);
 }
 
+static void test_ext_abt_guest(void)
+{
+	GUEST_FAIL("Guest should only run (I|D)ABT handler");
+}
+
+static void test_inject_data_abort(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm = vm_create_with_extabt_handler(&vcpu,
+							  test_ext_abt_guest,
+							  expect_dabt_esr_handler,
+							  unexpected_iabt_handler);
+	vcpu_inject_dabt_esr(vcpu);
+	vcpu_run_expect_done(vcpu);
+	kvm_vm_free(vm);
+}
+
+static void vcpu_inject_invalid_abt(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_events events = {};
+	int r;
+
+	events.exception.ext_iabt_pending = true;
+	events.exception.ext_dabt_pending = true;
+
+	r = __vcpu_ioctl(vcpu, KVM_SET_VCPU_EVENTS, &events);
+	TEST_ASSERT(r && errno == EINVAL,
+		    KVM_IOCTL_ERROR(KVM_SET_VCPU_EVENTS, r));
+}
+
+static void test_inject_instruction_abort(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm = vm_create_with_extabt_handler(&vcpu,
+							  test_ext_abt_guest,
+							  unexpected_dabt_handler,
+							  expect_iabt_esr_handler);
+	vcpu_inject_invalid_abt(vcpu);
+	vcpu_inject_iabt_esr(vcpu);
+	vcpu_run_expect_done(vcpu);
+	kvm_vm_free(vm);
+}
+
 int main(void)
 {
 	test_mmio_abort();
@@ -327,4 +456,6 @@ int main(void)
 	test_serror_masked();
 	test_serror_emulated();
 	test_mmio_ease();
+	test_inject_instruction_abort();
+	test_inject_data_abort();
 }
diff --git a/tools/testing/selftests/kvm/arm64/inject_iabt.c b/tools/testing/selftests/kvm/arm64/inject_iabt.c
new file mode 100644
index 0000000000000..0c7999e5ba5b3
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/inject_iabt.c
@@ -0,0 +1,98 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * inject_iabt.c - Tests for injecting instruction aborts into guest.
+ */
+
+#include "processor.h"
+#include "test_util.h"
+
+static void expect_iabt_handler(struct ex_regs *regs)
+{
+	u64 esr = read_sysreg(esr_el1);
+
+	GUEST_PRINTF("Handling Guest SEA\n");
+	GUEST_PRINTF("  ESR_EL1=%#lx\n", esr);
+
+	GUEST_ASSERT_EQ(ESR_ELx_EC(esr), ESR_ELx_EC_IABT_CUR);
+	GUEST_ASSERT_EQ(esr & ESR_ELx_FSC_TYPE, ESR_ELx_FSC_EXTABT);
+
+	GUEST_DONE();
+}
+
+static void guest_code(void)
+{
+	GUEST_FAIL("Guest should only run SEA handler");
+}
+
+static void vcpu_run_expect_done(struct kvm_vcpu *vcpu)
+{
+	struct ucall uc;
+	bool guest_done = false;
+
+	do {
+		vcpu_run(vcpu);
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		case UCALL_PRINTF:
+			ksft_print_msg("From guest: %s", uc.buffer);
+			break;
+		case UCALL_DONE:
+			ksft_print_msg("Guest done gracefully!\n");
+			guest_done = true;
+			break;
+		default:
+			TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
+		}
+	} while (!guest_done);
+}
+
+static void vcpu_inject_ext_iabt(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_events events = {};
+
+	events.exception.ext_iabt_pending = true;
+	vcpu_events_set(vcpu, &events);
+}
+
+static void vcpu_inject_invalid_abt(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_events events = {};
+	int r;
+
+	events.exception.ext_iabt_pending = true;
+	events.exception.ext_dabt_pending = true;
+
+	ksft_print_msg("Injecting invalid external abort events\n");
+	r = __vcpu_ioctl(vcpu, KVM_SET_VCPU_EVENTS, &events);
+	TEST_ASSERT(r && errno == EINVAL,
+		    KVM_IOCTL_ERROR(KVM_SET_VCPU_EVENTS, r));
+}
+
+static void test_inject_iabt(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vcpu);
+
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
+				ESR_ELx_EC_IABT_CUR, expect_iabt_handler);
+
+	vcpu_inject_invalid_abt(vcpu);
+
+	vcpu_inject_ext_iabt(vcpu);
+	vcpu_run_expect_done(vcpu);
+
+	kvm_vm_free(vm);
+}
+
+int main(void)
+{
+	test_inject_iabt();
+	return 0;
+}
-- 
2.50.1.565.gc32cd1483b-goog

