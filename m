Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5BC101C7
	for <kvmarm@lists.linux.dev>; Tue,  8 Aug 2023 11:48:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77CA1C433CA;
	Tue,  8 Aug 2023 11:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1691495317;
	bh=ivoPwC7KYxKBbQzlsrB2uNaBK9Wd47hsEELhdsqf0qY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nufHxW6OL2iwdW/N81uQGr9Eab0FY4pA0WSkQJZtc6PWM6t3wZjJWFShfnnSWS2h3
	 PELNlg43BRK7k6e8mKoleDnqap2ceqrwYZE0NQwXZ531RQbqmFh30fWVaLl8tarboB
	 6ltM8yeQNSape56bJB392JqMfS/rgZPtgR9gy4ByR0g4VNkivhPvMaxljuOPXZq2gv
	 r9STBH+zvEfOXvYx3eDNVJrGaTM1hAvMmULN9Ac0y/oCJ5UDuhO94/5onVCRBHdBLI
	 KXjhjkcqDFvGgTMDJF1z2LgVtZoaRec6fu8+h+xwKe2sfT8gUllTSxV+cTtefCQp23
	 DeTqRI+PGGJ5A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qTLBL-0037Ph-2O;
	Tue, 08 Aug 2023 12:47:23 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Miguel Luis <miguel.luis@oracle.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v3 24/27] KVM: arm64: nv: Add switching support for HFGxTR/HDFGxTR
Date: Tue,  8 Aug 2023 12:47:08 +0100
Message-Id: <20230808114711.2013842-25-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230808114711.2013842-1-maz@kernel.org>
References: <20230808114711.2013842-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we can evaluate the FGT registers, allow them to be merged
with the hypervisor's own configuration (in the case of HFG{RW}TR_EL2)
or simply set for HFGITR_EL2, HDGFRTR_EL2 and HDFGWTR_EL2.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 48 +++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index e096b16e85fd..a4750070563f 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -70,6 +70,13 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 	}
 }
 
+#define compute_clr_set(vcpu, reg, clr, set)				\
+	do {								\
+		u64 hfg;						\
+		hfg = __vcpu_sys_reg(vcpu, reg) & ~__ ## reg ## _RES0;	\
+		set |= hfg & __ ## reg ## _MASK; 			\
+		clr |= ~hfg & __ ## reg ## _nMASK; 			\
+	} while(0)
 
 
 static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
@@ -97,6 +104,10 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
 		w_set |= HFGxTR_EL2_TCR_EL1_MASK;
 
+	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
+		compute_clr_set(vcpu, HFGRTR_EL2, r_clr, r_set);
+		compute_clr_set(vcpu, HFGWTR_EL2, w_clr, w_set);
+	}
 
 	/* The default is not to trap anything but ACCDATA_EL1 */
 	r_val = __HFGRTR_EL2_nMASK & ~HFGxTR_EL2_nACCDATA_EL1;
@@ -109,6 +120,38 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 
 	write_sysreg_s(r_val, SYS_HFGRTR_EL2);
 	write_sysreg_s(w_val, SYS_HFGWTR_EL2);
+
+	if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
+		return;
+
+	ctxt_sys_reg(hctxt, HFGITR_EL2) = read_sysreg_s(SYS_HFGITR_EL2);
+
+	r_set = r_clr = 0;
+	compute_clr_set(vcpu, HFGITR_EL2, r_clr, r_set);
+	r_val = __HFGITR_EL2_nMASK;
+	r_val |= r_set;
+	r_val &= ~r_clr;
+
+	write_sysreg_s(r_val, SYS_HFGITR_EL2);
+
+	ctxt_sys_reg(hctxt, HDFGRTR_EL2) = read_sysreg_s(SYS_HDFGRTR_EL2);
+	ctxt_sys_reg(hctxt, HDFGWTR_EL2) = read_sysreg_s(SYS_HDFGWTR_EL2);
+
+	r_clr = r_set = w_clr = w_set = 0;
+
+	compute_clr_set(vcpu, HDFGRTR_EL2, r_clr, r_set);
+	compute_clr_set(vcpu, HDFGWTR_EL2, w_clr, w_set);
+
+	r_val = __HDFGRTR_EL2_nMASK;
+	r_val |= r_set;
+	r_val &= ~r_clr;
+
+	w_val = __HDFGWTR_EL2_nMASK;
+	w_val |= w_set;
+	w_val &= ~w_clr;
+
+	write_sysreg_s(r_val, SYS_HDFGRTR_EL2);
+	write_sysreg_s(w_val, SYS_HDFGWTR_EL2);
 }
 
 static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
@@ -121,7 +164,12 @@ static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 	write_sysreg_s(ctxt_sys_reg(hctxt, HFGRTR_EL2), SYS_HFGRTR_EL2);
 	write_sysreg_s(ctxt_sys_reg(hctxt, HFGWTR_EL2), SYS_HFGWTR_EL2);
 
+	if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
+		return;
 
+	write_sysreg_s(ctxt_sys_reg(hctxt, HFGITR_EL2), SYS_HFGITR_EL2);
+	write_sysreg_s(ctxt_sys_reg(hctxt, HDFGRTR_EL2), SYS_HDFGRTR_EL2);
+	write_sysreg_s(ctxt_sys_reg(hctxt, HDFGWTR_EL2), SYS_HDFGWTR_EL2);
 }
 
 static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
-- 
2.34.1

