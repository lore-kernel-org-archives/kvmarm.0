Return-Path: <SRS0=np2t=GI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C5BDC433E6
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 16:37:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D936922CB8
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 16:37:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D936922CB8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E9C54B297;
	Tue,  5 Jan 2021 11:37:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZuA2cX7agRea; Tue,  5 Jan 2021 11:37:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B7E44B331;
	Tue,  5 Jan 2021 11:37:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BBC14B30B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 11:37:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ra1+vQdo7UHX for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jan 2021 11:37:09 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE66E4B348
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 11:37:09 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 79BA7143D;
 Tue,  5 Jan 2021 08:37:09 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.195.35])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 984EB3F70D;
 Tue,  5 Jan 2021 08:37:07 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Ard Biesheuvel <ardb@kernel.org>, Russell King <linux@armlinux.org.uk>,
 Marc Zyngier <maz@kernel.org>
Subject: [PATCH v5 5/5] KVM: arm64: implement the TRNG hypervisor call
Date: Tue,  5 Jan 2021 16:36:52 +0000
Message-Id: <20210105163652.23646-6-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210105163652.23646-1-andre.przywara@arm.com>
References: <20210105163652.23646-1-andre.przywara@arm.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Theodore Ts'o <tytso@mit.edu>, Linus Walleij <linus.walleij@linaro.org>,
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
 Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.cs.columbia.edu,
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: Ard Biesheuvel <ardb@kernel.org>

Provide a hypervisor implementation of the ARM architected TRNG firmware
interface described in ARM spec DEN0098. All function IDs are implemented,
including both 32-bit and 64-bit versions of the TRNG_RND service, which
is the centerpiece of the API.

The API is backed by the kernel's entropy pool only, to avoid guests
draining more precious direct entropy sources.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
[Andre: minor fixes, drop arch_get_random() usage]
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 +
 arch/arm64/kvm/Makefile           |  2 +-
 arch/arm64/kvm/hypercalls.c       |  6 +++
 arch/arm64/kvm/trng.c             | 85 +++++++++++++++++++++++++++++++
 4 files changed, 94 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/trng.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 11beda85ee7e..271c79914afd 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -748,4 +748,6 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 #define kvm_vcpu_has_pmu(vcpu)					\
 	(test_bit(KVM_ARM_VCPU_PMU_V3, (vcpu)->arch.features))
 
+int kvm_trng_call(struct kvm_vcpu *vcpu);
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 60fd181df624..8d2b9984ac36 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -16,7 +16,7 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
 	 inject_fault.o va_layout.o handle_exit.o \
 	 guest.o debug.o reset.o sys_regs.o \
 	 vgic-sys-reg-v3.o fpsimd.o pmu.o \
-	 arch_timer.o \
+	 arch_timer.o trng.o\
 	 vgic/vgic.o vgic/vgic-init.o \
 	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
 	 vgic/vgic-v3.o vgic/vgic-v4.o \
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 25ea4ecb6449..ead21b98b620 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -71,6 +71,12 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		if (gpa != GPA_INVALID)
 			val = gpa;
 		break;
+	case ARM_SMCCC_TRNG_VERSION:
+	case ARM_SMCCC_TRNG_FEATURES:
+	case ARM_SMCCC_TRNG_GET_UUID:
+	case ARM_SMCCC_TRNG_RND32:
+	case ARM_SMCCC_TRNG_RND64:
+		return kvm_trng_call(vcpu);
 	default:
 		return kvm_psci_call(vcpu);
 	}
diff --git a/arch/arm64/kvm/trng.c b/arch/arm64/kvm/trng.c
new file mode 100644
index 000000000000..99bdd7103c9c
--- /dev/null
+++ b/arch/arm64/kvm/trng.c
@@ -0,0 +1,85 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2020 Arm Ltd.
+
+#include <linux/arm-smccc.h>
+#include <linux/kvm_host.h>
+
+#include <asm/kvm_emulate.h>
+
+#include <kvm/arm_hypercalls.h>
+
+#define ARM_SMCCC_TRNG_VERSION_1_0	0x10000UL
+
+/* Those values are deliberately separate from the generic SMCCC definitions. */
+#define TRNG_SUCCESS			0UL
+#define TRNG_NOT_SUPPORTED		((unsigned long)-1)
+#define TRNG_INVALID_PARAMETER		((unsigned long)-2)
+#define TRNG_NO_ENTROPY			((unsigned long)-3)
+
+#define TRNG_MAX_BITS64			192
+
+static const uuid_t arm_smc_trng_uuid __aligned(4) = UUID_INIT(
+	0x0d21e000, 0x4384, 0x11eb, 0x80, 0x70, 0x52, 0x44, 0x55, 0x4e, 0x5a, 0x4c);
+
+static int kvm_trng_do_rnd(struct kvm_vcpu *vcpu, int size)
+{
+	DECLARE_BITMAP(bits, TRNG_MAX_BITS64);
+	u32 num_bits = smccc_get_arg1(vcpu);
+	int i;
+
+	if (num_bits > 3 * size) {
+		smccc_set_retval(vcpu, TRNG_INVALID_PARAMETER, 0, 0, 0);
+		return 1;
+	}
+
+	/* get as many bits as we need to fulfil the request */
+	for (i = 0; i < DIV_ROUND_UP(num_bits, BITS_PER_LONG); i++)
+		bits[i] = get_random_long();
+
+	bitmap_clear(bits, num_bits, TRNG_MAX_BITS64 - num_bits);
+
+	if (size == 32)
+		smccc_set_retval(vcpu, TRNG_SUCCESS, lower_32_bits(bits[1]),
+				 upper_32_bits(bits[0]), lower_32_bits(bits[0]));
+	else
+		smccc_set_retval(vcpu, TRNG_SUCCESS, bits[2], bits[1], bits[0]);
+
+	memzero_explicit(bits, sizeof(bits));
+	return 1;
+}
+
+int kvm_trng_call(struct kvm_vcpu *vcpu)
+{
+	const __le32 *u = (__le32 *)arm_smc_trng_uuid.b;
+	u32 func_id = smccc_get_function(vcpu);
+	unsigned long val = TRNG_NOT_SUPPORTED;
+	int size = 64;
+
+	switch (func_id) {
+	case ARM_SMCCC_TRNG_VERSION:
+		val = ARM_SMCCC_TRNG_VERSION_1_0;
+		break;
+	case ARM_SMCCC_TRNG_FEATURES:
+		switch (smccc_get_arg1(vcpu)) {
+		case ARM_SMCCC_TRNG_VERSION:
+		case ARM_SMCCC_TRNG_FEATURES:
+		case ARM_SMCCC_TRNG_GET_UUID:
+		case ARM_SMCCC_TRNG_RND32:
+		case ARM_SMCCC_TRNG_RND64:
+			val = TRNG_SUCCESS;
+		}
+		break;
+	case ARM_SMCCC_TRNG_GET_UUID:
+		smccc_set_retval(vcpu, le32_to_cpu(u[0]), le32_to_cpu(u[1]),
+				 le32_to_cpu(u[2]), le32_to_cpu(u[3]));
+		return 1;
+	case ARM_SMCCC_TRNG_RND32:
+		size = 32;
+		fallthrough;
+	case ARM_SMCCC_TRNG_RND64:
+		return kvm_trng_do_rnd(vcpu, size);
+	}
+
+	smccc_set_retval(vcpu, val, 0, 0, 0);
+	return 1;
+}
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
