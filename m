Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7F99C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 20 Oct 2022 07:13:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7248C4B8AF;
	Thu, 20 Oct 2022 03:13:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NZV36E0x7X9c; Thu, 20 Oct 2022 03:13:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 23E694B93E;
	Thu, 20 Oct 2022 03:13:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB8664B884
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 03:13:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vLJQnW8XqYrs for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Oct 2022 03:13:19 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CB964B91E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 03:13:19 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1666249999;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=J1UM8Q4XCnJXEEhn+ghVOV9BUOCnBbI8Wc42C/4GuEI=;
 b=NjXUi+lOCH9okHNW1jhamfUQj8lyiUbRjz8pjVzO31N8Ltimzab7YBbAJyADv9E8JYxngW
 Y0B+GRkrG/+HsaTnvHjVpx/iiuv0Nnev4Cl1uc7xNXQ1D37L+cOznrUP3ADLnas5dWM6Zo
 oFfgtUcbpmPnTjcXys8CTghCckjAgOk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-519-RAFMVK5ONQWj7_8GG4AbPA-1; Thu, 20 Oct 2022 03:13:14 -0400
X-MC-Unique: RAFMVK5ONQWj7_8GG4AbPA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B48585A5B6;
 Thu, 20 Oct 2022 07:13:14 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-70.bne.redhat.com [10.64.54.70])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A428E40C6EC2;
 Thu, 20 Oct 2022 07:13:08 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Subject: [PATCH v3 5/6] KVM: selftests: memslot_perf_test: Consolidate memory
Date: Thu, 20 Oct 2022 15:12:08 +0800
Message-Id: <20221020071209.559062-6-gshan@redhat.com>
In-Reply-To: <20221020071209.559062-1-gshan@redhat.com>
References: <20221020071209.559062-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Cc: mail@maciej.szmigiero.name, kvm@vger.kernel.org, maz@kernel.org,
 linux-kernel@vger.kernel.org, zhenyzha@redhat.com, shan.gavin@gmail.com,
 pbonzini@redhat.com, shuah@kernel.org, kvmarm@lists.cs.columbia.edu,
 ajones@ventanamicro.com
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

The addresses and sizes passed to vm_userspace_mem_region_add() and
madvise() should be aligned to host page size, which can be 64KB on
aarch64. So it's wrong by passing additional fixed 4KB memory area
to various tests.

Fix it by passing additional fixed 64KB memory area to various tests.
We also add checks to ensure that none of host/guest page size exceeds
64KB. MEM_TEST_MOVE_SIZE is fixed up to 192KB either.

With this, the following command works fine on 64KB-page-size-host and
4KB-page-size-guest.

  # ./memslot_perf_test -v -s 512

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 .../testing/selftests/kvm/memslot_perf_test.c | 43 +++++++++++--------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index 9af61ca8ad0a..daebc264de5a 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -20,17 +20,20 @@
 #include <unistd.h>
 
 #include <linux/compiler.h>
+#include <linux/sizes.h>
 
 #include <test_util.h>
 #include <kvm_util.h>
 #include <processor.h>
 
-#define MEM_SIZE		((512U << 20) + 4096)
-#define MEM_GPA		0x10000000UL
+#define MEM_EXTRA_SIZE		SZ_64K
+
+#define MEM_SIZE		(SZ_512M + MEM_EXTRA_SIZE)
+#define MEM_GPA			SZ_256M
 #define MEM_AUX_GPA		MEM_GPA
 #define MEM_SYNC_GPA		MEM_AUX_GPA
-#define MEM_TEST_GPA		(MEM_AUX_GPA + 4096)
-#define MEM_TEST_SIZE		(MEM_SIZE - 4096)
+#define MEM_TEST_GPA		(MEM_AUX_GPA + MEM_EXTRA_SIZE)
+#define MEM_TEST_SIZE		(MEM_SIZE - MEM_EXTRA_SIZE)
 
 /*
  * 32 MiB is max size that gets well over 100 iterations on 509 slots.
@@ -38,8 +41,8 @@
  * 8194 slots in use can then be tested (although with slightly
  * limited resolution).
  */
