Return-Path: <SRS0=NdW8=5F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D394FC41620
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 18:24:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8944220786
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 18:24:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="JQNTLw4J"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8944220786
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4242C4B0D5;
	Fri, 20 Mar 2020 14:24:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HXAWjdrrU1q7; Fri, 20 Mar 2020 14:24:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 48BA64B0D4;
	Fri, 20 Mar 2020 14:24:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBF964B0AC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 14:24:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x4EZ3psUqVZN for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Mar 2020 14:24:41 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 352F04B0C3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 14:24:40 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 51F9F20789;
 Fri, 20 Mar 2020 18:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1584728679;
 bh=BD9MJn5ZkhmmeJieQQ/G6s9Ba2ph4IWfpzL8AB0tUy4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=JQNTLw4J9oknjdw/E1FTv5Jay5DZiJq6JR75ChGSinO2zDVkmnLWUaBk/UGw9X3Jq
 hcVxEbPGBuym4QqehEcTtyFQ+4ndugKUAnnGc4tGJykIC7FRy4nmAwn+XxKVT50PQU
 zlFLRIfHPx4cmVbXWyisjaArPcGU6ujCeGsO+MU4=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jFMJx-00EKAx-HK; Fri, 20 Mar 2020 18:24:37 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 06/23] irqchip/gic-v4.1: Advertise support v4.1 to KVM
Date: Fri, 20 Mar 2020 18:23:49 +0000
Message-Id: <20200320182406.23465-7-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200320182406.23465-1-maz@kernel.org>
References: <20200320182406.23465-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net,
 tglx@linutronix.de, yuzenghui@huawei.com, eric.auger@redhat.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>
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

Tell KVM that we support v4.1. Nothing uses this information so far.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/20200304203330.4967-7-maz@kernel.org
---
 drivers/irqchip/irq-gic-v3-its.c       | 9 ++++++++-
 drivers/irqchip/irq-gic-v3.c           | 2 ++
 include/linux/irqchip/arm-gic-common.h | 2 ++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index fc5788584df7..bcc1a0957cda 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4870,6 +4870,7 @@ int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
 	struct device_node *of_node;
 	struct its_node *its;
 	bool has_v4 = false;
+	bool has_v4_1 = false;
 	int err;
 
 	gic_rdists = rdists;
@@ -4890,8 +4891,14 @@ int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
 	if (err)
 		return err;
 
-	list_for_each_entry(its, &its_nodes, entry)
+	list_for_each_entry(its, &its_nodes, entry) {
 		has_v4 |= is_v4(its);
+		has_v4_1 |= is_v4_1(its);
+	}
+
+	/* Don't bother with inconsistent systems */
+	if (WARN_ON(!has_v4_1 && rdists->has_rvpeid))
+		rdists->has_rvpeid = false;
 
 	if (has_v4 & rdists->has_vlpis) {
 		if (its_init_vpe_domain() ||
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 0f716c2647fd..8c5de59c5213 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -1764,6 +1764,7 @@ static void __init gic_of_setup_kvm_info(struct device_node *node)
 		gic_v3_kvm_info.vcpu = r;
 
 	gic_v3_kvm_info.has_v4 = gic_data.rdists.has_vlpis;
+	gic_v3_kvm_info.has_v4_1 = gic_data.rdists.has_rvpeid;
 	gic_set_kvm_info(&gic_v3_kvm_info);
 }
 
@@ -2079,6 +2080,7 @@ static void __init gic_acpi_setup_kvm_info(void)
 	}
 
 	gic_v3_kvm_info.has_v4 = gic_data.rdists.has_vlpis;
+	gic_v3_kvm_info.has_v4_1 = gic_data.rdists.has_rvpeid;
 	gic_set_kvm_info(&gic_v3_kvm_info);
 }
 
diff --git a/include/linux/irqchip/arm-gic-common.h b/include/linux/irqchip/arm-gic-common.h
index b9850f5f1906..fa8c0455c352 100644
--- a/include/linux/irqchip/arm-gic-common.h
+++ b/include/linux/irqchip/arm-gic-common.h
@@ -32,6 +32,8 @@ struct gic_kvm_info {
 	struct resource vctrl;
 	/* vlpi support */
 	bool		has_v4;
+	/* rvpeid support */
+	bool		has_v4_1;
 };
 
 const struct gic_kvm_info *gic_get_kvm_info(void);
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
