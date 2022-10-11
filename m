Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5F015B7
	for <kvmarm@lists.linux.dev>; Tue, 11 Oct 2022 01:07:01 +0000 (UTC)
Received: by mail-pg1-f201.google.com with SMTP id r126-20020a632b84000000b004393806c06eso6940331pgr.4
        for <kvmarm@lists.linux.dev>; Mon, 10 Oct 2022 18:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DP+7o4VUTNDCJGmIjDcGSTOB0VbOEdBk+0Jht8aULcg=;
        b=MzJhuqrADZbTAED7a7W1G+WHx7zy4WqoAWbk7lwAR3G4FCzAHG2/MmbJChasG2fhBo
         1hv6ftMV6GuU345D1xdyBCmuPmcX8SBc8uNZV8gGLK5wit4D4FAn9S3sDl6qIJFUgb8p
         QqTzvZ2chJRGOvxpXXR30kZ33JY6StBab70813Qk7rK2VyXk+A1N6ZqwFnXOsK/z+8Lk
         02+m0F/YVYelTDJaUDMEratC6vQ6M9jOnWlYPlfMyACaXJ4+8Jxszm1Fas6Cike/TSJc
         AlQk9YUl17veHi72iTyWBn7AKH5e2r4Tt/+bN7BPyzZxkmuVsUX5Tt3Et0wun4CBVCf+
         oUpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DP+7o4VUTNDCJGmIjDcGSTOB0VbOEdBk+0Jht8aULcg=;
        b=0d7aLysVYCrCFwIfbNsHE0YxD7JeqA3/JQ8aQBlF6AVM75zFPOaE3p8ouQGyDpts0x
         WmS6fBLZsWfFFUDE3rF5MyIwo4nRcf1XJZ+c/M6U88MjP19Cb+Ve7a5m+tTyLgG9Ni/8
         q0bBgbAPoFHP6JeSTRM74Fa/2sD6Nv5Y44upvwLPWjdn2XpKJl3zp1eKcKIVPuc0l0ot
         dkQ0YPM9PRETQ7ME8E6MqBrvFLi8s4MEaqQFdTQL3kUzNGW3aTlGU9xh2EbeKNVQ6Tmn
         J8WZGpG206bfFSFq01lz//+BQfo8PbYidp3q9wBV7Y3fZGUo8B0v6RfH5DJfHB3AzfPR
         +IWg==
X-Gm-Message-State: ACrzQf0OlfeD29hCtr/Bs5t3UxgSw1t/REB6sOxGxXzueh00nMl7h3bU
	MMAnmYlYVAgf0pO0wE7gWKuhA47EhRb0Pg==
X-Google-Smtp-Source: AMsMyM4jt20hose3qBwsDVqSWBN3gukm+20XXz8ezM2XHfrEHD+MBfY6GQdcoxu/XBljEQflE2Vjljuwi4FL6g==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a63:ff55:0:b0:438:fa5d:af36 with SMTP id
 s21-20020a63ff55000000b00438fa5daf36mr19320367pgk.533.1665450420799; Mon, 10
 Oct 2022 18:07:00 -0700 (PDT)
Date: Tue, 11 Oct 2022 01:06:27 +0000
In-Reply-To: <20221011010628.1734342-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221011010628.1734342-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221011010628.1734342-14-ricarkol@google.com>
Subject: [PATCH v9 13/14] KVM: selftests: aarch64: Add readonly memslot tests
 into page_fault_test
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	andrew.jones@linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, seanjc@google.com, 
	alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com, 
	reijiw@google.com, rananta@google.com, bgardon@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221011010627.p3o8_uKB6Foh41IHJnFSBiFLXnTYlsRqMZxf5KCEH8U@z>

Add some readonly memslot tests into page_fault_test. Mark the data and/or
page-table memory regions as readonly, perform some accesses, and check
that the right fault is triggered when expected (e.g., a store with no
write-back should lead to an mmio exit).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/aarch64/page_fault_test.c   | 102 +++++++++++++++++-
 1 file changed, 101 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 06fab0c00184..51d74909c50f 100644
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
@@ -415,6 +419,31 @@ static bool punch_hole_in_backing_store(struct kvm_vm *vm,
 	return true;
 }
 
+static void mmio_on_test_gpa_handler(struct kvm_vm *vm, struct kvm_run *run)
+{
+	struct userspace_mem_region *region;
+	void *hva;
+
+	region = vm_get_mem_region(vm, MEM_REGION_TEST_DATA);
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
@@ -462,6 +491,18 @@ static bool handle_cmd(struct kvm_vm *vm, int cmd)
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
 
@@ -563,9 +604,20 @@ static void setup_memslots(struct kvm_vm *vm, struct test_params *p)
 	vm->memslots[MEM_REGION_TEST_DATA] = TEST_DATA_MEMSLOT;
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
@@ -590,10 +642,18 @@ static void reset_event_counts(void)
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
@@ -607,6 +667,10 @@ static void vcpu_run_loop(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
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
@@ -646,6 +710,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	load_exec_code_for_test(vm);
 	setup_uffd(vm, p, &pt_uffd, &data_uffd);
 	setup_abort_handlers(vm, vcpu, test);
+	setup_default_handlers(test);
 	vcpu_args_set(vcpu, 1, test);
 
 	vcpu_run_loop(vm, vcpu, test);
@@ -733,6 +798,25 @@ static void help(char *name)
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
@@ -807,6 +891,22 @@ static struct test_desc tests[] = {
 	TEST_DIRTY_LOG(guest_dc_zva, with_af, guest_check_write_in_dirty_log),
 	TEST_DIRTY_LOG(guest_st_preidx, with_af, guest_check_write_in_dirty_log),
 
+	/*
+	 * Try accesses when the data memory region is marked read-only
+	 * (with KVM_MEM_READONLY). Writes with a syndrome result in an
+	 * MMIO exit, writes with no syndrome (e.g., CAS) result in a
+	 * failed vcpu run, and reads/execs with and without syndroms do
+	 * not fault.
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
2.38.0.rc1.362.ged0d419d3c-goog

