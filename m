Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827521;
	b=Sd7QkeHHiIWwukTw4R8snoajemDSCBfFLmrHbvLsp31U8DmoRGX387fBa5S5FKk/ZqYg
	 gC4iSw6DQFHXkUA4yZ/XNdcHXfpnTbrJyriYUbDv89qce+S8mE4mIds56dG4Zw0rOoKXM
	 9amhCIoQrYB2+acYMyRKI2L8pPLWDOPYmZ8ZQP4pIRi4zcN0GPqMEOZ5E5S8PAXjLll2Z
	 CmUf56gJbx8HCPBtUAo3bHbl0i4TthYdHz0X1l43PZJFFdR2cKKhUaEvbO/ndzCTS0oAY
	 N3YEFYokw6MNO8Gn6al6ikD1nwJGEDCP4alLkdVXT9L/NBobQFb7pTM2WXHquNr24iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827521;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=+6Og+d5q4vSNXIn2vlsAgSTEs60/ZNjOZygcUkWgf08=;
	b=aFCaEXhn7euRFJc3KT4FAePUjsvJPYKJo/CcYCklQ48Wr408Rrn04QmQ60Da9gJBhy51
	 FVx90N6tjNsHRHzbt2TiCyKuC3f/aa5ZDHqlbycSIm+9n6zjGpuvmdeO6bE5FZCm8iHS3
	 id8kLRyOPE0W2NnIMNN1Zr4rwqdnTC2L5gBJzZeROcGoqfE5Kqv+Dzsjb4dy4/qv5OKXv
	 xb3qMSstvaXzhgdNW4/br5BoGrabZ8qXxsWAan1aGC0Q7gGWAdOWa4TR3NNHePO8AHwuo
	 6iP+RSn2CWVdFt82NzWPqnI1TZLnu1VpOAbfGV3f80UQsE5lWwwzOw4dpFq2MpyVBTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=F0fl+iCm;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEE5C606BA3B
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 21:25:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AEE5C606BA3B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=F0fl+iCm
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 806BD2F;
	Wed,  4 Nov 2026 13:25:15 -0800 (PST)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 40B3B3F632;
	Wed,  4 Nov 2026 13:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793827518; bh=G19VHiVImOj1mN5lRMMvKfMIGLvlEe3NRs5o+L0/QDc=;
	h=From:To:Cc:Subject:Date:From;
	b=F0fl+iCmDgOtlN5Rp6yqct0DfN7yh+UR8e6lTCpQeUfpkpubkuL29vTjtjw8aUirC
	 0kJLvbQjRIYtXzKwXOGOP1v94jxytHsyqvQuQr15c4uJny9/XQWalS6pq9DveRfd70
	 y+3WpS01lzw4QJMMDuJCGZ3ds8A+/LnHmxNtF0aI=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	Eric Auger <eric.auger@redhat.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Jackie Liu <liuyun01@kylinos.cn>,
	Jonathan Cameron <jic23@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v1] KVM: arm64: vgic: Use new IRQ type helpers in vgic_try_get_irq_ref()
