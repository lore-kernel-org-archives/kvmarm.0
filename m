Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D160C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 17:41:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ECEF840BD3;
	Fri, 11 Mar 2022 12:41:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id isfK5HgyGbRm; Fri, 11 Mar 2022 12:41:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5733649F1C;
	Fri, 11 Mar 2022 12:41:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2969349EF5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:41:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sSts2-lA-ddU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Mar 2022 12:41:19 -0500 (EST)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ACD6240B91
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:41:16 -0500 (EST)
Received: by mail-io1-f74.google.com with SMTP id
 g16-20020a05660226d000b00638d8e1828bso6754237ioo.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 09:41:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=2LSJANjSYpAWOJFNIXz+8dt0F/NtwX4/yDcBJViXKEo=;
 b=VlHiPeyTld/1NEk/E5VMaNHpezW5J48Ln8kdGwQgrmfpaHqxesSVY7tRWUosoJXplI
 F9W3pkhSk76+quWnsaAbZW2S3ltT21dCRJ+kP1wGmDThq7tm+k+tZiwmNXcRevC6Y5+y
 Gp2tz9/2N16lbXBwYoSoWap+jD7C5H28Vvdv/R3bInAqoxEIwxuTyyF6X/GyalQ7Jgup
 JiTlA4qtNID5BN0RG4tP5GSnFvSLV0kiNsUTm072zN9GzW0CNiE/i05m5vx8GrLK7tNJ
 qhP4mXDkxPI9VLdwja9wo9ByBlpVK0w29OTvnLhK78lglNFRbSuc6DGQg+w3lLAVMctE
 gkIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=2LSJANjSYpAWOJFNIXz+8dt0F/NtwX4/yDcBJViXKEo=;
 b=Mf+tD17IDUYGMfmBOf2LRN+dkEHVx6axsaEP5zO1gRfw4LguJk4Zbs9+SNGBg4xWJd
 TUZ/e934Sjam+cy1DRfEpy5f7C06tkTvjCjS1svFowY2PWYcEAnIuLwcEn6gR2d3OKO6
 XBGlpQyloIYm6BvZX4ZGSCiYB44tsvO0t4tx39cpnCjy8i5zA+7nG3AUg+A1kSdho2dk
 LQngERidaEZ+1pNRvPNoiEQf7mrgfQsQsqE/RVlwX/2VMVy5THB3lQxifzVKyn+ynrA0
 2lt0juyPujkKlibmpucJ5Qtq44L2IuxhFptNOb8UwBbzLEpgvpEvfSxi4KiJqnREKC0U
 EtJw==
X-Gm-Message-State: AOAM531gi5PHq95f9Cwwlfo6i0MIGPb/yYAcDYoqv6OeQIzbXCK6b+Za
 /IsPXQYUz04yKI4R8oWowYIADVq/LjWGPY0aOuVcF89cmFvTt9Qb9mYuI1/eHk3BPlw8rqs8Efi
 Id0rbKZePSTqK8/1tP5WzfqC6f3CjdLiocu7gDFAarwZdcxRKOSQJS/4w50K9fHW47ObDNw==
X-Google-Smtp-Source: ABdhPJwFStQunXcwugd9xidupQuW9bZm+6k3cfSglfyyz0xljBqYTInRveQuXk40mwAmA8qhksT+CAzWSXk=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:d003:0:b0:646:4652:bd57 with
 SMTP id
 x3-20020a6bd003000000b006464652bd57mr8748957ioa.51.1647020476191; Fri, 11 Mar
 2022 09:41:16 -0800 (PST)
Date: Fri, 11 Mar 2022 17:40:01 +0000
In-Reply-To: <20220311174001.605719-1-oupton@google.com>
Message-Id: <20220311174001.605719-16-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v4 15/15] selftests: KVM: Test SYSTEM_SUSPEND PSCI call
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
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
