Return-Path: <SRS0=i7fx=6J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3161C55185
	for <kvmarm@archiver.kernel.org>; Sat, 25 Apr 2020 09:44:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 638072071C
	for <kvmarm@archiver.kernel.org>; Sat, 25 Apr 2020 09:44:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="f1zbBBC9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 638072071C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C4AE04B28E;
	Sat, 25 Apr 2020 05:44:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7k3Wz7xVAgEG; Sat, 25 Apr 2020 05:44:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 878974B2A0;
	Sat, 25 Apr 2020 05:44:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 418E84B28E
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Apr 2020 05:44:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pyarIOBkWWWV for <kvmarm@lists.cs.columbia.edu>;
 Sat, 25 Apr 2020 05:44:55 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F9B04B248
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Apr 2020 05:44:55 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id EFF832064C;
 Sat, 25 Apr 2020 09:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1587807894;
 bh=hbcviEx626chZm3MDI73tTRFC1Bak0yE4bT+LlrKlz8=;
 h=From:To:Cc:Subject:Date:From;
 b=f1zbBBC9R3jLlcrk8D+MtVDc/EpaeLHY61g/LIf0YQmldc02dH17V87ccKJQhqXZ4
 SJF/NsTajZ+xmjI8CHw9bHInwhuObC6SDfV+JpT2aBEoJpxQ8YMK2UkwHxNRtJaZnR
 FDyi2WUg89eS13Wlf4YniGNCqfk45wpDlHtrQh84=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jSHMi-006HBD-Ce; Sat, 25 Apr 2020 10:44:52 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: arm64: vgic-v4: Initialize GICv4.1 even in the absence
 of a virtual ITS
Date: Sat, 25 Apr 2020 10:44:26 +0100
Message-Id: <20200425094426.162962-1-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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

KVM now expects to be able to use HW-accelerated delivery of vSGIs
as soon as the guest has enabled thm. Unfortunately, we only
initialize the GICv4 context if we have a virtual ITS exposed to
the guest.

Fix it by always initializing the GICv4.1 context if it is
available on the host.

Fixes: 2291ff2f2a56 ("KVM: arm64: GICv4.1: Plumb SGI implementation selection in the distributor")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/vgic/vgic-init.c    | 9 ++++++++-
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 3 ++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index a963b9d766b73..8e6f350c3bcd1 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -294,8 +294,15 @@ int vgic_init(struct kvm *kvm)
 		}
 	}
 
-	if (vgic_has_its(kvm)) {
+	if (vgic_has_its(kvm))
 		vgic_lpi_translation_cache_init(kvm);
+
+	/*
+	 * If we have GICv4.1 enabled, unconditionnaly request enable the
+	 * v4 support so that we get HW-accelerated vSGIs. Otherwise, only
+	 * enable it if we present a virtual ITS to the guest.
+	 */
+	if (vgic_supports_direct_msis(kvm)) {
 		ret = vgic_v4_init(kvm);
 		if (ret)
 			goto out;
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index e72dcc4542475..26b11dcd45524 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -50,7 +50,8 @@ bool vgic_has_its(struct kvm *kvm)
 
 bool vgic_supports_direct_msis(struct kvm *kvm)
 {
-	return kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm);
+	return (kvm_vgic_global_state.has_gicv4_1 ||
+		(kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm)));
 }
 
 /*
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
