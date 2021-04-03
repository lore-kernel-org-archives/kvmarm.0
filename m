Return-Path: <SRS0=To9v=JA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38B99C43600
	for <kvmarm@archiver.kernel.org>; Sat,  3 Apr 2021 11:30:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C0F456125F
	for <kvmarm@archiver.kernel.org>; Sat,  3 Apr 2021 11:29:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C0F456125F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 748534B1DA;
	Sat,  3 Apr 2021 07:29:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7TSBytYgXXKL; Sat,  3 Apr 2021 07:29:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7142C4B584;
	Sat,  3 Apr 2021 07:29:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00AB84B55E
 for <kvmarm@lists.cs.columbia.edu>; Sat,  3 Apr 2021 07:29:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id po45lmC-Z42a for <kvmarm@lists.cs.columbia.edu>;
 Sat,  3 Apr 2021 07:29:54 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 12B1B4B50F
 for <kvmarm@lists.cs.columbia.edu>; Sat,  3 Apr 2021 07:29:54 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 38C2561210;
 Sat,  3 Apr 2021 11:29:53 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lSeTP-005R95-Io; Sat, 03 Apr 2021 12:29:51 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 3/9] KVM: arm64: vgic: Be tolerant to the lack of
 maintenance interrupt
Date: Sat,  3 Apr 2021 12:29:25 +0100
Message-Id: <20210403112931.1043452-4-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210403112931.1043452-1-maz@kernel.org>
References: <20210403112931.1043452-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com,
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

As it turns out, not all the interrupt controllers are able to
expose a vGIC maintenance interrupt as a distrete signal.
And to be fair, it doesn't really matter as all we require is
for *something* to kick us out of guest mode out way or another.

On systems that do not expose a maintenance interrupt as such,
there are two outcomes:

- either the virtual CPUIF does generate an interrupt, and
  by the time we are back to the host the interrupt will have long
  been disabled (as we set ICH_HCR_EL2.EN to 0 on exit). In this case,
  interrupt latency is as good as it gets.

- or some other event (physical timer) will take us out of the guest
  anyway, and the only drawback is a bad interrupt latency.

So let's be tolerant to the lack of maintenance interrupt, and just let
the user know that their mileage may vary...

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-init.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 9b491263f5f7..00c75495fd0c 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -521,11 +521,6 @@ int kvm_vgic_hyp_init(void)
 	if (!gic_kvm_info)
 		return -ENODEV;
 
-	if (!gic_kvm_info->maint_irq) {
-		kvm_err("No vgic maintenance irq\n");
-		return -ENXIO;
-	}
-
 	switch (gic_kvm_info->type) {
 	case GIC_V2:
 		ret = vgic_v2_probe(gic_kvm_info);
@@ -549,6 +544,11 @@ int kvm_vgic_hyp_init(void)
 	if (ret)
 		return ret;
 
+	if (!kvm_vgic_global_state.maint_irq) {
+		kvm_err("No maintenance interrupt available, fingers crossed...\n");
+		return 0;
+	}
+
 	ret = request_percpu_irq(kvm_vgic_global_state.maint_irq,
 				 vgic_maintenance_handler,
 				 "vgic", kvm_get_running_vcpus());
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
