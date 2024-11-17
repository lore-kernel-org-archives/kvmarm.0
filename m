Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3A31D9A4E;
	Sun, 17 Nov 2024 16:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731862684; cv=none; b=qUMerOwbjMSeu6F5vyoHtYep0IuiyIbwe8sC0e7z0spv1ibBkJVS4H+sDH9P8tBfKR/P5oBKneTkdxclXjTyTsk2wAklGWEGXRKgInAhrThq/5pjMStb6cgNfT9D2FEvcHGgM16QAWBupNRbuPfAv6dVRjolOxXuWJ3gWTm7fnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731862684; c=relaxed/simple;
	bh=9zNkXkUqhiT4/4QyOrzhcl3PWYD7D6JifJQs9H3zeIo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hMcFrV3Pl2jwmhoSsYgoeb6ZoZ0B/a//oeXIal75DQqY68JAz0qMeB9hK8YP+taWSWY+pAiPN74OkCHIe+Td5nDxmWBE8au7yql+JjHoIEQBbn5xZpdSzzt65kR0KT3ji+TdHa8c4XCTMhAzhuehswx7mUzTUDdT09aUwD+ytAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AlNehxc/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AlNehxc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BFEC4CEDB;
	Sun, 17 Nov 2024 16:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731862683;
	bh=9zNkXkUqhiT4/4QyOrzhcl3PWYD7D6JifJQs9H3zeIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AlNehxc/o8WzdofOWsZ/cIeq3vaojCfLGcp20Mzm0YNYqI8cIV0OvB0WB46+tcALp
	 oOjt+VLaZjMWKVSHrgYYv95+qPRNKCPzCOHgxPoJ4SuR4loLoeNTQG4Ee9+3cxUtsi
	 Y+qp+6pNZ2hgUkI0If7J5yQKBf2ciOltQvPXBbphfaR7i7pGSNxByy1vjGBy+CtiuP
	 VGGJHBnbju40KI82rc/RMUX3oCqHdQkdPPrbCvu/2VHCTohOGLy+Fg0myjhx25eglX
	 z53Dhp88dV9/umJTxyfQALkTSMalFl2BVmL/8XmNvQIIfIjsuH0zzIFqXP4I1U/BLy
	 Okhl6FhOrP6SQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tCib3-00DYt6-C7;
	Sun, 17 Nov 2024 16:58:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/4] KVM: arm64: vgic-v3: Sanitise guest writes to GICR_INVLPIR
Date: Sun, 17 Nov 2024 16:57:54 +0000
Message-Id: <20241117165757.247686-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241117165757.247686-1-maz@kernel.org>
References: <20241117165757.247686-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, glider@google.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Make sure we filter out non-LPI invalidation when handling writes
to GICR_INVLPIR.

Fixes: 4645d11f4a553 ("KVM: arm64: vgic-v3: Implement MMIO-based LPI invalidation")
Reported-by: Alexander Potapenko <glider@google.com>
Tested-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 9e50928f5d7df..70a44852cbafe 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -530,6 +530,7 @@ static void vgic_mmio_write_invlpi(struct kvm_vcpu *vcpu,
 				   unsigned long val)
 {
 	struct vgic_irq *irq;
+	u32 intid;
 
 	/*
 	 * If the guest wrote only to the upper 32bit part of the
@@ -541,9 +542,13 @@ static void vgic_mmio_write_invlpi(struct kvm_vcpu *vcpu,
 	if ((addr & 4) || !vgic_lpis_enabled(vcpu))
 		return;
 
+	intid = lower_32_bits(val);
+	if (intid < VGIC_MIN_LPI)
+		return;
+
 	vgic_set_rdist_busy(vcpu, true);
 
-	irq = vgic_get_irq(vcpu->kvm, NULL, lower_32_bits(val));
+	irq = vgic_get_irq(vcpu->kvm, NULL, intid);
 	if (irq) {
 		vgic_its_inv_lpi(vcpu->kvm, irq);
 		vgic_put_irq(vcpu->kvm, irq);
-- 
2.39.2

