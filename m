Return-Path: <SRS0=dc8k=5U=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AD96C2BA1B
	for <kvmarm@archiver.kernel.org>; Sat,  4 Apr 2020 14:38:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 44AE02070E
	for <kvmarm@archiver.kernel.org>; Sat,  4 Apr 2020 14:38:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S9MI/xsa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 44AE02070E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F30C44B224;
	Sat,  4 Apr 2020 10:38:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sS98AMMv8BtK; Sat,  4 Apr 2020 10:38:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ECA054B1AC;
	Sat,  4 Apr 2020 10:38:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D5A44B10A
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Apr 2020 10:38:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RM7L9JZohD49 for <kvmarm@lists.cs.columbia.edu>;
 Sat,  4 Apr 2020 10:38:13 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 58B7B4B16A
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Apr 2020 10:38:13 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1586011093;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=E3BV988DpZ1VkA4WWHvhl1mOj9xBGw7xFZ3+tYvTVds=;
 b=S9MI/xsa57I40PBws6/T2pPZaR6+y4UzpnHZJa/+70VfEqZzeaOah3eKnxrJYr80aCR9VU
 2GI4kW2bnOG6mZdIgtfSgnWx6FEo5vSNQjVhqWRzwB94Nj86a/zMRsiIKhj/+anWLPRDAW
 H5jCht67wCVWgyg4RNAuweUQGeIkpC4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-T2IZTTFqOt2WcY50aea6BQ-1; Sat, 04 Apr 2020 10:38:10 -0400
X-MC-Unique: T2IZTTFqOt2WcY50aea6BQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3BAF18AB2C0;
 Sat,  4 Apr 2020 14:38:09 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
 by smtp.corp.redhat.com (Postfix) with ESMTP id C67F69B912;
 Sat,  4 Apr 2020 14:38:07 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: pbonzini@redhat.com
Subject: [PULL kvm-unit-tests 12/39] arm64: timer: Use the proper RDist
 register name in GICv3
Date: Sat,  4 Apr 2020 16:37:04 +0200
Message-Id: <20200404143731.208138-13-drjones@redhat.com>
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

From: Zenghui Yu <yuzenghui@huawei.com>

We're actually going to read GICR_ISACTIVER0 and GICR_ISPENDR0 (in
SGI_base frame of the redistribitor) to get the active/pending state
of the timer interrupt.  Fix this typo.

And since they have the same value, there's no functional change.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/timer.c          | 4 ++--
 lib/arm/asm/gic-v3.h | 4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index 94543f231ba9..10a88f3f1d19 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -351,8 +351,8 @@ static void test_init(void)
 		gic_icenabler = gicv2_dist_base() + GICD_ICENABLER;
 		break;
 	case 3:
-		gic_isactiver = gicv3_sgi_base() + GICD_ISACTIVER;
-		gic_ispendr = gicv3_sgi_base() + GICD_ISPENDR;
+		gic_isactiver = gicv3_sgi_base() + GICR_ISACTIVER0;
+		gic_ispendr = gicv3_sgi_base() + GICR_ISPENDR0;
 		gic_isenabler = gicv3_sgi_base() + GICR_ISENABLER0;
 		gic_icenabler = gicv3_sgi_base() + GICR_ICENABLER0;
 		break;
diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index 0dc838b3ab2d..e2736a12b319 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -32,6 +32,10 @@
 #define GICR_IGROUPR0			GICD_IGROUPR
 #define GICR_ISENABLER0			GICD_ISENABLER
 #define GICR_ICENABLER0			GICD_ICENABLER
+#define GICR_ISPENDR0			GICD_ISPENDR
+#define GICR_ICPENDR0			GICD_ICPENDR
+#define GICR_ISACTIVER0			GICD_ISACTIVER
+#define GICR_ICACTIVER0			GICD_ICACTIVER
 #define GICR_IPRIORITYR0		GICD_IPRIORITYR
 
 #define ICC_SGI1R_AFFINITY_1_SHIFT	16
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
