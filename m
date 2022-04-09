Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10074C433FE
	for <kvmarm@archiver.kernel.org>; Sat,  9 Apr 2022 18:46:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C14EF4B215;
	Sat,  9 Apr 2022 14:46:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mEE0Z9bfMe3J; Sat,  9 Apr 2022 14:46:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1FDF4B22C;
	Sat,  9 Apr 2022 14:46:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33B5049E44
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Apr 2022 14:46:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m7axz1BkSKm8 for <kvmarm@lists.cs.columbia.edu>;
 Sat,  9 Apr 2022 14:46:12 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D6C234B1B5
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Apr 2022 14:46:12 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 b12-20020a056902030c00b0061d720e274aso9153963ybs.20
 for <kvmarm@lists.cs.columbia.edu>; Sat, 09 Apr 2022 11:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=OjrumNZxEEC9JuFBLDox+92YZe3EIOWUkCcQ/nIRGPY=;
 b=LZ5+m4r1/6YLipI0gN+Pv5e4GfhlOD5144KXetxI+6WILM1ibWOL2bzGYh7eJYM7v4
 UsaMw2u6MW9ZKH1GRs8LfqU3rL6RMKc0Vcs1s+72v1b1qLvDaoKkk7p2lF7v4ZbN81nd
 p9qjopZgxbw+8wXyDx7jIvDTTvHWuduflu0Z9qYn2lWeEqoUoPcs2cFDLKCYyYvIzVmZ
 V+Dr6045ojYb2r4D2rI4Tsr1rJ3MEwznClc9hwZrI8ILxidC0oDstuE92NUlNrHGgsy9
 Kr0dJQPWbPWgIvtwKwbSsFQ6RE6jiZ9ofc7J0dOWqyNVcFMnbJIYZEVyGrdJSVOOO4Hy
 Cg8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=OjrumNZxEEC9JuFBLDox+92YZe3EIOWUkCcQ/nIRGPY=;
 b=hmf7R/LPxcl+TmVMHdOAXQV9XKA920l42L3XELmeeUlmO7/1oRy2Ir0KBeraXx1FAa
 M5aNrXIi0A5Oov09qHTRv7DJlNJpxGhCvlgb+R2oyicBQMPQrLY5zBF9mSEHxwIBo+mp
 M1HHWlS9j4yLRoXQY32jHHmzBEi6+Pn2Nn9nMQi/XE/8E6U5KX1NH8mu84no0yaqTpoy
 h5L2rP4thajHueyTwRpEgJb2ftRppuFhTBehj3LcwRtdk2pttRjpYLlNu3NgicJRFwvD
 zTjBVztmniiW8hNWE516zhrBZCrPPa4uQsB4kcnHR67uZP6x4nCtcch3Elp4hYgW7Vsd
 RphA==
X-Gm-Message-State: AOAM531DaBH3EaIfY3Y89jEZG2V5g5USA9uGw5sMB6wxeRhltC9dToTX
 w7S00dEJ0OGB0qobt6xR/ISpk/W3HZMaLHb+aiHEMYJfkH4vasRvHTi5531/NoK3OFVdjSmNwyi
 9Hk58I/1b1OPNMsg+qWv5CG2uhygNNsUpkDN7BRNYSiIyySYthbsCa/+CFVz8wIbe2UDTBA==
X-Google-Smtp-Source: ABdhPJw23470taeCjhyd7oxRIw+PzjKhZH13DOsSObKCyPE5FciaKTT52JBHfWKqYlSKc4u1Dt/oLSuJNCc=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a5b:e8e:0:b0:63d:cbfc:36e9 with
 SMTP id
 z14-20020a5b0e8e000000b0063dcbfc36e9mr16905813ybr.362.1649529972291; Sat, 09
 Apr 2022 11:46:12 -0700 (PDT)
Date: Sat,  9 Apr 2022 18:45:49 +0000
In-Reply-To: <20220409184549.1681189-1-oupton@google.com>
Message-Id: <20220409184549.1681189-14-oupton@google.com>
Mime-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v5 13/13] selftests: KVM: Test SYSTEM_SUSPEND PSCI call
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

Assert that the vCPU exits to userspace with KVM_SYSTEM_EVENT_SUSPEND if
the guest calls PSCI SYSTEM_SUSPEND. Additionally, guarantee that the
SMC32 and SMC64 flavors of this call are discoverable with the
PSCI_FEATURES call.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../testing/selftests/kvm/aarch64/psci_test.c | 69 +++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index 535130d5e97f..88541de21c41 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -45,6 +45,25 @@ static uint64_t psci_affinity_info(uint64_t target_affinity,
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
+static uint64_t psci_features(uint32_t func_id)
+{
+	struct arm_smccc_res res;
+
+	smccc_hvc(PSCI_1_0_FN_PSCI_FEATURES, func_id, 0, 0, 0, 0, 0, 0, &res);
+
+	return res.a0;
+}
+
 static void vcpu_power_off(struct kvm_vm *vm, uint32_t vcpuid)
 {
 	struct kvm_mp_state mp_state = {
@@ -137,8 +156,58 @@ static void host_test_cpu_on(void)
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
+	uint64_t ret;
+
+	/* assert that SYSTEM_SUSPEND is discoverable */
+	GUEST_ASSERT(!psci_features(PSCI_1_0_FN_SYSTEM_SUSPEND));
+	GUEST_ASSERT(!psci_features(PSCI_1_0_FN64_SYSTEM_SUSPEND));
+
+	ret = psci_system_suspend(CPU_ON_ENTRY_ADDR, CPU_ON_CONTEXT_ID);
+	GUEST_SYNC(ret);
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
 int main(void)
 {
+	if (!kvm_check_cap(KVM_CAP_ARM_SYSTEM_SUSPEND)) {
+		print_skip("KVM_CAP_ARM_SYSTEM_SUSPEND not supported");
+		exit(KSFT_SKIP);
+	}
+
 	host_test_cpu_on();
+	host_test_system_suspend();
 	return 0;
 }
-- 
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
