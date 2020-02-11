Return-Path: <SRS0=XaYj=37=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9239CC352A3
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 08:40:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 263B1206CC
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 08:40:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 263B1206CC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7756E4AE99;
	Tue, 11 Feb 2020 03:40:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id URgeANvBlmlk; Tue, 11 Feb 2020 03:40:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BA1F4ACF2;
	Tue, 11 Feb 2020 03:40:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79D114A946
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 03:40:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 83i49AM1KxHR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Feb 2020 03:40:44 -0500 (EST)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E61014A542
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 03:40:43 -0500 (EST)
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 7E00E77A104706A55F6E;
 Tue, 11 Feb 2020 16:40:40 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.173.222.27) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Tue, 11 Feb 2020 16:40:34 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <drjones@redhat.com>, <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>
Subject: [kvm-unit-tests PATCH 2/3] arm64: timer: Use the proper RDist
 register name in GICv3
Date: Tue, 11 Feb 2020 16:39:00 +0800
Message-ID: <20200211083901.1478-3-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
In-Reply-To: <20200211083901.1478-1-yuzenghui@huawei.com>
References: <20200211083901.1478-1-yuzenghui@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
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

We're actually going to read GICR_ISACTIVER0 and GICR_ISPENDR0 (in
SGI_base frame of the redistribitor) to get the active/pending state
of the timer interrupt.  Fix this typo.

And since they have the same value, there's no functional change.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 arm/timer.c          | 4 ++--
 lib/arm/asm/gic-v3.h | 4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index 94543f2..10a88f3 100644
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
index 0dc838b..e2736a1 100644
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
2.19.1


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
