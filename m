Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142D613956D
	for <kvmarm@lists.linux.dev>; Fri, 16 Feb 2024 18:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708108936; cv=none; b=GQ5mkMEp+w1MahZ9p/RiKv6/VVEQJiPuLrKky2DDKf+Z5m6OwA3IKk5XJGaFqwN8djh8+4hQxMe0Ae4clKT6cfVzZkDCzcxqxoADlhCUHOJ2y8UlHyMgKmRA+JSAxbzAPGD7QbpOPCQg/rRycAT8yMcgJorRw3LfGLqXzOfZnSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708108936; c=relaxed/simple;
	bh=kWOvmd79TSBa85yZMhQxLashdvnOQitPJm7fzCmDhgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNtqmsL5ZEwoKFeBZB5I2rhDGOhnucNWd/Z3W2ugC4D/4eyGOfbOuBQdzXCYmCmhVZ++Tkkr0tFhgNLi9VP25ELnjgjURtu0aJvsjYCKoc0YudtXMfOhKW+Ss0bHPWPeMYekcrfptr4pvKdIel/ojUeL1AZkunaptMaxJ1Oiuhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=n1FUOVlE; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="n1FUOVlE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708108933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZQGaJWYKQGMmTnU81XUm3LbLxD/nkGmlez2wBi9FY5g=;
	b=n1FUOVlE36G2VVZcvP+dqcFaQP/pVkYnqUcaLYGdtm9/lxWqLZYHUlFvWZz/JpQPNCRJP6
	1wTx7GgFkHB6w/xSy6Ht/4/qxBloxyYg8mhMIejHWFi/xDFcNVBqjzuUqKKH/EJ2liryZJ
	wRYPIDA1qMmkaeagAY7w1JT56E90o40=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 04/10] KVM: arm64: vgic-its: Walk the LPI xarray in vgic_copy_lpi_list()
Date: Fri, 16 Feb 2024 18:41:47 +0000
Message-ID: <20240216184153.2714504-5-oliver.upton@linux.dev>
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

Start iterating the LPI xarray in anticipation of removing the LPI
linked-list.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index fb2d3c356984..9ce2edfadd11 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -335,6 +335,7 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
 int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
+	XA_STATE(xas, &dist->lpi_xa, GIC_LPI_OFFSET);
 	struct vgic_irq *irq;
 	unsigned long flags;
 	u32 *intids;
@@ -353,7 +354,9 @@ int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr)
 		return -ENOMEM;
 
 	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
-	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
+	rcu_read_lock();
+
+	xas_for_each(&xas, irq, INTERRUPT_ID_BITS_ITS) {
 		if (i == irq_count)
 			break;
 		/* We don't need to "get" the IRQ, as we hold the list lock. */
@@ -361,6 +364,8 @@ int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr)
 			continue;
 		intids[i++] = irq->intid;
 	}
+
+	rcu_read_unlock();
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 
 	*intid_ptr = intids;
-- 
2.44.0.rc0.258.g7320e95886-goog

