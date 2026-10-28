Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.114
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208818;
	b=VwRk09hrr1HIRGMlpA39uQsAXFXRIJwrPlRceuvHCW+HYYdq7XkeDTby9mmsIrrT8nOJ
	 8PRxsKd2bq7hsVhB/gI5sNUNRWNVisXg8YvWNxTJEe4mQhSc4Q3eDokJL3BrxhAr7pWSc
	 dSVsQX/flOgoLiFh25mhVfEHJvF1QWbAnx+6ScDLW4Zv8Kp1CsXEVJ0XLvYL19mJDjOpE
	 sQNLu4SICWHd722o/XG8NXRzzoULOIjjoc5wNHLVOd4Jm/t5SfCSDyl+zrrR5fkogckyD
	 aR+gTBInQgibYhhYYuTXvBcSZwClSZY2X5NQ1TfWWEcdFGz+LqvPMiJOWNoqYxq2xdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208818;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=I1Fa6JRPP7VYNcV1UYSNzfVBuIai7Yz+ImynYwQzz8w=;
	b=p0qvToXv7yt1yVNsBddhpqBkXGRrNsJl8nICkhQsGf4An+nzIvs4dybhWSsvtGJ+JIMC
	 cJznAFrF2cjZ7DCEUzIj/8PJnJRfrSqT0kJXnPFhq5eZA4aEyXkiMk2pZ00PuvO5F2nX0
	 U2D4E8/dd34YxtA1uZm272OjXf+u2K6qDzh9wdOrfjCOFKF46eDzI78XWt/+Q2/BFyLVe
	 UrN0qP7AYmO4llupZ/OGw9aBMpMLQbgGIg3NuRZ6fnpboiyM9+qdhyqKajxCZ+SEHGMRv
	 5Zuo9JrtY63aV6cZeVmpo8M2g3W5Km+eicGUMl3YNlzRtV9cE0RtTu79voypava820w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YldVIdE0;
	arc=none smtp.remote-ip=95.215.58.114
Received: from mta1.migadu.com (out-114.mta1.migadu.com [95.215.58.114])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872A4606A31F
	for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 17:33:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 872A4606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YldVIdE0
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Vu3DCnFQlvZnnQDvCt8iSvZagRZVGtqQzKTq6UXQQNA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793208815; v=1; x=1793813615;
 b=YldVIdE0tZen68U2dzYAeLfmvCn/AYpRxWJFx3P/bZU+3lg8OkAkiv8LzWz35zCguLpc2HKT
 uqEPOk4lIqIMYEpy+vQ/zQOyE7Fmqf8t+bVhqSi0E5R6jjx89onQgmgZLBzpv5mwCP9bc4+rrBZ
 qIadKiMGGYOrpMBweNdPzo0g=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 5cb386fb5ff2312e;
	Wed, 28 Oct 2026 17:33:35 +0000
X-Mizu-Trace-ID: 5cb386fb5ff2312e
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: arm64: vgic-its: Remove the pending state of a cleared LPI
Date: Wed, 28 Oct 2026 17:33:19 +0000
Message-ID: <20261028173319.1807811-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028173319.1807811-1-fuad.tabba@linux.dev>
References: <20261028173319.1807811-1-fuad.tabba@linux.dev>
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

