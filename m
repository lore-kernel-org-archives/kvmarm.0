Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0048C00140
	for <kvmarm@archiver.kernel.org>; Fri, 19 Aug 2022 00:57:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE49B4C25D;
	Thu, 18 Aug 2022 20:57:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xfhPEc0HYp1I; Thu, 18 Aug 2022 20:57:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C42574CC2F;
	Thu, 18 Aug 2022 20:57:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 130344CC29
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Aug 2022 20:57:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vnVIY1DMmAAv for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Aug 2022 20:57:31 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E06504CC2F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Aug 2022 20:57:31 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1660870651;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=NtiIgnIOWAAHwJQ2LveDQTHCn3qhSJFmqy9sxEsG1rc=;
 b=MYZzpYaGYZuDC3c3NpxjkJ81fPmvyocs94YkRfy4kjp+1bXmQ5ysFPQkfu9pYJtUGquXXe
 zoqP7tjZ4IUMQkKzoqiah6wDQI5sMzdiodL6x2MxZPbAZjq6c0aM1oFBggC8nEZrAJ7y6u
 ru7D+a8X4FiGKV09fwErMdK2T3n8js0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-491-hcWi1V5tPBipyahNrluaWA-1; Thu, 18 Aug 2022 20:57:26 -0400
X-MC-Unique: hcWi1V5tPBipyahNrluaWA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BCBDF801755;
 Fri, 19 Aug 2022 00:57:24 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-16.bne.redhat.com [10.64.54.16])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C878FC15BB8;
 Fri, 19 Aug 2022 00:57:16 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 5/5] KVM: selftests: Automate choosing dirty ring size in
 dirty_log_test
Date: Fri, 19 Aug 2022 08:56:01 +0800
Message-Id: <20220819005601.198436-6-gshan@redhat.com>
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

In the dirty ring case, we rely on VM_EXIT due to full dirty ring
state. On ARM64 system, there are 4096 host pages when the host
page size is 64KB. In this case, the vcpu never exits due to the
full dirty ring state. The vcpu corrupts same set of pages, but the
dirty page information isn't collected in the main thread. This
leads to infinite loop as the following log shows.

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
to ensure VM_EXIT due to full dirty ring state. The option '-c'
provides a hint to it, instead of the value of it.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 24 ++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 450e97d10de7..ad31b6e3fe6a 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -23,6 +23,9 @@
 #include "guest_modes.h"
 #include "processor.h"
 
+#define DIRTY_MEM_BITS 30 /* 1G */
+#define PAGE_SHIFT_4K  12
+
 /* The memory slot index to track dirty pages */
 #define TEST_MEM_SLOT_INDEX		1
 
@@ -298,6 +301,22 @@ static bool dirty_ring_supported(void)
 
 static void dirty_ring_create_vm_done(struct kvm_vm *vm)
 {
+	uint64_t pages;
+	uint32_t limit;
+
+	/*
+	 * We rely on VM_EXIT due to full dirty ring state. Adjust
+	 * the ring buffer size to ensure we're able to reach the
+	 * full dirty ring state.
+	 */
+	pages = (1ul << (DIRTY_MEM_BITS - vm->page_shift)) + 3;
+	pages = vm_adjust_num_guest_pages(vm->mode, pages);
+	pages = vm_num_host_pages(vm->mode, pages);
+
+	limit = 1 << (31 - __builtin_clz(pages));
+	test_dirty_ring_count = 1 << (31 - __builtin_clz(test_dirty_ring_count));
+	test_dirty_ring_count = min(limit, test_dirty_ring_count);
+
 	/*
 	 * Switch to dirty ring mode after VM creation but before any
 	 * of the vcpu creation.
@@ -710,9 +729,6 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, struct kvm_vcpu **vcpu,
 	return vm;
 }
 
-#define DIRTY_MEM_BITS 30 /* 1G */
-#define PAGE_SHIFT_4K  12
-
 struct test_params {
 	unsigned long iterations;
 	unsigned long interval;
@@ -856,7 +872,7 @@ static void help(char *name)
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
