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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B6E7C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 19:16:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 052FD61108
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 19:16:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 052FD61108
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF2844B11E;
	Thu, 23 Sep 2021 15:16:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id g0aGSZwajoTw; Thu, 23 Sep 2021 15:16:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 673844B17B;
	Thu, 23 Sep 2021 15:16:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 820A94A19A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 15:16:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WkcSKQIn4psW for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Sep 2021 15:16:29 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 76CDC4B11A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 15:16:28 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 83-20020a251956000000b0059948f541cbso298193ybz.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 12:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=iaLxJyQl/R2XLxgbK/Yc9KCKg/FcSd6fsVvahhw1gbk=;
 b=MqZIRMrNmbaHF93vIL8MIjYz2FQMq964YhsWtPj5J9/0PZjaTBZpanOXfeFLtiaHD6
 Hsgb+G10pPVRL3jFu9SHOfUQVSQ7fGYx/a82WtqnoWdfGLYU2XoGYrqILas2jRPIB+/E
 kmYvDT8rmmUHm2NSVM0jhH3pOM6ZobF3TeTwVtJtYZKa9pvK+gVSBWawg72Bvnql/ZaW
 jnudsfUiXLzKsyUzFN8yATBQoCq2+iJdo2ChUcjejGtjDrjsCYIVX1iLmpqv2SVDf9/r
 WOpKinDu5OyTWsFnWFIcnGYP9vXMkQFAcN6ygsEvgfxniC2rcaMQlYG0BigOBa9xfF8s
 uPdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=iaLxJyQl/R2XLxgbK/Yc9KCKg/FcSd6fsVvahhw1gbk=;
 b=zbLNTUDP7U8Fl4Wmz5rHxJTA6uAIQ+rQWyUdgoTDU6SF22xJDi+hp3HWQnIpMz5yzI
 qQPV/UYtK10W7CXnA/apaj2SLlap831Eixzz38Jx5GY40e6uWAUR0Yk/t1ukJ0KH38Kp
 O10q91odd565nW9b3P3Y4S4SKV12zDRGgKBxhi5HgeG+wYstnErNb26rHMVtV/kNwG19
 iBW3MfURK9rXhu97RZWquAWizni/sVGOCPjjpfHbPwEBOug16oatXJMWDdPErCPy2lLk
 cT83Uby3wnPddC3N5JQbjiFoikn8LWcpwJVEE0uMEgZEAq3spX6MdpEFcHvtk1S1oO1X
 4yKg==
X-Gm-Message-State: AOAM532L8khmvCOYV2akR+JIfNFrkVdTeUzDFHud8NM1wWQoR494AVBs
 bXLezWzx/0M2irgLieLCt19cpO4QCOtoH8+aJUGBA3KW33z6baMm87i/bUcrcibH/872XX5zvcr
 oiUtytdw9Fjd1gN4DSPNTe6u3eId8Kmbc3pCtioQXTIHuBVrZqxTLEnL8O6IOPMlFIpMHLw==
X-Google-Smtp-Source: ABdhPJyjXGf6r7078NOSI+fwirDQAYTFCKMH/ZKp0jWghQ7m5qJfBJ9PqydzFMi5FrxM+rw+lmH3oJ2XpIA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:2d4c:: with SMTP id
 s12mr7301465ybe.350.1632424587972; 
 Thu, 23 Sep 2021 12:16:27 -0700 (PDT)
Date: Thu, 23 Sep 2021 19:16:10 +0000
In-Reply-To: <20210923191610.3814698-1-oupton@google.com>
Message-Id: <20210923191610.3814698-12-oupton@google.com>
Mime-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v2 11/11] selftests: KVM: Test SYSTEM_SUSPEND PSCI call
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

Assert that the vCPU exits to userspace with KVM_SYSTEM_EVENT_SUSPEND if
it correctly executes the SYSTEM_SUSPEND PSCI call. Additionally, assert
that the guest PSCI call fails if preconditions are not met (more than 1
running vCPU).

Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../testing/selftests/kvm/aarch64/psci_test.c | 75 +++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index 90312be335da..5b881ca4d102 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -45,6 +45,16 @@ static uint64_t psci_affinity_info(uint64_t target_affinity,
 	return res.a0;
 }
 
