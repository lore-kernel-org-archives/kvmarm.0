Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.193
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793006897;
	b=2WGHVUiIRneosD/+47P8n5Gd/3KQo0iECcvUPRvw/6cCyU/DR5m3JohdLjsJyjNP7qS1
	 AbVcFcxzbfkxGSEIKoPQ4uy5XzBszJSosXi/nLal5vrjnVoX1yNahGst5welX+lD3tVHa
	 x94IvahxYEZqLr+O59du36Bpz33l+br8rmyok+Wh5QrF/ZSGHMDg1EAEtMKhahp52MRii
	 duJipacGoJuzHZZl+DaGej7TfPnc3M8qmGIQe18sEC1o69KL3szPOy/wFs2mzrl5iydii
	 mSKe+REp7JNSpzufkOw6YBrz2HW/kJurX7z9OVXpe3pxJ9S2kwblIEDJXwAyMLPGxMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793006897;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=+AI0DYauqQPIFoBNmaP0YwjPn6fiYc/EIMHLhz9D4Mk=;
	b=NtMdvsi7qzkqkt4JWqOLLhYVMhh58CzH+yaPFomlNlbHdTC22FihLOLiqVfTAZLeBzkd
	 dKVBPJ9O400A7zWPavR0xNJKjsjlH5ZKRTygn4DzrKnb8oFpfMGS6ecOGdWPk9tV+Ms0H
	 UKqJHnzKHXi9B2uph1dwt43UHPlqoRM7oOOVzRtk22mv2qE0Y1eRZsGGwlZfvHfyBlSSh
	 o7eG4P6C+ODBBVwjPOQycYZHUonYsFcjWwGmAGnvsbi62MHk8tKBtyHEmlNtMxDPcPUOo
	 BVaiUhrIQqKq6AAZZwpysWP6ksKALXHmnqpUs/OYAS9qKNW6H5DWPP7HfXTeUGlJnmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xMpA6cyk;
	arc=none smtp.remote-ip=95.215.58.193
Received: from mta1.migadu.com (out-193.mta1.migadu.com [95.215.58.193])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECE8606A31E
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 09:28:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7ECE8606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xMpA6cyk
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=WutytbD2CvrnwsDDfY3uXMPciA1D/8obpWjMW5XUgIs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793006891; v=1; x=1793611691;
 b=xMpA6cyk9O8sjT1ffQZWhshc+JJqlySlicrVlf126vGAUc0IR1zqxfaeDZuG6tA3GO743AYD
 uTGQZRX1nPDG2ABvMOEUiK883N8FfCzrQcEM7dbbiIcw32JWidKfrQgP1NXVDJkMrLjdN9In9vu
 m/dZ2HqoR8Y9DXkEPVg6BJTM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id c5e8a671613dede4;
	Mon, 26 Oct 2026 09:28:11 +0000
X-Mizu-Trace-ID: c5e8a671613dede4
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
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: arm64: vgic: Don't forward LPIs to a redistributor with LPIs disabled
Date: Mon, 26 Oct 2026 09:28:01 +0000
Message-ID: <20261026092802.2636798-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261026092802.2636798-1-fuad.tabba@linux.dev>
References: <20261026092802.2636798-1-fuad.tabba@linux.dev>
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

Clearing GICR_CTLR.EnableLPIs retires the LPIs on the target vCPU's
ap_list, then invalidates the ITS translation caches. However, an MSI
that hits the translation cache can still queue an LPI to that vCPU
after the retire, and so can an INVALL that enables an LPI already
pending. vgic_target_oracle() only checks that the distributor is
enabled, so the LPI goes on the ap_list and the vCPU takes it with
EnableLPIs clear.

Make the oracle also return NULL for an LPI whose redistributor has LPIs
disabled. vgic_queue_irq_unlock() rechecks it under the ap_list lock,
which the retire takes after clearing EnableLPIs, so either the retire
finds the LPI or the queueing reads EnableLPIs clear. The disable path
pauses the vCPU after clearing EnableLPIs, and with this change the
prune on that vCPU's exit would take its pending LPIs off the ap_list
before the retire walks it. Pause the vCPU before clearing EnableLPIs,
so that the retire still clears their pending state.

