Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2FDA93A
	for <kvmarm@lists.linux.dev>; Thu, 23 Mar 2023 15:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2BCC433A0;
	Thu, 23 Mar 2023 15:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1679586557;
	bh=/uGx45HMfQP5sjD2snoqgNI1enn4/7Is9C9kcXV6zXE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=LPDha8QjcAnciWhAL5JRLE3LZ+gTwHPTcuBwiRnKiL1bv/eItD1pyU5SHK9AZxktd
	 1zs6vNpM2n5SnRPsNEA9eUV0zb3uB5jPMyrDCg2dOwuKxaTJc3iKb5j28HZl9TBQ8f
	 rNyHGQq4nuVUaKrr0/4W5I77cAfV97/sKj+5H+m8DaAKfizNzgL2VbTqC7ZoP1gjmJ
	 I8YxEOQmYI0Eg0MGr01zB1ZA3c/NdlzPfigOnGAMUD+rb7TzC0nIyaG+5g1OCBf97F
	 4O1bpaEyiA2ahIIJZrerj+GGSpPaTFIpkm1jxWbxc0hu8RIKB+WnrKSLM99AQINseI
	 ruyJbjXast/aQ==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 23 Mar 2023 15:48:35 +0000
Subject: [PATCH v2 1/2] arm64: Add feature detection for fine grained traps
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230301-kvm-arm64-fgt-v2-1-c11c0dcf810a@kernel.org>
References: <20230301-kvm-arm64-fgt-v2-0-c11c0dcf810a@kernel.org>
In-Reply-To: <20230301-kvm-arm64-fgt-v2-0-c11c0dcf810a@kernel.org>
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
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBkHHT2PqGya4Sl7tNN4HF4r8Ro9DsEi+1tZ82Lgjlk
 z8Y77uWJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZBx09gAKCRAk1otyXVSH0PQsB/
 94GcRFdZKNfASYdsAPdBqiQFT40EJlBPVqv7Ue0gA9h8z2Hb74Wt4ZuyxPe/oEece5Gzb2oY2kp+4t
 KsWS/JSNZc93Zq1nD9p6PSEDHRv2xh260FdIqL4OgLQ1wPb4+f3gZu8BGMzRIgqi7eFkwQbrwNPAQ2
 8DRrF+oZHBWz1Thsl3VtVPI/B9KbIccOrfnveSoOp89EpK9STS1ZxxezLGkWZoUABJX8Z+e4uy8Z1B
 eqQy6/L/DFdHoB/6RBnTqXsNrYQNNQiA/BXiwLaBVR74wjp6NhQVrNyP+g/3G+33eoV+eBIDBP1CJz
 vFtWXjzWp68xmU0WZXGFFQ+0ki3yIV
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

