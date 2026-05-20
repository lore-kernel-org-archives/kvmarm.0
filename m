Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C7F3BAD89
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 09:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779268815; cv=none; b=Y3W/AdABHtcrY1Tv2Q4BRniIesYezPE0mmJnFsGn70+bXsfzYMQryhEopYErTgoJdPsVcm84c4JcykATwATK9yKAt/kx4MEU9cxpSCBGoMbyH+2kV1J7YRrm0WybFgT9q9MC2p1q8uacHxCrUgameZZnd1u0FosipN8JiDBp72I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779268815; c=relaxed/simple;
	bh=gazaM+hbBkgurtwj2pSx8TA704AOvxVtNX2zJsNdhdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ci6ct9Y6ZkP36ncmL6Y6RF9T5fuWYYA9c+Adh+CJ2jyGMCnlijKVC+AC1likrOL9Ca9aw9R28Igr/tM3j86N4xdntC/Pc4VFMErrPzeStPq3DW9GRNps/jDsu6DaRo4URn9y+UU0ZKfYEvGYPo+IlyfzhbyOnUv62o7m5FrPiWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FQRsryKr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FQRsryKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A531A1F000E9;
	Wed, 20 May 2026 09:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779268812;
	bh=LsdMoOJmlRlzGp5zQP3AHVoH36EaiJADf+BAwxUcYWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FQRsryKrwtAkdpQCJoHYLOWkbHZTpt6ZyjfVxjH1O53zM/+xAUXiDif5hpwhsnZp7
	 S7vPpdm3ayXhhtuwcphlBOKDGravWKv0DnW87ByUIcXkvopQ8/qy1s419kXmJfA6ic
	 mlX/zacsgNzHBoMk3nXfWng7x34rtul2fLvq4T/vw99umGP2zsomQa/0F7bNWctUm4
	 iVTP+wQmvE2M7U6/IfCioD4nS/y3tjcarFMzpQRnqCWeJMIKbYkDRWJdSrKSlv7eMb
	 mAaZe6T4Lb6GRALvsT8vY+VtBDJDElrFuG0Ni+O8/54fafIT2+OpM73o3MQ75kdLYj
	 2t6DJaMmzC4ig==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPd62-00000004IaV-3KN1;
	Wed, 20 May 2026 09:20:10 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH v2 03/18] KVM: arm64: vgic-v5: Remove use of __assign_bit() with a constant
Date: Wed, 20 May 2026 10:19:34 +0100
Message-ID: <20260520091949.542365-4-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520091949.542365-1-maz@kernel.org>
References: <20260520091949.542365-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com
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

