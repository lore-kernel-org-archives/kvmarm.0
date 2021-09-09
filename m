Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 292C4C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 01:39:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D50CF6113E
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 01:39:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D50CF6113E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8834C4AC80;
	Wed,  8 Sep 2021 21:39:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Vbgx4FTdlbJm; Wed,  8 Sep 2021 21:39:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6453B4B0C5;
	Wed,  8 Sep 2021 21:39:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D48304029C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 21:39:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8QE0FfApZp8D for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Sep 2021 21:39:06 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C0BF24B0C5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 21:39:05 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 mm23-20020a17090b359700b00185945eae0eso301494pjb.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Sep 2021 18:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=fhJBhdTI7Fph8U8UIbebfbsbJEo/+U9ZAKdtVVmT0OQ=;
 b=rP8SFpJgPxh5O3rCo7DlGcKTQcyeoV5/8Amp4gBI8kJiTtJgE1jEuvY/WmpuCQuFdw
 Ol5TEtCV7UxcmNrgAiMoi3ZMFJ1fOL13rECQ6SDHrCnAeHftRvScWKwQtdAh/m1WnwBM
 AwAxJjd4jVZyvg9I3pCCNJufENKS7X9OPjXgh/rNbDIhZ/1NRb7Pb0dZtZL3x0FIoTZw
 WWe9GS21MN2Co959shkpEpn3GO2WxfKW9VfGk06hr770AF+kqaBAsT4Mag16JXd3a5tB
 tOxYrzOzi7UY+KbUpcEPORumjkWyN7gqFlEMSY+ox4pDYJlSUGlLD8U5xqmXzHYzI9mR
 9Khg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=fhJBhdTI7Fph8U8UIbebfbsbJEo/+U9ZAKdtVVmT0OQ=;
 b=0k9Dck3Vli4coQOt6OVWuaha+Rbnui5vsqwz95FRx2Zv161+pxOl7MXrqeum1xKDNL
 TSVdwZ8F5YNhDICbn9lE+9Ya41kKTmPko+fqK3hkSgrlN8UC0nDG0AjBFJ9MdlTUtNhi
 spp9HFTmaEEnWvKSGmu/ob5lk9ZBlrEuUupP7UTrljIr9+fmVdNxC8p/cvLPJ+qLAwgv
 18z/aW95lFR5lmFrAqZYtsw/rCf9auIpJgGznMiVPvgqwvXLRHHzIh8uLNjRKLrU7tG6
 +38iUdcX20S/zWqO4kyXO7mcnJYLUrJmdRzZg0uRVbydV+d+55ULhGbnLSg3vo/MxIbO
 UPFA==
X-Gm-Message-State: AOAM5320k6XqOQ484h+cgwS5s72I0MXaxUb3fhYsFqDFoFT0YwzYUhEi
 9jXutcu5+8vl0OkCAfyBSjBRZ/ruNQDd
X-Google-Smtp-Source: ABdhPJy1lNBcGsIrqRNLwlUOtJjNJsPjnKdPd3b+kR3weBs5ZRkHHcD0ZUb/rO+VqjVCBrvKm12LfqSuKHJa
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90b:fd7:: with SMTP id
 gd23mr51155pjb.1.1631151544636; Wed, 08 Sep 2021 18:39:04 -0700 (PDT)
Date: Thu,  9 Sep 2021 01:38:17 +0000
In-Reply-To: <20210909013818.1191270-1-rananta@google.com>
Message-Id: <20210909013818.1191270-18-rananta@google.com>
Mime-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v4 17/18] KVM: arm64: selftests: Replace ARM64_SYS_REG with
 ARM64_SYS_KVM_REG
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

