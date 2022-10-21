Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD36C6AB5
	for <kvmarm@lists.linux.dev>; Fri, 21 Oct 2022 23:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA5AC433B5;
	Fri, 21 Oct 2022 23:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666393443;
	bh=OtC70SIN9mH9KFjzUBIVH0zuzHvdzXBo2osQ7N46N+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=so9/0MtB2kL/sd6z7SfRohTE0GEEm74uhx11DapLbceGKJhi2+3Dw86QuZwnoe/jK
	 53el99sH5vMhdAoxUqfp049/pUTaR+E4ySWLdnDLRndxmu2+UV7SaUThJrd4glMlJ8
	 bDm1gWtT5WazkEM7B+BpV9ECUOpXvR8PgMwodYHY9wtwVqOA4uehvNJUljahxogq5x
	 Yi+fBTsRTyRXh/wBgsE3jegVeENWj7RxoZltLVR3vmKO4OeWwtUxJEW1bS/KJAdVOc
	 wVnyKGDHRJiSUoH8scBZfdE77TaG8Myzx7jEYUGM3RvNnyP7acnbZ/8O14Me6EnNym
	 OgMo84+4petSw==
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
Subject: [PATCH v4 8/8] arm64/fp: Use a struct to pass data to fpsimd_bind_state_to_cpu()
Date: Sat, 22 Oct 2022 00:03:21 +0100
Message-Id: <20221021230321.1159287-9-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221021230321.1159287-1-broonie@kernel.org>
References: <20221021230321.1159287-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5745; i=broonie@kernel.org; h=from:subject; bh=OtC70SIN9mH9KFjzUBIVH0zuzHvdzXBo2osQ7N46N+s=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjUyU48CIsX3cJPVYh5fFvc2IzphS/0C7dMQ+FYDqS 6AqwFYyJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY1MlOAAKCRAk1otyXVSH0KQ+B/ 451cp1G4w3hczpFNUq+6BLP6h+au2xGpLni6zQDid4txZyuNzj154qk6BbHMHr1P3XqvntH/5fw5lL uorqiHaM7cEdnoJ4mTC2uir5C0gNocX+5ZdOBji+fb+pFm11n3aNai8w4Kyurjm1Fhv4R/4R66Y4Ee /KeOQIlxjhjiIDTFUbO+qwAETC9Th5QtAMOCHRD58jS7XBmiC3t+gC+z0yb5APBwNKqkQHyaXimXO/ OVggmLNLPSAO0WasFqA8JhxMjxqkkTgXwHlsfBDugpgYOX24q6iRRQ4OY25k/dd1xkKmgoonm2IeCH Wh6LnRfxc0eH9b6nBIu48MJWoveHXc
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

For reasons that are unclear to this reader fpsimd_bind_state_to_cpu()
populates the struct fpsimd_last_state_struct that it uses to store the
active floating point state for KVM guests by passing an argument for
each member of the structure. As the richness of the architecture increases
this is resulting in a function with a rather large number of arguments
which isn't ideal.

Simplify the interface by using the struct directly as the single argument
for the function, renaming it as we lift the definition into the header.
This could be built on further to reduce the work we do adding storage for
new FP state in various places but for now it just simplifies this one
interface.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/fpsimd.h | 17 ++++++++++++-----
 arch/arm64/kernel/fpsimd.c      | 34 ++++++---------------------------
 arch/arm64/kvm/fpsimd.c         | 24 +++++++++++++----------
 3 files changed, 32 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 0ad683dab1e2..e6fa1e2982c8 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -58,11 +58,18 @@ extern void fpsimd_restore_current_state(void);
 extern void fpsimd_update_current_state(struct user_fpsimd_state const *state);
 extern void fpsimd_kvm_prepare(void);
 
-extern void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *state,
-				     void *sve_state, unsigned int sve_vl,
-				     void *za_state, unsigned int sme_vl,
-				     u64 *svcr, enum fp_type *type,
-				     enum fp_type to_save);
+struct cpu_fp_state {
+	struct user_fpsimd_state *st;
+	void *sve_state;
+	void *za_state;
+	u64 *svcr;
+	unsigned int sve_vl;
+	unsigned int sme_vl;
+	enum fp_type *fp_type;
+	enum fp_type to_save;
+};
+
+extern void fpsimd_bind_state_to_cpu(struct cpu_fp_state *fp_state);
 
 extern void fpsimd_flush_task_state(struct task_struct *target);
 extern void fpsimd_save_and_flush_cpu_state(void);
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 984ea997e7ca..8b1f9b44d831 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -118,18 +118,8 @@
  *   returned from the 2nd syscall yet, TIF_FOREIGN_FPSTATE is still set so
  *   whatever is in the FPSIMD registers is not saved to memory, but discarded.
  */
