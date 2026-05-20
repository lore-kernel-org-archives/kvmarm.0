Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841BF3B6C0E
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 09:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779268814; cv=none; b=cX2FbTZ7CsEviEZes3VXXWObEfwQUUylFZNA9uBqTRTyjrSI1IloOOQlIdPqywA245iveB2C/jbVAAQwI3TJ3lAHoW3YmqkNYtpwyJ88qLMHPOeRCqKy0Utbp+9GKPM6I1K+inBXpm5Fh55gtrydT2wWQjeCL7yL+dgF0Qi19+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779268814; c=relaxed/simple;
	bh=96VNcfcAOKx179M//vuW6V7jcQGc/LjE1T/SragukLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8h7B3oa/PYcDexhxf0KIVK4jbCQV7SVsr3xnvOlmP4D07yQucEBOOG08iFXRTMOOUfuBRemx4+XWkRUrTFStKLM/qCkuiNJ2MWi+YgHatmzgxNBfYEJP9QlZ1aeosI403yE/kgaqjRvOmbUvCS+9H8/ssC1KiiYw2PMehz4JvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b37zcHUI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b37zcHUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B601F00894;
	Wed, 20 May 2026 09:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779268812;
	bh=d/JlcUjNjLjulQ9vEDBIuWcS1+FjD6s/DiGmeKXzMZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b37zcHUIMWJHRRwZePi1aAt3excKPi1uHm6003yNhOEg9bXCEfjpPkPVEPhZzVo2K
	 xGpPkyn2zspgQdgoiiLQ9kQq9PsEmr0lMvMY1IBRYH/vS+VyAGQS4YbI5vvWX+Yx/4
	 j0mYn3hDuJIbbc7YRCfa90vqS1224qjJSXchMS7MABr118a2bXp2AQB5dTZPYYE2H6
	 33/yLsO36baeI25mYaA2760VVuJALaIRI2SvyrHQmz+pBNNahFvyp6AKwtoIaMNomd
	 irQkiH5/uNCyUpaivHmHNhQh4tclIbjsduvVAT9NM/UEYoAqznZdjlcgyj4RCALinh
	 RKDn9QNvos1xA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPd62-00000004IaV-1faw;
	Wed, 20 May 2026 09:20:10 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH v2 01/18] KVM: arm64: vgic-v5: Add for_each_visible_v5_ppi() iterator
Date: Wed, 20 May 2026 10:19:32 +0100
Message-ID: <20260520091949.542365-2-maz@kernel.org>
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

We have multiple instances of iterators walking the vgic_ppi_mask
mask, and the way it is written has a tendency to make one's eyes
bleed.

Factor it as a helper and use that across the code base.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c     |  2 +-
 arch/arm64/kvm/vgic/vgic-v5.c | 10 ++++------
 arch/arm64/kvm/vgic/vgic.h    |  3 +++
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 148fc3400ea81..513f5f1429b5f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -751,7 +751,7 @@ static bool access_gicv5_ppi_enabler(struct kvm_vcpu *vcpu,
 	 * Sync the change in enable states to the vgic_irqs. We consider all
 	 * PPIs as we don't expose many to the guest.
 	 */
-	for_each_set_bit(i, mask, VGIC_V5_NR_PRIVATE_IRQS) {
+	for_each_visible_v5_ppi(i, vcpu->kvm) {
 		u32 intid = vgic_v5_make_ppi(i);
 		struct vgic_irq *irq;
 
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index fdd39ea7f83ec..c0d36658ffe74 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -316,7 +316,7 @@ static void vgic_v5_sync_ppi_priorities(struct kvm_vcpu *vcpu)
 	 * those actually exposed to the guest by first iterating over the mask
 	 * of exposed PPIs.
 	 */
-	for_each_set_bit(i, vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS) {
+	for_each_visible_v5_ppi(i, vcpu->kvm) {
 		u32 intid = vgic_v5_make_ppi(i);
 		struct vgic_irq *irq;
 		int pri_idx, pri_reg, pri_bit;
@@ -358,7 +358,7 @@ bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu)
 	if (!priority_mask)
 		return false;
 
-	for_each_set_bit(i, vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS) {
+	for_each_visible_v5_ppi(i, vcpu->kvm) {
 		u32 intid = vgic_v5_make_ppi(i);
 		bool has_pending = false;
 		struct vgic_irq *irq;
@@ -391,8 +391,7 @@ void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu)
 	activer = host_data_ptr(vgic_v5_ppi_state)->activer_exit;
 	pendr = host_data_ptr(vgic_v5_ppi_state)->pendr;
 
-	for_each_set_bit(i, vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask,
-			 VGIC_V5_NR_PRIVATE_IRQS) {
+	for_each_visible_v5_ppi(i, vcpu->kvm) {
 		u32 intid = vgic_v5_make_ppi(i);
 		struct vgic_irq *irq;
 
@@ -429,8 +428,7 @@ void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
 	 * ICC_PPI_PENDRx_EL1, however.
 	 */
 	bitmap_zero(pendr, VGIC_V5_NR_PRIVATE_IRQS);
-	for_each_set_bit(i, vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask,
-			 VGIC_V5_NR_PRIVATE_IRQS) {
+	for_each_visible_v5_ppi(i, vcpu->kvm) {
 		u32 intid = vgic_v5_make_ppi(i);
 		struct vgic_irq *irq;
 
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 9d941241c8a2b..f45f7e3ec4d6e 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -378,6 +378,9 @@ void vgic_v5_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v5_restore_state(struct kvm_vcpu *vcpu);
 void vgic_v5_save_state(struct kvm_vcpu *vcpu);
 
+#define for_each_visible_v5_ppi(__i, __k)		\
+	for_each_set_bit(__i, (__k)->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS)
+
 static inline int vgic_v3_max_apr_idx(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *cpu_if = &vcpu->arch.vgic_cpu;
-- 
2.47.3

