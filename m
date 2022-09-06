Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDE94C6FA86
	for <kvmarm@archiver.kernel.org>; Tue,  6 Sep 2022 18:10:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B8764BCD5;
	Tue,  6 Sep 2022 14:10:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q-uOlReF7aSM; Tue,  6 Sep 2022 14:10:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 419914BC68;
	Tue,  6 Sep 2022 14:10:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CB004BB94
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2022 14:10:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iaM4dshX6QXu for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2022 14:10:02 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C2F084BCD2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2022 14:10:01 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-34500a9b644so79193037b3.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Sep 2022 11:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date;
 bh=6g0+sbXE3jF6Ff45WLsR6oO1jnRUdtkvFHmn/gX5h9c=;
 b=au9jbTpNJBac5Cnu8oklgE3sYDslOdVxaG92ziImQk/BdZkvjaZ8TNrbt5dfjaeGMe
 QRuUk2YaUlT1seVuAlv8+eYdIPFhqGGeZoHdeA5owfnMDwPI1R3HAh+j5Bnhk4T2uTpP
 LcqAZEpYNBbeEA+eyvcjuiXTMYMWyhL+AQUzFFjZFsy2YwB1G3eRhJAQ7mO4w5gajyE+
 +uy4cxuECBVqFd8/wp5OJUs8Kzx7IDoCEfavo5Fn3qbHRxdtDuo8eO7uZxC7/ywHSt6I
 S7ss17xFufZ+SaYU92Mb5Pf1BU7ZaZTwUA/9ds6Jz4JPLI/iPqz9Fqg+fiZDuSp4tzpO
 BLAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=6g0+sbXE3jF6Ff45WLsR6oO1jnRUdtkvFHmn/gX5h9c=;
 b=d5kGh4mx0a6Ds3t9MP01ymomYHNAv7XU0BM8FPuZdYsXLjIhda4TwKH9gw02Frqne9
 AeklP2XDM0A5HM3huL6XS0iY1rBxs/a4Zo3u9vaXBXiptuw/IDRnQwfoPl5UaEm6reI4
 YVpCfCHuKuw9ki+PlUDplh4hNuEZONxhirzjFIxhv5reoWpEn9v5b3w9HPcgsGxG1s74
 G51zrewYLo2vU2KHUHmpYLVWmRHNRSBckb0WgxpvNhIlfPNu1tI2voJUU9pkHhtxVlu4
 lCScf5Gs5DhgpG3c5mPYByhcO+bOI/FnstrVMWLn2xE5yx7QSptCtLbbkZE140sd0NpD
 NPtg==
X-Gm-Message-State: ACgBeo3VCvr3Udv7zXyaNtjXRkMpmI/JvVxxvJ8RmBscy0LXncV8nfqE
 MJJiNXMj3pnbpwq/nVsOp2SAEnBxDXPB2A==
X-Google-Smtp-Source: AA6agR5LsAm+3Z5RCyxrKZ6AtzEpNjpMkzP0+YEghygheP3GZAOFm7UhPWzjkbLQmjNDYklSWyrNBB+zPQ3EXA==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:f46:0:b0:696:568:59f1 with SMTP id
 67-20020a250f46000000b00696056859f1mr39008757ybp.455.1662487801312; Tue, 06
 Sep 2022 11:10:01 -0700 (PDT)
Date: Tue,  6 Sep 2022 18:09:30 +0000
In-Reply-To: <20220906180930.230218-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220906180930.230218-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220906180930.230218-14-ricarkol@google.com>
Subject: [PATCH v6 13/13] KVM: selftests: aarch64: Add mix of tests into
 page_fault_test
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

Add some mix of tests into page_fault_test: memslots with all the
pairwise combinations of read-only, userfaultfd, and dirty-logging.  For
example, writing into a read-only memslot which has a hole handled with
userfaultfd.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/aarch64/page_fault_test.c   | 155 ++++++++++++++++++
 1 file changed, 155 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 39fc2103fdd6..60a6a8a45fa4 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -399,6 +399,12 @@ static void free_uffd(struct test_desc *test, struct uffd_desc *pt_uffd,
 	free(data_args.copy);
 }
 
+static int uffd_no_handler(int mode, int uffd, struct uffd_msg *msg)
+{
+	TEST_FAIL("There was no UFFD fault expected.");
+	return -1;
+}
+
 /* Returns false if the test should be skipped. */
 static bool punch_hole_in_memslot(struct kvm_vm *vm,
 				  struct userspace_mem_region *region)
@@ -827,6 +833,22 @@ static void help(char *name)
 	.expected_events	= { 0 },					\
 }
 
