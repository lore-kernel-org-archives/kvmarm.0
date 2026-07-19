Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61C32B9B7;
	Sun, 19 Jul 2026 23:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784502607; cv=none; b=EgoGY5p9V+7XGCS7BzgcUXRErxPmA3C+2WPQmfbWi1bDo8QiEaPuHELu6QDs3rao/UWZXrf+sqoe+/nvAjhiu4FAie+/6mINsWHmWlrBsCu4rIMPqKw36Qmwf3TRJ8xVuHZ6irJnWgYUbscnQEbcihKRrev0ywXqrENIFOHUVG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784502607; c=relaxed/simple;
	bh=clF88Q4Q++Obbm8UOSQg/p4rzpktP8Z7HgDS1dOLUf4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZG7NScw01tLKiQKqGt+zyqEvxLD+zAbJRgsFsgBa9aZk11Z1RszuYj/nHammp56boRo0dSrMrAB6Q0c3BiOmqKKv/HrF5R+sMCCUg+zDGvdCYdTgP+gLbtzNARfSaYeU41nrR2n24xT4kppsmIJ8b895cNNx9ZFn4mpJoA5WTeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ca09oOBj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ca09oOBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4571F000E9;
	Sun, 19 Jul 2026 23:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784502606;
	bh=eTfU+3gRILRsep1OeyOpzQlJd2O1qxNpsyVnL6cFMrQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ca09oOBjr3+encUJ/u9jcpCA+2WrhlONLFPknKiiUcSm4bZHip3bDeoBOLkSMesBq
	 2RW2SyTgnVnVumqBdav7dnqGTVbRfUJcc34lVW1QB2Zi1QgcVmKdKeXrbrWseu03Wo
	 HJEWORWveBQv5blLK2xc6yFkuaVh84AdeX/oZYxudZX/lRNSnNxwSvF31aZjOxsk0g
	 j/0aUk0hD21BZuAykxhPwloFAOgK2EDMXHDm8fJe+S57ecKDt+HioAycJ+V8gbRAsI
	 47lgLFHB0H/nsSIwOXfeSvnM16v6EhsW7Juyn5tZg9DgHeJvC+5KR3qra7bLnti+gy
	 x61rNMMeK7u2Q==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 20 Jul 2026 00:07:29 +0100
Subject: [PATCH v13 02/32] arm64/fpsimd: Ensure all of ZCR_EL1 is
 initialised from idle
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-kvm-arm64-sme-v13-2-d9abd3ffa245@kernel.org>
References: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
In-Reply-To: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
 Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 Jean-Philippe Brucker <jpb@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Peter Maydell <peter.maydell@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3682; i=broonie@kernel.org;
 h=from:subject:message-id; bh=clF88Q4Q++Obbm8UOSQg/p4rzpktP8Z7HgDS1dOLUf4=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqXVko7WT9BD6E6lLZIiVH1XDlT15U/QuOW9/ff
 EG0PpVJG8+JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCal1ZKAAKCRAk1otyXVSH
 0DnvB/0QktPiWkbF6fHJalPB1OgY3yy/F0vT9g6NTN8UCrvSd3lZaVgD48hOfO31NeHgEpI0BCv
 u7bv+ZhtnVfktppXY2fBsk2lBx7TfDeIc3biWpbonSJSRusyf9yaPyG9WYG3YMgkSR94bQsozsz
 ijjEyS0r7VPN5KWNTleYrmAaPlo5LorS7EvOKJutXWcrmDMC1HlNZ6HsrwecBF9Tms6ap421H98
 SgWdwXt0iyxrTfEgUQMy3tPr666H/oDpA3svzX8VAwFI2nIDBFHIvwCwO7cn1qY5YGgabEX/cTM
 mwZCcT0TXFu0pRWE9fwBX1stg0jaEOq+QzBH9AEyk75K9vcW
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

