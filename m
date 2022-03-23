Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFD7FC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 22:54:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B51749F56;
	Wed, 23 Mar 2022 18:54:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AhVzMjGIu3qt; Wed, 23 Mar 2022 18:54:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BFC64B0B8;
	Wed, 23 Mar 2022 18:54:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CCA049ED8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 18:54:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 31wM25yXJClO for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Mar 2022 18:54:25 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D60EE4A417
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 18:54:24 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 v10-20020a17090a0c8a00b001c7a548e4f7so1064545pja.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 15:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=/89MKP2BWFTMFr1I+WAjn8R2Z4dFf8EnGbuPEHCIdJY=;
 b=RlWBXu652oujXBG5JqJ5G3bNtA2p9IlCyCUEKqY0PmdCc9cpESgJudt/esnTc3rt5t
 YVSnRShAOh8HhIUlu19MnM0byFf3Qdvfr3AI+948y2Bblb++tG3WzNaSjYa+eZx5FIuJ
 zYC2pOWEL4lkKQj7rdiC22x//YfIzx0qhFR9SaOb7kRdwg64orvtF4HbYXvGfxBdyOhH
 3v04jKyL80xNiutznrRvOMZxmuBB9aKbaP4qEZEtAtAA4NeUH6rYm+VIU34u8b+om6VV
 mlH9FLckEicZD6qXQ/TaHfgUEq9UT7F+gosIFmCBB4hoI7OTCCwPnIIoCONLnZKHvW3V
 yEWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=/89MKP2BWFTMFr1I+WAjn8R2Z4dFf8EnGbuPEHCIdJY=;
 b=SySLsoD0FuvsvxRA18XpsdPZtiakUM0kxwtgCYzs0a/7AUcURLN3GbLh7FY7aFdCPS
 htpL5qCX/KGBxK9OUYi9FphvK6ex8JExrZvz+R9DPudxIJlM3ZyJMOnL4dE0lOXEsGEY
 wlswAH4WmA8DwdGKVqWDLvkkUnZA92T4FxqnJSnZG08V6rILdxwvjDUrQaWzqxYTJj6m
 ZOaV1oQ7CWvoWdQQdKUUd97Mc5aNvc1g6EaYOQiFCSYqxasb9ASxxx1CFrWBRH4iqbGN
 cyUV8590z1iPwG4FqGtvaCkDQGneHb6rrVw4lZkAbtsDbWI41qmnhN/fPJd/B+kZUnU1
 A00g==
X-Gm-Message-State: AOAM532vagLkIMFt3KmkjkGZlz8pZZyOmnrqYYbW9dLu4oRJhlXR2CNg
 4f8rCG5MDMXIWnUJVBDgIvm4KhgSCGjvEQ==
X-Google-Smtp-Source: ABdhPJwGEFfuWKuS9ydMbKpWNJYNLHlEsPreQ1KcrhowuX6bcFrqwZAMS2SL4KO9siNgqNbXq9CfVHDFr1oIxg==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:114b:b0:4f7:915:3ec3 with SMTP
 id b11-20020a056a00114b00b004f709153ec3mr2233613pfm.8.1648076064060; Wed, 23
 Mar 2022 15:54:24 -0700 (PDT)
Date: Wed, 23 Mar 2022 15:54:03 -0700
In-Reply-To: <20220323225405.267155-1-ricarkol@google.com>
Message-Id: <20220323225405.267155-10-ricarkol@google.com>
Mime-Version: 1.0
References: <20220323225405.267155-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 09/11] KVM: selftests: aarch64: Add dirty logging tests
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
 .../selftests/kvm/aarch64/page_fault_test.c   | 123 ++++++++++++++++++
 1 file changed, 123 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 99449eaddb2b..b41da9317242 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -45,6 +45,11 @@
 #define CMD_SKIP_TEST				(-1LL)
 #define CMD_HOLE_PT				(1ULL << 2)
 #define CMD_HOLE_TEST				(1ULL << 3)
