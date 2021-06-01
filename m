Return-Path: <SRS0=w8eh=K3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C9BAC47093
	for <kvmarm@archiver.kernel.org>; Tue,  1 Jun 2021 10:40:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D59F660FEE
	for <kvmarm@archiver.kernel.org>; Tue,  1 Jun 2021 10:40:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D59F660FEE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 881F64081C;
	Tue,  1 Jun 2021 06:40:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KOFZpMCjPijZ; Tue,  1 Jun 2021 06:40:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A1BA849D50;
	Tue,  1 Jun 2021 06:40:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69F7C40212
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Jun 2021 06:40:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ed3aJv-Zo50t for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Jun 2021 06:40:15 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3636A4081C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Jun 2021 06:40:15 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4B4D8613AF;
 Tue,  1 Jun 2021 10:40:14 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1lo1oi-004nNs-JJ; Tue, 01 Jun 2021 11:40:12 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 3/9] KVM: arm64: vgic: Be tolerant to the lack of
 maintenance interrupt masking
Date: Tue,  1 Jun 2021 11:39:59 +0100
Message-Id: <20210601104005.81332-4-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210601104005.81332-1-maz@kernel.org>
References: <20210601104005.81332-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, eric.auger@redhat.com, marcan@marcan.st,
 mark.rutland@arm.com, yuzenghui@huawei.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Hector Martin <marcan@marcan.st>
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

As it turns out, not all the interrupt controllers are able to
expose a vGIC maintenance interrupt that can be independently
enabled/disabled.

And to be fair, it doesn't really matter as all we require is
for the interrupt to kick us out of guest mode out way or another.

To that effect, add gic_kvm_info.no_maint_irq_mask for an interrupt
controller to advertise the lack of masking.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-init.c       | 8 +++++++-
 include/linux/irqchip/arm-vgic-info.h | 2 ++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 2fdb65529594..6752d084934d 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -519,12 +519,15 @@ void kvm_vgic_init_cpu_hardware(void)
  */
 int kvm_vgic_hyp_init(void)
 {
+	bool has_mask;
 	int ret;
 
 	if (!gic_kvm_info)
 		return -ENODEV;
 
-	if (!gic_kvm_info->maint_irq) {
+	has_mask = !gic_kvm_info->no_maint_irq_mask;
+
+	if (has_mask && !gic_kvm_info->maint_irq) {
 		kvm_err("No vgic maintenance irq\n");
 		return -ENXIO;
 	}
@@ -552,6 +555,9 @@ int kvm_vgic_hyp_init(void)
 	if (ret)
 		return ret;
 
+	if (!has_mask)
+		return 0;
+
 	ret = request_percpu_irq(kvm_vgic_global_state.maint_irq,
 				 vgic_maintenance_handler,
 				 "vgic", kvm_get_running_vcpus());
diff --git a/include/linux/irqchip/arm-vgic-info.h b/include/linux/irqchip/arm-vgic-info.h
index a25d4da5697d..7c0d08ebb82c 100644
--- a/include/linux/irqchip/arm-vgic-info.h
+++ b/include/linux/irqchip/arm-vgic-info.h
@@ -24,6 +24,8 @@ struct gic_kvm_info {
 	struct resource vcpu;
 	/* Interrupt number */
 	unsigned int	maint_irq;
+	/* No interrupt mask, no need to use the above field */
+	bool		no_maint_irq_mask;
 	/* Virtual control interface */
 	struct resource vctrl;
 	/* vlpi support */
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
