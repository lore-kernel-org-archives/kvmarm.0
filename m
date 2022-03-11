Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DBA3C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 06:02:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F37E240FB2;
	Fri, 11 Mar 2022 01:02:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PCWMfMDIBAAR; Fri, 11 Mar 2022 01:02:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C4E3749EBD;
	Fri, 11 Mar 2022 01:02:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D548408AA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 01:02:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v7k4oc2pSgQv for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Mar 2022 01:02:31 -0500 (EST)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9250940B59
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 01:02:29 -0500 (EST)
Received: by mail-pg1-f202.google.com with SMTP id
 f21-20020a633815000000b0038105768c61so1033979pga.21
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 22:02:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=n0unht5qzdqOFcOLqfZJouXFJeZ+JY2CKOuyKBmheCA=;
 b=LfwlZvTsfX375jUVosmH2FSFaIoyaBWCknnU1gJXvE28xTOYuOr1q34o/zA3Wsg9jT
 1JVwKQ9XrP+iijvAAd70Cgzq8cD0IViWF29HrRDlnUofoEh+LvPKJPTHMhzPy9NDLsjG
 7lyOr1VvFITJI3s4CZr6sXM/jKuJV+mDBLTCUv6n2fvBwx2KDZ2pzT2cjzui2bPFke9n
 mx0fCUxeqG/f8dQmK90wSLvRQSPolTkdzSTP6RXfFXX8N+BykM0G00XaeJ6jw2nWzG94
 nrd04TyJUg0miVpBO/KsSCs5BTrjFQG9ZkCLLH/giJEabKAnATpwD64gxUwfgV3VFeZL
 wymA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=n0unht5qzdqOFcOLqfZJouXFJeZ+JY2CKOuyKBmheCA=;
 b=E2E6YoDm4pi9hPJ+L9DRPZh+ArjN+uaYE+BkdTGyWR+S9wdL3I7I7NbLCQSMfdWI2b
 v3F8alNIc4GbYHCmk62HjgKTt3fiSRSFH5BuPHAr62QugMwaHFD/96FR8lXGnGmv+hUU
 vI+/2zUWQYMJ9mxWMYWnW8n4SkYjBB2tFLmyVFyl/Tri1n6838AroQGW9TOxEO9c53J5
 FhoY0V643tTn7E+ulYhpP1iwQTWsZnlXjIdi17gSKnaMeJlF0bgvpk+9oheTNTN8vR0Z
 aSiz3YBRaiFjS33v03y1OUCRdb0XU5VcoJ51tJr5VIQnyK7Q7ABAjUlysqO4KkUztl9L
 Orqg==
X-Gm-Message-State: AOAM531ip5jw+yNU+sxWnfCf+xJ3EhEADUJiQJi6QboLKo++DmuYly57
 SXdeBNr6pcDeqV3NM9hl2oyZIKrQuMMJBg==
X-Google-Smtp-Source: ABdhPJw3bzyRx2Qc+ZAwSoMid/szXDn7Vzz6hZONQ9ewFnuLbhdgmtOSNT7JklW7GOKEz7JP8odEs7mpTOXbOg==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:f78d:b0:14f:ce61:eaf2 with SMTP
 id q13-20020a170902f78d00b0014fce61eaf2mr8934670pln.124.1646978548847; Thu,
 10 Mar 2022 22:02:28 -0800 (PST)
Date: Thu, 10 Mar 2022 22:02:07 -0800
In-Reply-To: <20220311060207.2438667-1-ricarkol@google.com>
Message-Id: <20220311060207.2438667-12-ricarkol@google.com>
Mime-Version: 1.0
References: <20220311060207.2438667-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 11/11] KVM: selftests: aarch64: Add mix of tests into
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

Add some mix of tests into page_fault_test, like stage 2 faults on
memslots marked for both userfaultfd and dirty-logging.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/aarch64/page_fault_test.c   | 148 ++++++++++++++++++
 1 file changed, 148 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index e6607f903bc1..f1a5bf081a5b 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -399,6 +399,12 @@ static int uffd_test_read_handler(int mode, int uffd, struct uffd_msg *msg)
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
@@ -912,6 +918,30 @@ int main(int argc, char *argv[])
 #define TEST_S1PTW_ON_HOLE_UFFD_AF(__a, __uffd_handler)				\
 	TEST_S1PTW_ON_HOLE_UFFD(__a, __uffd_handler, __AF_TEST_ARGS)
 
