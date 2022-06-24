Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47D16C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 24 Jun 2022 21:33:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 063F84141A;
	Fri, 24 Jun 2022 17:33:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZLxj2fytgxos; Fri, 24 Jun 2022 17:33:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E4E64B0B4;
	Fri, 24 Jun 2022 17:33:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 679024B08F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2022 17:33:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UiKENA4WYIqL for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Jun 2022 17:33:22 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AC4CD49ED1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2022 17:33:22 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 o8-20020a17090a9f8800b001dc9f554c7fso1721045pjp.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2022 14:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=T7tbR+U+sEDMhJp8laHdpXCM9blITt3mJCz0H/F91Iw=;
 b=EkRRuWmlzQaahBp7vyadCkWnB5Yxh7c/FELoPCGh0oYcb414NUCpjbpZVWuGpglH0b
 hN7QsjwyNizJeYbTMFCGIznhc7+Mte29mULPd6cCB9v2wOkUT5xiKb1gy7tOZ/SXzB63
 sStVFR+x7GXIZU+qAe/BxBPcWFc2o8rCJKkHeo4+zi/pnIqsLH42L+LnwQSaCyya9xjz
 OgsiAL3WZHZpVAg1qF1sf9i7zcIIAqNkgZGRhO8bn5JJg3rT+6kZuOl4U8hh2a4BETqr
 ojqTDQ2NEsVm+myHDxj3DwE43q6liVD3LKgMeQvIteYXUpqzQq5gEK6GMa5PuWrcZtUb
 5hKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=T7tbR+U+sEDMhJp8laHdpXCM9blITt3mJCz0H/F91Iw=;
 b=QlSwkyL5tLgaGSkIWApGhiz+tsYniRDC9a29zClnKHa7eMcHx1jKPasY9EP514bDG/
 S0A70w4ZKMXXnITuFdjc5epZo4I4myb2s+7LobjFZEeMEeN0oIIUepk3Tms86ngwEpZO
 cGdKXV3hYF35mR6LxoWM8nUHSbzhqY64hAVuCNCIE34d4825y9qrfsln8dAbD+963hQv
 D8aih2slrQZwihtnpkTI6ApjaaVDD18eIULJ4crBKGRbDVoRs2lFqvTytrPNGuuJK44x
 YIo9ypmuHTVn19uIviP5Je0xpcRH2pGy8T3yY80RTKWZNmTrHqfswQVp/WXdFrhzPdTx
 LgWw==
X-Gm-Message-State: AJIora+P+lnsg9QzC16IzSIj9xzYTyQRRnEyBNCeukJ1R/KhqFK9OUJZ
 83oyqcluYxrVdyjcUY6FGHo9Y07UAWMPNg==
X-Google-Smtp-Source: AGRyM1uwVYYiI5/oSrXOPPqqDKcr3Uuk5LG/u+TjhqhQ8umLPUYm28sF3hLDyg4DGo2l/IzZzNSthoIPLcN/aA==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:1948:b0:525:45e3:2eb7 with SMTP
 id s8-20020a056a00194800b0052545e32eb7mr994069pfk.77.1656106401901; Fri, 24
 Jun 2022 14:33:21 -0700 (PDT)
Date: Fri, 24 Jun 2022 14:32:56 -0700
In-Reply-To: <20220624213257.1504783-1-ricarkol@google.com>
Message-Id: <20220624213257.1504783-13-ricarkol@google.com>
Mime-Version: 1.0
References: <20220624213257.1504783-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v4 12/13] KVM: selftests: aarch64: Add readonly memslot tests
 into page_fault_test
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc: maz@kernel.org, bgardon@google.com, dmatlack@google.com,
 pbonzini@redhat.com, axelrasmussen@google.com
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

