Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A4D2C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 00:41:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13DD149EF8;
	Thu,  7 Apr 2022 20:41:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EhBVDXBvcWfq; Thu,  7 Apr 2022 20:41:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4346B4B204;
	Thu,  7 Apr 2022 20:41:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 95A0749F44
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 20:41:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qkOXy7Hd6UVb for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Apr 2022 20:41:44 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 39CE049F49
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 20:41:43 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 jz6-20020a17090b14c600b001ca9ea859afso4421904pjb.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Apr 2022 17:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=0JC27tzxF0DH2/IqsaHt7sMZZrQrpnDQEZxqc8XX/us=;
 b=G8cwN5MoapOTNKzP7bxMWmyQDpbB6oJ8uyQjQawFuIOxhSTvb9FcJ6bOOdm/rtajz0
 TkOn+Yupdz1XAeb8rv+sILLr5Z1UZUXvIclhWIziQ6oUjeCwBgTAYdRdLfD7LnMelCmp
 qvn6+i0ysj+dwQJ/6un4AcGYhePAurijQ7HgZFJyDI34u8OioMKs0fxgyJslGuWCXP7/
 myEAMb2qv7KFnejkoBLXIiILR2vku0bDl1X0yw6tz2/QFehlvJSZUy1BLO6pOywBR/I0
 juV+RCwGUIivYJOTMZzofiZsM/ORi2CGlE0CuYh8M9h63yoaa5YYctnGyuU6qrGgk8pU
 kOGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=0JC27tzxF0DH2/IqsaHt7sMZZrQrpnDQEZxqc8XX/us=;
 b=GyQqBPkFWX0WwO/SVQorAwz/5vsFRV4aijEiB3TokAlv0mq0Zlu+MJKvc1L6uyDG1B
 B9sqAXGuzqXzgpBsVAsJzyKx1bl+EC3tvuQEWnSMj04ut/75c3DY5vdQAcYhrKzkgU/p
 PchqyJgSDZ0Fa5T8f69cvez24uq2nYK2J+NT8GulQLurmbfP6JdDA+pwpp1pM8h/gOBN
 0GDEoTTPokqbSi2cauW3xY5WlGLRikifrG2VRiJsIN7JP9zoYEXU38VChsVJBnK3YBiq
 3tyNeqq05+KSEmm7ZPoydKNinJDb0y0IDY2uyHor4K9ogHu/uFG2zyj+lD55F6R7dOJZ
 Ts7g==
X-Gm-Message-State: AOAM530DDNP6NH5a+A9BEqdYTEj+cuQm9JmbfH1TNqYGRuHDuu0IdZPo
 YVPcFmXr/3kH5cjLUPAQLx+3O/ihrXJvLA==
X-Google-Smtp-Source: ABdhPJyZAQXUaQMTLgHlY/W0lQueq3rPlOYdS7IEJFB8N1AQsrUeB83cPkXxOQkOSlNvRY6V2z0bn4HWEilgMQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:903:248:b0:155:e8c6:8770 with SMTP id
 j8-20020a170903024800b00155e8c68770mr16082508plh.129.1649378502460; Thu, 07
 Apr 2022 17:41:42 -0700 (PDT)
