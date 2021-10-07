Return-Path: <SRS0=Cc05=O3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06076C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  7 Oct 2021 23:35:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9A96E61076
	for <kvmarm@archiver.kernel.org>; Thu,  7 Oct 2021 23:35:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9A96E61076
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A5674B2AE;
	Thu,  7 Oct 2021 19:35:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dQTGvRQHK0le; Thu,  7 Oct 2021 19:35:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 983B84B2AB;
	Thu,  7 Oct 2021 19:35:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBE974086F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Oct 2021 19:35:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id thsyc5Hlh2ba for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Oct 2021 19:35:00 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 720CE4B2C6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Oct 2021 19:34:57 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 n15-20020a170902e54f00b0013ed08c1bacso3925488plf.20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Oct 2021 16:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=F/zs/L5o3RVm3Py5wUOA95eG+q7sFQsiBYx3cR6Byyc=;
 b=GRWGNWrXatSszSYAm5id6fn5vLAzMUADRwMuFO1wfmfuRDodoik8vqN+6qZkkoc8SF
 IFlvC1lPStzeFZ+RtFERpOQKSBCzL9ziFiLn8UrwxQMrnMK7mdJT8vgkPz6mEOYroCsn
 3yCPUBzDCXUBgsCFNO4cR8bHQfVC56stUrv2K9L4mGhVoigrihvoFI0fdYeYRHDzveid
 1IWxH0Ur1RmSeXSJ5Fxaf2p8Cp6rmT6S4TqLQYMY1DWz0ZE+PfJvX2rIs74cQD+BoGxk
 ll0unDBBM29h0O+zYaS84HBfJqk3FzfsHvn1ehS7QDpfqzTvjsf7AFR7lUOPxYZmNHpg
 TzLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=F/zs/L5o3RVm3Py5wUOA95eG+q7sFQsiBYx3cR6Byyc=;
 b=ZT79z4H0dZV/cwu+vSPijK4lXDSFZvto5MhEtqdCYkaRHiKcvLrdHeESZYQf0LpiV3
 aE/jtPPGnZ48COWYn5TILPABxi66BhDBuv9Hge3JGjuxrkzL/4irjp6pKCojVAnHD0zG
 5FWww4jdMseOFzzvNpWtqOMf6/xJQfnsRbprdVJVUnSJ/mYnL7pwoV2e38oXt0pcRXvv
 IggkfWuPv3CqM58oQFB1g1VqHb3+334XgKLCJmMgaWYDWyvRNUcBeu2msb3JO0PIY441
 /NN0Ki0OMUvvBToq0gf3DrPzs89QGFYqkJWOL4nc6pNnmABDxCGDLXXlar1mi8MWT/pN
 kDTw==
X-Gm-Message-State: AOAM5313iAizam/bHREsoLjTEN1b44Ch+d1FqRPbhleMRvaRrHyunkrQ
 j5sEatN1+Zma8bLtoK3lVuwEPcsoO/r0
X-Google-Smtp-Source: ABdhPJxOXoernLJrGHp7u6AxwByuyVHxe5Q/pHmU7IW019W80Wme37Cbfn0+DpLelk5b0TA2fy2jCJ19QWm7
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:d88d:b0:13e:807b:d52b with SMTP id
 b13-20020a170902d88d00b0013e807bd52bmr6448083plz.69.1633649696487; Thu, 07
 Oct 2021 16:34:56 -0700 (PDT)
Date: Thu,  7 Oct 2021 23:34:28 +0000
In-Reply-To: <20211007233439.1826892-1-rananta@google.com>
Message-Id: <20211007233439.1826892-5-rananta@google.com>
Mime-Version: 1.0
References: <20211007233439.1826892-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v8 04/15] KVM: arm64: selftests: Introduce ARM64_SYS_KVM_REG
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Andrew Jones <drjones@redhat.com>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

With the inclusion of sysreg.h, that brings in system register
encodings, it would be redundant to re-define register encodings
again in processor.h to use it with ARM64_SYS_REG for the KVM
functions such as set_reg() or get_reg(). Hence, add helper macro,
ARM64_SYS_KVM_REG, that converts SYS_* definitions in sysreg.h
into ARM64_SYS_REG definitions.

