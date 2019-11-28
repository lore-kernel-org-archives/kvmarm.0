Return-Path: <SRS0=76eI=ZU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26FFAC43215
	for <kvmarm@archiver.kernel.org>; Thu, 28 Nov 2019 14:34:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9A0422071F
	for <kvmarm@archiver.kernel.org>; Thu, 28 Nov 2019 14:34:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T4nxUxGd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A0422071F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB6674A522;
	Thu, 28 Nov 2019 09:34:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bXtMcdgLbprc; Thu, 28 Nov 2019 09:34:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 030B34A5A0;
	Thu, 28 Nov 2019 09:34:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2BE34A52E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Nov 2019 09:34:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N1NcfWQCYqOy for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Nov 2019 09:34:29 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00B014A522
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Nov 2019 09:34:28 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1574951668;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=3ypLLmy7uIRdZ2ESXpMXZa2LOjKZgb/771ocPNYrRmk=;
 b=T4nxUxGdmeZqEKr/WBy1u5BaCqRhkYj4fpI+LRHKaWYwEJLNvRUXlPA+1PC6CfFNAu6Rgb
 aOP+7rlGjflGsFbRx+4w6mGWOxtNjW7xwfixGt0LvXFfCdUW1uN556j10yXS2hrGtC2Qvp
 PIahxO6N6oyOOXqUaXedp1vp104lQb8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136-rEEgGoYSMsaDEemHK1Gl6w-1; Thu, 28 Nov 2019 09:34:25 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5EFFC1800D52;
 Thu, 28 Nov 2019 14:34:24 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 2991E5C1B0;
 Thu, 28 Nov 2019 14:34:23 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH kvm-unit-tests] arm: Enable the VFP
Date: Thu, 28 Nov 2019 15:34:21 +0100
Message-Id: <20191128143421.13815-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: rEEgGoYSMsaDEemHK1Gl6w-1
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

CC'ing Thomas because I think he had to workaround travis tests
failing due to this issue once. Maybe travis can now be
un-worked-around?


 arm/cstart.S | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

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
