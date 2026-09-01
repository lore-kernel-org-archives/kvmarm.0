Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC95A388385;
	Tue,  1 Sep 2026 21:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788299444; cv=none; b=tXlkm8FKrf1aN1UVDEqGiRHwiODvtQx3PwplTBYhTLumgOhXIzwcJ2BqRobb9bSdmNXEIPgLtAoVjzJrWvZH4Yo3x0JkIQ4e8DNRIiTAFdl5Wi18/kTyWa6fnSP2aKMyjLFP8Lga7XpMf5Mm38VDbc1UwCc1BJ9zao/d+1+zyeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788299444; c=relaxed/simple;
	bh=YKCiV3JRnowlUYP4gZAvFvJ+clFyUJvl2G9cB2ncGS4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NBhlqk+45grTWN8/rgtnOi87u17XcCdhy3Tc6GLDLPrwnGAf4fSMEAa4qd0NFOalBCH7tIHZg9r+hO2dZWMvoVTtjTi8OiOWDKz3WEvcXWv1wCztww4rUaTkZHvYCqEhtBdcDGuLO3LHs9KnD/IbA1zIdNG5Q0ErpVal3MMH3vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O1tXmJQX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O1tXmJQX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0341F00A3A;
	Tue,  1 Sep 2026 21:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788299440;
	bh=B5W37ayUUTp9OcZ1NvZJyL332jGmKa7++7rGX5259fQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=O1tXmJQXdWbHBUSj0QyD/dvMCJh0uMI39ko23jLxCFXoTGrENSFz1UlAfuI9YUjuc
	 nUhT0OHwlouVyx7ci6Bvt6/CAE0Xjap399URkibWTCg8aQ9YIqhWQUoA9vkTyiaMPf
	 MR0Ik6aTSjpDbMaBsvaiZ9geURMncNkCHtfJc34ybgg28JQY0SZbTC5Y8wpCFN2iaY
	 pSwnQybHNe62KCRKMV3ucyrtwFwHyGg885H0ILS6FmCd+nwSO6UyZaggHxQxm8k7Rz
	 oOyOf1/aY1o6PcSynyuikf5PcW3isdYMuiqtIIB4zHVfRrGeIUPoZyo3MI6tH1TLYo
	 8cXDpPuC5wR+w==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 01 Sep 2026 22:46:59 +0100
Subject: [PATCH v20 01/14] arm64/gcs: Ensure FGTs for EL1 GCS instructions
 are disabled
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-arm64-gcs-v20-1-f31750bdfadb@kernel.org>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
In-Reply-To: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
 Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=953; i=broonie@kernel.org;
 h=from:subject:message-id; bh=YKCiV3JRnowlUYP4gZAvFvJ+clFyUJvl2G9cB2ncGS4=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBql0idB4DcdKlt7wJVbB6ROntsyQAta8YhETgGb
 uPxSopq6guJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCapdInQAKCRAk1otyXVSH
 0NtVB/9mh/8qaJIgJBmwYxhtuRck4ae6qKEoj6g+12jBJAM9deBCHC2GZtOn9jE2Z7vuin2xq85
 3ILDGkDY13HakK2mBhbm+J3OI59twTVJL8325yrcuL2uQpdk2nbGMeHVX6Ugf6dnervIaRcGy3G
 QY/IPBVZL6161pO02IwcLqVE2oyD4ko6+gF7d8nBmPiCGbThC1orRYaXXrGxycYaVmr30CPzPru
 r2M/1x8t5l88fNN89tNdNPjZDI7sczsDoKdDhwPBie51aqMxO02kKPFmPVj41MZOeXHcg3IjZwD
 dvXXlZjQqhY9BsFNeIcyfXp0C1mixuaSokOUzvHcKYAOo8QF
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

The initial EL2 setup for GCS did not include disabling of EL1 usage of
GCS instructions, also disable these traps.

Fixes: ff5181d8a2a8 ("arm64/gcs: Provide basic EL2 setup to allow GCS usage at EL0 and EL1")
Reviewed-by: Leonardo Bras <leo.bras@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/el2_setup.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index aa8ec9df8024..d308c6e6757d 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -393,6 +393,11 @@
 	orr	x0, x0, #HFGRTR_EL2_nGCS_EL1_MASK
 	orr	x0, x0, #HFGRTR_EL2_nGCS_EL0_MASK
 
+	/* Disable traps of GCS instructions at EL1 */
+	orr	x2, x2, #HFGITR_EL2_nGCSEPP_MASK
+	orr	x2, x2, #HFGITR_EL2_nGCSSTR_EL1_MASK
+	orr	x2, x2, #HFGITR_EL2_nGCSPUSHM_EL1_MASK
+
 .Lskip_gce_fgt_\@:
 
 .Lset_fgt_\@:

-- 
2.47.3

