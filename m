Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A10B5C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  5 Apr 2022 18:23:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0019B4B0BD;
	Tue,  5 Apr 2022 14:23:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id m8snLBpCRyHG; Tue,  5 Apr 2022 14:23:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A38344B137;
	Tue,  5 Apr 2022 14:23:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C849F4B11F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Apr 2022 14:23:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zmUNhG7pp9Ic for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Apr 2022 14:23:47 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D15C44B108
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Apr 2022 14:23:47 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 2B4B4618D9;
 Tue,  5 Apr 2022 18:23:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87CF8C385A5;
 Tue,  5 Apr 2022 18:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1649183026;
 bh=v+twvuAPSyK4b9502wrkUr1BlR4MnKo9qztL8KChOdc=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=LLOYj5k6GyvTyNAdNZj0c6Gle/yFS2W70/CxyQAwxEKjeHO9G0Nxdx5hzSUYFC4PM
 Kadz63LpDnQ5oM/9t9hvcMAjfv4CLhXlVgpMSSwVfh2CL0IToZLvmVdp3nd+lpeV64
 UCvN9RKEZfpk1IcUU+iRxrlIiQ4FJPzR9shGO9eJeZMT9zR0nCeM5VHRGowxdMAblC
 IJkHzPqBropv5/71J1gekb4shabq6Vg2UVuK6uZDS5S1yXsPU3njK9Do0WWG+3KByW
 hp9sGtYYUKHhcH+rhpZY7xOlOYEaVq3CN2asYacwKGXGMBOXtu/nyGydLTKOykTnYo
 gtlipFrkCYFig==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nbnqC-001tdH-4e; Tue, 05 Apr 2022 19:23:44 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 1/4] irqchip/gic-v3: Exposes bit values for GICR_CTLR.{IR,
 CES}
Date: Tue,  5 Apr 2022 19:23:24 +0100
Message-Id: <20220405182327.205520-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220405182327.205520-1-maz@kernel.org>
References: <20220405182327.205520-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, andre.przywara@arm.com, eric.auger@redhat.com,
 oupton@google.com, lorenzo.pieralisi@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andre Przywara <andre.przywara@arm.com>, kernel-team@android.com
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

As we're about to expose GICR_CTLR.{IR,CES} to guests, populate
the include file with the architectural values.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 include/linux/irqchip/arm-gic-v3.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 12d91f0dedf9..728691365464 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -127,6 +127,8 @@
 #define GICR_PIDR2			GICD_PIDR2
 
 #define GICR_CTLR_ENABLE_LPIS		(1UL << 0)
+#define GICR_CTLR_CES			(1UL << 1)
+#define GICR_CTLR_IR			(1UL << 2)
 #define GICR_CTLR_RWP			(1UL << 3)
 
 #define GICR_TYPER_CPU_NUMBER(r)	(((r) >> 8) & 0xffff)
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
