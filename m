Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D8D13E3F8;
	Mon,  8 Jul 2024 14:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720448484; cv=none; b=j0F0msNrbmOlIDei6XAzsnkxeatTK874cy3NXi97CIl6TDe0Dsn344/7K4EqD9bzL+Nj3sxC3EziXS8S/XXU0eewXsAa0wMiFCoWDsrNyMIMV2hV1gOLvuNzClsTNUcptF8SZ2sdOmlXymUuGxSAAA4WJDZ+81vjrIepob+Dri8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720448484; c=relaxed/simple;
	bh=lND+9Wrq6h84wg/7dcgVXzhKhNM8RJROdnPLpTYN0xk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Buanx90elU9UpTUwPwgQ6OZqomjonQbRaX+2ykWPqYy+GnwcKMsjJZSzncWp/0hamwB2O2PHBMlPscBoXs5cVig6qPPHMl/xtX/RvY2ul0Z/vkIm9wtuYi2LHJCEUXOn8HGY+Fja/icDsjB78VWKcr8oopJ5DAiLi4UX4Wv/BeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GaWkGbdR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GaWkGbdR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F07C32786;
	Mon,  8 Jul 2024 14:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720448484;
	bh=lND+9Wrq6h84wg/7dcgVXzhKhNM8RJROdnPLpTYN0xk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=GaWkGbdRkfWJTCn44B+jyvf7DEOkcAdjP+Q7GAUwynSRjyx9/oK2thfv35LHDzCvm
	 LYTBJ8gvAyWR5q7Oy7t8KOS0eWJcadvlbfybA7R3n5UiBMbyGppxz14sAYPcAgNjeE
	 9vv2yWC38y6FDr/UNDQ7jH0iHtrQ/lCvWeK6A+GUChkp0knVOJr56y4MOPJDIrAd3c
	 cCjqoZC6nIELBzT2AVVpx/VONrU/AxJaHZgItiDtm/tZovejftMgsIzKrhip76HKQV
	 hMfjf4vGpHXO7cdGBfeLKZOX/MyZGv3nnjUFVfR762Eor+pX0VOB3lvwXtQl8MjZyF
	 hBuOX6nsaSXMA==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 08 Jul 2024 15:19:15 +0100
Subject: [PATCH v5 3/4] KVM: arm64: Fix FFR offset calculation for pKVM
 host state save and restore
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240708-kvm-arm64-fix-pkvm-sve-vl-v5-3-d2175738456b@kernel.org>
References: <20240708-kvm-arm64-fix-pkvm-sve-vl-v5-0-d2175738456b@kernel.org>
In-Reply-To: <20240708-kvm-arm64-fix-pkvm-sve-vl-v5-0-d2175738456b@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.14-dev-d4707
X-Developer-Signature: v=1; a=openpgp-sha256; l=3206; i=broonie@kernel.org;
 h=from:subject:message-id; bh=lND+9Wrq6h84wg/7dcgVXzhKhNM8RJROdnPLpTYN0xk=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmi/XLR+gOeEj+oJx6GbLGY6GRKjPkxOMypVwTg0mg
 cp5Wv+KJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZov1ywAKCRAk1otyXVSH0N2cB/
 0XusVxwjo05ZSzJHcrIrNFF/cFKAlf/3cx4Slc8IPYSDz/JSPi5w5FT/2F5CzMoliN9owVuPNDYWxF
 IQcpTCybn0vX+fzS4PB+odCHagG475eG2J/t76uh4P4DCoHN+v65XJsUgi795PrcYfc+RMUx75YNgX
 1vNZzZOT6lXrCqybWKKMqzl/pj9TJdPPqj/+6ILmBGmqLrVi0+iWKgLu9IvGcpBx9vnzwHVrqYJVKj
 rge+WgNfvRWuAg+iA7A92qsjLJKXFwHo8WJgBgyQBvFKSKBDLg5pF8BIgO1vP6eQj6/bCDAd6SGdx6
 NNXfx6NdzOZolCACd146CtIzfRGCDi
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

When saving and restoring the SVE state for the host we configure the
hardware for the maximum VL it supports, but when calculating offsets in
memory we use the maximum usable VL for the host. Since these two values
may not be the same this may result in data corruption in the case where
the PE supports a VL larger than the maximum usable VL for the host.  We
can just read the current VL from the hardware with an instruction so
use that instead of a saved value, we need to correct the value used to
lay out the stored data and this makes it clear that the layout is
consistent with the hardware configuration.

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

