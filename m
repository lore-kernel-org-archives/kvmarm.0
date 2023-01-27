Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCE15221
	for <kvmarm@lists.linux.dev>; Fri, 27 Jan 2023 21:43:58 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id u186-20020a2560c3000000b007c8e2cf3668so6690065ybb.14
        for <kvmarm@lists.linux.dev>; Fri, 27 Jan 2023 13:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GAm747K7yMJq/Oj/OQ23lxK4f4XZ8ZGYC14Tp45ZG6Q=;
        b=GM1aVigxP8nj2xwwTIADkar9SAgV0VX8GL7RFAle6KcbWjBDVWzFRDHrQPwAvF6gbB
         7fPvGMhSfVLoQtJsls2HDRZR694Dvw7sq9fmpcMy/+lWrU/YGfiqwxgdfA9tm/NlB/Iz
         i0vQldTJmbc/vlcvhqAn4uptwSCtfUdGx99S/eWfq1WKYUuAdJf/FV8Hr6ZyR+Ny3KE8
         +3015KVwl63I9+SvI0UXenCkIjBtflEZTXiU9Ohqvn+DRb6pIDW9BGQN1L547TnaPsZI
         KPBtW4suPLR9E05IovS5t3D9WpP9pUSs48fgtkydqbNsE7yO656h+d1pGYjllpqWb4u+
         j9LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GAm747K7yMJq/Oj/OQ23lxK4f4XZ8ZGYC14Tp45ZG6Q=;
        b=NfdWB31J/jUJlSQN7R/ScFuWeC9gipj9gxQf9JsEcoF8YizWLZn/Ph4XhZyj8H2jtM
         G/IOKNuZqsZWwg3c+mSFZQEuzdYp9v9OrlT66d7k+uKzpCCtVO820OuryvLVJTdERkXK
         SiLLcQ2JDXVV3IWkYe+zWFrmVhug8rP8aQzbPWwz+dS2uQgD91JICoGdjoGkqN7w57WV
         HjNIWuyxc1erQKw9x9Kt8Oj45PoI3F2BxvujEUGdWV/b+GT3kjpIB3VmCcE4Uz9FnTJB
         UEax21NhGVCJEWShHMUeD22b2tswK6R9wofSZDBOOYy47AEeaBUQrFDp9V43v7GJzm3X
         JZpQ==
X-Gm-Message-State: AFqh2kos/rRacOOh0V6rrpSB66vWV2zPXd4V74ERbaJi0JQaXyuE5ux9
	02lgFMJAX8mOOddUlXIH3KhkKamaBsCR3w==
X-Google-Smtp-Source: AMrXdXvGSgpaFoKdd0ARSvL+0wzxIxR0ty/no0rwpK6wpBMx/taETu3Iykkba3kJDDf/hRACsXyoNg0jV4agCg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a0d:d84d:0:b0:4fe:5760:9885 with SMTP id
 a74-20020a0dd84d000000b004fe57609885mr3829210ywe.475.1674855837340; Fri, 27
 Jan 2023 13:43:57 -0800 (PST)
Date: Fri, 27 Jan 2023 21:43:50 +0000
In-Reply-To: <20230127214353.245671-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230127214353.245671-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230127214353.245671-2-ricarkol@google.com>
Subject: [PATCH v2 1/4] KVM: selftests: aarch64: Relax userfaultfd read vs.
 write checks
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com, 
	eric.auger@redhat.com, oupton@google.com, yuzenghui@huawei.com, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"

Only Stage1 Page table walks (S1PTW) writing a PTE on an unmapped page
should result in a userfaultfd write. However, the userfaultfd tests in
page_fault_test wrongly assert that any S1PTW is a PTE write.

