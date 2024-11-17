Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447B51DA31F
	for <kvmarm@lists.linux.dev>; Sun, 17 Nov 2024 16:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731862684; cv=none; b=bDz7yhnQjWzzbXFshpAd8iJgfeWWfdp9W+2CKRt6d/g//aG/IXOe9uSdnQWuosiYYSCwdNoql13zfbG52ZoZ5weENOY6i29rcMcAOf2P9OWpmxzgWyxuude64GDY0ipn6GQw1lbu375e4fVcQhJuEdqVkk6XXKJrX2CTTCgyYi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731862684; c=relaxed/simple;
	bh=er1apRZxsuOToYSVSNSfMOdot8PRgMxEILxC3gGJczE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O6Uz6GduKNTegcUEI5Kx9gTLQrl71Z6EzRZNrjdEr9trGjiAsgUMJfHJ0iWJWxE3G7zOxeI4c7fPQEtyOvNgRdskLK+yqY7/Ai1HXhca0tuAg8J1hDYfdrvSTMJXsN+eBDqWOgL4DP6XAI70upeFPYViQPiKUqATqKZzPN+/d9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F7svWC9/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F7svWC9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE2AC4CED9;
	Sun, 17 Nov 2024 16:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731862683;
	bh=er1apRZxsuOToYSVSNSfMOdot8PRgMxEILxC3gGJczE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F7svWC9/QUlByhEh85FqZ1Zoc07eZfE7kZx0LvAlnkvWgpTeCOwhuv4SE2y1gj6rT
	 3ngHFFJ3CvzeGHGq0EilGn6cQBVWExmjJ3zonT8124eTz5nc9ZbA0jzrepFjHCMEq8
	 vgZYBhH+Tfa6btqATNrcx//NbEPL9MMrRQHbbYnDeXaCFxeWqepPq4wyCmKAfBEi5U
	 e7AYwLeQnG+gT/ZXny0o5UjyptT3w4iIjBnM3ePEzANyfqzBeySyP9yU88Pcfp1O/+
	 sKzbqepbH+bDeyHG3nXFJnX4vAx9qxvq7hZp//L14mF9ugmpeEKsp07YhJPM88sY65
	 9TE6Wok4M0tww==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tCib3-00DYt6-HD;
	Sun, 17 Nov 2024 16:58:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 2/4] KVM: arm64: vgic: Make vgic_get_irq() more robust
Date: Sun, 17 Nov 2024 16:57:55 +0000
Message-Id: <20241117165757.247686-3-maz@kernel.org>
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

vgic_get_irq() has an awkward signature, as it takes both a kvm
*and* a vcpu, where the vcpu is allowed to be NULL if the INTID
being looked up is a global interrupt (SPI or LPI).

This leads to potentially problematic situations where the INTID
passed is a private interrupt, but that there is no vcpu.

In order to make things less ambiguous, let have *two* helpers
instead:

- vgic_get_irq(struct kvm *kvm, u32 intid), which is only concerned
  with *global* interrupts, as indicated by the lack of vcpu.

- vgic_get_vcpu_irq(struct kvm_vcpu *vcpu, u32 intid), which can
  return *any* interrupt class, but must have of course a non-NULL
  vcpu.

Most of the code nicely falls under one or the other situations,
except for a couple of cases (close to the UABI or in the debug code)
where we have to distinguish between the two cases.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-debug.c   |  5 +++-
 arch/arm64/kvm/vgic/vgic-init.c    |  2 +-
 arch/arm64/kvm/vgic/vgic-its.c     |  8 +++---
 arch/arm64/kvm/vgic/vgic-mmio-v2.c | 12 ++++-----
 arch/arm64/kvm/vgic/vgic-mmio-v3.c |  8 +++---
 arch/arm64/kvm/vgic/vgic-mmio.c    | 38 +++++++++++++-------------
 arch/arm64/kvm/vgic/vgic-v2.c      |  2 +-
 arch/arm64/kvm/vgic/vgic-v3.c      |  2 +-
 arch/arm64/kvm/vgic/vgic-v4.c      |  4 +--
 arch/arm64/kvm/vgic/vgic.c         | 43 +++++++++++++++++++-----------
 arch/arm64/kvm/vgic/vgic.h         |  4 +--
 11 files changed, 71 insertions(+), 57 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index e1397ab2072a5..afb018528bc3b 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -287,7 +287,10 @@ static int vgic_debug_show(struct seq_file *s, void *v)
 	 * Expect this to succeed, as iter_mark_lpis() takes a reference on
 	 * every LPI to be visited.
 	 */
