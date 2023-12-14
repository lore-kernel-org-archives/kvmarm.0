Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F53B2E64B
	for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 10:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IXLqMGHK"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbce98f7d44so286416276.2
        for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 02:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702548141; x=1703152941; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LWwzLbvByHCmWMHsPOp6gqtuDic+laOykV5wdqH7WEA=;
        b=IXLqMGHKv1szU43DRLW5/BgRaKB/7hY/jbARtACsgeXJMMs4WyTcKrizmT6Cdm8E8i
         lZWewATOsM/mzn781/zpEgMIn/Z2AxhUURn4zK6RbhWghoRZnLzixgd4ZSUo4jjzbr8c
         XPMy7EJPoHEiR/jJjZ6/oQzyQG7GCfTsuVpQ52OKQHnqDzSsSAyXm6xvp0gppKZ7JS5B
         NTY8i3ZCKTdAuqGvzW8/hdtQBk/K96Bw8zMrfaRl72xPIrW5HvO6qa0vhJyxfkwkh8xZ
         NifnoPPI2/U0iT9VH8dtQ/QMMw3Bl8p2ur4fWGRgzkISN7PrS1ziqfHZoBXO43Nx7HfO
         aYnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702548141; x=1703152941;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LWwzLbvByHCmWMHsPOp6gqtuDic+laOykV5wdqH7WEA=;
        b=KgvziW69je+CPHNkIkROdbKQctzeemWYpwLxmSHMdDZkyuPeqwTsjqOVbfcIEUl7BV
         PwdB4qJFBG1QnLs59bu3TcOT6DXlTuAyw2heQ28fg6VULw7io91d18JZ0LtVFXwcPS5O
         IeMqNDvc24H6lS2P00goPIiIxDrzVr4kBE24tCjslT/J1OzNXS0gxeliaej2vvjnY/e9
         eSQdeyEac+jl2kIg8cD9fyXmX7C+CJ4lOvIzEekUXPq0TGpgaHsIwkPCVQh/MSB/HO3W
         vBDj9Yq7vPldmfOoDXkBmAE3rCawbqz+XyYEsYPQ5v823QluwvSF5z58RmPj4H8/rRU0
         EpCA==
X-Gm-Message-State: AOJu0Yzhb5IxAkVtsqDkJr+faxcC6eG4dISOEFZWY84KA6N2Q4zkSwhw
	MgAUkD8kLpsXkyd9uUtIPCHaxMyUln4loQtnCgiWFA4FWJpnArehzNBqKmKe/oecYLvYpKvHtGd
	qz4O2vS/DMjTYCDLthui9lC6PezHrWIycmLYOAGc2/YsuJ2sAND9/B/Hjz7Q=
X-Google-Smtp-Source: AGHT+IEQz3VBSiDveYMYZZJRvCqTfLzVPzfPWPwNQqScEnd95XhL1OToVJz/PKu0HJcWp0GJCwuKytlQyA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:4e5:b0:dbc:cf1a:312c with SMTP id
 w5-20020a05690204e500b00dbccf1a312cmr36793ybs.4.1702548140735; Thu, 14 Dec
 2023 02:02:20 -0800 (PST)
Date: Thu, 14 Dec 2023 10:01:49 +0000
In-Reply-To: <20231214100158.2305400-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231214100158.2305400-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231214100158.2305400-10-tabba@google.com>
Subject: [PATCH v3 09/17] KVM: arm64: Handle HAFGRTR_EL2 trapping in nested virt
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, broonie@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com, 
	jingzhangos@google.com, joey.gouly@arm.com, tabba@google.com, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Add the encodings to fine grain trapping fields for HAFGRTR_EL2
and add the associated handling code in nested virt. Based on
DDI0601 2023-09. Add the missing field definitions as well,
both to generate the correct RES0 mask and to be able to toggle
their FGT bits.

