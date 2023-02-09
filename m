Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3323BA92B
	for <kvmarm@lists.linux.dev>; Thu,  9 Feb 2023 17:58:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6690CC433A8;
	Thu,  9 Feb 2023 17:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675965529;
	bh=bDxJtBbv3EPtICbhn9EntHIP/DYyRvi5Hb9bcUYfVhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ALgXvNLEKbyFx1ns99W6jqFDBYAitcEL0d40uD+KR+73Kk0yN1YknZk9CHDyRVi0N
	 8CpCWw7D+obNO34m4UWCayfZls1CMoqYrc2XQ68Ydg3AZiO2bArclNYzmfCIIqyY7S
	 KlHe1SPyxj0tiVn5LZf8TwHPhk0VzZhdi4kVN6zWStx1dWBiGTPNdfBYp8q22Qusko
	 pCYerEswdcbBQWm2XYoVJgKWWzDw90n4L/N8nS9uFXJDlMtuBK6Nt0iCNuoqomhAg2
	 aUmWOATOW9k7fqbbvPru+HSj6kThjiDhSKsHJbZEzyLHD4zRX7avOdRILtm30sxd1Z
	 OwvcdrBwLhcnw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pQBC3-0093r7-Ej;
	Thu, 09 Feb 2023 17:58:47 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 07/18] KVM: arm64: nv: Add nested virt VCPU primitives for vEL2 VCPU state
Date: Thu,  9 Feb 2023 17:58:09 +0000
Message-Id: <20230209175820.1939006-8-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209175820.1939006-1-maz@kernel.org>
References: <20230209175820.1939006-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, catalin.marinas@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Christoffer Dall <christoffer.dall@arm.com>

When running a nested hypervisor we commonly have to figure out if
the VCPU mode is running in the context of a guest hypervisor or guest
guest, or just a normal guest.

Add convenient primitives for this.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 56 ++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 193583df2d9c..e5d826dc0b63 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -183,6 +183,62 @@ static __always_inline void vcpu_set_reg(struct kvm_vcpu *vcpu, u8 reg_num,
 		vcpu_gp_regs(vcpu)->regs[reg_num] = val;
 }
 
+static inline bool vcpu_is_el2_ctxt(const struct kvm_cpu_context *ctxt)
+{
+	switch (ctxt->regs.pstate & (PSR_MODE32_BIT | PSR_MODE_MASK)) {
+	case PSR_MODE_EL2h:
+	case PSR_MODE_EL2t:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static inline bool vcpu_is_el2(const struct kvm_vcpu *vcpu)
+{
+	return vcpu_is_el2_ctxt(&vcpu->arch.ctxt);
+}
+
+static inline bool __vcpu_el2_e2h_is_set(const struct kvm_cpu_context *ctxt)
+{
+	return ctxt_sys_reg(ctxt, HCR_EL2) & HCR_E2H;
+}
+
+static inline bool vcpu_el2_e2h_is_set(const struct kvm_vcpu *vcpu)
+{
+	return __vcpu_el2_e2h_is_set(&vcpu->arch.ctxt);
+}
+
+static inline bool __vcpu_el2_tge_is_set(const struct kvm_cpu_context *ctxt)
+{
+	return ctxt_sys_reg(ctxt, HCR_EL2) & HCR_TGE;
+}
+
+static inline bool vcpu_el2_tge_is_set(const struct kvm_vcpu *vcpu)
+{
+	return __vcpu_el2_tge_is_set(&vcpu->arch.ctxt);
+}
+
+static inline bool __is_hyp_ctxt(const struct kvm_cpu_context *ctxt)
+{
+	/*
+	 * We are in a hypervisor context if the vcpu mode is EL2 or
+	 * E2H and TGE bits are set. The latter means we are in the user space
+	 * of the VHE kernel. ARMv8.1 ARM describes this as 'InHost'
+	 *
+	 * Note that the HCR_EL2.{E2H,TGE}={0,1} isn't really handled in the
+	 * rest of the KVM code, and will result in a misbehaving guest.
+	 */
+	return vcpu_is_el2_ctxt(ctxt) ||
+		(__vcpu_el2_e2h_is_set(ctxt) && __vcpu_el2_tge_is_set(ctxt)) ||
+		__vcpu_el2_tge_is_set(ctxt);
+}
+
+static inline bool is_hyp_ctxt(const struct kvm_vcpu *vcpu)
+{
+	return __is_hyp_ctxt(&vcpu->arch.ctxt);
+}
+
 /*
  * The layout of SPSR for an AArch32 state is different when observed from an
  * AArch64 SPSR_ELx or an AArch32 SPSR_*. This function generates the AArch32
-- 
2.34.1

