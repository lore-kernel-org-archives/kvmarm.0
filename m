Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85287C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 00:41:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 39D784B1C5;
	Thu,  7 Apr 2022 20:41:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LqHSog0PoTb3; Thu,  7 Apr 2022 20:41:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 209204B12C;
	Thu,  7 Apr 2022 20:41:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B6BEC49ECC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 20:41:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fNrNDszaT+Pf for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Apr 2022 20:41:41 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 734514A49C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 20:41:41 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 t4-20020a628104000000b005056f132662so1256177pfd.21
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Apr 2022 17:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=aoevi1/32QaVDCl+0szzfKHcofBdzbe9olbkExGouDU=;
 b=Q3W9yM2TaUg82+PVHhJ8mGGjamC+M7ubH5r5aVeen2pcp/xncjpRLX2bxSAbh9u0wU
 2Mjoo9kni1Ftlar5xEf8tT50lHbRkf9ITovBMge+y+LDBUh83qjcXIgPTyk1h+Y7oVL2
 MlYJl0OgTPZWfmtD5UDrY2A2/UoiYOnwS08NHJ3lcr0dlRYIR5HZI5Mc+Gb8oF89HKF4
 vzZLgAJ345U7wtQqHIcumU6JIntk952u6HHQIQbU57ZaBxo5/FPA7rjyle3ICFdRbcN4
 cxT/FwFLPehjYXC3tVmLfQe7xPcBL+4JP3IUzG3JBMxTYGdUYokEGfl+OqgpqPinssEH
 zVQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=aoevi1/32QaVDCl+0szzfKHcofBdzbe9olbkExGouDU=;
 b=ATLRf3mPKc8P8HmLEcdpChBHlYdA6B+kuNc7CBWE2e7/aFzp2bICykzX/D1zn30s0G
 usTj1fXdL/fT6PobmBFwpd9qdvzDCt09eT5CZNB3aXOmyNy2+dooSHFR2J90vGbJ7QOH
 wKZ80PUb8tldUZtL6UuzacTlOYtfo25mgIS6nI/VjsxIWnKfT5adSLQVuKWaUyNHYGEF
 wWukOS1gAOq9iFm49pVVMBRQXpv5M3PR1wcmqk04zHW/XvE71p1Hpd5Z/UXojiCGpMHS
 57dzFy73Q+ZjEWiza7kJXCPrQXqzqCHbsvKL3SoQ6AYjbbfsJa4uEqvnZ47dkUdMCf7c
 aHUQ==
X-Gm-Message-State: AOAM531FqWkUm5E0kAdxzcR94UDHyKO64XHFOIdA0joYVl6lQCPoamuW
 ZF/cj1kgriOP0n0R8ULs+OW/CsVqPuwWkQ==
X-Google-Smtp-Source: ABdhPJwiQGNa+4qbobcoTIwwKQaBhvMBS+dfIPSyzmuIf4+XOeYr9E/iSLYO1Q0ddo5TGg+q+oAsMD5PGSBGuA==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:bcca:b0:153:88c7:a02 with SMTP id
 o10-20020a170902bcca00b0015388c70a02mr16810370pls.112.1649378500718; Thu, 07
 Apr 2022 17:41:40 -0700 (PDT)
Date: Thu,  7 Apr 2022 17:41:18 -0700
In-Reply-To: <20220408004120.1969099-1-ricarkol@google.com>
Message-Id: <20220408004120.1969099-12-ricarkol@google.com>
Mime-Version: 1.0
References: <20220408004120.1969099-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v3 11/13] KVM: selftests: aarch64: Add dirty logging tests
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

Add some dirty logging tests into page_fault_test. Mark the data and/or
page-table memslots for dirty logging, perform some accesses, and check
that the dirty log bits are set or clean when expected.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/aarch64/page_fault_test.c   | 74 +++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index bee525625956..342170e207b0 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -43,6 +43,12 @@
 #define CMD_SKIP_TEST				(1ULL << 1)
 #define CMD_HOLE_PT				(1ULL << 2)
 #define CMD_HOLE_TEST				(1ULL << 3)
+#define CMD_RECREATE_PT_MEMSLOT_WR		(1ULL << 4)
+#define CMD_CHECK_WRITE_IN_DIRTY_LOG		(1ULL << 5)
+#define CMD_CHECK_S1PTW_WR_IN_DIRTY_LOG		(1ULL << 6)
+#define CMD_CHECK_NO_WRITE_IN_DIRTY_LOG		(1ULL << 7)
+#define CMD_CHECK_NO_S1PTW_WR_IN_DIRTY_LOG	(1ULL << 8)
+#define CMD_SET_PTE_AF				(1ULL << 9)
 
 #define PREPARE_FN_NR				10
 #define CHECK_FN_NR				10
@@ -269,6 +275,21 @@ static void guest_check_pte_af(void)
 	GUEST_ASSERT_EQ(*((uint64_t *)TEST_PTE_GVA) & PTE_AF, PTE_AF);
 }
 
