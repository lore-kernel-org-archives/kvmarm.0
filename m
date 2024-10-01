Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EC51C2429;
	Tue,  1 Oct 2024 11:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727782282; cv=none; b=ItKZaFdBxAzGchGULKOYeZwTCUazvGpcxlVq8m5tNpJ17bLVYVNOT4E2F97K3b2GfEgdqlGXjeSrmM10JP4sbBqnyPUpQj+HzjsWS36TU6QXzIYgdukDgVT7WJqTkf+V6i1TmI6o3QXcJlqQh6XXYzrHd69r7ZZ/6fww3Bdy1UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727782282; c=relaxed/simple;
	bh=KBunKuidQbGsl1sTPDqT1ibl0GGL5dnEQFUfFDn0MP8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TpPlcxYGyLYNPxnvdtkB++bp4kvTG30XdoZz57aqWYaf90P8yLs3YyGAYqj+aIfvbfJ4QIxwfOVL4YqozaBFil/aqO6T46I9FZZU4m1N0w0fDQ9TggeaCgyxDsz7qZNJZbchVqpCiO+NUJFQPIqhsgnA40NbANYD5BGDxWwnfOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f2utS53a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f2utS53a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B0CC4CEC6;
	Tue,  1 Oct 2024 11:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727782281;
	bh=KBunKuidQbGsl1sTPDqT1ibl0GGL5dnEQFUfFDn0MP8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=f2utS53aPNMtAdR2kLn87aubYqKj6soMe/MmzTiwRNusjBY9Kvtd6t8lsrYC66qcT
	 2caAWmgTZjnL+MHHlShC8N1E5MZh1IxjUtqpkiWJaPvzht7rXS+SsapTNPfR7AnDBL
	 kd0KFzAU0ScB+S3JML/yRqKEEu9pw3uN7bwg+5xpWUHyNm1helyuJvmXq9TPBplb8A
	 nPPMnzlWOtlnFGdwgGboF1PdVpxfvmyVjzv6qNv1tFMQljPYocbhF/KUky0C4mpNup
	 HMgVOpIx79OsWdmel+ctIodRvkcMSPFpOxF+QM8QYCqtz6ulqYb8ZUfQ85kJvuaUhG
	 HMwZEG1sWDMQQ==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 01 Oct 2024 12:29:08 +0100
Subject: [PATCH v7 3/4] KVM: arm64: Fix FFR offset calculation for pKVM
 host state save and restore
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241001-kvm-arm64-fix-pkvm-sve-vl-v7-3-7b0171a36695@kernel.org>
References: <20241001-kvm-arm64-fix-pkvm-sve-vl-v7-0-7b0171a36695@kernel.org>
In-Reply-To: <20241001-kvm-arm64-fix-pkvm-sve-vl-v7-0-7b0171a36695@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-99b12
X-Developer-Signature: v=1; a=openpgp-sha256; l=3206; i=broonie@kernel.org;
 h=from:subject:message-id; bh=KBunKuidQbGsl1sTPDqT1ibl0GGL5dnEQFUfFDn0MP8=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBm+91952Fz2ONJP3ZDAU2Oql7Admcy1BKuIxh9+12i
 7GtyhbuJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZvvdfQAKCRAk1otyXVSH0PTkB/
 407zY0DEiqK+eF3/i3xkdy/woU0hcDfHxTybQd/T6pvgXBawysTNgYjQ2CogGCSBbw2pDvtNcedfI3
 0IVNF17OOUZiVB7M0DGQjX4C85sN4i+JFZ/Hm0uVzONX/hAWX3wPafc6YTKZc2kzsmQGz4IE7PnNNt
 sVBUmV/EeSNHYzoqbJfdHp2+sb36lNGBL3fzSUOPs8Ubt16DA8/+rYRzbtQcM+RjSw/cJ0kY8k0FTA
 rax6ye6OXZGFwiJGCDaYpnZlUDwxpl9QKgYDr11tRok3EbtntYmW6c4HzPhv1i/k7JWARv+cB3Dod7
 6JZh3CHiXQ9r4iQB/izB/VgNa4fdJm
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
index c838309e4ec4..6b074f4d48b2 100644
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
index 46d52e8a3df3..58f60ea95a35 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -339,7 +339,7 @@ static inline void __hyp_sve_save_host(void)
 
 	sve_state->zcr_el1 = read_sysreg_el1(SYS_ZCR);
 	write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
-	__sve_save_state(sve_state->sve_regs + sve_ffr_offset(kvm_host_sve_max_vl),
+	__sve_save_state(sve_state->sve_regs + sve_ffr_offset(__sve_get_vl()),
 			 &sve_state->fpsr,
 			 true);
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 87692b566d90..48adcd005079 100644
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

