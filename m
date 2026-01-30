Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348A337F738
	for <kvmarm@lists.linux.dev>; Fri, 30 Jan 2026 19:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769801324; cv=none; b=atlIRmysu7lO62cAfjwRWWIsXNl7PPR0seqg0/XWfst/l7GdGnwJ8yWwBhuLyNYPmxL2fhUnBrucp4l9XqYrZNbklXoE1H1AOvVsdRiY4s9/Wh580/iSNcnHyENSzYehqMpps4kObmZNGql3oQBz0bsavhPhegWZQ+q7BMfxxXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769801324; c=relaxed/simple;
	bh=xha2tKLV6loVZapX6DrV2TpHDlxU/QfYCAu+9gTx3UM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=K7fe9drcdJ2Ev2wRfXQAj8Rjb0DJ4Pok+xhVuv6+fwkOxD55aD6Mm3pC6EuzXXSLcFciR/9JBirzhGCTdxa0v5GqlYOin3ZyoX3BwBpDad1/K1Yl7fwi1yWfa5y/aA3PzK7O/USg3gEJYoZgVEuI1uZxzssXRwPzX7IxBgKdQ5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XyKIrkXL; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XyKIrkXL"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c613426e8dcso4216090a12.1
        for <kvmarm@lists.linux.dev>; Fri, 30 Jan 2026 11:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769801321; x=1770406121; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rjy71wms5szan9FXTuTPKKlYyd/zTVsqWF/S5ag+Qgc=;
        b=XyKIrkXLxhJqwU5Yg5EoyrOrYEaWrE4hs44cHZM2096ZiZ0Ws00oO/U+x+/VVvm7QZ
         m63OIyR+M9aKCWCwiizKc7QLrNvm8Z/kXWM4KSFcGOjMxs3vqzGq3Ya/SgZTlJTghoSo
         5Q9BR0CGKWTBOYyOkOykFIvVqmVkjLEfo7nmg4C+PmGxOe2WfEJ2zeHqC/bWnDdTq7xJ
         DcqQLTAPROzN5Yxk38arj2vG5GjnvNBnJEbTGWb2g5h+ASD+wlwZxsuCkBnrcHOaDKbl
         A8p278kXu5zlEhDipoXhA0n5mSzIDOgg7AWBqr0yAXMArSjZDCE94U0SflHgJRm/Etgh
         o9Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769801321; x=1770406121;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rjy71wms5szan9FXTuTPKKlYyd/zTVsqWF/S5ag+Qgc=;
        b=hWoFMFUplr7At2TwjYfNtm2XjkuIKtP+RncYOFZly/t7TJzzVm/DPuLdmbv76nvgZy
         o5TnzCaB5P1CKO6ulr2AmcbNtQ72Ulty6/3//vrvPdDtmoGpNbYvXi5R7MDQ8rvxZsVR
         /CUtxtnn8quWZry7Ol3Rh46RxJj7atZLPWl1+7rVX/WX8whQa5GjPU6he7mmHZJnp0Yj
         X7ibBz7S7nIHFx8w0iTqZhkbwKYphfYDBw97/r/0i1L/ZfdKuszT9fBZ5TJ7LdLq7CoW
         rqI4r5mGTIwsv/YAXC0tJZbIyM0s0XAyh0ID5UTZNSWiWkTPz7Kppi2advfsQkdgSaAP
         zAeA==
X-Forwarded-Encrypted: i=1; AJvYcCXtDsPWK6LKj5hhCWLaAVAvIwQID6+cZS4SmWdh7fgbvPDc8TFrhzsvwz32evrBWj6ACEj0ewk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwSd98TPsezHpmT6EYCe6ePWl2zB6nLo0aLGt+4S7xsj56IK1pV
	OJGQX20bJfM6VyGAyYC/ncNzDayjcnMkLcd/JZNd1R475MuINT2tX63qmImv3w+Im2rl45HiBgs
	GtVwUkjAGJZ9JaA==
X-Received: from pgct22.prod.google.com ([2002:a05:6a02:5296:b0:bd9:19be:503c])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:a11c:b0:38e:9d3b:470b with SMTP id adf61e73a8af0-392e01096dbmr3663945637.42.1769801321501;
 Fri, 30 Jan 2026 11:28:41 -0800 (PST)
Date: Fri, 30 Jan 2026 19:28:37 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260130192837.890688-1-jiaqiyan@google.com>
Subject: [PATCH v1] KVM: selftests: Improve sea_to_user test
From: Jiaqi Yan <jiaqiyan@google.com>
To: oupton@kernel.org
Cc: sebott@redhat.com, gshan@redhat.com, yuzenghui@huawei.com, maz@kernel.org, 
	rananta@google.com, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	pbonzini@redhat.com, shuah@kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"

