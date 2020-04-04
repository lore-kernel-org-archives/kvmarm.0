Return-Path: <SRS0=dc8k=5U=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66902C2BA15
	for <kvmarm@archiver.kernel.org>; Sat,  4 Apr 2020 14:38:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1B2B6206F5
	for <kvmarm@archiver.kernel.org>; Sat,  4 Apr 2020 14:38:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FJEcvjRC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B2B6206F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C9D694B16A;
	Sat,  4 Apr 2020 10:38:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id j-IQVz-7buxr; Sat,  4 Apr 2020 10:38:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA3DF4B10A;
	Sat,  4 Apr 2020 10:38:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23C2D4B0CF
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Apr 2020 10:38:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kNlOjFG25ftB for <kvmarm@lists.cs.columbia.edu>;
 Sat,  4 Apr 2020 10:38:11 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E94984B1AA
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Apr 2020 10:38:10 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1586011090;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=HJXgouF5hnW6c32QC5HW05D5OVof60jHODwykFGab7c=;
 b=FJEcvjRC3G/OSI/OrdjTEdAjCaoQYjzgxu8vTLxh7n7/fdnKokVJjjeYPRYclR/uVQ4nrZ
 WVvaW46L+jZlbNU07r4o6qGNgxI8vbbwlzN/8xLm/hSo7aOdZVCdKl+Cpg6UQYDSuqh/TL
 zPEfIO4ubS22z6RMgm269KPafFP3SLw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-vZ5SYYPXO0q_xL4SSS9zSg-1; Sat, 04 Apr 2020 10:38:08 -0400
X-MC-Unique: vZ5SYYPXO0q_xL4SSS9zSg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5085D107ACC7;
 Sat,  4 Apr 2020 14:38:07 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 660F51147D3;
 Sat,  4 Apr 2020 14:38:03 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: pbonzini@redhat.com
Subject: [PULL kvm-unit-tests 11/39] arm/arm64: gic: Move gic_state
 enumeration to asm/gic.h
Date: Sat,  4 Apr 2020 16:37:03 +0200
Message-Id: <20200404143731.208138-12-drjones@redhat.com>
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

The status of each interrupt are defined by the GIC architecture and
maintained by GIC hardware.  They're not specified to the timer HW.
Let's move this software enumeration to a more proper place.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/timer.c       | 7 -------
 lib/arm/asm/gic.h | 7 +++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index dea364f5355d..94543f231ba9 100644
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
index 09826fd5bc29..a72e0cde4e9c 100644
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
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
