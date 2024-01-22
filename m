Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE894121E
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 20:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705954741; cv=none; b=eyy0Np08KaBf6yhgHvXUqRMcEOxYKX4Xog+AQP6EcCO8caR6hWuK9N09t3FpONCHQRr4wbDoBB0IYi/uhtO3jKd444HTHU97hzoUq7K8fUsxtq3gB3xaecASWy8auhxVhMw+SGo5vd3aBjohOIxC3WfEBbSG45DbdtmCKk+oQmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705954741; c=relaxed/simple;
	bh=Gi7IgLWtazPnWSpe7hy4LaLkjs7DEdeqIF5IZQeO8Sw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l9jesRtA40raAofHRK8Lt39a/FA03E8yaPMQaf9JEaIc9/wg3uXHNkPn8Tjf8iwegAGhjj1AYMGWHE4OAx9rJ6u7nkka0euL11bWycmi6eHDPEaIK6JUGi3V8iAYRYy0X24dt/dXFYjM3ZLOdOQi85Bz6l/GGj5vXf2tJYUrR6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kTrMgbuI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kTrMgbuI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2FEC43394;
	Mon, 22 Jan 2024 20:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705954741;
	bh=Gi7IgLWtazPnWSpe7hy4LaLkjs7DEdeqIF5IZQeO8Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kTrMgbuIZBfERUKi0fhi2TuoSLrUzFTJ7m1k3PlkL0WkyLUOYEUZB9LuLGP26iEet
	 TwjlzH4hxXvV3TF5s2sDCKwzZ0mL/Q9bg13wHNwwcd6tHKnFTw+ianE4QNwR9zlCoU
	 4NCSRmRc2rmer8He11M7nep4KiRb62GiVrIL8ZiXdbjxqJXfYXVHgz1nQCotwCbPza
	 yFHn8AXGFEaL0P7Ir2mv06CCwGutCV1wKv61GchIvX8lb3ReWojmvq2I2dIvUnMaXs
	 azHHwtK0yGxS8zAKhYpnRHRiCcK8Q2d56SoeIR4hgnbNQ9sfoC617UuVUaha0CU7q5
	 qyVezUKgcIjSg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rS0l1-00DjkQ-Qg;
	Mon, 22 Jan 2024 20:18:59 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 22/25] KVM: arm64: Make PIR{,E0}_EL1 UNDEF if S1PIE is not advertised to the guest
Date: Mon, 22 Jan 2024 20:18:49 +0000
Message-Id: <20240122201852.262057-23-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240122201852.262057-1-maz@kernel.org>
References: <20240122201852.262057-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As part of the ongoing effort to honor the guest configuration,
add the necessary checks to make PIR_EL1 and co UNDEF if not
advertised to the guest, and avoid context switching them.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 15 ++++++++++++++-
 arch/arm64/kvm/sys_regs.c                  |  4 ++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index bb6b571ec627..b34743292ca7 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -37,6 +37,19 @@ static inline bool ctxt_has_mte(struct kvm_cpu_context *ctxt)
 	return kvm_has_mte(kern_hyp_va(vcpu->kvm));
 }
 
+static inline bool ctxt_has_s1pie(struct kvm_cpu_context *ctxt)
+{
+	struct kvm_vcpu *vcpu = ctxt->__hyp_running_vcpu;
+
+	if (!cpus_have_final_cap(ARM64_HAS_S1PIE))
+		return false;
+
+	if (!vcpu)
+		vcpu = container_of(ctxt, struct kvm_vcpu, arch.ctxt);
+
+	return kvm_has_feat(kern_hyp_va(vcpu->kvm), ID_AA64MMFR3_EL1, S1PIE, IMP);
+}
+
 static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt_sys_reg(ctxt, SCTLR_EL1)	= read_sysreg_el1(SYS_SCTLR);
@@ -55,7 +68,7 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 	ctxt_sys_reg(ctxt, CONTEXTIDR_EL1) = read_sysreg_el1(SYS_CONTEXTIDR);
 	ctxt_sys_reg(ctxt, AMAIR_EL1)	= read_sysreg_el1(SYS_AMAIR);
 	ctxt_sys_reg(ctxt, CNTKCTL_EL1)	= read_sysreg_el1(SYS_CNTKCTL);
-	if (cpus_have_final_cap(ARM64_HAS_S1PIE)) {
+	if (ctxt_has_s1pie(ctxt)) {
 		ctxt_sys_reg(ctxt, PIR_EL1)	= read_sysreg_el1(SYS_PIR);
 		ctxt_sys_reg(ctxt, PIRE0_EL1)	= read_sysreg_el1(SYS_PIRE0);
 	}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3c939ea4a28f..bcde43b81755 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3990,6 +3990,10 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
 						HFGITR_EL2_TLBIRVAAE1OS	|
 						HFGITR_EL2_TLBIRVAE1OS);
 
+	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1PIE, IMP))
+		kvm->arch.fgu[HFGxTR_GROUP] |= (HFGxTR_EL2_nPIRE0_EL1 |
+						HFGxTR_EL2_nPIR_EL1);
+
 	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
 out:
 	mutex_unlock(&kvm->arch.config_lock);
-- 
2.39.2

