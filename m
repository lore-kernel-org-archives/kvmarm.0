Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4107AC433FE
	for <kvmarm@archiver.kernel.org>; Wed,  4 May 2022 03:25:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A362F4B235;
	Tue,  3 May 2022 23:25:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sBjaR4IUthfB; Tue,  3 May 2022 23:25:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 093264B1FA;
	Tue,  3 May 2022 23:25:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF8524B132
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 23:25:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4XXsGjuita58 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2022 23:25:14 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B54EF4B1E0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 23:25:13 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 y17-20020a637d11000000b003ab06870074so91082pgc.15
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 May 2022 20:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=O6gsi1VosCJ9Q+QJJSE7NIUXWalRHVe1tFy/2jVg0nU=;
 b=J2nRE+pM0k4FjNp2cMlnN8/gWRkViT6d6HglwgNSrVeXwgSSlC2eD0N42z2TxFenrK
 1++90Z1DhXB+oCBWCaQUko3MtAX2Vwd7k7Tg1W8U1wFg4ebNTsyShXIVfZkQlXp61hpV
 P8TkYscwX69KGqwKqPYsXZHORIsX6xH+TgDrD+LwGi6A533g0QAbvuLY4DBvjChRlkuh
 uAKUg7eTOY8BCZ0zNkVkrc+zK8FyrgaDWWHxRBy50l5jAmd2A4PbUM4xe1EOHPswFwyu
 luobZxTR3exLfL81rO4/ZURyhjwdWEhoN7RcpAgHC25Ze+urfrMTfV3ojBPHk7Pyw04k
 jjPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=O6gsi1VosCJ9Q+QJJSE7NIUXWalRHVe1tFy/2jVg0nU=;
 b=bb1pXR0WcTF+KNXnI/TBKVvgGe7DBmiFABUE5TB+g3epdgaEyk/ThjNcx60ARXPkAK
 R6xyC2xENAsr+EqIyraU6VSaPGcCYYf8JzY4D3md2Wy7ZBqzvOCHKSAEEKcffM5riHsa
 mnaEW5uFboxLwaPI7zS9eLoxXj4Q/xzmLCmIC8W3O3tg2OQuSX42FRaRbC5sjJnKfr1n
 YpdYBF0/emkxjAvpQwJHQllMGEHb1bQ5j8eRQ1H5r461dhs8+OT2V5dgKidTuisgM3VQ
 7qP7YOxybiCancfB9TAY4Ujy4jMf0L79ZbBf0KdWcFMJpLPv47jrn3kcAN7w54tPWxfM
 RN9Q==
X-Gm-Message-State: AOAM530CFDxwT9Mf1Dn1HSSucTdpJX4HBxo0N198y0gV+/c6Rv8+myCL
 TVZlD/+uQwexMyVfefFeQfAN2AYFVhUus7vRRJHrhEOhLUWtR1MY6z4wkiJ3psfVa5tApAk3QQU
 WZKYMQkfKuRLISC/bsgrfStQA0zFL5/Z99AqmCFXFf0qCShWOJBb67VsnO53J/D+dNkAljw==
X-Google-Smtp-Source: ABdhPJzFv7NkWcBU+6vplhxBAUpwjxPW1/ACANI7rwBZF4ra9bVHx4OSHqKJtvMgIzFZVeY3+CTj/EOn3DA=
X-Received: from oupton3.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a17:902:9309:b0:156:983d:2193 with SMTP id
 bc9-20020a170902930900b00156983d2193mr19155791plb.158.1651634713185; Tue, 03
 May 2022 20:25:13 -0700 (PDT)
Date: Wed,  4 May 2022 03:24:46 +0000
In-Reply-To: <20220504032446.4133305-1-oupton@google.com>
Message-Id: <20220504032446.4133305-13-oupton@google.com>
Mime-Version: 1.0
References: <20220504032446.4133305-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v6 12/12] selftests: KVM: Test SYSTEM_SUSPEND PSCI call
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
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
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
