Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC842F30
	for <kvmarm@lists.linux.dev>; Wed, 29 Mar 2023 15:46:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC31C433A0;
	Wed, 29 Mar 2023 15:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1680104779;
	bh=/uGx45HMfQP5sjD2snoqgNI1enn4/7Is9C9kcXV6zXE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=fzqa6vRsbqPNvFj5rGpZs27ASHjBXjhthX0P5aovCYmRA2zvqElurCQPZwYFQiggk
	 R9+YOPq/BBVjKUlcxr5bd/MILKLf/xD8zBlOVCDDyeAQ+6qn1+MHuWSlLvVnl3ZSyp
	 ixBbAn7Y2sdJ0LIl+tXpMUPlyDknOt8NL8/w+b7LW7LYaxI/lmC5rx8aAUr443mXE0
	 vEUhc1r6GkhUKhvPyEMO70iLdYxW1acsF8OIXxwJ5dTzKNdukgHk42MXjxY1OPFJIz
	 vaDsDQg9QcgjuwWoBPubCpZhS8z1zdRwMfMs61FN/N1OnTNNIipIyiiD81ohwzOaVJ
	 ZKdyMS/WeQtcw==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 29 Mar 2023 16:38:17 +0100
Subject: [PATCH v3 1/2] arm64: Add feature detection for fine grained traps
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230301-kvm-arm64-fgt-v3-1-8f59543bb683@kernel.org>
References: <20230301-kvm-arm64-fgt-v3-0-8f59543bb683@kernel.org>
In-Reply-To: <20230301-kvm-arm64-fgt-v3-0-8f59543bb683@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.13-dev-bd1bf
X-Developer-Signature: v=1; a=openpgp-sha256; l=1486; i=broonie@kernel.org;
 h=from:subject:message-id; bh=/uGx45HMfQP5sjD2snoqgNI1enn4/7Is9C9kcXV6zXE=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBkJF1FKjRHUrmMuqLJbThUNexFUIK5IessJk8snaGR
 PBZnClKJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZCRdRQAKCRAk1otyXVSH0KUNB/
 9QA+9Y2SpKqrcNCYl3II67ZthhykNmaw0KMvXWaPd/bTgDrM/+HRdgWqC4ixXsf0FzJ9P4L5ygS+ce
 CROjQ2Jd5FkcweLMllW8ZZ3kLXyZEXQRTf0nE+A2+s/tL+sUewy/UpU7pLvekG9s0AezmUOwuTwvf/
 WYd03DR7CBZaUneRY5fzRM2E/hE8wpi2GuGuTEg+XhetX1r4bpSteqYw5P+eF8c4Vcvqc3aAUR0sJY
 X4iUWBxncWmwAh6N9xvfSnCI7b3SGFoKNMcZ/i2mnPMKmp7Wfd+PihHm2sOoA7+tlc0ozMetM6vSxX
 4QiCg06D5TyJFva2h1SXOj8boT4r13
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

In order to allow us to have shared code for managing fine grained traps
for KVM guests add it as a detected feature rather than relying on it
being a dependency of other features.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
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

