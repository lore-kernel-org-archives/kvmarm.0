Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A2758235
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 18:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705947242; cv=none; b=MUFBJ//plIkIcnahGSRGnJaxWCNPvUU3TBOvlJ3I3tRCSP6Kw6s09sQsfa4Gd5d/Tb1JxWh2lZZhtm+q7A/FpSTbR+bRezBikOM9AOwsodZisfZti6hwQAvlj784HJb6hvLGXvmKgkoTQSeXX9aJpyLR3WsXCf0+y151fv7rB1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705947242; c=relaxed/simple;
	bh=GGerkmtaNjy22Jb7TRkxak0xA1aU5iFzPnFQ3YcbEbw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DxwVaIgCMqwUE05r4Rf9+XTXm+aOukzUAP7InEHH5Xzo2MABYZKOuz/+b2zga5byuYabWv70m084YOj6H7b7RlA+NXEwb4iDGjuLfz1ZdRXslnxyMGyO1ySQ402Zv1k2xTVA8hy34mlttZo3QsOrzCRF1I8uCFP42uDPWndsPww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZBcFP7t6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZBcFP7t6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216E3C433F1;
	Mon, 22 Jan 2024 18:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705947242;
	bh=GGerkmtaNjy22Jb7TRkxak0xA1aU5iFzPnFQ3YcbEbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZBcFP7t6QT6a9a1hEXg9i6RQcW3s+KkaZTPSdvVkJvT5C/I+4I32XqXmI5Mczba10
	 MrHBqKG7FTXDa8wInbEXQLofQ26dIdpskJjre8CQvAHAsPG2LL35JtqqH4UwBcpQro
	 9SDnkjEcJaeRo4gbRbZZyTPB8ldbfV0TfnjN+SO/wKNn4ODzukLesIWXdLDDL3s7BJ
	 vSf1EjGd5hxA1ilavlmr6rsZav4kD6hptJBvJviR47RmL3rTRc2ZesbZ2eL1G8EQ0c
	 z+LVV4ObZpT6Zw64vVTRrd/6Orny1AbyuWcg6n7D4ABHUbYy+62kobCCh/Q4h1xO0G
	 4lJlb6ofYLG+g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rRyo4-00Dh6E-8E;
	Mon, 22 Jan 2024 18:14:00 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v4 09/10] KVM: arm64: Force guest's HCR_EL2.E2H RES1 when NV1 is not implemented
Date: Mon, 22 Jan 2024 18:13:43 +0000
Message-Id: <20240122181344.258974-10-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240122181344.258974-1-maz@kernel.org>
References: <20240122181344.258974-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, suzuki.poulose@arm.com, ardb@kernel.org, james.morse@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
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
index b804fe832184..debc3753d2ef 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -209,7 +209,8 @@ static inline bool vcpu_is_el2(const struct kvm_vcpu *vcpu)
 
 static inline bool __vcpu_el2_e2h_is_set(const struct kvm_cpu_context *ctxt)
 {
-	return ctxt_sys_reg(ctxt, HCR_EL2) & HCR_E2H;
+	return (!cpus_have_final_cap(ARM64_HAS_HCR_NV1) ||
+		(ctxt_sys_reg(ctxt, HCR_EL2) & HCR_E2H));
 }
 
 static inline bool vcpu_el2_e2h_is_set(const struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 08a9571fa809..041b11825578 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2175,6 +2175,16 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static u64 reset_hcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	u64 val = r->val;
+
+	if (!cpus_have_final_cap(ARM64_HAS_HCR_NV1))
+		val |= HCR_E2H;
+
+	return __vcpu_sys_reg(vcpu, r->reg) = val;
+}
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -2666,7 +2676,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG_VNCR(VMPIDR_EL2, reset_unknown, 0),
 	EL2_REG(SCTLR_EL2, access_rw, reset_val, SCTLR_EL2_RES1),
 	EL2_REG(ACTLR_EL2, access_rw, reset_val, 0),
-	EL2_REG_VNCR(HCR_EL2, reset_val, 0),
+	EL2_REG_VNCR(HCR_EL2, reset_hcr, 0),
 	EL2_REG(MDCR_EL2, access_rw, reset_val, 0),
 	EL2_REG(CPTR_EL2, access_rw, reset_val, CPTR_NVHE_EL2_RES1),
 	EL2_REG_VNCR(HSTR_EL2, reset_val, 0),
-- 
2.39.2

