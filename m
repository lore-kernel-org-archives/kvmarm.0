Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DE379F5;
	Fri, 14 Mar 2025 00:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741912542; cv=none; b=pizwA91q+5I6E68nk2mtFD9e10fIDCvOHExhFRImv0OVjn6EgrQ9YXKJ/TqeJbuONL3BuVdX0cb6q6mRFFNdY8hBQ/vosfzGtHP3yDTNjpYA6iWOksz8cEt9ea64FHaZ20TRJm8ObZL1JYMOkk2WFNb9+p25tl8M7VsE/ig7OW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741912542; c=relaxed/simple;
	bh=sdmZYjSKuQYlgeObZgUxNcOjWmmjERzES6RrhaWvdbs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nACppJnlPF+ZaK2SKOb53yoBd8umLshc9Dyj1nhfcL+Baeik5shwj+sF62EvhsaYgGPhC8Y/JRnzaPO6o4Ehr8BnhAORh0Xx8k1CRm/5AEJlK9f21EUMBxEHaivcEknrLTDl8savPb6rKoSdNlkfucc8vGP9sVj4pKAuDB2u6DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j7M3eJXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j7M3eJXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16F7C4CEEE;
	Fri, 14 Mar 2025 00:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741912542;
	bh=sdmZYjSKuQYlgeObZgUxNcOjWmmjERzES6RrhaWvdbs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=j7M3eJXhVEi6uVZTB9xmZqHMymkc0GPeayaNiqtANpkI1FJ7HyR9+giATBk7sF3gE
	 FBmdlG7LPzuNkqILq/IRuS1qLLTHSeHmKcv+SJEwSMg5raOdv5P5EtV9SZf49d1KP7
	 HzYYeoD2QOnv+4vy+bWNx/3O2c7t7zi8tDCkwXxjG0jC1yxWApC9daSCUZWEz79hh0
	 /wbnGDMVfg2ez/HqPRCu5zKYOv87qMhxuXEW0TaX8p4uwy2QbN3OtIZjqh+yYcViui
	 /5y9wGzQRjqhb2XLJ0BQsPyE9UhyFih1Tzeha76AYrzUqhT3NvzttSLk5/6NstQZkG
	 7RvsKa6mPe3lw==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 14 Mar 2025 00:35:15 +0000
Subject: [PATCH 6.12 3/8] KVM: arm64: Remove host FPSIMD saving for
 non-protected KVM
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250314-stable-sve-6-12-v1-3-ddc16609d9ba@kernel.org>
References: <20250314-stable-sve-6-12-v1-0-ddc16609d9ba@kernel.org>
In-Reply-To: <20250314-stable-sve-6-12-v1-0-ddc16609d9ba@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Fuad Tabba <tabba@google.com>
X-Mailer: b4 0.15-dev-1b0d6
X-Developer-Signature: v=1; a=openpgp-sha256; l=8015; i=broonie@kernel.org;
 h=from:subject:message-id; bh=B7wPFF9YCtOLnvOO1e5I1AsTzXQtKnhMVVgl4qZXzEw=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBn03nLrDwOKvSDQTZPZf+b5TQyfduhDYMSzj5tQ+lO
 8DZtD6+JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZ9N5ywAKCRAk1otyXVSH0MczB/
 9CI6049p0PAAl+rol27UWJXPS6g0vl1CiKPGmsFUuy3j4ZYzOLrWJll8+O54QUP/lcHklqxORGfsj0
 PcWQbfogCoXW/3m6vCekyGDz0GOXJtOFDU6q2IJ1ALm6Ig6k+7M8xGvrigv8bkUKcO9qeIxtqkmJwi
 lnRraNw0w7vdhV6qGqXC8aBxjunl/VlhGWmaqUGRWsuwxJAOaTMEUu3py/ymc35GQp57Nc7m2xaiq3
 L6aa7EeXmFV8CChd48KVSdIaU14pzZ4IefnxnFm9myH/68PasQpbd6j6c4z8E7KmMm0cQqTOMSHaeS
 kb0QLnaFZs3eSiL7UrfXCvfRtR25uP
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

From: Mark Rutland <mark.rutland@arm.com>

Now that the host eagerly saves its own FPSIMD/SVE/SME state,
non-protected KVM never needs to save the host FPSIMD/SVE/SME state,
and the code to do this is never used. Protected KVM still needs to
save/restore the host FPSIMD/SVE state to avoid leaking guest state to
the host (and to avoid revealing to the host whether the guest used
FPSIMD/SVE/SME), and that code needs to be retained.

Remove the unused code and data structures.

