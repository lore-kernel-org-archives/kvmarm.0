Return-Path: <SRS0=XaYj=37=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65DD7C3B188
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 08:40:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 293D920848
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 08:40:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 293D920848
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B23B54AE9A;
	Tue, 11 Feb 2020 03:40:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Et879zSkvcSt; Tue, 11 Feb 2020 03:40:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 783864AE8E;
	Tue, 11 Feb 2020 03:40:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7D534A542
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 03:40:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vmQJASQOcs86 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Feb 2020 03:40:44 -0500 (EST)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 79F3A4A7D9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 03:40:44 -0500 (EST)
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 8259A53757EA3401812D;
 Tue, 11 Feb 2020 16:40:40 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.173.222.27) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Tue, 11 Feb 2020 16:40:33 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <drjones@redhat.com>, <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>
Subject: [kvm-unit-tests PATCH 1/3] arm/arm64: gic: Move gic_state enumeration
 to asm/gic.h
Date: Tue, 11 Feb 2020 16:38:59 +0800
Message-ID: <20200211083901.1478-2-yuzenghui@huawei.com>
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

The status of each interrupt are defined by the GIC architecture and
maintained by GIC hardware.  They're not specified to the timer HW.
Let's move this software enumeration to a more proper place.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 arm/timer.c       | 7 -------
 lib/arm/asm/gic.h | 7 +++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index dea364f..94543f2 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -17,13 +17,6 @@
 #define ARCH_TIMER_CTL_IMASK   (1 << 1)
 #define ARCH_TIMER_CTL_ISTATUS (1 << 2)
 
-enum gic_state {
-	GIC_STATE_INACTIVE,
-	GIC_STATE_PENDING,
-	GIC_STATE_ACTIVE,
-	GIC_STATE_ACTIVE_PENDING,
-};
-
 static void *gic_isactiver;
 static void *gic_ispendr;
 static void *gic_isenabler;
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index 09826fd..a72e0cd 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -47,6 +47,13 @@
 #ifndef __ASSEMBLY__
 #include <asm/cpumask.h>
 
+enum gic_state {
+	GIC_STATE_INACTIVE,
+	GIC_STATE_PENDING,
+	GIC_STATE_ACTIVE,
+	GIC_STATE_ACTIVE_PENDING,
+};
+
 /*
  * gic_init will try to find all known gics, and then
  * initialize the gic data for the one found.
-- 
2.19.1


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
