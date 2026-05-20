Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A54F3BF67A
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 09:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779268817; cv=none; b=MKDjck0gFPVn3oBY1Oa4QR1FTnEPwPKugw1wWituF7usmaJORAf3T1xRBC5I42SyRspZ4YmcZnQMgQcHsLFmFPfHt5N+vOozISF1FYnGZg8ic1w5UbxjpjbUOKgxeILkWxCYeTAFPEZGJdTugcVez9OFm5UqVMxrOrMRHZRUP+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779268817; c=relaxed/simple;
	bh=BZz1qnB2VX9ACDvWCNyOh7Vg0dUXghFKOcw3QAKYdvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MqxXlpG2E2fBGI1UZhXUTwHstAADKRi8PY12QeaL8x70C6jBgeMR2V/iOhkZBN7fCCO1krjQTzfRuYJvDymXBdE+/1CeYZzqswWGEObEtR/mzZ944IEvUG720LoWSPwD3jK0iL+7GTaYHWMaeasDXkNJayvwYJvj8Nxo29ZxVpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WdqPYev4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WdqPYev4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50AF61F00893;
	Wed, 20 May 2026 09:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779268814;
	bh=Y73/712ucFBf0Y4l8UyabCLqbd4ZcvBJJwObvbr5Gwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WdqPYev4RKpxkjPdnUoKTYgTJ6CCx5iyuXSvynvIT7xPJmh/igebYdS23I2FIw/Ld
	 sboGJKLqQt5/8Oe51J7rkzngQio1M8MLOFaxVikK9fDAO9IT1/Vu6d20J+P9ABcwg6
	 oogdRufGiU1NvydjJHWo7xsVgrItXQUVG70wzC4Dp5y99agDpt2wGO1kWNvmvR9PGg
	 r2blA3+QvNsbvGaAI0uhK1w1q09dqFyrhfV+3g3MHXKDCFHy1FsQJPowZmSuwelKLD
	 wZ/FRWbWlZJbX/Tx33B+7VtoiB9ZKovN/CGC3T0aIVvaJnw0TqwYJqapcOSUlruc+c
	 ZOhclw1KbpEQQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPd64-00000004IaV-21VV;
	Wed, 20 May 2026 09:20:12 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH v2 11/18] KVM: arm64: vgic-v5: Atomically assign bits to PPI DVI bitmap
Date: Wed, 20 May 2026 10:19:42 +0100
Message-ID: <20260520091949.542365-12-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520091949.542365-1-maz@kernel.org>
References: <20260520091949.542365-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Sascha Bischoff <sascha.bischoff@arm.com>

For GICv5 guests we make use of the DVI mechanism for PPIs where
possible.  When mapping a virtual irq to a physical one for a GICv5
guest, the corresponding bit in the DVI bitmap is set. When unmapping,
said bit is cleared again. The key user of this mechanism is the arch
timer.

The existing code used the non-atomic __assign_bit() rather than doing
the update atomically. This could technically result in losing state
if a second PPI's DVI bit were being manipulated concurrently. Each
individual bit within the DVI bitmap is guarded using
vgic_irq->irq_lock, but there's no locking for the overall
bitmap. Therefore, switch to using the atomic assign_bit() function
instead.

Fixes: 5a98d0e17e59 ("KVM: arm64: gic-v5: Implement direct injection of PPIs")
Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 7916bd8d564ef..d4789ff3e7402 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -272,7 +272,7 @@ void vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, struct vgic_irq *irq, bool dvi)
 	lockdep_assert_held(&irq->irq_lock);
 
 	ppi = vgic_v5_get_hwirq_id(irq->intid);
-	__assign_bit(ppi, cpu_if->vgic_ppi_dvir, dvi);
+	assign_bit(ppi, cpu_if->vgic_ppi_dvir, dvi);
 }
 
 static const struct irq_ops vgic_v5_ppi_irq_ops = {
-- 
2.47.3

