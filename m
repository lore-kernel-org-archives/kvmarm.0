Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0425576B
	for <kvmarm@lists.linux.dev>; Tue, 27 Feb 2024 22:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709073789; cv=none; b=ZCRGoH1J7YrX35lTEYypDSCqKpnZv5i3NwZWebQxERLGsUxR+4W6GRS8ogxu6oTgvO/b9Lc2fL6IJlSRVzh9a/rqktjj0TH0pIlx6UWEoFaTHBR6DDOOCBeEkQe8HDxQ4sQFr5zkbzzKL9jb3qOg0ilF6yYtSWyPtvQ4ABywVjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709073789; c=relaxed/simple;
	bh=RJlJI/ARX8GFsACScofTGOnqm9zBu3rNOORa5Tm8Z+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FrbJHKL5tlqE6MseXWlJL8NIiEVor9E/5ino85niaJytiPd7BZRAx+1FO6hx7K7LTlUdDdr1H0AdfGhl4aSvXRc/FP0EY1RoQEOkBc5mApnrj+NTeIz/+ZFSJq9BHaUK3yknrLuDdgXuwB278DiCfeROkza5n1nH/hBY/rDG0sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gO1mWRQO; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gO1mWRQO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709073785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V796tR5sORaBSuGtM1k3M9vAsz4ajxpDqe8oWSxjgJg=;
	b=gO1mWRQOo6+YNAycJ2BcJ29meCb+El5TmO3Mkbk/JODvw18HvZ7/tPAhZqfHA151MPqT9c
	rnISxoiXselZZTU5yLUCpi1j2t8CATLm7EQgQBOp+xWd3ogJsNn6961d/XchBYhCGG5Bwo
	4NJfYVnHbj/n4QN3YgAlyJUXLnyP0wQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 03/20] KVM: arm64: vgic-its: Walk LPI xarray in vgic_its_invall()
Date: Tue, 27 Feb 2024 22:42:32 +0000
Message-ID: <20240227224249.2209194-4-oliver.upton@linux.dev>
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
in vgic_its_invall().

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index af183eea8631..408600e79cd4 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1363,23 +1363,19 @@ static int vgic_its_cmd_handle_inv(struct kvm *kvm, struct vgic_its *its,
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
2.44.0.rc1.240.g4c46232300-goog