+#define CMD_RECREATE_PT_MEMSLOT_WR		(1ULL << 4)
+#define CMD_CHECK_WRITE_IN_DIRTY_LOG		(1ULL << 5)
+#define CMD_CHECK_S1PTW_WR_IN_DIRTY_LOG		(1ULL << 6)
+#define CMD_CHECK_NO_WRITE_IN_DIRTY_LOG		(1ULL << 7)
+#define CMD_SET_PTE_AF				(1ULL << 8)
 
 #define PREPARE_FN_NR				10
 #define CHECK_FN_NR				10
@@ -251,6 +256,21 @@ static void guest_check_pte_af(void)
 	GUEST_ASSERT_EQ(*((uint64_t *)pte_gva) & PTE_AF, PTE_AF);
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
 static void guest_test_exec(void)
 {
 	int (*code)(void) = (int (*)(void))test_exec_gva;
@@ -380,12 +400,34 @@ static void punch_hole_in_memslot(struct kvm_vm *vm,
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
 static void handle_cmd(struct kvm_vm *vm, int cmd)
 {
 	if (cmd & CMD_HOLE_PT)
 		punch_hole_in_memslot(vm, &memslot[PT]);
 	if (cmd & CMD_HOLE_TEST)
 		punch_hole_in_memslot(vm, &memslot[TEST]);
+	if (cmd & CMD_CHECK_WRITE_IN_DIRTY_LOG)
+		TEST_ASSERT(check_write_in_dirty_log(vm, &memslot[TEST], 0),
+				"Missing write in dirty log");
+	if (cmd & CMD_CHECK_NO_WRITE_IN_DIRTY_LOG)
+		TEST_ASSERT(!check_write_in_dirty_log(vm, &memslot[TEST], 0),
+				"Unexpected s1ptw write in dirty log");
+	if (cmd & CMD_CHECK_S1PTW_WR_IN_DIRTY_LOG)
+		TEST_ASSERT(check_write_in_dirty_log(vm, &memslot[PT], 0),
+				"Missing s1ptw write in dirty log");
 }
 
 static void sync_stats_from_guest(struct kvm_vm *vm)
@@ -783,6 +825,56 @@ int main(int argc, char *argv[])
 #define TEST_ACCESS_AND_S1PTW_ON_HOLE_UFFD_AF(__a, __th, __ph)			\
 	TEST_ACCESS_AND_S1PTW_ON_HOLE_UFFD(__a, __th, __ph, __AF_TEST_ARGS)
 
+#define	__TEST_ACCESS_DIRTY_LOG(__a, ...)					\
+{										\
+	.name			= SNAME(TEST_ACCESS_DIRTY_LOG ## _ ## __a),	\
+	.test_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
+	.guest_test 		= __a,						\
+	.expected_events	= { 0 },					\
+	__VA_ARGS__								\
+}
+
+#define __CHECK_WRITE_IN_DIRTY_LOG						\
+	.guest_test_check	= { guest_check_write_in_dirty_log, },
+
+#define __CHECK_NO_WRITE_IN_DIRTY_LOG						\
+	.guest_test_check	= { guest_check_no_write_in_dirty_log, },
+
+#define	TEST_WRITE_DIRTY_LOG(__a, ...)						\
+	__TEST_ACCESS_DIRTY_LOG(__a, __CHECK_WRITE_IN_DIRTY_LOG __VA_ARGS__)
+
+#define	TEST_NO_WRITE_DIRTY_LOG(__a, ...)					\
+	__TEST_ACCESS_DIRTY_LOG(__a, __CHECK_NO_WRITE_IN_DIRTY_LOG __VA_ARGS__)
+
+#define	__TEST_S1PTW_DIRTY_LOG(__a, ...)					\
+{										\
+	.name			= SNAME(S1PTW_AF_DIRTY_LOG ## _ ## __a),	\
+	.pt_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
+	.guest_test 		= __a,						\
+	.expected_events	= { 0 },					\
+	__VA_ARGS__								\
+}
+
+#define __CHECK_S1PTW_WR_IN_DIRTY_LOG						\
+	.guest_test_check	= { guest_check_s1ptw_wr_in_dirty_log, },
+
+#define	TEST_S1PTW_DIRTY_LOG(__a, ...)						\
+	__TEST_S1PTW_DIRTY_LOG(__a, __CHECK_S1PTW_WR_IN_DIRTY_LOG __VA_ARGS__)
+
+#define __AF_TEST_ARGS_FOR_DIRTY_LOG						\
+	.guest_prepare		= { guest_set_ha, guest_clear_pte_af, },	\
+	.guest_test_check       = { guest_check_s1ptw_wr_in_dirty_log, 		\
+				    guest_check_pte_af, },
+
+#define __AF_AND_LSE_ARGS_FOR_DIRTY_LOG						\
+	.guest_prepare		= { guest_set_ha, guest_clear_pte_af,		\
+				    guest_check_lse, },				\
+	.guest_test_check       = { guest_check_s1ptw_wr_in_dirty_log, 		\
+				    guest_check_pte_af, },
+
+#define	TEST_S1PTW_AF_DIRTY_LOG(__a, ...)					\
+	TEST_S1PTW_DIRTY_LOG(__a, __AF_TEST_ARGS_FOR_DIRTY_LOG)
+
 static struct test_desc tests[] = {
 	/* Check that HW is setting the AF (sanity checks). */
 	TEST_HW_ACCESS_FLAG(guest_test_read64),
@@ -793,6 +885,37 @@ static struct test_desc tests[] = {
 	TEST_HW_ACCESS_FLAG(guest_test_dc_zva),
 	TEST_HW_ACCESS_FLAG(guest_test_exec),
 
+	/* Dirty log basic checks. */
+	TEST_WRITE_DIRTY_LOG(guest_test_write64),
+	TEST_WRITE_DIRTY_LOG(guest_test_cas, __PREPARE_LSE_TEST_ARGS),
+	TEST_WRITE_DIRTY_LOG(guest_test_dc_zva),
+	TEST_WRITE_DIRTY_LOG(guest_test_st_preidx),
+	TEST_NO_WRITE_DIRTY_LOG(guest_test_read64),
+	TEST_NO_WRITE_DIRTY_LOG(guest_test_ld_preidx),
+	TEST_NO_WRITE_DIRTY_LOG(guest_test_at),
+	TEST_NO_WRITE_DIRTY_LOG(guest_test_exec),
+
+	/*
+	 * S1PTW on a PT (no AF) which is marked for dirty logging. Note that
+	 * this still shows up in the dirty log as a write.
+	 */
+	TEST_S1PTW_DIRTY_LOG(guest_test_write64),
+	TEST_S1PTW_DIRTY_LOG(guest_test_st_preidx),
+	TEST_S1PTW_DIRTY_LOG(guest_test_read64),
+	TEST_S1PTW_DIRTY_LOG(guest_test_cas, __PREPARE_LSE_TEST_ARGS),
+	TEST_S1PTW_DIRTY_LOG(guest_test_ld_preidx),
+	TEST_S1PTW_DIRTY_LOG(guest_test_at),
+	TEST_S1PTW_DIRTY_LOG(guest_test_dc_zva),
+	TEST_S1PTW_DIRTY_LOG(guest_test_exec),
+	TEST_S1PTW_AF_DIRTY_LOG(guest_test_write64),
+	TEST_S1PTW_AF_DIRTY_LOG(guest_test_st_preidx),
+	TEST_S1PTW_AF_DIRTY_LOG(guest_test_read64),
+	TEST_S1PTW_DIRTY_LOG(guest_test_cas, __AF_AND_LSE_ARGS_FOR_DIRTY_LOG),
+	TEST_S1PTW_AF_DIRTY_LOG(guest_test_ld_preidx),
+	TEST_S1PTW_AF_DIRTY_LOG(guest_test_at),
+	TEST_S1PTW_AF_DIRTY_LOG(guest_test_dc_zva),
+	TEST_S1PTW_AF_DIRTY_LOG(guest_test_exec),
+
 	/* Accessing a hole shouldn't fault (more sanity checks). */
 	TEST_ACCESS_ON_HOLE_NO_FAULTS(guest_test_read64),
 	TEST_ACCESS_ON_HOLE_NO_FAULTS(guest_test_cas, __PREPARE_LSE_TEST_ARGS),
-- 
2.35.1.894.gb6a874cedc-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