With the introduction of ARM64_SYS_KVM_REG, that takes the
system register encodings from sysreg.h directly, replace
all the users of ARM64_SYS_REG, relyiing on the encodings
created in processor.h, with ARM64_SYS_KVM_REG.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c     |  2 +-
 .../selftests/kvm/aarch64/psci_cpu_on_test.c     |  3 ++-
 .../selftests/kvm/include/aarch64/processor.h    | 10 ----------
 .../selftests/kvm/lib/aarch64/processor.c        | 16 ++++++++--------
 4 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 11fd23e21cb4..b28b311f4dd7 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -190,7 +190,7 @@ static int debug_version(struct kvm_vm *vm)
 {
 	uint64_t id_aa64dfr0;
 
-	get_reg(vm, VCPU_ID, ARM64_SYS_REG(ID_AA64DFR0_EL1), &id_aa64dfr0);
+	get_reg(vm, VCPU_ID, ARM64_SYS_KVM_REG(SYS_ID_AA64DFR0_EL1), &id_aa64dfr0);
 	return id_aa64dfr0 & 0xf;
 }
 
diff --git a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
index 018c269990e1..4c8aa7b8a65d 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
@@ -91,7 +91,8 @@ int main(void)
 	init.features[0] |= (1 << KVM_ARM_VCPU_POWER_OFF);
 	aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_main);
 
-	get_reg(vm, VCPU_ID_TARGET, ARM64_SYS_REG(MPIDR_EL1), &target_mpidr);
+	get_reg(vm, VCPU_ID_TARGET,
+		ARM64_SYS_KVM_REG(SYS_MPIDR_EL1), &target_mpidr);
 	vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
 	vcpu_run(vm, VCPU_ID_SOURCE);
 
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 150f63101f4c..ee81dd3db516 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -16,16 +16,6 @@
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
-
 /*
  * ARM64_SYS_KVM_REG(sys_reg_id): Helper macro to convert
  * SYS_* register definitions in sysreg.h to use in KVM
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 9844b62227b1..d7b89aa092f5 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -240,10 +240,10 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
 	 * Enable FP/ASIMD to avoid trapping when accessing Q0-Q15
 	 * registers, which the variable argument list macros do.
 	 */
-	set_reg(vm, vcpuid, ARM64_SYS_REG(CPACR_EL1), 3 << 20);
+	set_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_CPACR_EL1), 3 << 20);
 
-	get_reg(vm, vcpuid, ARM64_SYS_REG(SCTLR_EL1), &sctlr_el1);
-	get_reg(vm, vcpuid, ARM64_SYS_REG(TCR_EL1), &tcr_el1);
+	get_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_SCTLR_EL1), &sctlr_el1);
+	get_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_TCR_EL1), &tcr_el1);
 
 	switch (vm->mode) {
 	case VM_MODE_P52V48_4K:
@@ -281,10 +281,10 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
 	tcr_el1 |= (1 << 8) | (1 << 10) | (3 << 12);
 	tcr_el1 |= (64 - vm->va_bits) /* T0SZ */;
 
-	set_reg(vm, vcpuid, ARM64_SYS_REG(SCTLR_EL1), sctlr_el1);
-	set_reg(vm, vcpuid, ARM64_SYS_REG(TCR_EL1), tcr_el1);
-	set_reg(vm, vcpuid, ARM64_SYS_REG(MAIR_EL1), DEFAULT_MAIR_EL1);
-	set_reg(vm, vcpuid, ARM64_SYS_REG(TTBR0_EL1), vm->pgd);
+	set_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_SCTLR_EL1), sctlr_el1);
+	set_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_TCR_EL1), tcr_el1);
+	set_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_MAIR_EL1), DEFAULT_MAIR_EL1);
+	set_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_TTBR0_EL1), vm->pgd);
 }
 
 void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
@@ -370,7 +370,7 @@ void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid)
 {
 	extern char vectors;
 
-	set_reg(vm, vcpuid, ARM64_SYS_REG(VBAR_EL1), (uint64_t)&vectors);
+	set_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_VBAR_EL1), (uint64_t)&vectors);
 }
 
 void route_exception(struct ex_regs *regs, int vector)
-- 
2.33.0.153.gba50c8fa24-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