-	irq = vgic_get_irq(kvm, vcpu, iter->intid);
+	if (iter->intid < VGIC_NR_PRIVATE_IRQS)
+		irq = vgic_get_vcpu_irq(vcpu, iter->intid);
+	else
+		irq = vgic_get_irq(kvm, iter->intid);
 	if (WARN_ON_ONCE(!irq))
 		return -EINVAL;
 
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 48c952563e85f..bc7e22ab5d812 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -322,7 +322,7 @@ int vgic_init(struct kvm *kvm)
 			goto out;
 
 		for (i = 0; i < VGIC_NR_PRIVATE_IRQS; i++) {
-			struct vgic_irq *irq = vgic_get_irq(kvm, vcpu, i);
+			struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, i);
 
 			switch (dist->vgic_model) {
 			case KVM_DEV_TYPE_ARM_VGIC_V3:
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 198296933e7eb..79c40708b6646 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -42,7 +42,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 				     struct kvm_vcpu *vcpu)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
-	struct vgic_irq *irq = vgic_get_irq(kvm, NULL, intid), *oldirq;
+	struct vgic_irq *irq = vgic_get_irq(kvm, intid), *oldirq;
 	unsigned long flags;
 	int ret;
 
@@ -419,7 +419,7 @@ static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
 			last_byte_offset = byte_offset;
 		}
 
-		irq = vgic_get_irq(vcpu->kvm, NULL, intid);
+		irq = vgic_get_irq(vcpu->kvm, intid);
 		if (!irq)
 			continue;
 
