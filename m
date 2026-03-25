Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCCEE1F4168
	for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 00:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774399066; cv=none; b=deSVvzFgsV6cQNPzCp0AtVja8dbGFzJ93AP/EIYBdEvnIn8TUaQYAL0i5ZfPlxIUd2x9BIxS9EaiA5Q+l9iYZGpK6Izw25nVMnz1j5N6/loeixfI0CjlPc9IFAiYCgmM17jUlEbC4/pJ8XAPXJ8+uRxXu6LhMYBHDWls/uns0vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774399066; c=relaxed/simple;
	bh=r2NqJqtxMzptltCE+GymYSs9aCU3DPcd19M/MmyWskE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWUrItHjWNxDhpJle/5qB6bKzPZCDNbh3ld68DCafOk7ebev8LVFdWhf2f2HqFUlZI9LM/oWyvRQhQKk0xaEb7A97LCHcRhzh7dma3xrEb34eIkBHcwiJuXFzlTEFeBsx7sn5LuL7/2LHlSRcIlNIhixLsfahDbrU3TcVNy0VPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IXGXS+yk; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IXGXS+yk"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6C82A1C0A;
	Tue, 24 Mar 2026 17:37:38 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 380233FB90;
	Tue, 24 Mar 2026 17:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774399064; bh=r2NqJqtxMzptltCE+GymYSs9aCU3DPcd19M/MmyWskE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IXGXS+ykBFLyiBA3As/Eqt2T1yCIqKBQCggrqBgjYnb6sfzOlJ9y3rqp5FIAOB6gb
	 jIdZXjLGF6flg57RCzDbANEG7hahqs4hSAhbGwjg0A+O6xyXZoiK0O4TdYPhw1JiSh
	 SsEzrofyk+2laz8DFG/BqAOD8i45Vwh7xOU+pBNY=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 2/3] KVM: arm64: sefltests: Add basic NV selftest
Date: Wed, 25 Mar 2026 00:36:19 +0000
Message-ID: <20260325003620.2214766-3-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260325003620.2214766-1-weilin.chang@arm.com>
References: <20260325003620.2214766-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a simple NV selftest that uses the NV library functions to eret from
vEL2 to EL1, then call an hvc to jump back to vEL2.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |  1 +
 .../selftests/kvm/arm64/hello_nested.c        | 65 +++++++++++++++++++
 2 files changed, 66 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/hello_nested.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 5e681e8e0cd7..d7499609cd0c 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -167,6 +167,7 @@ TEST_GEN_PROGS_arm64 += arm64/arch_timer_edge_cases
 TEST_GEN_PROGS_arm64 += arm64/at
 TEST_GEN_PROGS_arm64 += arm64/debug-exceptions
 TEST_GEN_PROGS_arm64 += arm64/hello_el2
+TEST_GEN_PROGS_arm64 += arm64/hello_nested
 TEST_GEN_PROGS_arm64 += arm64/host_sve
 TEST_GEN_PROGS_arm64 += arm64/hypercalls
 TEST_GEN_PROGS_arm64 += arm64/external_aborts
diff --git a/tools/testing/selftests/kvm/arm64/hello_nested.c b/tools/testing/selftests/kvm/arm64/hello_nested.c
new file mode 100644
index 000000000000..16c600539810
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/hello_nested.c
@@ -0,0 +1,65 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * hello_nested - Go from vEL2 to EL1 then back
+ */
+#include "kvm_util.h"
+#include "nested.h"
+#include "processor.h"
+#include "test_util.h"
+#include "ucall.h"
+
+static void l2_guest_code(void)
+{
+	/* nothing */
+}
+
+static void guest_code(void)
+{
+	GUEST_ASSERT_EQ(get_current_el(), 2);
+	GUEST_PRINTF("vEL2 entry\n");
+	run_l2();
+	GUEST_DONE();
+}
+
+int main(void)
+{
+	struct kvm_vcpu_init init;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_ARM_EL2));
+	vm = vm_create(1);
+
+	kvm_get_default_vcpu_target(vm, &init);
+	init.features[0] |= BIT(KVM_ARM_VCPU_HAS_EL2);
+	vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
+	kvm_arch_vm_finalize_vcpus(vm);
+
+	prepare_l2_stack(vm, vcpu);
+	prepare_hyp_state(vm, vcpu);
+	prepare_eret_destination(vm, vcpu, l2_guest_code);
+	prepare_nested_sync_handler(vm, vcpu);
+
+	while (true) {
+		vcpu_run(vcpu);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_PRINTF:
+			pr_info("%s", uc.buffer);
+			break;
+		case UCALL_DONE:
+			pr_info("DONE!\n");
+			goto end;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			fallthrough;
+		default:
+			TEST_FAIL("Unhandled ucall: %ld\n", uc.cmd);
+		}
+	}
+
+end:
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.43.0

