Return-Path: <SRS0=oqs1=OD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47006C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 23:10:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DD0E361154
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 23:10:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DD0E361154
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 92F2F4B1F1;
	Mon, 13 Sep 2021 19:10:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mePc+lmwXyS0; Mon, 13 Sep 2021 19:10:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36B5A4B213;
	Mon, 13 Sep 2021 19:10:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED7674B1E7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 19:10:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SJHnmjoxJCQM for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Sep 2021 19:10:11 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A759E4B204
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 19:10:11 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 a5-20020a656405000000b002692b7b6d95so8246959pgv.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 16:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=zsGTJXgW5L8fK7Rb/PnuJ4Hti/6f1rC6mavZcKXDQkg=;
 b=J5fPugN6vsUupQn2H9Qf1HeTHlH8cTqhAw78PkFuMo1x4Pyf1tbdFH3gSnapH2V7Tb
 yHK/MwMxXIji3ej7q2PDy97dW5OGt+VjfpL/sZecCfZ5k0W+uDdIYhPmi/Ms+tp5rULm
 C2apJxCBwVvPZTyO8O78eDXzVjzqINN7PfEUk754/kgeb68/5kJghrBk3HghzlFSfAfk
 o+BZCF3N/9CAgdWLW1qyC2phd4PcebFj2dsew8w8uar+lGkKhZNE1gS+w7G5BXdrwbKH
 zbpR5BgED738mVr4+csxM/QdPaq1eRgMzEecAjyjx9yG8tp+UY4/JT/JFExA8WCKGssI
 BlyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=zsGTJXgW5L8fK7Rb/PnuJ4Hti/6f1rC6mavZcKXDQkg=;
 b=WB4NNpnTcUtIt+QtP7xEpFq60WLS/n3JKPVgOHxqlE1XuXqTgVKbaLrazX9KdfBniW
 LGi/TIFHK/vvdYXiwYEsuntz38a3tFmGOHculF13S8LPfmiulryNowV2mYs7xKL8MGv5
 IfaJsbTK4aqvBItouhHOL0v88h+lugU/9Ytc3JBMSmveJ7bpNbDqwT+OWS2Bnbd/qul1
 2Zaa+30U4hX3tizW5AjqXMeYNvNfQKLw4XCGfve8axo3SVPQ9eUUVI7mAnB888Y18zki
 1xxqLhX/VZ/giNXLAjTXkuT1Hy8NXaLv+fOZXhErtm39MH3e3KRmIDnF6+cmmns1FRXc
 UsgA==
X-Gm-Message-State: AOAM532D0etSaFeoIUG7rEDhNgDvVtya2U6FlS3qTCJqbhUV33K+kLgs
 T7u641JqqblNf5kp/3cWI+JN8yNP6+FJ
X-Google-Smtp-Source: ABdhPJyaddiiPnuaUgOvGlBvBJQfxs6e92o1ccgM4oy+BqdSvLtyC+2KXICrdphNjiJnujNiqiShpfiEZI/5
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a65:52cd:: with SMTP id
 z13mr13056425pgp.405.1631574610889; Mon, 13 Sep 2021 16:10:10 -0700 (PDT)
Date: Mon, 13 Sep 2021 23:09:45 +0000
In-Reply-To: <20210913230955.156323-1-rananta@google.com>
Message-Id: <20210913230955.156323-5-rananta@google.com>
Mime-Version: 1.0
References: <20210913230955.156323-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v6 04/14] KVM: arm64: selftests: Introduce ARM64_SYS_KVM_REG
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
2.33.0.309.g3052b89438-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
