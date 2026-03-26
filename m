Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D340402BA8;
	Thu, 26 Mar 2026 15:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774539338; cv=none; b=KhLexKlKxfCpawDxaRxyqPr5O+K2ahEXSBYHMJGqZKxY4t1CEZMGcR9+HGinFfBOj9VAY//emN4PkGE6jSEu+64rldymrf3f2avXIS+m4eUlpYIQdY9WI/7fE7pm3RCeZ+p3FRcp54Y5wxFmYhycheST8I/lp5abTdtUm5IZeJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774539338; c=relaxed/simple;
	bh=wAr21SGWaskPWZ1zkmUORU+tQYp2h4f6CHNfFfIlMVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b8XvYk/+aav2OA+rhT4H51H4GNHUsi/rqDWIfdnyH8dmALVwNLSYh8flnhH7PXPgwvPIYmM8zJVSrLrouf6jW4DxoPZSqNT+gghlchSoMNSS+qJWreQNOS+gMd4IWip+VfJ0oQlqGVYa+/tdK5as36zQHkZXa6xr27qfBrE1eiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cLxF8Su3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cLxF8Su3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124F6C116C6;
	Thu, 26 Mar 2026 15:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774539338;
	bh=wAr21SGWaskPWZ1zkmUORU+tQYp2h4f6CHNfFfIlMVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cLxF8Su3CM01NazMbWxO/wtlKzB25+OPV2YXtiaBvbAGTgw6KQWk3aa3+MB0Q0sqw
	 nBsDsj4jX1QTabNbGcBq3jyyELSM0jPhNsHuTZkqMeAJwSPDsEaR01HZiagDleTpo+
	 D3tuWGty1eyTVqPasyuKtj9dkRkg8eTdq48mxNzCOfwaF/JaOIy/sqLwo0CCc3hxg2
	 kXbwBqzvZMPjTH+FTJYuY3YUV8oFpnXGsQCAHTZ3P8ZiD1/cAKGdTKuabpYtVxFAba
	 3DuzfWJ/4Zmq+W17upUX1UjZ9sv2Z0ZBKIkbfiVNB01q7jU09SHpvMoP8Adt+tiDhy
	 qKiLMqAnfBo0Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w5mkC-000000060II-0jUE;
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
Subject: [PATCH 09/15] KVM: arm64: vgic-v5: align priority comparison with other GICs
Date: Thu, 26 Mar 2026 15:35:24 +0000
Message-ID: <20260326153530.3981879-10-maz@kernel.org>
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

The way the effective priority mask is computed, and then compared
to the priority of an interrupt to decide whether to wake-up or not,
is slightly odd, and breaks at the limits.

This could result in spurious wake-ups that are undesirable.

Adopt the GICv[23] logic instead, which checks that the priority value
is strictly lower than the mask.

Fixes: 933e5288fa971 ("KVM: arm64: gic-v5: Check for pending PPIs")
Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 0f269321ece4b..75372bbfb6a6a 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -238,7 +238,7 @@ static u32 vgic_v5_get_effective_priority_mask(struct kvm_vcpu *vcpu)
 	 */
 	priority_mask = FIELD_GET(FEAT_GCIE_ICH_VMCR_EL2_VPMR, cpu_if->vgic_vmcr);
 
-	return min(highest_ap, priority_mask + 1);
+	return min(highest_ap, priority_mask);
 }
 
 /*
@@ -367,7 +367,7 @@ bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu)
 
 		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
 			has_pending = (irq->enabled && irq_is_pending(irq) &&
-				       irq->priority <= priority_mask);
+				       irq->priority < priority_mask);
 
 		vgic_put_irq(vcpu->kvm, irq);
 
-- 
2.47.3

