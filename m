Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E8C14AB3
	for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 19:24:45 +0000 (UTC)
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-55c1c7f872bso3771828a12.1
        for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 12:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689017084; x=1691609084;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f6NXlz6D/782SdBzr3IeFN6HXvUmoGCjaw12aI23xnw=;
        b=QaWI7OqJmI9M8bM1aj3NsLqaCx1I5k6gpphm8NxsBbY8FHuucsWWTeL8iN2yV1FXVb
         TqxFd8gqyRQCX/8ObyZ475vmft1DSuu+wKcaOCTFIvb/qakIqDzlJtZyW4zH8Z48htEB
         7q0uleRZWSS1zQOz7FK5QukaTfWoOKy0ERUmO+w5zWUmDsYLLjghn8bjIBqgP68FSuL0
         enjGoL11dA8v2Xmb6/fKAZeict/e+bv/j2Cn6S+4nNEj6L56SBJVAvfbZealQEU2DP8z
         tpZeptlRL8LohFO4CVrHvomh89oBZ6SpNqnO0vcS+ei90fzoPjqvfmwgtiHIDAi06wO2
         C4Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689017084; x=1691609084;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f6NXlz6D/782SdBzr3IeFN6HXvUmoGCjaw12aI23xnw=;
        b=TzMZxK1tTiN9LUjePs0MxV7NlUCIKcqA3+B18ZmPJQQPspl9wO//PlYo7teF2PegdM
         9+4xNAK07p/7cF6mBdsmlwHsFsyLdb/7ElBcqWa3dck2cQPjFjVbcaB1LPwEOtwF5LBB
         AtF+VvpaQ/xcNyyr16MBjKAK7znHSKAaPBGGItiUeWYspquP2e2TRHXnkFiYoxGsQU8I
         6slA/+EMMypwnwbMYrB7qrIIsi3vgsOZs8Yn3A2sWFwMCWROsfgf5UTj2XcWRRVIk9ND
         ZcvD6sTkYUBd6DBvTMUWOr5pIqTXhgRz5NMWUjGfsm0RbqQ6oCBdrQ9zWA/DLa/rCm98
         i9Hw==
X-Gm-Message-State: ABy/qLb14fLfVnKmOt/Z6kc0zJvbYpWPNeBzM4gUteeLyXnuAxvHamDS
	zb1HDwnpLfQQxN3pH6xS5u6+E7Ou1Iv0rg75Hw==
X-Google-Smtp-Source: APBJJlHVokzEZ9a7PsT83p+FFKlLBIrwwQbGiY4jiVEL9w49sYETLgIQpfTACCighGl5sfBJLgZT02e1kg6SYA4k/Q==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:d2cd:b0:1b8:929f:1990 with
 SMTP id n13-20020a170902d2cd00b001b8929f1990mr12756961plc.6.1689017084698;
 Mon, 10 Jul 2023 12:24:44 -0700 (PDT)
Date: Mon, 10 Jul 2023 19:24:29 +0000
In-Reply-To: <20230710192430.1992246-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230710192430.1992246-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230710192430.1992246-7-jingzhangos@google.com>
Subject: [PATCH v5 6/6] KVM: arm64: selftests: Test for setting ID register
 from usersapce
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Suraj Jitindar Singh <surajjs@amazon.com>, Cornelia Huck <cohuck@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a test to verify setting ID registers from userapce is handled
correctly by KVM.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/set_id_regs.c       | 163 ++++++++++++++++++
 2 files changed, 164 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/set_id_regs.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index c692cc86e7da..87ceadc1292a 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -144,6 +144,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 += aarch64/hypercalls
 TEST_GEN_PROGS_aarch64 += aarch64/page_fault_test
 TEST_GEN_PROGS_aarch64 += aarch64/psci_test
+TEST_GEN_PROGS_aarch64 += aarch64/set_id_regs
 TEST_GEN_PROGS_aarch64 += aarch64/smccc_filter
 TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
