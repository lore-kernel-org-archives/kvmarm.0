Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6E62F360A;
	Mon,  2 Feb 2026 18:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770057821; cv=none; b=GBl2BigExcZFgqZaM5jnEHtygEQPs9s5UwWioFkQw3JlDPxQyXcblINTWDwqC8o7JhykIZLO1BGfHUDmOBs0EFuQiCoQSl/oV/bBEVpFbX5OI6leCdxoJc5TDbCrmFg80JMMQ2NL6DoaUGJpcy0Lajf54GXgxN0wGTH6Q0PYLtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770057821; c=relaxed/simple;
	bh=7ud6JNfa7NSfJKxGupaHkrIYoNT74Y9AH88J7RRY1Bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltdk1zWjCgLXZH9bHwOHHA80N6FJGMn/0dDR6an0xcKB1ViGVTyTakaN6C0aEfdvxfe61eW2eBxNx3rIkcnGEa9ri/XHLDLEi4/Dh0DnM/qkhbJHFGlNaX8PGQgpD0JRT+zpDINKeGFmIsxts5GU0HVNKwET45Cpjfb5wUQrFmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C8TF7ER4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C8TF7ER4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73368C2BC86;
	Mon,  2 Feb 2026 18:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770057821;
	bh=7ud6JNfa7NSfJKxGupaHkrIYoNT74Y9AH88J7RRY1Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C8TF7ER4jvJtQUctCfVAajBjWQEXcmHxIL0fvrwGtqALnptxaN2sCThB1Ynb/MFHG
	 fKdFl7k7WgdF1os2oGZPWZP9gsMw6+ileD5BJpgL4EvlDoBrH8SoaU+/aEt0+VEXH5
	 heOBhiH1Ezl42WG/3BRy3UpJcSsmVBYl3qVcrSsiRVvsMqSWVjI0rNYyPY4N5VQ19Q
	 ryy069geJ6KfHRtZTQURyNTt0aZlYK4P2TejKKwkqdnnCGKD6z/yh5h2eT+QNN4Zu3
	 LJeVIqGO8SCfaDGerdBMsre1hgMLX+S3rhZvk6/gTk5aYFnnMBDPg1uyR/zDHsqbXj
	 tlFAN54PiYnoQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vmytf-00000007sAy-0d4E;
	Mon, 02 Feb 2026 18:43:39 +0000
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
Subject: [PATCH v2 02/20] KVM: arm64: Remove duplicate configuration for SCTLR_EL1.{EE,E0E}
Date: Mon,  2 Feb 2026 18:43:11 +0000
Message-ID: <20260202184329.2724080-3-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202184329.2724080-1-maz@kernel.org>
References: <20260202184329.2724080-1-maz@kernel.org>
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
Reviewed-by: Fuad Tabba <tabba@google.com>
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

