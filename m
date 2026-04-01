Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCE23F165E;
	Wed,  1 Apr 2026 10:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775039792; cv=none; b=MGYlkJfo+PnHzxjPoj4sTE6xZZyu6mWiG13APq7OW3SZmqGqk/JmfZbvH3s7oj9ZrKt0JuOiuO/rZB49qoUyQXl7SgMoyl498yAxIYstt5qbCQj0nJTVnYHBAZWPeWtQQzYmw64sEftoQ5Em6rJ06nfG01YoqPC+Q1G5onehM0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775039792; c=relaxed/simple;
	bh=CFePSoo9MRelTjN7d6tKirqt9VLTbTDHcdGyM9MrxaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f//OgYKdxA5JUUYtNkWjHxLLn6z212NVaENRsnM26rZRQD+KoDZeZ4ObENWiAETLX9eotxeFUCP05BM0zcFClKDMq73tOpcT7B6jVVv03yEC88mvFK81aJhhRJdTtcM6ct1GCxXuKMoCGpoU5Odjvqk57sOHHbMvoS671Rh4P3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=reD3drKD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="reD3drKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE5FC2BCB4;
	Wed,  1 Apr 2026 10:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775039792;
	bh=CFePSoo9MRelTjN7d6tKirqt9VLTbTDHcdGyM9MrxaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=reD3drKDITbjHXo+09xcvh/m9AxfUnvjslVLZ5TCQ/LOBiI9sIF/AaM0ONdFXAGEN
	 F7WisRBp/Mm2570vN90c6kYVvlVOlCgJ2mZEcZIP2LM1GW87Vb3mtIkYV+/sH9f/2D
	 AXhyGolStCkrpHd9KdjWxGLhX84d1rVkjVtR4WqKT9/JY1XbubdbSdg1wDE+9Slmh6
	 qlMqb9FtH4c4K1vOhETxWicQE2e0z3RDOUfru4uvEOCPoN4TyBmprLUX7uylywp5+o
	 bcJ37MIyLrMZjvhUzwWQM7lTFRWNXhSWbR5z6Qv0VJPX7FtOxAvhoA+uYr/nnStB6M
	 Y3ZU6lBeSAJIg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w7sw2-00000007oRQ-0O3X;
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
Subject: [PATCH v2 04/16] KVM: arm64: Fix writeable mask for ID_AA64PFR2_EL1
Date: Wed,  1 Apr 2026 11:35:59 +0100
Message-ID: <20260401103611.357092-5-maz@kernel.org>
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

The writeable mask for fields in ID_AA64PFR2_EL1 has been accidentally
inverted, which isn't a very good idea.

Restore the expected polarity.

Reviewed-by: Sascha Bischoff <sascha.bischoff@arm.com>
Fixes: a258a383b9177 ("KVM: arm64: gic-v5: Sanitize ID_AA64PFR2_EL1.GCIE")
Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 18e2d2fccedb8..6a96cb7ba9a3c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3304,10 +3304,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 				       ID_AA64PFR1_EL1_MPAM_frac |
 				       ID_AA64PFR1_EL1_MTE)),
 	ID_FILTERED(ID_AA64PFR2_EL1, id_aa64pfr2_el1,
-		    ~(ID_AA64PFR2_EL1_FPMR |
-		      ID_AA64PFR2_EL1_MTEFAR |
-		      ID_AA64PFR2_EL1_MTESTOREONLY |
-		      ID_AA64PFR2_EL1_GCIE)),
+		    (ID_AA64PFR2_EL1_FPMR		|
+		     ID_AA64PFR2_EL1_MTEFAR		|
+		     ID_AA64PFR2_EL1_MTESTOREONLY	|
+		     ID_AA64PFR2_EL1_GCIE)),
 	ID_UNALLOCATED(4,3),
 	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
 	ID_HIDDEN(ID_AA64SMFR0_EL1),
-- 
2.47.3

