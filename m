Return-Path: <SRS0=dc8k=5U=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30E2BC2BA1A
	for <kvmarm@archiver.kernel.org>; Sat,  4 Apr 2020 14:38:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E03B8206F5
	for <kvmarm@archiver.kernel.org>; Sat,  4 Apr 2020 14:38:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FQ2jQCIB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E03B8206F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BB4F4B191;
	Sat,  4 Apr 2020 10:38:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nw1e7WI-c6Hy; Sat,  4 Apr 2020 10:37:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82C9A4B1EC;
	Sat,  4 Apr 2020 10:37:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0090B4B188
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Apr 2020 10:37:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LYwUGLGmFVrA for <kvmarm@lists.cs.columbia.edu>;
 Sat,  4 Apr 2020 10:37:56 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 16FD04B191
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Apr 2020 10:37:56 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1586011075;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=UcAnXTLK05SgTXUHXQBKYPlI5GJyG0mw92B1RM6BqXM=;
 b=FQ2jQCIB7/O+8KkkIi/xlSbF3Av+8QgxTZhpYClC1LOpUqLdUqVfn4eUxnzeqSD3QCI9mg
 eZK9FfIuwBUitpg13JKzL9eC5mxAGQlxXQiyC+Alom6OyRaXNAkSa9FEQfyBsFmyYMd2mm
 ixPHtn/P0sUMw6g/odYPWoGbPv4x6pQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-Amhc2xJtMUmRaY-ktwU_mQ-1; Sat, 04 Apr 2020 10:37:53 -0400
X-MC-Unique: Amhc2xJtMUmRaY-ktwU_mQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1A798024D0;
 Sat,  4 Apr 2020 14:37:48 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
 by smtp.corp.redhat.com (Postfix) with ESMTP id E30F09B912;
 Sat,  4 Apr 2020 14:37:46 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: pbonzini@redhat.com
Subject: [PULL kvm-unit-tests 04/39] arm64: timer: Add ISB before reading the
 counter value
Date: Sat,  4 Apr 2020 16:36:56 +0200
Message-Id: <20200404143731.208138-5-drjones@redhat.com>
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

From: Alexandru Elisei <alexandru.elisei@arm.com>

Reads of the physical counter and the virtual counter registers "can occur
speculatively and out of order relative to other instructions executed on
the same PE" [1, 2].

There is no theoretical limit to the number of instructions that the CPU
can reorder and we use the counter value to program the timer to fire in
the future. Add an ISB before reading the counter to make sure the read
instruction is not reordered too long in the past with regard to the
instruction that programs the timer alarm, thus causing the timer to fire
unexpectedly. This matches what Linux does (see
arch/arm64/include/asm/arch_timer.h).

Because we use the counter value to program the timer, we create a register
dependency [3] between the value that we read and the value that we write to
CVAL and thus we don't need a barrier after the read. Linux does things
differently because the read needs to be ordered with regard to a memory
load (more information in commit 75a19a0202db ("arm64: arch_timer: Ensure
counter register reads occur with seqlock held")).

This also matches what we already do in get_cntvct from
lib/arm{,64}/asm/processor.h.

[1] ARM DDI 0487E.a, section D11.2.1
[2] ARM DDI 0487E.a, section D11.2.2
[3] ARM DDI 0486E.a, section B2.3.2

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/timer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arm/timer.c b/arm/timer.c
index c6ea108cfa4b..e758e84855c3 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -30,6 +30,7 @@ static void ptimer_unsupported_handler(struct pt_regs *regs, unsigned int esr)
 
 static u64 read_vtimer_counter(void)
 {
+	isb();
 	return read_sysreg(cntvct_el0);
 }
 
@@ -68,6 +69,7 @@ static void write_vtimer_ctl(u64 val)
 
 static u64 read_ptimer_counter(void)
 {
+	isb();
 	return read_sysreg(cntpct_el0);
 }
 
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