CLEAR removes the pending state of an LPI (IHI 0069H.b 5.3.3). Since
commit e99ff76f4a02b ("KVM: arm64: vgic-its: Remove the pending state of
a discarded LPI"), DISCARD does that under the irq lock, after pausing
the vCPUs whose list registers can hold the LPI. CLEAR does neither. An
LPI pending in a running vCPU's list register is folded back on exit, so
the guest takes it after the CLEAR. pending_latch also shares a word
with on_lr, so a racing CLEAR can restore on_lr after the exit path has
cleared it under the lock, and trip the WARN_ON() in
vgic_v3_compute_lr() when the LPI is next queued.

Move DISCARD's pause and clear into a helper and use it for CLEAR too,
after checking, as DISCARD does, that the event's collection is mapped.
CLEAR on an unmapped collection is a command error. Without the check,
the helper could be handed an LPI that has no target vCPU to pause.

Fixes: df9f58fbea9bc ("KVM: arm64: vgic-its: Implement ITS command queue command handlers")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 67 ++++++++++++++++++----------------
 1 file changed, 35 insertions(+), 32 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 42dc71495ad98..f9e9b0a71eb5a 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -817,6 +817,38 @@ static u64 its_cmd_mask_field(u64 *its_cmd, int word, int shift, int size)
 #define its_cmd_get_target_addr(cmd)	its_cmd_mask_field(cmd, 2, 16, 32)
 #define its_cmd_get_validbit(cmd)	its_cmd_mask_field(cmd, 2, 63,  1)
 
+/*
+ * Only an LPI on a vCPU's AP list can be in its list registers, which the
+ * exit path folds back, and that exit moves the LPI to its target vCPU if
+ * the target has changed: pause both. Clear an LPI on no AP list before
+ * dropping the lock, so that nothing can put it in a list register first.
+ * Must be called with the its_lock mutex held.
+ */
+static void vgic_its_clear_pending(struct vgic_irq *irq)
+{
+	struct kvm_vcpu *vcpu, *target;
+
+	scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+		vcpu = irq->vcpu;
+		target = irq->target_vcpu;
+		if (!vcpu)
+			irq->pending_latch = false;
+	}
+
+	if (vcpu) {
+		if (target != vcpu)
+			kvm_pause_vcpu(target);
+		kvm_pause_vcpu(vcpu);
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
+			irq->pending_latch = false;
+
+		kvm_resume_vcpu(vcpu);
+		if (target != vcpu)
+			kvm_resume_vcpu(target);
+	}
+}
+
 /*
  * The DISCARD command frees an Interrupt Translation Table Entry (ITTE).
  * Must be called with the its_lock mutex held.
@@ -833,38 +865,9 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
 		struct its_device *device = find_its_device(its, device_id);
 		int ite_esz = vgic_its_get_abi(its)->ite_esz;
 		gpa_t gpa = device->itt_addr + ite->event_id * ite_esz;
-		struct vgic_irq *irq = ite->irq;
-		struct kvm_vcpu *vcpu, *target;
 
 		vgic_its_invalidate_cache(its);
-
-		/*
-		 * Only an LPI on a vCPU's AP list can be in its list registers,
-		 * which the exit path folds back, and that exit moves the LPI
-		 * to its target vCPU if the target has changed: pause both.
-		 * Clear an LPI on no AP list before dropping the lock, so that
-		 * nothing can put it in a list register first.
-		 */
-		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
-			vcpu = irq->vcpu;
-			target = irq->target_vcpu;
-			if (!vcpu)
-				irq->pending_latch = false;
-		}
-
-		if (vcpu) {
-			if (target != vcpu)
-				kvm_pause_vcpu(target);
-			kvm_pause_vcpu(vcpu);
-
-			scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
-				irq->pending_latch = false;
-
-			kvm_resume_vcpu(vcpu);
-			if (target != vcpu)
-				kvm_resume_vcpu(target);
-		}
-
+		vgic_its_clear_pending(ite->irq);
 		its_free_ite(kvm, ite);
 
 		return vgic_its_write_entry_lock(its, gpa, 0ULL, ite);
@@ -1309,10 +1312,10 @@ static int vgic_its_cmd_handle_clear(struct kvm *kvm, struct vgic_its *its,
 
 
 	ite = find_ite(its, device_id, event_id);
-	if (!ite)
+	if (!ite || !its_is_collection_mapped(ite->collection))
 		return E_ITS_CLEAR_UNMAPPED_INTERRUPT;
 
-	ite->irq->pending_latch = false;
+	vgic_its_clear_pending(ite->irq);
 
 	if (ite->irq->hw)
 		return irq_set_irqchip_state(ite->irq->host_irq,
-- 
2.47.3

