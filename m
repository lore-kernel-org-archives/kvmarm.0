Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B00C6FA82
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 04:15:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BBB94B69D;
	Tue, 20 Sep 2022 00:15:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N5RTxwwyFicj; Tue, 20 Sep 2022 00:15:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 365074B750;
	Tue, 20 Sep 2022 00:15:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD40A4B6EE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 00:15:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QtLT4jMSH+el for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 00:15:35 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A767F4B62F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 00:15:32 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 w1-20020a63d741000000b0042c254a4ccdso827646pgi.15
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 21:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date;
 bh=3IXMWWfhtSsnWeEyyRGnY8bQzfkxRCulrm5lrBr2778=;
 b=HqIras6OrXifXEJ2Qi2ZLU7qF0oQKywtXsLvz6sAIHSTA0Wi6ta86vc5lJrAxLNSMi
 /Aez3IGNCp3wz5W9xl+e5wwDQwBnBCAFgAU60Wl9DPllXL3zo68zav7xcEZDryjj5ArX
 8KgJksHVoy6Ckszk3kwztXywShkxUKHralVmy9fmQFZzkhbvu4tSCm0Mohe2iYTHtsFB
 R/L6gco9DVXoBa0/+NiXvh7P1DbdZ4kxZErAUS4NP7hTeYll3duaSxFG7PVAF8ffwJLC
 pThEg/5Ctqt5rsCWCglGu5+gRy1OKVQn4PIa8RP8XOc2Dsu+KhqUUtSNwLvTT6S7nu9n
 Wk0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=3IXMWWfhtSsnWeEyyRGnY8bQzfkxRCulrm5lrBr2778=;
 b=mPd103u96O4v8yZceCbz4GFbV7nx1qtmmEvnhrdeoD1i+lH8NhOOLdHljccVE7THYM
 xKlllkkJRb1ia6nLH/yS7ocrPYfdCYTEjHuVumJbRIrDksi1lcAVcymf0LvnZV2pEPCX
 L1FfcWywhHXPgkd8eEnYSHDfTEUcg6F7AfgSzgpdvubbScOe3UB6H+kD2aLnZTLcqJ4v
 2gl7/tXLjPtaoyvdOPexjSDzPwtmH1MnDXEWwcY/KvijYQbY4mqBjuXdITJ9Lwp0jdVQ
 K1jsGg687MSfduXt3eHAAx5S0rbI/eFM7YMqLDJFse6glwzvTZ4yl9fQicQy/61OeIBR
 IQig==
X-Gm-Message-State: ACrzQf0lzVNRH3mTyadOTVmIQfiv4jVgHeWWW/MboLbVjTIiq2oB4f58
 KfnlFExstNZKOTFJwyMVamEfc/nmvwXDlQ==
X-Google-Smtp-Source: AMsMyM5uPS3nbdKQXMQGEozz2wSqm+MFNrHvMq3oU+cJfx4UlcuRkZv4apjvUpRz1nd0mCuFtUhRrCPu4iUgCQ==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:1a08:b0:545:362c:b219 with SMTP
 id g8-20020a056a001a0800b00545362cb219mr22264440pfv.27.1663647331691; Mon, 19
 Sep 2022 21:15:31 -0700 (PDT)
Date: Tue, 20 Sep 2022 04:15:08 +0000
In-Reply-To: <20220920041509.3131141-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220920041509.3131141-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920041509.3131141-13-ricarkol@google.com>
Subject: [PATCH v6 12/13] KVM: selftests: aarch64: Add readonly memslot tests
 into page_fault_test
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
Cc: maz@kernel.org, bgardon@google.com, pbonzini@redhat.com,
 axelrasmussen@google.com, dmatlack@google.com
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
 .../selftests/kvm/aarch64/page_fault_test.c   | 101 +++++++++++++++++-
 1 file changed, 100 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 51b2ac260db5..386c20b47723 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -41,6 +41,8 @@ static uint64_t *guest_test_memory = (uint64_t *)TEST_GVA;
 #define CHECK_FN_NR				10
 
 static struct event_cnt {
+	int mmio_exits;
+	int fail_vcpu_runs;
 	int uffd_faults;
 	/* uffd_faults is incremented from multiple threads. */
 	pthread_mutex_t uffd_faults_mutex;
@@ -57,6 +59,8 @@ struct test_desc {
 	uffd_handler_t uffd_data_handler;
 	void (*dabt_handler)(struct ex_regs *regs);
 	void (*iabt_handler)(struct ex_regs *regs);
+	void (*mmio_handler)(struct kvm_vm *vm, struct kvm_run *run);
+	void (*fail_vcpu_run_handler)(int ret);
 	uint32_t pt_memslot_flags;
 	uint32_t data_memslot_flags;
 	bool skip;
@@ -418,6 +422,31 @@ static bool punch_hole_in_memslot(struct kvm_vm *vm,
 	return true;
 }
 
+static void mmio_on_test_gpa_handler(struct kvm_vm *vm, struct kvm_run *run)
+{
+	struct userspace_mem_region *region;
+	void *hva;
+
+	region = vm_get_mem_region(vm, MEM_REGION_DATA);
+	hva = (void *)region->region.userspace_addr;
+
+	ASSERT_EQ(run->mmio.phys_addr, region->region.guest_phys_addr);
+
+	memcpy(hva, run->mmio.data, run->mmio.len);
+	events.mmio_exits += 1;
+}
+
+static void mmio_no_handler(struct kvm_vm *vm, struct kvm_run *run)
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
 		struct userspace_mem_region *region, uint64_t host_pg_nr)
 {
@@ -465,6 +494,18 @@ static bool handle_cmd(struct kvm_vm *vm, int cmd)
 	return continue_test;
 }
 
+void fail_vcpu_run_no_handler(int ret)
+{
+	TEST_FAIL("Unexpected vcpu run failure\n");
+}
+
+void fail_vcpu_run_mmio_no_syndrome_handler(int ret)
+{
+	TEST_ASSERT(errno == ENOSYS,
+		"The mmio handler should have returned not implemented.");
+	events.fail_vcpu_runs += 1;
+}
+
 typedef uint32_t aarch64_insn_t;
 extern aarch64_insn_t __exec_test[2];
 
@@ -570,9 +611,20 @@ static void setup_memslots(struct kvm_vm *vm, struct test_params *p)
 	vm->memslots[MEM_REGION_DATA] = DATA_MEMSLOT;
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
 	ASSERT_EQ(test->expected_events.uffd_faults, events.uffd_faults);
+	ASSERT_EQ(test->expected_events.mmio_exits, events.mmio_exits);
+	ASSERT_EQ(test->expected_events.fail_vcpu_runs, events.fail_vcpu_runs);
 }
 
 static void print_test_banner(enum vm_guest_mode mode, struct test_params *p)
