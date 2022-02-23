Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 656E0C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 04:20:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E47F4C2FE;
	Tue, 22 Feb 2022 23:20:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W7cSmDbSr97H; Tue, 22 Feb 2022 23:20:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C10604C410;
	Tue, 22 Feb 2022 23:20:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 779C54C3F7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:20:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hM1drPZimzQJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 23:20:01 -0500 (EST)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C57CA4C3EE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:19:59 -0500 (EST)
Received: by mail-io1-f74.google.com with SMTP id
 v123-20020a6bc581000000b0063d8771a58aso13164741iof.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 20:19:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=i98hnG6qtGbABTs3j3QXd9dWCgzrVG+u5f8yLDrE9OQ=;
 b=YBAhhNZXsuZ52Ml9yB6SFT5gzAnvK703/uJsaiQO/3XBbULguXGz4eUcK7Iwx0jrB+
 BhCR6xI4LMSyobe3yqiRvNJFIlAkFrCpg25eRUJRMqTCPL1+3aGzT9jjZWQUf6QtrSOL
 MFdYsE76aqx8nEgsSPFfnv3ub9boa4S6JJawLfX2AVjqeWMsSN9VuLivLBxcHYzq/1Js
 uHiN538s7Ufr8y/64m9Vz14I/O8iWZiv7rHrIkqF9Ha9v98rkOhULZroUrj2qh0iRMTb
 kB8SszgWhRubTmwuM1iI5Dtxp5eUJOtuX5tgG7V2SRTfMD77l9vS6RS679+PayqZPUWZ
 VX7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=i98hnG6qtGbABTs3j3QXd9dWCgzrVG+u5f8yLDrE9OQ=;
 b=DI0fInwO78cWUE3utaAuCwrDeC0IIRL7PBAS5bTb38eXiMDPUEnd7c6uqP5+6FZSLV
 oWYex0cHV9cvsSPo0r+QVY2nR7Qpx1p8O8hEFbFZoaoRxTiwcbw5stVX27Hnk2m+MoEW
 PtrWj7mrt6OktcvEmDIFSgmDzaHLHh0kI7LVA+Rsozt48j1i+TEEVj+Y7K5eLN2DqsIh
 2SdcA8js0rNe3JEV0a2e4CeaPSsMbPiMMu75DI5+jA8Dp66qGBB3IR2f7eF0QCwGEQrg
 dvZWo7/2jGW33feLDAIV8AXyacaU0+iKMzsSJu3mFVh7TsVc93Gjejj6gNSDwiHsNXr0
 rGjg==
X-Gm-Message-State: AOAM532in94X5bx8gGWF9Wkpuzyt9nSPvhVMiXa4R+OYbODlphRILy19
 JOiLATW1wDsgdL/NJSUtTQDPg1Ct1IY7ZflaieOeQ+nQnfvquCpUzHgq7nTms7mjpyXotyFTkqz
 /2UudFPKgy/PDN8MXRHqumnvwR2mImanqH9WJ2qqY+AY2gQ7hbTHNZxIwf+tk/B3xyUPEQA==
X-Google-Smtp-Source: ABdhPJxZPc1WYaO4N3CymGo4vz22DvGFH7vPk5M8cHUCqUrPSPImWyzkemXzMuR+yAGmHzxYihfCCkrqH/0=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:25c2:b0:314:cb35:412
 with SMTP id
 u2-20020a05663825c200b00314cb350412mr12995818jat.216.1645589999299; Tue, 22
 Feb 2022 20:19:59 -0800 (PST)
Date: Wed, 23 Feb 2022 04:18:43 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-19-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 18/19] selftests: KVM: Refactor psci_test to make it
 amenable to new tests
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, Atish Patra <atishp@atishpatra.org>,
 Peter Shier <pshier@google.com>, kvm-riscv@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>
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

Split up the current test into several helpers that will be useful to
subsequent test cases added to the PSCI test suite.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 .../testing/selftests/kvm/aarch64/psci_test.c | 97 ++++++++++++-------
 1 file changed, 60 insertions(+), 37 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index fe1d5d343a2f..535130d5e97f 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -45,21 +45,6 @@ static uint64_t psci_affinity_info(uint64_t target_affinity,
 	return res.a0;
 }
 
