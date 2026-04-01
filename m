Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A541D3F20FD;
	Wed,  1 Apr 2026 10:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775039792; cv=none; b=NaQ3AqCnULf5ZKbp1xFa0wYUW+50dSpMCgPCT4drjw2Lo+gdbPY1WrIaOF9FHx6/pzmDKC3KWBW28liTh0b2Fe97iIBm/XM1ylO2MQgo2D5RWJp29DrZf8Ucov3gFbnG1rmK+NOWaTwqtLa5lpBuQRES6Dowo32JAsZ7IA1m9M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775039792; c=relaxed/simple;
	bh=tCagDxGfX64OrjM6zObYSFRfzhSvNvykWS0XRcrR0rQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbVZztMkPX7pb0XtEUkRAx7YObOVkL70WMH4XV3fjNt+4ZfASExdmjmMP6XchTnEu/UJfn8P3q6hhseOwvowKwGjos93fcZVHuTZKL7Tc3OiVIUuM846w9qFixF2PkWJiQjLypm4hIVaS2ESZLq0GNDImcmZt5D2yKY97rnq48Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DWR9bW+i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DWR9bW+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819DFC2BC9E;
	Wed,  1 Apr 2026 10:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775039792;
	bh=tCagDxGfX64OrjM6zObYSFRfzhSvNvykWS0XRcrR0rQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DWR9bW+iPs3/2IeSxx+TfhxLe6EwPAHTZt3djdzrr9iOWLN6v/qZUB6wg8LSo7riQ
	 ffTjLzRSTeXXVOa9KgPwrnJWNZN1OAKmD97r+5fRjlxfN0Dwa9HgvkUZaHIAEPh2WE
	 01Rpcaz0THHECF7iMnjBxnDtveyrbbaWk8Qw9SFRKi+MkXRCCquG3oQgkUOWHw8RQZ
	 ZLLfCZeTn18S6bLTl0bUHDJmioh6gi3Jt6OhUZ1kglNdRrJP0thjhh0JjNUITYu67G
	 Smw5wo8WgQkBcOvGyxZq71v9Yy6UQ3dPCxGw2Q6Zsbq0LNY/BSXePKyjtirsA05VPA
	 euHc7HY4WOmeA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w7sw2-00000007oRQ-31R8;
	Wed, 01 Apr 2026 10:36:30 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 07/16] KVM: arm64: vgic-v5: Transfer edge pending state to ICH_PPI_PENDRx_EL2
Date: Wed,  1 Apr 2026 11:36:02 +0100
Message-ID: <20260401103611.357092-8-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260401103611.357092-1-maz@kernel.org>
References: <20260401103611.357092-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

While it is perfectly correct to leave the pending state of a level
interrupt as is when queuing it (it is, after all, only driven by
the line), edge pending state must be transfered, as nothing will
lower it.

Reviewed-by: Sascha Bischoff <sascha.bischoff@arm.com>
Fixes: 4d591252bacb2 ("KVM: arm64: gic-v5: Implement PPI interrupt injection")
Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 119d7d01d0e77..422741c86c6a8 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -445,8 +445,11 @@ void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
 
 		irq = vgic_get_vcpu_irq(vcpu, intid);
 
-		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
 			__assign_bit(i, pendr, irq_is_pending(irq));
+			if (irq->config == VGIC_CONFIG_EDGE)
+				irq->pending_latch = false;
+		}
 
 		vgic_put_irq(vcpu->kvm, irq);
 	}
-- 
2.47.3

