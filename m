Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530CF32857A
	for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 16:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758039069; cv=none; b=UxXb98NnUr/zw2CABjizSQhZR/F8jTXEZ7DpwDhnKNqhW5q8a7dgXBAzxO5NMeZ1Bez0QVhoISMfG1x71qWttCXpjL/JiUlqg+Hq44fy3OpMFg9eU3C/XghkV+XTf8qCumzLO8L2A9xodfZYI5X+aJyfX3tNS56rpFGV6ZEi7Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758039069; c=relaxed/simple;
	bh=6wYcoEAkVyvq2dC25L2mVkyq9vs38Lp9ZDtXq0HWe7w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mqOqKc2r/pVL8BSg+LrgNsaD1u5nDKIzyAhBFR5BhPMxSUBgl3B3YOW35bTVwLj/Pmv+C9ZgbBLknCYYe5dS2ENfzpDxyB3li463/41mqZCOVv8cNuKm620FceaSX7tk2Td0gXQDe93haGbgiBZcoDgeSw9quD4J27DpemE2TlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d2S0hk89; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d2S0hk89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A3DC4CEEB;
	Tue, 16 Sep 2025 16:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758039068;
	bh=6wYcoEAkVyvq2dC25L2mVkyq9vs38Lp9ZDtXq0HWe7w=;
	h=From:To:Cc:Subject:Date:From;
	b=d2S0hk89nRZzt0Rrdhps1nN+c0s+Q2s5ODETkt1LUXBQ/BV73MTaPqBpxnNGc3xwJ
	 kl56zC5pSwN1+KqCqRjz8sEC6XCRWvTY8fksR4shlArJNm+QLFuqucQ/s01G7kZ2cB
	 I+FLR3cGg5GrScqGzUsux8kw+TPTFjwp3u2jf0F3S5cVt2e9oBFs4GkCQ2cvzSAgsm
	 JyByURy5ev2ES+czmWVHk8N2YSVVseCCEdOKHgBPI4ziaNr1I5DyMWMNNmngr/cMnb
	 EPQhTL6kQseoN6ToT/rUIHkUxDEeZeYNTKQpE71qrcImgGGhRJ+ilPtM9QJRfSrged
	 h3dakp48Fwf5Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uyYGo-00000006mbe-2kwH;
	Tue, 16 Sep 2025 16:11:06 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: Fix kvm_vcpu_{set,is}_be() to deal with EL2 state
Date: Tue, 16 Sep 2025 17:11:03 +0100
Message-Id: <20250916161103.1040727-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Nobody really cares about BE, but KVM currently only deals with
SCTLR_EL1 when evaluating or setting the endianness in PSCI,
meaning that we evaluate whatever the L2 state has been at some point.

Teach these primitives about SCTLR_EL2, and forget about BE...

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index fa8a08a1ccd5c..85f998dffea5d 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -511,21 +511,29 @@ static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
 	if (vcpu_mode_is_32bit(vcpu)) {
 		*vcpu_cpsr(vcpu) |= PSR_AA32_E_BIT;
 	} else {
-		u64 sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
+		enum vcpu_sysreg r;
+		u64 sctlr;
+
+		r = vcpu_has_nv(vcpu) ? SCTLR_EL2 : SCTLR_EL1;
+
+		sctlr = vcpu_read_sys_reg(vcpu, r);
 		sctlr |= SCTLR_ELx_EE;
-		vcpu_write_sys_reg(vcpu, sctlr, SCTLR_EL1);
+		vcpu_write_sys_reg(vcpu, sctlr, r);
 	}
 }
 
 static inline bool kvm_vcpu_is_be(struct kvm_vcpu *vcpu)
 {
+	enum vcpu_sysreg r;
+	u64 bit;
+
 	if (vcpu_mode_is_32bit(vcpu))
 		return !!(*vcpu_cpsr(vcpu) & PSR_AA32_E_BIT);
 
-	if (vcpu_mode_priv(vcpu))
-		return !!(vcpu_read_sys_reg(vcpu, SCTLR_EL1) & SCTLR_ELx_EE);
-	else
-		return !!(vcpu_read_sys_reg(vcpu, SCTLR_EL1) & SCTLR_EL1_E0E);
+	r = is_hyp_ctxt(vcpu) ? SCTLR_EL2 : SCTLR_EL1;
+	bit = vcpu_mode_priv(vcpu) ? SCTLR_ELx_EE : SCTLR_EL1_E0E;
+
+	return vcpu_read_sys_reg(vcpu, r) & bit;
 }
 
 static inline unsigned long vcpu_data_guest_to_host(struct kvm_vcpu *vcpu,
-- 
2.39.2