-static void guest_main(uint64_t target_cpu)
-{
-	GUEST_ASSERT(!psci_cpu_on(target_cpu, CPU_ON_ENTRY_ADDR, CPU_ON_CONTEXT_ID));
-	uint64_t target_state;
-
-	do {
-		target_state = psci_affinity_info(target_cpu, 0);
-
-		GUEST_ASSERT((target_state == PSCI_0_2_AFFINITY_LEVEL_ON) ||
-			     (target_state == PSCI_0_2_AFFINITY_LEVEL_OFF));
-	} while (target_state != PSCI_0_2_AFFINITY_LEVEL_ON);
-
-	GUEST_DONE();
-}
-
 static void vcpu_power_off(struct kvm_vm *vm, uint32_t vcpuid)
 {
 	struct kvm_mp_state mp_state = {
@@ -69,12 +54,10 @@ static void vcpu_power_off(struct kvm_vm *vm, uint32_t vcpuid)
 	vcpu_set_mp_state(vm, vcpuid, &mp_state);
 }
 
-int main(void)
+static struct kvm_vm *setup_vm(void *guest_code)
 {
-	uint64_t target_mpidr, obs_pc, obs_x0;
 	struct kvm_vcpu_init init;
 	struct kvm_vm *vm;
-	struct ucall uc;
 
 	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
 	kvm_vm_elf_load(vm, program_invocation_name);
@@ -83,31 +66,28 @@ int main(void)
 	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
 	init.features[0] |= (1 << KVM_ARM_VCPU_PSCI_0_2);
 
-	aarch64_vcpu_add_default(vm, VCPU_ID_SOURCE, &init, guest_main);
-	aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_main);
+	aarch64_vcpu_add_default(vm, VCPU_ID_SOURCE, &init, guest_code);
+	aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_code);
 
-	/*
-	 * make sure the target is already off when executing the test.
-	 */
-	vcpu_power_off(vm, VCPU_ID_TARGET);
+	return vm;
+}
 
-	get_reg(vm, VCPU_ID_TARGET, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), &target_mpidr);
-	vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
-	vcpu_run(vm, VCPU_ID_SOURCE);
+static void enter_guest(struct kvm_vm *vm, uint32_t vcpuid)
+{
+	struct ucall uc;
 
-	switch (get_ucall(vm, VCPU_ID_SOURCE, &uc)) {
-	case UCALL_DONE:
-		break;
-	case UCALL_ABORT:
+	vcpu_run(vm, vcpuid);
+	if (get_ucall(vm, vcpuid, &uc) == UCALL_ABORT)
 		TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0], __FILE__,
 			  uc.args[1]);
-		break;
-	default:
-		TEST_FAIL("Unhandled ucall: %lu", uc.cmd);
-	}
+}
+
+static void assert_vcpu_reset(struct kvm_vm *vm, uint32_t vcpuid)
+{
+	uint64_t obs_pc, obs_x0;
 
-	get_reg(vm, VCPU_ID_TARGET, ARM64_CORE_REG(regs.pc), &obs_pc);
-	get_reg(vm, VCPU_ID_TARGET, ARM64_CORE_REG(regs.regs[0]), &obs_x0);
+	get_reg(vm, vcpuid, ARM64_CORE_REG(regs.pc), &obs_pc);
+	get_reg(vm, vcpuid, ARM64_CORE_REG(regs.regs[0]), &obs_x0);
 
 	TEST_ASSERT(obs_pc == CPU_ON_ENTRY_ADDR,
 		    "unexpected target cpu pc: %lx (expected: %lx)",
@@ -115,7 +95,50 @@ int main(void)
 	TEST_ASSERT(obs_x0 == CPU_ON_CONTEXT_ID,
 		    "unexpected target context id: %lx (expected: %lx)",
 		    obs_x0, CPU_ON_CONTEXT_ID);
+}
+
+static void guest_test_cpu_on(uint64_t target_cpu)
+{
+	uint64_t target_state;
+
+	GUEST_ASSERT(!psci_cpu_on(target_cpu, CPU_ON_ENTRY_ADDR, CPU_ON_CONTEXT_ID));
+
+	do {
+		target_state = psci_affinity_info(target_cpu, 0);
+
+		GUEST_ASSERT((target_state == PSCI_0_2_AFFINITY_LEVEL_ON) ||
+			     (target_state == PSCI_0_2_AFFINITY_LEVEL_OFF));
+	} while (target_state != PSCI_0_2_AFFINITY_LEVEL_ON);
+
+	GUEST_DONE();
+}
+
+static void host_test_cpu_on(void)
+{
+	uint64_t target_mpidr;
+	struct kvm_vm *vm;
+	struct ucall uc;
+
+	vm = setup_vm(guest_test_cpu_on);
+
+	/*
+	 * make sure the target is already off when executing the test.
+	 */
+	vcpu_power_off(vm, VCPU_ID_TARGET);
+
+	get_reg(vm, VCPU_ID_TARGET, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), &target_mpidr);
+	vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
+	enter_guest(vm, VCPU_ID_SOURCE);
+
+	if (get_ucall(vm, VCPU_ID_SOURCE, &uc) != UCALL_DONE)
+		TEST_FAIL("Unhandled ucall: %lu", uc.cmd);
 
+	assert_vcpu_reset(vm, VCPU_ID_TARGET);
 	kvm_vm_free(vm);
+}
+
+int main(void)
+{
+	host_test_cpu_on();
 	return 0;
 }
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
