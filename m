Return-Path: <SRS0=H5Sr=3R=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16659C33C9E
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jan 2020 10:36:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9ED1124681
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jan 2020 10:36:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y8wufg16"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9ED1124681
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 305794A94D;
	Tue, 28 Jan 2020 05:36:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eKcIRbUGnFzL; Tue, 28 Jan 2020 05:36:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 33A924A830;
	Tue, 28 Jan 2020 05:36:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 191DD4A5BD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jan 2020 05:36:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ffSt4re+Y4nu for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jan 2020 05:36:22 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB2E44AC70
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jan 2020 05:36:21 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1580207781;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=78G0omYBZtnhpn3J/dduj+Q41/b0ahCr4I2teh8jw18=;
 b=Y8wufg168fsx2zz69IBuywVl65yAc3CR4GfPfE6tpMgYpRGUdGemsjNtMuZl8YvVugyWbM
 9gZhEfUZd1PyVnqaWPi9Y1wStYRO1iVgp5zXCq3s5o4KMW/5WU1Hb9ztxAboU0PgrqzRhJ
 gNXcTk6u849euCuhUVo0eXbyBcj6Ip4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-QHcEkjAAPcSg6VQP7dxRFA-1; Tue, 28 Jan 2020 05:36:07 -0500
X-MC-Unique: QHcEkjAAPcSg6VQP7dxRFA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB695107ACC4;
 Tue, 28 Jan 2020 10:36:05 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-37.ams2.redhat.com [10.36.116.37])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 50F401001DD8;
 Tue, 28 Jan 2020 10:35:58 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [kvm-unit-tests PATCH v3 07/14] arm/arm64: gicv3: Enable/Disable LPIs
 at re-distributor level
Date: Tue, 28 Jan 2020 11:34:52 +0100
Message-Id: <20200128103459.19413-8-eric.auger@redhat.com>
In-Reply-To: <20200128103459.19413-1-eric.auger@redhat.com>
References: <20200128103459.19413-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

This helper function controls the signaling of LPIs at
redistributor level.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v2 -> v3:
- move the helper in lib/arm/gic-v3.c
- rename the function with gicv3_lpi_ prefix
- s/report_abort/assert
---
 lib/arm/asm/gic-v3.h |  1 +
 lib/arm/gic-v3.c     | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index ec2a6f0..734c0c0 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -96,6 +96,7 @@ extern void gicv3_lpi_set_config(int n, u8 val);
 extern u8 gicv3_lpi_get_config(int n);
 extern void gicv3_lpi_set_pending_table_bit(int rdist, int n, bool set);
 extern void gicv3_lpi_alloc_tables(void);
+extern void gicv3_lpi_rdist_ctrl(u32 redist, bool set);
 
 static inline void gicv3_do_wait_for_rwp(void *base)
 {
diff --git a/lib/arm/gic-v3.c b/lib/arm/gic-v3.c
index c33f883..7865d01 100644
--- a/lib/arm/gic-v3.c
+++ b/lib/arm/gic-v3.c
@@ -210,4 +210,21 @@ void gicv3_lpi_set_pending_table_bit(int rdist, int n, bool set)
 		byte &= ~mask;
 	*ptr = byte;
 }
+
+void gicv3_lpi_rdist_ctrl(u32 redist, bool set)
+{
+	void *ptr;
+	u64 val;
+
+	assert(redist < nr_cpus);
+
+	ptr = gicv3_data.redist_base[redist];
+	val = readl(ptr + GICR_CTLR);
+	if (set)
+		val |= GICR_CTLR_ENABLE_LPIS;
+	else
+		val &= ~GICR_CTLR_ENABLE_LPIS;
+	writel(val,  ptr + GICR_CTLR);
+}
 #endif /* __aarch64__ */
+
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
