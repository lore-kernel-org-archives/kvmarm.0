Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6A3146910
	for <kvmarm@lists.linux.dev>; Fri, 16 Feb 2024 18:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708108944; cv=none; b=mtOwOSGBGmDTv/rbKbISKSp1Oy9KHpDkIJm4IBXc96XJJh4j5mfQcCZcRuCvfESHuZlmdufgofqK6/JtsDMlaMBq/kFuOl78Bpp9A3jQjkRmhUxt+Wwh8kNbTpslIQ1g5kTCWpiOVdtvZ69UZXnfGSCyRRiUpw4hwCkQ3orP5yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708108944; c=relaxed/simple;
	bh=SeNrU4ebThHySloZ/TR+kB1GC+oWuzUM+5Ajy3ISOQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIJJA2tSUsE4yRnAmUnCWGJgET08+hqZe6UJLJjm26yUErajbW3EDt4AeuBpeknwi6Fhx6wt0ayZnP4LWpBQtCJKSzkMG316ZKKRf0T5VebTUgSHg2FqjXzR19CYt8SUfhnKpanF1vDXiPIftRNYzlSYa2sLk3zMW6fu/neLYEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oTBnQU5q; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oTBnQU5q"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708108941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cQF8jmMEEUM2DwWlHNkDBl2apuHpFelpH7G2Kk29lho=;
	b=oTBnQU5qPGkYHCizl8J+qjyAehCVu38cmLrtpEEygEROkm0VoerNZhquN0IIRIcY5RnvjN
	6ANsbJ6rbKZCeF8F1yno7ZklnqkDwLYGHWg/qWlVXBtXCfQno+URKfRUqvNpbp9Afxhyqc
	7TOCUUKhqw1uKfu2420fNRxQiMnKuvc=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 08/10] KVM: arm64: vgic: Rely on RCU protection in vgic_get_lpi()
Date: Fri, 16 Feb 2024 18:41:51 +0000
Message-ID: <20240216184153.2714504-9-oliver.upton@linux.dev>
In-Reply-To: <20240216184153.2714504-1-oliver.upton@linux.dev>
References: <20240216184153.2714504-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Stop acquiring the lpi_list_lock in favor of RCU for protecting
the read-side critical section in vgic_get_lpi(). In order for this to
be safe, we also need to be careful not to take a reference on an irq
with a refcount of 0, as it is about to be freed.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic.c |  9 ++++-----
 arch/arm64/kvm/vgic/vgic.h | 14 +++++++++++---
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index be3ed4c5e1fa..128ae53a0a55 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -62,15 +62,14 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u32 intid)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_irq *irq = NULL;
-	unsigned long flags;
 
-	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
+	rcu_read_lock();
 
 	irq = xa_load(&dist->lpi_xa, intid);
-	if (irq)
-		vgic_get_irq_kref(irq);
+	if (!vgic_try_get_irq_kref(irq))
+		irq = NULL;
 
-	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
+	rcu_read_unlock();
 
 	return irq;
 }
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 8d134569d0a1..f874b9932c5a 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -220,12 +220,20 @@ void vgic_v2_vmcr_sync(struct kvm_vcpu *vcpu);
 void vgic_v2_save_state(struct kvm_vcpu *vcpu);
 void vgic_v2_restore_state(struct kvm_vcpu *vcpu);
 
-static inline void vgic_get_irq_kref(struct vgic_irq *irq)
+static inline bool vgic_try_get_irq_kref(struct vgic_irq *irq)
 {
+	if (!irq)
+		return false;
+
 	if (irq->intid < VGIC_MIN_LPI)
-		return;
+		return true;
 
-	kref_get(&irq->refcount);
+	return kref_get_unless_zero(&irq->refcount);
+}
+
+static inline void vgic_get_irq_kref(struct vgic_irq *irq)
+{
+	WARN_ON_ONCE(!vgic_try_get_irq_kref(irq));
 }
 
 void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu);
-- 
2.44.0.rc0.258.g7320e95886-goog

