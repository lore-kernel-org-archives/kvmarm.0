Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73634035B6;
	Thu, 26 Mar 2026 15:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774539336; cv=none; b=JicFEk3XftK6SxU3qkjEB4MNZbqTwYl47J0HPPd87o1s8BGFe/y3tYavh2IZaw1j3Sg24yTaXmlbF6wOmHuBvA9g5pOyIg5kc7EpeEdQu5aUgYjZ91HTSzaHdhQdlccC62sGNr4BO2oG3R2Hjp0UtTKhVU8WrG1j/4sSseUNeH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774539336; c=relaxed/simple;
	bh=rF/5q0POVppW5TATGBHNU8W1ENdew7ttw3E4pLJqUAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gAIxHPf8hvI7Htb1kJ2rCsG2VNAlYCHjRuMAMz4Sl+zh1RFUK4FgdQzpYJl/6MQjJO5aMifMm2O1SIzPRGWl7grI23lCCIOWw94lSowxErEonu8dgU3Pxil8NMkX3Vz2q6wadB0olU9X/CY9Ktj318TrzDs7SXzAu0+aigfvDjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FkFCNpV0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FkFCNpV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E3BC2BCB6;
	Thu, 26 Mar 2026 15:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774539336;
	bh=rF/5q0POVppW5TATGBHNU8W1ENdew7ttw3E4pLJqUAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FkFCNpV0egblNaeA9awlqN9BcAU5z6C0g3Uk4syyedUoVjT3RtZ0FYSoHR+Rg2x56
	 ln8148X/lXkU7+WAI0SqZgL62PJ/trMAh1l52EAcRxWoWOw5P7VzkeXCKxwC++gAjo
	 9js6oHrC1afgl42fvgfJNXAyCjDbT+3Z71n+qEasXjjC0fKA26p3HNxnOuke3gyttd
	 2AvC7JWbx2CGb704fHIkYTBPExaBMib5Q1tnVPclwWUwBd5DgeYuWWgJIw2usdIFZo
	 8C0fvBERZQKdPh3JB1XfyesNxodL4ge+Jk/CcNXFmOAOZcVLoXiRli6c5mkPYB+Uqm
	 Bhem7PXc3LdmA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w5mkA-000000060II-3aeR;
	Thu, 26 Mar 2026 15:35:34 +0000
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
Subject: [PATCH 03/15] arm64: Fix field references for ICH_PPI_DVIR[01]_EL2
Date: Thu, 26 Mar 2026 15:35:18 +0000
Message-ID: <20260326153530.3981879-4-maz@kernel.org>
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

The ICH_PPI_DVIR[01]_EL2 registers should refer to the ICH_PPI_DVIRx_EL2
fields, instead of ICH_PPI_DVIx_EL2.

Fixes: 2808a8337078f ("arm64/sysreg: Add remaining GICv5 ICC_ & ICH_ sysregs for KVM support")
Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 51dcca5b2fa6e..3b57cb692c5be 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -4888,11 +4888,11 @@ Field	0	DVI0
 EndSysregFields
 
 Sysreg	ICH_PPI_DVIR0_EL2	3	4	12	10	0
-Fields ICH_PPI_DVIx_EL2
+Fields ICH_PPI_DVIRx_EL2
 EndSysreg
 
 Sysreg	ICH_PPI_DVIR1_EL2	3	4	12	10	1
-Fields ICH_PPI_DVIx_EL2
+Fields ICH_PPI_DVIRx_EL2
 EndSysreg
 
 SysregFields	ICH_PPI_ENABLERx_EL2
-- 
2.47.3

