Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926E328ED
	for <kvmarm@lists.linux.dev>; Tue, 15 Nov 2022 09:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E47C433D6;
	Tue, 15 Nov 2022 09:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668505650;
	bh=p9BZhbfXm4Psap5bWVtFQXApnBolc3L/XBDOOw1Wa1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FGmr7SHfZkec3C1ptRBci4IVNeL7T4ekQ/itmHMNML89rX+TZGcA344Sq1mM1I28L
	 6SimlkLHkyJMd95SWnAad9vFUYk2X2m3Ury3dZq6Mcld8TBM8e2D+OTC7xBlG28OyA
	 Md3dKnDQevT8ifYibJv2OapFWv6kxAapIvZ+R35x0t2HeQp4XX5pqQqk3y/TxnBz4B
	 /yCaF/bXM56xHAicd6lkiK+OimJNpEMUJJDLCDHbiUtT7NbAJzCLEe/Y1GmiCJIexN
	 uH4z/mwu7Kb2eBhSktvf2vyV3mgj9Ye0lkbVMV/mx0QlpeD8rVaSHGV1oxhnaE0UJd
	 0sJ1DcSGCKblQ==
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
Subject: [PATCH v5 1/8] KVM: arm64: Discard any SVE state when entering KVM guests
Date: Tue, 15 Nov 2022 09:46:33 +0000
Message-Id: <20221115094640.112848-2-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221115094640.112848-1-broonie@kernel.org>
References: <20221115094640.112848-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3079; i=broonie@kernel.org; h=from:subject; bh=p9BZhbfXm4Psap5bWVtFQXApnBolc3L/XBDOOw1Wa1M=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjc1/6LNLHg4hy6Rq/UNF8qFfYL2webDv0rdbKK2Vl 3KX0bB2JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY3Nf+gAKCRAk1otyXVSH0BwwB/ 9i85NRA4v5BLV2bSeuTLwxeRMJYsM9UOIyZGUBFC3//dsLHtI9UUt2Aa0CmSNGIZYaBF38tb8RgMKJ iqk2AqxLociIQ74iVU9gjQnnM9ASiroqeKnnGwpH3fICI+EPrkO629NMjPM/gZwWj55BZfLYPWCH/K GXlVYUHpZvhDpiHmmzDLZeTqgkVYmcFQDJlbhYt8y8vnI26b9AU6rVAujVG2fxV5T/SSnceNEQfflz 7PX11qMF4fx4Sf1KJXxAkNsN57M/gAvNigpQMWxzYyVm5g8UEHOIQHsI+o89/30jaRVhICfspwiUQN aFgP216Z0SkSRhdFPnjTWaCY+dQ/Wk
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

Since 8383741ab2e773a99 (KVM: arm64: Get rid of host SVE tracking/saving)
KVM has not tracked the host SVE state, relying on the fact that we
currently disable SVE whenever we perform a syscall. This may not be true
in future since performance optimisation may result in us keeping SVE
enabled in order to avoid needing to take access traps to reenable it.
Handle this by clearing TIF_SVE and converting the stored task state to
FPSIMD format when preparing to run the guest.  This is done with a new
call fpsimd_kvm_prepare() to keep the direct state manipulation
functions internal to fpsimd.c.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/fpsimd.h |  1 +
 arch/arm64/kernel/fpsimd.c      | 23 +++++++++++++++++++++++
 arch/arm64/kvm/fpsimd.c         |  3 ++-
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 6f86b7ab6c28..c07e4abaca3d 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -56,6 +56,7 @@ extern void fpsimd_signal_preserve_current_state(void);
 extern void fpsimd_preserve_current_state(void);
 extern void fpsimd_restore_current_state(void);
 extern void fpsimd_update_current_state(struct user_fpsimd_state const *state);
+extern void fpsimd_kvm_prepare(void);
 
 extern void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *state,
 				     void *sve_state, unsigned int sve_vl,
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 23834d96d1e7..549e11645e0f 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1627,6 +1627,29 @@ void fpsimd_signal_preserve_current_state(void)
 		sve_to_fpsimd(current);
 }
 
+/*
+ * Called by KVM when entering the guest.
+ */
+void fpsimd_kvm_prepare(void)
+{
+	if (!system_supports_sve())
+		return;
+
+	/*
+	 * KVM does not save host SVE state since we can only enter
+	 * the guest from a syscall so the ABI means that only the
+	 * non-saved SVE state needs to be saved.  If we have left
+	 * SVE enabled for performance reasons then update the task
+	 * state to be FPSIMD only.
+	 */
+	get_cpu_fpsimd_context();
+
+	if (test_and_clear_thread_flag(TIF_SVE))
+		sve_to_fpsimd(current);
+
+	put_cpu_fpsimd_context();
+}
+
 /*
  * Associate current's FPSIMD context with this cpu
  * The caller must have ownership of the cpu FPSIMD context before calling
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index ec8e4494873d..51ca78b31b95 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -75,11 +75,12 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 {
 	BUG_ON(!current->mm);
-	BUG_ON(test_thread_flag(TIF_SVE));
 
 	if (!system_supports_fpsimd())
 		return;
 
+	fpsimd_kvm_prepare();
+
 	vcpu->arch.fp_state = FP_STATE_HOST_OWNED;
 
 	vcpu_clear_flag(vcpu, HOST_SVE_ENABLED);
-- 
2.30.2

