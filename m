Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA6E4070F7;
	Thu, 26 Mar 2026 15:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774539337; cv=none; b=DOsUSpm+GLTcFLpCvt/M7inweBPfucQCOvQbusGmb4Tk1elHqXFwtcLJyxPBfKHrcTD4mf1cE5WxTAO9FfYovGApa1gRnCGvx7+fiyGCuow77N/g9XheKk2F1QTttmjnkRQxJmn7LcRdG05f73JTSwfcmErtNOQOhw/4TGwkpQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774539337; c=relaxed/simple;
	bh=BRbmzUOJBjqYkQ5YB+hmyXy64v2qULuFBJxfbjyyGRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXKue4CR36gGLEWCoADbgZ1xxT2ReXfci8vSqwplQbUEyxFauYeZ6OzTT804Wx1YcRt/+ZR0pl1dJ5b4ZtrrTml4W6Lc5KxT5/ztYPiA1wBXgo3GAVWq4/Yyfc3GKxkJ7JHBLoD+ULVSkKjWNsqPmn1iNvIrRzERryKzymaNVFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VI4WsgMA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VI4WsgMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C404C2BCB4;
	Thu, 26 Mar 2026 15:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774539337;
	bh=BRbmzUOJBjqYkQ5YB+hmyXy64v2qULuFBJxfbjyyGRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VI4WsgMAyvo2ow4/RFEWZKHyYZp4RTvpwDfyWPwNxRH0T8UxkIAjVytwiiAOevfw9
	 +v/XYWBCuBjD/JSRHFCmsfzf3x/EXyFeSP2OIwewcqGEO7PL7x4YQl5sa0XBJwT86O
	 ssu/0tsjthkio9FagoBHJ+ppyGR9FDOwhE19hZmNFbggTLY34CnHu1Wr2pVe8RNwpm
	 qbOO1nj12O9Hstzkdx6bs19sxIfux0hsrdinOUJ30L2ZwQ/5jIGEWZJwy3vAiKNLqf
	 OoBM5eLAq/fKmTPjhJkqJ6xccKwWmg9C9foPxJDHyDFBSsxhCoHgvhFyUqMeCpeBhU
	 gcjjWqz0+bupw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w5mkB-000000060II-2BdE;
	Thu, 26 Mar 2026 15:35:35 +0000
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
Subject: [PATCH 06/15] KVM: arm64: vgic-v5: Hold config_lock while finalizing GICv5 PPIs
Date: Thu, 26 Mar 2026 15:35:21 +0000
Message-ID: <20260326153530.3981879-7-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260326153530.3981879-1-maz@kernel.org>
References: <20260326153530.3981879-1-maz@kernel.org>
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

