Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF3740823F;
	Thu, 26 Mar 2026 15:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774539338; cv=none; b=KMqzTO0ceWW90IBh/tQrnDJDNzxRvLTRxXZbT5Vd5DUtPbpIGdJLxnMU5Pv7A6UmengYjMAuiGxuwCzy8QLV66jNepSBUxHKUnfPd6BYJNesTSxiQ8rHqjSTs/KcIkJ+RMBLX9IEDBXoI+ZqossHE+ZSPOBkKAPeLdHvRVTjuFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774539338; c=relaxed/simple;
	bh=fro4HwPkgBXwJWfWk9t+zbkprwm2rp0aKeHmCvbxKAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fI5eEcha6AFyGRJWaa9o3RMi3wztTLl8kCFPdt3i+J2GmFTAzAKd5LHAJ0p1zpAsCkD306tRkkHXpFI9jcMAm7LYn9tL2AAQ8NG98C1dyGE8jnmM2/UXtDreNllJqfVj/kc20laLsm9x0WRdXj93cMt142wFOlf7/n1y9vH037s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sC4D9CgU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sC4D9CgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA81C2BCB1;
	Thu, 26 Mar 2026 15:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774539338;
	bh=fro4HwPkgBXwJWfWk9t+zbkprwm2rp0aKeHmCvbxKAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sC4D9CgUhu9snrPZjupBAazZ5AVJGRj4+MbTkpfh3KwtF0XzWazZbF0qJIJRCcnxm
	 rTIw8+7OSqrBoDIg1GySkUdx6MXmab5Y/XKkBQk4NmR8CpbZSfEnTzgYCHZdDgvPwz
	 qqGcamDJOVCHirzxXlZk7TKQXhIgIk2YS0BsTIobMHMTTzG/Yckn/sUvQTAx+q2/gU
	 JXeaBSGDBXawM1g/WtXAKg8zvo5rmQMBsw6P2vYceZ7FSYHDRhNGkQBjR08h+LcZDX
	 Ftfl/X0wwkZsfBxcFgCbCrbUxEsbrnsBaJi3f8BT68dbTf7Aln/OK52xp61sgv1EVg
	 8zdP1MPSYe2tg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w5mkC-000000060II-1e9D;
	Thu, 26 Mar 2026 15:35:36 +0000
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
Subject: [PATCH 10/15] KVM: arm64: vgic-v5: Correctly set dist->ready once initialised
Date: Thu, 26 Mar 2026 15:35:25 +0000
Message-ID: <20260326153530.3981879-11-maz@kernel.org>
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

kvm_vgic_map_resources() targetting a v5 model results in vgic->dist_ready
never being set. This doesn't result in anything really bad, only
some more heavy locking as we go and re-init something for no good reason.

Rejig the code to correctly set the ready flag in all non-failing
cases.

Fixes: f4d37c7c35769 ("KVM: arm64: gic-v5: Create and initialise vgic_v5")
Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-init.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index fd872079f2a24..ecb0aea180327 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -657,16 +657,20 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 		needs_dist = false;
 	}
 
-	if (ret || !needs_dist)
+	if (ret)
 		goto out;
 
-	dist_base = dist->vgic_dist_base;
-	mutex_unlock(&kvm->arch.config_lock);
+	if (needs_dist) {
+		dist_base = dist->vgic_dist_base;
+		mutex_unlock(&kvm->arch.config_lock);
 
-	ret = vgic_register_dist_iodev(kvm, dist_base, type);
-	if (ret) {
-		kvm_err("Unable to register VGIC dist MMIO regions\n");
-		goto out_slots;
+		ret = vgic_register_dist_iodev(kvm, dist_base, type);
+		if (ret) {
+			kvm_err("Unable to register VGIC dist MMIO regions\n");
+			goto out_slots;
+		}
+	} else {
+		mutex_unlock(&kvm->arch.config_lock);
 	}
 
 	smp_store_release(&dist->ready, true);
-- 
2.47.3

