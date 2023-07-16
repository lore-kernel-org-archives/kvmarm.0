Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE46F9444
	for <kvmarm@lists.linux.dev>; Sun, 16 Jul 2023 21:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9FC2C433CD;
	Sun, 16 Jul 2023 21:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689544425;
	bh=5itbN5XsI23hSHpvwvYCaA48pJH6cAkdAvMEghq3bJY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=B3WvwLPa0kPZ05606e24d+wKXy8XvpvoWS8YyXrjOnIukFSSQjhJyUhJjQ5PzlGRO
	 4fopiqdU0YF7x5/huJrF7KQ1A3IiNvr910mVOS+lL0aHGqvThP7j3SBISVrQihTTVN
	 KEK6mooqm4aeC+0i9FAeSvNEzSX6rjL3UmKdWHOUkmvJYeBnz5mEBlDTvMnwRnj+bT
	 f1pEcJrT7JyJS7kWKg3ntcxzSmPf160RwTF7Oe8QMN9pjhEuAmQMG89D/9zH8fjwgd
	 7YM/JEc3IOzMz8gZQmhtML7z2GKqPNIx+KgdLFhahrmLs+wlctaioJTYMx0LrobbP7
	 6FKUm+ZYqoDSA==
From: Mark Brown <broonie@kernel.org>
Date: Sun, 16 Jul 2023 22:51:05 +0100
Subject: [PATCH 09/35] arm64/cpufeature: Runtime detection of Guarded
 Control Stack (GCS)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230716-arm64-gcs-v1-9-bf567f93bba6@kernel.org>
References: <20230716-arm64-gcs-v1-0-bf567f93bba6@kernel.org>
In-Reply-To: <20230716-arm64-gcs-v1-0-bf567f93bba6@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Andrew Morton <akpm@linux-foundation.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Arnd Bergmann <arnd@arndb.de>, 
 Oleg Nesterov <oleg@redhat.com>, Eric Biederman <ebiederm@xmission.com>, 
 Kees Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>, 
 "Rick P. Edgecombe" <rick.p.edgecombe@intel.com>, 
 Deepak Gupta <debug@rivosinc.com>, Ard Biesheuvel <ardb@kernel.org>, 
 Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.13-dev-099c9
X-Developer-Signature: v=1; a=openpgp-sha256; l=3031; i=broonie@kernel.org;
 h=from:subject:message-id; bh=5itbN5XsI23hSHpvwvYCaA48pJH6cAkdAvMEghq3bJY=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBktGaWtHOw3enM4B5g54amxlUgz0T6xDyKMI+X9aWP
 sDgDapSJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZLRmlgAKCRAk1otyXVSH0DjsB/
 0ftgZjkmfkC59iaeyPxrKWG/EPzbWppuZtL8wn2nYjEI3bKdPsmO0+WXETjIu9YHQORgfIW30ICk9U
 HmPWiGbezKYCwJ/zM3zsqbeXD87zxToeeKUH4htD7F9lMAbpaK9YOLJ596ay8x5+rjIlXdxvxnSv+V
 WBhYXp4H998g2hwxyzNly3XnI0XFqdKO4B1FhThymySJjhLOLi+08NAoJe+zsNJD4tHL+IF/J2EoHB
 WL4/ADcAuOeBMtWPKBRFOodh5DaZ9bZu1dUrVcFM1LJIJLtiPEyxaL9oa1AN7vV4WoDQod9H2+4gOB
 /CLOY7fL0loYFvUKiTy6SeyWF+d9AN
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Add a cpufeature for GCS, allowing other code to conditionally support it
at runtime.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/cpufeature.h |  6 ++++++
 arch/arm64/kernel/cpufeature.c      | 20 ++++++++++++++++++++
 arch/arm64/tools/cpucaps            |  1 +
 3 files changed, 27 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 96e50227f940..189783142a96 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -831,6 +831,12 @@ static inline bool system_supports_tlb_range(void)
 		cpus_have_const_cap(ARM64_HAS_TLB_RANGE);
 }
 
+static inline bool system_supports_gcs(void)
+{
+	return IS_ENABLED(CONFIG_ARM64_GCS) &&
+		cpus_have_const_cap(ARM64_HAS_GCS);
+}
+
 int do_emulate_mrs(struct pt_regs *regs, u32 sys_reg, u32 rt);
 bool try_emulate_mrs(struct pt_regs *regs, u32 isn);
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index f9d456fe132d..92e730027d84 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -254,6 +254,8 @@ static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64pfr1[] = {
+	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_GCS),
+		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_GCS_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SME),
 		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_SME_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_MPAM_frac_SHIFT, 4, 0),
@@ -2219,6 +2221,12 @@ static void cpu_enable_mops(const struct arm64_cpu_capabilities *__unused)
 	sysreg_clear_set(sctlr_el1, 0, SCTLR_EL1_MSCEn);
 }
 
+static void cpu_enable_gcs(const struct arm64_cpu_capabilities *__unused)
+{
+	/* GCS is not currently used at EL1 */
+	write_sysreg_s(0, SYS_GCSCR_EL1);
+}
+
 /* Internal helper functions to match cpu capability type */
 static bool
 cpucap_late_cpu_optional(const struct arm64_cpu_capabilities *cap)
@@ -2715,6 +2723,18 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.min_field_value = ID_AA64MMFR2_EL1_EVT_IMP,
 		.matches = has_cpuid_feature,
 	},
+	{
+		.desc = "Guarded Control Stack (GCS)",
+		.capability = ARM64_HAS_GCS,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.sys_reg = SYS_ID_AA64PFR1_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64PFR1_EL1_GCS_SHIFT,
+		.field_width = 4,
+		.min_field_value = ID_AA64PFR1_EL1_GCS_IMP,
+		.matches = has_cpuid_feature,
+		.cpu_enable = cpu_enable_gcs,
+	},
 	{},
 };
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index c80ed4f3cbce..ab582f592131 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -26,6 +26,7 @@ HAS_ECV
 HAS_ECV_CNTPOFF
 HAS_EPAN
 HAS_EVT
+HAS_GCS
 HAS_GENERIC_AUTH
 HAS_GENERIC_AUTH_ARCH_QARMA3
 HAS_GENERIC_AUTH_ARCH_QARMA5

-- 
2.30.2

