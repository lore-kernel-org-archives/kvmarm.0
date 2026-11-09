Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794214176;
	b=4M8nyKgPCWXMgrRlzStPTvnrg0ExsXPGkXLeOgY6YRXJWhjg8BlWSdV25IXeB2QFplKd
	 d+3UubXScMg83WmVHjUnH18noX9Y8+es895uVM7i+yCVB73Tu6Synx1KuSLqc9B0fNShI
	 Hb3K1DsmMshEQV3FxznoAyyecj0eYaUy3tmnwsi4BtkJZ79d/iFbpXRSlNb/zYAbfJnJ1
	 jGc3JhLmVN/whr6eyLyN94ENlWJJ/yQYyTtUtf4jKByCPrR8JLyKk2uthOKLcvHkxFhUl
	 AskChvvNnZZ1fbbhORGrnSCLFyZmmUg35fMc/00IVa8y6tFYQXNgK/nPmmtjjmQ5YGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794214176;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ZqLRHECtu1IbyfmzqydS0xcErU/tndix94XGkirfv30=;
	b=danbQ+jHJeDw87zeJNB7W2Oqvm3hMD4/Rj+XY501YAApbLOzZe73dwiX3Id7fhuHyETS
	 ibOYmolTZ2cxvIQdCdbjJQeIABNCdeFjjMKC+4eOLwbv8y6d4gyDDicgkNQwIKOWs0aax
	 Jm5MRWqnuryztd+1vLlwMRe6xxL5TbzUgsiiF5IymS3+1v+Mjm/4H2WkJyDmyKQjZbdQS
	 ae3UTt55imcM6H0YSp/Qth8SOHsbqfkuDHrd2JkcFj9ijnmBJvOhcy+yh0Ym1hm6GDvUk
	 pFQ5nwWg3KvrPODCr63WVeADLgo1xh/p1Jzn2PgX3b6ZEO/ZW+dc7YKkP3ZiBQKE9YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NQxKjYUn;
	arc=none smtp.remote-ip=91.218.175.50