Fix this by relaxing the read vs. write checks in all userfaultfd
handlers.  Note that this is also an attempt to focus less on KVM (and
userfaultfd) behavior, and more on architectural behavior. Also note
that after commit 406504c7b040 ("KVM: arm64: Fix S1PTW handling on RO
memslots"), the userfaultfd fault (S1PTW with AF on an unmaped PTE
page) is actually a read: the translation fault that comes before the
permission fault.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/aarch64/page_fault_test.c   | 83 ++++++++-----------
 1 file changed, 34 insertions(+), 49 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index beb944fa6fd4..0dda58766185 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -304,7 +304,7 @@ static struct uffd_args {
 
 /* Returns true to continue the test, and false if it should be skipped. */
 static int uffd_generic_handler(int uffd_mode, int uffd, struct uffd_msg *msg,
-				struct uffd_args *args, bool expect_write)
+				struct uffd_args *args)
 {
 	uint64_t addr = msg->arg.pagefault.address;
 	uint64_t flags = msg->arg.pagefault.flags;
@@ -313,7 +313,6 @@ static int uffd_generic_handler(int uffd_mode, int uffd, struct uffd_msg *msg,
 
 	TEST_ASSERT(uffd_mode == UFFDIO_REGISTER_MODE_MISSING,
 		    "The only expected UFFD mode is MISSING");
-	ASSERT_EQ(!!(flags & UFFD_PAGEFAULT_FLAG_WRITE), expect_write);
 	ASSERT_EQ(addr, (uint64_t)args->hva);
 
 	pr_debug("uffd fault: addr=%p write=%d\n",
@@ -337,19 +336,14 @@ static int uffd_generic_handler(int uffd_mode, int uffd, struct uffd_msg *msg,
 	return 0;
 }
 
-static int uffd_pt_write_handler(int mode, int uffd, struct uffd_msg *msg)
+static int uffd_pt_handler(int mode, int uffd, struct uffd_msg *msg)
 {
-	return uffd_generic_handler(mode, uffd, msg, &pt_args, true);
+	return uffd_generic_handler(mode, uffd, msg, &pt_args);
 }
 
-static int uffd_data_write_handler(int mode, int uffd, struct uffd_msg *msg)
+static int uffd_data_handler(int mode, int uffd, struct uffd_msg *msg)
 {
-	return uffd_generic_handler(mode, uffd, msg, &data_args, true);
-}
-
-static int uffd_data_read_handler(int mode, int uffd, struct uffd_msg *msg)
-{
-	return uffd_generic_handler(mode, uffd, msg, &data_args, false);
+	return uffd_generic_handler(mode, uffd, msg, &data_args);
 }
 
 static void setup_uffd_args(struct userspace_mem_region *region,
@@ -822,7 +816,7 @@ static void help(char *name)
 	.mem_mark_cmd		= CMD_HOLE_DATA | CMD_HOLE_PT,			\
 	.guest_test_check	= { _CHECK(_with_af), _test_check },		\
 	.uffd_data_handler	= _uffd_data_handler,				\
-	.uffd_pt_handler	= uffd_pt_write_handler,			\
+	.uffd_pt_handler	= uffd_pt_handler,				\
 	.expected_events	= { .uffd_faults = _uffd_faults, },		\
 }
 
@@ -878,7 +872,7 @@ static void help(char *name)
 	.guest_prepare		= { _PREPARE(_access) },			\
 	.guest_test		= _access,					\
 	.uffd_data_handler	= _uffd_data_handler,				\
-	.uffd_pt_handler	= uffd_pt_write_handler,			\
+	.uffd_pt_handler	= uffd_pt_handler,				\
 	.mmio_handler		= _mmio_handler,				\
 	.expected_events	= { .mmio_exits = _mmio_exits,			\
 				    .uffd_faults = _uffd_faults },		\
@@ -892,7 +886,7 @@ static void help(char *name)
 	.mem_mark_cmd		= CMD_HOLE_DATA | CMD_HOLE_PT,			\
 	.guest_test		= _access,					\
 	.uffd_data_handler	= _uffd_data_handler,				\
-	.uffd_pt_handler	= uffd_pt_write_handler,			\
+	.uffd_pt_handler	= uffd_pt_handler,			\
 	.fail_vcpu_run_handler	= fail_vcpu_run_mmio_no_syndrome_handler,	\
 	.expected_events	= { .fail_vcpu_runs = 1,			\
 				    .uffd_faults = _uffd_faults },		\
@@ -933,29 +927,27 @@ static struct test_desc tests[] = {
 	 * (S1PTW).
 	 */
 	TEST_UFFD(guest_read64, with_af, CMD_HOLE_DATA | CMD_HOLE_PT,
-		  uffd_data_read_handler, uffd_pt_write_handler, 2),
-	/* no_af should also lead to a PT write. */
+		  uffd_data_handler, uffd_pt_handler, 2),
 	TEST_UFFD(guest_read64, no_af, CMD_HOLE_DATA | CMD_HOLE_PT,
-		  uffd_data_read_handler, uffd_pt_write_handler, 2),
-	/* Note how that cas invokes the read handler. */
+		  uffd_data_handler, uffd_pt_handler, 2),
 	TEST_UFFD(guest_cas, with_af, CMD_HOLE_DATA | CMD_HOLE_PT,
-		  uffd_data_read_handler, uffd_pt_write_handler, 2),
+		  uffd_data_handler, uffd_pt_handler, 2),
 	/*
 	 * Can't test guest_at with_af as it's IMPDEF whether the AF is set.
 	 * The S1PTW fault should still be marked as a write.
 	 */
 	TEST_UFFD(guest_at, no_af, CMD_HOLE_DATA | CMD_HOLE_PT,
-		  uffd_data_read_handler, uffd_pt_write_handler, 1),
+		  uffd_no_handler, uffd_pt_handler, 1),
 	TEST_UFFD(guest_ld_preidx, with_af, CMD_HOLE_DATA | CMD_HOLE_PT,
-		  uffd_data_read_handler, uffd_pt_write_handler, 2),
+		  uffd_data_handler, uffd_pt_handler, 2),
 	TEST_UFFD(guest_write64, with_af, CMD_HOLE_DATA | CMD_HOLE_PT,
-		  uffd_data_write_handler, uffd_pt_write_handler, 2),
+		  uffd_data_handler, uffd_pt_handler, 2),
 	TEST_UFFD(guest_dc_zva, with_af, CMD_HOLE_DATA | CMD_HOLE_PT,
-		  uffd_data_write_handler, uffd_pt_write_handler, 2),
+		  uffd_data_handler, uffd_pt_handler, 2),
 	TEST_UFFD(guest_st_preidx, with_af, CMD_HOLE_DATA | CMD_HOLE_PT,
-		  uffd_data_write_handler, uffd_pt_write_handler, 2),
+		  uffd_data_handler, uffd_pt_handler, 2),
 	TEST_UFFD(guest_exec, with_af, CMD_HOLE_DATA | CMD_HOLE_PT,
-		  uffd_data_read_handler, uffd_pt_write_handler, 2),
+		  uffd_data_handler, uffd_pt_handler, 2),
 
 	/*
 	 * Try accesses when the data and PT memory regions are both
@@ -980,25 +972,25 @@ static struct test_desc tests[] = {
 	 * fault, and nothing in the dirty log.  Any S1PTW should result in
 	 * a write in the dirty log and a userfaultfd write.
 	 */
