Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD33D227599
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 14:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774620110; cv=none; b=F/0VrExhyfHOYVtX2pdZG8zKYlPv3StPMzJNCNb5E/sp6uYSuTeblH+vDYAaB2MJebdA+Rr+56J+TcJyViRGyaksqg7YS2XZQB9mEVyuhZGyaFLfCeuyUwYuyDxDkyhT5CeE/gtlP6pa8PevyAiMoKeB2ZXbBy+OOuHQ3g8yWJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774620110; c=relaxed/simple;
	bh=ogU9AKOUaT35sbK8mPxNvogWxla2rweipWB00VFORvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=auZHKH7+XUznrY5dLvjAGrLy6Tjazuc0rw8rdeIgWlXfeOB5tqAV53BbEa/QOYcgdYDIeNuyWBPxfuo8wFNfoq87wB8B7uTHZauo2sU6yiv5P1smQMXfxwU6a+tS9fp6wlU1oV4F6mVJjbmGvHx838OdmAahD6pvASEOKDel9cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QuzuoHu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QuzuoHu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EDE2C19423;
	Fri, 27 Mar 2026 14:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774620110;
	bh=ogU9AKOUaT35sbK8mPxNvogWxla2rweipWB00VFORvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QuzuoHu8EK431FJ+O0z4daKXP3oZ1eqjPok8SWzcLR/Ddw8a6Ic7d/6w6FZPft9B0
	 R0EA+rbBcEHx/QzHIHbs2o6Tn0tNBXQ6K+K29duFGOi/FJKy2RjYD5rzvS/hek7Mft
	 FrxsWTj0IXiPR+kNPkPyhNDC6KXzICSBNO0g56uFwP+Qs2Os5OVa57gFj8uTH4HPfS
	 vpjBlWrHkLnmcdNrq3c61AEBdATwfPFogi988nFdL9PpTFp/QpVIXYlzCqqXpVhAGn
	 DCfsRomz3tELc/vVtapiolc2/vJmFQE7lbLjNoFafQoxfiB9t3w6r9RjNtXOj33i/S
	 PgFq9alspEJGw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v4 18/38] KVM: arm64: Support translation faults in inject_host_exception()
Date: Fri, 27 Mar 2026 14:00:17 +0000
Message-ID: <20260327140039.21228-19-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327140039.21228-1-will@kernel.org>
References: <20260327140039.21228-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend inject_host_exception() to support the injection of translation
faults on both the data and instruction side to 32-bit and 64-bit EL0
as well as 64-bit EL1. This will be used in a subsequent patch when
resolving an unhandled host stage-2 abort.

Cc: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/trap_handler.h |  2 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c             | 18 +++++++++++++++---
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h b/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h
index ba5382c12787..32d7b7746e8e 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h
@@ -16,4 +16,6 @@
 				__always_unused int ___check_reg_ ## reg;	\
 				type name = (type)cpu_reg(ctxt, (reg))
 
+void inject_host_exception(u64 esr);
+
 #endif /* __ARM64_KVM_NVHE_TRAP_HANDLER_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index adfc0bc15398..6db5aebd92dc 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -705,15 +705,24 @@ static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
 	kvm_skip_host_instr();
 }
 
-static void inject_host_exception(u64 esr)
+void inject_host_exception(u64 esr)
 {
 	u64 sctlr, spsr_el1, spsr_el2, exc_offset = except_type_sync;
 	const u64 spsr_mask = PSR_N_BIT | PSR_Z_BIT | PSR_C_BIT |
 			      PSR_V_BIT | PSR_DIT_BIT | PSR_PAN_BIT;
 
-	exc_offset += CURRENT_EL_SP_ELx_VECTOR;
-
 	spsr_el1 = spsr_el2 = read_sysreg_el2(SYS_SPSR);
+	switch (spsr_el1 & (PSR_MODE_MASK | PSR_MODE32_BIT)) {
+	case PSR_MODE_EL0t:
+		exc_offset += LOWER_EL_AArch64_VECTOR;
+		break;
+	case PSR_MODE_EL0t | PSR_MODE32_BIT:
+		exc_offset += LOWER_EL_AArch32_VECTOR;
+		break;
+	default:
+		exc_offset += CURRENT_EL_SP_ELx_VECTOR;
+	}
+
 	spsr_el2 &= spsr_mask;
 	spsr_el2 |= PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT |
 		    PSR_MODE_EL1h;
@@ -728,6 +737,9 @@ static void inject_host_exception(u64 esr)
 	if (system_supports_mte())
 		spsr_el2 |= PSR_TCO_BIT;
 
+	if (esr_fsc_is_translation_fault(esr))
+		write_sysreg_el1(read_sysreg_el2(SYS_FAR), SYS_FAR);
+
 	write_sysreg_el1(esr, SYS_ESR);
 	write_sysreg_el1(read_sysreg_el2(SYS_ELR), SYS_ELR);
 	write_sysreg_el1(spsr_el1, SYS_SPSR);
-- 
2.53.0.1018.g2bb0e51243-goog

