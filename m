Return-Path: <SRS0=EFuC=5T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0940C43331
	for <kvmarm@archiver.kernel.org>; Fri,  3 Apr 2020 07:13:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 76CF9206F5
	for <kvmarm@archiver.kernel.org>; Fri,  3 Apr 2020 07:13:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AmaEZl22"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 76CF9206F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21D674B162;
	Fri,  3 Apr 2020 03:13:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6lU2c599XT8Q; Fri,  3 Apr 2020 03:13:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE3144B169;
	Fri,  3 Apr 2020 03:13:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 802B74AC80
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Apr 2020 03:13:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yaY9RJgT1mpn for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Apr 2020 03:13:42 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7A664B163
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Apr 2020 03:13:42 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1585898022;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=5QgGQR5lmCzHdU2tw8u26Dp0LVz138MaKuXfv7AyzLc=;
 b=AmaEZl22Q6IctKMMzB+rgc+I1AJAJjjmCPvgwSxYbp1F/7g70ROC+W/WgheZZZrnrpsD0w
 HJn3BGdNJ6XD6i09ZsLqX/OtUMQi7+MlinhASqRimz9VP1UZJhENS/jSWEkmmxfjHB/SX3
 jhSyQK9eZihjj2v+7n0051UbQpd95Rc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-6uK3z0ZZOhS9hY4FytW9qg-1; Fri, 03 Apr 2020 03:13:40 -0400
X-MC-Unique: 6uK3z0ZZOhS9hY4FytW9qg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D63AF107ACC4;
 Fri,  3 Apr 2020 07:13:38 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-58.ams2.redhat.com [10.36.112.58])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 1D68C5C1C6;
 Fri,  3 Apr 2020 07:13:35 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [kvm-unit-tests PATCH v4 01/12] arm64: Provide read/write_sysreg_s
Date: Fri,  3 Apr 2020 09:13:15 +0200
Message-Id: <20200403071326.29932-2-eric.auger@redhat.com>
In-Reply-To: <20200403071326.29932-1-eric.auger@redhat.com>
References: <20200403071326.29932-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Cc: andrew.murray@arm.com, andre.przywara@arm.com
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

From: Andrew Jones <drjones@redhat.com>

Sometimes we need to test access to system registers which are
missing assembler mnemonics.

Signed-off-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm64/asm/sysreg.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
index a03830b..a45eebd 100644
--- a/lib/arm64/asm/sysreg.h
+++ b/lib/arm64/asm/sysreg.h
@@ -38,6 +38,17 @@
 	asm volatile("msr " xstr(r) ", %x0" : : "rZ" (__val));	\
 } while (0)
 
+#define read_sysreg_s(r) ({					\
+	u64 __val;						\
+	asm volatile("mrs_s %0, " xstr(r) : "=r" (__val));	\
+	__val;							\
+})
+
+#define write_sysreg_s(v, r) do {				\
+	u64 __val = (u64)v;					\
+	asm volatile("msr_s " xstr(r) ", %x0" : : "rZ" (__val));\
+} while (0)
+
 asm(
 "	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30\n"
 "	.equ	.L__reg_num_x\\num, \\num\n"
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
