Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793876461;
	b=2jUO7Udy+tXPBDK1Dx8s/AgmANeNXCxl9g945nNlBPjMQ16BYMV+r19//1ZYbEtFcZG/
	 H4mLz/gcn+L/uPIT5b2HiyF6o2RPgSUyceEPVI26pPcQQfyzKZiR8E7SltAZJCRRpRfyl
	 GzZP04LhlUHWlM5fbaFBhFatOC/LTqy/q2N9T+SLNexnCLmwrF5SLpz1yUKb2QeRx9Ls4
	 HSVcHlrCKuZyO0q88nGFoFNldVPiBDd6I/quAyzehxhQBC00an8VqpTC+f72xIRLTbAQL
	 gEJrAoAf0iO9o/IZOIfXtQk8N7K+03iZ+/lXeQDY227Rjkopimn18L+5y/CGqdkUYWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793876461;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=rvaFmtyNDISQsoxMWBFpDY8CKig5NLHO//X6oykgI60=;
	b=1Uj6H3kTpqeYwOK1sZIG1xcs+s2fNcaFD1lysPVShkRa4ItYFNzvgy0FkJuO6Eg8yobA
	 16F/8f4oI5QVUrVQ9aV3xRbvVdN15TNJ+VneEwxAwyeNlSKACNb5zJS39SBgRV2EdP3dF
	 z68lQT6Px2jwDUZbwq6S4GctsTnNRhPOV46DOwD53454aQZiyWB6LRbjV+tVBAL+KgWha
	 ryBSnC462Ub58Krn2eT7vQ+Wl7tAD52To1Z/0mtH6I0z4hoNNCeIiEMEhmvCcHx9XXDf5
	 taPT66Ja8XWj6Cbj7sYLcFw0vRdJjSCfvWeee8HJhPt0o6m1QNCGx0LDyLUiXEKRFWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vIrFY6We;
	arc=none smtp.remote-ip=91.218.175.174
Received: from mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DBD3606A32F
	for <kvmarm@lists.linux.dev>; Thu,  5 Nov 2026 11:00:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DBD3606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vIrFY6We
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=NyEGJoxXLgzBuQGYRabpnuVYOlu6XTCpsnZS7w1lcug=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793876458; v=1; x=1794481258;
 b=vIrFY6WeE9WW0HJWQx9rBXqXQNSdxsKhOXDMFmBTNEXy8U9imBwQJnQtc2KIP9G6rQVZE2qF
 RptMNnBmU1d/2aZsQAHwNJylcGlk9FG3Wkl2J4hFsYIqYeOuqImALXcJEel5Kb7ABLAFdXf9Cos
 Gu8ued5W8kzL9C5W2qhqaYTw=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id e5683ee50ff6c947;
	Thu, 05 Nov 2026 11:00:58 +0000
X-Mizu-Trace-ID: e5683ee50ff6c947
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
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
	Eric Auger <eric.auger@redhat.com>,
	Yuchao Zhang <ndaugoing@gmail.com>,
	Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] KVM: arm64: vgic: Drop the pending state of all LPIs when disabling LPIs
Date: Thu,  5 Nov 2026 11:00:48 +0000
Message-ID: <20261105110050.1244525-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261105110050.1244525-1-fuad.tabba@linux.dev>
References: <20261105110050.1244525-1-fuad.tabba@linux.dev>
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

When the guest clears GICR_CTLR.EnableLPIs, vgic_flush_pending_lpis()
retires the LPIs on the vCPU's AP list. However, an LPI disabled in the
configuration table can be pending without being on that list. An LPI
moved to the vCPU by MOVI can also still be in another vCPU's LRs,
which pausing the vCPU doesn't fold back. These LPIs stay pending, and
the guest takes them even after re-enabling LPIs with
GICR_PENDBASER.PTZ set.

Halt the guest rather than the vCPU, so that no vCPU can fold such an
LPI back from its LRs after the flush. Have the flush clear the pending
state of every LPI targeting the vCPU. A forwarded vLPI's pending state
is in its vPE's pending table, which the flush doesn't clear.

Invalidate the translation cache before the flush. Only an MSI racing
with the disable can then make an LPI pending, or cache its translation
for later ones.

Fixes: 0e4e82f154e38 ("KVM: arm64: vgic-its: Enable ITS emulation as a virtual MSI controller")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 13 +++++++------
 arch/arm64/kvm/vgic/vgic.c         | 16 +++++++++++++++-
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 02292f8e0b431..93024879ed3b3 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -298,14 +298,15 @@ static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
 		/*
 		 * Yes, disabling LPIs is painful, since it can be done from
 		 * a *remote* vcpu! So let's not take any chance, and make
-		 * sure that the target vCPU has written their LRs back to the
+		 * sure that every vCPU has written their LRs back to the
 		 * irq structures, and release any reference they would have.
-		 * Pause it before its LPIs read as disabled, so that the exit's
-		 * prune leaves them for vgic_flush_pending_lpis() to retire.
+		 * Halt them before the LPIs read as disabled, so that none can
+		 * fold an LPI back from its LRs after vgic_flush_pending_lpis()
+		 * has cleared it.
 		 *
 		 * If it hurts, don't do it.
 		 */
-		kvm_pause_vcpu(vcpu);
+		kvm_arm_halt_guest(vcpu->kvm);
 
 		/*
 		 * Don't disable if RWP is set, as there already an
@@ -315,12 +316,12 @@ static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
 					      GICR_CTLR_ENABLE_LPIS,
 					      GICR_CTLR_RWP);
 		if (ctlr == GICR_CTLR_ENABLE_LPIS) {
-			vgic_flush_pending_lpis(vcpu);
 			vgic_its_invalidate_all_caches(vcpu->kvm);
+			vgic_flush_pending_lpis(vcpu);
 			atomic_set_release(&vgic_cpu->ctlr, 0);
 		}
 
-		kvm_resume_vcpu(vcpu);
+		kvm_arm_resume_guest(vcpu->kvm);
 	} else {
 		ctlr = atomic_cmpxchg_acquire(&vgic_cpu->ctlr, 0,
 					      GICR_CTLR_ENABLE_LPIS);
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index fe09ada322625..a99570538f104 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -207,9 +207,10 @@ static void vgic_release_deleted_lpis(struct kvm *kvm)
 void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	struct vgic_irq *irq, *tmp;
+	unsigned long intid, flags;
 	bool deleted = false;
-	unsigned long flags;
 
 	raw_spin_lock_irqsave(&vgic_cpu->ap_list_lock, flags);
 
@@ -228,6 +229,19 @@ void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
 
 	if (deleted)
 		vgic_release_deleted_lpis(vcpu->kvm);
+
+	/* Disabled LPIs and LPIs MOVI'd here can be pending off this AP list. */
+	xa_for_each(&dist->lpi_xa, intid, irq) {
+		irq = vgic_get_irq(vcpu->kvm, intid);
+		if (!irq)
+			continue;
+
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
+		if (irq->target_vcpu == vcpu)
+			irq->pending_latch = false;
+		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+		vgic_put_irq(vcpu->kvm, irq);
+	}
 }
 
 void vgic_irq_set_phys_pending(struct vgic_irq *irq, bool pending)
-- 
2.47.3

