Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E624EC38A02
	for <kvmarm@archiver.kernel.org>; Mon, 31 Oct 2022 00:39:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BBC64BAD8;
	Sun, 30 Oct 2022 20:39:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G11SUyGzDhus; Sun, 30 Oct 2022 20:39:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 730194BA8E;
	Sun, 30 Oct 2022 20:39:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED1DE4BA8B
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Oct 2022 20:39:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2caBkdjNZaWm for <kvmarm@lists.cs.columbia.edu>;
 Sun, 30 Oct 2022 20:39:08 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E645E4BA79
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Oct 2022 20:39:08 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667176748;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=UeYV9gtrEMC/f2NfGupIKl3UhHTgEqpO1AGhP6jS8dg=;
 b=JYfu8clHAA+YOyFJWMUdB4Qm2SQz+ZTeJ3t4O46sPPRjTJvEHHgJp93BGdo4VCCMMUKudH
 0xiVsd4ZCpon4P9CCaYth0TqejZn/3z1V/dWgezEbNQHETKUx3JYyv7YeyWHFTsNBYEWVH
 A3CGHhIFc7nRXCYvTV9URHWoXVl8zE0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-249-Ul4LwwRhM0aMhypjoAEcLQ-1; Sun, 30 Oct 2022 20:39:04 -0400
X-MC-Unique: Ul4LwwRhM0aMhypjoAEcLQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52797185A794;
 Mon, 31 Oct 2022 00:39:03 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-151.bne.redhat.com [10.64.54.151])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 46E6D40C6F75;
 Mon, 31 Oct 2022 00:38:55 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Subject: [PATCH v7 9/9] KVM: selftests: Automate choosing dirty ring size in
 dirty_log_test
Date: Mon, 31 Oct 2022 08:36:21 +0800
Message-Id: <20221031003621.164306-10-gshan@redhat.com>
In-Reply-To: <20221031003621.164306-1-gshan@redhat.com>
References: <20221031003621.164306-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Cc: shuah@kernel.org, catalin.marinas@arm.com, kvm@vger.kernel.org,
 maz@kernel.org, andrew.jones@linux.dev, shan.gavin@gmail.com,
 bgardon@google.com, dmatlack@google.com, pbonzini@redhat.com,
 zhenyzha@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

In the dirty ring case, we rely on vcpu exit due to full dirty ring
state. On ARM64 system, there are 4096 host pages when the host
page size is 64KB. In this case, the vcpu never exits due to the
full dirty ring state. The similar case is 4KB page size on host
and 64KB page size on guest. The vcpu corrupts same set of host
pages, but the dirty page information isn't collected in the main
thread. This leads to infinite loop as the following log shows.

  # ./dirty_log_test -M dirty-ring -c 65536 -m 5
  Setting log mode to: 'dirty-ring'
  Test iterations: 32, interval: 10 (ms)
  Testing guest mode: PA-bits:40,  VA-bits:48,  4K pages
  guest physical test memory offset: 0xffbffe0000
  vcpu stops because vcpu is kicked out...
  Notifying vcpu to continue
  vcpu continues now.
  Iteration 1 collected 576 pages
  <No more output afterwards>

Fix the issue by automatically choosing the best dirty ring size,
to ensure vcpu exit due to full dirty ring state. The option '-c'
becomes a hint to the dirty ring count, instead of the value of it.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 26 +++++++++++++++++---
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 8758c10ec850..a87e5f78ebf1 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -24,6 +24,9 @@
 #include "guest_modes.h"
 #include "processor.h"
 
+#define DIRTY_MEM_BITS 30 /* 1G */
+#define PAGE_SHIFT_4K  12
+
 /* The memory slot index to track dirty pages */
 #define TEST_MEM_SLOT_INDEX		1
 
@@ -273,6 +276,24 @@ static bool dirty_ring_supported(void)
 
 static void dirty_ring_create_vm_done(struct kvm_vm *vm)
 {
+	uint64_t pages;
+	uint32_t limit;
+
+	/*
+	 * We rely on vcpu exit due to full dirty ring state. Adjust
+	 * the ring buffer size to ensure we're able to reach the
+	 * full dirty ring state.
+	 */
+	pages = (1ul << (DIRTY_MEM_BITS - vm->page_shift)) + 3;
+	pages = vm_adjust_num_guest_pages(vm->mode, pages);
+	if (vm->page_size < getpagesize())
+		pages = vm_num_host_pages(vm->mode, pages);
+
+	limit = 1 << (31 - __builtin_clz(pages));
+	test_dirty_ring_count = 1 << (31 - __builtin_clz(test_dirty_ring_count));
+	test_dirty_ring_count = min(limit, test_dirty_ring_count);
+	pr_info("dirty ring count: 0x%x\n", test_dirty_ring_count);
+
 	/*
 	 * Switch to dirty ring mode after VM creation but before any
 	 * of the vcpu creation.
@@ -685,9 +706,6 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, struct kvm_vcpu **vcpu,
 	return vm;
 }
 
-#define DIRTY_MEM_BITS 30 /* 1G */
-#define PAGE_SHIFT_4K  12
-
 struct test_params {
 	unsigned long iterations;
 	unsigned long interval;
@@ -830,7 +848,7 @@ static void help(char *name)
 	printf("usage: %s [-h] [-i iterations] [-I interval] "
 	       "[-p offset] [-m mode]\n", name);
 	puts("");
-	printf(" -c: specify dirty ring size, in number of entries\n");
+	printf(" -c: hint to dirty ring size, in number of entries\n");
 	printf("     (only useful for dirty-ring test; default: %"PRIu32")\n",
 	       TEST_DIRTY_RING_COUNT);
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
