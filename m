Received: from mta0.migadu.com (out-195.mta0.migadu.com [91.218.175.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC864CF46F
	for <kvmarm@lists.linux.dev>; Sat, 17 Oct 2026 07:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792223256; cv=none; b=ula9jpFAUtMr+XJnsIQ9UXrULbrIB6GD/DsabeEHJkoFQEqAsaDpwYVvq/gdb8kOXdSkMXXUoIafHvp1o1ufGv7jq7Ja5nJQ5GdP/TbBSjh1PFfYhEV8v9iacK3ZKXcuLGkyY8o7zNBNsvFtZNeMq0lQ35Cuv3ceNq/baBfh2KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792223256; c=relaxed/simple;
	bh=K/GjPujog81eosgMnB/C6I2UKh+50kgQjjrNKqsh+sw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lWvgYfSAj4SpgDKQYG+gRMLDtP0F7tJdp5J3SdYLinwRT4DL/XQIBein5aAuDFNktrUDNfg88+sOPtY0mVT+am/xpaY3jwHVpRCma3AfghB+jZ+0k7kblBt0v+D2vbubHgSHMOb0kuU8Nu/0QHxNSNMzjMHZp5BElDXjd11FYlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gdUfYuum; arc=none smtp.client-ip=91.218.175.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gdUfYuum"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=K/GjPujog81eosgMnB/C6I2UKh+50kgQjjrNKqsh+sw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792223252; v=1; x=1792828052;
 b=gdUfYuumArIO26fzon+sgfQV0duZO2YOurShhPgSUXOdiAmBEnhCpmTr4O23bF/NJs6JCv31
 oSR48EBhlYbuZdpIc/e/xvpuArdN/xRXJFY9v2LDiXcIqyYIEOzMxSj0z0Z18GNB+YNs6ermNtA
 kQA/O1BACza9Du4qy14QR76g=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 445c47590b6a75ee;
	Sat, 17 Oct 2026 07:47:32 +0000
X-Mizu-Trace-ID: 445c47590b6a75ee
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
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
Subject: Re: [PATCH v2 2/2] KVM: arm64: vgic-its: Remove the pending state of a discarded LPI
Date: Sat, 17 Oct 2026 08:47:28 +0100
Message-Id: <20261017074728.1981932-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261017074021.1948168-1-fuad.tabba@linux.dev>
References: <20261017074021.1948168-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Marc,

In case it saves you writing it, this is what I tested on top of v2
and your series:

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index d24c391e0aae2..37059d1338406 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -834,25 +834,34 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
 		int ite_esz = vgic_its_get_abi(its)->ite_esz;
 		gpa_t gpa = device->itt_addr + ite->event_id * ite_esz;
 		struct vgic_irq *irq = ite->irq;
-		bool queued;
+		struct kvm_vcpu *vcpu, *target;
 
 		vgic_its_invalidate_cache(its);
 
 		/*
-		 * A queued LPI can be pending in a running vCPU's list register,
-		 * which the exit path folds back: halt the guest before clearing.
+		 * Only an LPI on a vCPU's AP list can be in its list registers,
+		 * which the exit path folds back, and that exit moves the LPI
+		 * to its target vCPU if the target has changed: pause both.
 		 */
-		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
-			queued = irq->vcpu;
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+			vcpu = irq->vcpu;
+			target = irq->target_vcpu;
+		}
 
-		if (queued)
-			kvm_arm_halt_guest(kvm);
+		if (vcpu) {
+			if (target != vcpu)
+				kvm_pause_vcpu(target);
+			kvm_pause_vcpu(vcpu);
+		}
 
 		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
 			irq->pending_latch = false;
 
-		if (queued)
-			kvm_arm_resume_guest(kvm);
+		if (vcpu) {
+			kvm_resume_vcpu(vcpu);
+			if (target != vcpu)
+				kvm_resume_vcpu(target);
+		}
 
 		its_free_ite(kvm, ite);
 

Cheers,
/fuad
