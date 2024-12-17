Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD5E1FA176
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 21:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734470650; cv=none; b=CK5S4snL/LWzMvHAvtUluTZ+S324eRmI0rh/feYFV8lIC3ypDkUVMjH9cAW/uefzR8J7shA5+R5pvWS71YpzsNOBSaQfJp7rRpajt6swkFoCIS4bzLu8qb+jZUtPMeQVwm7LDKDHzkvzGHT8d5TIfRoL2IlgkNMUGORh7YXL4lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734470650; c=relaxed/simple;
	bh=0f9wBCQbmZ3UMKrf1z+BBVUrpPmS0z0ymG1sBaR15+8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VJOFOJCxDyKaXYw0Y7V5YdCVDivxVdJRemZxI5tg2x+/eZ9KRd1npx+8yT6FhyB4v0se9fkq1ptxwR2hiHm+RCyzRUeo7Y9o3kCQ5P3H8Ysfe7EiGaijaB7UBiAFFuXRUxoSTQ6/2cnB6G340T4hr41HZVBf8epQfMoELFDAQvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VA67n1iq; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VA67n1iq"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734470647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SSMKPr218zjQZP8gl2Xn0SkINEtcf07/ruTFBToN5tY=;
	b=VA67n1iq+co1LRtOkonRL8hQMfYqG8eeihPXIot35jdV2OqnM0IjIoEclBz4iiySst4K0O
	LpbiaLE1FVTaMHBQwCzSQ5mBlfh37Ts9KNZjGnmfFVXlJQjc0cOLHDRXz9b+O2BGfhJIK0
	0sykWNf2bqTb28Q1+oNUBAVGbdQCK7U=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [HACK PATCH 18/18] KVM: arm64: selftests: Add test for probing PMUv3 sysregs
Date: Tue, 17 Dec 2024 13:23:58 -0800
Message-Id: <20241217212358.3709634-1-oliver.upton@linux.dev>
In-Reply-To: <20241217212048.3709204-1-oliver.upton@linux.dev>
References: <20241217212048.3709204-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add a test for sniffing out PMUv3 register traps.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---

Not intended to be applied, just sharing in case someone finds it
useful.

 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/aarch64/pmuv3_register_probe.c        | 135 ++++++++++++++++++
 2 files changed, 136 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/pmuv3_register_probe.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 41593d2e7de9..739542928306 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -159,6 +159,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/hypercalls
 TEST_GEN_PROGS_aarch64 += aarch64/mmio_abort
 TEST_GEN_PROGS_aarch64 += aarch64/page_fault_test
+TEST_GEN_PROGS_aarch64 += aarch64/pmuv3_register_probe
 TEST_GEN_PROGS_aarch64 += aarch64/psci_test
 TEST_GEN_PROGS_aarch64 += aarch64/set_id_regs
 TEST_GEN_PROGS_aarch64 += aarch64/smccc_filter
diff --git a/tools/testing/selftests/kvm/aarch64/pmuv3_register_probe.c b/tools/testing/selftests/kvm/aarch64/pmuv3_register_probe.c
new file mode 100644
index 000000000000..859b0162dbeb
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/pmuv3_register_probe.c
@@ -0,0 +1,135 @@
+#include <perf/arm_pmuv3.h>
+
+#include "vgic.h"
+#include "test_util.h"
+#include "processor.h"
+
+static bool undef_taken;
+
+#define test_read(sr)							\
+do {									\
+	u64 __val = read_sysreg(sr);					\
+									\
+	if (READ_ONCE(undef_taken))					\
+		GUEST_PRINTF("read_sysreg("#sr"): UNDEFINED\n");	\
+	else								\
+		GUEST_PRINTF("read_sysreg("#sr"): %lx\n", __val);	\
+	WRITE_ONCE(undef_taken, false);					\
+} while (0)
+
+#define test_write(val, sr)							\
+do {										\
+	write_sysreg(val, sr);							\
+										\
+	if (READ_ONCE(undef_taken))						\
+		GUEST_PRINTF("write_sysreg(%x, "#sr"): UNDEFINED\n", val);	\
+	else									\
+		GUEST_PRINTF("write_sysreg(%x, "#sr"): OK\n", val);		\
+	WRITE_ONCE(undef_taken, false);						\
+} while (0)
+
+static void guest_undef_handler(struct ex_regs *regs)
+{
+	WRITE_ONCE(undef_taken, true);
+	regs->pc += 4;
+}
+
+#define READ_PMEVCNTRN(n)	test_read(pmevcntr##n##_el0)
+static void test_read_evcntr(int n)
+{
+	PMEVN_SWITCH(n, READ_PMEVCNTRN);
+}
+
+#define READ_PMEVTYPERN(n)	test_read(pmevtyper##n##_el0);
+static void test_read_evtyper(int n)
+{
+	PMEVN_SWITCH(n, READ_PMEVTYPERN);
+}
+
+static void guest_code(void)
+{
+	test_read(pmcr_el0);
+	test_read(pmcntenset_el0);
+	test_read(pmcntenclr_el0);
+	test_read(pmovsset_el0);
+	test_read(pmovsclr_el0);
+	test_read(pmintenset_el1);
+	test_read(pmintenclr_el1);
+	test_read(pmceid0_el0);
+	test_read(pmceid1_el0);
+
+	test_read(pmccntr_el0);
+	test_read(pmccfiltr_el0);
+	test_write(0, pmswinc_el0);
+
+	test_write(0, pmselr_el0);
+	test_read(pmxevcntr_el0);
+	test_read(pmxevtyper_el0);
+
+	test_read(pmuserenr_el0);
+
+	for (int i = 0; i < 31; i++) {
+		test_read_evcntr(i);
+		test_read_evtyper(i);
+	}
+
+	GUEST_DONE();
+}
+
+static void run_test(struct kvm_vcpu *vcpu)
+{
+	struct ucall uc;
+
+	while (true) {
+		vcpu_run(vcpu);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_PRINTF:
+			REPORT_GUEST_PRINTF(uc);
+			break;
+		case UCALL_DONE:
+			return;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	}
+}
+
+int main(void)
+{
+	struct kvm_device_attr attr;
+	struct kvm_vcpu_init init;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	int irq = 23;
+
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PMU_V3));
+
+	vm = vm_create(1);
+	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
+	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
+	vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
+
+	__TEST_REQUIRE(vgic_v3_setup(vm, 1, 64) >= 0,
+		       "Failed to create vgic-v3, skipping");
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vcpu);
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT, ESR_ELx_EC_UNKNOWN,
+				guest_undef_handler);
+
+	attr = (struct kvm_device_attr) {
+		.group	= KVM_ARM_VCPU_PMU_V3_CTRL,
+		.attr	= KVM_ARM_VCPU_PMU_V3_IRQ,
+		.addr	= (u64)&irq,
+	};
+	vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &attr);
+
+	attr = (struct kvm_device_attr) {
+		.group	= KVM_ARM_VCPU_PMU_V3_CTRL,
+		.attr	= KVM_ARM_VCPU_PMU_V3_INIT,
+	};
+	vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &attr);
+
+	run_test(vcpu);
+}
-- 
2.39.5