Received: from mta0.migadu.com (out-50.mta0.migadu.com [91.218.175.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8185606A332
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 08:49:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8185606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NQxKjYUn
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=f+5i3cnibFXJG4SEb8GtpTgqVNwtOWpsHcWaN7rrewI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794214174; v=1; x=1794818974;
 b=NQxKjYUnckKOknKJv2m0bxjLW1paI30H4PpVhZOlbVKCoe30d4MJL3e3zuK8zbdv6ixF28T2
 4e43uyoR1iyzUv+6YPUlljOMwu88HhQYwmOuYvCo2TXDOSsijIPyIlPLrhRY/Ba8Q1Xk4lQ2kQ4
 Rneo6d6edZmqTUsmGqwqgTZg=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id c6b98e3bab36c25f;
	Mon, 09 Nov 2026 08:49:33 +0000
X-Mizu-Trace-ID: c6b98e3bab36c25f
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 11/19] KVM: arm64: selftests: Add pkvm_smccc hypercall test
Date: Mon,  9 Nov 2026 08:48:46 +0000
Message-ID: <20261109084854.840576-12-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261109084854.840576-1-fuad.tabba@linux.dev>
References: <20261109084854.840576-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

EL2 handles a protected guest's SMCCC calls other than PSCI rather than
forwarding them to the host. The vendor-hyp feature bitmap advertises
only FEATURES and the three memory calls.

Check SMCCC_VERSION, the vendor-hyp UID and feature bitmap, that the
calls EL2 doesn't implement (FF-A, TRNG, an unknown function) return
NOT_SUPPORTED, and that an SMC makes the guest take an UNDEF.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/arm64/pkvm_smccc.c  | 117 ++++++++++++++++++
 2 files changed, 118 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/pkvm_smccc.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 88c1159cb3bf1..6bb436bd36205 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -193,6 +193,7 @@ TEST_GEN_PROGS_arm64 += arm64/page_fault_test
 TEST_GEN_PROGS_arm64 += arm64/pkvm_host_abi
 TEST_GEN_PROGS_arm64 += arm64/pkvm_mem_share
 TEST_GEN_PROGS_arm64 += arm64/pkvm_psci
+TEST_GEN_PROGS_arm64 += arm64/pkvm_smccc
 TEST_GEN_PROGS_arm64 += arm64/psci_test
 TEST_GEN_PROGS_arm64 += arm64/sea_to_user
 TEST_GEN_PROGS_arm64 += arm64/set_id_regs
diff --git a/tools/testing/selftests/kvm/arm64/pkvm_smccc.c b/tools/testing/selftests/kvm/arm64/pkvm_smccc.c
new file mode 100644
index 0000000000000..64bfa12b26824
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/pkvm_smccc.c
@@ -0,0 +1,117 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * pkvm_smccc - the SMCCC calls EL2 handles for a protected VM, and its SMC.
+ *
+ * Copyright (C) 2025 Google LLC
+ * Author: Fuad Tabba <fuad.tabba@linux.dev>
+ */
+
+#include <linux/arm-smccc.h>
+#include <linux/bits.h>
+
+#include "kvm_util.h"
+#include "pkvm.h"
+#include "processor.h"
+#include "test_util.h"
+
+/* KVM UID 28b46fb6-2ec5-11e9-a9ca-4b564d003a74, as four SMCCC result regs. */
+#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_0	0xb66fb428U
+#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_1	0xe911c52eU
+#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2	0x564bcaa9U
+#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3	0x743a004dU
+
+/* The vendor-hyp feature bitmap EL2 advertises to protected guests. */
+#define KVM_FEATURES (					\
+	BIT(ARM_SMCCC_KVM_FUNC_FEATURES) |		\
+	BIT(ARM_SMCCC_KVM_FUNC_HYP_MEMINFO) |		\
+	BIT(ARM_SMCCC_KVM_FUNC_MEM_SHARE) |		\
+	BIT(ARM_SMCCC_KVM_FUNC_MEM_UNSHARE))
+
+#define FFA_VERSION_FUNC_ID						\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL, ARM_SMCCC_SMC_32,	\
+			   ARM_SMCCC_OWNER_STANDARD, 0x63)
+
+/* An unallocated vendor-hyp function id. */
+#define UNKNOWN_FUNC_ID							\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL, ARM_SMCCC_SMC_64,	\
+			   ARM_SMCCC_OWNER_VENDOR_HYP, 30)
+
+extern unsigned char smc_insn;
+
+static volatile u64 undef_pc;
+
+static void guest_code(void)
+{
+	struct arm_smccc_res res;
+	unsigned long ret;
+
+	pkvm_guest_init();
+
+	/* The vendor-hyp calls require SMCCC 1.1. */
+	ret = pkvm_hvc(ARM_SMCCC_VERSION_FUNC_ID, 0, 0, 0);
+	__GUEST_ASSERT((s32)ret >= ARM_SMCCC_VERSION_1_1, "SMCCC_VERSION 0x%lx", ret);
+
+	smccc_hvc(ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID, 0, 0, 0, 0, 0, 0, 0, &res);
+	GUEST_ASSERT_EQ(res.a0, ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_0);
+	GUEST_ASSERT_EQ(res.a1, ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_1);
+	GUEST_ASSERT_EQ(res.a2, ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2);
+	GUEST_ASSERT_EQ(res.a3, ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3);
+
+	ret = pkvm_hvc(ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID, 0, 0, 0);
+	GUEST_ASSERT_EQ(ret, KVM_FEATURES);
+
+	/* EL2 returns NOT_SUPPORTED for a call it doesn't implement, rather than forward it. */
+	GUEST_ASSERT_EQ(pkvm_hvc(FFA_VERSION_FUNC_ID, 0, 0, 0), SMCCC_RET_NOT_SUPPORTED);
+	GUEST_ASSERT_EQ(pkvm_hvc(ARM_SMCCC_TRNG_VERSION, 0, 0, 0), SMCCC_RET_NOT_SUPPORTED);
+	GUEST_ASSERT_EQ(pkvm_hvc(UNKNOWN_FUNC_ID, 0, 0, 0), SMCCC_RET_NOT_SUPPORTED);
+
+	GUEST_DONE();
+}
+
+static void undef_handler(struct ex_regs *regs)
+{
+	undef_pc = regs->pc;
+	regs->pc += 4;
+}
+
+/* EL2 injects an UNDEF for a protected guest's SMC. */
+static void guest_smc(void)
+{
+	pkvm_guest_init();
+
+	{
+		register u64 x0 asm("x0") = ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID;
+
+		asm volatile("smc_insn: smc #0" : "+r"(x0) : : "memory");
+	}
+	GUEST_ASSERT_EQ(undef_pc, (u64)&smc_insn);
+	GUEST_DONE();
+}
+
+static void run_guest(void *guest_code, bool smc)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = pkvm_vm_create_with_one_vcpu(&vcpu, guest_code);
+	if (smc)
+		vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT, ESR_ELx_EC_UNKNOWN, undef_handler);
+	pkvm_run_loop(vcpu, NULL);
+	kvm_vm_free(vm);
+}
+
+int main(void)
+{
+	TEST_REQUIRE(pkvm_supported());
+
+	ksft_print_header();
+	ksft_set_plan(2);
+
+	run_guest(guest_code, false);
+	ksft_test_result_pass("SMCCC surface\n");
+
+	run_guest(guest_smc, true);
+	ksft_test_result_pass("SMC takes an UNDEF\n");
+
+	ksft_finished();
+}
-- 
2.47.3

