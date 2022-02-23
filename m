Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FA5FC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 04:20:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 497804C3E9;
	Tue, 22 Feb 2022 23:20:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id swbkJhEry0g1; Tue, 22 Feb 2022 23:20:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E24124C40B;
	Tue, 22 Feb 2022 23:20:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0707B4C40E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:20:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B2oefgBqwv3Q for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 23:20:02 -0500 (EST)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9EE574C403
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:20:01 -0500 (EST)
Received: by mail-il1-f202.google.com with SMTP id
 l5-20020a927005000000b002c24d650588so4451832ilc.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 20:20:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Ln5NpBpAQfeJH+D9rE91ZmcHe7YhrG7E3g5O/Fn36fE=;
 b=Xjc9neOk8jLLu+5+Yti4DACQgrQiyssQHoAN7SFgxpMJyEW3cYy+lMA8PkZGdKa2/Z
 suF9pIyrCUOYdJJDUKrMbl8SC+woir18EsBPWNqzPzpKUdm8/53eOBdpSJtWvwu4Jtci
 qhrqwwZhKcQsO0a8HFMlK+1YEa8YCothulVqpLiPz3MEYxNhNOO8/yxB4W6vkc5mspmj
 v1N6wuKoaSiWKhN13VjP3x3VK3YJJDwBcY9T3IU6LoKRCOLSVGjNm3eABUMVNgbkPWQ8
 kjo1bqmvbsPpgbCpPFxoFG3FfwcFuuK7tTIwAT59RcWtut6JZnjS2XnB75pDTVKpj8GB
 Zy5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Ln5NpBpAQfeJH+D9rE91ZmcHe7YhrG7E3g5O/Fn36fE=;
 b=A6OjLH0GO1+ukSp8rSlOtOIWa0X65v5vv0tZUo5zxcP77zTAeP9flgvm8wjVjO+/pY
 1t2KNLA89SDPobl/RpGT1cqMNLvwsJ7GelvfZKyXrZZBYBo591HIIQmUyAwQevBJmfbY
 8nwHZ1Z3APKgby+QZj8R6F7f5oSB6Emf7eogQYaBpvmUFSAdmO32OKVfnvMT9n+8/QGp
 V/Mjnfj1WkLxPtoDRYF8kAneF70aKtM4q/ZxhOI5KKjhy2vIKeJF7H6MPKtYOayr304/
 jksLNtaYTZq/fcr+q0+MjZIp9DcZtKiTVVxiPOgyeW7DKapyjFwuzZXifbeUx2ITKqRB
 d50A==
X-Gm-Message-State: AOAM531AKfEOnO6ldz1wxjLLzqtITG9m+pva4vIjq7bvJIaVoTiUJ4lK
 TT8lVreXMOcm0W0ZMoV/4T9NWeE57YR+hVXmCg3P6MjvZlneLsJMoUrzY1RurU7FEIUQpYeHelf
 TOFINuX7nnaxylB0iGQ5seygXOJZXpPR9ngzAfFnHmFRXd/tuXPdKVKM/3uzdG49YwcQrUA==
X-Google-Smtp-Source: ABdhPJxixMOimHhRWdkDlokvYZ9TdxE7WefirH3ZQMjiEuPl8GdS7TYGQs/MgM2jjjoBQ5O+TiFAkrLSadw=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a5d:8b8c:0:b0:613:8223:321a with
 SMTP id
 p12-20020a5d8b8c000000b006138223321amr21146843iol.203.1645590001085; Tue, 22
 Feb 2022 20:20:01 -0800 (PST)
Date: Wed, 23 Feb 2022 04:18:44 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-20-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 19/19] selftests: KVM: Test SYSTEM_SUSPEND PSCI call
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

Assert that the vCPU exits to userspace with KVM_SYSTEM_EVENT_SUSPEND if
it correctly executes the SYSTEM_SUSPEND PSCI call. Additionally, assert
that the guest PSCI call fails if preconditions are not met (more than 1
running vCPU).

Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../testing/selftests/kvm/aarch64/psci_test.c | 74 +++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index 535130d5e97f..ef7fd58af675 100644
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
 static void vcpu_power_off(struct kvm_vm *vm, uint32_t vcpuid)
 {
 	struct kvm_mp_state mp_state = {
@@ -137,8 +147,72 @@ static void host_test_cpu_on(void)
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
+static void guest_test_system_suspend(void)
+{
+	uint64_t r = psci_system_suspend(CPU_ON_ENTRY_ADDR, CPU_ON_CONTEXT_ID);
+
+	GUEST_SYNC(r);
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
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