-#define MEM_SIZE_MAP		((32U << 20) + 4096)
-#define MEM_TEST_MAP_SIZE	(MEM_SIZE_MAP - 4096)
+#define MEM_SIZE_MAP		(SZ_32M + MEM_EXTRA_SIZE)
+#define MEM_TEST_MAP_SIZE	(MEM_SIZE_MAP - MEM_EXTRA_SIZE)
 
 /*
  * 128 MiB is min size that fills 32k slots with at least one page in each
@@ -47,8 +50,8 @@
  *
  * 2 MiB chunk size like a typical huge page
  */
-#define MEM_TEST_UNMAP_SIZE		(128U << 20)
-#define MEM_TEST_UNMAP_CHUNK_SIZE	(2U << 20)
+#define MEM_TEST_UNMAP_SIZE		SZ_128M
+#define MEM_TEST_UNMAP_CHUNK_SIZE	SZ_2M
 
 /*
  * For the move active test the middle of the test area is placed on
@@ -64,12 +67,12 @@
  *
  * architecture   slots    memory-per-slot    memory-on-last-slot
  * --------------------------------------------------------------
- * x86-4KB        32763    16KB               100KB
- * arm64-4KB      32766    16KB               52KB
- * arm64-16KB     32766    16KB               48KB
- * arm64-64KB     8192     64KB               64KB
+ * x86-4KB        32763    16KB               160KB
+ * arm64-4KB      32766    16KB               112KB
+ * arm64-16KB     32766    16KB               112KB
+ * arm64-64KB     8192     64KB               128KB
  */
-#define MEM_TEST_MOVE_SIZE		0x10000
+#define MEM_TEST_MOVE_SIZE		(3 * SZ_64K)
 #define MEM_TEST_MOVE_GPA_DEST		(MEM_GPA + MEM_SIZE)
 static_assert(MEM_TEST_MOVE_SIZE <= MEM_TEST_SIZE,
 	      "invalid move test region size");
@@ -533,7 +536,6 @@ static bool test_memslot_move_prepare(struct vm_data *data,
 				      uint64_t *maxslots, bool isactive)
 {
 	uint32_t guest_page_size = data->vm->page_size;
-	uint64_t move_pages = MEM_TEST_MOVE_SIZE / guest_page_size;
 	uint64_t movesrcgpa, movetestgpa;
 
 	movesrcgpa = vm_slot2gpa(data, data->nslots - 1);
@@ -542,7 +544,7 @@ static bool test_memslot_move_prepare(struct vm_data *data,
 		uint64_t lastpages;
 
 		vm_gpa2hva(data, movesrcgpa, &lastpages);
-		if (lastpages < move_pages / 2) {
+		if (lastpages * guest_page_size < MEM_TEST_MOVE_SIZE / 2) {
 			*maxslots = 0;
 			return false;
 		}
@@ -808,13 +810,13 @@ static const struct test_data tests[] = {
 	},
 	{
 		.name = "unmap",
-		.mem_size = MEM_TEST_UNMAP_SIZE + 4096,
+		.mem_size = MEM_TEST_UNMAP_SIZE + MEM_EXTRA_SIZE,
 		.guest_code = guest_code_test_memslot_unmap,
 		.loop = test_memslot_unmap_loop,
 	},
 	{
 		.name = "unmap chunked",
-		.mem_size = MEM_TEST_UNMAP_SIZE + 4096,
+		.mem_size = MEM_TEST_UNMAP_SIZE + MEM_EXTRA_SIZE,
 		.guest_code = guest_code_test_memslot_unmap,
 		.loop = test_memslot_unmap_loop_chunked,
 	},
@@ -874,8 +876,15 @@ static void help(char *name, struct test_args *targs)
 
 static bool check_memory_sizes(void)
 {
+	uint32_t host_page_size = getpagesize();
 	uint32_t guest_page_size = vm_guest_mode_params[VM_MODE_DEFAULT].page_size;
 
+	if (host_page_size > SZ_64K || guest_page_size > SZ_64K) {
+		pr_info("Unsupported page size on host (0x%x) or guest (0x%x)\n",
+			host_page_size, guest_page_size);
+		return false;
+	}
+
 	if (MEM_SIZE % guest_page_size ||
 	    MEM_TEST_SIZE % guest_page_size) {
 		pr_info("invalid MEM_SIZE or MEM_TEST_SIZE\n");
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
