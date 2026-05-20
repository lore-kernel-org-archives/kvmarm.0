Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612B03BED79
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 09:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779268817; cv=none; b=M3v7Zo6eAfV4NbBH2qnnmnJRl96thQvVDBR6EH1+c7qDP2RCT/C3GJYK48BWRSwqkIGqgVnkNmy7zvsSabDT3X8Rme8JYgket+NMMw9TgdoBigSrrFBjlVtXtbegqjbUW5NCCYw6X08xE6uvsOLxNA7m+DqgKmBd8Gl9Jv+qchE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779268817; c=relaxed/simple;
	bh=kvRfycaZDSggSPfdRhmD3S0u3GFFUyi419jgkqqwWpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVsgukv959zpgZG/O9yNfL0Ss05PV4mX7nHqI5/VkubAdYz1oh7Qf/X7NsCto1eWY3Ij1g+cnuosgES4xSfJJKl95U2fFPjGh5nl0lpr82FpGBtJBlHGVqa8Ml4iByG0Kw+Awm/BdMPxjR4l9w+YSwVfFr0awQMWut5/yP4ndRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cLV3pc9/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cLV3pc9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2984F1F00898;
	Wed, 20 May 2026 09:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779268813;
	bh=1TIzKuY83q97U1U+0f8lUwk8XwQIwJ6OrTSRAlmEejI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cLV3pc9/PX5HDAD/BE3FqjE0SYANog0dx37qTlsgIML1uUo11+E71W5YzJ9XnCPG1
	 TgwBt95CzdT+hVKA/Tv0pbL1IMGMHu8Drxyzj9uPOArpi1W8az8LvkX+PAD5zYbbRP
	 169iYbXYnc3pBqNBVQpj4GGO7/TNyDiMaMLAeNI8aKjeG+SfErvAW2WnDMcKuGWNk2
	 o6QO/csRcuXIrb7B8v//rLRtI2KhfMAF15EagxYoJ6EFgmGflXDSZcRFy2HjZFIEnF
	 r/hdLJcoZeF7A++kkc1X/+zba4o7l69zghrCUYhXVBVk9NpDpUFNPdgLNb5HVhRiSc
	 LM5ighT0q3nqA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPd63-00000004IaV-1nFT;
	Wed, 20 May 2026 09:20:11 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH v2 06/18] KVM: arm64: vgic: Consolidate vgic_allocate_private_irqs_locked()
Date: Wed, 20 May 2026 10:19:37 +0100
Message-ID: <20260520091949.542365-7-maz@kernel.org>
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

vgic_allocate_private_irqs_locked() calls two helpers, oddly named
vgic_{,v5_}allocate_private_irq().

Not only these helpers don't allocate anything, but they also
contain duplicate init code that would be better placed in the
caller.

Consolidate the common init code in the caller, rename the helpers
to vgic_{,v5_}setup_private_irq(), and pass the irq pointer around
instead of the index of the interrupt.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-init.c | 45 +++++++++++++--------------------
 1 file changed, 18 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 933983bb20052..907057881b26a 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -271,18 +271,12 @@ int kvm_vgic_vcpu_nv_init(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-static void vgic_allocate_private_irq(struct kvm_vcpu *vcpu, int i, u32 type)
+static void vgic_setup_private_irq(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
+				   u32 type)
 {
-	struct vgic_irq *irq = &vcpu->arch.vgic_cpu.private_irqs[i];
+	irq->intid = irq - &vcpu->arch.vgic_cpu.private_irqs[0];
 
-	INIT_LIST_HEAD(&irq->ap_list);
-	raw_spin_lock_init(&irq->irq_lock);
-	irq->vcpu = NULL;
-	irq->target_vcpu = vcpu;
-	refcount_set(&irq->refcount, 0);
-
-	irq->intid = i;
-	if (vgic_irq_is_sgi(i)) {
+	if (vgic_irq_is_sgi(irq->intid)) {
 		/* SGIs */
 		irq->enabled = 1;
 		irq->config = VGIC_CONFIG_EDGE;
@@ -303,18 +297,11 @@ static void vgic_allocate_private_irq(struct kvm_vcpu *vcpu, int i, u32 type)
 	}
 }
 
-static void vgic_v5_allocate_private_irq(struct kvm_vcpu *vcpu, int i, u32 type)
+static void vgic_v5_setup_private_irq(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
 {
-	struct vgic_irq *irq = &vcpu->arch.vgic_cpu.private_irqs[i];
-	u32 intid = vgic_v5_make_ppi(i);
-
-	INIT_LIST_HEAD(&irq->ap_list);
-	raw_spin_lock_init(&irq->irq_lock);
-	irq->vcpu = NULL;
-	irq->target_vcpu = vcpu;
-	refcount_set(&irq->refcount, 0);
+	int i = irq - &vcpu->arch.vgic_cpu.private_irqs[0];
 
-	irq->intid = intid;
+	irq->intid = vgic_v5_make_ppi(i);
 
 	/* The only Edge architected PPI is the SW_PPI */
 	if (i == GICV5_ARCH_PPI_SW_PPI)
@@ -323,7 +310,7 @@ static void vgic_v5_allocate_private_irq(struct kvm_vcpu *vcpu, int i, u32 type)
 		irq->config = VGIC_CONFIG_LEVEL;
 
 	/* Register the GICv5-specific PPI ops */
-	vgic_v5_set_ppi_ops(vcpu, intid);
+	vgic_v5_set_ppi_ops(vcpu, irq->intid);
 }
 
 static int vgic_allocate_private_irqs_locked(struct kvm_vcpu *vcpu, u32 type)
@@ -349,15 +336,19 @@ static int vgic_allocate_private_irqs_locked(struct kvm_vcpu *vcpu, u32 type)
 	if (!vgic_cpu->private_irqs)
 		return -ENOMEM;
 
-	/*
-	 * Enable and configure all SGIs to be edge-triggered and
-	 * configure all PPIs as level-triggered.
-	 */
 	for (i = 0; i < num_private_irqs; i++) {
+		struct vgic_irq *irq = &vcpu->arch.vgic_cpu.private_irqs[i];
+
+		INIT_LIST_HEAD(&irq->ap_list);
+		raw_spin_lock_init(&irq->irq_lock);
+		irq->vcpu = NULL;
+		irq->target_vcpu = vcpu;
+		refcount_set(&irq->refcount, 0);
+
 		if (vgic_is_v5(vcpu->kvm))
-			vgic_v5_allocate_private_irq(vcpu, i, type);
+			vgic_v5_setup_private_irq(vcpu, irq);
 		else
-			vgic_allocate_private_irq(vcpu, i, type);
+			vgic_setup_private_irq(vcpu, irq, type);
 	}
 
 	return 0;
-- 
2.47.3

