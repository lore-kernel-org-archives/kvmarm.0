Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF14C1350CF
	for <kvmarm@lists.linux.dev>; Wed, 24 Jan 2024 20:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706129372; cv=none; b=gVGXPu6ucxLlqdt2ofxWNG1AkPrLxq9J8Vy4fFIYGYOaVC1FmOUeXiBwUfSDi+0YAeOiaemx8E+4KcaUh8DFRx0fnAmwGVhwGdtvqXMgdwvNVubIMXsrpODMwIoR2Li4vyJdhT8XfT8aH2gK+kXCtSrMMbTQcRbyX8iONzQBgZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706129372; c=relaxed/simple;
	bh=EQxOcqkChok4sxfbnzwEFj1fVU3Aa1XVGuAjzKFsnoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAnubGH3jPtP4Qoc4Bh5BXbAbOb2/uQp0a8wm16qCjwt9FyuFUU6eUaDcY4E14g1ea0VWYZqOaJkcFE+bi1ianrUiOo6n/MOcq9bRn8jYatehUyktndb4iQwmtJ3kEIDR7HrjBUmJgSQ/eCr5mo7ph8eQTHBYVkPUIjt/zqqjZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GqkyWNab; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GqkyWNab"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706129368;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UgcFzuCZCGBGq43AzcrLHC5Pd72zyqu8lxZidsgbsEI=;
	b=GqkyWNabnKnkeObvMJ/FRzoCT6oKeXtbNT5mUjYJrbgYJtHOAm65oO8fkeCI7syffofLXL
	ooJtHG8vAa9CtBbrL+DrwtAFIsfGEisWrb2SDY+I0iTrgTUL1ycfLvlKG+fitri6mmMnzB
	MhXOGyzCrXAn5QZ2PbudfeZP+HGxhxA=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 04/15] KVM: arm64: vgic-its: Walk the LPI xarray in vgic_copy_lpi_list()
Date: Wed, 24 Jan 2024 20:48:58 +0000
Message-ID: <20240124204909.105952-5-oliver.upton@linux.dev>
In-Reply-To: <20240124204909.105952-1-oliver.upton@linux.dev>
References: <20240124204909.105952-1-oliver.upton@linux.dev>
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
index f152d670113f..a2d95a279798 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -332,6 +332,7 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
 int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
+	XA_STATE(xas, &dist->lpi_xa, 0);
 	struct vgic_irq *irq;
 	unsigned long flags;
 	u32 *intids;
@@ -350,7 +351,9 @@ int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr)
 		return -ENOMEM;
 
 	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
-	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
+	rcu_read_lock();
+
+	xas_for_each(&xas, irq, U32_MAX) {
 		if (i == irq_count)
 			break;
 		/* We don't need to "get" the IRQ, as we hold the list lock. */
@@ -358,6 +361,8 @@ int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr)
 			continue;
 		intids[i++] = irq->intid;
 	}
+
+	rcu_read_unlock();
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 
 	*intid_ptr = intids;
-- 
2.43.0.429.g432eaa2c6b-goog

