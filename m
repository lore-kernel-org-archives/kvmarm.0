Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5C4329E79
	for <kvmarm@lists.linux.dev>; Wed, 22 Apr 2026 10:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776852135; cv=none; b=Nk85GY/II3Lrln0kMTOCYAJupIoEn24Pk+S31qRdKAW2Pa/4rSgTcIPfjJnZHY1WHFDKIduEWFiTim4NbQQ5vwP66PPjf5OqMnQo6fmZrl5NkXiGSYuwMYa+uCWKEb/Ge35pKSG7o1TdHaoROraJaPod6eGAg2MaLACq/iqFV6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776852135; c=relaxed/simple;
	bh=8+FVoIt5874kTvCFfQfFzjTHRR/9k+x9ujb8FG6UUGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T4NEurz3cW9Gab8ZTpyuF3HtvJpz8M+pf14ff2/EEy9VaKSublNz/iJLCM5Q7B21vAGdQMCP6rfyYPP0+eRvfWUJ4tU4AmuWBX0uBKY0D2K4rMf6HhnQXsJQS+8/gT115PgvKG0Be64AfMrNIV0MLZygwvk/ffdekMzxcHcGKM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vNOromq/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vNOromq/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89450C2BCB9;
	Wed, 22 Apr 2026 10:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776852135;
	bh=8+FVoIt5874kTvCFfQfFzjTHRR/9k+x9ujb8FG6UUGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vNOromq/sF5yWPDIgDVH/Ry7WP5HGrN9n1trn3kwpOiIkAxiIwh7YWpyUFmDG3e2/
	 NdSZzycVI/xm1N40sEOlBX9siN4AqAid9Y9t6TkK+NuKwZ+rsXS75+gqVWiJUmbGyX
	 nv+Ua7OqrTaLXzp9vzGGM+ZxImUy18CAOncQrbm4yeR5OyWpHHcZBR+S4rkeI6W7l3
	 CTZU0OKTh0trAjb+4UI3QS033o61q59ODxKrgKx9rexKc9/Sqsp0hrA02GZR0RgGiN
	 npDjWWzF6ORtmWt7A43DbVb3q2yNbASKYSVLEheWaR2KM1szI5Pm5HohKufk4dEgah
	 BF2YMkcXojMYA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wFUPN-0000000Dh6d-31Jd;
	Wed, 22 Apr 2026 10:02:13 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 4/4] KVM: arm64: vgic-v2: Don't init the vgic on in-kernel interrupt injection
Date: Wed, 22 Apr 2026 11:02:10 +0100
Message-ID: <20260422100210.3008156-5-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260422100210.3008156-1-maz@kernel.org>
References: <20260422100210.3008156-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kartikey406@gmail.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
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

