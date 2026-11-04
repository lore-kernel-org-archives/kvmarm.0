Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.154
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782198;
	b=vE7HNSfuz+57i33nYYwKUgN7ap6dNeCrZ/n7KvxDHOhd+mVBGN7f+W712O6eXd9vHnE+
	 BIHakXlx2fYCJlVomnl5F/87BmCgcdD1ANGhSC+5aq4KF53GyUR+wYTRvB19RB8aRXiQi
	 1NQPwpCQuoLnItwmEoAx9jp4cfQW9QR5LhkNrTvQoEr8TzAXEztsVwzP95eUHr0hrGpDG
	 zuDWbT0nqWv+wl4SGjdX3XGLZqPgSTo+Oi8Q9Da0y4kkBHxkcGKDMQBilygDjKOsUwZTW
	 c/6zmZkuPJUS0wbNrDZFylMkLY8LfQe3OvgztPUDsoHEF/s24i5w8f7KC4VRc1unz/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782198;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ZqLRHECtu1IbyfmzqydS0xcErU/tndix94XGkirfv30=;
	b=WoBmIs45KXMKy7xr8J+mKeeNfupF0CRSazAAt6i7zsoDCTZLZcwP2V42MdBUzUhMBYph
	 +C9N4RIyswJmdCc7YiAUqyo1f9xRJ57Nm74MFYUHqI8tZeB05+ntv4noJFBK8Vzd85MWA
	 pzjxP/W1ermXzrBIzn6Opfjj16B3ghaPL1bwyKQ5bAP68uuH/iOHLcyEG/hbfidVglR3z
	 J5j7iDitOyFWruEyxFJrUjQQiXJ02IuLj5OZN/eBblXXykoYBFQMCTN2QIjOmrTpcM7xb
	 WD6sMDf6j87l2t9JJWZAEhUtQbsugKHuDmTy2BsWtk5S2zcRx7ZiL3yY7yb6f2LprXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YLUzwbAt;
	arc=none smtp.remote-ip=95.215.58.154
Received: from mta1.migadu.com (out-154.mta1.migadu.com [95.215.58.154])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72AC8606A329
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 08:49:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72AC8606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YLUzwbAt
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=f+5i3cnibFXJG4SEb8GtpTgqVNwtOWpsHcWaN7rrewI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793782195; v=1; x=1794386995;
 b=YLUzwbAt9vS1mFhO1bSoPI0bQm0x9rLlWr5JEn7pekmT29QZ6UxVhgGjexmvtZiIK4o2doy9
 dyHVHNH6i9oV3sb2QHZWR46Xf/s29TqtutrbzACssQaRrz0cnTbhdiYP+ljmkRU5UwhOItu3pom
 4lo+QDJUPBNZL5MWKZ7QXFgc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id b91f71648611a956;
	Wed, 04 Nov 2026 08:49:55 +0000
X-Mizu-Trace-ID: b91f71648611a956
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>,
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
Subject: [PATCH 10/16] KVM: arm64: selftests: Add pkvm_smccc hypercall test
Date: Wed,  4 Nov 2026 08:48:36 +0000
Message-ID: <20261104084842.132944-11-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104084842.132944-1-fuad.tabba@linux.dev>
References: <20261104084842.132944-1-fuad.tabba@linux.dev>
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

