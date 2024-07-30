Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A613319E7CF;
	Tue, 30 Jul 2024 13:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722346270; cv=none; b=c38Ck7wBKPB5mc3nUmoaMf6DBVo9FyIG+AOrXtN+Ia3/ssaBECyGD7RxSqyzR7vqNtHHConHnWU2q92QOzKH2AZjeDF66RauBFbEmI3frNykrIsTe3vmerL0ScUv7ECp/nP3G4FJTWIqmLoxk0A+MIhGRb7Zlw/JdUj5oXcecO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722346270; c=relaxed/simple;
	bh=Hh0bBv0Uinp19NOdsxRBjh5fZ/0nyJqTw+fsAoXtvjo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=f49VP3c7jTfy4jh0Q9TIZ7ZXB7yNxJcVQ+OXCwvgpn1uYVVDLpxaOKTFX8Z3XSy0T7NcySvagqQM2qbx9wosJKRF6Ko8Ohmo4+kw5Nj5BZfKquJxJccPS8XOyODS+Or13I2kA4ElMtMTmm551qTphJP/bJsSSWSFqMX3pX30aww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ADIJ1hB9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ADIJ1hB9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC638C4AF0F;
	Tue, 30 Jul 2024 13:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722346269;
	bh=Hh0bBv0Uinp19NOdsxRBjh5fZ/0nyJqTw+fsAoXtvjo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ADIJ1hB9RSjFfyojHeR87Wgjg0+BLjd5ZuV3bILAa+ZOn+rfu1Pn/YPmetVPNVQ7I
	 opWl3+lwQ1AtAZOx/vyuUL+kKesPLWg66TqlVKD4MX/by5lD0AujDWfXJm0JUaSGlQ
	 AyX6VDjKp4W49NPS3dRwM8mD7/zHG/ERpFreAYVGl1vZjgHRMmPZXWL4NtUMuot3nc
	 xpfUAZSVcyV6oaHDKhd3SDneBXJlEM4FdH47sdfeuafmOTCPcUEgZz6Ol2psbzCDHR
	 GNsMb85Hy+eWAb3Q7KGpnqAGMQ9Seng+CHmUkI4DEQQIuOtvfSRxXCuERf/mh0PoeA
	 40tQbfl5GOXBQ==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 30 Jul 2024 14:29:15 +0100
Subject: [PATCH v6 3/4] KVM: arm64: Fix FFR offset calculation for pKVM
 host state save and restore
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240730-kvm-arm64-fix-pkvm-sve-vl-v6-3-cae8a2e0bd66@kernel.org>
References: <20240730-kvm-arm64-fix-pkvm-sve-vl-v6-0-cae8a2e0bd66@kernel.org>
In-Reply-To: <20240730-kvm-arm64-fix-pkvm-sve-vl-v6-0-cae8a2e0bd66@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-37811
X-Developer-Signature: v=1; a=openpgp-sha256; l=3206; i=broonie@kernel.org;
 h=from:subject:message-id; bh=Hh0bBv0Uinp19NOdsxRBjh5fZ/0nyJqTw+fsAoXtvjo=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmqOsQJWqCq6fmsC0JdY+DmVUd1I3fd1kQDilFaVnx
 a07qBhSJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZqjrEAAKCRAk1otyXVSH0BODB/
 9Cm+AOQiqOzGljQgfVO2X+nhRfYllxzG+ma4VpNwilRfbKXBxbtsYZbNxLooa4VUcBTf0Je4aqCaik
 SotpKbJ7qNBVX1OcNs/4hEX2+SI0QLP8sRyvh43YIJmPdUY20nkbI9YTr4S4mkvWXAeYk89Oxi/4Sd
 5Sg8T0Q0UJFkL5HQSlLAInrZ1d54JGChgdFAYMfzOgeY+q3FuYoAIKkR/T5YyHWj6rswVi/whsfxjB
 Q/LzDc+ZJ+zec9L1d5z1EH6qKBrpsnOVKb8Ll3C3tq/MrL7FQRNRwkoNZ7tVgydrSNEczlMTWoPA3+
 nOlLuiVT0WC4YGJbDdYnDS7LslGjLB
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
index f59ccfe11ab9..526e49b6f09e 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -340,7 +340,7 @@ static inline void __hyp_sve_save_host(void)
 
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

