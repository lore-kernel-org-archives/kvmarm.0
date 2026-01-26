Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DAC335575;
	Mon, 26 Jan 2026 12:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769429854; cv=none; b=ESPhZ27WP2hq7XfoJIcWW2r4E5HrKrPK4lB2/K2Bu5lrNZO40D4EEe4yWGX0zlICDLjP5dHNIiTD+WNWbXf8+BXadLQj19Wt+fc48r7Dr+ELkXGWvkpZbc0H8QCYFa77+9//W7ciuOy1YUYDc5VVPs3DcJiIamMR78fO12Pvco0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769429854; c=relaxed/simple;
	bh=QeiXUuyXsqsEXxB+jqohGZCe05XcAXx+BdZIo7VroQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SrpFrpfvKZkcQILEEmGRT2ypmiN60E3/IwMrOkJMYO15KJYy9xs3rYuRxWJ5Jkps9qKotsBHUxF0ZdiAt04OPJPj/+mXkTfoWFpf2HbAKLX7QeMeC8xOIl732W2xKXpK7jDYhc7asGlX96JJ00TlsO3IGRZcRRNthWW8MJnP+Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YBUnOjJW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YBUnOjJW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 470E4C19425;
	Mon, 26 Jan 2026 12:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769429854;
	bh=QeiXUuyXsqsEXxB+jqohGZCe05XcAXx+BdZIo7VroQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YBUnOjJWF+T2u9EWHwN2DyhpXnicV4PKCBWsG2hPUK5e6vSwJtyUmmMRgvrS+oRnl
	 5eMmU5DQW0YWbrfGYAVTlgGiA91YLQj3i10Q56S6SPlIUKDyIigYtqY67iqLIFDvYt
	 qg5zeK0FEUOtsRXHdDjjFZPvwO92qKac8WrKhuxuMvbknhBYSJHYoGl3rEQ3lyTsYW
	 iyqyvF+xbHHiyX86rSGO5+9aad+GZAmlBkfQSdJwh1o7eyRT1FmFKuoGVdnmCOj5+s
	 4fZW7/dzys9ovO46BVbzG4eE9el0Ya2HsXXrqSRdsRd6lCYI29vSOKkiYd/0Ti6HxO
	 wUva/H36i5UKw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vkLXA-00000005hx6-01CE;
	Mon, 26 Jan 2026 12:17:32 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 02/20] KVM: arm64: Remove duplicate configuration for SCTLR_EL1.{EE,E0E}
Date: Mon, 26 Jan 2026 12:16:36 +0000
Message-ID: <20260126121655.1641736-3-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260126121655.1641736-1-maz@kernel.org>
References: <20260126121655.1641736-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We already have specific constraints for SCTLR_EL1.{EE,E0E}, and
making them depend on FEAT_AA64EL1 is just buggy.

Fixes: 6bd4a274b026e ("KVM: arm64: Convert SCTLR_EL1 to config-driven sanitisation")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 9c04f895d3769..0bcdb39885734 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1140,8 +1140,6 @@ static const struct reg_bits_to_feat_map sctlr_el1_feat_map[] = {
 		   SCTLR_EL1_TWEDEn,
 		   FEAT_TWED),
 	NEEDS_FEAT(SCTLR_EL1_UCI	|
-		   SCTLR_EL1_EE		|
-		   SCTLR_EL1_E0E	|
 		   SCTLR_EL1_WXN	|
 		   SCTLR_EL1_nTWE	|
 		   SCTLR_EL1_nTWI	|
-- 
2.47.3

