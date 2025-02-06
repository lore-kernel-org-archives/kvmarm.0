Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FD223642A
	for <kvmarm@lists.linux.dev>; Thu,  6 Feb 2025 15:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738855273; cv=none; b=nLFghT9/U79ITxOXk34y70GELs5ssqGiE3NJyU3GY1wij+39a35pmrnNUnlp4+Y4fa+jGnU5fmDLD1N1Q/5sYxnRmH3B5MlOlCYbXmMErHGfYH+kN8o5/nmDlkIFRSS1vwLrABfh1zy5fLxq+YL+OZqX7EzmeXL3oRTlUD27gJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738855273; c=relaxed/simple;
	bh=R18buuzsuS125/Odab8HVwhiAwt8pdMFSvfHK7BgPUE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C4Y1xGyHzJ3wQfSQK5sINCbSVrVcFfOt4EqnSpUwTZ4NBuCUjx4UwN8vUQqvD3RgsuMYQFKk8+TsZZ2Yl9a0KMvB9QxFY0plC8zoeHucwUlK8502Epk3W5y4MJCVxDuEclaFwrsnoWEf3p6ZbBjqIm5OtNh7glycJww44PF2aV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=or1/UO5X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="or1/UO5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35D4C4CEDD;
	Thu,  6 Feb 2025 15:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738855273;
	bh=R18buuzsuS125/Odab8HVwhiAwt8pdMFSvfHK7BgPUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=or1/UO5XwRfczye/Xg3Gq9snuMNbD5/7D8mXMHJadtD4gAdT5tCRPNYqcWLDwAtVb
	 NQ0kdre2iz6RvesgTbw0NYtZIWCbkZ4LIea/r7sDruoUwy4xRgC3IeT7MIWnpNrLFG
	 ntGemeTwGuUEI/1VAJJLP0jfYj64zmMV9sVHbmXFEu2e9vHZAqj/dL/3AC1GcaCZcg
	 lFpn0Ty1llhSJveVbEjhW75q6PkA2NnqHkSsWwHzN3V+GEJlFn8TH+l+rtE9fpexRk
	 CO9ail4A1mn6LfqTp+DbzcwTtHWRVzidv1M2oGPmV0aBG0tUwZs9oAHVij9HnSD8T1
	 Q2Sgka8EvM1hQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tg3gk-001Axu-JW;
	Thu, 06 Feb 2025 15:21:11 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Alexander Potapenko <glider@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 2/3] KVM: arm64: vgic: Check for unallocated PPI/SPI arrays
Date: Thu,  6 Feb 2025 15:20:59 +0000
Message-Id: <20250206152100.1107909-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250206152100.1107909-1-maz@kernel.org>
References: <20250206152100.1107909-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, glider@google.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Alexander's fuzzing has exhibited a large variety of races that
all end-up with taking the address of a PPI or SPI structure while
the vgic was torn down (because nuking it is only an ioctl() away,
and syzkaller is amazing at finding holes).

In order to preserve some sanity, always evaluate whether the array
containing the PPI/SPI is allocated.

Suggested-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index cc8c6b9b5dd8b..f454cef59e24b 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -89,6 +89,8 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid)
 	/* SPIs */
 	if (intid >= VGIC_NR_PRIVATE_IRQS &&
 	    intid < (kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS)) {
+		if (unlikely(!kvm->arch.vgic.spis))
+			return NULL;
 		intid = array_index_nospec(intid, kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS);
 		return &kvm->arch.vgic.spis[intid - VGIC_NR_PRIVATE_IRQS];
 	}
@@ -107,6 +109,8 @@ struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *vcpu, u32 intid)
 
 	/* SGIs and PPIs */
 	if (intid < VGIC_NR_PRIVATE_IRQS) {
+		if (unlikely(!vcpu->arch.vgic_cpu.private_irqs))
+			return NULL;
 		intid = array_index_nospec(intid, VGIC_NR_PRIVATE_IRQS);
 		return &vcpu->arch.vgic_cpu.private_irqs[intid];
 	}
-- 
2.39.2

