Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D77F197A96;
	Thu,  6 Jun 2024 15:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717687929; cv=none; b=AaivA2zZxZUYxxvUsdWyGW1cwDeTl2m23zapu4ag4hG0FjSSAxS/heKDQZsjtdZJ/AmnGTKVtrALJDyLOwnDaopBAfLImcyIY04mQkl8Dx1ZzSH+17nUjoybsayfNIQjGVMLr10zBalBJ50H1CD/G3PN8Bzx/2woqDqA0CY8J4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717687929; c=relaxed/simple;
	bh=uej+Tf8xf9z3hwiLLHmVJLafNhINst5vjRm2ck0g7NI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Nge7ThiqzvDXbk42LujNEClsjSs5U8iyJJ/B8v+BeaJAWVFKDCj5oHP0iWX7PD8+tRaCtl+tUunlerDGgEeifq34DzOOtv6ltr0XeG7q9hrdPi9Cebc/LTDtx+rO3MymP60Mu4B/uXT8D8SfburFVTbUWDQRxcxCfRMisdZ5FLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g+LjCG5D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g+LjCG5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8701EC32782;
	Thu,  6 Jun 2024 15:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717687928;
	bh=uej+Tf8xf9z3hwiLLHmVJLafNhINst5vjRm2ck0g7NI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=g+LjCG5Dckh2ymqVHPJbXOurf4EebD7bdxByAad7JMaf34VU3t5ZktiW32JOaqfg/
	 0yYaH5smz8iUiMs+iWkQtMMtXvshNLHpFGVEPS6LIVRhQ3nnjS/sW/wTiiqyEi0lld
	 7gnvSTO/E9YgV+f0unr5p3jFPkXvp1amS2UJLU3co53afuX5JVoHHCzhNADl5+nP/g
	 H43FGZ2r3FPKkwLA0VqDXQT4CaNMQXzhFa/zvxwzAEmINSHTEapKXrZXTAN2Vr2gS4
	 pIHxaax2aREy4s1hZ979ZYTLSMNGgvEEDhrLpQPaJM1l+Al9yXhcd6KqxrNaRBVWaS
	 yACtJB7XGpe7w==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 06 Jun 2024 16:21:45 +0100
Subject: [PATCH v2 3/4] KVM: arm64: Fix FFR offset calculation for pKVM
 host state save and restore
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240606-kvm-arm64-fix-pkvm-sve-vl-v2-3-c88f4eb4b14b@kernel.org>
References: <20240606-kvm-arm64-fix-pkvm-sve-vl-v2-0-c88f4eb4b14b@kernel.org>
In-Reply-To: <20240606-kvm-arm64-fix-pkvm-sve-vl-v2-0-c88f4eb4b14b@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.14-dev-d4707
X-Developer-Signature: v=1; a=openpgp-sha256; l=3038; i=broonie@kernel.org;
 h=from:subject:message-id; bh=uej+Tf8xf9z3hwiLLHmVJLafNhINst5vjRm2ck0g7NI=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmYdZsz4r7UnVjNwEMykuqo5GUe570WUMT0pqnJdWE
 gToCCkWJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZmHWbAAKCRAk1otyXVSH0Mw4B/
 943uDUyYIEx5pZu40qDu0DfW1U3V+HvNFfCFkiV2wuM9gthMVvxU3mdEKV8ycpgkIFfheiOOxXrdlN
 L45cC3KEK4JltkArIAf0igt7SRKdcQfhfq30AJwXcRsw+di5RlXoqQL07wQ5oVJAqnb4EbXYcpWfL/
 WOiBpO7bSj6Jqxy+eWzqiz2gzzUrVCecNYkasdJhvxtHG1UyHfcKBTT9OAL97pVa9KdOzhVIhah4YX
 4ccR2jQi1A40+WoQEQO8Uq7Z3HsKcFEQVWg7hYdxQ2GZtQHf1Y17yxigN/3JvEs7lWu9ndaxlp9j53
 KXRUj+78kTnQLVr7UzqV33uUNcwqVR
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

When saving and restoring the SVE state for the host we configure the
hardware for the maximum VL it supports, but when calculating offsets in
memory we use the maximum usable VL for the host. Since these two values
may not be the same this may result in data corruption.  We can just
read the current VL from the hardware with an instruction so do that
instead of a saved value, we need to correct the value and this makes
the consistency obvious.

Fixes: b5b9955617bc ("KVM: arm64: Eagerly restore host fpsimd/sve state in pKVM")
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_hyp.h        | 1 +
 arch/arm64/kvm/hyp/fpsimd.S             | 5 +++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 2 +-
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index b05bceca3385..7510383d78a6 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -113,6 +113,7 @@ void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
 void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
 void __sve_save_state(void *sve_pffr, u32 *fpsr, int save_ffr);
 void __sve_restore_state(void *sve_pffr, u32 *fpsr, int restore_ffr);
+int __sve_get_vl(void);
 
 u64 __guest_enter(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/hyp/fpsimd.S b/arch/arm64/kvm/hyp/fpsimd.S
index e950875e31ce..d272dbf36da8 100644
--- a/arch/arm64/kvm/hyp/fpsimd.S
+++ b/arch/arm64/kvm/hyp/fpsimd.S
@@ -31,3 +31,8 @@ SYM_FUNC_START(__sve_save_state)
 	sve_save 0, x1, x2, 3
 	ret
 SYM_FUNC_END(__sve_save_state)
+
+SYM_FUNC_START(__sve_get_vl)
+	_sve_rdvl	0, 1
+	ret
+SYM_FUNC_END(__sve_get_vl)
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 0c4de44534b7..06efcca765cc 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -327,7 +327,7 @@ static inline void __hyp_sve_save_host(void)
 
 	sve_state->zcr_el1 = read_sysreg_el1(SYS_ZCR);
 	write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
-	__sve_save_state(sve_state->sve_regs + sve_ffr_offset(kvm_host_sve_max_vl),
+	__sve_save_state(sve_state->sve_regs + sve_ffr_offset(__sve_get_vl()),
 			 &sve_state->fpsr,
 			 true);
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index f43d845f3c4e..bd8f671e848c 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -49,7 +49,7 @@ static void __hyp_sve_restore_host(void)
 	 * supported by the system (or limited at EL3).
 	 */
 	write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
-	__sve_restore_state(sve_state->sve_regs + sve_ffr_offset(kvm_host_sve_max_vl),
+	__sve_restore_state(sve_state->sve_regs + sve_ffr_offset(__sve_get_vl()),
 			    &sve_state->fpsr,
 			    true);
 	write_sysreg_el1(sve_state->zcr_el1, SYS_ZCR);

-- 
2.39.2

