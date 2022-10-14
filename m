Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94347C43219
	for <kvmarm@archiver.kernel.org>; Fri, 14 Oct 2022 07:21:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 32C7A4B274;
	Fri, 14 Oct 2022 03:21:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yDnlW5vm7d0x; Fri, 14 Oct 2022 03:21:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28C824B286;
	Fri, 14 Oct 2022 03:21:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BE3240BEE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Oct 2022 03:21:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M8zyDthewcva for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 Oct 2022 03:21:12 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F13D40C1F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Oct 2022 03:21:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1665732071;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=pr7VHnuYR01/Gc5/jPxyHFPhwmvdOLksQ25lnmxgeCs=;
 b=Ao4qM7HRDbYAEDNS7h8yVN6qjzHbBkV8Tr9DD0QJ4kD3nvGfm+b3bLlvmOg5mviCkEf4e8
 HqU2EzzPApjtkudvdl3EclJz5R9DCLs6lIeoEHHhyUHRXFFhGZIsKhxvQIoOSxJLKaEabc
 Th4Lh5kkuaEipuOBY1wGgieDX93xxXU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204-rtiAg9aKM9azsTkhDxYPzQ-1; Fri, 14 Oct 2022 03:21:08 -0400
X-MC-Unique: rtiAg9aKM9azsTkhDxYPzQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 972B51C05ED2;
 Fri, 14 Oct 2022 07:20:52 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-52.bne.redhat.com [10.64.54.52])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6FAF2C3343C;
 Fri, 14 Oct 2022 07:20:23 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Subject: [PATCH 5/6] KVM: selftests: memslot_perf_test: Consolidate memory
 sizes
Date: Fri, 14 Oct 2022 15:19:13 +0800
Message-Id: <20221014071914.227134-6-gshan@redhat.com>
In-Reply-To: <20221014071914.227134-1-gshan@redhat.com>
References: <20221014071914.227134-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 zhenyzha@redhat.com, shan.gavin@gmail.com, pbonzini@redhat.com,
 maciej.szmigiero@oracle.com, shuah@kernel.org, kvmarm@lists.cs.columbia.edu,
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

The addresses and sizes passed to madvise() and vm_userspace_mem_region_add()
should be aligned to host page size, which can be 64KB on aarch64. So it's
wrong by passing additional fixed 4KB memory area to various tests.

Fix it by passing additional fixed 64KB memory area to various tests. After
it's applied, the following command works fine on 64KB-page-size-host and
4KB-page-size-guest.

  # ./memslot_perf_test -v -s 512

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 .../testing/selftests/kvm/memslot_perf_test.c  | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index d587bd952ff9..e6d34744b45d 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -25,12 +25,14 @@
 #include <kvm_util.h>
 #include <processor.h>
 
-#define MEM_SIZE		((512U << 20) + 4096)
-#define MEM_GPA		0x10000000UL
+#define MEM_EXTRA_SIZE		0x10000
+
+#define MEM_SIZE		((512U << 20) + MEM_EXTRA_SIZE)
+#define MEM_GPA			0x10000000UL
 #define MEM_AUX_GPA		MEM_GPA
 #define MEM_SYNC_GPA		MEM_AUX_GPA
-#define MEM_TEST_GPA		(MEM_AUX_GPA + 4096)
-#define MEM_TEST_SIZE		(MEM_SIZE - 4096)
+#define MEM_TEST_GPA		(MEM_AUX_GPA + MEM_EXTRA_SIZE)
+#define MEM_TEST_SIZE		(MEM_SIZE - MEM_EXTRA_SIZE)
 
 /*
  * 32 MiB is max size that gets well over 100 iterations on 509 slots.
@@ -38,8 +40,8 @@
  * 8194 slots in use can then be tested (although with slightly
  * limited resolution).
  */
-#define MEM_SIZE_MAP		((32U << 20) + 4096)
-#define MEM_TEST_MAP_SIZE	(MEM_SIZE_MAP - 4096)
+#define MEM_SIZE_MAP		((32U << 20) + MEM_EXTRA_SIZE)
+#define MEM_TEST_MAP_SIZE	(MEM_SIZE_MAP - MEM_EXTRA_SIZE)
 
 /*
  * 128 MiB is min size that fills 32k slots with at least one page in each
@@ -799,13 +801,13 @@ static const struct test_data tests[] = {
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
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
