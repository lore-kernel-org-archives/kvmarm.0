Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677A953B8
	for <kvmarm@lists.linux.dev>; Mon,  6 Mar 2023 16:14:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA02C433D2;
	Mon,  6 Mar 2023 16:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678119256;
	bh=vceDguBh4JZwOSilIbFFRC7rbnkH49TmeEOBoUMa2Os=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=XOPbzYisxsZD3Yah010t2RDkzdldGp565OgaDJ7hJEIuncBPByJ0bk6aqYeDg20xC
	 Oj40qEclmLArHa4FDR5xAsIHzEilNpCd9ausXVfk5Vwf+juSp8WI/arubq2jST3Oos
	 YDTPHiDjgXXtZpgyWMrXpHCIzZkoEYmimKu4fUx690vDCccGrjzn17++kSyR0Uk+MI
	 1gqPr/MowoMUiGfOruvVbjHnqiR+hUhM8cWNYRdcNKaAnC3CHsqVBJ8wVWWUdivATz
	 GrAOR4WAHfLMjF5sPBRt+x50cQy35GcOkM82IvH1Ra+q1m2jTX8P0cIQWlWSHieKwR
	 p5XlTQyqxid3w==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 06 Mar 2023 16:08:51 +0000
Subject: [PATCH 1/2] arm64: Add feature detection for fine grained traps
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230301-kvm-arm64-fgt-v1-1-cfdf71ac67dc@kernel.org>
References: <20230301-kvm-arm64-fgt-v1-0-cfdf71ac67dc@kernel.org>
In-Reply-To: <20230301-kvm-arm64-fgt-v1-0-cfdf71ac67dc@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.13-dev-bd1bf
X-Developer-Signature: v=1; a=openpgp-sha256; l=1433; i=broonie@kernel.org;
 h=from:subject:message-id; bh=vceDguBh4JZwOSilIbFFRC7rbnkH49TmeEOBoUMa2Os=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBkBhFRKKJwboOyASu4sTY6ztRuLGhBHbkXSFwzI1la
 l8wg8JqJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZAYRUQAKCRAk1otyXVSH0CURB/
 9H+0wmgpfXvmHW9PsE7T58kmE54EpyIp7Prpl/OjTYGc6hS4GqYnkrMilLEezpXUEHpx8bav0OQx52
 LuhH+sSSwsk2GbkfLE3xzIukIWFckOdWGnD7lFhbaei/8J5Gedc6p5yksscH0jgX2Pwwc2rw87SA5k
 8jf29qCL2/DaAYiewjHg82zZAO0c3ym9I49SgwG/L9BEIIuUoobghgAMG1GS0VCyQEJgcFnHHj3XZ5
 XJKQ2JgThWye9FWlfRSaUiQ1Vi45E4bLP/1WErmQccYBhvDbdBjlExbAf7/U6jCU+HSKroDrM482Ui
 dtx7zzd4EmmssbnkdGUVcb80gRZkkU
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

In order to allow us to have shared code for managing fine grained traps
for KVM guests add it as a detected feature rather than relying on it
being a dependency of other features.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 11 +++++++++++
 arch/arm64/tools/cpucaps       |  1 +
 2 files changed, 12 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 2e3e55139777..6d1cda522f69 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2698,6 +2698,17 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		.min_field_value = 1,
 	},
+	{
+		.desc = "Fine Grained Traps",
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.capability = ARM64_HAS_FGT,
+		.sys_reg = SYS_ID_AA64MMFR0_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64MMFR0_EL1_FGT_SHIFT,
+		.field_width = 4,
+		.min_field_value = 1,
+		.matches = has_cpuid_feature,
+	},
 #ifdef CONFIG_ARM64_SME
 	{
 		.desc = "Scalable Matrix Extension",
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 37b1340e9646..b63cd342add2 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -24,6 +24,7 @@ HAS_DIT
 HAS_E0PD
 HAS_ECV
 HAS_EPAN
+HAS_FGT
 HAS_GENERIC_AUTH
 HAS_GENERIC_AUTH_ARCH_QARMA3
 HAS_GENERIC_AUTH_ARCH_QARMA5

-- 
2.30.2