Fixes: 0e4e82f154e38 ("KVM: arm64: vgic-its: Enable ITS emulation as a virtual MSI controller")
Suggested-by: Oliver Upton <oupton@kernel.org>
Link: https://lore.kernel.org/r/asf87i2RDh-WksL-@kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 31 ++++++++++++++++--------------
 arch/arm64/kvm/vgic/vgic.c         | 12 ++++++++----
 2 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index f5bd29fbe3a90..9117cd85aa593 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -293,6 +293,18 @@ static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
 		return;
 
 	if (!(val & GICR_CTLR_ENABLE_LPIS)) {
+		/*
+		 * Yes, disabling LPIs is painful, since it can be done from
+		 * a *remote* vcpu! So let's not take any chance, and make
+		 * sure that the target vCPU has written their LRs back to the
+		 * irq structures, and release any reference they would have.
+		 * Pause it before its LPIs read as disabled, so that the exit's
+		 * prune leaves them for vgic_flush_pending_lpis() to retire.
+		 *
+		 * If it hurts, don't do it.
+		 */
+		kvm_pause_vcpu(vcpu);
+
 		/*
 		 * Don't disable if RWP is set, as there already an
 		 * ongoing disable. Funky guest...
@@ -300,21 +312,12 @@ static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
 		ctlr = atomic_cmpxchg_acquire(&vgic_cpu->ctlr,
 					      GICR_CTLR_ENABLE_LPIS,
 					      GICR_CTLR_RWP);
-		if (ctlr != GICR_CTLR_ENABLE_LPIS)
-			return;
+		if (ctlr == GICR_CTLR_ENABLE_LPIS) {
+			vgic_flush_pending_lpis(vcpu);
+			vgic_its_invalidate_all_caches(vcpu->kvm);
+			atomic_set_release(&vgic_cpu->ctlr, 0);
+		}
 
-		/*
-		 * Yes, disabling LPIs is painful, since it can be done from
-		 * a *remote* vcpu! So let's not take any chance, and make
-		 * sure that the target vCPU has written their LRs back to the
-		 * irq structures, and release any reference they would have.
-		 *
-		 * If it hurts, don't do it.
-		 */
-		kvm_pause_vcpu(vcpu);
-		vgic_flush_pending_lpis(vcpu);
-		vgic_its_invalidate_all_caches(vcpu->kvm);
-		atomic_set_release(&vgic_cpu->ctlr, 0);
 		kvm_resume_vcpu(vcpu);
 	} else {
 		ctlr = atomic_cmpxchg_acquire(&vgic_cpu->ctlr, 0,
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 7061b4ab206c9..e1a6a5aa61a8e 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -273,14 +273,18 @@ struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq)
 	 * If the IRQ is not active but enabled and pending, we should direct
 	 * it to its configured target VCPU.
 	 * If the distributor is disabled, pending interrupts shouldn't be
-	 * forwarded.
+	 * forwarded, nor should LPIs whose redistributor has them disabled.
 	 */
 	if (irq->enabled && irq_is_pending(irq)) {
-		if (unlikely(irq->target_vcpu &&
-			     !irq->target_vcpu->kvm->arch.vgic.enabled))
+		struct kvm_vcpu *vcpu = irq->target_vcpu;
+
+		if (unlikely(vcpu && !vcpu->kvm->arch.vgic.enabled))
 			return NULL;
 
-		return irq->target_vcpu;
+		if (unlikely(vcpu && irq_is_lpi(vcpu->kvm, irq->intid) && !vgic_lpis_enabled(vcpu)))
+			return NULL;
+
+		return vcpu;
 	}
 
 	/* If neither active nor pending and enabled, then this IRQ should not
-- 
2.47.3