@@ -1288,7 +1288,7 @@ int vgic_its_invall(struct kvm_vcpu *vcpu)
 	unsigned long intid;
 
 	xa_for_each(&dist->lpi_xa, intid, irq) {
-		irq = vgic_get_irq(kvm, NULL, intid);
+		irq = vgic_get_irq(kvm, intid);
 		if (!irq)
 			continue;
 
@@ -1354,7 +1354,7 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 		return 0;
 
 	xa_for_each(&dist->lpi_xa, intid, irq) {
-		irq = vgic_get_irq(kvm, NULL, intid);
+		irq = vgic_get_irq(kvm, intid);
 		if (!irq)
 			continue;
 
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v2.c b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
index e070cda86e12f..f25fccb1f8e63 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
@@ -148,7 +148,7 @@ static void vgic_mmio_write_sgir(struct kvm_vcpu *source_vcpu,
 		if (!(targets & (1U << c)))
 			continue;
 
-		irq = vgic_get_irq(source_vcpu->kvm, vcpu, intid);
+		irq = vgic_get_vcpu_irq(vcpu, intid);
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 		irq->pending_latch = true;
@@ -167,7 +167,7 @@ static unsigned long vgic_mmio_read_target(struct kvm_vcpu *vcpu,
 	u64 val = 0;
 
 	for (i = 0; i < len; i++) {
-		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+		struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, intid + i);
 
 		val |= (u64)irq->targets << (i * 8);
 
@@ -191,7 +191,7 @@ static void vgic_mmio_write_target(struct kvm_vcpu *vcpu,
 		return;
 
 	for (i = 0; i < len; i++) {
-		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, NULL, intid + i);
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, intid + i);
 		int target;
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
@@ -213,7 +213,7 @@ static unsigned long vgic_mmio_read_sgipend(struct kvm_vcpu *vcpu,
 	u64 val = 0;
 
 	for (i = 0; i < len; i++) {
-		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+		struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, intid + i);
 
 		val |= (u64)irq->source << (i * 8);
 
@@ -231,7 +231,7 @@ static void vgic_mmio_write_sgipendc(struct kvm_vcpu *vcpu,
 	unsigned long flags;
 
 	for (i = 0; i < len; i++) {
-		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+		struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, intid + i);
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 
@@ -253,7 +253,7 @@ static void vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
 	unsigned long flags;
 
 	for (i = 0; i < len; i++) {
-		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+		struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, intid + i);
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 70a44852cbafe..ae4c0593d1145 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -194,7 +194,7 @@ static unsigned long vgic_mmio_read_irouter(struct kvm_vcpu *vcpu,
 					    gpa_t addr, unsigned int len)
 {
 	int intid = VGIC_ADDR_TO_INTID(addr, 64);
-	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, NULL, intid);
+	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, intid);
 	unsigned long ret = 0;
 
 	if (!irq)
@@ -220,7 +220,7 @@ static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
 	if (addr & 4)
 		return;
 
-	irq = vgic_get_irq(vcpu->kvm, NULL, intid);
+	irq = vgic_get_irq(vcpu->kvm, intid);
 
 	if (!irq)
 		return;
@@ -548,7 +548,7 @@ static void vgic_mmio_write_invlpi(struct kvm_vcpu *vcpu,
 
 	vgic_set_rdist_busy(vcpu, true);
 
-	irq = vgic_get_irq(vcpu->kvm, NULL, intid);
+	irq = vgic_get_irq(vcpu->kvm, intid);
 	if (irq) {
 		vgic_its_inv_lpi(vcpu->kvm, irq);
 		vgic_put_irq(vcpu->kvm, irq);
@@ -1025,7 +1025,7 @@ int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
 
 static void vgic_v3_queue_sgi(struct kvm_vcpu *vcpu, u32 sgi, bool allow_group1)
 {
-	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, sgi);
+	struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, sgi);
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&irq->irq_lock, flags);
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index cf76523a21945..e416e433baff3 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -50,7 +50,7 @@ unsigned long vgic_mmio_read_group(struct kvm_vcpu *vcpu,
 
 	/* Loop over all IRQs affected by this read */
 	for (i = 0; i < len * 8; i++) {
-		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+		struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, intid + i);
 
 		if (irq->group)
 			value |= BIT(i);
@@ -74,7 +74,7 @@ void vgic_mmio_write_group(struct kvm_vcpu *vcpu, gpa_t addr,
 	unsigned long flags;
 
 	for (i = 0; i < len * 8; i++) {
-		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+		struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, intid + i);
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 		irq->group = !!(val & BIT(i));
@@ -102,7 +102,7 @@ unsigned long vgic_mmio_read_enable(struct kvm_vcpu *vcpu,
 
 	/* Loop over all IRQs affected by this read */
 	for (i = 0; i < len * 8; i++) {
-		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+		struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, intid + i);
 
 		if (irq->enabled)
 			value |= (1U << i);
@@ -122,7 +122,7 @@ void vgic_mmio_write_senable(struct kvm_vcpu *vcpu,
 	unsigned long flags;
 
 	for_each_set_bit(i, &val, len * 8) {
-		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+		struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, intid + i);
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
@@ -171,7 +171,7 @@ void vgic_mmio_write_cenable(struct kvm_vcpu *vcpu,
 	unsigned long flags;
 
 	for_each_set_bit(i, &val, len * 8) {
-		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+		struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, intid + i);
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 		if (irq->hw && vgic_irq_is_sgi(irq->intid) && irq->enabled)
@@ -193,7 +193,7 @@ int vgic_uaccess_write_senable(struct kvm_vcpu *vcpu,
 	unsigned long flags;
 
 	for_each_set_bit(i, &val, len * 8) {
-		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+		struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, intid + i);
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 		irq->enabled = true;
@@ -214,7 +214,7 @@ int vgic_uaccess_write_cenable(struct kvm_vcpu *vcpu,
 	unsigned long flags;
 
 	for_each_set_bit(i, &val, len * 8) {
-		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+		struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, intid + i);
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 		irq->enabled = false;
@@ -236,7 +236,7 @@ static unsigned long __read_pending(struct kvm_vcpu *vcpu,
 
 	/* Loop over all IRQs affected by this read */
 	for (i = 0; i < len * 8; i++) {
-		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+		struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, intid + i);
 		unsigned long flags;
 		bool val;
 
@@ -309,7 +309,7 @@ static void __set_pending(struct kvm_vcpu *vcpu, gpa_t addr, unsigned int len,
 	unsigned long flags;
 
 	for_each_set_bit(i, &val, len * 8) {
-		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+		struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, intid + i);
 
 		/* GICD_ISPENDR0 SGI bits are WI when written from the guest. */
 		if (is_vgic_v2_sgi(vcpu, irq) && !is_user) {
@@ -395,7 +395,7 @@ static void __clear_pending(struct kvm_vcpu *vcpu,
 	unsigned long flags;
 
 	for_each_set_bit(i, &val, len * 8) {
-		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+		struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, intid + i);
 
 		/* GICD_ICPENDR0 SGI bits are WI when written from the guest. */
 		if (is_vgic_v2_sgi(vcpu, irq) && !is_user) {
@@ -494,7 +494,7 @@ static unsigned long __vgic_mmio_read_active(struct kvm_vcpu *vcpu,
 
 	/* Loop over all IRQs affected by this read */
 	for (i = 0; i < len * 8; i++) {
-		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+		struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, intid + i);
 
 		/*
 		 * Even for HW interrupts, don't evaluate the HW state as
@@ -598,7 +598,7 @@ static void __vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
 	int i;
 
 	for_each_set_bit(i, &val, len * 8) {
-		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+		struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, intid + i);
 		vgic_mmio_change_active(vcpu, irq, false);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
@@ -635,7 +635,7 @@ static void __vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
 	int i;
 
 	for_each_set_bit(i, &val, len * 8) {
-		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+		struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, intid + i);
 		vgic_mmio_change_active(vcpu, irq, true);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
@@ -672,7 +672,7 @@ unsigned long vgic_mmio_read_priority(struct kvm_vcpu *vcpu,
 	u64 val = 0;
 
 	for (i = 0; i < len; i++) {
-		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+		struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, intid + i);
 
 		val |= (u64)irq->priority << (i * 8);
 
@@ -698,7 +698,7 @@ void vgic_mmio_write_priority(struct kvm_vcpu *vcpu,
 	unsigned long flags;
 
 	for (i = 0; i < len; i++) {
-		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+		struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, intid + i);
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 		/* Narrow the priority range to what we actually support */
@@ -719,7 +719,7 @@ unsigned long vgic_mmio_read_config(struct kvm_vcpu *vcpu,
 	int i;
 
 	for (i = 0; i < len * 4; i++) {
-		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+		struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, intid + i);
 
 		if (irq->config == VGIC_CONFIG_EDGE)
 			value |= (2U << (i * 2));
@@ -750,7 +750,7 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
 		if (intid + i < VGIC_NR_PRIVATE_IRQS)
 			continue;
 
-		irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+		irq = vgic_get_irq(vcpu->kvm, intid + i);
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 
 		if (test_bit(i * 2 + 1, &val))
@@ -775,7 +775,7 @@ u32 vgic_read_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid)
 		if ((intid + i) < VGIC_NR_SGIS || (intid + i) >= nr_irqs)
 			continue;
 
-		irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+		irq = vgic_get_vcpu_irq(vcpu, intid + i);
 		if (irq->config == VGIC_CONFIG_LEVEL && irq->line_level)
 			val |= (1U << i);
 
@@ -799,7 +799,7 @@ void vgic_write_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid,
 		if ((intid + i) < VGIC_NR_SGIS || (intid + i) >= nr_irqs)
 			continue;
 
-		irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+		irq = vgic_get_vcpu_irq(vcpu, intid + i);
 
 		/*
 		 * Line level is set irrespective of irq type
diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index ae5a44d5702d1..381673f03c395 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -72,7 +72,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 			kvm_notify_acked_irq(vcpu->kvm, 0,
 					     intid - VGIC_NR_PRIVATE_IRQS);
 
-		irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
+		irq = vgic_get_vcpu_irq(vcpu, intid);
 
 		raw_spin_lock(&irq->irq_lock);
 
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index b217b256853c2..f267bc2486a18 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -65,7 +65,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 			kvm_notify_acked_irq(vcpu->kvm, 0,
 					     intid - VGIC_NR_PRIVATE_IRQS);
 
-		irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
+		irq = vgic_get_vcpu_irq(vcpu, intid);
 		if (!irq)	/* An LPI could have been unmapped. */
 			continue;
 
diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index 74a67ad87f29d..eedecbbbcf31b 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -123,7 +123,7 @@ static void vgic_v4_enable_vsgis(struct kvm_vcpu *vcpu)
 	 * IRQ. The SGI code will do its magic.
 	 */
 	for (i = 0; i < VGIC_NR_SGIS; i++) {
-		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, i);
+		struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, i);
 		struct irq_desc *desc;
 		unsigned long flags;
 		int ret;
@@ -160,7 +160,7 @@ static void vgic_v4_disable_vsgis(struct kvm_vcpu *vcpu)
 	int i;
 
 	for (i = 0; i < VGIC_NR_SGIS; i++) {
-		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, i);
+		struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, i);
 		struct irq_desc *desc;
 		unsigned long flags;
 		int ret;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index f50274fd55815..ffaa52448b6f8 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -84,17 +84,11 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u32 intid)
  * struct vgic_irq. It also increases the refcount, so any caller is expected
  * to call vgic_put_irq() once it's finished with this IRQ.
  */
-struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
-			      u32 intid)
+struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid)
 {
-	/* SGIs and PPIs */
-	if (intid <= VGIC_MAX_PRIVATE) {
-		intid = array_index_nospec(intid, VGIC_MAX_PRIVATE + 1);
-		return &vcpu->arch.vgic_cpu.private_irqs[intid];
-	}
-
 	/* SPIs */
-	if (intid < (kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS)) {
+	if (intid >= VGIC_NR_PRIVATE_IRQS &&
+	    intid < (kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS)) {
 		intid = array_index_nospec(intid, kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS);
 		return &kvm->arch.vgic.spis[intid - VGIC_NR_PRIVATE_IRQS];
 	}
@@ -106,6 +100,20 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	return NULL;
 }
 
+struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *vcpu, u32 intid)
+{
+	if (WARN_ON(!vcpu))
+		return NULL;
+
+	/* SGIs and PPIs */
+	if (intid <= VGIC_MAX_PRIVATE) {
+		intid = array_index_nospec(intid, VGIC_MAX_PRIVATE + 1);
+		return &vcpu->arch.vgic_cpu.private_irqs[intid];
+	}
+
+	return vgic_get_irq(vcpu->kvm, intid);
+}
+
 /*
  * We can't do anything in here, because we lack the kvm pointer to
  * lock and remove the item from the lpi_list. So we keep this function
@@ -437,7 +445,10 @@ int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 
 	trace_vgic_update_irq_pending(vcpu ? vcpu->vcpu_idx : 0, intid, level);
 
-	irq = vgic_get_irq(kvm, vcpu, intid);
+	if (intid < VGIC_NR_PRIVATE_IRQS)
+		irq = vgic_get_vcpu_irq(vcpu, intid);
+	else
+		irq = vgic_get_irq(kvm, intid);
 	if (!irq)
 		return -EINVAL;
 
@@ -499,7 +510,7 @@ static inline void kvm_vgic_unmap_irq(struct vgic_irq *irq)
 int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
 			  u32 vintid, struct irq_ops *ops)
 {
-	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
+	struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, vintid);
 	unsigned long flags;
 	int ret;
 
@@ -524,7 +535,7 @@ int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
  */
 void kvm_vgic_reset_mapped_irq(struct kvm_vcpu *vcpu, u32 vintid)
 {
-	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
+	struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, vintid);
 	unsigned long flags;
 
 	if (!irq->hw)
@@ -547,7 +558,7 @@ int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid)
 	if (!vgic_initialized(vcpu->kvm))
 		return -EAGAIN;
 
-	irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
+	irq = vgic_get_vcpu_irq(vcpu, vintid);
 	BUG_ON(!irq);
 
 	raw_spin_lock_irqsave(&irq->irq_lock, flags);
@@ -560,7 +571,7 @@ int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid)
 
 int kvm_vgic_get_map(struct kvm_vcpu *vcpu, unsigned int vintid)
 {
-	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
+	struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, vintid);
 	unsigned long flags;
 	int ret = -1;
 
@@ -596,7 +607,7 @@ int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned int intid, void *owner)
 	if (!irq_is_ppi(intid) && !vgic_valid_spi(vcpu->kvm, intid))
 		return -EINVAL;
 
-	irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
+	irq = vgic_get_vcpu_irq(vcpu, intid);
 	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 	if (irq->owner && irq->owner != owner)
 		ret = -EEXIST;
@@ -1008,7 +1019,7 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid)
 	if (!vgic_initialized(vcpu->kvm))
 		return false;
 
-	irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
+	irq = vgic_get_vcpu_irq(vcpu, vintid);
 	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 	map_is_active = irq->hw && irq->active;
 	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 309295f5e1b07..8290f3276cf07 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -202,8 +202,8 @@ int vgic_v2_parse_attr(struct kvm_device *dev, struct kvm_device_attr *attr,
 const struct vgic_register_region *
 vgic_get_mmio_region(struct kvm_vcpu *vcpu, struct vgic_io_device *iodev,
 		     gpa_t addr, int len);
-struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
-			      u32 intid);
+struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid);
+struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *vcpu, u32 intid);
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq);
 bool vgic_get_phys_line_level(struct vgic_irq *irq);
 void vgic_irq_set_phys_pending(struct vgic_irq *irq, bool pending);
-- 
2.39.2

