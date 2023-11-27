Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F033B101F2
	for <kvmarm@lists.linux.dev>; Mon, 27 Nov 2023 11:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IPCRnm7T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C503DC433C9;
	Mon, 27 Nov 2023 11:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701085569;
	bh=TsGkexKp8HUOn/B8FDEVImO0nATvBu12UOy6vG/PoGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IPCRnm7T9hDe7nKklC3BHITnCk/ndpMFE+k4m1nJPrQ9xW5IWsCORrWHhgxwRStwM
	 dDAeKpRu9cpVbeOA808dQ6qJgKkzhmf7ORBXL73sAX0o2GEHS4+mnhGl+e5RlMHAQY
	 I1RB4L8OQMvJuLu2x3P59dbejayfl0+N4X/myMjxZt4wxiNyTUtPZBAiOijuVbcb8P
	 jAm/mA9VyI2oQNJQnql5Zotq+Nr82VpA6qPICgnlR8+F/mlk8pTTL6OrWh8fAktn76
	 Fg2fl4IjvP4VIX+Q6y9vKigUFjzqhXfE4tuVe1fh0JJGfOECOEFXIoT7VeGsZPoN+K
	 QZp/ALMQXI7jg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r7a3z-00GleL-Uj;
	Mon, 27 Nov 2023 11:46:08 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v3 13/13] KVM: arm64: Force guest's HCR_EL2.E2H RES1 when NV1 is not implemented
Date: Mon, 27 Nov 2023 11:45:59 +0000
Message-Id: <20231127114559.990314-14-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231127114559.990314-1-maz@kernel.org>
References: <20231127114559.990314-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, ardb@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

If NV1 isn't supported on a system, make sure we always evaluate
the guest's HCR_EL2.E2H as RES1, irrespective of what the guest
may have written there.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h |  3 ++-
 arch/arm64/kvm/sys_regs.c            | 12 +++++++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 78a550537b67..7b10a44189d0 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -213,7 +213,8 @@ static inline bool vcpu_is_el2(const struct kvm_vcpu *vcpu)
 
 static inline bool __vcpu_el2_e2h_is_set(const struct kvm_cpu_context *ctxt)
 {
-	return ctxt_sys_reg(ctxt, HCR_EL2) & HCR_E2H;
+	return (cpus_have_final_cap(ARM64_HCR_NV1_RES0) ||
+		(ctxt_sys_reg(ctxt, HCR_EL2) & HCR_E2H));
 }
 
 static inline bool vcpu_el2_e2h_is_set(const struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ff2e66f0bda1..9e1e3da2ed4a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2022,6 +2022,16 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static u64 reset_hcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	u64 val = r->val;
+
+	if (cpus_have_final_cap(ARM64_HCR_NV1_RES0))
+		val |= HCR_E2H;
+
+	return __vcpu_sys_reg(vcpu, r->reg) = val;
+}
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -2513,7 +2523,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(VMPIDR_EL2, access_rw, reset_unknown, 0),
 	EL2_REG(SCTLR_EL2, access_rw, reset_val, SCTLR_EL2_RES1),
 	EL2_REG(ACTLR_EL2, access_rw, reset_val, 0),
-	EL2_REG(HCR_EL2, access_rw, reset_val, 0),
+	EL2_REG(HCR_EL2, access_rw, reset_hcr, 0),
 	EL2_REG(MDCR_EL2, access_rw, reset_val, 0),
 	EL2_REG(CPTR_EL2, access_rw, reset_val, CPTR_NVHE_EL2_RES1),
 	EL2_REG(HSTR_EL2, access_rw, reset_val, 0),
-- 
2.39.2

