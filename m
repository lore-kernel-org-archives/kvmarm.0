Return-Path: <SRS0=Cc05=O3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B91A5C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  7 Oct 2021 18:32:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2C0EE6103C
	for <kvmarm@archiver.kernel.org>; Thu,  7 Oct 2021 18:32:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2C0EE6103C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BDA9400CF;
	Thu,  7 Oct 2021 14:32:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CDz883Qhod3j; Thu,  7 Oct 2021 14:32:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DA6C4B2AC;
	Thu,  7 Oct 2021 14:32:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 306F04B2A6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Oct 2021 14:32:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LmCzDYtGdcDm for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Oct 2021 14:32:34 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 14603400CF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Oct 2021 14:32:34 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 n22-20020a6563d6000000b0029261ffde9bso293440pgv.22
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Oct 2021 11:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=i6OEbiI8nlcVRWyoELZ1THHrO3woPs2C0f6nWf9PSk4=;
 b=mXR5zPdcv4MXtkg2imDp3q7q0/bEztvEq0fsPXhM84SSV5Us+5vTx3owGhop+XvCbs
 LhxEoD/DAKQznwMtjJqVH2eOGgyFwRbXkZO9um0j11iMwdAb4UV+7XHsj/rddZqkEmtw
 ZWcSJmaPT2/kXZb5cSiwitT7zOnBabZeIiQrjUlWvHmm1wz3yi3b0Ju46pc96bEZTt6l
 ekrL+dGlxbYrHSOCmUqQLb8CLB4q87NB7vm+fYd08OqbV952AP8bq26ZMaIMedtJ3zgx
 PHLzk/O20mxGbtOxtlEVlYEabRFzmWyuvVj2WePmgI9DNQsGaNgvukCY7PhCbwHgKC5p
 wCfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=i6OEbiI8nlcVRWyoELZ1THHrO3woPs2C0f6nWf9PSk4=;
 b=Sy38qedgmqG309g+eCVGzcd6BiIr1+OErcvGETy79N48qy0ALTy39SeKNweDhytNDc
 EWLwP1athhC9yMlIQ5152clGI5BmmdctBGAvpJGTqctf+Ssl/Hg/Hw+d0AuiCiqvt1MX
 vyBaEvqe0hfhQXh+i5t/HfmxQ1IfKNDBAFE76FNh8nk7YKFYx41uSVSK813L9oNj1f6O
 KqovI84tgyXhvLj6dZhBHRWAs0y48FbVrpl8/2/WbHG7JFKbOsRmIv4j+v5zP9+110GL
 GE4Dl6aMggDLdvOFvKDWnpVwMpLwVtuyxZe4mKp60bXcrzfjT92nwG2KxO8gvsFAkrdH
 73MQ==
X-Gm-Message-State: AOAM5302BFAkezxQ0Z591pZVW0GJcktdwLUOII3B7hcOcWEcpHjoDnGy
 VxG+XAh38uim3JrXyE58ebp08xs/tGUcsw==
X-Google-Smtp-Source: ABdhPJy7oKg9elfYErbsHYmLS4lp7sNHRNhyxdLMfpQzT1qM4Nmm6PELIP83922J96gkNI0XU07DH5zFMHLEEg==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:e544:b0:13e:e863:6cd2 with SMTP
 id n4-20020a170902e54400b0013ee8636cd2mr5171887plf.41.1633631553089; Thu, 07
 Oct 2021 11:32:33 -0700 (PDT)
Date: Thu,  7 Oct 2021 11:32:30 -0700
Message-Id: <20211007183230.2637929-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [kvm-unit-tests PATCH] arm64: Add mmio_addr arg to arm/micro-bench
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Paolo Bonzini <pbonzini@redhat.com>
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

Add a command line arg to arm/micro-bench to set the mmio_addr to other
values besides the default QEMU one. Default to the QEMU value if no arg
is passed. Also, the <NUM> in mmio_addr=<NUM> can't be a hex.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/micro-bench.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index 8e1d4ab..2c08813 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -19,16 +19,19 @@
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
 #include <libcflat.h>
+#include <util.h>
 #include <asm/gic.h>
 #include <asm/gic-v3-its.h>
 #include <asm/timer.h>
 
-#define NS_5_SECONDS (5 * 1000 * 1000 * 1000UL)
+#define NS_5_SECONDS		(5 * 1000 * 1000 * 1000UL)
+#define QEMU_MMIO_ADDR		0x0a000008
 
 static u32 cntfrq;
 
 static volatile bool irq_ready, irq_received;
 static int nr_ipi_received;
+static unsigned long mmio_addr = QEMU_MMIO_ADDR;
 
 static void *vgic_dist_base;
 static void (*write_eoir)(u32 irqstat);
@@ -278,12 +281,10 @@ static void *userspace_emulated_addr;
 static bool mmio_read_user_prep(void)
 {
 	/*
-	 * FIXME: Read device-id in virtio mmio here in order to
-	 * force an exit to userspace. This address needs to be
-	 * updated in the future if any relevant changes in QEMU
-	 * test-dev are made.
+	 * Read device-id in virtio mmio here in order to
+	 * force an exit to userspace.
 	 */
-	userspace_emulated_addr = (void*)ioremap(0x0a000008, sizeof(u32));
+	userspace_emulated_addr = (void *)ioremap(mmio_addr, sizeof(u32));
 	return true;
 }
 
@@ -378,10 +379,30 @@ static void loop_test(struct exit_test *test)
 		test->name, total_ns.ns, total_ns.ns_frac, avg_ns.ns, avg_ns.ns_frac);
 }
 
+static void parse_args(int argc, char **argv)
+{
+	int i, len;
+	long val;
+
+	for (i = 0; i < argc; ++i) {
+		len = parse_keyval(argv[i], &val);
+		if (len == -1)
+			continue;
+
+		argv[i][len] = '\0';
+		if (strcmp(argv[i], "mmio-addr") == 0) {
+			mmio_addr = val;
+			report_info("found mmio_addr=0x%lx", mmio_addr);
+		}
+	}
+}
+
 int main(int argc, char **argv)
 {
 	int i;
 
+	parse_args(argc, argv);
+
 	if (!test_init())
 		return 1;
 
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
