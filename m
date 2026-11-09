Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.59
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794214197;
	b=mPluT/dnn0j3uR18BKt3AA+F9F5vQ32JFNIgscJTQmQgM7XZx3JQgPgckAqzAqD2VS9U
	 KukQm8m5Eqf85/0JBiF6a7mw6rFlOvy3D/ZTxbmg3u5g6lESLDOYdtrAJQNLnCRHoKMNO
	 H9QnoeUs+/gdFUUPYbbPS9Ftx68JZkDhEN6ggMSqExG7z3rRhi7nZlDwU8gbVCRYlvWMm
	 C+teEw0N8FE8qkLKYRS5NboXCxtIig7bMA970eX0EsYvD0Ov++H255u/1BGJpJymWNXp/
	 LMrYmwASZH7BmeZvaKSGRYD84YCIDV1fipR96flLAFLWzR5Jj8UkX8Oa+oCYmLQrhnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794214197;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=YYtZXvG9+UdS+4Z9GxZSoWsbkG0GwWt2msV5s/Y8pAo=;
	b=RcwZ8kXx7MBKyHOWWkj6PvIU7awwxHw6FrGY1A68Fn4PORwzP8ELjg31jzJXrApLnNZD
	 Lz4mFHKOepVEzGcUmXAqvMxlEhoNYijuz2ZtcU6PAiaT/04/GMhXVOHvx7S2URpJn5Hqu
	 x4w13rkvQlF10NFPjBMhmMmOBphOuuqw0tIjwHlAIOUfsDndNUz7CQoKFk8xDJ8p1nwkQ
	 yIbBPpGxDLWZYsYTAwgo7Oyh8eTZufZsnuhdTFqYTtn24yZ5oSiIxInR3pyvcuVuPiV77
	 4sHV/sYs+yJHoLsfRNNr+0Xgx4oBW2rst1MZX5JZgDlSJ274sWrYw9nbcGYjIiqwlkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="VfFncnz/";
	arc=none smtp.remote-ip=95.215.58.59
Received: from mta1.migadu.com (out-59.mta1.migadu.com [95.215.58.59])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF7960A3803
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 08:49:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8FF7960A3803
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=VfFncnz/
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Ia4ROUhNRdc6AFPTEZfdVXbpoKxOmfz2LXLKwxYl31Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794214194; v=1; x=1794818994;
 b=VfFncnz/4dzhyDw8/vZCcUip6yuDYqNURfw0jvHCMQNSdAL0eL+RgUiCavu2+KVK9/lt/LM7
 Ezyi+ktJl1dPYhEk1HYEcvsVfHCNwe7jTmO643a9q9kmLKnZnXHXVEjAaV5yOIaRRKatwIdhhKp
 cVUlBJdresaaxmH1iN1BZizk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 6a0cd798898f94ae;
	Mon, 09 Nov 2026 08:49:54 +0000
X-Mizu-Trace-ID: 6a0cd798898f94ae
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
Subject: [PATCH v2 17/19] KVM: arm64: selftests: Add pkvm_exceptions debug and SError test
Date: Mon,  9 Nov 2026 08:48:52 +0000
Message-ID: <20261109084854.840576-18-fuad.tabba@linux.dev>
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

pKVM can hide self-hosted debug from a protected guest, which then reads
ID_AA64DFR0_EL1.DebugVer as 0. A virtual SError the host injects has to
be delivered by EL2, since the host can't see whether the guest has it
masked.

Verify that the guest's own handler takes a hardware breakpoint, a
watchpoint and a single step, and that an injected SError is pending in
ISR_EL1.A while PSTATE.A masks it and is taken once unmasked. The debug
cases skip while ID_AA64DFR0_EL1.DebugVer is 0.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/arm64/pkvm_exceptions.c     | 261 ++++++++++++++++++
 2 files changed, 262 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/pkvm_exceptions.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 214f38e3f67a7..1045136aacc16 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -190,6 +190,7 @@ TEST_GEN_PROGS_arm64 += arm64/nv_pre_fault_memory_test
 TEST_GEN_PROGS_arm64 += arm64/external_aborts
 TEST_GEN_PROGS_arm64 += arm64/mmio_sign_ext
 TEST_GEN_PROGS_arm64 += arm64/page_fault_test
+TEST_GEN_PROGS_arm64 += arm64/pkvm_exceptions
 TEST_GEN_PROGS_arm64 += arm64/pkvm_host_abi
 TEST_GEN_PROGS_arm64 += arm64/pkvm_id_regs
 TEST_GEN_PROGS_arm64 += arm64/pkvm_irq
