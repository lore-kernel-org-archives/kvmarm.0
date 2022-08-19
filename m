Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D89CC3F6B0
	for <kvmarm@archiver.kernel.org>; Fri, 19 Aug 2022 00:57:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3D8A4CC14;
	Thu, 18 Aug 2022 20:57:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id c+L5ZwCs76AO; Thu, 18 Aug 2022 20:57:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 683D84CBF4;
	Thu, 18 Aug 2022 20:57:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA30B4C399
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Aug 2022 20:57:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y58mnfRumhZn for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Aug 2022 20:57:12 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6995D4CBF4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Aug 2022 20:57:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1660870632;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=W+KM/oNj0I/wS0RXKgmyise3ZxF2pvHFwuH0MTKYePA=;
 b=doFtK5Nw4IpUvqVrG2qKdZYAYqsRyS6Jeizip9fOd3LwIwATDH8CMqWvZshj0cpAY90ojc
 DAnZIAtKW+cPSIfw/7KrL5mtVLFPTweh60Jj5cghx7fdmfN45u1OlpZz6NPaqiaPUV3tU8
 3saYH2LJKo0vNTXyGdvI/wI/F/TxfIE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-252-0IVyFOiYPsyaJ_WaOfR3kA-1; Thu, 18 Aug 2022 20:57:08 -0400
X-MC-Unique: 0IVyFOiYPsyaJ_WaOfR3kA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC7DA381078F;
 Fri, 19 Aug 2022 00:57:07 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-16.bne.redhat.com [10.64.54.16])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 708AEC15BB8;
 Fri, 19 Aug 2022 00:56:59 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 3/5] KVM: selftests: Dirty host pages in dirty_log_test
Date: Fri, 19 Aug 2022 08:55:59 +0800
Message-Id: <20220819005601.198436-4-gshan@redhat.com>
In-Reply-To: <20220819005601.198436-1-gshan@redhat.com>
References: <20220819005601.198436-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, catalin.marinas@arm.com,
 linux-kselftest@vger.kernel.org, bgardon@google.com, shuah@kernel.org,
 corbet@lwn.net, maz@kernel.org, shan.gavin@gmail.com, drjones@redhat.com,
 will@kernel.org, zhenyzha@redhat.com, dmatlack@google.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 pbonzini@redhat.com
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

It's assumed that 1024 host pages, instead of guest pages, are dirtied
in each iteration in guest_code(). The current implementation misses
the case of mismatched page sizes in host and guest. For example,
ARM64 could have 64KB page size in guest, but 4KB page size in host.
(TEST_PAGES_PER_LOOP / 16), instead of TEST_PAGES_PER_LOOP, host pages
are dirtied in every iteration.

Fix the issue by touching all sub-pages when we have mismatched
page sizes in host and guest.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 50 +++++++++++++++-----
 1 file changed, 39 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 9c883c94d478..50b02186ce12 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -70,6 +70,7 @@
  * that may change.
  */
 static uint64_t host_page_size;
+static uint64_t host_num_pages;
 static uint64_t guest_page_size;
 static uint64_t guest_num_pages;
 static uint64_t random_array[TEST_PAGES_PER_LOOP];
@@ -94,8 +95,23 @@ static uint64_t guest_test_virt_mem = DEFAULT_GUEST_TEST_MEM;
  */
 static void guest_code(void)
 {
+	uint64_t num_pages, page_size, sub_page_size;
 	uint64_t addr;
-	int i;
+	int pages_per_loop, i, j;
+
+	/*
+	 * The page sizes on host and VM could be different. We need
+	 * to perform writing on all sub-pages.
+	 */
+	if (host_page_size >= guest_page_size) {
+		num_pages = host_num_pages;
+		page_size = host_page_size;
+		sub_page_size = host_page_size;
+	} else {
+		num_pages = guest_num_pages;
+		page_size = guest_page_size;
+		sub_page_size = host_page_size;
+	}
 
 	/*
 	 * On s390x, all pages of a 1M segment are initially marked as dirty
@@ -103,18 +119,29 @@ static void guest_code(void)
 	 * To compensate this specialty in this test, we need to touch all
 	 * pages during the first iteration.
 	 */
-	for (i = 0; i < guest_num_pages; i++) {
-		addr = guest_test_virt_mem + i * guest_page_size;
-		*(uint64_t *)addr = READ_ONCE(iteration);
+	for (i = 0; i < num_pages; i++) {
+		addr = guest_test_virt_mem + i * page_size;
+		addr = align_down(addr, page_size);
+
+		for (j = 0; j < page_size / sub_page_size; j++) {
+			*(uint64_t *)(addr + j * sub_page_size) =
+				READ_ONCE(iteration);
+		}
 	}
 
+	pages_per_loop = (TEST_PAGES_PER_LOOP * sub_page_size) / page_size;
+
 	while (true) {
-		for (i = 0; i < TEST_PAGES_PER_LOOP; i++) {
+		for (i = 0; i < pages_per_loop; i++) {
 			addr = guest_test_virt_mem;
-			addr += (READ_ONCE(random_array[i]) % guest_num_pages)
-				* guest_page_size;
-			addr = align_down(addr, host_page_size);
-			*(uint64_t *)addr = READ_ONCE(iteration);
+			addr += (READ_ONCE(random_array[i]) % num_pages)
+				* page_size;
+			addr = align_down(addr, page_size);
+
+			for (j = 0; j < page_size / sub_page_size; j++) {
+				*(uint64_t *)(addr + j * sub_page_size) =
+					READ_ONCE(iteration);
+			}
 		}
 
 		/* Tell the host that we need more random numbers */
@@ -713,14 +740,14 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		       2ul << (DIRTY_MEM_BITS - PAGE_SHIFT_4K), guest_code);
 
 	guest_page_size = vm->page_size;
+	host_page_size = getpagesize();
+
 	/*
 	 * A little more than 1G of guest page sized pages.  Cover the
 	 * case where the size is not aligned to 64 pages.
 	 */
 	guest_num_pages = (1ul << (DIRTY_MEM_BITS - vm->page_shift)) + 3;
 	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
-
-	host_page_size = getpagesize();
 	host_num_pages = vm_num_host_pages(mode, guest_num_pages);
 
 	if (!p->phys_offset) {
@@ -760,6 +787,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	sync_global_to_guest(vm, host_page_size);
 	sync_global_to_guest(vm, guest_page_size);
 	sync_global_to_guest(vm, guest_test_virt_mem);
+	sync_global_to_guest(vm, host_num_pages);
 	sync_global_to_guest(vm, guest_num_pages);
 
 	/* Start the iterations */
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
