Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018F6D517
	for <kvmarm@lists.linux.dev>; Thu, 31 Oct 2024 08:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730363751; cv=none; b=BBztuoud03HBCb4O3PmHLqbZ6BtwVEyvAaXQrSK66GFdfzZhzBT06LPbx8Azerk4l5s4El/r0NgRXPyOqMlX3lQLiXX2eUFtu0sFZlLBvY70OWT9P/Jc7ZsHu3vnjqzA7LQjGxoPVqXb50zCo6NY3XmbyBx4RzpgtOIoceuzGi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730363751; c=relaxed/simple;
	bh=+FzpCGPLbvdqhl1sCnZuiJbbI6lkLMa9iXpMXwi139o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZS3Fa5Pho/cdG2NoZHGw0nyashTzdS+8R3zwxq35orMh0KEDvGHYv9lAIznx3rKSNJYe6r8/d5zJPcqwFIxI5CDAQp0h777pykatdSn8AgKDz4hIxM4NkxN9+gK06/BLecT/bSyBs2MHugcvAvlnT1C065e6gaMckxDaGDp6ues=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o/Xigo8p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o/Xigo8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932BDC4CEC3;
	Thu, 31 Oct 2024 08:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730363750;
	bh=+FzpCGPLbvdqhl1sCnZuiJbbI6lkLMa9iXpMXwi139o=;
	h=From:To:Cc:Subject:Date:From;
	b=o/Xigo8pno5nttMto3H3k4SyBYHzd2izIgk8zqUjKffgjfTHEXMZ1JdfSF7E1VnQe
	 Ia8hnvbAY6pGXyWG60M2cx2tW3dshWIZjnmomMCeCtLka34YLpy4BM/5T5tPbDP/rT
	 tHPbs6AAVEv8POF6WjDVJL6yf3XlGP+AgDf97S0yKZnEFcOkYNO3EaRKxpC2OEyUO1
	 0+uf2wvhRsQcHFfaL9rgHDsf6yCkyHzHS8kXwU+91Zrdi1GyXqk1mMg9GgGsCuZMv+
	 LVQVGfCNY8bl6qViSYGR4LSlTuxuXQ9R8x8Q8UoQpqkvq8vzj+sCkNNTSRgi2YU6Zp
	 Jv/8sj06ri7lg==
Received: from 82-132-232-68.dab.02.net ([82.132.232.68] helo=localhost.localdomain)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t6Qeh-008VPB-CQ;
	Thu, 31 Oct 2024 08:35:48 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] arm64: Expose ID_AA64ISAR1_EL1.XS to sanitised feature consumers
Date: Thu, 31 Oct 2024 08:35:19 +0000
Message-ID: <20241031083519.364313-1-maz@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 82.132.232.68
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, will@kernel.org, catalin.marinas@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Despite KVM now being able to deal with XS-tagged TLBIs, we still don't
expose these feature bits to KVM.

Plumb in the feature in ID_AA64ISAR1_EL1.

Fixes: 0feec7769a63 ("KVM: arm64: nv: Add handling of NXS-flavoured TLBI operations")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 718728a85430..db994d1fd97e 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -228,6 +228,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar0[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64isar1[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_EL1_XS_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_EL1_I8MM_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_EL1_DGH_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_EL1_BF16_SHIFT, 4, 0),
-- 
2.43.0

