Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD5D198823;
	Wed,  5 Jun 2024 11:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717588213; cv=none; b=oYe8zCcuig7ueut/y0lYFBNuLRFKNeoUEy1XTrUMvvZlwlj/hzJWmv9Cu8pikkGy5cZ+tuZFL+Z+h6Qdmlbu5LVRAy/cgGJssbaWd8IHyUzhdYBnnciCD+Ae3MUfZQtLhsA3fk/fnY86JCYGj4PZD6HoJjwH+uYC6xpb+5IR3E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717588213; c=relaxed/simple;
	bh=6c1J1xU5lj/uDWDKMELN0USooXuGEwyYBBdoSr9IN5k=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AKarUDlZjsxHgEu/KPvvVTrcEan7eX+UmNUEbJb7cm0iJZzXm1rxagIFmpm5QILWNUdHdBx3sLxl5ZAoE4uqxYBz04Mg+FnehT3zqgebYFuzMuTxG9iNIb29SfhoqNZuQ/69y7zAVitR7ZGweFA77tOsjq6D53CrITSiIqv3C4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kpzyHpVZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kpzyHpVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E766C3277B;
	Wed,  5 Jun 2024 11:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717588212;
	bh=6c1J1xU5lj/uDWDKMELN0USooXuGEwyYBBdoSr9IN5k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=kpzyHpVZUc2cTuibhG56v9GllJK173FJzG3r6TeFWkRGAYVtW2e9xDXplXbVGsKVa
	 92wrW67uFQBubZkx6H6Ix0dnnC+N7VpxYRe6jEBw3l9RfgnNwB/Hnd9GzC6c2sgIll
	 WGAPzU4yawFn0cUCVfNeVABJv3VvMO4jOR0JvKBb0YSji8iU4U95cEac8CDc75BFUw
	 ZtZuaZneMOfCi6EZeOtOgiioD7GIV0o6z6O8aQKn60PHUzuLxBtBOd461WGRjM2q7R
	 Bwtx/ah62/GxMbMe/QMI96UFKb5KQ+WZ+I77Uxb9UrTkasGbhVnBK9ehWx3Rr0flP7
	 UHEo4IGhJH2fA==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 05 Jun 2024 12:41:29 +0100
Subject: [PATCH 3/4] KVM: arm64: Fix FFR offset calculation for pKVM host
 state save and restore
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240605-kvm-arm64-fix-pkvm-sve-vl-v1-3-680d6b43b4c1@kernel.org>
References: <20240605-kvm-arm64-fix-pkvm-sve-vl-v1-0-680d6b43b4c1@kernel.org>
In-Reply-To: <20240605-kvm-arm64-fix-pkvm-sve-vl-v1-0-680d6b43b4c1@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.14-dev-d4707
X-Developer-Signature: v=1; a=openpgp-sha256; l=2968; i=broonie@kernel.org;
 h=from:subject:message-id; bh=6c1J1xU5lj/uDWDKMELN0USooXuGEwyYBBdoSr9IN5k=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmYFDoS+tQMHD3gju9xsmaBv3OV04ouECGRPwHWpXn
 FW5Cn7OJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZmBQ6AAKCRAk1otyXVSH0JjbB/
 4wVrMIkRIgpQYuRW+a+2JfCt54xdzClYfx+fQf+SGGIjsHUnHvOEMSO2msR5qAC+tQ1JCEFvIliLWt
 TFjxCf4X8WrQtcqJvT+1ToflMa2Ib9zeEeP2OQ3ETsOdmbWUjZBhq9cBt1SxOkPSEOAGXRdiCPGNBO
 /4qBks58qe38BvrN6HbU0rIoYCOGjSGasUw/j0BCCPrE+kgPjpXgt8attTusyAjhwCMYtWYatoNF1Q
 /MvzeLeVT3eiyCiK5aQxv9YAA8NQynz8pe+SA3T1trQldGnoEtfmS1tlmaIEzoatn5rSJQ30TRmV1Z
 6zhHdyz+542bvrleMcCzWoVL0dZjiI
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

When saving and restoring the SVE state for the host we configure the
hardware for the maximum VL it supports, but when calculating offsets in
memory we use the maximum usable VL for the host. Since these two values
may not be the same this may result in data corruption.  We can just
read the current VL from the hardware with an instruction so do that
instead of a saved value.

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

