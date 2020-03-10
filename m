Return-Path: <SRS0=Utlv=43=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D080C18E5A
	for <kvmarm@archiver.kernel.org>; Tue, 10 Mar 2020 14:54:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C884A205F4
	for <kvmarm@archiver.kernel.org>; Tue, 10 Mar 2020 14:54:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QNsjpzfg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C884A205F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BF554A65C;
	Tue, 10 Mar 2020 10:54:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jyzRpW6YcAGQ; Tue, 10 Mar 2020 10:54:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 72F704A536;
	Tue, 10 Mar 2020 10:54:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87F1B4A4AA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Mar 2020 10:54:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TaDtdPdlEfIt for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Mar 2020 10:54:45 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60D6A4A389
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Mar 2020 10:54:45 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1583852085;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=HV5vvbw31wyEYrQ32o2dc0uwSfN4maLDv7794Qu4y+I=;
 b=QNsjpzfgVn23dHGGUaTiWq3ssrBqTuU8Lqm0O7KCTjV/7Y9mWK+AusOXiyeMtaFgJaC32z
 GjyGhno7ynp9uKSC4wpypjzRUvDfl28TysVKFAeEiIij2hglbGxI/AcpmZw3oy4ZuXaOJX
 n3VVNPeGoNvqjwZWOzNaVxCU753voWU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-nQoaXeRJPViRToH7SNk9rg-1; Tue, 10 Mar 2020 10:54:41 -0400
X-MC-Unique: nQoaXeRJPViRToH7SNk9rg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D61D1107ACC7;
 Tue, 10 Mar 2020 14:54:39 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-117-85.ams2.redhat.com [10.36.117.85])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 95A176106B;
 Tue, 10 Mar 2020 14:54:33 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [kvm-unit-tests PATCH v5 04/13] arm/arm64: gicv3: Add some
 re-distributor defines
Date: Tue, 10 Mar 2020 15:54:01 +0100
Message-Id: <20200310145410.26308-5-eric.auger@redhat.com>
In-Reply-To: <20200310145410.26308-1-eric.auger@redhat.com>
References: <20200310145410.26308-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

PROPBASER, PENDBASE and GICR_CTRL will be used for LPI management.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

---

v3 -> v4:
- replace some spaces by tabs and added Zenghui's R-b
---
 lib/arm/asm/gic-v3.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index e2736a1..47df051 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -18,6 +18,7 @@
  * We expect to be run in Non-secure mode, thus we define the
  * group1 enable bits with respect to that view.
  */
+#define GICD_CTLR			0x0000
 #define GICD_CTLR_RWP			(1U << 31)
 #define GICD_CTLR_ARE_NS		(1U << 4)
 #define GICD_CTLR_ENABLE_G1A		(1U << 1)
@@ -38,6 +39,11 @@
 #define GICR_ICACTIVER0			GICD_ICACTIVER
 #define GICR_IPRIORITYR0		GICD_IPRIORITYR
 
+#define GICR_PROPBASER			0x0070
+#define GICR_PENDBASER			0x0078
+#define GICR_CTLR			GICD_CTLR
+#define GICR_CTLR_ENABLE_LPIS		(1UL << 0)
+
 #define ICC_SGI1R_AFFINITY_1_SHIFT	16
 #define ICC_SGI1R_AFFINITY_2_SHIFT	32
 #define ICC_SGI1R_AFFINITY_3_SHIFT	48
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