+#define __DIRTY_LOG_TEST							\
+	.test_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
+	.guest_test_check	= { guest_check_write_in_dirty_log, },		\
+
+#define __DIRTY_LOG_S1PTW_TEST							\
+	.pt_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
+	.guest_test_check	= { guest_check_s1ptw_wr_in_dirty_log, },	\
+
+#define TEST_WRITE_DIRTY_LOG_AND_S1PTW_ON_UFFD(__a, __uffd_handler, ...)	\
+	TEST_S1PTW_ON_HOLE_UFFD(__a, __uffd_handler,				\
+			__DIRTY_LOG_TEST __VA_ARGS__)
+
+#define TEST_WRITE_ON_DIRTY_LOG_AND_UFFD(__a, __uffd_handler, ...)		\
+	TEST_ACCESS_ON_HOLE_UFFD(__a, __uffd_handler,				\
+			__DIRTY_LOG_TEST __VA_ARGS__)
+
+#define TEST_WRITE_UFFD_AND_S1PTW_ON_DIRTY_LOG(__a, __uffd_handler, ...)	\
+	TEST_ACCESS_ON_HOLE_UFFD(__a, __uffd_handler,				\
+			__DIRTY_LOG_S1PTW_TEST __VA_ARGS__)
+
+#define TEST_S1PTW_ON_DIRTY_LOG_AND_UFFD(__a, __uffd_handler, ...)		\
+	TEST_S1PTW_ON_HOLE_UFFD(__a, __uffd_handler,				\
+			__DIRTY_LOG_S1PTW_TEST __VA_ARGS__)
+
 #define TEST_ACCESS_AND_S1PTW_ON_HOLE_UFFD(__a, __th, __ph, ...)		\
 {										\
 	.name			= SNAME(ACCESS_S1PTW_ON_HOLE_UFFD ## _ ## __a),	\
@@ -1015,6 +1045,10 @@ int main(int argc, char *argv[])
 	.guest_prepare		= { guest_set_ha, guest_check_lse, },		\
 	.guest_test_check	= { guest_check_pte_af, }
 
+#define __NULL_UFFD_HANDLERS							\
+	.uffd_test_handler	= uffd_no_handler,				\
+	.uffd_pt_handler	= uffd_no_handler
+
 #define	TEST_WRITE_ON_RO_MEMSLOT_AF(__a)					\
 	TEST_WRITE_ON_RO_MEMSLOT(__a, __AF_TEST_IN_RO_MEMSLOT_ARGS)
 
@@ -1105,6 +1139,37 @@ int main(int argc, char *argv[])
 #define TEST_EXEC_AND_S1PTW_AF_ON_RO_MEMSLOT(__a) 				\
 	TEST_EXEC_AND_S1PTW_ON_RO_MEMSLOT(__a, __AF_TEST_IN_RO_MEMSLOT_ARGS)
 
+#define TEST_WRITE_AND_S1PTW_AF_ON_RO_MEMSLOT_WITH_UFFD(__a)			\
+	TEST_WRITE_AND_S1PTW_ON_RO_MEMSLOT(__a, __NULL_UFFD_HANDLERS)
+#define TEST_READ_AND_S1PTW_ON_RO_MEMSLOT_WITH_UFFD(__a)			\
+	TEST_READ_AND_S1PTW_ON_RO_MEMSLOT(__a, __NULL_UFFD_HANDLERS)
+#define TEST_CM_AND_S1PTW_AF_ON_RO_MEMSLOT_WITH_UFFD(__a)			\
+	TEST_CM_AND_S1PTW_ON_RO_MEMSLOT(__a, __NULL_UFFD_HANDLERS)
+#define TEST_EXEC_AND_S1PTW_AF_ON_RO_MEMSLOT_WITH_UFFD(__a)			\
+	TEST_EXEC_AND_S1PTW_ON_RO_MEMSLOT(__a, __NULL_UFFD_HANDLERS)
+
+#define	TEST_WRITE_ON_RO_DIRTY_LOG_MEMSLOT(__a, ...)				\
+{										\
+	.name			= SNAME(WRITE_ON_RO_MEMSLOT ## _ ## __a),	\
+	.test_memslot_flags	= KVM_MEM_READONLY | KVM_MEM_LOG_DIRTY_PAGES,	\
+	.guest_test		= __a,						\
+	.guest_test_check	= { guest_check_no_write_in_dirty_log, },	\
+	.mmio_handler		= mmio_on_test_gpa_handler,			\
+	.expected_events	= { .mmio_exits = 1, },				\
+	__VA_ARGS__								\
+}
+
+#define	TEST_CM_ON_RO_DIRTY_LOG_MEMSLOT(__a, ...)				\
+{										\
+	.name			= SNAME(WRITE_ON_RO_MEMSLOT ## _ ## __a),	\
+	.test_memslot_flags	= KVM_MEM_READONLY | KVM_MEM_LOG_DIRTY_PAGES,	\
+	.guest_test		= __a,						\
+	.guest_test_check	= { guest_check_no_write_in_dirty_log, },	\
+	.fail_vcpu_run_handler	= fail_vcpu_run_mmio_no_syndrome_handler,	\
+	.expected_events	= { .fail_vcpu_runs = 1, },			\
+	__VA_ARGS__								\
+}
+
 static struct test_desc tests[] = {
 	/* Check that HW is setting the AF (sanity checks). */
 	TEST_HW_ACCESS_FLAG(guest_test_read64),
@@ -1223,6 +1288,65 @@ static struct test_desc tests[] = {
 	TEST_ACCESS_AND_S1PTW_ON_HOLE_UFFD_AF(guest_test_exec,
 			uffd_test_read_handler, uffd_pt_write_handler),
 
+	/* Write into a memslot marked for both dirty logging and UFFD. */
+	TEST_WRITE_ON_DIRTY_LOG_AND_UFFD(guest_test_write64,
+			uffd_test_write_handler),
+	/* Note that the cas uffd handler is for a read. */
+	TEST_WRITE_ON_DIRTY_LOG_AND_UFFD(guest_test_cas,
+			uffd_test_read_handler, __PREPARE_LSE_TEST_ARGS),
+	TEST_WRITE_ON_DIRTY_LOG_AND_UFFD(guest_test_dc_zva,
+			uffd_test_write_handler),
+	TEST_WRITE_ON_DIRTY_LOG_AND_UFFD(guest_test_st_preidx,
+			uffd_test_write_handler),
+
+	/*
+	 * Access whose s1ptw faults on a hole that's marked for both dirty
+	 * logging and UFFD.
+	 */
+	TEST_S1PTW_ON_DIRTY_LOG_AND_UFFD(guest_test_read64,
+			uffd_pt_write_handler),
+	TEST_S1PTW_ON_DIRTY_LOG_AND_UFFD(guest_test_cas,
+			uffd_pt_write_handler, __PREPARE_LSE_TEST_ARGS),
+	TEST_S1PTW_ON_DIRTY_LOG_AND_UFFD(guest_test_ld_preidx,
+			uffd_pt_write_handler),
+	TEST_S1PTW_ON_DIRTY_LOG_AND_UFFD(guest_test_exec,
+			uffd_pt_write_handler),
+	TEST_S1PTW_ON_DIRTY_LOG_AND_UFFD(guest_test_write64,
+			uffd_pt_write_handler),
+	TEST_S1PTW_ON_DIRTY_LOG_AND_UFFD(guest_test_st_preidx,
+			uffd_pt_write_handler),
+	TEST_S1PTW_ON_DIRTY_LOG_AND_UFFD(guest_test_dc_zva,
+			uffd_pt_write_handler),
+	TEST_S1PTW_ON_DIRTY_LOG_AND_UFFD(guest_test_at,
+			uffd_pt_write_handler),
+
+	/*
+	 * Write on a memslot marked for dirty logging whose related s1ptw
+	 * is on a hole marked with UFFD.
+	 */
+	TEST_WRITE_DIRTY_LOG_AND_S1PTW_ON_UFFD(guest_test_write64,
+			uffd_pt_write_handler),
+	TEST_WRITE_DIRTY_LOG_AND_S1PTW_ON_UFFD(guest_test_cas,
+			uffd_pt_write_handler, __PREPARE_LSE_TEST_ARGS),
+	TEST_WRITE_DIRTY_LOG_AND_S1PTW_ON_UFFD(guest_test_dc_zva,
+			uffd_pt_write_handler),
+	TEST_WRITE_DIRTY_LOG_AND_S1PTW_ON_UFFD(guest_test_st_preidx,
+			uffd_pt_write_handler),
+
+	/*
+	 * Write on a memslot that's on a hole marked with UFFD, whose related
+	 * sp1ptw is on a memslot marked for dirty logging.
+	 */
+	TEST_WRITE_UFFD_AND_S1PTW_ON_DIRTY_LOG(guest_test_write64,
+			uffd_test_write_handler),
+	/* Note that the uffd handler is for a read. */
+	TEST_WRITE_UFFD_AND_S1PTW_ON_DIRTY_LOG(guest_test_cas,
+			uffd_test_read_handler, __PREPARE_LSE_TEST_ARGS),
+	TEST_WRITE_UFFD_AND_S1PTW_ON_DIRTY_LOG(guest_test_dc_zva,
+			uffd_test_write_handler),
+	TEST_WRITE_UFFD_AND_S1PTW_ON_DIRTY_LOG(guest_test_st_preidx,
+			uffd_test_write_handler),
+
 	/* Access on readonly memslot (sanity check). */
 	TEST_WRITE_ON_RO_MEMSLOT(guest_test_write64),
 	TEST_READ_ON_RO_MEMSLOT(guest_test_read64),
@@ -1290,6 +1414,30 @@ static struct test_desc tests[] = {
 	TEST_CM_AND_S1PTW_AF_ON_RO_MEMSLOT(guest_test_st_preidx),
 	TEST_EXEC_AND_S1PTW_AF_ON_RO_MEMSLOT(guest_test_exec),
 
+	/*
+	 * Access on a memslot marked as readonly with also dirty log tracking.
+	 * There should be no write in the dirty log.
+	 */
+	TEST_WRITE_ON_RO_DIRTY_LOG_MEMSLOT(guest_test_write64),
+	TEST_CM_ON_RO_DIRTY_LOG_MEMSLOT(guest_test_cas,
+			__PREPARE_LSE_TEST_ARGS),
+	TEST_CM_ON_RO_DIRTY_LOG_MEMSLOT(guest_test_dc_zva),
+	TEST_CM_ON_RO_DIRTY_LOG_MEMSLOT(guest_test_st_preidx),
+
+	/*
+	 * Access on a RO memslot with S1PTW also on a RO memslot, while also
+	 * having those memslot regions marked for UFFD fault handling.  The
+	 * result is that UFFD fault handlers should not be called.
+	 */
+	TEST_WRITE_AND_S1PTW_AF_ON_RO_MEMSLOT_WITH_UFFD(guest_test_write64),
+	TEST_READ_AND_S1PTW_ON_RO_MEMSLOT_WITH_UFFD(guest_test_read64),
+	TEST_READ_AND_S1PTW_ON_RO_MEMSLOT_WITH_UFFD(guest_test_ld_preidx),
+	TEST_CM_AND_S1PTW_ON_RO_MEMSLOT(guest_test_cas,
+			__PREPARE_LSE_TEST_ARGS __NULL_UFFD_HANDLERS),
+	TEST_CM_AND_S1PTW_AF_ON_RO_MEMSLOT_WITH_UFFD(guest_test_dc_zva),
+	TEST_CM_AND_S1PTW_AF_ON_RO_MEMSLOT_WITH_UFFD(guest_test_st_preidx),
+	TEST_EXEC_AND_S1PTW_AF_ON_RO_MEMSLOT_WITH_UFFD(guest_test_exec),
+
 	{ 0 },
 };
 
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
