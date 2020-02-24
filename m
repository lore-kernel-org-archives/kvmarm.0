Return-Path: <SRS0=MUVm=4M=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B796C35677
	for <kvmarm@archiver.kernel.org>; Mon, 24 Feb 2020 02:51:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9E15F2187F
	for <kvmarm@archiver.kernel.org>; Mon, 24 Feb 2020 02:51:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E15F2187F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D8164B020;
	Sun, 23 Feb 2020 21:51:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ebFcLgsIUZO4; Sun, 23 Feb 2020 21:51:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F292B4AFF0;
	Sun, 23 Feb 2020 21:51:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC1184AFE7
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Feb 2020 21:51:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d+a-qKq18v3k for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Feb 2020 21:51:06 -0500 (EST)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C15C4AFA9
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Feb 2020 21:51:06 -0500 (EST)
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 08295B1E631B9B876FB6;
 Mon, 24 Feb 2020 10:51:01 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.173.222.27) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Mon, 24 Feb 2020 10:50:52 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <kvmarm@lists.cs.columbia.edu>, <maz@kernel.org>
Subject: [PATCH] irqchip/gic-v3-its: Clear Valid before writing any bits else
 in VPENDBASER
Date: Mon, 24 Feb 2020 10:50:29 +0800
Message-ID: <20200224025029.92-1-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: Yanlei Jia <jiayanlei@huawei.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
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

The Valid bit must be cleared before changing anything else when writing
GICR_VPENDBASER to avoid the UNPREDICTABLE behavior. This is exactly what
we've done on 32bit arm, but not on arm64.

This works fine on GICv4 where we only clear Valid for a vPE deschedule.
With the introduction of GICv4.1, we might also need to talk something else
(e.g., PendingLast, Doorbell) to the redistributor when clearing the Valid.
Let's port the 32bit gicr_write_vpendbaser() to arm64 so that hardware can
do the right thing after descheduling the vPE.

Cc: Yanlei Jia <jiayanlei@huawei.com>
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 arch/arm64/include/asm/arch_gicv3.h | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/arch_gicv3.h b/arch/arm64/include/asm/arch_gicv3.h
index 25fec4bde43a..effe66e1ca58 100644
--- a/arch/arm64/include/asm/arch_gicv3.h
+++ b/arch/arm64/include/asm/arch_gicv3.h
@@ -143,7 +143,18 @@ static inline u32 gic_read_rpr(void)
 #define gicr_write_vpropbaser(v, c)	writeq_relaxed(v, c)
 #define gicr_read_vpropbaser(c)		readq_relaxed(c)
 
-#define gicr_write_vpendbaser(v, c)	writeq_relaxed(v, c)
+#define gicr_write_vpendbaser(v, c) do {		\
+	u64 tmp = readq_relaxed(c);			\
+							\
+	/* Clear Valid before writing any bits else. */	\
+	if (tmp & GICR_VPENDBASER_Valid) {		\
+		tmp &= ~GICR_VPENDBASER_Valid;		\
+		writeq_relaxed(tmp, c);			\
+	}						\
+							\
+	writeq_relaxed(v, c);				\
+} while (0)
+
 #define gicr_read_vpendbaser(c)		readq_relaxed(c)
 
 static inline bool gic_prio_masking_enabled(void)
-- 
2.19.1


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