To avoid the need for a stub copy of kvm_hyp_save_fpsimd_host() in the
VHE hyp code, the nVHE/hVHE version is moved into the shared switch
header, where it is only invoked when KVM is in protected mode.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Tested-by: Mark Brown <broonie@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20250210195226.1215254-3-mark.rutland@arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h       | 20 +++++---------------
 arch/arm64/kvm/arm.c                    |  8 --------
 arch/arm64/kvm/fpsimd.c                 |  2 --
 arch/arm64/kvm/hyp/include/hyp/switch.h | 25 +++++++++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c        | 28 ----------------------------
 arch/arm64/kvm/hyp/vhe/switch.c         |  8 --------
 7 files changed, 29 insertions(+), 64 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d148cf578cb84e7dec4d1add2afa60a3c7a1e041..d8802490b25cba65369f03d94627a2624f14b072 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -602,23 +602,13 @@ struct kvm_host_data {
 	struct kvm_cpu_context host_ctxt;
 
 	/*
-	 * All pointers in this union are hyp VA.
+	 * Hyp VA.
 	 * sve_state is only used in pKVM and if system_supports_sve().
 	 */
-	union {
-		struct user_fpsimd_state *fpsimd_state;
-		struct cpu_sve_state *sve_state;
-	};
-
-	union {
-		/* HYP VA pointer to the host storage for FPMR */
-		u64	*fpmr_ptr;
-		/*
-		 * Used by pKVM only, as it needs to provide storage
-		 * for the host
-		 */
-		u64	fpmr;
-	};
+	struct cpu_sve_state *sve_state;
+
+	/* Used by pKVM only. */
+	u64	fpmr;
 
 	/* Ownership of the FP regs */
 	enum {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e6f0443210a8b7a65f616b25b2e6f74a05683ed6..634d3f62481827a3bf3aba6bf78cafed71b5bd32 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2476,14 +2476,6 @@ static void finalize_init_hyp_mode(void)
 			per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->sve_state =
 				kern_hyp_va(sve_state);
 		}
-	} else {
-		for_each_possible_cpu(cpu) {
-			struct user_fpsimd_state *fpsimd_state;
-
-			fpsimd_state = &per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->host_ctxt.fp_regs;
-			per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->fpsimd_state =
-				kern_hyp_va(fpsimd_state);
-		}
 	}
 }
 
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index efb54ed60fe1d1d8a904b10a4a4bd3c820d9dac5..2ee6bde85235581d6bc9cba7e578c55875b5d5a1 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -64,8 +64,6 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	 */
 	fpsimd_save_and_flush_cpu_state();
 	*host_data_ptr(fp_owner) = FP_STATE_FREE;
-	*host_data_ptr(fpsimd_state) = NULL;
-	*host_data_ptr(fpmr_ptr) = NULL;
 
 	vcpu_clear_flag(vcpu, HOST_SVE_ENABLED);
 	if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 5310fe1da6165bcdedfb5ce61bce353e4c9dd58b..a7f6a653f33718d1a25e232608e63ea287f2a672 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -344,7 +344,28 @@ static inline void __hyp_sve_save_host(void)
 			 true);
 }
 
-static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu);
+static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Non-protected kvm relies on the host restoring its sve state.
+	 * Protected kvm restores the host's sve state as not to reveal that
+	 * fpsimd was used by a guest nor leak upper sve bits.
+	 */
+	if (system_supports_sve()) {
+		__hyp_sve_save_host();
+
+		/* Re-enable SVE traps if not supported for the guest vcpu. */
+		if (!vcpu_has_sve(vcpu))
+			cpacr_clear_set(CPACR_ELx_ZEN, 0);
+
+	} else {
+		__fpsimd_save_state(host_data_ptr(host_ctxt.fp_regs));
+	}
+
+	if (kvm_has_fpmr(kern_hyp_va(vcpu->kvm)))
+		*host_data_ptr(fpmr) = read_sysreg_s(SYS_FPMR);
+}
+
 
 /*
  * We trap the first access to the FP/SIMD to save the host context and
@@ -394,7 +415,7 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 	isb();
 
 	/* Write out the host state if it's in the registers */
-	if (host_owns_fp_regs())
+	if (is_protected_kvm_enabled() && host_owns_fp_regs())
 		kvm_hyp_save_fpsimd_host(vcpu);
 
 	/* Restore the guest state */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index fefc89209f9e41c95478f6770881eb314a38b4c2..4e757a77322c9efc59cdff501745f7c80d452358 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -83,7 +83,7 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
 	if (system_supports_sve())
 		__hyp_sve_restore_host();
 	else
-		__fpsimd_restore_state(*host_data_ptr(fpsimd_state));
+		__fpsimd_restore_state(host_data_ptr(host_ctxt.fp_regs));
 
 	if (has_fpmr)
 		write_sysreg_s(*host_data_ptr(fpmr), SYS_FPMR);
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 81d933a71310fd1132b2450cd08108e071a2cf78..3ce16f90fe6af7be21bc7b84a9d8b3905b8b08a7 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -193,34 +193,6 @@ static bool kvm_handle_pvm_sys64(struct kvm_vcpu *vcpu, u64 *exit_code)
 		kvm_handle_pvm_sysreg(vcpu, exit_code));
 }
 
-static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
-{
-	/*
-	 * Non-protected kvm relies on the host restoring its sve state.
-	 * Protected kvm restores the host's sve state as not to reveal that
-	 * fpsimd was used by a guest nor leak upper sve bits.
-	 */
-	if (unlikely(is_protected_kvm_enabled() && system_supports_sve())) {
-		__hyp_sve_save_host();
-
-		/* Re-enable SVE traps if not supported for the guest vcpu. */
-		if (!vcpu_has_sve(vcpu))
-			cpacr_clear_set(CPACR_ELx_ZEN, 0);
-
-	} else {
-		__fpsimd_save_state(*host_data_ptr(fpsimd_state));
-	}
-
-	if (kvm_has_fpmr(kern_hyp_va(vcpu->kvm))) {
-		u64 val = read_sysreg_s(SYS_FPMR);
-
-		if (unlikely(is_protected_kvm_enabled()))
-			*host_data_ptr(fpmr) = val;
-		else
-			**host_data_ptr(fpmr_ptr) = val;
-	}
-}
-
 static const exit_handler_fn hyp_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]		= NULL,
 	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15_32,
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 80581b1c399595fd64d0ccada498edac322480a6..e7ca0424107adec2371ae4553ebab9857c60b6d9 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -309,14 +309,6 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return true;
 }
 
-static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
-{
-	__fpsimd_save_state(*host_data_ptr(fpsimd_state));
-
-	if (kvm_has_fpmr(vcpu->kvm))
-		**host_data_ptr(fpmr_ptr) = read_sysreg_s(SYS_FPMR);
-}
-
 static bool kvm_hyp_handle_tlbi_el2(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	int ret = -EINVAL;

-- 
2.39.5

