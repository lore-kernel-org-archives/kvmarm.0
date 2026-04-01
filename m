Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535413F23CE;
	Wed,  1 Apr 2026 10:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775039793; cv=none; b=Kz5eCMbSbrSrWiSLSQiBPQ2pJxrDSp50PM2kWX04iYpCY1ViAsnVRJkjN5MQKvjqT2c1wNmI+89FdTlZP1ELIxuv/smHbHk0enJRsuIr4qBm8Ar55M1FzA9wkd0nFsPHE3UdX8mckIftoomCxpRbCXTg7uC4tupQ5u6Q9nfqfbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775039793; c=relaxed/simple;
	bh=eXE9Q7fOTHuVMVAJDSqKZS9kp+vZ41E2oC5DvdD/1Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZ9PN8cMe2yvG/JHVZTwdB9VM4SFJEuAheE2h+ROt6flbes3TgVjqxnYj7Uqy08FPG+n7FRHGk7l95ux0xlML4u5WWk2Kmsrl3XHgKRAFrxDn6TZf8M8XxVyejlJdq61Tpoecf3NEMgUM4kCLZGJthCRRLttYEMGheLeDKbIE6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uEN9gI+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uEN9gI+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34FFCC2BCB3;
	Wed,  1 Apr 2026 10:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775039793;
	bh=eXE9Q7fOTHuVMVAJDSqKZS9kp+vZ41E2oC5DvdD/1Co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uEN9gI+okR178H3w2TuvDBRBg6ye8PeUrLj7xU6vkeazPZOHiFIk4pQn95/KyDIdS
	 yD1SgDo3Kq/Kd1MxVjb49rEIudEaDZPVnoacDsWLFmI8eH6DecK5wODmyR47FOVYeu
	 cxPLPfayqKXcnxilTVrA/MP0Prf7cTwKgwqaiEw/G5GMrZufy3b0vPQjKb2qtRz9Ui
	 oDrOumdPSS9W8Pi06H/EBhhl6k8BY7vU0/BuObSnI0rV9NtIvUIBzQPZO046whrJAU
	 W4pdVXClJWbzZOotLC/n88tTCoz/8CzRBXV78H3k0RLUMFffFUY4YvAiurc7IaevNv
	 aZyDo7TTpdDpQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w7sw3-00000007oRQ-1e9E;
	Wed, 01 Apr 2026 10:36:31 +0000
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
Subject: [PATCH v2 10/16] KVM: arm64: vgic-v5: Correctly set dist->ready once initialised
Date: Wed,  1 Apr 2026 11:36:05 +0100
Message-ID: <20260401103611.357092-11-maz@kernel.org>
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

kvm_vgic_map_resources() targetting a v5 model results in vgic->dist_ready
never being set. This doesn't result in anything really bad, only
some more heavy locking as we go and re-init something for no good reason.

Rejig the code to correctly set the ready flag in all non-failing
cases.

Reviewed-by: Sascha Bischoff <sascha.bischoff@arm.com>
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

