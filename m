Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794214198;
	b=sey7GBizdHM1CKosUzDZvAWy9SOLx/rT9Bdp2ZQsND9++bD0YvgBNgKVGQRuUWtMSFaj
	 Ah9sVE87GyWzlXfxpVEaljjeGu5Ckx+R/d/gB9+azh3FZte9+usPNVMYdeA7TcElDsQwP
	 4R3uvln99jFGFw7K1JETpUWmJVbj5xKtQ4zuocx7iOUVJ89RHIn10So3Z7qt3xizbfCf4
	 LNKyenTl0Akv46VKNkOhLE5CV4WJwL52sTzcNh3tyagB6bcL46z7H/MuMrvnw55XedLPA
	 MlI/JbOUT3bPujs53PRmkgTJtUiNp5DooDe1UmdodkxscLtvdGlUihxfdjorW1EwGIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794214198;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=enZ+rxNA5llQq8stUAYqL777l3E+Rb4FChBimMnVo/c=;
	b=zZ1H4+sqcWV2lbqivfI+XdFf3vxizy4jVZo7WKaDZiYZi2z8WZ7//J5QDtEI5V77gf6g
	 Gp3Sq20rXvUDCYyvTqYEGJacxHiz5/T9U8wIQLjkAKaFVsJbMmisYSwOOwn1w1wpPAXg7
	 p+kwXY8rox8biLcgeTAKMggrRmZyQrDTvPXz1QRmjqVI+m02FzqhcyxUa50V1L387/JM1
	 bE0cKqC3OoP4IQxrd4uBcVt1b7NJqSd6rFYv+qkwYdyFssOn/q669dERbIlHw8NcLO3fB
	 uJNzgj4leqS5/Kf/o6E2sT3STwTC/bsvxloX98D3x/dFpHnOkqdtnnjyqHlYhd5Zgiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fjDfygNY;
	arc=none smtp.remote-ip=91.218.175.99
Received: from mta0.migadu.com (out-99.mta0.migadu.com [91.218.175.99])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC4F60A263A
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 08:49:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DC4F60A263A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fjDfygNY
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=b2F/ChI2+6P14QFvIr5FqQQCzRs45fgFrDhYNkVhDbg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794214195; v=1; x=1794818995;
 b=fjDfygNYYDNv/1/yXjoUmm7eehczwA6KcblDnYn8ZG3FnzQliU9ytj40d5kQcLLESakM+5fb
 ekbZJi9TjObJrppUVJKry9NjiPmaySvpnjQAju165/54LAFS161EM0VGlFu43Z5XXPxtM532DXj
 1mG3E5t5egXMw73eOsPqxZ3g=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 069a26477df958a7;
	Mon, 09 Nov 2026 08:49:55 +0000
X-Mizu-Trace-ID: 069a26477df958a7
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
Subject: [PATCH v2 18/19] KVM: arm64: selftests: Add pkvm_sve vector-length test
Date: Mon,  9 Nov 2026 08:48:53 +0000
Message-ID: <20261109084854.840576-19-fuad.tabba@linux.dev>
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

EL2 saves and restores a protected guest's SVE registers at the vector
length the host set before the first run. On every exit, it puts the
host's own vector length back.

Run a protected guest at each vector length KVM supports, and check
that it reads that length with RDVL, and that its predicates and FFR
survive exits. At the largest length, check Z, P and FFR across moves to
another host CPU. Check the host thread's vector length after every
exit. The cases skip when a protected VM can't have SVE.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm     |   1 +
 tools/testing/selftests/kvm/arm64/pkvm_sve.c | 357 +++++++++++++++++++
 2 files changed, 358 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/pkvm_sve.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 1045136aacc16..b25ed1834f197 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -199,6 +199,7 @@ TEST_GEN_PROGS_arm64 += arm64/pkvm_lifecycle
 TEST_GEN_PROGS_arm64 += arm64/pkvm_mem_share
 TEST_GEN_PROGS_arm64 += arm64/pkvm_psci
 TEST_GEN_PROGS_arm64 += arm64/pkvm_smccc