Date: Thu,  7 Apr 2022 17:41:19 -0700
In-Reply-To: <20220408004120.1969099-1-ricarkol@google.com>
Message-Id: <20220408004120.1969099-13-ricarkol@google.com>
Mime-Version: 1.0
References: <20220408004120.1969099-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v3 12/13] KVM: selftests: aarch64: Add readonly memslot tests
 into page_fault_test
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc: maz@kernel.org, bgardon@google.com, pbonzini@redhat.com,
 axelrasmussen@google.com
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
 .../selftests/kvm/aarch64/page_fault_test.c   | 151 +++++++++++++++++-
 1 file changed, 148 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 342170e207b0..70085db873d3 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -80,6 +80,7 @@ struct memslot_desc {
 
 static struct event_cnt {
 	int aborts;
+	int mmio_exits;
 	int fail_vcpu_runs;
 	int uffd_faults;
 	/* uffd_faults is incremented from multiple threads. */
@@ -97,6 +98,8 @@ struct test_desc {
 	int (*uffd_test_handler)(int mode, int uffd, struct uffd_msg *msg);
 	void (*dabt_handler)(struct ex_regs *regs);
 	void (*iabt_handler)(struct ex_regs *regs);
+	void (*mmio_handler)(struct kvm_run *run);
+	void (*fail_vcpu_run_handler)(int ret);
 	uint32_t pt_memslot_flags;
 	uint32_t test_memslot_flags;
 	bool skip;
@@ -342,6 +345,20 @@ static void guest_code(struct test_desc *test)
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
@@ -420,6 +437,49 @@ static void punch_hole_in_memslot(struct kvm_vm *vm,
 	}
 }
 
+static int __memory_region_add(struct kvm_vm *vm, void *mem, uint32_t slot,
+		uint32_t size, uint64_t guest_addr,
+		uint32_t flags)
+{
+	struct kvm_userspace_memory_region region;
+	int ret;
+
+	region.slot = slot;
+	region.flags = flags;
+	region.guest_phys_addr = guest_addr;
+	region.memory_size = size;
+	region.userspace_addr = (uintptr_t) mem;
+	ret = ioctl(vm_get_fd(vm), KVM_SET_USER_MEMORY_REGION, &region);
+
+	return ret;
+}
+
+static void recreate_memslot(struct kvm_vm *vm, struct memslot_desc *ms,
+		uint32_t flags)
+{
+	__memory_region_add(vm, ms->hva, ms->idx, 0, ms->gpa, 0);
+	__memory_region_add(vm, ms->hva, ms->idx, ms->size, ms->gpa, flags);
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
@@ -443,6 +503,8 @@ static bool handle_cmd(struct kvm_vm *vm, int cmd)
 		punch_hole_in_memslot(vm, &memslot[PT]);
 	if (cmd & CMD_HOLE_TEST)
 		punch_hole_in_memslot(vm, &memslot[TEST]);
+	if (cmd & CMD_RECREATE_PT_MEMSLOT_WR)
+		recreate_memslot(vm, &memslot[PT], 0);
 	if (cmd & CMD_CHECK_WRITE_IN_DIRTY_LOG)
 		TEST_ASSERT(check_write_in_dirty_log(vm, &memslot[TEST], 0),
 				"Missing write in dirty log");
@@ -471,6 +533,13 @@ void fail_vcpu_run_no_handler(int ret)
 	TEST_FAIL("Unexpected vcpu run failure\n");
 }
 
+void fail_vcpu_run_mmio_no_syndrome_handler(int ret)
+{
+	TEST_ASSERT(errno == ENOSYS, "The mmio handler in the kernel"
+			" should have returned not implemented.");
+	events.fail_vcpu_runs += 1;
+}
+
 static uint64_t get_total_guest_pages(enum vm_guest_mode mode,
 		struct test_params *p)
 {
@@ -626,10 +695,21 @@ static void setup_uffd(enum vm_guest_mode mode, struct test_params *p,
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
@@ -661,12 +741,20 @@ static void reset_event_counts(void)
 
 static bool vcpu_run_loop(struct kvm_vm *vm, struct test_desc *test)
 {
+	struct kvm_run *run;
 	bool skip_test = false;
 	struct ucall uc;
-	int stage;
+	int stage, ret;
+
+	run = vcpu_state(vm, VCPU_ID);
 
 	for (stage = 0; ; stage++) {
-		vcpu_run(vm, VCPU_ID);
+		ret = _vcpu_run(vm, VCPU_ID);
+		if (ret) {
+			test->fail_vcpu_run_handler(ret);
+			pr_debug("Done.\n");
+			goto done;
+		}
 
 		switch (get_ucall(vm, VCPU_ID, &uc)) {
 		case UCALL_SYNC:
@@ -684,6 +772,10 @@ static bool vcpu_run_loop(struct kvm_vm *vm, struct test_desc *test)
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
@@ -708,6 +800,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	ucall_init(vm, NULL);
 
 	reset_event_counts();
+	setup_abort_handlers(vm, test);
 	setup_memslots(vm, mode, p);
 
 	/*
@@ -718,7 +811,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	 */
 	load_exec_code_for_test();
 	setup_uffd(mode, p, uffd);
-	setup_abort_handlers(vm, test);
+	setup_default_handlers(test);
 	vcpu_args_set(vm, 0, 1, test);
 
 	sync_global_to_guest(vm, memslot);
@@ -842,6 +935,32 @@ int main(int argc, char *argv[])
 	.expected_events	= { 0 },					\
 }
 
+#define TEST_RO_MEMSLOT(_access, _mmio_handler, _mmio_exits,			\
+			_iabt_handler, _dabt_handler, _aborts)			\
+{										\
+	.name			= SCAT3(ro_memslot, _access, _with_af),		\
+	.test_memslot_flags	= KVM_MEM_READONLY,				\
+	.pt_memslot_flags	= KVM_MEM_READONLY,				\
+	.guest_prepare		= { _PREPARE(_access) },			\
+	.guest_test 		= _access,					\
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
+	.guest_test 		= _access,					\
+	.dabt_handler		= dabt_s1ptw_on_ro_memslot_handler,		\
+	.fail_vcpu_run_handler	= fail_vcpu_run_mmio_no_syndrome_handler,	\
+	.expected_events	= { .aborts = 1, .fail_vcpu_runs = 1 },		\
+}
+
 static struct test_desc tests[] = {
 	/* Check that HW is setting the Access Flag (AF) (sanity checks). */
 	TEST_ACCESS(guest_read64, with_af, CMD_NONE),
@@ -909,6 +1028,32 @@ static struct test_desc tests[] = {
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
 	{ 0 },
 };
 
-- 
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