Also add the code for handling FGT trapping, reading of the
register, to nested virt.

Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h       |  1 +
 arch/arm64/kvm/emulate-nested.c         | 48 +++++++++++++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 12 +++++++
 arch/arm64/kvm/sys_regs.c               |  1 +
 4 files changed, 62 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 824f29f04916..ba14648e2de2 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -443,6 +443,7 @@ enum vcpu_sysreg {
 	HFGITR_EL2,
 	HDFGRTR_EL2,
 	HDFGWTR_EL2,
+	HAFGRTR_EL2,
 	CNTHP_CTL_EL2,
 	CNTHP_CVAL_EL2,
 	CNTHV_CTL_EL2,
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 89901550db34..431fd429932d 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1012,6 +1012,7 @@ enum fgt_group_id {
 	HDFGRTR_GROUP,
 	HDFGWTR_GROUP,
 	HFGITR_GROUP,
+	HAFGRTR_GROUP,
 
 	/* Must be last */
 	__NR_FGT_GROUP_IDS__
@@ -1689,6 +1690,49 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
 	SR_FGT(SYS_PMCR_EL0,		HDFGWTR, PMCR_EL0, 1),
 	SR_FGT(SYS_PMSWINC_EL0,		HDFGWTR, PMSWINC_EL0, 1),
 	SR_FGT(SYS_OSLAR_EL1,		HDFGWTR, OSLAR_EL1, 1),
+	/*
+	 * HAFGRTR_EL2
+	 */
+	SR_FGT(SYS_AMEVTYPER1_EL0(15),	HAFGRTR, AMEVTYPER115_EL0, 1),
+	SR_FGT(SYS_AMEVTYPER1_EL0(14),	HAFGRTR, AMEVTYPER114_EL0, 1),
+	SR_FGT(SYS_AMEVTYPER1_EL0(13),	HAFGRTR, AMEVTYPER113_EL0, 1),
+	SR_FGT(SYS_AMEVTYPER1_EL0(12),	HAFGRTR, AMEVTYPER112_EL0, 1),
+	SR_FGT(SYS_AMEVTYPER1_EL0(11),	HAFGRTR, AMEVTYPER111_EL0, 1),
+	SR_FGT(SYS_AMEVTYPER1_EL0(10),	HAFGRTR, AMEVTYPER110_EL0, 1),
+	SR_FGT(SYS_AMEVTYPER1_EL0(9),	HAFGRTR, AMEVTYPER19_EL0, 1),
+	SR_FGT(SYS_AMEVTYPER1_EL0(8),	HAFGRTR, AMEVTYPER18_EL0, 1),
+	SR_FGT(SYS_AMEVTYPER1_EL0(7),	HAFGRTR, AMEVTYPER17_EL0, 1),
+	SR_FGT(SYS_AMEVTYPER1_EL0(6),	HAFGRTR, AMEVTYPER16_EL0, 1),
+	SR_FGT(SYS_AMEVTYPER1_EL0(5),	HAFGRTR, AMEVTYPER15_EL0, 1),
+	SR_FGT(SYS_AMEVTYPER1_EL0(4),	HAFGRTR, AMEVTYPER14_EL0, 1),
+	SR_FGT(SYS_AMEVTYPER1_EL0(3),	HAFGRTR, AMEVTYPER13_EL0, 1),
+	SR_FGT(SYS_AMEVTYPER1_EL0(2),	HAFGRTR, AMEVTYPER12_EL0, 1),
+	SR_FGT(SYS_AMEVTYPER1_EL0(1),	HAFGRTR, AMEVTYPER11_EL0, 1),
+	SR_FGT(SYS_AMEVTYPER1_EL0(0),	HAFGRTR, AMEVTYPER10_EL0, 1),
+	SR_FGT(SYS_AMEVCNTR1_EL0(15),	HAFGRTR, AMEVCNTR115_EL0, 1),
+	SR_FGT(SYS_AMEVCNTR1_EL0(14),	HAFGRTR, AMEVCNTR114_EL0, 1),
+	SR_FGT(SYS_AMEVCNTR1_EL0(13),	HAFGRTR, AMEVCNTR113_EL0, 1),
+	SR_FGT(SYS_AMEVCNTR1_EL0(12),	HAFGRTR, AMEVCNTR112_EL0, 1),
+	SR_FGT(SYS_AMEVCNTR1_EL0(11),	HAFGRTR, AMEVCNTR111_EL0, 1),
+	SR_FGT(SYS_AMEVCNTR1_EL0(10),	HAFGRTR, AMEVCNTR110_EL0, 1),
+	SR_FGT(SYS_AMEVCNTR1_EL0(9),	HAFGRTR, AMEVCNTR19_EL0, 1),
+	SR_FGT(SYS_AMEVCNTR1_EL0(8),	HAFGRTR, AMEVCNTR18_EL0, 1),
+	SR_FGT(SYS_AMEVCNTR1_EL0(7),	HAFGRTR, AMEVCNTR17_EL0, 1),
+	SR_FGT(SYS_AMEVCNTR1_EL0(6),	HAFGRTR, AMEVCNTR16_EL0, 1),
+	SR_FGT(SYS_AMEVCNTR1_EL0(5),	HAFGRTR, AMEVCNTR15_EL0, 1),
+	SR_FGT(SYS_AMEVCNTR1_EL0(4),	HAFGRTR, AMEVCNTR14_EL0, 1),
+	SR_FGT(SYS_AMEVCNTR1_EL0(3),	HAFGRTR, AMEVCNTR13_EL0, 1),
+	SR_FGT(SYS_AMEVCNTR1_EL0(2),	HAFGRTR, AMEVCNTR12_EL0, 1),
+	SR_FGT(SYS_AMEVCNTR1_EL0(1),	HAFGRTR, AMEVCNTR11_EL0, 1),
+	SR_FGT(SYS_AMEVCNTR1_EL0(0),	HAFGRTR, AMEVCNTR10_EL0, 1),
+	SR_FGT(SYS_AMCNTENCLR1_EL0,	HAFGRTR, AMCNTEN1, 1),
+	SR_FGT(SYS_AMCNTENSET1_EL0,	HAFGRTR, AMCNTEN1, 1),
+	SR_FGT(SYS_AMCNTENCLR0_EL0,	HAFGRTR, AMCNTEN0, 1),
+	SR_FGT(SYS_AMCNTENSET0_EL0,	HAFGRTR, AMCNTEN0, 1),
+	SR_FGT(SYS_AMEVCNTR0_EL0(3),	HAFGRTR, AMEVCNTR03_EL0, 1),
+	SR_FGT(SYS_AMEVCNTR0_EL0(2),	HAFGRTR, AMEVCNTR02_EL0, 1),
+	SR_FGT(SYS_AMEVCNTR0_EL0(1),	HAFGRTR, AMEVCNTR01_EL0, 1),
+	SR_FGT(SYS_AMEVCNTR0_EL0(0),	HAFGRTR, AMEVCNTR00_EL0, 1),
 };
 
 static union trap_config get_trap_config(u32 sysreg)
@@ -1909,6 +1953,10 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
 			val = sanitised_sys_reg(vcpu, HDFGWTR_EL2);
 		break;
 
+	case HAFGRTR_GROUP:
+		val = sanitised_sys_reg(vcpu, HAFGRTR_EL2);
+		break;
+
 	case HFGITR_GROUP:
 		val = sanitised_sys_reg(vcpu, HFGITR_EL2);
 		switch (tc.fgf) {
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 7b4909dfd1f5..22f3b916f60c 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -156,6 +156,17 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 
 	write_sysreg_s(r_val, SYS_HDFGRTR_EL2);
 	write_sysreg_s(w_val, SYS_HDFGWTR_EL2);
+
+	ctxt_sys_reg(hctxt, HAFGRTR_EL2) = read_sysreg_s(SYS_HAFGRTR_EL2);
+
+	r_clr = r_set = 0;
+	compute_clr_set(vcpu, HAFGRTR_EL2, r_clr, r_set);
+
+	r_val = __HAFGRTR_EL2_nMASK;
+	r_val |= r_set;
+	r_val &= ~r_clr;
+
+	write_sysreg_s(r_val, SYS_HAFGRTR_EL2);
 }
 
 static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
@@ -174,6 +185,7 @@ static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 	write_sysreg_s(ctxt_sys_reg(hctxt, HFGITR_EL2), SYS_HFGITR_EL2);
 	write_sysreg_s(ctxt_sys_reg(hctxt, HDFGRTR_EL2), SYS_HDFGRTR_EL2);
 	write_sysreg_s(ctxt_sys_reg(hctxt, HDFGWTR_EL2), SYS_HDFGWTR_EL2);
+	write_sysreg_s(ctxt_sys_reg(hctxt, HAFGRTR_EL2), SYS_HAFGRTR_EL2);
 }
 
 static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4735e1b37fb3..8bb297a2df38 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2532,6 +2532,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_DACR32_EL2), trap_undef, reset_unknown, DACR32_EL2 },
 	EL2_REG(HDFGRTR_EL2, access_rw, reset_val, 0),
 	EL2_REG(HDFGWTR_EL2, access_rw, reset_val, 0),
+	EL2_REG(HAFGRTR_EL2, access_rw, reset_val, 0),
 	EL2_REG(SPSR_EL2, access_rw, reset_val, 0),
 	EL2_REG(ELR_EL2, access_rw, reset_val, 0),
 	{ SYS_DESC(SYS_SP_EL1), access_sp_el1},
-- 
2.43.0.472.g3155946c3a-goog