Add some readonly memslot tests into page_fault_test. Mark the data
and/or page-table memslots as readonly, perform some accesses, and check
that the right fault is triggered when expected (e.g., a store with no
write-back should lead to an mmio exit).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/aarch64/page_fault_test.c   | 134 +++++++++++++++++-
 1 file changed, 131 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index d44a024dca89..c96fc2fd3390 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -72,6 +72,7 @@ struct memslot_desc {
 
 static struct event_cnt {
 	int aborts;
+	int mmio_exits;
 	int fail_vcpu_runs;
 	int uffd_faults;
 	/* uffd_faults is incremented from multiple threads. */
@@ -89,6 +90,8 @@ struct test_desc {
 	int (*uffd_test_handler)(int mode, int uffd, struct uffd_msg *msg);
 	void (*dabt_handler)(struct ex_regs *regs);
 	void (*iabt_handler)(struct ex_regs *regs);
+	void (*mmio_handler)(struct kvm_run *run);
+	void (*fail_vcpu_run_handler)(int ret);
 	uint32_t pt_memslot_flags;
 	uint32_t test_memslot_flags;
 	bool skip;
@@ -318,6 +321,20 @@ static void guest_code(struct test_desc *test)
 	GUEST_DONE();
 }
 
+static void dabt_s1ptw_on_ro_memslot_handler(struct ex_regs *regs)
+{
+	GUEST_ASSERT_EQ(read_sysreg(far_el1), TEST_GVA);
+	events.aborts += 1;
+	GUEST_SYNC(CMD_RECREATE_PT_MEMSLOT_WR);
+}
+
+static void iabt_s1ptw_on_ro_memslot_handler(struct ex_regs *regs)
+{
+	GUEST_ASSERT_EQ(regs->pc, TEST_EXEC_GVA);
+	events.aborts += 1;
+	GUEST_SYNC(CMD_RECREATE_PT_MEMSLOT_WR);
+}
+
 static void no_dabt_handler(struct ex_regs *regs)
 {
 	GUEST_ASSERT_1(false, read_sysreg(far_el1));
@@ -403,6 +420,32 @@ static bool punch_hole_in_memslot(struct kvm_vm *vm,
 	return true;
 }
 
+static void recreate_memslot(struct kvm_vm *vm, struct memslot_desc *ms,
+		uint32_t flags)
+{
+	vm_set_user_memory_region(vm, ms->idx, 0, ms->gpa, 0, ms->hva);
+	vm_set_user_memory_region(vm, ms->idx, flags, ms->gpa, ms->size, ms->hva);
+}
+
+static void mmio_on_test_gpa_handler(struct kvm_run *run)
+{
+	ASSERT_EQ(run->mmio.phys_addr, memslot[TEST].gpa);
+
+	memcpy(memslot[TEST].hva, run->mmio.data, run->mmio.len);
+	events.mmio_exits += 1;
+}
+
+static void mmio_no_handler(struct kvm_run *run)
+{
+	uint64_t data;
+
+	memcpy(&data, run->mmio.data, sizeof(data));
+	pr_debug("addr=%lld len=%d w=%d data=%lx\n",
+			run->mmio.phys_addr, run->mmio.len,
+			run->mmio.is_write, data);
+	TEST_FAIL("There was no MMIO exit expected.");
+}
+
 static bool check_write_in_dirty_log(struct kvm_vm *vm,
 		struct memslot_desc *ms, uint64_t host_pg_nr)
 {
@@ -440,6 +483,8 @@ static bool handle_cmd(struct kvm_vm *vm, int cmd)
 	if (cmd & CMD_CHECK_NO_S1PTW_WR_IN_DIRTY_LOG)
 		TEST_ASSERT(!check_write_in_dirty_log(vm, &memslot[PT], 0),
 				"Unexpected s1ptw write in dirty log");
+	if (cmd & CMD_RECREATE_PT_MEMSLOT_WR)
+		recreate_memslot(vm, &memslot[PT], 0);
 
 	return continue_test;
 }
@@ -456,6 +501,13 @@ void fail_vcpu_run_no_handler(int ret)
 	TEST_FAIL("Unexpected vcpu run failure\n");
 }
 
+void fail_vcpu_run_mmio_no_syndrome_handler(int ret)
+{
+	TEST_ASSERT(errno == ENOSYS,
+		"The mmio handler should have returned not implemented.");
+	events.fail_vcpu_runs += 1;
+}
+
 extern unsigned char __exec_test;
 
 void noinline __return_0x77(void)
@@ -625,10 +677,21 @@ static void setup_uffd(enum vm_guest_mode mode, struct test_params *p,
 				test->uffd_test_handler);
 }
 
+static void setup_default_handlers(struct test_desc *test)
+{
+	if (!test->mmio_handler)
+		test->mmio_handler = mmio_no_handler;
+
+	if (!test->fail_vcpu_run_handler)
+		test->fail_vcpu_run_handler = fail_vcpu_run_no_handler;
+}
+
 static void check_event_counts(struct test_desc *test)
 {
 	ASSERT_EQ(test->expected_events.aborts,	events.aborts);
 	ASSERT_EQ(test->expected_events.uffd_faults, events.uffd_faults);
+	ASSERT_EQ(test->expected_events.mmio_exits, events.mmio_exits);
+	ASSERT_EQ(test->expected_events.fail_vcpu_runs, events.fail_vcpu_runs);
 }
 
 static void free_uffd(struct test_desc *test, struct uffd_desc **uffd)
@@ -661,12 +724,20 @@ static void reset_event_counts(void)
 static bool vcpu_run_loop(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
 		struct test_desc *test)
 {
+	struct kvm_run *run;
 	bool skip_test = false;
 	struct ucall uc;
-	int stage;
+	int stage, ret;
+
+	run = vcpu->run;
 
 	for (stage = 0; ; stage++) {
-		vcpu_run(vcpu);
+		ret = _vcpu_run(vcpu);
+		if (ret) {
+			test->fail_vcpu_run_handler(ret);
+			pr_debug("Done.\n");
+			goto done;
+		}
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_SYNC:
@@ -684,6 +755,10 @@ static bool vcpu_run_loop(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
 		case UCALL_DONE:
 			pr_debug("Done.\n");
 			goto done;
+		case UCALL_NONE:
+			if (run->exit_reason == KVM_EXIT_MMIO)
+				test->mmio_handler(run);
+			break;
 		default:
 			TEST_FAIL("Unknown ucall %lu", uc.cmd);
 		}
@@ -709,6 +784,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	ucall_init(vm, NULL);
 
 	reset_event_counts();
+	setup_abort_handlers(vm, vcpu, test);
 	setup_memslots(vm, mode, p);
 
 	/*
@@ -719,7 +795,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	 */
 	load_exec_code_for_test();
 	setup_uffd(mode, p, uffd);
-	setup_abort_handlers(vm, vcpu, test);
+	setup_default_handlers(test);
 	vcpu_args_set(vcpu, 1, test);
 
 	sync_global_to_guest(vm, memslot);
@@ -810,6 +886,32 @@ static void help(char *name)
 	.expected_events	= { 0 },					\
 }
 
+#define TEST_RO_MEMSLOT(_access, _mmio_handler, _mmio_exits,			\
+			_iabt_handler, _dabt_handler, _aborts)			\
+{										\
+	.name			= SCAT3(ro_memslot, _access, _with_af),		\
+	.test_memslot_flags	= KVM_MEM_READONLY,				\
+	.pt_memslot_flags	= KVM_MEM_READONLY,				\
+	.guest_prepare		= { _PREPARE(_access) },			\
+	.guest_test		= _access,					\
+	.mmio_handler		= _mmio_handler,				\
+	.iabt_handler		= _iabt_handler,				\
+	.dabt_handler		= _dabt_handler,				\
+	.expected_events	= { .mmio_exits = _mmio_exits,			\
+				    .aborts = _aborts},				\
+}
+
+#define TEST_RO_MEMSLOT_NO_SYNDROME(_access)					\
+{										\
+	.name			= SCAT2(ro_memslot_no_syndrome, _access),	\
+	.test_memslot_flags	= KVM_MEM_READONLY,				\
+	.pt_memslot_flags	= KVM_MEM_READONLY,				\
+	.guest_test		= _access,					\
+	.dabt_handler		= dabt_s1ptw_on_ro_memslot_handler,		\
+	.fail_vcpu_run_handler	= fail_vcpu_run_mmio_no_syndrome_handler,	\
+	.expected_events	= { .aborts = 1, .fail_vcpu_runs = 1 },		\
+}
+
 static struct test_desc tests[] = {
 	/* Check that HW is setting the Access Flag (AF) (sanity checks). */
 	TEST_ACCESS(guest_read64, with_af, CMD_NONE),
@@ -877,6 +979,32 @@ static struct test_desc tests[] = {
 	TEST_DIRTY_LOG(guest_dc_zva, with_af, guest_check_write_in_dirty_log),
 	TEST_DIRTY_LOG(guest_st_preidx, with_af, guest_check_write_in_dirty_log),
 
+	/*
+	 * Try accesses when both the test and PT memslots are marked read-only
+	 * (with KVM_MEM_READONLY). The S1PTW results in an guest abort, whose
+	 * handler asks the host to recreate the memslot as writable. Note that
+	 * guests would typically panic as there's no way of asking the VMM to
+	 * perform the write for the guest (or make the memslot writable).  The
+	 * instruction then is executed: writes with a syndrome result in an
+	 * MMIO exit, writes with no syndrome (e.g., CAS) result in a failed
+	 * vcpu run, and reads/execs with and without syndroms do not fault.
+	 * Check that the expected aborts, failed vcpu runs, mmio exits
+	 * actually happen.
+	 */
+	TEST_RO_MEMSLOT(guest_read64, 0, 0, 0,
+			dabt_s1ptw_on_ro_memslot_handler, 1),
+	TEST_RO_MEMSLOT(guest_ld_preidx, 0, 0, 0,
+			dabt_s1ptw_on_ro_memslot_handler, 1),
+	TEST_RO_MEMSLOT(guest_at, 0, 0, 0,
+			dabt_s1ptw_on_ro_memslot_handler, 1),
+	TEST_RO_MEMSLOT(guest_exec, 0, 0, iabt_s1ptw_on_ro_memslot_handler,
+			0, 1),
+	TEST_RO_MEMSLOT(guest_write64, mmio_on_test_gpa_handler, 1, 0,
+			dabt_s1ptw_on_ro_memslot_handler, 1),
+	TEST_RO_MEMSLOT_NO_SYNDROME(guest_dc_zva),
+	TEST_RO_MEMSLOT_NO_SYNDROME(guest_cas),
+	TEST_RO_MEMSLOT_NO_SYNDROME(guest_st_preidx),
+
 	{ 0 }
 };
 
-- 
2.37.0.rc0.161.g10f37bed90-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
