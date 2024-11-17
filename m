Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA34F1D8DEE
	for <kvmarm@lists.linux.dev>; Sun, 17 Nov 2024 16:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731862683; cv=none; b=L7MkciRo7rFPfEfEiRz9R+snZ0fI7KBZlllOFiQnpAtpg6b2bUrqivbplpT+fmSucmuypJOYYDJdEbwgDnP4+wwYL1j66xI82iPmll36MooaXOzAW7vPFph3YcALHZYq/Il6LereChE8XgfddSkA7wnqfwTS6LobWdYsN7F/Li8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731862683; c=relaxed/simple;
	bh=atUjxq7FtVXxDP6ar/cAzl7DD0zGoP/QXim6pTv1I6A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=slPd2imPv1RhsTHmbPauGEJbpnjzxKDUX5404aQ7UJfXtpD7bvkt1mFbpdvPvqvbgoogu5k5z7xmaQ94pDl8WKkHb6/b8h65UONI22cPFM75G1v46EJaZfEsgU9PE22Smq9op1KQgxjGFKsjTkFPzD/bW2YDFjFkp0PClEcRF7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lOPATGJz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lOPATGJz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78475C4CED8;
	Sun, 17 Nov 2024 16:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731862683;
	bh=atUjxq7FtVXxDP6ar/cAzl7DD0zGoP/QXim6pTv1I6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lOPATGJzVtFlIbIGw93CfPIezR2QKyW88Rolayiwjf+SFJHIU4Sb9awUJQjC8f/AJ
	 SISgTQaaWmdPxHJ+fDshpNEtVeXIVOdJEPrTNNHWtbnURLSCNJPnHo7FpzAv2WFPuD
	 8KETkPm/pnyDTUuAhaKdrVY88K3qgDu0djlPfqkVDwyiZpbyJ1klIcnpqZyyAeeEHf
	 h4E42VpYsM5QuLiEGXU9lVPtzTT8AsvX/TAz1Q0og0UxKqGci0rFEQ+MbYKJDJpxtS
	 cWjwi3AgHrlRWyCGJDqKMdjclyldPPmEAfUfAiBZjXvoFfZTgW3SlGib/A45Jtid7N
	 ImEaAwMTAktvA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tCib3-00DYt6-NZ;
	Sun, 17 Nov 2024 16:58:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 3/4] KVM: arm64: vgic: Kill VGIC_MAX_PRIVATE definition
Date: Sun, 17 Nov 2024 16:57:56 +0000
Message-Id: <20241117165757.247686-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241117165757.247686-1-maz@kernel.org>
References: <20241117165757.247686-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

VGIC_MAX_PRIVATE is a pretty useless definition, and is better
replaced with VGIC_NR_PRIVATE_IRQS.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic.c | 4 ++--
 include/kvm/arm_vgic.h     | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index ffaa52448b6f8..cc8c6b9b5dd8b 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -106,8 +106,8 @@ struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *vcpu, u32 intid)
 		return NULL;
 
 	/* SGIs and PPIs */
-	if (intid <= VGIC_MAX_PRIVATE) {
-		intid = array_index_nospec(intid, VGIC_MAX_PRIVATE + 1);
+	if (intid < VGIC_NR_PRIVATE_IRQS) {
+		intid = array_index_nospec(intid, VGIC_NR_PRIVATE_IRQS);
 		return &vcpu->arch.vgic_cpu.private_irqs[intid];
 	}
 
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index f5172549f9ba0..3a8ccfda34d29 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -26,7 +26,6 @@
 #define VGIC_NR_SGIS		16
 #define VGIC_NR_PPIS		16
 #define VGIC_NR_PRIVATE_IRQS	(VGIC_NR_SGIS + VGIC_NR_PPIS)
-#define VGIC_MAX_PRIVATE	(VGIC_NR_PRIVATE_IRQS - 1)
 #define VGIC_MAX_SPI		1019
 #define VGIC_MAX_RESERVED	1023
 #define VGIC_MIN_LPI		8192
-- 
2.39.2

