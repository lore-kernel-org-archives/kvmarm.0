Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEE30C433FE
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 00:41:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD0394B1A3;
	Thu,  7 Apr 2022 20:41:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id E0XYmnhUAhRG; Thu,  7 Apr 2022 20:41:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 628BC4B1EF;
	Thu,  7 Apr 2022 20:41:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CB184A49C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 20:41:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7zC1YwWglxzF for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Apr 2022 20:41:45 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C18264A534
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 20:41:44 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 c10-20020a170902d48a00b00156590dfa4cso3598169plg.20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Apr 2022 17:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=rkJVDUmk9B8/NrjotnCUiZyGZn+HhyJh8bavuSxqe7Q=;
 b=WlIRLidhHhOdmQkTKNMvcKUC89C0kIToiVd+e5owpY2xeNryaNVhF1TFPdiN8FB9dd
 9vwfFyh7JU0Rf8ae14/kZGx4rDhICsLQbODoJTteLUI39T9iqAwZNtdw2I4WZ2n1QpIb
 iFGb085E3kFSXx2+f3I2j9iT9/qCnxCkuAqjpvZFYdNxEpRB9lXV1paUDHn7V2Vx1Rqx
 5sGTabHLK5od1QNdYQDa8HNgZvXZjD7mtyzGewnr3cCGs5j2DPBcGcMY/R/WRh2HpYfa
 RfP5jOw8O/P1+SX9/+R6OP5tsjeDgHK/4BT9cF6xCwQIQsmZBaUrHrJdxxPPGZ6Zpk5F
 Jlaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=rkJVDUmk9B8/NrjotnCUiZyGZn+HhyJh8bavuSxqe7Q=;
 b=WOb9GU4RXWEwyf+ZHREK6Erb0qIokyQ4n+ww0RV27EKeEsHW9yHXVKdB0UCcO9pWcY
 yV0NOE610NgHI0U7/3n2ELtAiDGrQSgrY/mloV7bEjp7QYVq6uZtseDCSuSfMc5JBmgl
 WSS7izifY0EWh0d7OXko2KsXpNLQ3bDRoFHT4z5jJ7aL1bo9ovu5tAmWTrOZcVTRl5BK
 25kH9iBCbvRcf5V/MJoz19Of5MmG6+EvZibe/w/P/SzPGwEG+CqIK27scY1bceDlwuDi
 BX7Eme3FCBmG2zjdoGSEe0d/NzsRvQqY1Lm+sG9XULJsr2a/I9zztv94Vwey2jJyfzBm
 IhCg==
X-Gm-Message-State: AOAM5307PAJOwQ8Y3WRVzckOQSqliiGMvdQcSxqeAaF+JgXVnBenF8nC
 c8ACr6sRIQFtt2eQQa0bGK8w2i3j9Nwy8g==
X-Google-Smtp-Source: ABdhPJzzMftRgV9ggpc7b8MdVAiO90/RVlExwbOxM3uYNmuezPVXHzXCAv9n4tVSfSGh+0AjAau6Yf/4QFXXHQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:aa7:88d4:0:b0:4fd:ad26:c52f with SMTP id
 k20-20020aa788d4000000b004fdad26c52fmr16700591pff.25.1649378504066; Thu, 07
 Apr 2022 17:41:44 -0700 (PDT)
Date: Thu,  7 Apr 2022 17:41:20 -0700
In-Reply-To: <20220408004120.1969099-1-ricarkol@google.com>
Message-Id: <20220408004120.1969099-14-ricarkol@google.com>
Mime-Version: 1.0
References: <20220408004120.1969099-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v3 13/13] KVM: selftests: aarch64: Add mix of tests into
 page_fault_test
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

Add some mix of tests into page_fault_test: memslots with all the
pairwise combinations of read-only, userfaultfd, and dirty-logging.  For
example, writing into a read-only memslot which has a hole handled with
userfaultfd.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/aarch64/page_fault_test.c   | 178 ++++++++++++++++++
 1 file changed, 178 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 70085db873d3..fd83f0adc17f 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -419,6 +419,12 @@ static int uffd_test_read_handler(int mode, int uffd, struct uffd_msg *msg)
 	return uffd_generic_handler(mode, uffd, msg, &memslot[TEST], false);
 }
 
