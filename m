Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A6D6AB5
	for <kvmarm@lists.linux.dev>; Fri, 21 Oct 2022 23:03:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9D5C433B5;
	Fri, 21 Oct 2022 23:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666393425;
	bh=ZvYiIfT5ER5q7RSkta6D4TuM/yaUmcDGYH8/za2JEqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CsFGCqMsuJOyrNiaOouAnJCtANJ4MjsHTdbvUKBtYyB6UgTtjPNxUhYe/mItVKoF+
	 tzNlFLJSBCrQm0pIWdtEQMu2SOjQ+SAAuMLwRNLKq+kvH3Ca/5rI0CcFKw9acKMH+9
	 D+smgG27km0iGGd7zTrJxpZ+aK3/EM0rSC/MfNTRprjuffm0BCYV/nMN3NajfPWBcc
	 nT8x/K039KHArn4d/Ipx5l1dHqyQAyo7fZwqwKrT7/Ib31I+ChT0baarNsPIH/wi4g
	 w1d9L0F/ZxanR4OKLO2B/+9oBDVi9E0CrMr+aoqz2xkZClFdsKJGjVt6WoRmCMH4zI
	 OYenBZC0HuwdQ==
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
Subject: [PATCH v4 1/8] KVM: arm64: Discard any SVE state when entering KVM guests
Date: Sat, 22 Oct 2022 00:03:14 +0100
Message-Id: <20221021230321.1159287-2-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221021230321.1159287-1-broonie@kernel.org>
References: <20221021230321.1159287-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3023; i=broonie@kernel.org; h=from:subject; bh=ZvYiIfT5ER5q7RSkta6D4TuM/yaUmcDGYH8/za2JEqE=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjUyUxCdF/76f87U3Az0gAQWitbu7/dHVbFexdIzzK e+klnAKJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY1MlMQAKCRAk1otyXVSH0F5EB/ 9f0PNHy/wMYUkDMbuETCpHlp0enRwRotwfBt3IPCOcpd/R5EFWBksx4+gsOi3NfxMxeMcmmT8qCW9N MN8/nuHMr0//viXAmxha3itxGdqxUaAbTPy45lbvKwxO/Jy3/qK5G36qlf3Mf/LCsPUctiJj5IIkYO gZTptX3otGJeGnBGnbbTYFL82TK7DvNszgywLcoa59OGMoI3cCIrFhfJ0gGyg0uQHnWQhi3p3PN7dZ UzRan8BwGs8o53SJDu74hErlW6grA/lUQltgCvHukQq2sgOWuHotC7lJxfC3lVjYHvzzzNs9VcBXnG cXO/vWS81QeslJIrWdkx6CowBwQGqr
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

