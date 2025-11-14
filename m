Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766B83081D2;
	Fri, 14 Nov 2025 09:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763112949; cv=none; b=JYzS7pS5s7euSpHVejUAsKq+E9WBAcqQJxU7HsrCVBJx7X59mthPENuOOZQBlOMESfP/5BgyMWrZb8VMusCKXakEFVKSCqZrLmC7tNnClGL829oHtObf5RFcGaYXX/oJcDyRpv6CWgvkkdqcjHSD+G30HrsahaE6CqNdo0Zw7HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763112949; c=relaxed/simple;
	bh=3ECJbNj4u/wYCSmp3UoVaafBaARdBIhPbmRR5Xh4Rx8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pWlygiR9tB9FleMh+u0vuPtJtRTrbKSHWDp8+DdngIGQI0D8mXMc1PyVg55S8Zi0fHUer+R62TQSrGlu7/ykAjkz3I2gYM2cDnJd277EwKRsRPjqaPQ0snj6kh+fV+GLon+eSkVbR1qp032FQI0wOiSb1aULxe3XRJB/eWwe+KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ij77f9+b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ij77f9+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F32C4CEF5;
	Fri, 14 Nov 2025 09:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763112949;
	bh=3ECJbNj4u/wYCSmp3UoVaafBaARdBIhPbmRR5Xh4Rx8=;
	h=From:To:Cc:Subject:Date:From;
	b=ij77f9+bCKnjVqUFOEvNPJsPx9Y/ATmTL5CZY0Sz7s3U9RdJ+I6dtUrnSASDkv3bt
	 Ccq8bP4WAiY93Xqrid7H+RELHnkl0aDwQhdiKmN1/w/iOZMp8IRB1N2yleYFs3BlbR
	 QXzEuK7ItsUATWzfgQoxw90PZ85eugnwh3Qct/sRGih2G4k1uQzbjZmvn7RBnqJnoA
	 93LMm6XsJuuld3sQq0gOLLhEJAQIuRhwnEjQKhUmRRhryrvQVxXB77dzc7jX22XCWC
	 Vshed3PUYgvnP8qYpLaC4/s7fD3h/UQRZyJJsn0eyg9RxswRgGmAmuGpDnEnzAllzW
	 04kjiBf/qPRLA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vJqDa-000000059rP-2RMj;
	Fri, 14 Nov 2025 09:35:46 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH] KVM: arm64: GICv3: Don't advertise ICH_HCR_EL2.En==1 when no vgic is configured
Date: Fri, 14 Nov 2025 09:35:41 +0000
Message-ID: <20251114093541.3216162-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Configuring GICv3 to deal with the lack of GIC in the guest relies
on not setting ICH_HCR_EL2.En in the shadow register, as this is
an indication of the fact that we want to trap all system registers
to report an UNDEF in the guest.

Make sure we leave vgic_hcr untouched in this case.

Reported-by: Mark Brown <broonie@kernel.org>
Closes: https://lore.kernel.org/r/72e1e8b5-e397-4dc5-9cd6-a32b6af3d739@sirena.org.uk
Fixes: 877324a1b5415 ("KVM: arm64: Revamp vgic maintenance interrupt configuration")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 598621b14a30d..1d6dd1b545bdd 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -26,6 +26,9 @@ void vgic_v3_configure_hcr(struct kvm_vcpu *vcpu,
 {
 	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
 
+	if (!irqchip_in_kernel(vcpu->kvm))
+		return;
+
 	cpuif->vgic_hcr = ICH_HCR_EL2_En;
 
 	if (irqs_pending_outside_lrs(als))
-- 
2.47.3

