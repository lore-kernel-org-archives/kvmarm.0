Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9772922EE0
	for <kvmarm@lists.linux.dev>; Tue, 27 Feb 2024 22:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709073791; cv=none; b=WjFcwRbKWlw6sEGyAN/X0O4A4DeuvLHtAEe56+poZIbzkugi2wBHJdhuul4HSsSArG+/VRJKduTw7bFkC3CB2gYI/b+evbfCz6CXxNtNr3DC6SyX6dPX1j4W0K/p0jd+YH2qsdOOtLTGeltvgf7JogAA9Dpuba24uxu4/qb72pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709073791; c=relaxed/simple;
	bh=yAFJRcCpltor35cfcPMZSLr0b6RAzFW5CeApcemthLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2Q0vHRFcyEh5EzWKQkWKwRvUOSa8yn5QBAZy9NaJnXtqoXxNJwC1IRUppLn/0li/eN8uQFQa40vyyJpK3Wzukz/RPZ6Jj8IaqNS/YSzgcQD5jhk7RQM4HWO1z6bfQ2jmTft61hJcJUv0wmxYSzTgRtrVE5H/CZFCl/Tl56C2ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vCR5xHAK; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vCR5xHAK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709073788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AH0zi0lqWOeqLjBpJwcGXAXtGonKRSDb9SE2iftr4RE=;
	b=vCR5xHAKmhYzK13KEprEYZuYtaBrC7xCOM1Z6ycHU5sPA7bM6xGpWc5YxP92ZDHPfTVdUx
	hHJLbY7CXYkx8AdgTxY/OzSi7HyfgU8QarWFyZQQPhBzTuWeX2Lcg+gOMyeveIkCEKcv2w
	tpoTGaSlm1fZD/6WRbepZqjO3SK5Yeo=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 04/20] KVM: arm64: vgic-its: Walk LPI xarray in vgic_its_cmd_handle_movall()
Date: Tue, 27 Feb 2024 22:42:33 +0000
Message-ID: <20240227224249.2209194-5-oliver.upton@linux.dev>
In-Reply-To: <20240227224249.2209194-1-oliver.upton@linux.dev>
References: <20240227224249.2209194-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The new LPI xarray makes it possible to walk the VM's LPIs without
holding a lock, meaning that vgic_copy_lpi_list() is no longer
necessary. Prepare for the deletion by walking the LPI xarray directly
in vgic_its_cmd_handle_movall().

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 408600e79cd4..ba97fbe3aeab 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1418,10 +1418,10 @@ static int vgic_its_cmd_handle_invall(struct kvm *kvm, struct vgic_its *its,
 static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 				      u64 *its_cmd)
 {
+	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct kvm_vcpu *vcpu1, *vcpu2;
 	struct vgic_irq *irq;
-	u32 *intids;
-	int irq_count, i;
+	unsigned long intid;
 
 	/* We advertise GITS_TYPER.PTA==0, making the address the vcpu ID */
 	vcpu1 = kvm_get_vcpu_by_id(kvm, its_cmd_get_target_addr(its_cmd));
@@ -1433,12 +1433,8 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 	if (vcpu1 == vcpu2)
 		return 0;
 
-	irq_count = vgic_copy_lpi_list(kvm, vcpu1, &intids);
-	if (irq_count < 0)
-		return irq_count;
-
-	for (i = 0; i < irq_count; i++) {
-		irq = vgic_get_irq(kvm, NULL, intids[i]);
+	xa_for_each(&dist->lpi_xa, intid, irq) {
+		irq = vgic_get_irq(kvm, NULL, intid);
 
 		update_affinity(irq, vcpu2);
 
@@ -1447,7 +1443,6 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 
 	vgic_its_invalidate_cache(kvm);
 
-	kfree(intids);
 	return 0;
 }
 
-- 
2.44.0.rc1.240.g4c46232300-goog

