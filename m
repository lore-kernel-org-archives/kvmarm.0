Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858783A961B
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 14:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772721910; cv=none; b=dcv6+fE35q9eXNBrmMW4VGzw0X36Y0buTboo8fc/T5LOEIBa3vGoN318RDc7HewP4BueYyiCljmoQm/NABP6HSYHcv8cRew4E4JEOu8+QmJ4fAF0ywrOHQ33rRfE+jymj189KwVRZ/u83RDWv/cRMYqrYwcpF4hGdQzKOzoKbNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772721910; c=relaxed/simple;
	bh=lgKaBfTxFIy6N2O167IZSquC1rmS31Si+e9fbRSoKsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPFhoL522Nt2YfK5Pp07mnqjUueAMs7UpGgIeLNk9s1FynJg+B3lj/Nen4q4q6h5sEFYXcBTO6+o3RcTOpEtkS4MlRbYKGFL8eXl39K5vs8WqsxoGMqxc5iz2G7RMuB5QHGmaJyxix/n/P4/xAQAMmr9NcWOsO6RmRjo4xBoueQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ecEBzHiv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ecEBzHiv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A66EC2BC87;
	Thu,  5 Mar 2026 14:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772721909;
	bh=lgKaBfTxFIy6N2O167IZSquC1rmS31Si+e9fbRSoKsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ecEBzHivkbW/XdgHW4XjT9kLf7wDDJI365WJwlJzybC7sj65qlFlEp5xbefcI/7Fp
	 vZ1yDF6raVusLrIxTh/fBEW7agzGGy2bNas4vt1oXLuj2WA1RNgM4a3MrY3b7a8lKH
	 4xwhFuCx/AlN+rVRkFGbkSuMKtGwoKsacUPRaGLNm8QKVFEiHj//ObHPgqSjUJhmYN
	 ivmvyp/hjco5uAvZbI2EPvtCou8Aco6n4PAn34F5OsSnj/5TwW7tsebjwqZmis9vcM
	 q0TuGoVwyNn0bRGIVByr/J1IaBObe6afbcIhOXXGhZy0dV2Jb0fHxsFhkvVQ7AuEJz
	 xI88bg6qc8czg==
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
Subject: [PATCH v3 17/36] KVM: arm64: Support translation faults in inject_host_exception()
Date: Thu,  5 Mar 2026 14:43:30 +0000
Message-ID: <20260305144351.17071-18-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260305144351.17071-1-will@kernel.org>
References: <20260305144351.17071-1-will@kernel.org>
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
2.53.0.473.g4a7958ca14-goog

