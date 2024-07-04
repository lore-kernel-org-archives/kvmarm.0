Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC79D142640;
	Thu,  4 Jul 2024 17:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720114131; cv=none; b=VxJNPLFV293Y9KOGFhIUHgdEWJmWX4e8r6f9bPQrCPyu9YeJYnyp0W2BVPEA6bM1taAb5V6mPVUykkXXTPaCRVYbponDG6qAsQGAZBZtCZPoYiAfjNO7E7jyU9EDYtrYml9GVT3BE+AgqQrzSDYRmXdx3JEQz/1d6TabDEpi2jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720114131; c=relaxed/simple;
	bh=uej+Tf8xf9z3hwiLLHmVJLafNhINst5vjRm2ck0g7NI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LjQshGGNeDVpP1B9Ezp/9hNruZOf1r3QBVzmmYHq4FmjUmcst8F/hxgKnEr1aJqPYe5Nfys3eHtmM/af9S+Uz86f3qqkRxySIJVSeAPQpebrz7Dm3vmFolp3kUpCY/fkE8nFZaDvqx9qpueyFtgFirYlrkPhNAYXO1aJ0XbpqZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oCrA6yCv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oCrA6yCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D218C4AF0A;
	Thu,  4 Jul 2024 17:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720114130;
	bh=uej+Tf8xf9z3hwiLLHmVJLafNhINst5vjRm2ck0g7NI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=oCrA6yCvxOENhuEijgkLNf7jJ5dycTeVKssisuXMZ096HMOazZhuH4ywgMd5yrwMt
	 kUzyaV1tQCfnEuqfL+GX1iz3UBaWIDKHw/NMBA++GSBZPYrw3b/0Erx2lCLI8vuYio
	 zLNEG5qmA3a9sFY2nklH207+4j1LTeikH/m2bLtglM3tZZP+cer2eVrUjRqj9tU0ag
	 znpqhLEtJbrvCK6+2tWefcasHV2QvuifLouCZ2Yk/UsnDrv6DnVDXc17XbX0imvF23
	 wA6qSIt/F62xyhm9/h0bvsU5m1t8AXohZzvOE4cBodZIswF++IrLB0fnV+gYhcjkns
	 apwKiQU6xSzuw==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 04 Jul 2024 18:28:18 +0100
Subject: [PATCH v4 3/4] KVM: arm64: Fix FFR offset calculation for pKVM
 host state save and restore
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240704-kvm-arm64-fix-pkvm-sve-vl-v4-3-b6898ab23dc4@kernel.org>
References: <20240704-kvm-arm64-fix-pkvm-sve-vl-v4-0-b6898ab23dc4@kernel.org>
In-Reply-To: <20240704-kvm-arm64-fix-pkvm-sve-vl-v4-0-b6898ab23dc4@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.14-dev-d4707
X-Developer-Signature: v=1; a=openpgp-sha256; l=3038; i=broonie@kernel.org;
 h=from:subject:message-id; bh=uej+Tf8xf9z3hwiLLHmVJLafNhINst5vjRm2ck0g7NI=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmhtvG8RgiIH7ChU7tPW0F2wZPbjGxluAsnwcZnMXw
 lhtUMGmJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZobbxgAKCRAk1otyXVSH0G/wB/
 9MsIJ3abfou/ive8mabeCSn8wAHdZkkcIlJI0JBjwl6niTejAwiAEUPLkJFcgelmtA5PNO8Ls0f2QW
 oa6PqWl/C6LhMJEpaFPEaMvrwGvmjzNLbgsleJkoXyEfgWuJrL6fH9tMu9m8QYoWHyn++dk+eu0uPy
 RU3b2cv/KUJ3XYIFe7UmTVsDYA45TbG9aS5HTznFGffYmoIyTr9JNqxiqG71vzjJhtLkjo9WdAdO+O
 VVwvW+59r9mkrDri69m5j6pF0OzBdeB338wTPBRV2QH8ycFBa8+aQLkcNCEZUYTqrRpVgZ/WIU0VXQ
 srg0T+ZCxfFZ/bU4B1JBXv8/otGFPJ
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