Several improvments to the test for KVM_EXIT_ARM_SEA:

- Refactor run_vm to catch GUEST_FAIL, instead of causing confusing
  unhandled MMIO kvm exit.

- Sync far_invalid to guest.

- Exit test with KSFT_SKIP or KSFT_FAIL when should.

- Add comment about VM backing memory type.

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 .../testing/selftests/kvm/arm64/sea_to_user.c | 94 +++++++++++--------
 1 file changed, 53 insertions(+), 41 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/sea_to_user.c b/tools/testing/selftests/kvm/arm64/sea_to_user.c
index 573dd790aeb8e..4a3511fa1f940 100644
--- a/tools/testing/selftests/kvm/arm64/sea_to_user.c
+++ b/tools/testing/selftests/kvm/arm64/sea_to_user.c
@@ -12,6 +12,11 @@
  * including the notrigger feature. Otherwise the test will be skipped.
  * The under-test platform's APEI should be unable to claim SEA. Otherwise
  * the test will also be skipped.
+ *
+ * The VM backing memory is tied to HugeTLB 1G hugepage so far. Make sure
+ * there are more than 4 1G hugepage on the system. They can be allocated
+ * at runtime by:
+ *   echo 4 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
  */
 
 #include <signal.h>
@@ -98,11 +103,15 @@ static void write_einj_entry(const char *einj_path, uint64_t val)
 
 static void inject_uer(uint64_t paddr)
 {
-	if (access("/sys/firmware/acpi/tables/EINJ", R_OK) == -1)
-		ksft_test_result_skip("EINJ table no available in firmware");
+	if (access("/sys/firmware/acpi/tables/EINJ", R_OK) == -1) {
+		ksft_test_result_skip("EINJ table not available in firmware\n");
+		exit(KSFT_SKIP);
+	}
 
-	if (access(EINJ_ETYPE, R_OK | W_OK) == -1)
-		ksft_test_result_skip("EINJ module probably not loaded?");
+	if (access(EINJ_ETYPE, R_OK | W_OK) == -1) {
+		ksft_test_result_skip("EINJ module probably not loaded?\n");
+		exit(KSFT_SKIP);
+	}
 
 	write_einj_entry(EINJ_ETYPE, ERROR_TYPE_MEMORY_UER);
 	write_einj_entry(EINJ_FLAGS, MASK_MEMORY_UER);
@@ -123,12 +132,13 @@ static void sigbus_signal_handler(int sig, siginfo_t *si, void *v)
 	ksft_print_msg("SIGBUS (%d) received, dumping siginfo...\n", sig);
 	ksft_print_msg("si_signo=%d, si_errno=%d, si_code=%d, si_addr=%p\n",
 		       si->si_signo, si->si_errno, si->si_code, si->si_addr);
-	if (si->si_code == BUS_MCEERR_AR)
+	if (si->si_code == BUS_MCEERR_AR) {
 		ksft_test_result_skip("SEA is claimed by host APEI\n");
-	else
+		exit(KSFT_SKIP);
+	} else {
 		ksft_test_result_fail("Exit with signal unhandled\n");
-
-	exit(0);
+		exit(KSFT_FAIL);
+	}
 }
 
 static void setup_sigbus_handler(void)