+static uint64_t psci_system_suspend(uint64_t entry_addr, uint64_t context_id)
+{
+	struct arm_smccc_res res;
+
+	smccc_hvc(PSCI_1_0_FN64_SYSTEM_SUSPEND, entry_addr, context_id,
+		  0, 0, 0, 0, 0, &res);
+
+	return res.a0;
+}
+
 static void guest_test_cpu_on(uint64_t target_cpu)
 {
 	GUEST_ASSERT(!psci_cpu_on(target_cpu, CPU_ON_ENTRY_ADDR, CPU_ON_CONTEXT_ID));
@@ -69,6 +79,13 @@ static void vcpu_power_off(struct kvm_vm *vm, uint32_t vcpuid)
 	vcpu_set_mp_state(vm, vcpuid, &mp_state);
 }
 
+static void guest_test_system_suspend(void)
+{
+	uint64_t r = psci_system_suspend(CPU_ON_ENTRY_ADDR, CPU_ON_CONTEXT_ID);
+
+	GUEST_SYNC(r);
+}
+
 static struct kvm_vm *setup_vm(void *guest_code)
 {
 	struct kvm_vcpu_init init;
@@ -136,8 +153,66 @@ static void host_test_cpu_on(void)
 	kvm_vm_free(vm);
 }
 
+static void enable_system_suspend(struct kvm_vm *vm)
+{
+	struct kvm_enable_cap cap = {
+		.cap = KVM_CAP_ARM_SYSTEM_SUSPEND,
+	};
+
+	vm_enable_cap(vm, &cap);
+}
+
+static void host_test_system_suspend(void)
+{
+	struct kvm_run *run;
+	struct kvm_vm *vm;
+
+	vm = setup_vm(guest_test_system_suspend);
+	enable_system_suspend(vm);
+
+	vcpu_power_off(vm, VCPU_ID_TARGET);
+	run = vcpu_state(vm, VCPU_ID_SOURCE);
+
+	enter_guest(vm, VCPU_ID_SOURCE);
+
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_SYSTEM_EVENT,
+		    "Unhandled exit reason: %u (%s)",
+		    run->exit_reason, exit_reason_str(run->exit_reason));
+	TEST_ASSERT(run->system_event.type == KVM_SYSTEM_EVENT_SUSPEND,
+		    "Unhandled system event: %u (expected: %u)",
+		    run->system_event.type, KVM_SYSTEM_EVENT_SUSPEND);
+
+	assert_vcpu_reset(vm, VCPU_ID_SOURCE);
+	kvm_vm_free(vm);
+}
+
+static void host_test_system_suspend_fails(void)
+{
+	struct kvm_vm *vm;
+	struct ucall uc;
+
+	vm = setup_vm(guest_test_system_suspend);
+	enable_system_suspend(vm);
+
+	enter_guest(vm, VCPU_ID_SOURCE);
+	TEST_ASSERT(get_ucall(vm, VCPU_ID_SOURCE, &uc) == UCALL_SYNC,
+		    "Unhandled ucall: %lu", uc.cmd);
+	TEST_ASSERT(uc.args[1] == PSCI_RET_DENIED,
+		    "Unrecognized PSCI return code: %lu (expected: %u)",
+		    uc.args[1], PSCI_RET_DENIED);
+
+	kvm_vm_free(vm);
+}
+
 int main(void)
 {
+	if (!kvm_check_cap(KVM_CAP_ARM_SYSTEM_SUSPEND)) {
+		print_skip("KVM_CAP_ARM_SYSTEM_SUSPEND not supported");
+		exit(KSFT_SKIP);
+	}
+
 	host_test_cpu_on();
+	host_test_system_suspend();
+	host_test_system_suspend_fails();
 	return 0;
 }
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
