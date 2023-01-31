Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DEC808
	for <kvmarm@lists.linux.dev>; Tue, 31 Jan 2023 09:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600BDC433D2;
	Tue, 31 Jan 2023 09:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675158042;
	bh=2casMehS8IylmJ+68hnzrywmz9DomVYzfqnqCRV3bno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KTzM6Wa3dR3BAgoSq8imiW+RR6fop7ej/SR/bGgFH0cfp/snKNd3XNwJWYeiVq72i
	 Dg3DrggrQ+KlsnDZuhLeBQM5sdP4AZMdMWNM3DG8il488Eg8smJg+mN+/LOA8dvGsk
	 3XWAqGHITyGuO/IlnkX+GCg908iJpNQ1aTTgqAz4oP4JpZ12KsCo2vmS3JhK9Mo67l
	 V4a3uPpbonXGq8JyTOLBI8WcElhyPhoEpNhzGj+cy0Dr7ZTAra4zsuaGaWz6C/74l6
	 YW8C79JzR+1u4m941/2+CtZOYU++yc+kjbjEMasrTUI0nTQ/WETc2yurOHX3HfYZUL
	 bZO3ROnctAtiA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pMmtR-0067U2-Ot;
	Tue, 31 Jan 2023 09:25:33 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v8 15/69] KVM: arm64: nv: Handle SPSR_EL2 specially
Date: Tue, 31 Jan 2023 09:24:10 +0000
Message-Id: <20230131092504.2880505-16-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230131092504.2880505-1-maz@kernel.org>
References: <20230131092504.2880505-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

SPSR_EL2 needs special attention when running nested on ARMv8.3:

If taking an exception while running at vEL2 (actually EL1), the
HW will update the SPSR_EL1 register with the EL1 mode. We need
to track this in order to make sure that accesses to the virtual
view of SPSR_EL2 is correct.

To do so, we place an illegal value in SPSR_EL1.M, and patch it
accordingly if required when accessing it.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 37 ++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c            | 23 +++++++++++++++--
 2 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index b31b32ecbe2d..2f5d3e27c017 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -245,6 +245,43 @@ static inline bool is_hyp_ctxt(const struct kvm_vcpu *vcpu)
 	return __is_hyp_ctxt(&vcpu->arch.ctxt);
 }
 
+static inline u64 __fixup_spsr_el2_write(struct kvm_cpu_context *ctxt, u64 val)
+{
+	if (!__vcpu_el2_e2h_is_set(ctxt)) {
+		/*
+		 * Clear the .M field when writing SPSR to the CPU, so that we
+		 * can detect when the CPU clobbered our SPSR copy during a
+		 * local exception.
+		 */
+		val &= ~0xc;
+	}
+
+	return val;
+}
+
+static inline u64 __fixup_spsr_el2_read(const struct kvm_cpu_context *ctxt, u64 val)
+{
+	if (__vcpu_el2_e2h_is_set(ctxt))
+		return val;
+
+	/*
+	 * SPSR.M == 0 means the CPU has not touched the SPSR, so the
+	 * register has still the value we saved on the last write.
+	 */
+	if ((val & 0xc) == 0)
+		return ctxt_sys_reg(ctxt, SPSR_EL2);
+
+	/*
+	 * Otherwise there was a "local" exception on the CPU,
+	 * which from the guest's point of view was being taken from
+	 * EL2 to EL2, although it actually happened to be from
+	 * EL1 to EL1.
+	 * So we need to fix the .M field in SPSR, to make it look
+	 * like EL2, which is what the guest would expect.
+	 */
+	return (val & ~0x0c) | CurrentEL_EL2;
+}
+
 /*
  * The layout of SPSR for an AArch32 state is different when observed from an
  * AArch64 SPSR_ELx or an AArch32 SPSR_*. This function generates the AArch32
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6704b64e3982..4975c5222f73 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -130,11 +130,14 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 			goto memory_read;
 
 		/*
-		 * ELR_EL2 is special cased for now.
+		 * ELR_EL2 and SPSR_EL2 are special cased for now.
 		 */
 		switch (reg) {
 		case ELR_EL2:
 			return read_sysreg_el1(SYS_ELR);
+		case SPSR_EL2:
+			val = read_sysreg_el1(SYS_SPSR);
+			return __fixup_spsr_el2_read(&vcpu->arch.ctxt, val);
 		}
 
 		/*
@@ -191,6 +194,10 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 		case ELR_EL2:
 			write_sysreg_el1(val, SYS_ELR);
 			return;
+		case SPSR_EL2:
+			val = __fixup_spsr_el2_write(&vcpu->arch.ctxt, val);
+			write_sysreg_el1(val, SYS_SPSR);
+			return;
 		}
 
 		/* No EL1 counterpart? We're done here.? */
@@ -1825,6 +1832,18 @@ static bool access_sp_el1(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool access_spsr_el2(struct kvm_vcpu *vcpu,
+			    struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		vcpu_write_sys_reg(vcpu, p->regval, SPSR_EL2);
+	else
+		p->regval = vcpu_read_sys_reg(vcpu, SPSR_EL2);
+
+	return true;
+}
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -2267,7 +2286,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(VTCR_EL2, access_rw, reset_val, 0),
 
 	{ SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
-	EL2_REG(SPSR_EL2, access_rw, reset_val, 0),
+	EL2_REG(SPSR_EL2, access_spsr_el2, reset_val, 0),
 	EL2_REG(ELR_EL2, access_rw, reset_val, 0),
 	{ SYS_DESC(SYS_SP_EL1), access_sp_el1},
 
-- 
2.34.1

