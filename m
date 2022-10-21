Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9836AB5
	for <kvmarm@lists.linux.dev>; Fri, 21 Oct 2022 23:03:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93054C433D6;
	Fri, 21 Oct 2022 23:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666393435;
	bh=42ueoI/MDYVKCx924g9DZQGJowDMcrRoqKoHiJ2JNZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VJUgMGEn6Sgw3Al8twHzfz+L4AOvtu0ORb9gJHOR/t3ytJEHECfIkrDTF7mBbMnTb
	 YENhqNJuJqQt7JTpYawKzBPFMaWLJaJEKd+/KrOwmbcuwdaT2XLdF629TEANPj8rx1
	 tpfVovOR+LCsb2FjoC5JB85/4CwMr3rCLu5G8nr6FJTrUY/L5lNoHgVY93RZwwj00g
	 pSr5Zl5f8YZ0J3WqfoOjNKA7qoJddfpieDi6xRj5GI/wvd1TmTkHszYm0HqNzE+Tnn
	 WTyFRUulanj9SI9RQ1RrFShSuwHUAMaodQWqjZHkgOLHPK9v/oEZBvwKHGmNqyr8NQ
	 CziVZzw5kkWYg==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>,
	Zhang Lei <zhang.lei@jp.fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 5/8] arm64/fpsimd: Load FP state based on recorded data type
Date: Sat, 22 Oct 2022 00:03:18 +0100
Message-Id: <20221021230321.1159287-6-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221021230321.1159287-1-broonie@kernel.org>
References: <20221021230321.1159287-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2741; i=broonie@kernel.org; h=from:subject; bh=42ueoI/MDYVKCx924g9DZQGJowDMcrRoqKoHiJ2JNZE=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjUyU1+Qk+XbikpMcBXirp0nwoRf9ps2moCQSRjTys bvNDbdeJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY1MlNQAKCRAk1otyXVSH0KjwB/ 9sNmN0pJJcmddkG+ivwf0Ae0VBDZIspt8rVxLyNejUgnqK8rhMXIpBffmaDbmfT7kPp+n9yUkQcfJS KaMZ9nU5kSlK4nImIHcG5N+HdUkt0fxsAGY/fdziSgAT1MYfSPsGvp2yKbXhIyNxUDPLeEI/r0wNlU /jLEI0fjxHTIUUGP+ZS2IYdx1lhFZmOn2VtpUzquF1nRBcwtjEhAmoHxlgzgxj6m/UP6QFVxR2USGg tf57noGnwaPXwIAD/YHqpgBTT2FePFZNFjYq5x/4whv45r0PWd68KO8Pq/qHcbatnOVMPTtoLLM3zO IKlK01PMaMqkgrcJ4W0zZfdGuGQY0w
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

Now that we are recording the type of floating point register state we
are saving when we write the register state out to memory we can use
that information when we load from memory to decide which format to
load, bringing TIF_SVE into line with what we saved rather than relying
on TIF_SVE to determine what to load.

The SME state details are already recorded directly in the saved
SVCR and handled based on the information there.

Since we are not changing any of the save paths there should be no
functional change from this patch, further patches will make use of this
to optimise and clarify the code.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/fpsimd.c | 40 ++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 65ea8163c7f6..6544ecb297a5 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -395,11 +395,37 @@ static void task_fpsimd_load(void)
 	WARN_ON(!system_supports_fpsimd());
 	WARN_ON(!have_cpu_fpsimd_context());
 
-	/* Check if we should restore SVE first */
-	if (IS_ENABLED(CONFIG_ARM64_SVE) && test_thread_flag(TIF_SVE)) {
-		sve_set_vq(sve_vq_from_vl(task_get_sve_vl(current)) - 1);
-		restore_sve_regs = true;
-		restore_ffr = true;
+	if (system_supports_sve()) {
+		switch (current->thread.fp_type) {
+		case FP_STATE_FPSIMD:
+			/* Stop tracking SVE for this task until next use. */
+			if (test_and_clear_thread_flag(TIF_SVE))
+				sve_user_disable();
+			break;
+		case FP_STATE_SVE:
+			if (!thread_sm_enabled(&current->thread) &&
+			    !WARN_ON_ONCE(!test_and_set_thread_flag(TIF_SVE)))
+				sve_user_enable();
+
+			if (test_thread_flag(TIF_SVE))
+				sve_set_vq(sve_vq_from_vl(task_get_sve_vl(current)) - 1);
+
+			restore_sve_regs = true;
+			restore_ffr = true;
+			break;
+		default:
+			/*
+			 * This indicates either a bug in
+			 * fpsimd_save() or memory corruption, we
+			 * should always record an explicit format
+			 * when we save. We always at least have the
+			 * memory allocated for FPSMID registers so
+			 * try that and hope for the best.
+			 */
+			WARN_ON_ONCE(1);
+			clear_thread_flag(TIF_SVE);
+			break;
+		}
 	}
 
 	/* Restore SME, override SVE register configuration if needed */
@@ -415,10 +441,8 @@ static void task_fpsimd_load(void)
 		if (thread_za_enabled(&current->thread))
 			za_load_state(current->thread.za_state);
 
-		if (thread_sm_enabled(&current->thread)) {
-			restore_sve_regs = true;
+		if (thread_sm_enabled(&current->thread))
 			restore_ffr = system_supports_fa64();
-		}
 	}
 
 	if (restore_sve_regs) {
-- 
2.30.2

