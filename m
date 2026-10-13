Received: from mta0.migadu.com (out-12.mta0.migadu.com [91.218.175.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D269B4BE457
	for <kvmarm@lists.linux.dev>; Tue, 13 Oct 2026 08:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879424; cv=none; b=aN8/reh8xs/RIOdAfLTxukmfMnYBLm04vkPkXmRaqNLFvRJSWzwVRhR+tzXIgYcSDOL3rSu80SXq5rb6Lqmyw+qNB2qjL3MOjjSJZEbiWDXNTw3/oKaRZRogcfcf5CNbJy9qoXB73+7dn7LNgK1qM6SdFMZSOIiBzREUbcZLHRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879424; c=relaxed/simple;
	bh=QOyVRTmWh+YT7G+cpGvL66+aoL8H82+I49NPk8LYl+U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mwOuJApjkYJXVte6+M1mGj3QwLUu1MLQZPzI0S3NnIfXXLKH8jAQG5kHKjtlZXugBCklRUiV9v9DxuuFG9XneftJPc/tYLMI+TEmdOpLPiyLDMpZWNVVnP8sCo3iaHTGGpFddrxDL5ojferF8VWrWASj/q5TH3gtcr3BTkmP1FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Gp2nP+pH; arc=none smtp.client-ip=91.218.175.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Gp2nP+pH"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=QOyVRTmWh+YT7G+cpGvL66+aoL8H82+I49NPk8LYl+U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791879420; v=1; x=1792484220;
 b=Gp2nP+pHOe5Lp/et1yJeGbgH/+x9cN0DXk8zE3PXvHDZ4kolbcGb/VVt3+a32LtfaNmlG0rC
 3yT5yPU+6WVoTvrjgSgvU+sLUh5AUf/9uFh8ANALqX9BbmKu1J1Kq5TEenVeGrqi3Xbf0mQxJb9
 E9gJ30yAG8X/yBCVyYXjcF7g=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 3790d623399d7862;
	Tue, 13 Oct 2026 08:17:00 +0000
X-Mizu-Trace-ID: 3790d623399d7862
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 2/2] KVM: arm64: vgic-its: Remove the pending state of a discarded LPI
Date: Tue, 13 Oct 2026 09:16:46 +0100
Message-Id: <20261013081646.933312-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261013081646.933312-1-fuad.tabba@linux.dev>
References: <20261013081646.933312-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

DISCARD removes the mapping of an event and instructs the Redistributor
to remove the pending state of its LPI (IHI 0069H.b, 5.3.4). KVM only
frees the ITE, so an LPI that is pending when the guest discards it
stays queued on its target vCPU, and the guest still takes it.

Clear the pending state before freeing the ITE. A queued LPI can be
pending in a running vCPU's list register, so halt the guest first when
the LPI is queued, to fold that state back. A forwarded LPI already
loses its pending state in its_free_ite(), whose unmap from the vPE
sends a DISCARD to the host ITS.

Fixes: df9f58fbea9bc ("KVM: arm64: vgic-its: Implement ITS command queue command handlers")
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 44b92c01bc727..3b8e0e5b097e0 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -829,13 +829,27 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
 		struct its_device *device = find_its_device(its, device_id);
 		int ite_esz = vgic_its_get_abi(its)->ite_esz;
 		gpa_t gpa = device->itt_addr + ite->event_id * ite_esz;
-		/*
-		 * Though the spec talks about removing the pending state, we
-		 * don't bother here since we clear the ITTE anyway and the
-		 * pending state is a property of the ITTE struct.
-		 */
+		struct vgic_irq *irq = ite->irq;
+		bool queued;
+
 		vgic_its_invalidate_cache(its);
 
+		/*
+		 * A queued LPI can be pending in a running vCPU's list register,
+		 * which the exit path folds back: halt the guest before clearing.
+		 */
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
+			queued = irq->vcpu;
+
+		if (queued)
+			kvm_arm_halt_guest(kvm);
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
+			irq->pending_latch = false;
+
+		if (queued)
+			kvm_arm_resume_guest(kvm);
+
 		its_free_ite(kvm, ite);
 
 		return vgic_its_write_entry_lock(its, gpa, 0ULL, ite);
-- 
2.39.5

