Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D97F1851
	for <kvmarm@lists.linux.dev>; Fri,  3 Mar 2023 03:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677813152;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ncKHv1h1opO4DA5kxu6YhoDiEOVtPQycDQ/UhO4F0qc=;
	b=XIk/ILVwzcji3ocsagl9f10cBfqnVkU6an3In0hvChA/BEbiB+jE+3FUT4T2VOgdcn2e0X
	YlBuEUbn89jw1DEtpjG/9kML3tDS8hoW8O9N9tmrGYngyxBo8bekU2neVQj4VQsog9YGSl
	UjivJH/IQiAJh0N90JLnR9sJv1w2ok0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-116-e2nKKxRJMJmBTJN0Ujc7dQ-1; Thu, 02 Mar 2023 22:12:28 -0500
X-MC-Unique: e2nKKxRJMJmBTJN0Ujc7dQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 24D3D101A521;
	Fri,  3 Mar 2023 03:12:28 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1956C492C3E;
	Fri,  3 Mar 2023 03:12:28 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: kvmarm@lists.linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	kvm@vger.kernel.org (open list:ARM)
Subject: [kvm-unit-tests PATCH v3 3/3] arm64: microbench: Use gic_enable_irq() macro in microbench test
Date: Thu,  2 Mar 2023 22:11:47 -0500
Message-Id: <20230303031148.162816-4-shahuang@redhat.com>
In-Reply-To: <20230303031148.162816-1-shahuang@redhat.com>
References: <20230303031148.162816-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10

Use gic_enable_irq() to clean up code.

Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 arm/micro-bench.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index 8436612..090fda6 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -212,24 +212,11 @@ static void lpi_exec(void)
 
 static bool timer_prep(void)
 {
-	void *gic_isenabler;
-
 	gic_enable_defaults();
 	install_irq_handler(EL1H_IRQ, gic_irq_handler);
 	local_irq_enable();
 
-	switch (gic_version()) {
-	case 2:
-		gic_isenabler = gicv2_dist_base() + GICD_ISENABLER;
-		break;
-	case 3:
-		gic_isenabler = gicv3_sgi_base() + GICR_ISENABLER0;
-		break;
-	default:
-		assert_msg(0, "Unreachable");
-	}
-
-	writel(1 << PPI(TIMER_VTIMER_IRQ), gic_isenabler);
+	gic_enable_irq(PPI(TIMER_VTIMER_IRQ));
 	write_sysreg(ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
 	isb();
 
-- 
2.39.1