-	TEST_UFFD_AND_DIRTY_LOG(guest_read64, with_af, uffd_data_read_handler, 2,
+	TEST_UFFD_AND_DIRTY_LOG(guest_read64, with_af, uffd_data_handler, 2,
 				guest_check_no_write_in_dirty_log),
 	/* no_af should also lead to a PT write. */
-	TEST_UFFD_AND_DIRTY_LOG(guest_read64, no_af, uffd_data_read_handler, 2,
+	TEST_UFFD_AND_DIRTY_LOG(guest_read64, no_af, uffd_data_handler, 2,
 				guest_check_no_write_in_dirty_log),
-	TEST_UFFD_AND_DIRTY_LOG(guest_ld_preidx, with_af, uffd_data_read_handler,
+	TEST_UFFD_AND_DIRTY_LOG(guest_ld_preidx, with_af, uffd_data_handler,
 				2, guest_check_no_write_in_dirty_log),
-	TEST_UFFD_AND_DIRTY_LOG(guest_at, with_af, 0, 1,
+	TEST_UFFD_AND_DIRTY_LOG(guest_at, with_af, uffd_no_handler, 1,
 				guest_check_no_write_in_dirty_log),
-	TEST_UFFD_AND_DIRTY_LOG(guest_exec, with_af, uffd_data_read_handler, 2,
+	TEST_UFFD_AND_DIRTY_LOG(guest_exec, with_af, uffd_data_handler, 2,
 				guest_check_no_write_in_dirty_log),
-	TEST_UFFD_AND_DIRTY_LOG(guest_write64, with_af, uffd_data_write_handler,
+	TEST_UFFD_AND_DIRTY_LOG(guest_write64, with_af, uffd_data_handler,
 				2, guest_check_write_in_dirty_log),
-	TEST_UFFD_AND_DIRTY_LOG(guest_cas, with_af, uffd_data_read_handler, 2,
+	TEST_UFFD_AND_DIRTY_LOG(guest_cas, with_af, uffd_data_handler, 2,
 				guest_check_write_in_dirty_log),
-	TEST_UFFD_AND_DIRTY_LOG(guest_dc_zva, with_af, uffd_data_write_handler,
+	TEST_UFFD_AND_DIRTY_LOG(guest_dc_zva, with_af, uffd_data_handler,
 				2, guest_check_write_in_dirty_log),
 	TEST_UFFD_AND_DIRTY_LOG(guest_st_preidx, with_af,
-				uffd_data_write_handler, 2,
+				uffd_data_handler, 2,
 				guest_check_write_in_dirty_log),
 
 	/*
@@ -1051,22 +1043,15 @@ static struct test_desc tests[] = {
 	 * no userfaultfd write fault. Reads result in userfaultfd getting
 	 * triggered.
 	 */
-	TEST_RO_MEMSLOT_AND_UFFD(guest_read64, 0, 0,
-				 uffd_data_read_handler, 2),
-	TEST_RO_MEMSLOT_AND_UFFD(guest_ld_preidx, 0, 0,
-				 uffd_data_read_handler, 2),
-	TEST_RO_MEMSLOT_AND_UFFD(guest_at, 0, 0,
-				 uffd_no_handler, 1),
-	TEST_RO_MEMSLOT_AND_UFFD(guest_exec, 0, 0,
-				 uffd_data_read_handler, 2),
+	TEST_RO_MEMSLOT_AND_UFFD(guest_read64, 0, 0, uffd_data_handler, 2),
+	TEST_RO_MEMSLOT_AND_UFFD(guest_ld_preidx, 0, 0, uffd_data_handler, 2),
+	TEST_RO_MEMSLOT_AND_UFFD(guest_at, 0, 0, uffd_no_handler, 1),
+	TEST_RO_MEMSLOT_AND_UFFD(guest_exec, 0, 0, uffd_data_handler, 2),
 	TEST_RO_MEMSLOT_AND_UFFD(guest_write64, mmio_on_test_gpa_handler, 1,
-				 uffd_data_write_handler, 2),
-	TEST_RO_MEMSLOT_NO_SYNDROME_AND_UFFD(guest_cas,
-					     uffd_data_read_handler, 2),
-	TEST_RO_MEMSLOT_NO_SYNDROME_AND_UFFD(guest_dc_zva,
-					     uffd_no_handler, 1),
-	TEST_RO_MEMSLOT_NO_SYNDROME_AND_UFFD(guest_st_preidx,
-					     uffd_no_handler, 1),
+				 uffd_data_handler, 2),
+	TEST_RO_MEMSLOT_NO_SYNDROME_AND_UFFD(guest_cas, uffd_data_handler, 2),
+	TEST_RO_MEMSLOT_NO_SYNDROME_AND_UFFD(guest_dc_zva, uffd_no_handler, 1),
+	TEST_RO_MEMSLOT_NO_SYNDROME_AND_UFFD(guest_st_preidx, uffd_no_handler, 1),
 
 	{ 0 }
 };
-- 
2.39.1.456.gfc5497dd1b-goog