+#define TEST_UFFD_AND_DIRTY_LOG(_access, _with_af, _uffd_data_handler,		\
+				_uffd_faults, _test_check)			\
+{										\
+	.name			= SCAT3(uffd_and_dirty_log, _access, _with_af),	\
+	.data_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
+	.pt_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
+	.guest_prepare		= { _PREPARE(_with_af),				\
+				    _PREPARE(_access) },			\
+	.guest_test		= _access,					\
+	.mem_mark_cmd		= CMD_HOLE_DATA | CMD_HOLE_PT,			\
+	.guest_test_check	= { _CHECK(_with_af), _test_check },		\
+	.uffd_data_handler	= _uffd_data_handler,				\
+	.uffd_pt_handler	= uffd_pt_write_handler,			\
+	.expected_events	= { .uffd_faults = _uffd_faults, },		\
+}
+
 #define TEST_RO_MEMSLOT(_access, _mmio_handler, _mmio_exits)			\
 {										\
 	.name			= SCAT3(ro_memslot, _access, _with_af),		\
@@ -846,6 +868,59 @@ static void help(char *name)
 	.expected_events	= { .fail_vcpu_runs = 1 },			\
 }
 
+#define TEST_RO_MEMSLOT_AND_DIRTY_LOG(_access, _mmio_handler, _mmio_exits,	\
+				      _test_check)				\
+{										\
+	.name			= SCAT3(ro_memslot, _access, _with_af),		\
+	.data_memslot_flags	= KVM_MEM_READONLY | KVM_MEM_LOG_DIRTY_PAGES,	\
+	.pt_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
+	.guest_prepare		= { _PREPARE(_access) },			\
+	.guest_test		= _access,					\
+	.guest_test_check	= { _test_check },				\
+	.mmio_handler		= _mmio_handler,				\
+	.expected_events	= { .mmio_exits = _mmio_exits},			\
+}
+
+#define TEST_RO_MEMSLOT_NO_SYNDROME_AND_DIRTY_LOG(_access, _test_check)		\
+{										\
+	.name			= SCAT2(ro_memslot_no_syn_and_dlog, _access),	\
+	.data_memslot_flags	= KVM_MEM_READONLY | KVM_MEM_LOG_DIRTY_PAGES,	\
+	.pt_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
+	.guest_test		= _access,					\
+	.guest_test_check	= { _test_check },				\
+	.fail_vcpu_run_handler	= fail_vcpu_run_mmio_no_syndrome_handler,	\
+	.expected_events	= { .fail_vcpu_runs = 1 },			\
+}
+
+#define TEST_RO_MEMSLOT_AND_UFFD(_access, _mmio_handler, _mmio_exits,		\
+				 _uffd_data_handler, _uffd_faults)		\
+{										\
+	.name			= SCAT2(ro_memslot_uffd, _access),		\
+	.data_memslot_flags	= KVM_MEM_READONLY,				\
+	.mem_mark_cmd		= CMD_HOLE_DATA | CMD_HOLE_PT,			\
+	.guest_prepare		= { _PREPARE(_access) },			\
+	.guest_test		= _access,					\
+	.uffd_data_handler	= _uffd_data_handler,				\
+	.uffd_pt_handler	= uffd_pt_write_handler,			\
+	.mmio_handler		= _mmio_handler,				\
+	.expected_events	= { .mmio_exits = _mmio_exits,			\
+				    .uffd_faults = _uffd_faults },		\
+}
+
+#define TEST_RO_MEMSLOT_NO_SYNDROME_AND_UFFD(_access, _uffd_data_handler,	\
+					     _uffd_faults)			\
+{										\
+	.name			= SCAT2(ro_memslot_no_syndrome, _access),	\
+	.data_memslot_flags	= KVM_MEM_READONLY,				\
+	.mem_mark_cmd		= CMD_HOLE_DATA | CMD_HOLE_PT,			\
+	.guest_test		= _access,					\
+	.uffd_data_handler	= _uffd_data_handler,				\
+	.uffd_pt_handler	= uffd_pt_write_handler,			\
+	.fail_vcpu_run_handler	= fail_vcpu_run_mmio_no_syndrome_handler,	\
+	.expected_events	= { .fail_vcpu_runs = 1,			\
+				    .uffd_faults = _uffd_faults },		\
+}
+
 static struct test_desc tests[] = {
 
 	/* Check that HW is setting the Access Flag (AF) (sanity checks). */
@@ -914,6 +989,35 @@ static struct test_desc tests[] = {
 	TEST_DIRTY_LOG(guest_dc_zva, with_af, guest_check_write_in_dirty_log),
 	TEST_DIRTY_LOG(guest_st_preidx, with_af, guest_check_write_in_dirty_log),
 
+	/*
+	 * Access when the data and PT memslots are both marked for dirty
+	 * logging and UFFD at the same time. The expected result is that
+	 * writes should mark the dirty log and trigger a userfaultfd write
+	 * fault.  Reads/execs should result in a read userfaultfd fault, and
+	 * nothing in the dirty log.  Any S1PTW should result in a write in the
+	 * dirty log and a userfaultfd write.
+	 */
+	TEST_UFFD_AND_DIRTY_LOG(guest_read64, with_af, uffd_data_read_handler, 2,
+			guest_check_no_write_in_dirty_log),
+	/* no_af should also lead to a PT write. */
+	TEST_UFFD_AND_DIRTY_LOG(guest_read64, no_af, uffd_data_read_handler, 2,
+			guest_check_no_write_in_dirty_log),
+	TEST_UFFD_AND_DIRTY_LOG(guest_ld_preidx, with_af, uffd_data_read_handler,
+			2, guest_check_no_write_in_dirty_log),
+	TEST_UFFD_AND_DIRTY_LOG(guest_at, with_af, 0, 1,
+			guest_check_no_write_in_dirty_log),
+	TEST_UFFD_AND_DIRTY_LOG(guest_exec, with_af, uffd_data_read_handler, 2,
+			guest_check_no_write_in_dirty_log),
+	TEST_UFFD_AND_DIRTY_LOG(guest_write64, with_af, uffd_data_write_handler,
+			2, guest_check_write_in_dirty_log),
+	TEST_UFFD_AND_DIRTY_LOG(guest_cas, with_af, uffd_data_read_handler, 2,
+			guest_check_write_in_dirty_log),
+	TEST_UFFD_AND_DIRTY_LOG(guest_dc_zva, with_af, uffd_data_write_handler,
+			2, guest_check_write_in_dirty_log),
+	TEST_UFFD_AND_DIRTY_LOG(guest_st_preidx, with_af,
+			uffd_data_write_handler, 2,
+			guest_check_write_in_dirty_log),
+
 	/*
 	 * Try accesses when the data memslot is marked read-only (with
 	 * KVM_MEM_READONLY). Writes with a syndrome result in an MMIO exit,
@@ -929,6 +1033,57 @@ static struct test_desc tests[] = {
 	TEST_RO_MEMSLOT_NO_SYNDROME(guest_cas),
 	TEST_RO_MEMSLOT_NO_SYNDROME(guest_st_preidx),
 
+	/*
+	 * Access when both the data memslot is both read-only and marked for
+	 * dirty logging at the same time. The expected result is that for
+	 * writes there should be no write in the dirty log. The readonly
+	 * handling is the same as if the memslot was not marked for dirty
+	 * logging: writes with a syndrome result in an MMIO exit, and writes
+	 * with no syndrome result in a failed vcpu run.
+	 */
+	TEST_RO_MEMSLOT_AND_DIRTY_LOG(guest_read64, 0, 0,
+			guest_check_no_write_in_dirty_log),
+	TEST_RO_MEMSLOT_AND_DIRTY_LOG(guest_ld_preidx, 0, 0,
+			guest_check_no_write_in_dirty_log),
+	TEST_RO_MEMSLOT_AND_DIRTY_LOG(guest_at, 0, 0,
+			guest_check_no_write_in_dirty_log),
+	TEST_RO_MEMSLOT_AND_DIRTY_LOG(guest_exec, 0, 0,
+			guest_check_no_write_in_dirty_log),
+	TEST_RO_MEMSLOT_AND_DIRTY_LOG(guest_write64, mmio_on_test_gpa_handler,
+			1, guest_check_no_write_in_dirty_log),
+	TEST_RO_MEMSLOT_NO_SYNDROME_AND_DIRTY_LOG(guest_dc_zva,
+			guest_check_no_write_in_dirty_log),
+	TEST_RO_MEMSLOT_NO_SYNDROME_AND_DIRTY_LOG(guest_cas,
+			guest_check_no_write_in_dirty_log),
+	TEST_RO_MEMSLOT_NO_SYNDROME_AND_DIRTY_LOG(guest_st_preidx,
+			guest_check_no_write_in_dirty_log),
+
+	/*
+	 * Access when the data memslot is both read-only and punched with
+	 * holes tracked with userfaultfd.  The expected result is the union of
+	 * both userfaultfd and read-only behaviors. For example, write
+	 * accesses result in a userfaultfd write fault and an MMIO exit.
+	 * Writes with no syndrome result in a failed vcpu run and no
+	 * userfaultfd write fault. Reads result in userfaultfd getting
+	 * triggered.
+	 */
+	TEST_RO_MEMSLOT_AND_UFFD(guest_read64, 0, 0,
+			uffd_data_read_handler, 2),
+	TEST_RO_MEMSLOT_AND_UFFD(guest_ld_preidx, 0, 0,
+			uffd_data_read_handler, 2),
+	TEST_RO_MEMSLOT_AND_UFFD(guest_at, 0, 0,
+			uffd_no_handler, 1),
+	TEST_RO_MEMSLOT_AND_UFFD(guest_exec, 0, 0,
+			uffd_data_read_handler, 2),
+	TEST_RO_MEMSLOT_AND_UFFD(guest_write64, mmio_on_test_gpa_handler, 1,
+			uffd_data_write_handler, 2),
+	TEST_RO_MEMSLOT_NO_SYNDROME_AND_UFFD(guest_cas,
+			uffd_data_read_handler, 2),
+	TEST_RO_MEMSLOT_NO_SYNDROME_AND_UFFD(guest_dc_zva,
+			uffd_no_handler, 1),
+	TEST_RO_MEMSLOT_NO_SYNDROME_AND_UFFD(guest_st_preidx,
+			uffd_no_handler, 1),
+
 	{ 0 }
 };
 
-- 
2.37.2.789.g6183377224-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
