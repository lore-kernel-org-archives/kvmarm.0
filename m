Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E69E18D656;
	Fri,  4 Apr 2025 13:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743773250; cv=none; b=jKXRCO7mjghw1MvGHmo9hZ9YjF1FNhZ4vvGrt8zArb1VNu/GOhAxQU9jtBAF0ae/4lJjHmDZj/HipOIjRYHHCv7UjIuH/5F+thdL6zmyRomHr14xWpZDidoHHrNUmaWmxytNOJ/71kcrNa9U8j03fSD4S0813fY6iTLmlifTCPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743773250; c=relaxed/simple;
	bh=U9ohMsi/C5NsIEyWu6dVbfAEv4pdOsK7cOsMN2eLlRY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Wa8AgeZp68+PI1S6ZJN488C5kptb5E9gCyMcAZFhKs41s68zEYConuD/96Xt2kuBI5P3EYcAOOZh4WWmFKVgR59oknOWMJDlf4YovXDXvKtrAmEAjGl7i7iaCLiWY5Ec1pUfcnTbVGIgheZc+ebML7+TA3ocshsRSwKzHi1cdqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EsDHOHuy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EsDHOHuy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93EEDC4CEE8;
	Fri,  4 Apr 2025 13:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743773249;
	bh=U9ohMsi/C5NsIEyWu6dVbfAEv4pdOsK7cOsMN2eLlRY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=EsDHOHuyu9xRSRhlrZCe6BEXlLM0Aiwt+DZc/ch4giSLGrDkMx20jgE96x25WNcCR
	 /ZaTKqoiMRoGhD+WHj/Jwmyn38BZi5XemNrR4Kx/mTpVEJ26+8jdtcd1pxmUzy7uKF
	 STHgXKB1B4a+DOlHJmP1OIDu9fZJVCX7dJWy0Y8uU9O5+oHpzrhWjd/tsKjZJSM5pW
	 XcYnHzXsc1amP0MRFF4kDy26mWBeM7GcOA7DwhImmltxkosIomc5nG3IgiVJlifNHs
	 pD3DQdNsoG8MXQtrph/yWe0xtaczGIONmmOT/G2/RPIIF1j6JBO/XnvjRh6DmsEaAn
	 Q3naJx1Sdx5Hw==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 04 Apr 2025 14:23:34 +0100
Subject: [PATCH RESEND 6.1 01/12] KVM: arm64: Discard any SVE state when
 entering KVM guests
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250404-stable-sve-6-1-v1-1-cd5c9eb52d49@kernel.org>
References: <20250404-stable-sve-6-1-v1-0-cd5c9eb52d49@kernel.org>
In-Reply-To: <20250404-stable-sve-6-1-v1-0-cd5c9eb52d49@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Oliver Upton <oliver.upton@linux.dev>, Oleg Nesterov <oleg@redhat.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
 Mark Brown <broonie@kernel.org>, stable@vger.kernel.org, 
 Mark Rutland <mark.rutland@arm.com>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3447; i=broonie@kernel.org;
 h=from:subject:message-id; bh=U9ohMsi/C5NsIEyWu6dVbfAEv4pdOsK7cOsMN2eLlRY=;
 b=owGbwMvMwMWocq27KDak/QLjabUkhvT39/TefNePXTnn5MO2gvs2jrnCudmMR8X/Ny+9GXj9VIqw
 V7lrJ6MxCwMjF4OsmCLL2mcZq9LDJbbOfzT/FcwgViaQKQxcnAIwkZNM7P9jMw8x7wrY32NVrLv8YI
 zMGqH3LPyyTqYMBzy/XTLVFmrLKS+f9C1gnmdGzl5Dv/r1z3Q7/zgUmQqFMm29xOikE+exvzKuafpu
 udVf/p+bUsmj3l/Hc8FWyulE0ruyqFPTHb78/3SOn11XJY7p3hKNF1x2Zc9ELmT//Oah7PzgT9dWfj
 vWH66xPaX3tBPMn4YxPTzEb814wvOpy/UTj1ZtEzlz4JBtXlbkmQPev7aKzbzO+l/qlsx2Rre2GC0+
 iwcsLSz5kScOBJXx2cfUBJysueuVOqf2snSOTZkeu7hOW61937xDTx636FzW5WlWd2crue4352Vxm0
 +BtOYnUykdjS03dGcWGSYpKTsCAA==
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

[ Upstream commit 93ae6b01bafee8fa385aa25ee7ebdb40057f6abe ]

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
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221115094640.112848-2-broonie@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
[ Mark: trivial backport to v6.1 ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/fpsimd.h |  1 +
 arch/arm64/kernel/fpsimd.c      | 23 +++++++++++++++++++++++
 arch/arm64/kvm/fpsimd.c         |  3 ++-
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 930b0e6c9462..3544dfcc67a1 100644
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
index 43afe07c74fd..1dc4254a99f2 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1643,6 +1643,29 @@ void fpsimd_signal_preserve_current_state(void)
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
2.39.5

