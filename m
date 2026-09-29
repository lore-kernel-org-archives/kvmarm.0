Received: from mta0.migadu.com (out-37.mta0.migadu.com [91.218.175.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0904E36F5
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 09:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790672487; cv=none; b=bwMeG+TK2Ou2HfaU5J07iXEB6hmaAGRzkivX6+c7qb0z5Fuc2Fjz0npRCMq7teM0Yc+UhvNuJKjmbUJQfNd9vWU0ADYatAdzyNcdJisuwWfiQiCzL5pgljafUee9DMSst0eh29sh0Fmhg5UGhSdlnTUmJgJ1ra6qX57VzuU0L5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790672487; c=relaxed/simple;
	bh=9u1xb87yGfGazyR96ri6hSUGdO9iU79tn1MK3OJoWjI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fngVvi89KMWTB6hlQhmZxQNAt/V5y11xp9r+gbrCWDABFbHH6uuseBns6zRCqRhwlZFXuk4STFba13V9wmaB2E5pIwwV3q49wsZeXKIln5FWOMkFhmWXlxTNwewpLYC2chNj23NtNiDn2g85+J+eDu3sNhlaD9f6EN7Hi0btcjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eUjol+GI; arc=none smtp.client-ip=91.218.175.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eUjol+GI"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=9u1xb87yGfGazyR96ri6hSUGdO9iU79tn1MK3OJoWjI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790672483; v=1; x=1791277283;
 b=eUjol+GI/vZmVtUYQtJOjOyU6H1WzxwpjObLOgva+y+7YDk0RbRu+wZvHzoc/SugoXilQH1C
 wt4WgGaCQnmN4yHcihVgJpESiAtJvY4P1nnFh8rH+0+jrt20pi9M2xXwyDM2tITFopN3JWS68bW
 F3TH1vznqLLDRZ5XyXjS0458=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id cd8c479a161a7a38;
	Tue, 29 Sep 2026 09:01:23 +0000
X-Mizu-Trace-ID: cd8c479a161a7a38
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Quentin Perret <qperret@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Venkata Rao Kakani <venkata.kakani@oss.qualcomm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/4] KVM: arm64: selftests: Check a feature hidden in an ID register is UNDEF
Date: Tue, 29 Sep 2026 10:00:31 +0100
Message-Id: <20260929090031.3829185-5-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260929090031.3829185-1-fuad.tabba@linux.dev>
References: <20260929090031.3829185-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Userspace can hide a feature from a guest by clearing its field in a
writable ID register, and KVM then makes the feature's instructions
UNDEFINED in the guest by trapping or disabling them. No selftest checks
that.

Add a test that runs the instruction of each of TLBI OS, MOPS, TCR2_EL1
and FPMR once with its field as advertised and once with it cleared, and
expects an UNDEF only when cleared. A feature the vCPU doesn't advertise
is skipped, as is hidden TLBI OS on a CPU with neither FGT nor
FEAT_EVT2, where KVM can't trap it.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/arm64/hidden_features.c     | 184 ++++++++++++++++++
 2 files changed, 185 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/hidden_features.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 96bab7002d39e..864fdca7f362e 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -194,6 +194,7 @@ TEST_GEN_PROGS_arm64 += arm64/vgic_v5
 TEST_GEN_PROGS_arm64 += arm64/vpmu_counter_access
 TEST_GEN_PROGS_arm64 += arm64/no-vgic
 TEST_GEN_PROGS_arm64 += arm64/idreg-idst
+TEST_GEN_PROGS_arm64 += arm64/hidden_features
 TEST_GEN_PROGS_arm64 += arm64/kvm-uuid
 TEST_GEN_PROGS_arm64 += access_tracking_perf_test
 TEST_GEN_PROGS_arm64 += arch_timer
diff --git a/tools/testing/selftests/kvm/arm64/hidden_features.c b/tools/testing/selftests/kvm/arm64/hidden_features.c
new file mode 100644
index 0000000000000..194d746e7605e
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/hidden_features.c
@@ -0,0 +1,184 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * hidden_features - Check that a feature's instruction runs in the guest when
+ * its ID register field is advertised, and is UNDEFINED when userspace clears
+ * the field.
+ *
+ * Copyright (c) 2026 Google LLC
+ * Author: Fuad Tabba <fuad.tabba@linux.dev>
+ */
+#include "kvm_util.h"
+#include "processor.h"
+#include "test_util.h"
+
+static volatile bool undef;
+
+static void guest_tlbi_os(void)
+{
+	/* tlbi vmalle1os */
+	asm volatile("sys #0, c8, c1, #0\n\tdsb ish\n\tisb" ::: "memory");
+}
+
+static void guest_mops(void)
+{
+	register u64 *d asm("x0");
+	register u64 n asm("x1");
+	register u64 s asm("x2");
+	u64 buf[8];
+
+	d = buf;
+	n = sizeof(buf);
+	s = 0;
+	/* setp [x0]!, x1!, x2; setm; sete */
+	asm volatile(".inst 0x19c20420\n\t.inst 0x19c24420\n\t.inst 0x19c28420"
+		     : "+r"(d), "+r"(n) : "r"(s) : "cc", "memory");
+}
+
+static void guest_tcr2(void)
+{
+	read_sysreg_s(SYS_TCR2_EL1);
+}
+
+static void guest_fpmr(void)
+{
+	read_sysreg_s(SYS_FPMR);
+}
+
+struct feature {
+	const char *name;
+	u64 id_reg;
+	u64 mask;
+	u8 shift;
+	u64 min;
+	void (*insn)(void);
+	bool (*trappable)(struct kvm_vcpu *vcpu);
+};
+
+/* Without FGT, KVM traps a hidden TLBI OS only through HCR_EL2.TTLBOS (FEAT_EVT2). */
+static bool tlbi_os_trappable(struct kvm_vcpu *vcpu)
+{
+	u64 mmfr0 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR0_EL1));
+	u64 mmfr2 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR2_EL1));
+
+	return SYS_FIELD_GET(ID_AA64MMFR0_EL1, FGT, mmfr0) >= ID_AA64MMFR0_EL1_FGT_IMP ||
+	       SYS_FIELD_GET(ID_AA64MMFR2_EL1, EVT, mmfr2) >= ID_AA64MMFR2_EL1_EVT_TTLBxS;
+}
+
+#define FEATURE(n, reg, field, min_val, fn, trap)		\
+{								\
+	.name		= n,					\
+	.id_reg		= SYS_##reg,				\
+	.mask		= reg##_##field##_MASK,			\
+	.shift		= reg##_##field##_SHIFT,		\
+	.min		= reg##_##field##_##min_val,		\
+	.insn		= fn,					\
+	.trappable	= trap,					\
+}
+
+static const struct feature features[] = {
+	FEATURE("TLBI OS", ID_AA64ISAR0_EL1, TLB, OS, guest_tlbi_os, tlbi_os_trappable),
+	FEATURE("MOPS", ID_AA64ISAR2_EL1, MOPS, IMP, guest_mops, NULL),
+	FEATURE("TCR2_EL1", ID_AA64MMFR3_EL1, TCRX, IMP, guest_tcr2, NULL),
+	FEATURE("FPMR", ID_AA64PFR2_EL1, FPMR, IMP, guest_fpmr, NULL),
+};
+
+static void guest_code(const struct feature *feat)
+{
+	undef = false;
+	feat->insn();
+	GUEST_SYNC(undef);
+	GUEST_DONE();
+}
+
+static void guest_undef_handler(struct ex_regs *regs)
+{
+	undef = true;
+	regs->pc += 4;
+}
+
+static bool run(const struct feature *feat, bool hide)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+	bool got = false;
+	u64 val;
+
+	vm = vm_create_with_one_vcpu(&vcpu, (void *)guest_code);
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vcpu);
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT, ESR_ELx_EC_UNKNOWN, guest_undef_handler);
+	vcpu_args_set(vcpu, 1, feat);
+
+	if (hide) {
+		val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(feat->id_reg));
+		vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(feat->id_reg), val & ~feat->mask);
+	}
+
+	for (;;) {
+		vcpu_run(vcpu);
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			got = uc.args[1];
+			break;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		case UCALL_DONE:
+			kvm_vm_free(vm);
+			return got;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	}
+}
+
+static void probe_feature(const struct feature *feat, bool *present, bool *trappable)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	u64 val;
+
+	vm = vm_create_with_one_vcpu(&vcpu, NULL);
+	val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(feat->id_reg));
+	*present = ((val & feat->mask) >> feat->shift) >= feat->min;
+	*trappable = !feat->trappable || feat->trappable(vcpu);
+	kvm_vm_free(vm);
+}
+
+int main(void)
+{
+	const struct feature *feat;
+	bool present, trappable;
+	int i;
+
+	test_disable_default_vgic();
+
+	ksft_print_header();
+	ksft_set_plan(ARRAY_SIZE(features) * 2);
+
+	for (i = 0; i < ARRAY_SIZE(features); i++) {
+		feat = &features[i];
+
+		probe_feature(feat, &present, &trappable);
+		if (!present) {
+			ksft_test_result_skip("%s advertised, not supported\n", feat->name);
+			ksft_test_result_skip("%s hidden, not supported\n", feat->name);
+			continue;
+		}
+
+		if (run(feat, false))
+			ksft_test_result_fail("%s advertised, UNDEF\n", feat->name);
+		else
+			ksft_test_result_pass("%s advertised\n", feat->name);
+
+		if (!trappable)
+			ksft_test_result_skip("%s hidden, not trappable\n", feat->name);
+		else if (run(feat, true))
+			ksft_test_result_pass("%s hidden\n", feat->name);
+		else
+			ksft_test_result_fail("%s hidden, no UNDEF\n", feat->name);
+	}
+
+	ksft_finished();
+}
-- 
2.39.5

