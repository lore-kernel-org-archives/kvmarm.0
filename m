Return-Path: <SRS0=dc8k=5U=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B255C2BA15
	for <kvmarm@archiver.kernel.org>; Sat,  4 Apr 2020 14:39:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 269652070E
	for <kvmarm@archiver.kernel.org>; Sat,  4 Apr 2020 14:39:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SBhbQtRJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 269652070E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B8F54B284;
	Sat,  4 Apr 2020 10:39:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qJnoFjTm1oQ6; Sat,  4 Apr 2020 10:39:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8659E4B295;
	Sat,  4 Apr 2020 10:39:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26BAA4B179
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Apr 2020 10:39:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bUOK1AAsGy8t for <kvmarm@lists.cs.columbia.edu>;
 Sat,  4 Apr 2020 10:39:35 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DEBC4B27B
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Apr 2020 10:39:35 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1586011175;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=tCVC87LkZJzjp0nWYU+R4308nabVVB1yt9ifphXuw5Y=;
 b=SBhbQtRJXLmW/caB3xJUGn8vr/UbAw+uI8E0efnUiAlPQbEjrdVtkvtYQzFpuHUcfxU8Lo
 rCdv3iZL/yX8/eLBi9VRWDQx1m08G1BbinQJedwWMiUBhPE15A3ehfZZ6/B3MMoHVSQZ6j
 WWsjyOGPaf3ma6uGUiTeGZ1vmGA0AJU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-DRO7e7xkPU6k4HhiPkLdSA-1; Sat, 04 Apr 2020 10:39:28 -0400
X-MC-Unique: DRO7e7xkPU6k4HhiPkLdSA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD3BEDB22;
 Sat,  4 Apr 2020 14:39:27 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 824B89B912;
 Sat,  4 Apr 2020 14:39:26 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: pbonzini@redhat.com
Subject: [PULL kvm-unit-tests 37/39] arm/run: Allow Migration tests
Date: Sat,  4 Apr 2020 16:37:29 +0200
Message-Id: <20200404143731.208138-38-drjones@redhat.com>
In-Reply-To: <20200404143731.208138-1-drjones@redhat.com>
References: <20200404143731.208138-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

From: Eric Auger <eric.auger@redhat.com>

Let's link getchar.o to use puts and getchar from the
tests.

Then allow tests belonging to the migration group to
trigger the migration from the test code by putting
"migrate" into the uart. Then the code can wait for the
migration completion by using getchar().

The __getchar implement is minimalist as it just reads the
data register. It is just meant to read the single character
emitted at the end of the migration by the runner script.

It is not meant to read more data (FIFOs are not enabled).

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/Makefile.common |  2 +-
 arm/run             |  2 +-
 lib/arm/io.c        | 28 ++++++++++++++++++++++++++++
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/arm/Makefile.common b/arm/Makefile.common
index b8988f214d3b..a123e85d21bc 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -32,7 +32,7 @@ CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib
 asm-offsets = lib/$(ARCH)/asm-offsets.h
 include $(SRCDIR)/scripts/asm-offsets.mak
 
-cflatobjs += lib/util.o
+cflatobjs += lib/util.o lib/getchar.o
 cflatobjs += lib/alloc_phys.o
 cflatobjs += lib/alloc_page.o
 cflatobjs += lib/vmalloc.o
diff --git a/arm/run b/arm/run
index 277db9bb4a02..a390ca5ae0ba 100755
--- a/arm/run
+++ b/arm/run
@@ -61,6 +61,6 @@ fi
 M+=",accel=$ACCEL"
 command="$qemu -nodefaults $M -cpu $processor $chr_testdev $pci_testdev"
 command+=" -display none -serial stdio -kernel"
-command="$(timeout_cmd) $command"
+command="$(migration_cmd) $(timeout_cmd) $command"
 
 run_qemu $command "$@"
diff --git a/lib/arm/io.c b/lib/arm/io.c
index 99fd31560084..343e10822263 100644
--- a/lib/arm/io.c
+++ b/lib/arm/io.c
@@ -87,6 +87,34 @@ void puts(const char *s)
 	spin_unlock(&uart_lock);
 }
 
+static int do_getchar(void)
+{
+	int c;
+
+	spin_lock(&uart_lock);
+	c = readb(uart0_base);
+	spin_unlock(&uart_lock);
+
+	return c ?: -1;
+}
+
+/*
+ * Minimalist implementation for migration completion detection.
+ * Without FIFOs enabled on the QEMU UART device we just read
+ * the data register: we cannot read more than 16 characters.
+ */
+int __getchar(void)
+{
+	int c = do_getchar();
+	static int count;
+
+	if (c != -1)
+		++count;
+
+	assert(count < 16);
+
+	return c;
+}
 
 /*
  * Defining halt to take 'code' as an argument guarantees that it will
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