@@ -597,10 +649,18 @@ static void reset_event_counts(void)
 static void vcpu_run_loop(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
 		struct test_desc *test)
 {
+	struct kvm_run *run;
 	struct ucall uc;
+	int ret;
+
+	run = vcpu->run;
 
 	for (;;) {
-		vcpu_run(vcpu);
+		ret = _vcpu_run(vcpu);
+		if (ret) {
+			test->fail_vcpu_run_handler(ret);
+			goto done;
+		}
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_SYNC:
@@ -614,6 +674,10 @@ static void vcpu_run_loop(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
 			break;
 		case UCALL_DONE:
 			goto done;
+		case UCALL_NONE:
+			if (run->exit_reason == KVM_EXIT_MMIO)
+				test->mmio_handler(vm, run);
+			break;
 		default:
 			TEST_FAIL("Unknown ucall %lu", uc.cmd);
 		}
@@ -654,6 +718,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	load_exec_code_for_test(vm);
 	setup_uffd(vm, p, &pt_uffd, &data_uffd);
 	setup_abort_handlers(vm, vcpu, test);
+	setup_default_handlers(test);
 	vcpu_args_set(vcpu, 1, test);
 
 	vcpu_run_loop(vm, vcpu, test);
@@ -741,6 +806,25 @@ static void help(char *name)
 	.expected_events	= { 0 },					\
 }
 
+#define TEST_RO_MEMSLOT(_access, _mmio_handler, _mmio_exits)			\
+{										\
+	.name			= SCAT3(ro_memslot, _access, _with_af),		\
+	.data_memslot_flags	= KVM_MEM_READONLY,				\
+	.guest_prepare		= { _PREPARE(_access) },			\
+	.guest_test		= _access,					\
+	.mmio_handler		= _mmio_handler,				\
+	.expected_events	= { .mmio_exits = _mmio_exits },		\
+}
+
+#define TEST_RO_MEMSLOT_NO_SYNDROME(_access)					\
+{										\
+	.name			= SCAT2(ro_memslot_no_syndrome, _access),	\
+	.data_memslot_flags	= KVM_MEM_READONLY,				\
+	.guest_test		= _access,					\
+	.fail_vcpu_run_handler	= fail_vcpu_run_mmio_no_syndrome_handler,	\
+	.expected_events	= { .fail_vcpu_runs = 1 },			\
+}
+
 static struct test_desc tests[] = {
 
 	/* Check that HW is setting the Access Flag (AF) (sanity checks). */
@@ -809,6 +893,21 @@ static struct test_desc tests[] = {
 	TEST_DIRTY_LOG(guest_dc_zva, with_af, guest_check_write_in_dirty_log),
 	TEST_DIRTY_LOG(guest_st_preidx, with_af, guest_check_write_in_dirty_log),
 
+	/*
+	 * Try accesses when the data memslot is marked read-only (with
+	 * KVM_MEM_READONLY). Writes with a syndrome result in an MMIO exit,
+	 * writes with no syndrome (e.g., CAS) result in a failed vcpu run, and
+	 * reads/execs with and without syndroms do not fault.
+	 */
+	TEST_RO_MEMSLOT(guest_read64, 0, 0),
+	TEST_RO_MEMSLOT(guest_ld_preidx, 0, 0),
+	TEST_RO_MEMSLOT(guest_at, 0, 0),
+	TEST_RO_MEMSLOT(guest_exec, 0, 0),
+	TEST_RO_MEMSLOT(guest_write64, mmio_on_test_gpa_handler, 1),
+	TEST_RO_MEMSLOT_NO_SYNDROME(guest_dc_zva),
+	TEST_RO_MEMSLOT_NO_SYNDROME(guest_cas),
+	TEST_RO_MEMSLOT_NO_SYNDROME(guest_st_preidx),
+
 	{ 0 }
 };
 
-- 
2.37.3.968.ga6b4b080e4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
