Return-Path: <SRS0=fmje=ZA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12C83FA372C
	for <kvmarm@archiver.kernel.org>; Fri,  8 Nov 2019 14:43:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C54BC2247A
	for <kvmarm@archiver.kernel.org>; Fri,  8 Nov 2019 14:43:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C54BC2247A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C5B44AF0A;
	Fri,  8 Nov 2019 09:43:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zgwcjKht4vvv; Fri,  8 Nov 2019 09:43:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C7174AEE4;
	Fri,  8 Nov 2019 09:43:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 300604AC70
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Nov 2019 09:43:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Lxv+J-nHZGYJ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Nov 2019 09:43:04 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AEBC4AECA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Nov 2019 09:43:04 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DA65346A;
 Fri,  8 Nov 2019 06:43:03 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BD1F73F719;
 Fri,  8 Nov 2019 06:43:02 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Andrew Jones <drjones@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 10/17] arm: gic: Check for writable IGROUPR
 registers
Date: Fri,  8 Nov 2019 14:42:33 +0000
Message-Id: <20191108144240.204202-11-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191108144240.204202-1-andre.przywara@arm.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

When both groups are avaiable to the non-secure side, the MMIO group
registers need to be writable, so that the group that an IRQ belongs to
can be programmed.

Check that the group can be flipped, after having established that both
groups are usable.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arm/gic.c b/arm/gic.c
index c882a24..485ca4f 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -683,6 +683,7 @@ static bool gicv3_check_security(void *gicd_base)
 static void test_irq_group(void *gicd_base)
 {
 	bool is_gicv3 = (gic_version() == 3);
+	u32 reg;
 
 	report_prefix_push("GROUP");
 	gic_enable_defaults();
@@ -692,6 +693,16 @@ static void test_irq_group(void *gicd_base)
 		if (!gicv3_check_security(gicd_base))
 			return;
 	}
+
+	/*
+	 * On a security aware GIC in non-secure world the IGROUPR registers
+	 * are RAZ/WI. KVM emulates a single-security-state GIC, so both
+	 * groups are available and the IGROUPR registers are writable.
+	 */
+	reg = gic_get_irq_group(SPI_IRQ);
+	gic_set_irq_group(SPI_IRQ, !reg);
+	report("IGROUPR is writable", gic_get_irq_group(SPI_IRQ) != reg);
+	gic_set_irq_group(SPI_IRQ, reg);
 }
 
 static void spi_send(void)
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
