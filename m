Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC1C3F167A;
	Wed,  1 Apr 2026 10:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775039792; cv=none; b=gdo1132aRkofF3hXbXUEPklQsI/TYgn4NnFl3tljHmpeb1WKubQ7/7iJL2dBSEWctwOR0noLa71anpZVpGXrP0e6ax8f8H2Rb7pasVUb7dG34+w3FwT4ag4T0zhONjnohpCKkYJXrTAuDHWj6RWWWN/e1ioeYBIpWfm0fbRV94A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775039792; c=relaxed/simple;
	bh=fhCTNACn4ib4srYZ0jtgAsaLQBYsRgwflH0SpEJscMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hjHN8k1ztUOjgdelCxLWrBSbOCuHUixYyMmqJRBF1bYA4TRbDWGbBK75gY0PKiQKYTRJqG0LlyuU12q8+SL3WuyZcgKQrIKpcpu7LtKlG0aJzQIKSVFy2flU0nCNljk18T0tSrhaoCh3INqjmo4xdmsGR1JWZJvA+4La3g0TPww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ObJ7WvUo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ObJ7WvUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498B6C4CEF7;
	Wed,  1 Apr 2026 10:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775039792;
	bh=fhCTNACn4ib4srYZ0jtgAsaLQBYsRgwflH0SpEJscMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ObJ7WvUoNO9EitaoZSZPfNBs/5tVMgZkwjmPceFdRUPpmtOKynyFZbY7wfyAHp28k
	 eYQ+VDaVfobKTHVUk4bZAWFR747xQaaqm1hS3PvueDnheqUA7iQaPx8xrlQFw5ZzdQ
	 HTZKiE5EqXukXBA+zk7oelwYBRzeHJYxtiNA35XlQdwjRTc1n1y+vFQaPIdRiukxp3
	 X3315YYUjwfcGITjWlEmLQqEkV8MKMHYxZ5NjhEDad3RGnORx810GIpy57o2WHfidR
	 qih3N50ZzUTW5UaIUGMp9yvwXcQ+bVfjE5RYejZdFhbhtoqXQwAMiVLW0ziEn9a4ys
	 QHeNlOnEc4EvQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w7sw2-00000007oRQ-28Fs;
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
Subject: [PATCH v2 06/16] KVM: arm64: vgic-v5: Hold config_lock while finalizing GICv5 PPIs
Date: Wed,  1 Apr 2026 11:36:01 +0100
Message-ID: <20260401103611.357092-7-maz@kernel.org>
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

Finalizing the PPI state is done without holding any lock, which
means that two vcpus can race against each other and have one zeroing
the state while another one is setting it, or even maybe using it.

Fixing this is done by:

- holding the config lock while performing the initialisation

- checking if SW_PPI has already been advertised, meaning that
  we have already completed the initialisation once

Reviewed-by: Sascha Bischoff <sascha.bischoff@arm.com>
Fixes: 8f1fbe2fd2792 ("KVM: arm64: gic-v5: Finalize GICv5 PPIs and generate mask")
Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 2b6cd5c3f9c2f..119d7d01d0e77 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -172,6 +172,16 @@ int vgic_v5_finalize_ppi_state(struct kvm *kvm)
 	if (!vgic_is_v5(kvm))
 		return 0;
 
+	guard(mutex)(&kvm->arch.config_lock);
+
+	/*
+	 * If SW_PPI has been advertised, then we know we already
+	 * initialised the whole thing, and we can return early. Yes,
+	 * this is pretty hackish as far as state tracking goes...
+	 */
+	if (test_bit(GICV5_ARCH_PPI_SW_PPI, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask))
+		return 0;
+
 	/* The PPI state for all VCPUs should be the same. Pick the first. */
 	vcpu0 = kvm_get_vcpu(kvm, 0);
 
-- 
2.47.3

