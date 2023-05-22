Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44A4154BB
	for <kvmarm@lists.linux.dev>; Mon, 22 May 2023 16:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D1AC433A0;
	Mon, 22 May 2023 16:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684772652;
	bh=Tvvke9JuKgQUntdbgrEqu1jI2jiIofmhsgpeN97HTNs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ALa2tDS/s1R1uLXxdkUQc+98Izftxz09eWr+sK6CSMt0f1pFWEEX3DELzjLJ3VKtE
	 iKNXKyrhLuBtQ7saAgmHaKww7WGvc/p/ddqnv5z3u8Cn1Dmqv0ZAA78+ycSpNyj5R8
	 ffdE//yCgkn93pxJgGcCi9Q+au/iYPdoJtOiGwf74CcbAmcUhMunP4BjYo6CNbZNOr
	 pVKyuD2OVjmJBLPQGz+Vvz/i1n84jq+yfJesFCPmGxa8t2h9pj5iwCo5kIcso6G/Ir
	 RM2vTpiAZ39vdTE6Yo2+UMh4L4nRHs8HZ9zvx8bHEAHg6A8B5EhOTK5cDCDCGB/HSk
	 gCFIWCUm/8MLQ==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 22 May 2023 17:23:56 +0100
Subject: [PATCH v4 1/2] arm64: Add feature detection for fine grained traps
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230301-kvm-arm64-fgt-v4-1-1bf8d235ac1f@kernel.org>
References: <20230301-kvm-arm64-fgt-v4-0-1bf8d235ac1f@kernel.org>
In-Reply-To: <20230301-kvm-arm64-fgt-v4-0-1bf8d235ac1f@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.13-dev-bfdf5
X-Developer-Signature: v=1; a=openpgp-sha256; l=1521; i=broonie@kernel.org;
 h=from:subject:message-id; bh=Tvvke9JuKgQUntdbgrEqu1jI2jiIofmhsgpeN97HTNs=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBka5claTs0BAaIHaGN8OuBKDBRvmNGHSiDj6A4X3pw
 mK4Cz7aJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZGuXJQAKCRAk1otyXVSH0FYYB/
 9/IKpL/3TO1HaR/5GzEhkQ9SzUkfgdzbaHIwachcgFnFdHbfbNrnHt6sDpcGqhlOz+J/tqLZsPap0x
 pGHEKxq7WFQC34cg/dXMjnIVbFscLrLjoK5hAiwIFIemYEnBlPuA3C3rA5y76izA/+PmaRem7xb8ZA
 8HpqwiFef6SlPywSeGdkbCn/vrrvAuCi6vY0TkhVdOO9mj09PM/tjL6bDsajGpYUzuB+DsenZ3UsLT
 Rk1iqf5JatI0HOMl/kgx7N1y7/DgyMkIkoEmpo7TDY564/fEDTjIg6LAka4cc2ZqGB4/Xhuubtmmuu
 Sd6k92BXU14YO0nzibQ+MIZVfoebvr
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
index 7d7128c65161..a103ec454f02 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2591,6 +2591,17 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		ARM64_CPUID_FIELDS(ID_AA64ISAR1_EL1, LRCPC, IMP)
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
index 40ba95472594..bd93b3446e34 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -25,6 +25,7 @@ HAS_E0PD
 HAS_ECV
 HAS_ECV_CNTPOFF
 HAS_EPAN
+HAS_FGT
 HAS_GENERIC_AUTH
 HAS_GENERIC_AUTH_ARCH_QARMA3
 HAS_GENERIC_AUTH_ARCH_QARMA5

-- 
2.30.2