+TEST_GEN_PROGS_arm64 += arm64/pkvm_sve
 TEST_GEN_PROGS_arm64 += arm64/pkvm_vcpu_regs
 TEST_GEN_PROGS_arm64 += arm64/psci_test
 TEST_GEN_PROGS_arm64 += arm64/sea_to_user
diff --git a/tools/testing/selftests/kvm/arm64/pkvm_sve.c b/tools/testing/selftests/kvm/arm64/pkvm_sve.c
new file mode 100644
index 0000000000000..e34780aea4855
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/pkvm_sve.c
@@ -0,0 +1,357 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * pkvm_sve - SVE in a protected VM: at each vector length KVM supports,
+ * RDVL and the guest's predicate and FFR state across exits, then its Z, P
+ * and FFR state across moves to another host CPU, and the host's vector
+ * length after each protected KVM_RUN.
+ *
+ * Copyright (C) 2026 Google LLC
+ * Author: Fuad Tabba <fuad.tabba@linux.dev>
+ */
+
+#include <errno.h>
+#include <sched.h>
+
+#include "kvm_util.h"
+#include "pkvm.h"
+#include "processor.h"
+#include "test_util.h"
+
+#define VQS_WORDS	KVM_ARM64_SVE_VLS_WORDS
+
+/* Accesses to this unbacked IPA exit to the VMM as MMIO. */
+#define MMIO_IPA	BIT_ULL(31)
+
+#define NR_MIGRATIONS	32
+
+/* The architecture's largest VL, 2048 bits. */
+#define VL_ARCH_MAX	__sve_vl_from_vq(16)
+
+/* VL in bytes, set in the guest's copy by the host. */
+static u64 guest_expected_vl;
+
+/* The host thread's VL before any KVM_RUN. */
+static unsigned long host_vl;
+
+/* Z0-Z31, P0-P15 and FFR at the guest's VL, as LDR and STR (vector) lay them out. */
+static u8 z_in[32 * VL_ARCH_MAX], z_out[32 * VL_ARCH_MAX];
+static u8 p_in[16 * VL_ARCH_MAX / 8], p_out[16 * VL_ARCH_MAX / 8];
+static u8 ffr_in[VL_ARCH_MAX / 8], ffr_out[VL_ARCH_MAX / 8];
+
+static cpu_set_t host_cpus;
+
+static bool vq_present(const u64 *vqs, unsigned int vq)
+{
+	unsigned int i = (vq - KVM_ARM64_SVE_VQ_MIN) / 64;
+	unsigned int b = (vq - KVM_ARM64_SVE_VQ_MIN) % 64;
+
+	return vqs[i] & BIT_ULL(b);
+}
+
+static void vq_set(u64 *vqs, unsigned int vq)
+{
+	unsigned int i = (vq - KVM_ARM64_SVE_VQ_MIN) / 64;
+	unsigned int b = (vq - KVM_ARM64_SVE_VQ_MIN) % 64;
+
+	vqs[i] |= BIT_ULL(b);
+}
+
+/* Enable SVE and FP at EL1 and request the largest VL, returning the one granted. */
+static u64 guest_enable_sve(void)
+{
+	u64 vl;
+
+	write_sysreg(read_sysreg(cpacr_el1) | CPACR_EL1_ZEN_EL1EN | CPACR_EL1_FPEN_EL1EN,
+		     cpacr_el1);
+	isb();
+
+	write_sysreg_s(0xf, SYS_ZCR_EL1);
+	isb();
+	asm volatile(".arch_extension sve\n rdvl %0, #1" : "=r"(vl));
+
+	return vl;
+}
+
+/*
+ * The predicates and FFR are VL-sized and, unlike Z, untouched by compiler or
+ * ucall SIMD, so a save or restore at the wrong VL shows up here.
+ */
+static void guest_sve_vl(void)
+{
+	u64 p_ok, np_ok, ffr_ok;
+	int i;
+
+	pkvm_guest_init();
+	GUEST_ASSERT_EQ(guest_enable_sve(), guest_expected_vl);
+
+	asm volatile(".arch_extension sve\n"
+		     "ptrue	p0.b\n"		/* all-true, spans the VL */
+		     "pfalse	p4.b\n"		/* all-false pattern */
+		     "setffr\n"			/* FFR all-true */
+		     ::: "p0", "p4", "memory");
+
+	/* Each ucall is a full exit and entry, saving and restoring the guest SVE state. */
+	for (i = 0; i < 3; i++)
+		GUEST_SYNC(i);
+
+	asm volatile(".arch_extension sve\n"
+		     "cntp	%[p], p0, p0.b\n"	/* == VL bytes if the all-true mask held */
+		     "cntp	%[np], p0, p4.b\n"	/* == 0 if the all-false mask held */
+		     "rdffr	p1.b\n"
+		     "cntp	%[f], p0, p1.b\n"	/* == VL bytes if FFR held */
+		     : [p] "=r"(p_ok), [np] "=r"(np_ok), [f] "=r"(ffr_ok)
+		     :: "p0", "p1");
+
+	GUEST_ASSERT_EQ(p_ok, guest_expected_vl);
+	GUEST_ASSERT_EQ(np_ok, 0);
+	GUEST_ASSERT_EQ(ffr_ok, guest_expected_vl);
+
+	GUEST_DONE();
+}
+
+#define P_REGS	"0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15"
+#define Z_REGS	P_REGS ", 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31"
+
+/* @op every Z or P register at its index times its size from @buf. */
+#define Z_OP(op, buf)	\
+	".irp num, " Z_REGS "\n" op "	z\\num, [%[" buf "], #\\num, mul vl]\n.endr\n"
+#define P_OP(op, buf)	\
+	".irp num, " P_REGS "\n" op "	p\\num, [%[" buf "], #\\num, mul vl]\n.endr\n"
+
+/* A predicate is VL / 8 bytes. */
+static void fill_sve_in(int iter, u64 vl)
+{
+	u64 *z = (u64 *)z_in, *p = (u64 *)p_in;
+	int i;
+
+	/* Different in every word and on every exit. */
+	for (i = 0; i < 32 * vl / sizeof(u64); i++)
+		z[i] = 0x0101010101010101UL * (i + 1) ^ (u64)iter << 40;
+	for (i = 0; i < 16 * vl / 8 / sizeof(u64); i++)
+		p[i] = ~z[i];
+
+	/* WRFFR requires a run of active elements from the first, or FFR is UNPREDICTABLE. */
+	memset(ffr_in, 0, sizeof(ffr_in));
+	for (i = 0; i <= iter % vl; i++)
+		ffr_in[i / 8] |= BIT(i % 8);
+}
+
+static void check_sve_out(int iter, u64 vl)
+{
+	const u64 *z = (u64 *)z_out, *want = (u64 *)z_in;
+	int i;
+
+	for (i = 0; i < 32 * vl / sizeof(u64); i++)
+		__GUEST_ASSERT(z[i] == want[i], "migration %d: z%lu is 0x%lx, not 0x%lx",
+			       iter, i / (vl / sizeof(u64)), z[i], want[i]);
+	for (i = 0; i < 16 * vl / 8; i++)
+		__GUEST_ASSERT(p_out[i] == p_in[i], "migration %d: p%lu is 0x%x, not 0x%x",
+			       iter, i / (vl / 8), p_out[i], p_in[i]);
+	for (i = 0; i < vl / 8; i++)
+		__GUEST_ASSERT(ffr_out[i] == ffr_in[i], "migration %d: FFR is 0x%x, not 0x%x",
+			       iter, ffr_out[i], ffr_in[i]);
+}
+
+static void guest_sve_migrate(void)
+{
+	u64 vl;
+	int i;
+
+	pkvm_guest_init();
+	vl = guest_enable_sve();
+	GUEST_ASSERT_EQ(vl, guest_expected_vl);
+
+	for (i = 0; i < NR_MIGRATIONS; i++) {
+		fill_sve_in(i, vl);
+
+		asm volatile(".arch_extension sve\n"
+			     "ldr	p0, [%[ffr_in]]\n"
+			     "wrffr	p0.b\n"
+			     P_OP("ldr", "p_in") Z_OP("ldr", "z_in")
+			     "str	x0, [%[mmio]]\n"
+			     Z_OP("str", "z_out") P_OP("str", "p_out")
+			     "rdffr	p0.b\n"
+			     "str	p0, [%[ffr_out]]\n"
+			     : : [z_in] "r"(z_in), [z_out] "r"(z_out), [p_in] "r"(p_in),
+			       [p_out] "r"(p_out), [ffr_in] "r"(ffr_in), [ffr_out] "r"(ffr_out),
+			       [mmio] "r"(MMIO_IPA)
+			     : "v0", "v1", "v2", "v3", "v4", "v5", "v6", "v7",
+			       "v8", "v9", "v10", "v11", "v12", "v13", "v14", "v15",
+			       "v16", "v17", "v18", "v19", "v20", "v21", "v22", "v23",
+			       "v24", "v25", "v26", "v27", "v28", "v29", "v30", "v31",
+			       "p0", "p1", "p2", "p3", "p4", "p5", "p6", "p7",
+			       "p8", "p9", "p10", "p11", "p12", "p13", "p14", "p15",
+			       "memory");
+
+		check_sve_out(i, vl);
+	}
+
+	GUEST_DONE();
+}
+
+/* The host thread's VL is unchanged by a protected run. */
+static void assert_host_vl(void)
+{
+	unsigned long vl;
+
+	asm volatile(".arch_extension sve\n rdvl %0, #1" : "=r"(vl));
+	TEST_ASSERT_EQ(vl, host_vl);
+}
+
+static void on_sync(struct kvm_vcpu *vcpu, struct ucall *uc)
+{
+	assert_host_vl();
+}
+
+static void set_vls_and_finalize(struct kvm_vcpu *vcpu, u64 *vqs)
+{
+	struct kvm_one_reg reg = {
+		.id = KVM_REG_ARM64_SVE_VLS,
+		.addr = (u64)vqs,
+	};
+	int feature = KVM_ARM_VCPU_SVE;
+
+	vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
+	vcpu_ioctl(vcpu, KVM_ARM_VCPU_FINALIZE, &feature);
+}
+
+static void probe_available_vqs(u64 *vqs)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = pkvm_vm_create(1, BIT(KVM_ARM_VCPU_SVE), &vcpu);
+	TEST_ASSERT(!__vcpu_get_reg(vcpu, KVM_REG_ARM64_SVE_VLS, vqs),
+		    "KVM_GET_ONE_REG(SVE_VLS): errno %d", errno);
+	kvm_vm_free(vm);
+}
+
+/* Narrow the VM to max VQ @target and run the guest at that VL. */
+static void test_vl(unsigned int target, const u64 *avail)
+{
+	u64 vqs[VQS_WORDS] = {};
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	unsigned int vq;
+
+	/* The bitmap must match the host-available VQs up to the maximum. */
+	for (vq = KVM_ARM64_SVE_VQ_MIN; vq <= target; vq++)
+		if (vq_present(avail, vq))
+			vq_set(vqs, vq);
+
+	vm = pkvm_vm_create(1, BIT(KVM_ARM_VCPU_SVE), &vcpu);
+	set_vls_and_finalize(vcpu, vqs);
+	write_guest_global(vm, guest_expected_vl, __sve_vl_from_vq(target));
+	pkvm_vcpu_setup_boot(vcpu, guest_sve_vl);
+
+	pkvm_run_loop(vcpu, on_sync);
+	assert_host_vl();
+
+	kvm_vm_free(vm);
+}
+
+/* Move this thread, and with it the vCPU's next run, to another of its CPUs. */
+static void migrate_thread(void)
+{
+	int cpu = sched_getcpu();
+
+	do
+		cpu = (cpu + 1) % CPU_SETSIZE;
+	while (!CPU_ISSET(cpu, &host_cpus));
+
+	pin_self_to_cpu(cpu);
+	TEST_ASSERT_EQ(sched_getcpu(), cpu);
+}
+
+/* Run the VM at the largest VQ in @avail, moving it to another CPU at every MMIO exit. */
+static void test_migrate(unsigned int max_vq, u64 *avail)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_run *run;
+	struct kvm_vm *vm;
+	struct ucall uc;
+
+	vm = pkvm_vm_create(1, BIT(KVM_ARM_VCPU_SVE), &vcpu);
+	set_vls_and_finalize(vcpu, avail);
+	write_guest_global(vm, guest_expected_vl, __sve_vl_from_vq(max_vq));
+	pkvm_vcpu_setup_boot(vcpu, guest_sve_migrate);
+	virt_map(vm, MMIO_IPA, MMIO_IPA, 1);
+
+	run = vcpu->run;
+	for (;;) {
+		vcpu_run(vcpu);
+		assert_host_vl();
+
+		if (run->exit_reason == KVM_EXIT_MMIO && run->mmio.phys_addr == MMIO_IPA) {
+			migrate_thread();
+			continue;
+		}
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_DONE:
+			kvm_vm_free(vm);
+			return;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		default:
+			TEST_FAIL("Unexpected exit: %s", exit_reason_str(run->exit_reason));
+		}
+	}
+}
+
+int main(void)
+{
+	unsigned int vq, max_vq = 0, nr_vqs = 0;
+	u64 avail[VQS_WORDS] = {};
+	bool sve;
+
+	TEST_REQUIRE(pkvm_supported());
+
+	sve = pkvm_has_cap(KVM_CAP_ARM_SVE);
+	if (sve) {
+		probe_available_vqs(avail);
+		for (vq = KVM_ARM64_SVE_VQ_MIN; vq <= KVM_ARM64_SVE_VQ_MAX; vq++) {
+			if (!vq_present(avail, vq))
+				continue;
+			max_vq = vq;
+			nr_vqs++;
+		}
+		TEST_ASSERT(nr_vqs, "no SVE vector lengths advertised");
+	}
+
+	ksft_print_header();
+	ksft_set_plan(2 + (sve ? nr_vqs : 1));
+
+	if (!sve) {
+		const char *why = "SVE unavailable to a protected VM";
+
+		ksft_test_result_skip("vector lengths: %s\n", why);
+		ksft_test_result_skip("Z, P and FFR across host CPU migrations: %s\n", why);
+		ksft_test_result_skip("host VL preserved: %s\n", why);
+		ksft_finished();
+	}
+
+	/* The cap implies host SVE, so the host thread can read its own VL. */
+	asm volatile(".arch_extension sve\n rdvl %0, #1" : "=r"(host_vl));
+
+	for (vq = KVM_ARM64_SVE_VQ_MIN; vq <= KVM_ARM64_SVE_VQ_MAX; vq++) {
+		if (!vq_present(avail, vq))
+			continue;
+		test_vl(vq, avail);
+		ksft_test_result_pass("VQ %u: RDVL, predicates and FFR across exits\n", vq);
+	}
+
+	kvm_sched_getaffinity(0, sizeof(host_cpus), &host_cpus);
+	if (CPU_COUNT(&host_cpus) < 2) {
+		ksft_test_result_skip("Z, P and FFR across host CPU migrations: one CPU\n");
+	} else {
+		test_migrate(max_vq, avail);
+		kvm_sched_setaffinity(0, sizeof(host_cpus), &host_cpus);
+		ksft_test_result_pass("VQ %u: Z, P and FFR across host CPU migrations\n", max_vq);
+	}
+
+	ksft_test_result_pass("host VL preserved across protected runs\n");
+
+	ksft_finished();
+}
-- 
2.47.3

