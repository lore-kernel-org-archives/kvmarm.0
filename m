Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB785218AE
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 21:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790113359; cv=none; b=ki+5+foYCkwWMkhA3oCCBh65V/bLCewLkH52IIz9P+owfETgElSQfpgRx+v1L+A4LdKVpI8FolWSVZ9LdMBH4tdWpLBeZpoKwSRI8mUc/2PNQBhWmd2Lviq0yWkyGD39X4PhxlacZdqERxPaI8Dtt+rSGouqeCgdMAGIM3cWCro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790113359; c=relaxed/simple;
	bh=K3ON+PSIYZ6AcgA9jqDCpbeTLOL6MADP9ii0sndb/kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jm2HSRQY0GvLtk7iCbPgio0uo7hdOoiD6NwbaEZiYglMz4wCZaQ/2TjV+laMyZkB+oplMH51rxnoaj3lEgBsB9SJty0SPjapVsT/TySMhlao4ny2xHK8RoFm89nEZxEXnARWYw501x1691r014BGhNaf1ndhUL5VSGNNq/6ESMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ya5A6rHN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ya5A6rHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73E91F0089B;
	Tue, 22 Sep 2026 21:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790113344;
	bh=JI7EXFtD8nct3k80/WZ56pI4cZh/f9aZ7DXMwMK2D/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ya5A6rHNx7hQ40SvIJCp08q5QFMGYTTckXXph4KY2gDu6gfBuo6pHbHVE55FRlIIK
	 0FJs516x3zbPr2H+VdN8uEi1zr0nfGid8ZCspHmR6U161Ctkfy/D6YH828AjbOLe6h
	 0QeBr+NdsmNa4mnM1KzdjZx4boKNVUhZFL/i7z8SVzo7bpaO3AAaqHKg7jNu1cQecE
	 HTjRa2VzBv/wxCJNbjzzM50SGRDCamXOxv8ZGFQK39twt9M8+shLLpioS30vm5kmE9
	 uR5B6VdwRXK9HFlb5CehheG2vDKePB7Y3LnhRt9V5e6+y+giEo/Joripla93AIcoJ7
	 koAKtD6ed0Xhg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1x98Fr-0000000CFxJ-0Ehb;
	Tue, 22 Sep 2026 21:42:23 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Yuchao Zhang <ndaugoing@gmail.com>
Subject: [PATCH 3/3] KVM: arm64: vgic: Stop the VM when disabling LPIs
Date: Tue, 22 Sep 2026 22:42:12 +0100
Message-ID: <20260922214212.3327146-4-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260922214212.3327146-1-maz@kernel.org>
References: <20260922214212.3327146-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev, ndaugoing@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Disabling LPIs is pretty nasty, as it directly messes with the AP list
of the affected CPU, which could be running... This has the potential to
lead to really bad behaviours, and we should not be doing that.

Take example on the way the Active state is handled and simply pause all
the vcpus so that we are sure they are all in a quiescent state, and the
state be safely manipulated.

Nobody has any expectation of performance for this anyway.

Fixes: 96085b949672d ("KVM: arm/arm64: vgic-v3: Retire pending interrupts on disabling LPIs")
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 5913a20d83019..adefc42964732 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -303,9 +303,19 @@ static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
 		if (ctlr != GICR_CTLR_ENABLE_LPIS)
 			return;
 
+		/*
+		 * Yes, disabling LPIs is painful, since it can be done from
+		 * a *remote* vcpu! So let's not take any chance, and make
+		 * sure that everybody has written their LRs back to the irq
+		 * structures, and release any reference they would have.
+		 *
+		 * If it hurts, don't do it.
+		 */
+		kvm_arm_halt_guest(vcpu->kvm);
 		vgic_flush_pending_lpis(vcpu);
 		vgic_its_invalidate_all_caches(vcpu->kvm);
 		atomic_set_release(&vgic_cpu->ctlr, 0);
+		kvm_arm_resume_guest(vcpu->kvm);
 	} else {
 		ctlr = atomic_cmpxchg_acquire(&vgic_cpu->ctlr, 0,
 					      GICR_CTLR_ENABLE_LPIS);
-- 
2.47.3