-struct fpsimd_last_state_struct {
-	struct user_fpsimd_state *st;
-	void *sve_state;
-	void *za_state;
-	u64 *svcr;
-	unsigned int sve_vl;
-	unsigned int sme_vl;
-	enum fp_type *fp_type;
-	enum fp_type to_save;
-};
 
-static DEFINE_PER_CPU(struct fpsimd_last_state_struct, fpsimd_last_state);
+static DEFINE_PER_CPU(struct cpu_fp_state, fpsimd_last_state);
 
 __ro_after_init struct vl_info vl_info[ARM64_VEC_MAX] = {
 #ifdef CONFIG_ARM64_SVE
@@ -468,7 +458,7 @@ static void task_fpsimd_load(void)
  */
 static void fpsimd_save(void)
 {
-	struct fpsimd_last_state_struct const *last =
+	struct cpu_fp_state const *last =
 		this_cpu_ptr(&fpsimd_last_state);
 	/* set by fpsimd_bind_task_to_cpu() or fpsimd_bind_state_to_cpu() */
 	bool save_sve_regs = false;
@@ -1716,8 +1706,7 @@ void fpsimd_kvm_prepare(void)
  */
 static void fpsimd_bind_task_to_cpu(void)
 {
-	struct fpsimd_last_state_struct *last =
-		this_cpu_ptr(&fpsimd_last_state);
+	struct cpu_fp_state *last = this_cpu_ptr(&fpsimd_last_state);
 
 	WARN_ON(!system_supports_fpsimd());
 	last->st = &current->thread.uw.fpsimd_state;
@@ -1749,25 +1738,14 @@ static void fpsimd_bind_task_to_cpu(void)
 	}
 }
 
-void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st, void *sve_state,
-			      unsigned int sve_vl, void *za_state,
-			      unsigned int sme_vl, u64 *svcr,
-			      enum fp_type *type, enum fp_type to_save)
+void fpsimd_bind_state_to_cpu(struct cpu_fp_state *state)
 {
-	struct fpsimd_last_state_struct *last =
-		this_cpu_ptr(&fpsimd_last_state);
+	struct cpu_fp_state *last = this_cpu_ptr(&fpsimd_last_state);
 
 	WARN_ON(!system_supports_fpsimd());
 	WARN_ON(!in_softirq() && !irqs_disabled());
 
-	last->st = st;
-	last->svcr = svcr;
-	last->sve_state = sve_state;
-	last->za_state = za_state;
-	last->sve_vl = sve_vl;
-	last->sme_vl = sme_vl;
-	last->fp_type = type;
-	last->to_save = to_save;
+	*last = *state;
 }
 
 /*
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index ec82d0191f76..02dd7e9ebd39 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -130,25 +130,29 @@ void kvm_arch_vcpu_ctxflush_fp(struct kvm_vcpu *vcpu)
  */
 void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 {
-	enum fp_type fp_type;
+	struct cpu_fp_state fp_state;
 
 	WARN_ON_ONCE(!irqs_disabled());
 
 	if (vcpu->arch.fp_state == FP_STATE_GUEST_OWNED) {
-		if (vcpu_has_sve(vcpu))
-			fp_type = FP_STATE_SVE;
-		else
-			fp_type = FP_STATE_FPSIMD;
 
 		/*
 		 * Currently we do not support SME guests so SVCR is
 		 * always 0 and we just need a variable to point to.
 		 */
-		fpsimd_bind_state_to_cpu(&vcpu->arch.ctxt.fp_regs,
-					 vcpu->arch.sve_state,
-					 vcpu->arch.sve_max_vl,
-					 NULL, 0, &vcpu->arch.svcr,
-					 &vcpu->arch.fp_type, fp_type);
+		fp_state.st = &vcpu->arch.ctxt.fp_regs;
+		fp_state.sve_state = vcpu->arch.sve_state;
+		fp_state.sve_vl = vcpu->arch.sve_max_vl;
+		fp_state.za_state = NULL;
+		fp_state.svcr = &vcpu->arch.svcr;
+		fp_state.fp_type = &vcpu->arch.fp_type;
+
+		if (vcpu_has_sve(vcpu))
+			fp_state.to_save = FP_STATE_SVE;
+		else
+			fp_state.to_save = FP_STATE_FPSIMD;
+
+		fpsimd_bind_state_to_cpu(&fp_state);
 
 		clear_thread_flag(TIF_FOREIGN_FPSTATE);
 	}
-- 
2.30.2

