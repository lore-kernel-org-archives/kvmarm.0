Return-Path: <SRS0=WrEh=O4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A49C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 17:40:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 09C9B6101A
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 17:40:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 09C9B6101A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FB3A4B0A3;
	Fri,  8 Oct 2021 13:40:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7svL7EHhNa-M; Fri,  8 Oct 2021 13:40:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A4654B0B6;
	Fri,  8 Oct 2021 13:40:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE2704B093
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 13:40:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r5F-PHnl8FL2 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 13:40:27 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E0D6B405A6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 13:40:27 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 b9-20020a5b07890000b0290558245b7eabso13420875ybq.10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 10:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=S8FBbl6lmGnPBVMI8VNGPJDiN+mj3/gpo0KwKgQSUK0=;
 b=qP6aS0hp2202u33t77wMPCFTdcTl3UJGnUlf8F+uwXTszHWfGIxA+ejlgc2EszEayd
 Q5k442RcV8byW8GFezjWQStprHq/mrBDuc/fhFbqdlMRC1JBlDLeSE7gKWdT4kMwbcE/
 GiZ3tNGPWjQLia1W2UcaoYRbfq28YZmHCNhDisme7PPSDX+LMRIF0aYTwel3WezFxChy
 GNS8ca+uB+AYE6RycMBO4ouXizikGggu09YuYAUzs6KVyufLJfeVQB6eAA4fSZNn/W8y
 jqlfT8WSGjNG67favmpYGPaus3GjOEIPSdSnoA/ozHC8h1GGZjrpRx3lcvCcigw3SN8l
 cLMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=S8FBbl6lmGnPBVMI8VNGPJDiN+mj3/gpo0KwKgQSUK0=;
 b=oSSKFTMu7bSDC39JOuRbM4nwcDtV/scaQ82V15g2dGwUE96j5jUF6fGhsK67MUCtc2
 w1PBz1QrwrT6wstAGuuUo2l0c7X8UzxdXBFcB1obuwqhzX0t0Ecrt74HL7SyrXNKjyIr
 5u6nOFP5S2xwYS864zGSKDhmduTUSOEjKI7Pm+UaACsmKC+fuvYGcV5nkUHVnLMVCRAz
 DFG37Uol5FN7VQR/zkHBIQXlsE2ShPDDn0SHzzwvPgZsl6sIHoH1driXnrnEpdE5yoFl
 MFYJpsRnQzvZGUoJps1maih/4jXn2pTpQEkcPPa2phEpH5HRfx/kuaSHp1RAvkYQ30GX
 yHlw==
X-Gm-Message-State: AOAM532JvUPpZEQEDTtNPA/yYitlCSRCYBj8DZVe4NX1/IrrtZSlLPUV
 ObwazjnKu2G8TxCRJbAaSMMl3Z/DvArQOA==
X-Google-Smtp-Source: ABdhPJwMjy9k6BstIagSN5//XDryWlcz664ABmmd/chGimhmfE/yUQZn+HiHpd+cLcIO82rS5B+TmIMNOebU5g==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6902:114a:: with SMTP id
 p10mr5254440ybu.234.1633714825228; Fri, 08 Oct 2021 10:40:25 -0700 (PDT)
Date: Fri,  8 Oct 2021 10:40:22 -0700
Message-Id: <20211008174022.3028983-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [kvm-unit-tests PATCH v2] arm64: Add mmio_addr arg to arm/micro-bench
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
is passed.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/micro-bench.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index 8e1d4ab..c731b1d 100644
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
@@ -278,12 +281,14 @@ static void *userspace_emulated_addr;
 static bool mmio_read_user_prep(void)
 {
 	/*
-	 * FIXME: Read device-id in virtio mmio here in order to
-	 * force an exit to userspace. This address needs to be
-	 * updated in the future if any relevant changes in QEMU
-	 * test-dev are made.
+	 * FIXME: We need an MMIO address that we can safely read to test
+	 * exits to userspace. Ideally, the test-dev would provide us this
+	 * address (and one we could write to too), but until it does we
+	 * use a virtio-mmio transport address. FIXME2: We should be getting
+	 * this address (and the future test-dev address) from the devicetree,
+	 * but so far we lazily hardcode it.
 	 */
-	userspace_emulated_addr = (void*)ioremap(0x0a000008, sizeof(u32));
+	userspace_emulated_addr = (void *)ioremap(mmio_addr, sizeof(u32));
 	return true;
 }
 
@@ -378,10 +383,29 @@ static void loop_test(struct exit_test *test)
 		test->name, total_ns.ns, total_ns.ns_frac, avg_ns.ns, avg_ns.ns_frac);
 }
 
+static void parse_args(int argc, char **argv)
+{
+	int i, len;
+	long val;
+
+	for (i = 1; i < argc; ++i) {
+		len = parse_keyval(argv[i], &val);
+		if (len == -1)
+			continue;
+
+		if (strncmp(argv[i], "mmio-addr", len) == 0) {
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