Date: Wed,  4 Nov 2026 21:22:26 +0000
Message-ID: <20261104212226.3662020-1-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit eb8bce08ecb1 ("KVM: arm64: gic: Introduce interrupt type
helpers") introduced GICv3/v5-aware helpers to distinguish PPIs, SGIs,
SPIs, and LPIs.

However unlike vgic_put_irq(), vgic_try_get_irq_ref() wasn't updated and
is still using irq->intid < VGIC_MIN_LPI to detect LPIs. Although vGICv5
paths aren't referencing vgic_try_get_irq_ref() at the moment, let's
still do the correct thing and use the new irq_is_lpi() to avoid future
bugs.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
This caught my attention while looking at:
https://lore.kernel.org/kvmarm/20261102194454.4086911-9-sascha.bischoff@arm.com/
The ITS translation cache look up calls vgic_try_get_irq_ref().
The logic irq->intid < VGIC_MIN_LPI is wrong for GICv5, but since GICv5
vgic_irq->intid have the IRQ type encoded in the top bits the comparison
yields correct results by coincidence.

 arch/arm64/kvm/vgic/vgic-its.c | 6 +++---
 arch/arm64/kvm/vgic/vgic-v4.c  | 2 +-
 arch/arm64/kvm/vgic/vgic.c     | 8 ++++----
 arch/arm64/kvm/vgic/vgic.h     | 8 ++++----
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 5ce485485a11..9d3dfb0e525e 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -111,7 +111,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 	 * check that we don't add a second list entry with the same LPI.
 	 */
 	oldirq = xa_load(&dist->lpi_xa, intid);
-	if (vgic_try_get_irq_ref(oldirq)) {
+	if (vgic_try_get_irq_ref(kvm, oldirq)) {
 		/* Someone was faster with adding this LPI, lets use that. */
 		kfree(irq);
 		irq = oldirq;
@@ -560,7 +560,7 @@ static struct vgic_irq *vgic_its_check_cache(struct kvm *kvm, phys_addr_t db,
 	rcu_read_lock();
 
 	irq = xa_load(&its->translation_cache, cache_key);
-	if (!vgic_try_get_irq_ref(irq))
+	if (!vgic_try_get_irq_ref(kvm, irq))
 		irq = NULL;
 
 	rcu_read_unlock();
@@ -584,7 +584,7 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	 * its_lock, as the ITE (and the reference it holds) cannot be freed.
 	 */
 	lockdep_assert_held(&its->its_lock);
-	vgic_get_irq_ref(irq);
+	vgic_get_irq_ref(kvm, irq);
 
 	old = xa_store(&its->translation_cache, cache_key, irq, GFP_KERNEL_ACCOUNT);
 
diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index 1b7623f098e2..95b82a153134 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -524,7 +524,7 @@ static struct vgic_irq *__vgic_host_irq_get_vlpi(struct kvm *kvm, int host_irq)
 		if (!irq->hw || irq->host_irq != host_irq)
 			continue;
 
-		if (!vgic_try_get_irq_ref(irq))
+		if (!vgic_try_get_irq_ref(kvm, irq))
 			return NULL;
 
 		return irq;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index fe09ada32262..e1072b819245 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -71,7 +71,7 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u32 intid)
 	rcu_read_lock();
 
 	irq = xa_load(&dist->lpi_xa, intid);
-	if (!vgic_try_get_irq_ref(irq))
+	if (!vgic_try_get_irq_ref(kvm, irq))
 		irq = NULL;
 
 	rcu_read_unlock();
@@ -507,7 +507,7 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 	 * now in the ap_list. This is safe as the caller must already hold a
 	 * reference on the irq.
 	 */
-	vgic_get_irq_ref(irq);
+	vgic_get_irq_ref(kvm, irq);
 	list_add_tail(&irq->ap_list, &vcpu->arch.vgic_cpu.ap_list_head);
 	irq->vcpu = vcpu;
 
@@ -817,7 +817,7 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 		 * This interrupt looks like it has to be migrated,
 		 * make sure it is kept alive while locks are dropped.
 		 */
-		vgic_get_irq_ref(irq);
+		vgic_get_irq_ref(vcpu->kvm, irq);
 
 		raw_spin_unlock(&irq->irq_lock);
 		raw_spin_unlock(&vgic_cpu->ap_list_lock);
@@ -1049,7 +1049,7 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 			if (likely(vgic_target_oracle(irq) == vcpu)) {
 				vgic_populate_lr(vcpu, irq, count++);
 				if (count == kvm_vgic_global_state.nr_lr) {
-					vgic_get_irq_ref(irq);
+					vgic_get_irq_ref(vcpu->kvm, irq);
 					*host_data_ptr(last_lr_irq) = irq;
 				}
 			}
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 71c481ddd98d..fe7b508ce172 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -320,20 +320,20 @@ void vgic_v2_put(struct kvm_vcpu *vcpu);
 void vgic_v2_save_state(struct kvm_vcpu *vcpu);
 void vgic_v2_restore_state(struct kvm_vcpu *vcpu);
 
-static inline bool vgic_try_get_irq_ref(struct vgic_irq *irq)
+static inline bool vgic_try_get_irq_ref(struct kvm *kvm, struct vgic_irq *irq)
 {
 	if (!irq)
 		return false;
 
-	if (irq->intid < VGIC_MIN_LPI)
+	if (!irq_is_lpi(kvm, irq->intid))
 		return true;
 
 	return refcount_inc_not_zero(&irq->refcount);
 }
 
-static inline void vgic_get_irq_ref(struct vgic_irq *irq)
+static inline void vgic_get_irq_ref(struct kvm *kvm, struct vgic_irq *irq)
 {
-	WARN_ON_ONCE(!vgic_try_get_irq_ref(irq));
+	WARN_ON_ONCE(!vgic_try_get_irq_ref(kvm, irq));
 }
 
 void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu);
-- 
2.43.0

