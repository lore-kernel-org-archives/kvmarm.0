Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B790629B78E
	for <kvmarm@lists.linux.dev>; Thu,  4 Sep 2025 07:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756970913; cv=none; b=nTdHc6W/qpi1Yw9nwgfYC++B6+MlGgDyl1FCI1VU8kZtj4sOLD3jzQHqtOQ+ZAtw0+ELHFIOQP5UjdehHzgP4bbNLtS4GEll5fNYTBRXnDVG66Smbwky60kHXUFr8ahLgErznXfeTPpdW8m4lBE3TGMYoTqtu8pTB8GACGq/sNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756970913; c=relaxed/simple;
	bh=ef5Vyrdbds07Qb9NPQNpRS7OpMoiF+B/EpzM1aF2IPA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mi2xC90PTAkAzwtdsLh88QL4F4NESCW2xvMwNmefRPF1TqlnkHNP59S2HoodngeQzEgj00R/CABwtuDK4XZ+SoNuTLS5ZCpU7z3o8klUc8mIdH4X1rUqLiFsR+VpK/O6ENu2eDKSqwri5d9T3EotVdhoAwgA3FPGVoswWt5TFnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rK8SDymH; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rK8SDymH"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756970908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cBxpOsI68m+bd4r/5vOcR+wn8MHx4WyhcPxj/aZJuMg=;
	b=rK8SDymHi78i02o/Uvl1fh6IaTIL/ZwnQOWho3IjEidFsFOEwn4VKECyf9tvB/wkQ85T1/
	8ASFpDrzNG0nVIza2wn+pjr2xV4PgS6EkX9+4EWIJeN6jv8vpOn3ONDfNEibPP0oEC2u6f
	/bbCOdYCVp3DweMivieBpxoIOMUNWT8=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 2/5] KVM: arm64: Spin off release helper from vgic_put_irq()
Date: Wed,  3 Sep 2025 23:23:45 -0700
Message-Id: <20250904062348.223976-3-oliver.upton@linux.dev>
In-Reply-To: <20250904062348.223976-1-oliver.upton@linux.dev>
References: <20250904062348.223976-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Spin off the release implementation from vgic_put_irq() to prepare for a
more involved fix for lock ordering such that it may be unnested from
raw spinlocks. This has the minor functional change of doing call_rcu()
behind the xa_lock although it shouldn't be consequential.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index a1d6fab895c4..ec4d70936a5b 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -114,22 +114,32 @@ struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *vcpu, u32 intid)
 	return vgic_get_irq(vcpu->kvm, intid);
 }
 
+static void vgic_release_lpi_locked(struct vgic_dist *dist, struct vgic_irq *irq)
+{
+	lockdep_assert_held(&dist->lpi_xa.xa_lock);
+	__xa_erase(&dist->lpi_xa, irq->intid);
+	kfree_rcu(irq, rcu);
+}
+
+static __must_check bool __vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
+{
+	if (irq->intid < VGIC_MIN_LPI)
+		return false;
+
+	return refcount_dec_and_test(&irq->refcount);
+}
+
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	unsigned long flags;
 
-	if (irq->intid < VGIC_MIN_LPI)
-		return;
-
-	if (!refcount_dec_and_test(&irq->refcount))
+	if (!__vgic_put_irq(kvm, irq))
 		return;
 
 	xa_lock_irqsave(&dist->lpi_xa, flags);
-	__xa_erase(&dist->lpi_xa, irq->intid);
+	vgic_release_lpi_locked(dist, irq);
 	xa_unlock_irqrestore(&dist->lpi_xa, flags);
-
-	kfree_rcu(irq, rcu);
 }
 
 void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
-- 
2.39.5

