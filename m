Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DB937BE8F
	for <kvmarm@lists.linux.dev>; Wed, 15 Apr 2026 11:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776254181; cv=none; b=LFtmP9My4zJqBe/91ctS4kGhzgvCDHfrepcE6hr1/u7TVBd4k4fLP3kOz5T3PUARYEljIjmtTyx/E/+d4r8KxNa1bZE3i4ISWgH97LpaeAoFaQhrD6CFLG+N7mY8DTgzRRtsc0lqFFgND1QK0u7tnCPAzOCznfOSl/vGUyRVVMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776254181; c=relaxed/simple;
	bh=gazaM+hbBkgurtwj2pSx8TA704AOvxVtNX2zJsNdhdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZ/m96+pWD6MEN8LrpY3NavX/rxYc1j2OBd+5JYAbIffBUKkpHHP0CdyYfxZp8Y5LkwJJ25kDBsCN58fPGk62EaJQLDnXZhgWCa934H/GtUk9CywMQsSgSB8TX+oSmTG+xLzKflqR4gsss+KbQAARhnp5s5Cfzhq2tysZHWW/Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p5iWYg77; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p5iWYg77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C6EC2BCB4;
	Wed, 15 Apr 2026 11:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776254181;
	bh=gazaM+hbBkgurtwj2pSx8TA704AOvxVtNX2zJsNdhdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p5iWYg77aZ6PMS1rx3u7SjXcxb5eA8Zf43sFntvUjAujRBNbLp+j4SJXn6T086m1m
	 BCsO6uAaC+xssG9p9pL8KF2XDTaREn1MOzmhKIc6tF7NLWFCkopAzWEhS0i4n9rcxy
	 HN0Zqcmyl8Dl9XpCvn4Ta4N1ghbSDuRcV0Tb9D26QY+4nGWFKjUgaB8sW8r6cC7WrM
	 kbhe5CP4Y5cnO1KTZOLW4JqAWkP+wkjKPQLYv+bYHUb2WkklOINM5VkrNW9aI35cZl
	 rI9KpKyF6rygeCoeeTfo3TZHW45ML5uf2TcEfaFjouOjQIwQKQaUqVB8pCUJ8ckc1b
	 zdulR0ai/LzsA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wCyqx-0000000Bqsi-3B7l;
	Wed, 15 Apr 2026 11:56:19 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH 03/18] KVM: arm64: vgic-v5: Remove use of __assign_bit() with a constant
Date: Wed, 15 Apr 2026 12:55:44 +0100
Message-ID: <20260415115559.2227718-4-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260415115559.2227718-1-maz@kernel.org>
References: <20260415115559.2227718-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Using __assign_bit() is very useful when the value of the bit is
not known at compile time. In all other cases, __set_bit() and
__clear_bit() are the correct tool for the job.

This also fixes an odd case of using VGIC_V5_NR_PRIVATE_IRQS as
the bit value...

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 7c146fccc9689..4d62b1c31fe8b 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -25,13 +25,13 @@ static void vgic_v5_get_implemented_ppis(void)
 	 * If we have KVM, we have EL2, which means that we have support for the
 	 * EL1 and EL2 Physical & Virtual timers.
 	 */
-	__assign_bit(GICV5_ARCH_PPI_CNTHP, ppi_caps.impl_ppi_mask, 1);
-	__assign_bit(GICV5_ARCH_PPI_CNTV, ppi_caps.impl_ppi_mask, 1);
-	__assign_bit(GICV5_ARCH_PPI_CNTHV, ppi_caps.impl_ppi_mask, 1);
-	__assign_bit(GICV5_ARCH_PPI_CNTP, ppi_caps.impl_ppi_mask, 1);
+	__set_bit(GICV5_ARCH_PPI_CNTHP, ppi_caps.impl_ppi_mask);
+	__set_bit(GICV5_ARCH_PPI_CNTV, ppi_caps.impl_ppi_mask);
+	__set_bit(GICV5_ARCH_PPI_CNTHV, ppi_caps.impl_ppi_mask);
+	__set_bit(GICV5_ARCH_PPI_CNTP, ppi_caps.impl_ppi_mask);
 
 	/* The SW_PPI should be available */
-	__assign_bit(GICV5_ARCH_PPI_SW_PPI, ppi_caps.impl_ppi_mask, 1);
+	__set_bit(GICV5_ARCH_PPI_SW_PPI, ppi_caps.impl_ppi_mask);
 
 	/* The PMUIRQ is available if we have the PMU */
 	__assign_bit(GICV5_ARCH_PPI_PMUIRQ, ppi_caps.impl_ppi_mask, system_supports_pmuv3());
@@ -146,9 +146,7 @@ int vgic_v5_init(struct kvm *kvm)
 	/* We only allow userspace to drive the SW_PPI, if it is implemented. */
 	bitmap_zero(kvm->arch.vgic.gicv5_vm.userspace_ppis,
 		    VGIC_V5_NR_PRIVATE_IRQS);
-	__assign_bit(GICV5_ARCH_PPI_SW_PPI,
-		     kvm->arch.vgic.gicv5_vm.userspace_ppis,
-		     VGIC_V5_NR_PRIVATE_IRQS);
+	__set_bit(GICV5_ARCH_PPI_SW_PPI, kvm->arch.vgic.gicv5_vm.userspace_ppis);
 	bitmap_and(kvm->arch.vgic.gicv5_vm.userspace_ppis,
 		   kvm->arch.vgic.gicv5_vm.userspace_ppis,
 		   ppi_caps.impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
@@ -197,7 +195,7 @@ int vgic_v5_finalize_ppi_state(struct kvm *kvm)
 		/* Expose PPIs with an owner or the SW_PPI, only */
 		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
 			if (irq->owner || i == GICV5_ARCH_PPI_SW_PPI) {
-				__assign_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask, 1);
+				__set_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask);
 				__assign_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr,
 					     irq->config == VGIC_CONFIG_LEVEL);
 			}
-- 
2.47.3

