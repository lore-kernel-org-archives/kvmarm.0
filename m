Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A72F6312836
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 13:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779369998; cv=none; b=KHojSbL1uRTH8DPjmy34muJjLb67UDJ4znKpAB/cxyo4EvDimsvbIM5eugShsqbpE8BW8GLM6gFo3ep3WbjyE1f52dO5lT1vWfSs0uig1qGUnIKA04Ho6V2JIEEbekNo0WQNs9aOE8dr/gg2xvrXDc1wLY92bXb1/b4bQn3x90A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779369998; c=relaxed/simple;
	bh=Awmtl499rtF/0b4l3fU6t7Fxq/WplL1zCjoueMdmw1M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MYKUjx4WoHTPZP3RdMaVXQjarnKGzJL6QUb2fceOPKnp4V1jxndrM0CI3w97taO5zHpuQecehS+ZzALld+BvudwBtA7hLYxIHzp42ffmCFfxf3O2Hl3d5H5US7LyFAUBP2qhsRSWZfceWXfN7pF5B6ommKciM1Tcmld+cMmPQ4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qyeX/BCZ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qyeX/BCZ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C78F32BCB;
	Thu, 21 May 2026 06:26:30 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A11CB3F7B4;
	Thu, 21 May 2026 06:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779369995; bh=Awmtl499rtF/0b4l3fU6t7Fxq/WplL1zCjoueMdmw1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qyeX/BCZoz3sIRW+l7kLYBx6xZLBt6AW2+bDDZIYc/Pe5YUdAVZi4YOgIl9z6zhlK
	 3/GuahmaloG1VH7nxtj7Vx3C7iU0a882gSrZbOqsRcpDUfPbAWJGFDmrSybr2DfL89
	 Yn6fXAVvwL07B1jigNO9wS6M4q/cKB5K8+W04Q6g=
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: broonie@kernel.org,
	catalin.marinas@arm.com,
	james.morse@arm.com,
	mark.rutland@arm.com,
	maz@kernel.org,
	oupton@kernel.org,
	tabba@google.com,
	will@kernel.org
Subject: [PATCH 14/18] arm64: fpsimd: Use opaque type for SME state
Date: Thu, 21 May 2026 14:25:52 +0100
Message-Id: <20260521132556.584676-15-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260521132556.584676-1-mark.rutland@arm.com>
References: <20260521132556.584676-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As the SME state size can vary at runtime, we don't have a concrete type
for the in-memory SME state, and pass this around using a pointer to
void.

Using pointer to void means that it's very easy to introduce errors that
cannot be caught by the compiler (e.g. as 'void **' can be assigned to
'void *').

Improve this by adding an opaque 'struct sve_state', and consistently
passing a pointer to this.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/fpsimd.h    | 8 ++++----
 arch/arm64/include/asm/processor.h | 3 ++-
 arch/arm64/kernel/fpsimd.c         | 4 ++--
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 19e670ae67598..560814acc60c0 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -163,7 +163,7 @@ extern void fpsimd_update_current_state(struct user_fpsimd_state const *state);
 struct cpu_fp_state {
 	struct user_fpsimd_state *st;
 	struct sve_state *sve_state;
-	void *sme_state;
+	struct sme_state *sme_state;
 	u64 *svcr;
 	u64 *fpmr;
 	unsigned int sve_vl;
@@ -199,7 +199,7 @@ static inline void *thread_zt_state(struct thread_struct *thread)
 {
 	/* The ZT register state is stored immediately after the ZA state */
 	unsigned int sme_vq = sve_vq_from_vl(thread_get_sme_vl(thread));
-	return thread->sme_state + ZA_SIG_REGS_SIZE(sme_vq);
+	return (void *)thread->sme_state + ZA_SIG_REGS_SIZE(sme_vq);
 }
 
 static inline unsigned int sve_get_vl(void)
@@ -218,8 +218,8 @@ static inline unsigned int sve_get_vl(void)
 extern void sve_save_state(struct sve_state *state, int save_ffr);
 extern void sve_load_state(const struct sve_state *state, int restore_ffr);
 extern void sve_flush_live(bool flush_ffr, unsigned long vq_minus_1);
-extern void sme_save_state(void *state, int zt);
-extern void sme_load_state(void const *state, int zt);
+extern void sme_save_state(struct sme_state *state, int zt);
+extern void sme_load_state(const struct sme_state *state, int zt);
 
 struct arm64_cpu_capabilities;
 extern void cpu_enable_fpsimd(const struct arm64_cpu_capabilities *__unused);
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 1c2ffd063baa8..7304d9cca3e85 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -131,6 +131,7 @@ enum fp_type {
 };
 
 struct sve_state;		/* Opaque type */
+struct sme_state;		/* Opaque type */
 
 struct cpu_context {
 	unsigned long x19;
@@ -167,7 +168,7 @@ struct thread_struct {
 	enum fp_type		fp_type;	/* registers FPSIMD or SVE? */
 	unsigned int		fpsimd_cpu;
 	struct sve_state	*sve_state;	/* SVE registers, if any */
-	void			*sme_state;	/* ZA and ZT state, if any */
+	struct sme_state	*sme_state;	/* ZA and ZT state, if any */
 	unsigned int		vl[ARM64_VEC_MAX];	/* vector length */
 	unsigned int		vl_onexec[ARM64_VEC_MAX]; /* vl after next exec */
 	unsigned long		fault_address;	/* fault info */
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 66d880d081671..f9b3eeacf130d 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -808,7 +808,7 @@ static int change_live_vector_length(struct task_struct *task,
 	unsigned int sve_vl = task_get_sve_vl(task);
 	unsigned int sme_vl = task_get_sme_vl(task);
 	struct sve_state *sve_state = NULL;
-	void *sme_state = NULL;
+	struct sme_state *sme_state = NULL;
 
 	if (type == ARM64_VEC_SME)
 		sme_vl = vl;
@@ -1645,7 +1645,7 @@ static void fpsimd_flush_thread_vl(enum vec_type type)
 void fpsimd_flush_thread(void)
 {
 	struct sve_state *sve_state = NULL;
-	void *sme_state = NULL;
+	struct sme_state *sme_state = NULL;
 
 	if (!system_supports_fpsimd())
 		return;
-- 
2.30.2

