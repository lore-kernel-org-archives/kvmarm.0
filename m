Return-Path: <SRS0=m3m7=ON=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BDD4C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 19:16:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C515661261
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 19:16:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C515661261
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CCAD4B129;
	Thu, 23 Sep 2021 15:16:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cuIygfuif6Hg; Thu, 23 Sep 2021 15:16:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 50F5C4B126;
	Thu, 23 Sep 2021 15:16:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A4E34B139
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 15:16:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 78rkq9l+KynY for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Sep 2021 15:16:29 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 745FF4B174
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 15:16:27 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 k15-20020a25240f000000b0059efafc5a58so300407ybk.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 12:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=RpCaoc9NjAjS8EPpoMHzceVcM/1k9Q8w60NaBShbdjk=;
 b=co+l9oAZ6355c5KhVTyfzYGWYP4Nz4ZFxvDXKSvChvxDr80DIEgkapPvd97PPbdvea
 VOZss+k6ebLGG56OKre3eSslEiClTm8WuzSWmupPzatR6i0tjpNlx5ocuWQPAIwGisvC
 ZUo8fhiOkMNAHNBGjLsjxvkmyAAAXyXzsd/cdzxRVBqRtps4eqF5BzcPy81nrqx6/bH6
 sBcJqbW1Sy4SinO0XY0qnxlxnSNSAakTfL+Bry8VNLW66ZM5XfDwH7xMgN9RzCDzvkMU
 PdiANmn/wMNAHVhRhoNTb6qWJBxiYdXY14otq5o+X9aKtS3x21wgZQXTulAAN7RCtrDZ
 Yrlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=RpCaoc9NjAjS8EPpoMHzceVcM/1k9Q8w60NaBShbdjk=;
 b=LjhISgUW5tbad0orT2SpfOHO95MT8XZf1ClP+8soXw7CZonR2vEks986PS18pUbP9R
 nPW/KCmbNHEVP+2pxQ4Km0nNgbAPFNAFXvz/B0gTa1rqfTsWFqtR0UgE7hSvxsFPA72o
 PXqs2MlAVmYY3y0nKmyLncJfHu/jFH4ykwtfG5GDIQCylQdN82qko2xKTceHFNIXH1kS
 hmOV4hbuUt0ByT77qotkUBjsEQGhOtUpTu59UOwI+zP+rkS9QJz9eyOD6lr+J/VD+8Om
 2D6t4jbpMzIsrDHrJ1HPfFHu7XwhV9eB4Hw6pf0JrQXD3r+Io3mpQOXwg3ZLd9vIn60L
 m/TQ==
X-Gm-Message-State: AOAM5319b5UsbSTMKMfsKhjsj3djj+U0eW8QEs9maVidu9CYHoQ1dAiH
 YDzHM/nrcwQrL0fjz7K3YbIviY8dPFETTWzhCw3lfeIRx/Vfn4x+EtBmRHfMvpUDBbGjzfw1Zuk
 bh20X4dlqCEKO4TsKqTO5OY9aHLysj9Yn2xUrcZTRklGskmMFw9KVuYOH9UOMerrzxcmPZg==
X-Google-Smtp-Source: ABdhPJwtQ6SLPk6GlotikeJMiXCr9jbW1lJ4tjuIL9GlrCgGr5LzgSgMMJ90sHZpVANG5pT8u15504jtnvM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:dd6:: with SMTP id
 205mr7437042ybn.82.1632424586935; 
 Thu, 23 Sep 2021 12:16:26 -0700 (PDT)
Date: Thu, 23 Sep 2021 19:16:09 +0000
In-Reply-To: <20210923191610.3814698-1-oupton@google.com>
Message-Id: <20210923191610.3814698-11-oupton@google.com>
Mime-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v2 10/11] selftests: KVM: Refactor psci_test to make it
 amenable to new tests
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>
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
---
 .../testing/selftests/kvm/aarch64/psci_test.c | 68 ++++++++++++-------
 1 file changed, 45 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index 8d043e12b137..90312be335da 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -45,7 +45,7 @@ static uint64_t psci_affinity_info(uint64_t target_affinity,
 	return res.a0;
 }
 
-static void guest_main(uint64_t target_cpu)
+static void guest_test_cpu_on(uint64_t target_cpu)
 {
 	GUEST_ASSERT(!psci_cpu_on(target_cpu, CPU_ON_ENTRY_ADDR, CPU_ON_CONTEXT_ID));
 	uint64_t target_state;
@@ -69,12 +69,10 @@ static void vcpu_power_off(struct kvm_vm *vm, uint32_t vcpuid)
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
@@ -83,31 +81,28 @@ int main(void)
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
 
-	get_reg(vm, VCPU_ID_TARGET, ARM64_SYS_REG(MPIDR_EL1), &target_mpidr);
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
 
-	get_reg(vm, VCPU_ID_TARGET, ARM64_CORE_REG(regs.pc), &obs_pc);
-	get_reg(vm, VCPU_ID_TARGET, ARM64_CORE_REG(regs.regs[0]), &obs_x0);
+static void assert_vcpu_reset(struct kvm_vm *vm, uint32_t vcpuid)
+{
+	uint64_t obs_pc, obs_x0;
+
+	get_reg(vm, vcpuid, ARM64_CORE_REG(regs.pc), &obs_pc);
+	get_reg(vm, vcpuid, ARM64_CORE_REG(regs.regs[0]), &obs_x0);
 
 	TEST_ASSERT(obs_pc == CPU_ON_ENTRY_ADDR,
 		    "unexpected target cpu pc: %lx (expected: %lx)",
@@ -115,7 +110,34 @@ int main(void)
 	TEST_ASSERT(obs_x0 == CPU_ON_CONTEXT_ID,
 		    "unexpected target context id: %lx (expected: %lx)",
 		    obs_x0, CPU_ON_CONTEXT_ID);
+}
 
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
+	get_reg(vm, VCPU_ID_TARGET, ARM64_SYS_REG(MPIDR_EL1), &target_mpidr);
+	vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
+	enter_guest(vm, VCPU_ID_SOURCE);
+
+	if (get_ucall(vm, VCPU_ID_SOURCE, &uc) != UCALL_DONE)
+		TEST_FAIL("Unhandled ucall: %lu", uc.cmd);
+
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
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
