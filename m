Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE8A4699
	for <kvmarm@lists.linux.dev>; Mon, 17 Oct 2022 19:58:57 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id w11-20020a170902e88b00b001855276704aso2228868plg.4
        for <kvmarm@lists.linux.dev>; Mon, 17 Oct 2022 12:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XBDWxwhGTtBIvO3uG7VQCGhtW5Kgp6bQMeyMfJhYG9w=;
        b=dVc2PJLvdjMt7UrxqsYH8pYEo0ol6ovPvdnyRpTPQwujEnqxK/xg+K5SO1zJdBE7Zj
         3gMg5MvozH3O7rRFSLxWmoN+b1zCu6vTM6xbCtJgOoS6Olf+R2WsAMGzj8scQgsneEVM
         GFOQggc72Pu+SowYmfPqbM9pC05p+QHs13YYorVhynwf5LFQsr3PhpDL5NuhaKxuMWUw
         0GWkmd3r0yyOu+fS+0hbjRNnTObgpSrTuJQFbxbci0q1WXOzPiDaynhD4kacZV0VGBbP
         EHwbylirMmZ/Cs4deIy1eu0/pwxHqdxai1GGVFJqIQbD14GaPpoP+qgVD6ucfcarYf2V
         UT+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XBDWxwhGTtBIvO3uG7VQCGhtW5Kgp6bQMeyMfJhYG9w=;
        b=qrr3VCOU00ctT2ojp6JQwBhxIlBfoGo22fBNnldraZSdWgmdcvI4Rnrik8JMA/+oTi
         KJo9U3WtBGzeV2aKzkXosZwkqgB7lG1f8WK1hAiK997DcDGYiQC/i5Hh4pKxZeZXW7DK
         FrHNnKaQ5lD8NFcvuQdVZbpR2OrT9KGCUtWpE7v681CfxNbKT6ZNQTwl+pIn6lC1ShOB
         B1WXIGYHhyUGHglFmO457kUIeRbGLB5rVulHEljhSjzhMNbBDholZmuyJD4mlXV+gf7H
         MbC5R8iqBxjq9OK9Wpa+nB0ZPb7HJJTHYAHKsB1Pq84DTqTmJi6FmKZh229i65ALJ7Lv
         xZyg==
X-Gm-Message-State: ACrzQf3HUzy14R+HPW8ViGdrl8Zolvw0vz2DULzDRNsyUhANBJVVb585
	v/xFSJmPA6tzXyTuufVHWbiNnxXOsSxYvQ==
X-Google-Smtp-Source: AMsMyM7aiArYgvRUrD+wkSx4bzLNpl24zYj+Ro2hWgzZVmQJixARrwpIsgydjij1J61/bDrpPx1M0qScinAwxw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a63:6b44:0:b0:46a:fa55:b6a0 with SMTP id
 g65-20020a636b44000000b0046afa55b6a0mr12134633pgc.614.1666036736838; Mon, 17
 Oct 2022 12:58:56 -0700 (PDT)
Date: Mon, 17 Oct 2022 19:58:32 +0000
In-Reply-To: <20221017195834.2295901-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221017195834.2295901-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221017195834.2295901-13-ricarkol@google.com>
Subject: [PATCH v10 12/14] KVM: selftests: aarch64: Add dirty logging tests
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
Message-ID: <20221017195832.KLjhrdmt-klRU-Sq_2_hb62Wdtrrm2s2670Zh5gz_K4@z>

Add some dirty logging tests into page_fault_test. Mark the data and/or
page-table memory regions for dirty logging, perform some accesses, and
check that the dirty log bits are set or clean when expected.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/aarch64/page_fault_test.c   | 76 +++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 8ecc2ac8c476..a36001143aff 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -31,6 +31,11 @@ static uint64_t *guest_test_memory = (uint64_t *)TEST_GVA;
 #define CMD_SKIP_TEST				(1ULL << 1)
 #define CMD_HOLE_PT				(1ULL << 2)
 #define CMD_HOLE_DATA				(1ULL << 3)
+#define CMD_CHECK_WRITE_IN_DIRTY_LOG		(1ULL << 4)
+#define CMD_CHECK_S1PTW_WR_IN_DIRTY_LOG		(1ULL << 5)
+#define CMD_CHECK_NO_WRITE_IN_DIRTY_LOG		(1ULL << 6)
+#define CMD_CHECK_NO_S1PTW_WR_IN_DIRTY_LOG	(1ULL << 7)
+#define CMD_SET_PTE_AF				(1ULL << 8)
 
 #define PREPARE_FN_NR				10
 #define CHECK_FN_NR				10
@@ -213,6 +218,21 @@ static void guest_check_pte_af(void)
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
@@ -395,6 +415,22 @@ static bool punch_hole_in_backing_store(struct kvm_vm *vm,
 	return true;
 }
 
+static bool check_write_in_dirty_log(struct kvm_vm *vm,
+				     struct userspace_mem_region *region,
+				     uint64_t host_pg_nr)
+{
+	unsigned long *bmap;
+	bool first_page_dirty;
+	uint64_t size = region->region.memory_size;
+
+	/* getpage_size() is not always equal to vm->page_size */
+	bmap = bitmap_zalloc(size / getpagesize());
+	kvm_vm_get_dirty_log(vm, region->region.slot, bmap);
+	first_page_dirty = test_bit(host_pg_nr, bmap);
+	free(bmap);
+	return first_page_dirty;
+}
+
 /* Returns true to continue the test, and false if it should be skipped. */
 static bool handle_cmd(struct kvm_vm *vm, int cmd)
 {
@@ -411,6 +447,18 @@ static bool handle_cmd(struct kvm_vm *vm, int cmd)
 		continue_test = punch_hole_in_backing_store(vm, pt_region);
 	if (cmd & CMD_HOLE_DATA)
 		continue_test = punch_hole_in_backing_store(vm, data_region);
+	if (cmd & CMD_CHECK_WRITE_IN_DIRTY_LOG)
+		TEST_ASSERT(check_write_in_dirty_log(vm, data_region, 0),
+			    "Missing write in dirty log");
+	if (cmd & CMD_CHECK_S1PTW_WR_IN_DIRTY_LOG)
+		TEST_ASSERT(check_write_in_dirty_log(vm, pt_region, 0),
+			    "Missing s1ptw write in dirty log");
+	if (cmd & CMD_CHECK_NO_WRITE_IN_DIRTY_LOG)
+		TEST_ASSERT(!check_write_in_dirty_log(vm, data_region, 0),
+			    "Unexpected write in dirty log");
+	if (cmd & CMD_CHECK_NO_S1PTW_WR_IN_DIRTY_LOG)
+		TEST_ASSERT(!check_write_in_dirty_log(vm, pt_region, 0),
+			    "Unexpected s1ptw write in dirty log");
 
 	return continue_test;
 }
@@ -673,6 +721,19 @@ static void help(char *name)
 	.expected_events	= { .uffd_faults = _uffd_faults, },		\
 }
 
+#define TEST_DIRTY_LOG(_access, _with_af, _test_check)				\
+{										\
+	.name			= SCAT3(dirty_log, _access, _with_af),		\
+	.data_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
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
@@ -732,6 +793,21 @@ static struct test_desc tests[] = {
 	TEST_UFFD(guest_exec, with_af, CMD_HOLE_DATA | CMD_HOLE_PT,
 		  uffd_data_read_handler, uffd_pt_write_handler, 2),
 
+	/*
+	 * Try accesses when the data and PT memory regions are both
+	 * tracked for dirty logging.
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
 	{ 0 }
 };
 
-- 
2.38.0.413.g74048e4d9e-goog

