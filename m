Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2664C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 21 Feb 2022 15:35:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BAD94B218;
	Mon, 21 Feb 2022 10:35:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id k3NkFWZAn+Pi; Mon, 21 Feb 2022 10:35:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B4394B1EF;
	Mon, 21 Feb 2022 10:35:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4E6749F58
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Feb 2022 10:35:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PqpmcFgxIn2U for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Feb 2022 10:35:39 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0AF924B1EF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Feb 2022 10:35:37 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id C01C661182;
 Mon, 21 Feb 2022 15:35:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC36C340F3;
 Mon, 21 Feb 2022 15:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645457736;
 bh=qBbgPb2d7N6XTBwAhenhU3tAL8yT3EhCd8NBZI4dCXE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=BUG4IzCoVpQ3TLd+DwABVw5nsk5DYNCKfJLBkeSTAwYxnbY3yl4tIkzJcttViUBwo
 WgSMwhiisThq5MRILDu1DvKRECZYR0E6Pyube6aRLvWvzKyHQsS5uz+A+x9XNvD+GT
 gYnJqRkZO8lvThv/cpiNF6Nx7enuLjuOgs+5yBwa6TQd8b8HgbuvT4Vbos3XEJRWX4
 G8zQI6FwQnCPeR5K6KCi4si3qQBvNeehowYaM7WiJPUgkMCjLl6OSDy6Ou98U3lv33
 9Jt03WrY0ItI/rIhVADfswg7PekL5B22WOqHCgR4PUvUCpmXgopD8ik8sXNVBnA0m2
 QZMkIFAXI3+lQ==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 3/3] KVM: arm64: Indicate SYSTEM_RESET2 in
 kvm_run::system_event flags field
Date: Mon, 21 Feb 2022 15:35:24 +0000
Message-Id: <20220221153524.15397-4-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220221153524.15397-1-will@kernel.org>
References: <20220221153524.15397-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
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

When handling reset and power-off PSCI calls from the guest, we
initialise X0 to PSCI_RET_INTERNAL_FAILURE in case the VMM tries to
re-run the vCPU after issuing the call.

Unfortunately, this also means that the VMM cannot see which PSCI call
was issued and therefore cannot distinguish between PSCI SYSTEM_RESET
and SYSTEM_RESET2 calls, which is necessary in order to determine the
validity of the "reset_type" in X1.

Allocate bit 0 of the previously unused 'flags' field of the
system_event structure so that we can indicate the PSCI call used to
initiate the reset.

Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 Documentation/virt/kvm/api.rst    |  5 +++++
 arch/arm64/include/uapi/asm/kvm.h |  7 +++++++
 arch/arm64/kvm/psci.c             | 15 +++++++++++----
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a4267104db50..8305ac9747b6 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5939,6 +5939,11 @@ Valid values for 'type' are:
    to ignore the request, or to gather VM memory core dump and/or
    reset/shutdown of the VM.
 
+Valid flags are:
+
+ - KVM_SYSTEM_EVENT_RESET_FLAG_PSCI_RESET2 (arm64 only) -- the guest issued
+   a SYSTEM_RESET2 call according to v1.1 of the PSCI specification.
+
 ::
 
 		/* KVM_EXIT_IOAPIC_EOI */
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index b3edde68bc3e..06bc08fdf8ea 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -413,6 +413,13 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_PSCI_RET_INVAL		PSCI_RET_INVALID_PARAMS
 #define KVM_PSCI_RET_DENIED		PSCI_RET_DENIED
 
+/* arm64-specific kvm_run::system_event flags */
+/*
+ * Reset caused by a PSCI v1.1 SYSTEM_RESET2 call.
+ * Valid only when the system event has a type of KVM_SYSTEM_EVENT_RESET.
+ */
+#define KVM_SYSTEM_EVENT_RESET_FLAG_PSCI_RESET2	(1ULL << 0)
+
 #endif
 
 #endif /* __ARM_KVM_H__ */
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 30fcc5a99483..ecb4b74cb12a 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -162,7 +162,7 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
 	return PSCI_0_2_AFFINITY_LEVEL_OFF;
 }
 
-static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type)
+static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type, u64 flags)
 {
 	unsigned long i;
 	struct kvm_vcpu *tmp;
@@ -182,17 +182,24 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type)
 
 	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
 	vcpu->run->system_event.type = type;
+	vcpu->run->system_event.flags = flags;
 	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
 }
 
 static void kvm_psci_system_off(struct kvm_vcpu *vcpu)
 {
-	kvm_prepare_system_event(vcpu, KVM_SYSTEM_EVENT_SHUTDOWN);
+	kvm_prepare_system_event(vcpu, KVM_SYSTEM_EVENT_SHUTDOWN, 0);
 }
 
 static void kvm_psci_system_reset(struct kvm_vcpu *vcpu)
 {
-	kvm_prepare_system_event(vcpu, KVM_SYSTEM_EVENT_RESET);
+	kvm_prepare_system_event(vcpu, KVM_SYSTEM_EVENT_RESET, 0);
+}
+
+static void kvm_psci_system_reset2(struct kvm_vcpu *vcpu)
+{
+	kvm_prepare_system_event(vcpu, KVM_SYSTEM_EVENT_RESET,
+				 KVM_SYSTEM_EVENT_RESET_FLAG_PSCI_RESET2);
 }
 
 static void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
@@ -364,7 +371,7 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 			    arg < PSCI_1_1_RESET_TYPE_VENDOR_START) {
 				val = PSCI_RET_INVALID_PARAMS;
 			} else {
-				kvm_psci_system_reset(vcpu);
+				kvm_psci_system_reset2(vcpu);
 				val = PSCI_RET_INTERNAL_FAILURE;
 				ret = 0;
 			}
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