diff --git a/tools/testing/selftests/kvm/arm64/pkvm_exceptions.c b/tools/testing/selftests/kvm/arm64/pkvm_exceptions.c
new file mode 100644
index 0000000000000..f7f9b666dd089
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/pkvm_exceptions.c
@@ -0,0 +1,261 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * pkvm_exceptions - debug exceptions and a virtual SError in a protected VM.
+ *
+ * Copyright (C) 2026 Google LLC
+ * Author: Fuad Tabba <fuad.tabba@linux.dev>
+ */
+
+#include "kvm_util.h"
+#include "pkvm.h"
+#include "processor.h"
+#include "test_util.h"
+
+/* Debug register programming bits, as debug-exceptions.c has them. */
+#define DBGBCR_LEN8	(0xff << 5)
+#define DBGBCR_EXEC	(0x0 << 3)
+#define DBGBCR_EL1	(0x1 << 1)
+#define DBGBCR_E	(0x1 << 0)
+
+#define DBGWCR_LEN8	(0xff << 5)
+#define DBGWCR_RD	(0x1 << 3)
+#define DBGWCR_WR	(0x2 << 3)
+#define DBGWCR_EL1	(0x1 << 1)
+#define DBGWCR_E	(0x1 << 0)
+
+#define SPSR_SS		(1 << 21)
+
+#define NR_STEPS	3
+
+enum { CMD_INJECT_SERROR, CMD_CHECK_SERROR };
+
+extern unsigned char hw_bp, ss_start;
+
+static volatile u64 ex_pc, ex_addr;
+static volatile u64 ss_addr[NR_STEPS + 1];
+static volatile int ss_idx;
+static volatile char write_data;
+static volatile bool serror_taken;
+
+static bool debug_exposed;
+
+/* Masks debug on return so the breakpointed instruction runs. */
+static void hw_bp_handler(struct ex_regs *regs)
+{
+	ex_pc = regs->pc;
+	regs->pstate |= PSR_D_BIT;
+}
+
+/* Records FAR, the accessed address, and masks debug on return so the access completes. */
+static void wp_handler(struct ex_regs *regs)
+{
+	ex_pc = regs->pc;
+	ex_addr = read_sysreg(far_el1);
+	regs->pstate |= PSR_D_BIT;
+}
+
+/* Records the stepped PC and sets SPSR.SS so that the next instruction is stepped too. */
+static void ss_handler(struct ex_regs *regs)
+{
+	__GUEST_ASSERT(ss_idx <= NR_STEPS, "step %d past the stepped range", ss_idx);
+	ss_addr[ss_idx++] = regs->pc;
+	regs->pstate |= SPSR_SS;
+}
+
+static void reset_debug_state(void)
+{
+	asm volatile("msr daifset, #8");
+
+	/* Clear the OS lock and double lock so debug exceptions are permitted. */
+	write_sysreg(0, osdlr_el1);
+	write_sysreg(0, oslar_el1);
+	isb();
+
+	write_sysreg(0, mdscr_el1);
+	write_sysreg(0, dbgbcr0_el1);
+	write_sysreg(0, dbgbvr0_el1);
+	write_sysreg(0, dbgwcr0_el1);
+	write_sysreg(0, dbgwvr0_el1);
+	isb();
+
+	ex_pc = 0;
+	ex_addr = 0;
+}
+
+/* A zero DebugVer means EL2 hides self-hosted debug, so the case has nothing to test. */
+static bool guest_debug_exposed(void)
+{
+	bool exposed = SYS_FIELD_GET(ID_AA64DFR0_EL1, DebugVer, read_sysreg(id_aa64dfr0_el1));
+
+	GUEST_SYNC(exposed);
+	return exposed;
+}
+
+static void enable_monitor_debug(void)
+{
+	asm volatile("msr daifclr, #8");
+	write_sysreg(read_sysreg(mdscr_el1) | MDSCR_EL1_KDE | MDSCR_EL1_MDE, mdscr_el1);
+	isb();
+}
+
+static void guest_hw_breakpoint(void)
+{
+	pkvm_guest_init();
+	if (!guest_debug_exposed())
+		GUEST_DONE();
+
+	reset_debug_state();
+	write_sysreg(DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E, dbgbcr0_el1);
+	write_sysreg((u64)&hw_bp, dbgbvr0_el1);
+	enable_monitor_debug();
+	asm volatile("hw_bp: nop");
+	GUEST_ASSERT_EQ(ex_pc, (u64)&hw_bp);
+
+	reset_debug_state();
+	GUEST_DONE();
+}
+
+static void guest_watchpoint(void)
+{
+	pkvm_guest_init();
+	if (!guest_debug_exposed())
+		GUEST_DONE();
+
+	reset_debug_state();
+	write_sysreg(DBGWCR_LEN8 | DBGWCR_RD | DBGWCR_WR | DBGWCR_EL1 | DBGWCR_E, dbgwcr0_el1);
+	/*
+	 * BAS = 0xff watches all eight bytes only from a doubleword-aligned DBGWVR.
+	 * FAR still holds the byte's address.
+	 */
+	write_sysreg((u64)&write_data & ~7UL, dbgwvr0_el1);
+	enable_monitor_debug();
+	write_data = 'x';
+	GUEST_ASSERT_EQ(write_data, 'x');
+	GUEST_ASSERT_EQ(ex_addr, (u64)&write_data);
+
+	reset_debug_state();
+	GUEST_DONE();
+}
+
+static void guest_single_step(void)
+{
+	pkvm_guest_init();
+	if (!guest_debug_exposed())
+		GUEST_DONE();
+
+	reset_debug_state();
+	write_sysreg(read_sysreg(mdscr_el1) | MDSCR_EL1_KDE | MDSCR_EL1_SS, mdscr_el1);
+	isb();
+	ss_idx = 0;
+	/* Unmasking makes the step active-pending, so the first one is taken at ss_start. */
+	asm volatile("msr daifclr, #8\n"
+		     "ss_start:\n"
+		     "mrs x0, esr_el1\n"
+		     "add x0, x0, #1\n"
+		     "msr daifset, #8\n"
+		     : : : "x0");
+	GUEST_ASSERT_EQ(ss_addr[0], (u64)&ss_start);
+	GUEST_ASSERT_EQ(ss_addr[1], (u64)&ss_start + 4);
+	GUEST_ASSERT_EQ(ss_addr[2], (u64)&ss_start + 8);
+
+	reset_debug_state();
+	GUEST_DONE();
+}
+
+static void serror_handler(struct ex_regs *regs)
+{
+	GUEST_ASSERT_EQ(ESR_ELx_EC(read_sysreg(esr_el1)), ESR_ELx_EC_SERROR);
+	serror_taken = true;
+}
+
+/*
+ * The guest sees the injected SError in ISR_EL1.A while PSTATE.A masks it, and
+ * takes it on unmasking. EL2 has to deliver it through HCR_EL2.VSE, because the
+ * host can't read a protected guest's PSTATE.A for serror_is_masked().
+ */
+static void guest_serror(void)
+{
+	pkvm_guest_init();
+
+	GUEST_SYNC(CMD_INJECT_SERROR);
+	GUEST_ASSERT(read_sysreg(isr_el1) & ISR_EL1_A);
+	GUEST_ASSERT(!serror_taken);
+
+	local_serror_enable();
+	isb();
+	local_serror_disable();
+
+	GUEST_ASSERT(serror_taken);
+	GUEST_SYNC(CMD_CHECK_SERROR);
+	GUEST_DONE();
+}
+
+static void serror_sync(struct kvm_vcpu *vcpu, struct ucall *uc)
+{
+	struct kvm_vcpu_events events = {};
+
+	switch (uc->args[1]) {
+	case CMD_INJECT_SERROR:
+		events.exception.serror_pending = true;
+		vcpu_events_set(vcpu, &events);
+		memset(&events, 0, sizeof(events));
+		vcpu_events_get(vcpu, &events);
+		TEST_ASSERT(events.exception.serror_pending, "vSError not pending after injection");
+		break;
+	case CMD_CHECK_SERROR:
+		vcpu_events_get(vcpu, &events);
+		TEST_ASSERT(!events.exception.serror_pending, "vSError still pending once taken");
+		break;
+	}
+}
+
+static void test_serror(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = pkvm_vm_create_with_one_vcpu(&vcpu, guest_serror);
+	vm_install_exception_handler(vm, VECTOR_ERROR_CURRENT, serror_handler);
+	pkvm_run_loop(vcpu, serror_sync);
+	kvm_vm_free(vm);
+}
+
+static void debug_sync(struct kvm_vcpu *vcpu, struct ucall *uc)
+{
+	debug_exposed = uc->args[1];
+}
+
+static void run_debug_guest(void *guest_code, int ec, handler_fn handler, const char *name)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = pkvm_vm_create_with_one_vcpu(&vcpu, guest_code);
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT, ec, handler);
+	pkvm_run_loop(vcpu, debug_sync);
+	kvm_vm_free(vm);
+
+	if (debug_exposed)
+		ksft_test_result_pass("%s\n", name);
+	else
+		ksft_test_result_skip("%s: self-hosted debug not exposed to protected guests\n",
+				      name);
+}
+
+int main(void)
+{
+	TEST_REQUIRE(pkvm_supported());
+
+	ksft_print_header();
+	ksft_set_plan(4);
+
+	run_debug_guest(guest_hw_breakpoint, ESR_ELx_EC_BREAKPT_CUR, hw_bp_handler,
+			"hardware breakpoint");
+	run_debug_guest(guest_watchpoint, ESR_ELx_EC_WATCHPT_CUR, wp_handler, "watchpoint");
+	run_debug_guest(guest_single_step, ESR_ELx_EC_SOFTSTP_CUR, ss_handler, "single step");
+
+	test_serror();
+	ksft_test_result_pass("virtual SError taken on unmasking\n");
+
+	ksft_finished();
+}
-- 
2.47.3

