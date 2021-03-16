Return-Path: <SRS0=Oq5u=IO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDD3CC433E6
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 17:46:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 85C4665127
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 17:46:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 85C4665127
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 398BD4B4C3;
	Tue, 16 Mar 2021 13:46:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Xd5xaig0mHYs; Tue, 16 Mar 2021 13:46:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C08DD4B504;
	Tue, 16 Mar 2021 13:46:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE06E4B483
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 13:46:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uok7dsh83CxB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Mar 2021 13:46:49 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 381E44B527
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 13:46:45 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6E58365131;
 Tue, 16 Mar 2021 17:46:44 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lMDmE-0021ao-O3; Tue, 16 Mar 2021 17:46:42 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH 07/11] KVM: arm64: timer: Refactor IRQ configuration
Date: Tue, 16 Mar 2021 17:46:12 +0000
Message-Id: <20210316174617.173033-8-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210316174617.173033-1-maz@kernel.org>
References: <20210316174617.173033-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, eric.auger@redhat.com, marcan@marcan.st,
 mark.rutland@arm.com, kernel-team@android.com
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

As we are about to add some more things to the timer IRQ
configuration, move this code out of the main timer init code
into its own set of functions.

No functional changes.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c | 61 ++++++++++++++++++++++---------------
 1 file changed, 37 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index e2288b6bf435..7fa4f446456a 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -973,6 +973,39 @@ static int kvm_timer_dying_cpu(unsigned int cpu)
 	return 0;
 }
 
+static void kvm_irq_fixup_flags(unsigned int virq, u32 *flags)
+{
+	*flags = irq_get_trigger_type(virq);
+	if (*flags != IRQF_TRIGGER_HIGH && *flags != IRQF_TRIGGER_LOW) {
+		kvm_err("Invalid trigger for timer IRQ%d, assuming level low\n",
+			virq);
+		*flags = IRQF_TRIGGER_LOW;
+	}
+}
+
+static int kvm_irq_init(struct arch_timer_kvm_info *info)
+{
+	struct irq_domain *domain = NULL;
+	struct fwnode_handle *fwnode;
+	struct irq_data *data;
+
+	if (info->virtual_irq <= 0) {
+		kvm_err("kvm_arch_timer: invalid virtual timer IRQ: %d\n",
+			info->virtual_irq);
+		return -ENODEV;
+	}
+
+	host_vtimer_irq = info->virtual_irq;
+	kvm_irq_fixup_flags(host_vtimer_irq, &host_vtimer_irq_flags);
+
+	if (info->physical_irq > 0) {
+		host_ptimer_irq = info->physical_irq;
+		kvm_irq_fixup_flags(host_ptimer_irq, &host_ptimer_irq_flags);
+	}
+
+	return 0;
+}
+
 int kvm_timer_hyp_init(bool has_gic)
 {
 	struct arch_timer_kvm_info *info;
@@ -986,22 +1019,11 @@ int kvm_timer_hyp_init(bool has_gic)
 		return -ENODEV;
 	}
 
-	/* First, do the virtual EL1 timer irq */
-
-	if (info->virtual_irq <= 0) {
-		kvm_err("kvm_arch_timer: invalid virtual timer IRQ: %d\n",
-			info->virtual_irq);
-		return -ENODEV;
-	}
-	host_vtimer_irq = info->virtual_irq;
+	err = kvm_irq_init(info);
+	if (err)
+		return err;
 
-	host_vtimer_irq_flags = irq_get_trigger_type(host_vtimer_irq);
-	if (host_vtimer_irq_flags != IRQF_TRIGGER_HIGH &&
-	    host_vtimer_irq_flags != IRQF_TRIGGER_LOW) {
-		kvm_err("Invalid trigger for vtimer IRQ%d, assuming level low\n",
-			host_vtimer_irq);
-		host_vtimer_irq_flags = IRQF_TRIGGER_LOW;
-	}
+	/* First, do the virtual EL1 timer irq */
 
 	err = request_percpu_irq(host_vtimer_irq, kvm_arch_timer_handler,
 				 "kvm guest vtimer", kvm_get_running_vcpus());
@@ -1027,15 +1049,6 @@ int kvm_timer_hyp_init(bool has_gic)
 	/* Now let's do the physical EL1 timer irq */
 
 	if (info->physical_irq > 0) {
-		host_ptimer_irq = info->physical_irq;
-		host_ptimer_irq_flags = irq_get_trigger_type(host_ptimer_irq);
-		if (host_ptimer_irq_flags != IRQF_TRIGGER_HIGH &&
-		    host_ptimer_irq_flags != IRQF_TRIGGER_LOW) {
-			kvm_err("Invalid trigger for ptimer IRQ%d, assuming level low\n",
-				host_ptimer_irq);
-			host_ptimer_irq_flags = IRQF_TRIGGER_LOW;
-		}
-
 		err = request_percpu_irq(host_ptimer_irq, kvm_arch_timer_handler,
 					 "kvm guest ptimer", kvm_get_running_vcpus());
 		if (err) {
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