+static int uffd_no_handler(int mode, int uffd, struct uffd_msg *msg)
+{
+	TEST_FAIL("There was no UFFD fault expected.");
+	return -1;
+}
+
 static void punch_hole_in_memslot(struct kvm_vm *vm,
 		struct memslot_desc *memslot)
 {
@@ -935,6 +941,22 @@ int main(int argc, char *argv[])
 	.expected_events	= { 0 },					\
 }
 
+#define TEST_UFFD_AND_DIRTY_LOG(_access, _with_af, _uffd_test_handler,		\
+		_uffd_faults, _test_check)					\
+{										\
+	.name			= SCAT3(uffd_and_dirty_log, _access, _with_af),	\
+	.test_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
+	.pt_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
+	.guest_prepare		= { _PREPARE(_with_af),				\
+				    _PREPARE(_access) },			\
+	.guest_test		= _access,					\
+	.mem_mark_cmd		= CMD_HOLE_TEST | CMD_HOLE_PT,			\
+	.guest_test_check	= { _CHECK(_with_af), _test_check },		\
+	.uffd_test_handler	= _uffd_test_handler,				\
+	.uffd_pt_handler	= uffd_pt_write_handler,			\
+	.expected_events	= { .uffd_faults = _uffd_faults, },		\
+}
+
 #define TEST_RO_MEMSLOT(_access, _mmio_handler, _mmio_exits,			\
 			_iabt_handler, _dabt_handler, _aborts)			\
 {										\
@@ -961,6 +983,71 @@ int main(int argc, char *argv[])
 	.expected_events	= { .aborts = 1, .fail_vcpu_runs = 1 },		\
 }
 
