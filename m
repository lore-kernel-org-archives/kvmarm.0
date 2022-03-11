Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 538D2C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 17:41:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EC1849F07;
	Fri, 11 Mar 2022 12:41:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 97ImgSn4nIYE; Fri, 11 Mar 2022 12:41:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E02E49F16;
	Fri, 11 Mar 2022 12:41:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BAAF40C10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:41:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 58ZF2cEfNdjB for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Mar 2022 12:41:17 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AEEFB49EF7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:41:15 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 a3-20020a5b0ac3000000b006288f395b25so7888343ybr.18
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 09:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=9RhoYygE0YhbGgss02L1IrZ/eHu2ZW7VKbFiJR/6NsY=;
 b=bNZnYHvc0yZVoXSbr4tfbuMjCK2pakFObgjh4jNf/3piaNOO0HK44ST3c/47DILmGu
 C6FptlsVWrpn0xSxRuj/CBb9dvoNa55o5/+0HHpwz5KKhn4CJqckY0cOvpgL+mq/AsoV
 UBSCpPeD8IEAY24qzqoHCy4p+M3wE8U/cqnTxaL3HuTIH0g9Og8g8mGlGGAk1uTPXlRB
 8AAUXcM88iM/B5dkYC1Z76oYetFVl0eAc8s3hZjWFTXQRvzgDWDlWJIKCC4ZstaJrsKy
 +8EdtudDjMqc8ZE0Psnd9IEG4elr2A67DUFT/bciiofousvMNjMvsqkPwdl16QVX2f+M
 VqqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=9RhoYygE0YhbGgss02L1IrZ/eHu2ZW7VKbFiJR/6NsY=;
 b=foLBLXn+xMK1k7Gg1VpzjTWuT5vjZkJWhmaGw0nSw9vsXDj0YNN0tSpSnpVb+I6VBK
 tAXOXWPqKd09+bf2uaC1rYV6cVlsgNaUICSXuLQ7oYiS9djCT9T7aRApgiXnaGXTt4E/
 DeogGQvM08ARcR8afy0Q5+CwsnzkAjiyE3uZRyi/nT7nO6LWRf/zhocAVHERMnh+VQab
 /sO9G+EdCwUgkdwgnafPAI7ffsufOyvptUjwSFuwyj++QAU++w9KT1fqWSSsYr6ngMj/
 eWTzqoA5EGmEnEPUGr42YlV6nqpMVddH/P1yIfibjxnYoeRAoAE4nBLbxJ5TiZWrpq+r
 vFXw==
X-Gm-Message-State: AOAM53293xRR2GmFMrO8VIaymyQfbnEF0ZCO/lr0nki/S5wwnBnEy0Fd
 wBPuwGdE81yksDCuDxtVFetfR7dgT9o0yQcGTYCdiix/L/cDhP6XkQw+W/EpebOG5HziLPWj0nF
 jJbV8FnyXnEiGcWb27kt2BlU9RLCJs4XsFzKc14i5/2nkoVjyZcDUsHx31DVf1wecchsQ5w==
X-Google-Smtp-Source: ABdhPJxdgvSQlAtJSB+leGExvzKh3AfOFvObrD5Ft3CPDFWvPEtEQzDUUOU/i5dt+qgJADukvuYpFX3UlVM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6902:1388:b0:624:6892:5495
 with SMTP id
 x8-20020a056902138800b0062468925495mr8910786ybu.379.1647020475097; Fri, 11
 Mar 2022 09:41:15 -0800 (PST)
Date: Fri, 11 Mar 2022 17:40:00 +0000
In-Reply-To: <20220311174001.605719-1-oupton@google.com>
Message-Id: <20220311174001.605719-15-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v4 14/15] selftests: KVM: Refactor psci_test to make it
 amenable to new tests
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
 pshier@google.com, kvm-riscv@lists.infradead.org, atishp@atishpatra.org,
 pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com
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
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
