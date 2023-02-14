Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F25523D9
	for <kvmarm@lists.linux.dev>; Tue, 14 Feb 2023 03:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676346315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zbfo96JRTocyXswA9WhCCrgwff+hUp+2pthDFDIBBTE=;
	b=HHSIkacCHVQvUIPB8xI8xOESQoVQPgRFUVt61MU5Rl9iLLO351U8qbJVvYE4Ksl5YJklde
	/fuQWjS3fyQfv1tSVUzHUExshXxNulTxBv/vM4aBu5DBmeZtHnp64rr2iRPLBWMrksnT4Y
	5cus41iUc5xM00DAg5xeUHfUJo8bxvM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-UA6rUb3-N4Kf1Zr6-ViHrg-1; Mon, 13 Feb 2023 22:45:11 -0500
X-MC-Unique: UA6rUb3-N4Kf1Zr6-ViHrg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E7F3381078B;
	Tue, 14 Feb 2023 03:45:11 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 793F2C16022;
	Tue, 14 Feb 2023 03:45:11 +0000 (UTC)
From: shahuang@redhat.com
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests 2/3] arm64: timer: Use gic_enable/disable_irq() macro in timer test
Date: Mon, 13 Feb 2023 22:44:52 -0500
Message-Id: <20230214034453.148494-3-shahuang@redhat.com>
In-Reply-To: <20230214034453.148494-1-shahuang@redhat.com>
References: <20230214034453.148494-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8

From: Shaoqin Huang <shahuang@redhat.com>

Use gic_enable/disable_irq() to clean up the code.

Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 arm/timer.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index c4e7b10..c0a8388 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -14,9 +14,6 @@
 #include <asm/gic.h>
 #include <asm/io.h>
 
-static void *gic_isenabler;
-static void *gic_icenabler;
-
 static bool ptimer_unsupported;
 
 static void ptimer_unsupported_handler(struct pt_regs *regs, unsigned int esr)
@@ -139,12 +136,12 @@ static struct timer_info ptimer_info = {
 
 static void set_timer_irq_enabled(struct timer_info *info, bool enabled)
 {
-	u32 val = 1 << PPI(info->irq);
+	u32 irq = PPI(info->irq);
 
 	if (enabled)
-		writel(val, gic_isenabler);
+		gic_enable_irq(irq);
 	else
-		writel(val, gic_icenabler);
+		gic_disable_irq(irq);
 }
 
 static void irq_handler(struct pt_regs *regs)
@@ -366,17 +363,6 @@ static void test_init(void)
 
 	gic_enable_defaults();
 
-	switch (gic_version()) {
-	case 2:
-		gic_isenabler = gicv2_dist_base() + GICD_ISENABLER;
-		gic_icenabler = gicv2_dist_base() + GICD_ICENABLER;
-		break;
-	case 3:
-		gic_isenabler = gicv3_sgi_base() + GICR_ISENABLER0;
-		gic_icenabler = gicv3_sgi_base() + GICR_ICENABLER0;
-		break;
-	}
-
 	install_irq_handler(EL1H_IRQ, irq_handler);
 	set_timer_irq_enabled(&ptimer_info, true);
 	set_timer_irq_enabled(&vtimer_info, true);
-- 
2.39.1