Also replace all the users of ARM64_SYS_REG, relying on
the encodings created in processor.h, with ARM64_SYS_KVM_REG and
remove the definitions.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  |  2 +-
 .../selftests/kvm/aarch64/psci_cpu_on_test.c  |  2 +-
 .../selftests/kvm/include/aarch64/processor.h | 20 ++++++++++---------
 .../selftests/kvm/lib/aarch64/processor.c     | 16 +++++++--------
 4 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 11fd23e21cb4..ea189d83abf7 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -190,7 +190,7 @@ static int debug_version(struct kvm_vm *vm)
 {
 	uint64_t id_aa64dfr0;
 
-	get_reg(vm, VCPU_ID, ARM64_SYS_REG(ID_AA64DFR0_EL1), &id_aa64dfr0);
+	get_reg(vm, VCPU_ID, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &id_aa64dfr0);
 	return id_aa64dfr0 & 0xf;
 }
 
diff --git a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
index 018c269990e1..4c5f6814030f 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
@@ -91,7 +91,7 @@ int main(void)
 	init.features[0] |= (1 << KVM_ARM_VCPU_POWER_OFF);
 	aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_main);
 
-	get_reg(vm, VCPU_ID_TARGET, ARM64_SYS_REG(MPIDR_EL1), &target_mpidr);
+	get_reg(vm, VCPU_ID_TARGET, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), &target_mpidr);
 	vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
 	vcpu_run(vm, VCPU_ID_SOURCE);
 
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 7989e832cafb..93797783abad 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -16,15 +16,17 @@
 #define ARM64_CORE_REG(x) (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
 			   KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(x))
 
-#define CPACR_EL1               3, 0,  1, 0, 2
-#define TCR_EL1                 3, 0,  2, 0, 2
-#define MAIR_EL1                3, 0, 10, 2, 0
-#define MPIDR_EL1               3, 0,  0, 0, 5
-#define TTBR0_EL1               3, 0,  2, 0, 0
-#define SCTLR_EL1               3, 0,  1, 0, 0
-#define VBAR_EL1                3, 0, 12, 0, 0
-
-#define ID_AA64DFR0_EL1         3, 0,  0, 5, 0
+/*
+ * KVM_ARM64_SYS_REG(sys_reg_id): Helper macro to convert
+ * SYS_* register definitions in asm/sysreg.h to use in KVM
+ * calls such as get_reg() and set_reg().
+ */
+#define KVM_ARM64_SYS_REG(sys_reg_id)			\
+	ARM64_SYS_REG(sys_reg_Op0(sys_reg_id),		\
+			sys_reg_Op1(sys_reg_id),	\
+			sys_reg_CRn(sys_reg_id),	\
+			sys_reg_CRm(sys_reg_id),	\
+			sys_reg_Op2(sys_reg_id))
 
 /*
  * Default MAIR
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 632b74d6b3ca..db64ee206064 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -232,10 +232,10 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
 	 * Enable FP/ASIMD to avoid trapping when accessing Q0-Q15
 	 * registers, which the variable argument list macros do.
 	 */
-	set_reg(vm, vcpuid, ARM64_SYS_REG(CPACR_EL1), 3 << 20);
+	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_CPACR_EL1), 3 << 20);
 
-	get_reg(vm, vcpuid, ARM64_SYS_REG(SCTLR_EL1), &sctlr_el1);
-	get_reg(vm, vcpuid, ARM64_SYS_REG(TCR_EL1), &tcr_el1);
+	get_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_SCTLR_EL1), &sctlr_el1);
+	get_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TCR_EL1), &tcr_el1);
 
 	switch (vm->mode) {
 	case VM_MODE_P52V48_4K:
@@ -273,10 +273,10 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
 	tcr_el1 |= (1 << 8) | (1 << 10) | (3 << 12);
 	tcr_el1 |= (64 - vm->va_bits) /* T0SZ */;
 
-	set_reg(vm, vcpuid, ARM64_SYS_REG(SCTLR_EL1), sctlr_el1);
-	set_reg(vm, vcpuid, ARM64_SYS_REG(TCR_EL1), tcr_el1);
-	set_reg(vm, vcpuid, ARM64_SYS_REG(MAIR_EL1), DEFAULT_MAIR_EL1);
-	set_reg(vm, vcpuid, ARM64_SYS_REG(TTBR0_EL1), vm->pgd);
+	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_SCTLR_EL1), sctlr_el1);
+	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TCR_EL1), tcr_el1);
+	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_MAIR_EL1), DEFAULT_MAIR_EL1);
+	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TTBR0_EL1), vm->pgd);
 }
 
 void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
@@ -362,7 +362,7 @@ void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid)
 {
 	extern char vectors;
 
-	set_reg(vm, vcpuid, ARM64_SYS_REG(VBAR_EL1), (uint64_t)&vectors);
+	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_VBAR_EL1), (uint64_t)&vectors);
 }
 
 void route_exception(struct ex_regs *regs, int vector)
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
