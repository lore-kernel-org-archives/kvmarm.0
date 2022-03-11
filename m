Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E9FCC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 17:09:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7200408AA;
	Fri, 11 Mar 2022 12:09:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f69Otabe3Iv5; Fri, 11 Mar 2022 12:09:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9357E4076A;
	Fri, 11 Mar 2022 12:09:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92AF640815
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:09:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x25H7Yz3O5QC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Mar 2022 12:08:59 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8801F40712
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:08:59 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647018539;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=CGRRW1HyrjpX/mPdb1gMd4vnitCkHwitZW09OE4n8UI=;
 b=EaLBSUAgC9GUeFFs5cIw/htfE2IZhHGdJnVQmHrDehHKRZKrRluU/gzJawLwrAWmM/4mT9
 VyFH27NymFAIVhRkbwm01zoYrR1NS/G+JaRWSyOaHutN1HMLBGTNBocMPWeAh14F8bWnXv
 +cjZhpiTW85+GbQB/+TFJiBKED9b3c0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-332-M_2iTGDXOeu-AwPOdsOApg-1; Fri, 11 Mar 2022 12:08:55 -0500
X-MC-Unique: M_2iTGDXOeu-AwPOdsOApg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1144FC80;
 Fri, 11 Mar 2022 17:08:54 +0000 (UTC)
Received: from thuth.com (unknown [10.39.194.213])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 7596E1059163;
 Fri, 11 Mar 2022 17:08:53 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Andrew Jones <drjones@redhat.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] arm: Fix typos
Date: Fri, 11 Mar 2022 18:08:50 +0100
Message-Id: <20220311170850.2911898-1-thuth@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: kvmarm@lists.cs.columbia.edu
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

Correct typos which were discovered with the "codespell" utility.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 arm/cstart.S              | 2 +-
 arm/gic.c                 | 2 +-
 arm/micro-bench.c         | 2 +-
 lib/arm64/asm/assembler.h | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arm/cstart.S b/arm/cstart.S
index 2401d92..7036e67 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -44,7 +44,7 @@ start:
 
 	/*
 	 * set stack, making room at top of stack for cpu0's
-	 * exception stacks. Must start wtih stackptr, not
+	 * exception stacks. Must start with stackptr, not
 	 * stacktop, so the thread size masking (shifts) work.
 	 */
 	ldr	sp, =stackptr
diff --git a/arm/gic.c b/arm/gic.c
index 1e3ea80..60457e2 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -909,7 +909,7 @@ static void test_its_pending_migration(void)
 	gicv3_lpi_rdist_disable(pe0);
 	gicv3_lpi_rdist_disable(pe1);
 
-	/* lpis are interleaved inbetween the 2 PEs */
+	/* lpis are interleaved between the 2 PEs */
 	for (i = 0; i < 256; i++) {
 		struct its_collection *col = i % 2 ? collection[0] :
 						     collection[1];
diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index c731b1d..8436612 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -265,7 +265,7 @@ static void timer_post(uint64_t ntimes, uint64_t *total_ticks)
 {
 	/*
 	 * We use a 10msec timer to test the latency of PPI,
-	 * so we substract the ticks of 10msec to get the
+	 * so we subtract the ticks of 10msec to get the
 	 * actual latency
 	 */
 	*total_ticks -= ntimes * (cntfrq / 100);
diff --git a/lib/arm64/asm/assembler.h b/lib/arm64/asm/assembler.h
index a271e4c..aa8c65a 100644
--- a/lib/arm64/asm/assembler.h
+++ b/lib/arm64/asm/assembler.h
@@ -32,7 +32,7 @@
  * kvm-unit-tests has no concept of scheduling.
  *
  * 	op:		operation passed to dc instruction
- * 	domain:		domain used in dsb instruciton
+ * 	domain:		domain used in dsb instruction
  * 	addr:		starting virtual address of the region
  * 	size:		size of the region
  * 	Corrupts:	addr, size, tmp1, tmp2
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
