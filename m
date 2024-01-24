Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862771350ED
	for <kvmarm@lists.linux.dev>; Wed, 24 Jan 2024 20:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706129384; cv=none; b=T0kSagf46xcv5r5zya5bn3fbRGaVOHDbBC5YNZ5SDWp4pxq/K+ZWNoE44p3WzUh8Dg/p6qSw7UshxIa7hY4Qt0/jdwr6fNz2nzbdVXMzvyXd48ujn61BqQikM9Doi2J1rlHPaHivKaxGJTe3SgkwogAOmw+YLTBhiDKMeUkffpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706129384; c=relaxed/simple;
	bh=AaUwQqfc4Ku5CZrkEkRiMftjazrtuY7bOsUzVzb64Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwB5FQu7Xsz4XH7NCqs2L49Z0vYMLSAmlNkSnf7oMTwHPPX2EV2IRGTzyTLAAb68F/b8tHSnP4mh7go30tsqMP5ppfcpaVhL34o+GzcEGP3YTA0sklI0uvUURXuXrDDLuMnc1T2VURlR8nJ6KN2OsVEUyR4e6oV+iPUggR3i+1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cMlnq2Zn; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cMlnq2Zn"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706129378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LxxqEpTwO+zOxGEx/S+lcOqJ8/x3pVGgz89u4x3XNnQ=;
	b=cMlnq2ZnRx9gK/QCKmQw4yHzghedLSRfeCu9QAVj+8ifMd90nhmuiaAnAb2IP73EGYHFqK
	m3voIsdj+ElcUbBYHsyPeyOB/apHaOdUC4cJHM8Wt0FfXdiHBJCQ9zS/N6r2xB2Ih6AXEz
	V32y2tpxGfvLw1/V0796ACB+1DxdDR4=
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
Subject: [PATCH 09/15] KVM: arm64: vgic: Ensure the irq refcount is nonzero when taking a ref
Date: Wed, 24 Jan 2024 20:49:03 +0000
Message-ID: <20240124204909.105952-10-oliver.upton@linux.dev>
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

It will soon be possible for get() and put() calls to happen in
parallel, which means in most cases we must ensure the refcount is
nonzero when taking a new reference. Switch to using
vgic_try_get_irq_kref() where necessary, and document the few conditions
where an IRQ's refcount is guaranteed to be nonzero.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 18 ++++++++----------
 arch/arm64/kvm/vgic/vgic.c     |  3 ++-
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 1d912a595b71..7219f4a0a93d 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -75,18 +75,11 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 	 * check that we don't add a second list entry with the same LPI.
 	 */
 	oldirq = xa_load(&dist->lpi_xa, intid);
-	if (oldirq) {
+	if (oldirq && vgic_try_get_irq_kref(oldirq)) {
 		/* Someone was faster with adding this LPI, lets use that. */
 		kfree(irq);
 		irq = oldirq;
 
-		/*
-		 * This increases the refcount, the caller is expected to
-		 * call vgic_put_irq() on the returned pointer once it's
-		 * finished with the IRQ.
-		 */
-		vgic_get_irq_kref(irq);
-
 		goto out_unlock;
 	}
 
@@ -607,8 +600,8 @@ static struct vgic_irq *vgic_its_check_cache(struct kvm *kvm, phys_addr_t db,
 	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
 
 	irq = __vgic_its_check_cache(dist, db, devid, eventid);
-	if (irq)
-		vgic_get_irq_kref(irq);
+	if (irq && !vgic_try_get_irq_kref(irq))
+		irq = NULL;
 
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 
@@ -654,6 +647,11 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	if (cte->irq)
 		__vgic_put_lpi_locked(kvm, cte->irq);
 
+	/*
+	 * The irq refcount is guaranteed to be nonzero while holding the
+	 * its_lock, as the ITE (and the reference it holds) cannot be freed.
+	 */
+	lockdep_assert_held(&its->its_lock);
 	vgic_get_irq_kref(irq);
 
 	cte->db		= db;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 949af87bb599..7e0d84906a12 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -394,7 +394,8 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 
 	/*
 	 * Grab a reference to the irq to reflect the fact that it is
-	 * now in the ap_list.
+	 * now in the ap_list. This is safe as the caller must already hold a
+	 * reference on the irq.
 	 */
 	vgic_get_irq_kref(irq);
 	list_add_tail(&irq->ap_list, &vcpu->arch.vgic_cpu.ap_list_head);
-- 
2.43.0.429.g432eaa2c6b-goog

