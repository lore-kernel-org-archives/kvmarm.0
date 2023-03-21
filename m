Received: from out-8.mta0.migadu.com (out-8.mta0.migadu.com [91.218.175.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49039440
	for <kvmarm@lists.linux.dev>; Tue, 21 Mar 2023 12:13:28 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1679400806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=W8avJLFib3sdsj9e8Eeoams20ysVm7oUzXRXZTHIjjw=;
	b=XxJrLfW4fGCijJKOoIjCsd8QA36c4I/nw177R02xL1V9RMxwiMcCT1HI92YCp15a5Eg3co
	oTHHA9QHZ/IUbejd3hMwWeOFoSM7obmxFzLxutAMwxm4mvisbKAulzk/mofSxUuvLqHWHV
	iFIW2dWX4lBO48Ml358T1scG1Yl6eas=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [kvm-unit-tests PATCH] arm/pl031: Apply gic_enable_irq
Date: Tue, 21 Mar 2023 13:13:25 +0100
Message-Id: <20230321121325.755595-1-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use gic_enable_irq() to clean up code.

Suggested-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 arm/pl031.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/arm/pl031.c b/arm/pl031.c
index 452fe0f3e36c..c56805e402a0 100644
--- a/arm/pl031.c
+++ b/arm/pl031.c
@@ -47,7 +47,6 @@ static u32 cntfrq;
 static struct pl031_regs *pl031;
 static int pl031_irq;
 static void *gic_ispendr;
-static void *gic_isenabler;
 static volatile bool irq_triggered;
 
 static int check_id(void)
@@ -125,13 +124,6 @@ static bool gic_irq_pending(void)
 	return readl(gic_ispendr + offset) & (1 << (pl031_irq & 31));
 }
 
-static void gic_irq_unmask(void)
-{
-	uint32_t offset = (pl031_irq / 32) * 4;
-
-	writel(1 << (pl031_irq & 31), gic_isenabler + offset);
-}
-
 static void irq_handler(struct pt_regs *regs)
 {
 	u32 irqstat = gic_read_iar();
@@ -185,7 +177,7 @@ static int check_rtc_irq(void)
 	report(gic_irq_pending(), "  RTC IRQ pending now");
 
 	/* Enable retrieval of IRQ */
-	gic_irq_unmask();
+	gic_enable_irq(pl031_irq);
 	local_irq_enable();
 
 	report(irq_triggered, "  IRQ triggered");
@@ -208,11 +200,9 @@ static void rtc_irq_init(void)
 	switch (gic_version()) {
 	case 2:
 		gic_ispendr = gicv2_dist_base() + GICD_ISPENDR;
-		gic_isenabler = gicv2_dist_base() + GICD_ISENABLER;
 		break;
 	case 3:
 		gic_ispendr = gicv3_dist_base() + GICD_ISPENDR;
-		gic_isenabler = gicv3_dist_base() + GICD_ISENABLER;
 		break;
 	}
 }
-- 
2.39.2

