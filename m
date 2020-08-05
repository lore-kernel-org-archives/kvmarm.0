Return-Path: <SRS0=OpMx=BP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 134AAC433E0
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 17:57:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AF78322CA1
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 17:57:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="vcUqq6D/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF78322CA1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 646EF4B558;
	Wed,  5 Aug 2020 13:57:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iNRGEVih+aai; Wed,  5 Aug 2020 13:57:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A8504B5C2;
	Wed,  5 Aug 2020 13:57:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B33AA4B587
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 13:57:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y72jOA6tsi8y for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Aug 2020 13:57:20 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 621434B558
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 13:57:19 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 72F3D22CE3;
 Wed,  5 Aug 2020 17:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596650238;
 bh=fAuT8VTgA3l5MxpGKHZ5lW2sGaO4vZ74wkEmAKAFtrA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=vcUqq6D/d3qBogzUqxDEU1yrJft154JBCm9/Iv2SxFCKg6SWwNAnaoSxtp2W9u4Hi
 1LHIcd1mWTG2aLoNfI7y9EjiiC3kqdt3YfEY5jdj3KebOg9wC3TqfaAHRqVXwGYtis
 DgzUWUvS16QrvvGac+L0RzYqg7Yp+BFj7y7qV2mg=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k3NfA-0004w9-Vm; Wed, 05 Aug 2020 18:57:17 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 06/56] KVM: arm64: Allow in-atomic injection of SPIs
Date: Wed,  5 Aug 2020 18:56:10 +0100
Message-Id: <20200805175700.62775-7-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, graf@amazon.com,
 alexandru.elisei@arm.com, ascull@google.com, catalin.marinas@arm.com,
 christoffer.dall@arm.com, dbrazdil@google.com, eric.auger@redhat.com,
 gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com,
 richard.peng@oppo.com, qperret@google.com, will@kernel.org,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Peng Hao <richard.peng@oppo.com>, kernel-team@android.com,
 kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexander Graf <graf@amazon.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On a system that uses SPIs to implement MSIs (as it would be
the case on a GICv2 system exposing a GICv2m to its guests),
we deny the possibility of injecting SPIs on the in-atomic
fast-path.

This results in a very large amount of context-switches
(roughly equivalent to twice the interrupt rate) on the host,
and suboptimal performance for the guest (as measured with
a test workload involving a virtio interface backed by vhost-net).
Given that GICv2 systems are usually on the low-end of the spectrum
performance wise, they could do without the aggravation.

We solved this for GICv3+ITS by having a translation cache. But
SPIs do not need any extra infrastructure, and can be immediately
injected in the virtual distributor as the locking is already
heavy enough that we don't need to worry about anything.

This halves the number of context switches for the same workload.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-irqfd.c | 24 +++++++++++++++++++-----
 arch/arm64/kvm/vgic/vgic-its.c   |  3 +--
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-irqfd.c
index d8cdfea5cc96..79f8899b234c 100644
--- a/arch/arm64/kvm/vgic/vgic-irqfd.c
+++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
@@ -100,19 +100,33 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 
 /**
  * kvm_arch_set_irq_inatomic: fast-path for irqfd injection
- *
- * Currently only direct MSI injection is supported.
  */
 int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
 			      struct kvm *kvm, int irq_source_id, int level,
 			      bool line_status)
 {
-	if (e->type == KVM_IRQ_ROUTING_MSI && vgic_has_its(kvm) && level) {
+	if (!level)
+		return -EWOULDBLOCK;
+
+	switch (e->type) {
+	case KVM_IRQ_ROUTING_MSI: {
 		struct kvm_msi msi;
 
+		if (!vgic_has_its(kvm))
+			break;
+
 		kvm_populate_msi(e, &msi);
-		if (!vgic_its_inject_cached_translation(kvm, &msi))
-			return 0;
+		return vgic_its_inject_cached_translation(kvm, &msi);
+	}
+
+	case KVM_IRQ_ROUTING_IRQCHIP:
+		/*
+		 * Injecting SPIs is always possible in atomic context
+		 * as long as the damn vgic is initialized.
+		 */
+		if (unlikely(!vgic_initialized(kvm)))
+			break;
+		return vgic_irqfd_set_irq(e, kvm, irq_source_id, 1, line_status);
 	}
 
 	return -EWOULDBLOCK;
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index c012a52b19f5..40cbaca81333 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -757,9 +757,8 @@ int vgic_its_inject_cached_translation(struct kvm *kvm, struct kvm_msi *msi)
 
 	db = (u64)msi->address_hi << 32 | msi->address_lo;
 	irq = vgic_its_check_cache(kvm, db, msi->devid, msi->data);
-
 	if (!irq)
-		return -1;
+		return -EWOULDBLOCK;
 
 	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 	irq->pending_latch = true;
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
