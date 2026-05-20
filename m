Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D193D47AE
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 10:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779271330; cv=none; b=dBONXB5PMapfVpaJ10w4/vqeFnhUxOABrvWK/2hJoB6WqFUWxPUhzfNI4I0ceOnJeGMwnAmpNnvFqSvNWS1gHXTejUZ5tbPBzrPAO1YeulNXfs7gOihVqEuo1IYZ0C+cg0uH6gLpBP46N0oMG8JE9MRjAESh4ZDeHbebOWWRuDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779271330; c=relaxed/simple;
	bh=8+FVoIt5874kTvCFfQfFzjTHRR/9k+x9ujb8FG6UUGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ledz3pYG+XOREcITaGs5Pk+tVsSoIZEZPrzl4xVZB+nX470kx7vwURdNmRLZ1eYpFvd6Da3W0nCXTmAxw1U2nWw9G/gEKzWPzjdORPCwY1pOub0k2kSS9mQjgEnElvW1ePHxWwPxNhNvNNhU8RamwMRd23bfGPmtw98kPiRL/sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NMSUv7mq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NMSUv7mq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66EE21F0089A;
	Wed, 20 May 2026 10:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779271328;
	bh=GW/95UAqJVjJyk5NumyqoWPmDlgdsGENa/yA7wIIcgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NMSUv7mqPt7A1IayyUvF6KomI0iJsvk6XugotWZlwKG0yAIjlQ9oSVke4Sh0sCWPt
	 Q+OBGnRZeF65CRE+d4wYfS8zxqhCfMuloq/BToviIWtY8N6GktARgC0Dm+bimkPfjS
	 y+1DXQtMGH5rHqrKNrXrWeQhsIi8+KY5rgmbWWHtKpqcGwaar0O+4LblXpPLon8jev
	 NPLcHtkrNaLW6z/ackQTwInGp8k+ByKHinSg3x9a5v7x5XT2Zi49J+LnM1eEyzf/sh
	 LhDjaOpd8WLNA70lmadykx5S2DGNmlHv7GHopyEaW/jIevqBy8VM+vw7hwmclFgqN/
	 cT2kL3HJ8z+jA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPdkc-00000004Jio-2wVN;
	Wed, 20 May 2026 10:02:06 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v3 6/6] KVM: arm64: vgic-v2: Don't init the vgic on in-kernel interrupt injection
Date: Wed, 20 May 2026 11:02:00 +0100
Message-ID: <20260520100200.543845-7-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520100200.543845-1-maz@kernel.org>
References: <20260520100200.543845-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kartikey406@gmail.com, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We how have the lazy init on three paths:

- on first run of a vcpu
- on first injection of an interrupt from userspace and irqfd
- on first injection of an interrupt from kernel space as
  part of the device emulation (timers, PMU, vgic MI)

Given that we recompute the state of each in-kernel interrupt
every time we are about to enter the guest, we can drop the lazy
init from the kernel injection path.

This solves a bunch of issues related to vgic_lazy_init() being called
in non-preemptible context, such as vcpu reset.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 1e9fe8764584d..9e29f03d3463c 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -534,11 +534,9 @@ int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 {
 	struct vgic_irq *irq;
 	unsigned long flags;
-	int ret;
 
-	ret = vgic_lazy_init(kvm);
-	if (ret)
-		return ret;
+	if (unlikely(!vgic_initialized(kvm)))
+		return 0;
 
 	if (!vcpu && irq_is_private(kvm, intid))
 		return -EINVAL;
-- 
2.47.3