+#define TEST_RO_MEMSLOT_AND_DIRTY_LOG(_access, _mmio_handler, _mmio_exits,	\
+				      _iabt_handler, _dabt_handler, _aborts,	\
+				      _test_check)				\
+{										\
+	.name			= SCAT3(ro_memslot, _access, _with_af),		\
+	.test_memslot_flags	= KVM_MEM_READONLY | KVM_MEM_LOG_DIRTY_PAGES,	\
+	.pt_memslot_flags	= KVM_MEM_READONLY | KVM_MEM_LOG_DIRTY_PAGES,	\
+	.guest_prepare		= { _PREPARE(_access) },			\
+	.guest_test 		= _access,					\
+	.guest_test_check	= { _test_check },				\
+	.mmio_handler		= _mmio_handler,				\
+	.iabt_handler		= _iabt_handler,				\
+	.dabt_handler		= _dabt_handler,				\
+	.expected_events	= { .mmio_exits = _mmio_exits,			\
+				    .aborts = _aborts},				\
+}
+
+#define TEST_RO_MEMSLOT_NO_SYNDROME_AND_DIRTY_LOG(_access, _test_check)		\
+{										\
+	.name			= SCAT2(ro_memslot_no_syn_and_dlog, _access),	\
+	.test_memslot_flags	= KVM_MEM_READONLY | KVM_MEM_LOG_DIRTY_PAGES,	\
+	.pt_memslot_flags	= KVM_MEM_READONLY | KVM_MEM_LOG_DIRTY_PAGES,	\
+	.guest_test 		= _access,					\
+	.guest_test_check	= { _test_check },				\
+	.dabt_handler		= dabt_s1ptw_on_ro_memslot_handler,		\
+	.fail_vcpu_run_handler	= fail_vcpu_run_mmio_no_syndrome_handler,	\
+	.expected_events	= { .aborts = 1, .fail_vcpu_runs = 1 },		\
+}
+
+#define TEST_RO_MEMSLOT_AND_UFFD(_access, _mmio_handler, _mmio_exits,		\
+				 _iabt_handler, _dabt_handler, _aborts,		\
+				_uffd_test_handler, _uffd_faults)		\
+{										\
+	.name			= SCAT2(ro_memslot_uffd, _access),		\
+	.test_memslot_flags	= KVM_MEM_READONLY,				\
+	.pt_memslot_flags	= KVM_MEM_READONLY,				\
+	.mem_mark_cmd		= CMD_HOLE_TEST | CMD_HOLE_PT,			\
+	.guest_prepare		= { _PREPARE(_access) },			\
+	.guest_test 		= _access,					\
+	.uffd_test_handler	= _uffd_test_handler,				\
+	.uffd_pt_handler	= uffd_pt_write_handler,			\
+	.mmio_handler		= _mmio_handler,				\
+	.iabt_handler		= _iabt_handler,				\
+	.dabt_handler		= _dabt_handler,				\
+	.expected_events	= { .mmio_exits = _mmio_exits,			\
+				    .aborts = _aborts,				\
+				    .uffd_faults = _uffd_faults },		\
+}
+
+#define TEST_RO_MEMSLOT_NO_SYNDROME_AND_UFFD(_access, _uffd_test_handler,	\
+					     _uffd_faults)			\
+{										\
+	.name			= SCAT2(ro_memslot_no_syndrome, _access),	\
+	.test_memslot_flags	= KVM_MEM_READONLY,				\
+	.pt_memslot_flags	= KVM_MEM_READONLY,				\
+	.mem_mark_cmd		= CMD_HOLE_TEST | CMD_HOLE_PT,			\
+	.guest_test 		= _access,					\
+	.uffd_test_handler	= _uffd_test_handler,				\
+	.uffd_pt_handler	= uffd_pt_write_handler,			\
+	.dabt_handler		= dabt_s1ptw_on_ro_memslot_handler,		\
+	.fail_vcpu_run_handler	= fail_vcpu_run_mmio_no_syndrome_handler,	\
+	.expected_events	= { .aborts = 1, .fail_vcpu_runs = 1,		\
+				    .uffd_faults = _uffd_faults },		\
+}
+
 static struct test_desc tests[] = {
 	/* Check that HW is setting the Access Flag (AF) (sanity checks). */
 	TEST_ACCESS(guest_read64, with_af, CMD_NONE),
@@ -1028,6 +1115,35 @@ static struct test_desc tests[] = {
 	TEST_DIRTY_LOG(guest_dc_zva, with_af, guest_check_write_in_dirty_log),
 	TEST_DIRTY_LOG(guest_st_preidx, with_af, guest_check_write_in_dirty_log),
 
+	/*
+	 * Access when the test and PT memslots are both marked for dirty
+	 * logging and UFFD at the same time. The expected result is that
+	 * writes should mark the dirty log and trigger a userfaultfd write
+	 * fault.  Reads/execs should result in a read userfaultfd fault, and
+	 * nothing in the dirty log.  The S1PTW in all cases should result in a
+	 * write in the dirty log and a userfaultfd write.
+	 */
+	TEST_UFFD_AND_DIRTY_LOG(guest_read64, with_af, uffd_test_read_handler, 2,
+			guest_check_no_write_in_dirty_log),
+	/* no_af should also lead to a PT write. */
+	TEST_UFFD_AND_DIRTY_LOG(guest_read64, no_af, uffd_test_read_handler, 2,
+			guest_check_no_write_in_dirty_log),
+	TEST_UFFD_AND_DIRTY_LOG(guest_ld_preidx, with_af, uffd_test_read_handler,
+			2, guest_check_no_write_in_dirty_log),
+	TEST_UFFD_AND_DIRTY_LOG(guest_at, with_af, 0, 1,
+			guest_check_no_write_in_dirty_log),
+	TEST_UFFD_AND_DIRTY_LOG(guest_exec, with_af, uffd_test_read_handler, 2,
+			guest_check_no_write_in_dirty_log),
+	TEST_UFFD_AND_DIRTY_LOG(guest_write64, with_af, uffd_test_write_handler,
+			2, guest_check_write_in_dirty_log),
+	TEST_UFFD_AND_DIRTY_LOG(guest_cas, with_af, uffd_test_read_handler, 2,
+			guest_check_write_in_dirty_log),
+	TEST_UFFD_AND_DIRTY_LOG(guest_dc_zva, with_af, uffd_test_write_handler,
+			2, guest_check_write_in_dirty_log),
+	TEST_UFFD_AND_DIRTY_LOG(guest_st_preidx, with_af,
+			uffd_test_write_handler, 2,
+			guest_check_write_in_dirty_log),
+
 	/*
 	 * Try accesses when both the test and PT memslots are marked read-only
 	 * (with KVM_MEM_READONLY). The S1PTW results in an guest abort, whose
@@ -1054,6 +1170,68 @@ static struct test_desc tests[] = {
 	TEST_RO_MEMSLOT_NO_SYNDROME(guest_cas),
 	TEST_RO_MEMSLOT_NO_SYNDROME(guest_st_preidx),
 
+	/*
+	 * Access when both the test and PT memslots are read-only and marked
+	 * for dirty logging at the same time. The expected result is that
+	 * there should be no write in the dirty log. The S1PTW results in an
+	 * abort which is handled by asking the host to recreate the memslot as
+	 * writable. The readonly handling are the same as if the memslots were
+	 * not marked for dirty logging: writes with a syndrome result in an
+	 * MMIO exit, and writes with no syndrome result in a failed vcpu run.
+	 */
+	TEST_RO_MEMSLOT_AND_DIRTY_LOG(guest_read64, 0, 0, 0,
+			dabt_s1ptw_on_ro_memslot_handler, 1,
+			guest_check_no_write_in_dirty_log),
+	TEST_RO_MEMSLOT_AND_DIRTY_LOG(guest_ld_preidx, 0, 0, 0,
+			dabt_s1ptw_on_ro_memslot_handler, 1,
+			guest_check_no_write_in_dirty_log),
+	TEST_RO_MEMSLOT_AND_DIRTY_LOG(guest_at, 0, 0, 0,
+			dabt_s1ptw_on_ro_memslot_handler, 1,
+			guest_check_no_write_in_dirty_log),
+	TEST_RO_MEMSLOT_AND_DIRTY_LOG(guest_exec, 0, 0,
+			iabt_s1ptw_on_ro_memslot_handler, 0, 1,
+			guest_check_no_write_in_dirty_log),
+	TEST_RO_MEMSLOT_AND_DIRTY_LOG(guest_write64, mmio_on_test_gpa_handler,
+			1, 0, dabt_s1ptw_on_ro_memslot_handler, 1,
+			guest_check_no_write_in_dirty_log),
+	TEST_RO_MEMSLOT_NO_SYNDROME_AND_DIRTY_LOG(guest_dc_zva,
+			guest_check_no_write_in_dirty_log),
+	TEST_RO_MEMSLOT_NO_SYNDROME_AND_DIRTY_LOG(guest_cas,
+			guest_check_no_write_in_dirty_log),
+	TEST_RO_MEMSLOT_NO_SYNDROME_AND_DIRTY_LOG(guest_st_preidx,
+			guest_check_no_write_in_dirty_log),
+
+	/*
+	 * Access when both the test and PT memslots are read-only, and punched
+	 * with holes tracked with userfaultfd.  The expected result is the
+	 * union of both userfaultfd and read-only behaviors. For example,
+	 * write accesses result in a userfaultfd write fault and an MMIO exit.
+	 * Writes with no syndrome result in a failed vcpu run and no
+	 * userfaultfd write fault. Reads only result in userfaultfd getting
+	 * triggered.
+	 */
+	TEST_RO_MEMSLOT_AND_UFFD(guest_read64, 0, 0, 0,
+			dabt_s1ptw_on_ro_memslot_handler, 1,
+			uffd_test_read_handler, 2),
+	TEST_RO_MEMSLOT_AND_UFFD(guest_ld_preidx, 0, 0, 0,
+			dabt_s1ptw_on_ro_memslot_handler, 1,
+			uffd_test_read_handler, 2),
+	TEST_RO_MEMSLOT_AND_UFFD(guest_at, 0, 0, 0,
+			dabt_s1ptw_on_ro_memslot_handler, 1,
+			uffd_no_handler, 1),
+	TEST_RO_MEMSLOT_AND_UFFD(guest_exec, 0, 0,
+			iabt_s1ptw_on_ro_memslot_handler, 0, 1,
+			uffd_test_read_handler, 2),
+	TEST_RO_MEMSLOT_AND_UFFD(guest_write64, mmio_on_test_gpa_handler, 1, 0,
+			dabt_s1ptw_on_ro_memslot_handler, 1,
+			uffd_test_write_handler, 2),
+	TEST_RO_MEMSLOT_NO_SYNDROME_AND_UFFD(guest_cas,
+			uffd_test_read_handler, 2),
+	TEST_RO_MEMSLOT_NO_SYNDROME_AND_UFFD(guest_dc_zva,
+			uffd_no_handler, 1),
+	TEST_RO_MEMSLOT_NO_SYNDROME_AND_UFFD(guest_st_preidx,
+			uffd_no_handler, 1),
+
 	{ 0 },
 };
 
-- 
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