new file mode 100644
index 000000000000..e2242ef36bab
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
@@ -0,0 +1,163 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * set_id_regs - Test for setting ID register from usersapce.
+ *
+ * Copyright (c) 2023 Google LLC.
+ *
+ *
+ * Test that KVM supports setting ID registers from userspace and handles the
+ * feature set correctly.
+ */
+
+#include <stdint.h>
+#include "kvm_util.h"
+#include "processor.h"
+#include "test_util.h"
+#include <linux/bitfield.h>
+
+#define field_get(_mask, _reg) (((_reg) & (_mask)) >> (ffs(_mask) - 1))
+#define field_prep(_mask, _val) (((_val) << (ffs(_mask) - 1)) & (_mask))
+
+struct reg_feature {
+	uint64_t reg;
+	uint64_t ftr_mask;
+};
+
+static void guest_code(void)
+{
+	for (;;)
+		GUEST_SYNC(0);
+}
+
+static struct reg_feature lower_safe_reg_ftrs[] = {
+	{ KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), ARM64_FEATURE_MASK(ID_AA64DFR0_BRPS) },
+	{ KVM_ARM64_SYS_REG(SYS_ID_DFR0_EL1), ARM64_FEATURE_MASK(ID_DFR0_COPDBG) },
+	{ KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), ARM64_FEATURE_MASK(ID_AA64PFR0_EL3) },
+	{ KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR0_EL1), ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN4) },
+};
+
+static void test_user_set_lower_safe(struct kvm_vcpu *vcpu)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(lower_safe_reg_ftrs); i++) {
+		struct reg_feature *reg_ftr = lower_safe_reg_ftrs + i;
+		uint64_t val, new_val, ftr;
+
+		vcpu_get_reg(vcpu, reg_ftr->reg, &val);
+		ftr = field_get(reg_ftr->ftr_mask, val);
+
+		/* Set a safe value for the feature */
+		if (ftr > 0)
+			ftr--;
+
+		val &= ~reg_ftr->ftr_mask;
+		val |= field_prep(reg_ftr->ftr_mask, ftr);
+
+		vcpu_set_reg(vcpu, reg_ftr->reg, val);
+		vcpu_get_reg(vcpu, reg_ftr->reg, &new_val);
+		ASSERT_EQ(new_val, val);
+	}
+}
+
+static struct reg_feature exact_reg_ftrs[] = {
+	{ KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER) },
+};
+
+static void test_user_set_exact(struct kvm_vcpu *vcpu)
+{
+	int i, r;
+
+	for (i = 0; i < ARRAY_SIZE(exact_reg_ftrs); i++) {
+		struct reg_feature *reg_ftr = exact_reg_ftrs + i;
+		uint64_t val, old_val, ftr;
+
+		vcpu_get_reg(vcpu, reg_ftr->reg, &val);
+		ftr = field_get(reg_ftr->ftr_mask, val);
+		old_val = val;
+
+		/* Exact match */
+		vcpu_set_reg(vcpu, reg_ftr->reg, val);
+		vcpu_get_reg(vcpu, reg_ftr->reg, &val);
+		ASSERT_EQ(val, old_val);
+
+		/* Smaller value */
+		if (ftr > 0)
+			ftr--;
+		val &= ~reg_ftr->ftr_mask;
+		val |= field_prep(reg_ftr->ftr_mask, ftr);
+		r = __vcpu_set_reg(vcpu, reg_ftr->reg, val);
+		TEST_ASSERT(r < 0 && errno == EINVAL,
+			    "Unexpected KVM_SET_ONE_REG error: r=%d, errno=%d", r, errno);
+		vcpu_get_reg(vcpu, reg_ftr->reg, &val);
+		ASSERT_EQ(val, old_val);
+
+		/* Bigger value */
+		ftr += 2;
+		val &= ~reg_ftr->ftr_mask;
+		val |= field_prep(reg_ftr->ftr_mask, ftr);
+		r = __vcpu_set_reg(vcpu, reg_ftr->reg, val);
+		TEST_ASSERT(r < 0 && errno == EINVAL,
+			    "Unexpected KVM_SET_ONE_REG error: r=%d, errno=%d", r, errno);
+		vcpu_get_reg(vcpu, reg_ftr->reg, &val);
+		ASSERT_EQ(val, old_val);
+	}
+}
+
+static struct reg_feature fail_reg_ftrs[] = {
+	{ KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), ARM64_FEATURE_MASK(ID_AA64DFR0_WRPS) },
+	{ KVM_ARM64_SYS_REG(SYS_ID_DFR0_EL1), ARM64_FEATURE_MASK(ID_DFR0_MPROFDBG) },
+	{ KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), ARM64_FEATURE_MASK(ID_AA64PFR0_EL2) },
+	{ KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR0_EL1), ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN64) },
+};
+
+static void test_user_set_fail(struct kvm_vcpu *vcpu)
+{
+	int i, r;
+
+	for (i = 0; i < ARRAY_SIZE(fail_reg_ftrs); i++) {
+		struct reg_feature *reg_ftr = fail_reg_ftrs + i;
+		uint64_t val, old_val, ftr;
+
+		vcpu_get_reg(vcpu, reg_ftr->reg, &val);
+		ftr = field_get(reg_ftr->ftr_mask, val);
+
+		/* Set a invalid value (too big) for the feature */
+		ftr++;
+
+		old_val = val;
+		val &= ~reg_ftr->ftr_mask;
+		val |= field_prep(reg_ftr->ftr_mask, ftr);
+
+		r = __vcpu_set_reg(vcpu, reg_ftr->reg, val);
+		TEST_ASSERT(r < 0 && errno == EINVAL,
+			    "Unexpected KVM_SET_ONE_REG error: r=%d, errno=%d", r, errno);
+
+		vcpu_get_reg(vcpu, reg_ftr->reg, &val);
+		ASSERT_EQ(val, old_val);
+	}
+}
+
+int main(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+
+	ksft_print_header();
+	ksft_set_plan(3);
+
+	test_user_set_lower_safe(vcpu);
+	ksft_test_result_pass("test_user_set_lower_safe\n");
+
+	test_user_set_exact(vcpu);
+	ksft_test_result_pass("test_user_set_exact\n");
+
+	test_user_set_fail(vcpu);
+	ksft_test_result_pass("test_user_set_fail\n");
+
+	kvm_vm_free(vm);
+
+	ksft_finished();
+}
-- 
2.41.0.255.g8b1d071c50-goog

