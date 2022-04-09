Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2901C43219
	for <kvmarm@archiver.kernel.org>; Sat,  9 Apr 2022 18:46:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94A8A4B16F;
	Sat,  9 Apr 2022 14:46:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IzSr2tSqWPei; Sat,  9 Apr 2022 14:46:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B6284B229;
	Sat,  9 Apr 2022 14:46:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36A4F4B1D5
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Apr 2022 14:46:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8W0SDLvVh5Hy for <kvmarm@lists.cs.columbia.edu>;
 Sat,  9 Apr 2022 14:46:12 -0400 (EDT)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EDF344B1BD
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Apr 2022 14:46:11 -0400 (EDT)
Received: by mail-io1-f74.google.com with SMTP id
 g16-20020a05660203d000b005f7b3b0642eso7585648iov.16
 for <kvmarm@lists.cs.columbia.edu>; Sat, 09 Apr 2022 11:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=qWh0nGLS/sYDhLmuuIPUJ0xQoUccpVUiIJA65bvzxME=;
 b=d33w300qDK+2Vr9P3HE9o0RbVQOcL6Ksui1I+lNvRkcVR71900FoVBMi9IsioS418w
 Y8X77e/ORLEW0vKikbWAFNPaj4gpd5RVMBKK3Oh11ovSR4Cp7GaTSFGcjBfcQ+V4MkqX
 8pWssH8JU5fnaNKahix+LafSesWxHe0D9uazApxhzm7jq+Lqqcn1xiOrmvM1QTJbLj5I
 oE0jGEhffI9EY/qmi/v/NDt8vazM/0Rl5+6S8p+YhIyEIg0r7enTkmFkbqAOGwmTMdB6
 ZCwJW58hFVZE0+sxieMxHSTVJ9elGobvwpuYo0H3NAitQb56opMQX3Pk3YOQJnUV8Iy0
 m8DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=qWh0nGLS/sYDhLmuuIPUJ0xQoUccpVUiIJA65bvzxME=;
 b=BpvknXbCUc441q9UIqqi52RY30o6pXtFHQI62eynBQ4K2KZs2O1GWz9bEOKIuxhYbL
 ilVXHGuqKnLYc5kOOnnqMHAXEJ3WcFX7VOBROf5pMjnFAvelGKwD4hCCOZvyX7dHMOdy
 Bht0ej6kcdjlC0TA2HMjFIkznu8nzS3WCEgPNgWprZStQO/X2gKE4Mgv+rYFRCk5HaKs
 fItmW3DdJ6czlE+ZlgHja69TbeiDbLLSg+5C4YYIC6gsCPShTyPjWaFn7BaxtCSXAHLG
 5vkN5EtmWS6kBECPzWLp0IKwBZudK2a1KK/VceokiAxaDXlrGOJGbrVSFEQA3QEAlDuF
 p1IA==
X-Gm-Message-State: AOAM530sJ9js60uXGQbKtSLmfjpdF+uxZop5sunx14Rnhumsg4Pme02R
 7v0Z1i6NgqCcn+DBRNz4EdFF/Tjf555CE0X3J+mlSwFIPhx/SB24OLpLoetvVtyo2Ix7tzqqcOI
 tWQzW0ZMNmESCjbUuR8MSyM7NbkdAADPkBfs4/Q9dUeqyEF1UVF/aH/XU+UQDj3q7xsMKrQ==
X-Google-Smtp-Source: ABdhPJwSt4/aVKoZNg/n1mQkH/k9N2ZB1+N/+0Mn/FEydQfxiu90zopXLFInuaIRCMwD3k9QfmIBlmseeTQ=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:1409:b0:5e7:487:133c
 with SMTP id
 t9-20020a056602140900b005e70487133cmr10382621iov.196.1649529971434; Sat, 09
 Apr 2022 11:46:11 -0700 (PDT)
Date: Sat,  9 Apr 2022 18:45:48 +0000
In-Reply-To: <20220409184549.1681189-1-oupton@google.com>
Message-Id: <20220409184549.1681189-13-oupton@google.com>
Mime-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v5 12/13] selftests: KVM: Refactor psci_test to make it
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
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
