Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD794E2F00
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 21:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790717372; cv=none; b=gUWC26InwWzR3nbyAUGL+bTOGWuxWCIqAqjs0T2fmBxh8eJzIpss1arYNOHZzdwan2zN/IoFtXgJsO3xGRwoMLuf5U4bwCtLRtC5WXOCEDfX9rhuyIUzWn56ZrMC0T8SWc+fwvmavaghCqoWsYGx7Ua103nRjbr4cjnxx0T9aBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790717372; c=relaxed/simple;
	bh=MBSOvMIMrimxFIs8M34lor1ubpStpOcsyYd+Cyt0RMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hGwKufqATQoMtP8zUmSqOCuWHbet+dOlI4YapQw1SnOmWKEtRXeoqrlkoH6D0y6D8jhn1WRphstDcxIPNlOkYl1FZXLsZoxhr91yA6RRtCDAMLvPGIEnHGO9lhxIhr/G66GvSwqvfLXXzwisll6DIlt3//tdQKx0Kgrf51AGGDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gs75+8bE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gs75+8bE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F012E1F0089A;
	Tue, 29 Sep 2026 21:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790717371;
	bh=e29sKYI4gVLtFPQmB+LChQ/BOWjBCaE+eFvQGZr3tdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gs75+8bE8ZvoL2ZQtEBuFCfUs4oyN4AisS608/CDtUKMkSwwaPBb1XEivRayRomks
	 Rp9q6Ozhk/ugGV8aFNGR6fLOBKROfRtwPJe5WrU2AShv7c1u39u/bYzqBkfrCNcgCQ
	 lL9wgROstY4+XVEClJCRBokO33qoWSEWrYNQxX403wKYe6sHtNGQJZFDqVKf6iMkNd
	 6O9naHK6Ap0bzbhNMEVeGgrtwC3PpcFXQsTssIBl1Vioc2vbQjnjY/CClgs86Jo+XO
	 RfXjfQtjaejvHtHRs3WnEVFW7sirG0HmpFOzSFQ2umHOY4ChRBJ1W7Wwf0fBKZfFtw
	 lDq7uvFOk0ioA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 3/4] KVM: arm64: vgic-v3: Only pause the targeted vCPU when disabling LPIs
Date: Tue, 29 Sep 2026 14:29:24 -0700
Message-ID: <20260929212925.31775-4-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260929212925.31775-1-oupton@kernel.org>
References: <20260929212925.31775-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM pauses the VM any time LPIs are disabled at a redistributor, as
retiring pending LPIs was a bit dicey since it involved manipulating the
AP list of another vCPU while it was running. Of course, this is a very
large hammer and we could do slightly better.

Only pause the targeted vCPU when disabling LPIs, which is almost always
going to be done locally unless your guest is up to no good.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index e5fd7a0002b5..2dd8d83fc93d 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -302,16 +302,16 @@ static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
 		/*
 		 * Yes, disabling LPIs is painful, since it can be done from
 		 * a *remote* vcpu! So let's not take any chance, and make
-		 * sure that everybody has written their LRs back to the irq
-		 * structures, and release any reference they would have.
+		 * sure that the target vCPU has written their LRs back to the
+		 * irq structures, and release any reference they would have.
 		 *
 		 * If it hurts, don't do it.
 		 */
-		kvm_arm_halt_guest(vcpu->kvm);
+		kvm_pause_vcpu(vcpu);
 		vgic_flush_pending_lpis(vcpu);
 		vgic_its_invalidate_all_caches(vcpu->kvm);
 		atomic_set_release(&vgic_cpu->ctlr, 0);
-		kvm_arm_resume_guest(vcpu->kvm);
+		kvm_resume_vcpu(vcpu);
 	} else {
 		ctlr = atomic_cmpxchg_acquire(&vgic_cpu->ctlr, 0,
 					      GICR_CTLR_ENABLE_LPIS);
-- 
2.47.3

