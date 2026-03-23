Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567573C9EC1
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 17:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774288039; cv=none; b=Y9n08rSOmapZDOo2klxZNWD719cMjx2HI02lV8sIO2SXhGVK3NGuxdx03Xncv2rO3c1yxjDCnRc3/XkLqvjcK5y1NWJMa9IEyY2XDyuNiajcDPrqfhivbXwYN7t/KD/cJ5f8WEVMWTFiKBuVngF/lvRuU8qtTTRoclO8TmAYQDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774288039; c=relaxed/simple;
	bh=Zy4puHzdO9fdFncJD3haPPVzqpmQid8Z6DA7NwACs8k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nQUbugWV1iuKo37PIQzxpvf2ADffIArrDyOxrVYpSdgdSfniX3UlaD0vdo9Yudu8nZ0tHZGmkylpDQ7ToI4nTjr6fTxrr68HwrLmUJQkF0Q6hiYRc+XdJPiH/n7ekojirNELEpczxfvP3u8WRqUQSVSjImSj/q/6UHNc6fPH//Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AXtk4lWs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AXtk4lWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3266C4CEF7;
	Mon, 23 Mar 2026 17:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774288039;
	bh=Zy4puHzdO9fdFncJD3haPPVzqpmQid8Z6DA7NwACs8k=;
	h=From:To:Cc:Subject:Date:From;
	b=AXtk4lWs9dxuSKQzTKdqZgWd7CkMEQl4IDtwnmCzU+V5yBNI/8F+ZXwjVVlpF3n5j
	 8vTW4Hrc8im8BwwYo7Rz/Ppk3ei9BTrjRWlmNNBgke6uows+5x9KY88ICvn3luxGLH
	 ohIEWEeRqU7IUcdVE7O4l2bCa2xaMPRfmLtKgqH3QAHBytwf3nGUxGhRwhk9UWo6HE
	 gkUG6m+NwTo6UTTNoW6AcIiNJ3DW9CbcwdqL4yVaCmMzXC01jRnUfdM9AjZFupflrT
	 cf9rgGnUhsC8Xkktg4Zibx93XwYR9r+hm7OwzOolGyalfLXLcJjgn35PuOHlyXtW0o
	 kIRjOBXGU4IdA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w4jMy-00000004pxw-30GE;
	Mon, 23 Mar 2026 17:47:16 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: vgic: Don't reset cpuif/redist addresses at finalize time
Date: Mon, 23 Mar 2026 17:47:13 +0000
Message-ID: <20260323174713.3183111-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Although we are OK with rewriting idregs at finalize time, resetting
the guest's cpuif (GICv3) or redistributor (GICv3) addresses once
we start running the guest is a pretty bad idea.

Move back this initialisation to vgic creation time.

Fixes: a258a383b9177 ("KVM: arm64: gic-v5: Sanitize ID_AA64PFR2_EL1.GCIE")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-init.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 47169604100f2..fd872079f2a24 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -147,6 +147,15 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	kvm->arch.vgic.implementation_rev = KVM_VGIC_IMP_REV_LATEST;
 	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
 
+	switch (type) {
+	case KVM_DEV_TYPE_ARM_VGIC_V2:
+		kvm->arch.vgic.vgic_cpu_base = VGIC_ADDR_UNDEF;
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V3:
+		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
+		break;
+	}
+	
 	/*
 	 * We've now created the GIC. Update the system register state
 	 * to accurately reflect what we've created.
@@ -684,10 +693,8 @@ void kvm_vgic_finalize_idregs(struct kvm *kvm)
 
 	switch (type) {
 	case KVM_DEV_TYPE_ARM_VGIC_V2:
-		kvm->arch.vgic.vgic_cpu_base = VGIC_ADDR_UNDEF;
 		break;
 	case KVM_DEV_TYPE_ARM_VGIC_V3:
-		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
 		aa64pfr0 |= SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, GIC, IMP);
 		pfr1 |= SYS_FIELD_PREP_ENUM(ID_PFR1_EL1, GIC, GICv3);
 		break;
-- 
2.47.3