@@ -158,7 +168,6 @@ static void expect_sea_handler(struct ex_regs *regs)
 {
 	u64 esr = read_sysreg(esr_el1);
 	u64 far = read_sysreg(far_el1);
-	bool expect_far_invalid = far_invalid;
 
 	GUEST_PRINTF("Handling Guest SEA\n");
 	GUEST_PRINTF("ESR_EL1=%#lx, FAR_EL1=%#lx\n", esr, far);
@@ -166,7 +175,7 @@ static void expect_sea_handler(struct ex_regs *regs)
 	GUEST_ASSERT_EQ(ESR_ELx_EC(esr), ESR_ELx_EC_DABT_CUR);
 	GUEST_ASSERT_EQ(esr & ESR_ELx_FSC_TYPE, ESR_ELx_FSC_EXTABT);
 
-	if (expect_far_invalid) {
+	if (far_invalid) {
 		GUEST_ASSERT_EQ(esr & ESR_ELx_FnV, ESR_ELx_FnV);
 		GUEST_PRINTF("Guest observed garbage value in FAR\n");
 	} else {
@@ -185,25 +194,19 @@ static void vcpu_inject_sea(struct kvm_vcpu *vcpu)
 	vcpu_events_set(vcpu, &events);
 }
 
-static void run_vm(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+static void validate_kvm_exit_arm_sea(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 {
-	struct ucall uc;
-	bool guest_done = false;
 	struct kvm_run *run = vcpu->run;
 	u64 esr;
 
-	/* Resume the vCPU after error injection to consume the error. */
-	vcpu_run(vcpu);
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_ARM_SEA);
 
-	ksft_print_msg("Dump kvm_run info about KVM_EXIT_%s\n",
-		       exit_reason_str(run->exit_reason));
+	ksft_print_msg("Dumping kvm_run as arm_sea:\n");
 	ksft_print_msg("kvm_run.arm_sea: esr=%#llx, flags=%#llx\n",
 		       run->arm_sea.esr, run->arm_sea.flags);
 	ksft_print_msg("kvm_run.arm_sea: gva=%#llx, gpa=%#llx\n",
 		       run->arm_sea.gva, run->arm_sea.gpa);
 
-	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_ARM_SEA);
-
 	esr = run->arm_sea.esr;
 	TEST_ASSERT_EQ(ESR_ELx_EC(esr), ESR_ELx_EC_DABT_LOW);
 	TEST_ASSERT_EQ(esr & ESR_ELx_FSC_TYPE, ESR_ELx_FSC_EXTABT);
@@ -211,39 +214,48 @@ static void run_vm(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 	TEST_ASSERT_EQ((esr & ESR_ELx_INST_SYNDROME), 0);
 	TEST_ASSERT_EQ(esr & ESR_ELx_VNCR, 0);
 
-	if (!(esr & ESR_ELx_FnV)) {
-		ksft_print_msg("Expect gva to match given FnV bit is 0\n");
+	far_invalid = esr & ESR_ELx_FnV;
+	sync_global_to_guest(vm, far_invalid);
+
+	if (!far_invalid) {
+		ksft_print_msg("Expect gva to match\n");
 		TEST_ASSERT_EQ(run->arm_sea.gva, EINJ_GVA);
 	}
 
 	if (run->arm_sea.flags & KVM_EXIT_ARM_SEA_FLAG_GPA_VALID) {
-		ksft_print_msg("Expect gpa to match given KVM_EXIT_ARM_SEA_FLAG_GPA_VALID is set\n");
+		ksft_print_msg("Expect gpa to match\n");
 		TEST_ASSERT_EQ(run->arm_sea.gpa, einj_gpa & PAGE_ADDR_MASK);
 	}
+}
 
-	far_invalid = esr & ESR_ELx_FnV;
-
-	/* Inject a SEA into guest and expect handled in SEA handler. */
-	vcpu_inject_sea(vcpu);
+static void run_vm(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+{
+	struct ucall uc;
+	bool guest_done = false;
 
 	/* Expect the guest to reach GUEST_DONE gracefully. */
 	do {
 		vcpu_run(vcpu);
-		switch (get_ucall(vcpu, &uc)) {
-		case UCALL_PRINTF:
-			ksft_print_msg("From guest: %s", uc.buffer);
-			break;
-		case UCALL_DONE:
-			ksft_print_msg("Guest done gracefully!\n");
-			guest_done = 1;
-			break;
-		case UCALL_ABORT:
-			ksft_print_msg("Guest aborted!\n");
-			guest_done = 1;
-			REPORT_GUEST_ASSERT(uc);
-			break;
-		default:
-			TEST_FAIL("Unexpected ucall: %lu\n", uc.cmd);
+		if (vcpu->run->exit_reason == KVM_EXIT_ARM_SEA) {
+			validate_kvm_exit_arm_sea(vm, vcpu);
+			vcpu_inject_sea(vcpu);
+		} else {
+			switch (get_ucall(vcpu, &uc)) {
+			case UCALL_PRINTF:
+				ksft_print_msg("From guest: %s", uc.buffer);
+				break;
+			case UCALL_DONE:
+				ksft_print_msg("Guest done gracefully!\n");
+				guest_done = 1;
+				break;
+			case UCALL_ABORT:
+				ksft_print_msg("Guest aborted!\n");
+				guest_done = 1;
+				REPORT_GUEST_ASSERT(uc);
+				break;
+			default:
+				TEST_FAIL("Unexpected ucall: %lu\n", uc.cmd);
+			}
 		}
 	} while (!guest_done);
 }
-- 
2.53.0.rc2.204.g2597b5adb4-goog

