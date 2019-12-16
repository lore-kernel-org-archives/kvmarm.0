Return-Path: <SRS0=GAmw=2G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 904AEC2D0BF
	for <kvmarm@archiver.kernel.org>; Mon, 16 Dec 2019 14:04:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4A4E620684
	for <kvmarm@archiver.kernel.org>; Mon, 16 Dec 2019 14:04:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NngFZxQT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4A4E620684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 041D24A500;
	Mon, 16 Dec 2019 09:04:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bWFBVc1TXkWW; Mon, 16 Dec 2019 09:04:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E77C14A95C;
	Mon, 16 Dec 2019 09:04:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 21A534A65C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Dec 2019 09:04:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SFO4uPgbnBfp for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Dec 2019 09:04:13 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 323A64A319
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Dec 2019 09:04:13 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1576505052;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=go7p3wwISfVA0pTnz3FCaoN35+Sj/LsY9kHumr5FQBc=;
 b=NngFZxQTzCi0dy/V0rHpIqF4ivGvco6IoqTDiD4sdmSYHDAvyxXBcCi0tmQ7LCpESO283N
 ynhLF+KCwDZ9WhXsSfMzY+B28IH4PDMUvHVoINsL66qVLKYzdUZgkVnrh1nHkKyPDW/Y8M
 CL2AWeEQ92zp3vv95hvMBH0t+0Z2LbI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-rtoyeNZEPGCPQmzAG2EvCg-1; Mon, 16 Dec 2019 09:04:08 -0500
X-MC-Unique: rtoyeNZEPGCPQmzAG2EvCg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 199D38024E6;
 Mon, 16 Dec 2019 14:04:07 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-117.ams2.redhat.com [10.36.116.117])
 by smtp.corp.redhat.com (Postfix) with ESMTP id F0B68675B8;
 Mon, 16 Dec 2019 14:04:03 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [kvm-unit-tests PATCH 08/16] arm/arm64: ITS: Init the command queue
Date: Mon, 16 Dec 2019 15:02:27 +0100
Message-Id: <20191216140235.10751-9-eric.auger@redhat.com>
In-Reply-To: <20191216140235.10751-1-eric.auger@redhat.com>
References: <20191216140235.10751-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Cc: andre.przywara@arm.com, thuth@redhat.com
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

Allocate the command queue and initialize related registers:
CBASER, CREADR, CWRITER.

The command queue is 64kB. This aims at not bothing with fullness.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 lib/arm/asm/gic-v3-its.h |  7 +++++++
 lib/arm/gic-v3-its.c     | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
index 0d11aed..ed42707 100644
--- a/lib/arm/asm/gic-v3-its.h
+++ b/lib/arm/asm/gic-v3-its.h
@@ -113,10 +113,17 @@ struct its_baser {
 	int esz;
 };
 
+struct its_cmd_block {
+	u64     raw_cmd[4];
+};
+
 struct its_data {
 	void *base;
 	struct its_typer typer;
 	struct its_baser baser[GITS_BASER_NR_REGS];
+	struct its_cmd_block *cmd_base;
+	struct its_cmd_block *cmd_write;
+	struct its_cmd_block *cmd_readr;
 };
 
 extern struct its_data its_data;
diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
index 0b5a700..8b6a095 100644
--- a/lib/arm/gic-v3-its.c
+++ b/lib/arm/gic-v3-its.c
@@ -188,3 +188,40 @@ void set_pending_table_bit(int rdist, int n, bool set)
 		byte &= ~mask;
 	*ptr = byte;
 }
+
+/**
+ * init_cmd_queue: Allocate the command queue and initialize
+ * CBASER, CREADR, CWRITER
+ */
+void init_cmd_queue(void);
+void init_cmd_queue(void)
+{
+	unsigned long n = SZ_64K >> PAGE_SHIFT;
+	unsigned long order = fls(n);
+	u64 cbaser, tmp;
+
+	its_data.cmd_base = (void *)virt_to_phys(alloc_pages(order));
+
+	cbaser = ((u64)its_data.cmd_base	|
+		 GITS_CBASER_WaWb               |
+		 GITS_CBASER_InnerShareable     |
+		 (SZ_64K / SZ_4K - 1) |
+		 GITS_CBASER_VALID);
+
+	writeq(cbaser, its_data.base + GITS_CBASER);
+	tmp = readq(its_data.base + GITS_CBASER);
+
+	if ((tmp ^ cbaser) & GITS_CBASER_SHAREABILITY_MASK) {
+		if (!(tmp & GITS_CBASER_SHAREABILITY_MASK)) {
+			cbaser &= ~(GITS_CBASER_SHAREABILITY_MASK |
+				GITS_CBASER_CACHEABILITY_MASK);
+			cbaser |= GITS_CBASER_nC;
+			writeq(cbaser, its_data.base + GITS_CBASER);
+		}
+	}
+
+	its_data.cmd_write = its_data.cmd_base;
+	its_data.cmd_readr = its_data.cmd_base;
+	writeq(0, its_data.base + GITS_CWRITER);
+	writeq(0, its_data.base + GITS_CREADR);
+}
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
