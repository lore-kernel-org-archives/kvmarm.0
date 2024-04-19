Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD1513D289
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 22:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713566357; cv=none; b=l5LUCY1DT1cfBMd9GulmugWCOHbqdoJYhsg5v/P7NXoCWYCFQySOxkNmk+d2h99C/cItdNwm2xHWv8sNnJx/V50hYMb5bz5fIE/iOHN8fkqzFcc5YHdvTp7+W96p09DTbe6AW++pt1nlrSEFCDZKC/COS8yIEtnQMdW+p3Gt2Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713566357; c=relaxed/simple;
	bh=aPJ8EsOmW+ShuVGwFxFojefQqgXUi3BYddMzeavuhgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dlj6wad1zUtZa2658mO0Uvf4BNuXd0+d6h3uoWuBDnrzV+AUn9nCXOgDNKSnTdukY+mit788C8KtOJUkBxbal0HFeYBE/DJACvXQE6b6Es2+N4BGoSHNVPCCNuY+ehrCOagyY8WXUeGzPwIanzEuSreepOuajHxd3S6WiC6+LsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Z6DXG+47; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Z6DXG+47"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713566355;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FggNVBv5Qk/uiQWX9kyA7K+xN3CA6hkYXhcHr0dYksM=;
	b=Z6DXG+47cow9UWRf+hA1A9whnW+WaObqfcbV3VocI3YMgsmXWQVq7NUCxoXKRvwOJFAvMG
	FiLOjH0Xn9wabxsTkLeDTOFMvaKUs/0NtgNzOQjcoz7nvJEPUrYhHSoldWhwgLCaraXrNq
	DJiLFCDdJHGXrena5qeieZsvcTVvyMo=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 03/19] KVM: arm64: vgic-its: Walk LPI xarray in vgic_its_invall()
Date: Fri, 19 Apr 2024 22:38:26 +0000
Message-ID: <20240419223842.951452-4-oliver.upton@linux.dev>
In-Reply-To: <20240419223842.951452-1-oliver.upton@linux.dev>
References: <20240419223842.951452-1-oliver.upton@linux.dev>
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
in vgic_its_invall().

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index bdb7718b923a..07706c5e996b 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1365,23 +1365,19 @@ static int vgic_its_cmd_handle_inv(struct kvm *kvm, struct vgic_its *its,
 int vgic_its_invall(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
-	int irq_count, i = 0;
-	u32 *intids;
-
-	irq_count = vgic_copy_lpi_list(kvm, vcpu, &intids);
-	if (irq_count < 0)
-		return irq_count;
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct vgic_irq *irq;
+	unsigned long intid;
 
-	for (i = 0; i < irq_count; i++) {
-		struct vgic_irq *irq = vgic_get_irq(kvm, NULL, intids[i]);
+	xa_for_each(&dist->lpi_xa, intid, irq) {
+		irq = vgic_get_irq(kvm, NULL, intid);
 		if (!irq)
 			continue;
+
 		update_lpi_config(kvm, irq, vcpu, false);
 		vgic_put_irq(kvm, irq);
 	}
 
-	kfree(intids);
-
 	if (vcpu->arch.vgic_cpu.vgic_v3.its_vpe.its_vm)
 		its_invall_vpe(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe);
 
-- 
2.44.0.769.g3c40516874-goog

