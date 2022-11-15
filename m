Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F29F28ED
	for <kvmarm@lists.linux.dev>; Tue, 15 Nov 2022 09:47:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81A3C433D6;
	Tue, 15 Nov 2022 09:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668505675;
	bh=LGljjsCLs8dxjxzwH6PZLMYo5rSoS7NOmeMbiTrXavY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mji7kbdLxc2addyepW0Mk+oCz5BQw3QjavsHLyOJIhXDDaLdnXg0puX7Yk5COTwjd
	 uWPFr+KGNIfgDKzNRu8eiNZ95eyk0S4Bpnc4FkeYmtsbCm85L/uDOCwESC3xo8zfJI
	 ns0BKOEhCKP36AijBIyuk6CPTfhDm1cCoLiv36ZqqBJYwEGPE02i7E+7XOtb+3hWZl
	 C+C4DKf8nUYc+VKsrcYkCSFDIpnSglJ5T35wZIhH+TeXMhVBFRhEONR/DnuSfFst3i
	 HfjJFIoODwvPJX5LLFzcFnY3QilxtjkmMGh8pAqVoz8mfovWNN+Mr44F6igl2r7Cqk
	 1CMsWBqIL75ug==
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
Subject: [PATCH v5 5/8] arm64/fpsimd: Load FP state based on recorded data type
Date: Tue, 15 Nov 2022 09:46:37 +0000
Message-Id: <20221115094640.112848-6-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221115094640.112848-1-broonie@kernel.org>
References: <20221115094640.112848-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2797; i=broonie@kernel.org; h=from:subject; bh=LGljjsCLs8dxjxzwH6PZLMYo5rSoS7NOmeMbiTrXavY=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjc1/9sYinV1dSkwun96d3I7ENQl6cc0dzhuFXZjlS s9ZP+aOJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY3Nf/QAKCRAk1otyXVSH0DzoB/ 0aflHt3HfzPfPb7ykAX7GuLaNFoM7SNRl8rZyGc0APK/fMd8yIQ8gvdxc8K2V8Chh8MekaD9BswazS +SaKRDsET2S0XqZkY2DSLZSjaZvBSm74N3dB45/pTH5Gh7sXtHONFOc1tQ3Qb+fzinaqL8gCOCpNYp 9/akNO8MC5ZtdXxV5Zuf8kgEXSMcyrERGNN/hHNPbt1psFtQvikV1/FJm8qQI1VKv+XIn2AR6vyXTr 1cFdhDZjZlI5oNjXQrwX5kMlMfyS/PLVmFed5Uasy4lPyhphv/xJLYI6/bScV1s63eCfVgSo0cJasx 6lbldZBYTqKm60jdI8J/1U+cQjN7mj
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
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/kernel/fpsimd.c | 40 ++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 3041e55b1581..eb42b00dce54 100644
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

