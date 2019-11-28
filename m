Return-Path: <SRS0=76eI=ZU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81A76C432C3
	for <kvmarm@archiver.kernel.org>; Thu, 28 Nov 2019 15:09:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0610D21741
	for <kvmarm@archiver.kernel.org>; Thu, 28 Nov 2019 15:09:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SVc1uV4x"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0610D21741
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 773A54ACD5;
	Thu, 28 Nov 2019 10:09:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ql++BxvWwtEn; Thu, 28 Nov 2019 10:09:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D7A84A5C3;
	Thu, 28 Nov 2019 10:09:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 529B04A5C3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Nov 2019 10:09:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bdTUvvP8HFZp for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Nov 2019 10:09:50 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 770484A4DF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Nov 2019 10:09:50 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1574953790;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=zfCwKwf1qQnxszU4MATj1+UFG4UOmnvAEgBHepQ9IM4=;
 b=SVc1uV4xM2mbJ0eWH6V3YL0n41M45Bxwe8iSA4NnPSpl/eW7dGCBVNNYimnEH2kFg8pWwd
 dEjWa/BFrvX2aSwMM+YctHeLsbp3aG9MxKlQqfu+a8yS1gVQ7QOAYD66Msn46aROqGvOHg
 QSdSKe/Bh6d0yHGljZxxIqee29AbQv4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-fm-CBMAuPZekwbgiC5X58A-1; Thu, 28 Nov 2019 10:09:48 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A57EC10054E3;
 Thu, 28 Nov 2019 15:09:47 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 754A4608AC;
 Thu, 28 Nov 2019 15:09:46 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH kvm-unit-tests v2] arm: Enable the VFP
Date: Thu, 28 Nov 2019 16:09:45 +0100
Message-Id: <20191128150945.3851-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: fm-CBMAuPZekwbgiC5X58A-1
X-Mimecast-Spam-Score: 0
Cc: pbonzini@redhat.com, thuth@redhat.com
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

Variable argument macros frequently depend on floating point
registers. Indeed we needed to enable the VFP for arm64 since its
introduction in order to use printf and the like. Somehow we
didn't need to do that for arm32 until recently when compiling
with GCC 9.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---

v2: Added '-mfpu=vfp' cflag to deal with older compilers

CC'ing Thomas because I think he had to workaround travis tests
failing due to this issue once. Maybe travis can now be
un-worked-around?


 arm/Makefile.arm |  2 +-
 arm/cstart.S     | 14 +++++++++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arm/Makefile.arm b/arm/Makefile.arm
index 43b4be1e05ee..d379a2800749 100644
--- a/arm/Makefile.arm
+++ b/arm/Makefile.arm
@@ -5,7 +5,7 @@
 #
 bits = 32
 ldarch = elf32-littlearm
-machine = -marm
+machine = -marm -mfpu=vfp
 
 # stack.o relies on frame pointers.
 KEEP_FRAME_POINTER := y
diff --git a/arm/cstart.S b/arm/cstart.S
index 114726feab82..bc6219d8a3ee 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -50,10 +50,11 @@ start:
 	mov	r0, r2
 	push	{r0-r1}
 
-	/* set up vector table and mode stacks */
+	/* set up vector table, mode stacks, and enable the VFP */
 	mov	r0, lr			@ lr is stack top (see above),
 					@ which is the exception stacks base
 	bl	exceptions_init
+	bl	enable_vfp
 
 	/* complete setup */
 	pop	{r0-r1}
@@ -100,6 +101,16 @@ exceptions_init:
 	isb
 	mov	pc, lr
 
+enable_vfp:
+	/* Enable full access to CP10 and CP11: */
+	mov	r0, #(3 << 22 | 3 << 20)
+	mcr	p15, 0, r0, c1, c0, 2
+	isb
+	/* Set the FPEXC.EN bit to enable Advanced SIMD and VFP: */
+	mov	r0, #(1 << 30)
+	vmsr	fpexc, r0
+	mov	pc, lr
+
 .text
 
 .global get_mmu_off
@@ -130,6 +141,7 @@ secondary_entry:
 	ldr	r0, [r1]
 	mov	sp, r0
 	bl	exceptions_init
+	bl	enable_vfp
 
 	/* finish init in C code */
 	bl	secondary_cinit
-- 
2.21.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