+static void guest_check_write_in_dirty_log(void)
+{
+	GUEST_SYNC(CMD_CHECK_WRITE_IN_DIRTY_LOG);
+}
+
+static void guest_check_no_write_in_dirty_log(void)
+{
+	GUEST_SYNC(CMD_CHECK_NO_WRITE_IN_DIRTY_LOG);
+}
+
+static void guest_check_s1ptw_wr_in_dirty_log(void)
+{
+	GUEST_SYNC(CMD_CHECK_S1PTW_WR_IN_DIRTY_LOG);
+}
+
 static void guest_exec(void)
 {
 	int (*code)(void) = (int (*)(void))TEST_EXEC_GVA;
@@ -399,6 +420,19 @@ static void punch_hole_in_memslot(struct kvm_vm *vm,
 	}
 }
 
+static bool check_write_in_dirty_log(struct kvm_vm *vm,
+		struct memslot_desc *ms, uint64_t host_pg_nr)
+{
+	unsigned long *bmap;
+	bool first_page_dirty;
+
+	bmap = bitmap_zalloc(ms->size / getpagesize());
+	kvm_vm_get_dirty_log(vm, ms->idx, bmap);
+	first_page_dirty = test_bit(host_pg_nr, bmap);
+	free(bmap);
+	return first_page_dirty;
+}
+
 /* Returns false when the test was skipped. */
 static bool handle_cmd(struct kvm_vm *vm, int cmd)
 {
@@ -409,6 +443,18 @@ static bool handle_cmd(struct kvm_vm *vm, int cmd)
 		punch_hole_in_memslot(vm, &memslot[PT]);
 	if (cmd & CMD_HOLE_TEST)
 		punch_hole_in_memslot(vm, &memslot[TEST]);
+	if (cmd & CMD_CHECK_WRITE_IN_DIRTY_LOG)
+		TEST_ASSERT(check_write_in_dirty_log(vm, &memslot[TEST], 0),
+				"Missing write in dirty log");
+	if (cmd & CMD_CHECK_S1PTW_WR_IN_DIRTY_LOG)
+		TEST_ASSERT(check_write_in_dirty_log(vm, &memslot[PT], 0),
+				"Missing s1ptw write in dirty log");
+	if (cmd & CMD_CHECK_NO_WRITE_IN_DIRTY_LOG)
+		TEST_ASSERT(!check_write_in_dirty_log(vm, &memslot[TEST], 0),
+				"Unexpected write in dirty log");
+	if (cmd & CMD_CHECK_NO_S1PTW_WR_IN_DIRTY_LOG)
+		TEST_ASSERT(!check_write_in_dirty_log(vm, &memslot[PT], 0),
+				"Unexpected s1ptw write in dirty log");
 
 	return true;
 }
@@ -783,6 +829,19 @@ int main(int argc, char *argv[])
 	.expected_events	= { .uffd_faults = _uffd_faults, },		\
 }
 
+#define TEST_DIRTY_LOG(_access, _with_af, _test_check)				\
+{										\
+	.name			= SCAT3(dirty_log, _access, _with_af),		\
+	.test_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
+	.pt_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
+	.guest_prepare		= { _PREPARE(_with_af),				\
+				    _PREPARE(_access) },			\
+	.guest_test		= _access,					\
+	.guest_test_check	= { _CHECK(_with_af), _test_check,		\
+				    guest_check_s1ptw_wr_in_dirty_log},		\
+	.expected_events	= { 0 },					\
+}
+
 static struct test_desc tests[] = {
 	/* Check that HW is setting the Access Flag (AF) (sanity checks). */
 	TEST_ACCESS(guest_read64, with_af, CMD_NONE),
@@ -835,6 +894,21 @@ static struct test_desc tests[] = {
 	TEST_UFFD(guest_exec, with_af, CMD_HOLE_TEST | CMD_HOLE_PT,
 			uffd_test_read_handler, uffd_pt_write_handler, 2),
 
+	/*
+	 * Try accesses when the test and PT memslots are both tracked for
+	 * dirty logging.
+	 */
+	TEST_DIRTY_LOG(guest_read64, with_af, guest_check_no_write_in_dirty_log),
+	/* no_af should also lead to a PT write. */
+	TEST_DIRTY_LOG(guest_read64, no_af, guest_check_no_write_in_dirty_log),
+	TEST_DIRTY_LOG(guest_ld_preidx, with_af, guest_check_no_write_in_dirty_log),
+	TEST_DIRTY_LOG(guest_at, no_af, guest_check_no_write_in_dirty_log),
+	TEST_DIRTY_LOG(guest_exec, with_af, guest_check_no_write_in_dirty_log),
+	TEST_DIRTY_LOG(guest_write64, with_af, guest_check_write_in_dirty_log),
+	TEST_DIRTY_LOG(guest_cas, with_af, guest_check_write_in_dirty_log),
+	TEST_DIRTY_LOG(guest_dc_zva, with_af, guest_check_write_in_dirty_log),
+	TEST_DIRTY_LOG(guest_st_preidx, with_af, guest_check_write_in_dirty_log),
+
 	{ 0 },
 };
 
-- 
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