At present when exiting from idle we do not fully reinitialise ZCR_EL1,
we update ZCR_EL1.LEN with a read/modify/write cycle when loading task
state but never set any of the other bits to an explicit value.  Since
currently they are all architecturally RES0 or RAZ/WI this is not a
practical issue but it may become one if further fields are defined in
the register so we should explicitly configure the whole register.

Rename the existing sme_suspend_exit() (which handles this for SME) to
fpsimd_suspend_exit() and add set ZCR_EL1 to 0 there, if needed LEN will
be updated when loading task state.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/fpsimd.h |  4 ++--
 arch/arm64/kernel/fpsimd.c      | 24 +++++++++++++-----------
 arch/arm64/kernel/suspend.c     |  2 +-
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index a67d5774e672..e13a85320ab6 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -364,6 +364,8 @@ extern void cpu_enable_sme2(const struct arm64_cpu_capabilities *__unused);
 extern void cpu_enable_fa64(const struct arm64_cpu_capabilities *__unused);
 extern void cpu_enable_fpmr(const struct arm64_cpu_capabilities *__unused);
 
+extern void fpsimd_suspend_exit(void);
+
 /*
  * Helpers to translate bit indices in sve_vq_map to VQ values (and
  * vice versa).  This allows find_next_bit() to be used to find the
@@ -623,7 +625,6 @@ static inline unsigned int sme_get_vl(void)
 extern void sme_alloc(struct task_struct *task, bool flush);
 extern int sme_set_current_vl(unsigned long arg);
 extern int sme_get_current_vl(void);
-extern void sme_suspend_exit(void);
 
 static inline size_t __sme_state_size(unsigned int sme_vl)
 {
@@ -779,7 +780,6 @@ static inline int sme_max_vl(void) { return 0; }
 static inline int sme_max_virtualisable_vl(void) { return 0; }
 static inline int sme_set_current_vl(unsigned long arg) { return -EINVAL; }
 static inline int sme_get_current_vl(void) { return -EINVAL; }
-static inline void sme_suspend_exit(void) { }
 
 static inline size_t __sme_state_size(unsigned int sme_vl)
 {
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index e7f1682a3059..78c9d8dab545 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1279,24 +1279,26 @@ void __init sme_setup(void)
 		get_sme_default_vl());
 }
 
-void sme_suspend_exit(void)
+#endif /* CONFIG_ARM64_SME */
+
+void fpsimd_suspend_exit(void)
 {
 	u64 smcr = 0;
 
-	if (!system_supports_sme())
-		return;
+	if (system_supports_sve())
+		write_sysreg_s(0, SYS_ZCR_EL1);
 
-	if (system_supports_fa64())
-		smcr |= SMCR_ELx_FA64;
-	if (system_supports_sme2())
-		smcr |= SMCR_ELx_EZT0;
+	if (system_supports_sme()) {
+		if (system_supports_fa64())
+			smcr |= SMCR_ELx_FA64;
+		if (system_supports_sme2())
+			smcr |= SMCR_ELx_EZT0;
 
-	write_sysreg_s(smcr, SYS_SMCR_EL1);
-	write_sysreg_s(0, SYS_SMPRI_EL1);
+		write_sysreg_s(smcr, SYS_SMCR_EL1);
+		write_sysreg_s(0, SYS_SMPRI_EL1);
+	}
 }
 
-#endif /* CONFIG_ARM64_SME */
-
 /*
  * Trapped SVE access
  *
diff --git a/arch/arm64/kernel/suspend.c b/arch/arm64/kernel/suspend.c
index eaaff94329cd..e02728d14e0d 100644
--- a/arch/arm64/kernel/suspend.c
+++ b/arch/arm64/kernel/suspend.c
@@ -81,7 +81,7 @@ void notrace __cpu_suspend_exit(void)
 	 */
 	spectre_v4_enable_mitigation(NULL);
 
-	sme_suspend_exit();
+	fpsimd_suspend_exit();
 
 	/* Restore additional feature-specific configuration */
 	ptrauth_suspend_exit();

-- 
2.47.3

