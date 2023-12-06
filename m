Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D59288B6
	for <kvmarm@lists.linux.dev>; Wed,  6 Dec 2023 10:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RKM0uuLz"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3333aaf02b0so568510f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 06 Dec 2023 02:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701857118; x=1702461918; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7SP3sDUJm7sIfFMD/5d3gdGSF/LmXReOj/BWJwGqCMY=;
        b=RKM0uuLzb3Z/EQLif8NdnuBOicWSOvJDEx65ly5MTKeWr/zYd36tPkawIRSQZI17hO
         9Z4TEs+nCnTanFRInISjeQ+IGu5JfVNkX6h3F28aHNk8/f4rEqyy/Qo66maNgFrmOBhU
         W3HQIqJ+sw9hKrRPgHW1y3YGiDl1qjCM6NY5lRjwcb/b4XZSVd+dBTTEjJgDwUaNI3Sp
         OciP587oeVcCUBiKM5pb3FAOD2ApK4VbTbFWVXRLG9ddyjiCX1SvZ/JfXptTkWZqPj3C
         m6E76l9mlho14nUFbkj+mf18q9yZvSCPksjQeUgqZj8mvzmwqGJ3prMXAjW8Oi0UrhkL
         r98Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701857118; x=1702461918;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7SP3sDUJm7sIfFMD/5d3gdGSF/LmXReOj/BWJwGqCMY=;
        b=dQ9/NPpuagRViqP8sIFBtr+uZuElYzO0ITSPJJiMfnZTjdodZLjo2R/vvxSKtaNt8R
         Xtg/ocO3VS9m6Sdg/kuO9d9iBce0dN2kiAoJo9D9jU92wI1pBw/ht6OI5h8oa3zlb/Pk
         6xI7MKvqMV+Vgt83X9VYKss6nTJF0j69TzThIJyr+eYvsz1ufGxfZwqxZx78OqDfcr5G
         f/TSWqmPYHiJyIe3eskut/t2pSW5TdxoyN8PNTqnr90rHcjSlRLTZTk/DkSkDMzR0QZT
         53zOoY0zd02akX9L8LncHM3r2hvHiyULQqiVzYHJNuedl4R+xG1tTF75uYY8HYI6swAx
         NsCA==
X-Gm-Message-State: AOJu0Yz4aZXMR0zpXCegzYhudA7e604s/0zIYVmrrXrghN7XBv7No/DR
	3wlt4OUP5Mf1TjK2Ig/MS/ZSSiNs7SfATYLu4VN/2rViWjEU/uwnVyXuXcMMBGmEfTsAFNWPm3C
	SkVl+jwBnLKZIojHYn3mVUpu58Flu6UQAveE3HWbJNSR9VnXiLFCX5u1jTow=
X-Google-Smtp-Source: AGHT+IHJ7r+M9BmKZfpMNs1Per/YpxlauBlShuEXoqdEUwrXwAN3rmcPmnbp/u+JQ/ddccJn8WRj4Vnykw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6000:1548:b0:333:542d:db0b with SMTP id
 8-20020a056000154800b00333542ddb0bmr3197wry.6.1701857117470; Wed, 06 Dec 2023
 02:05:17 -0800 (PST)
Date: Wed,  6 Dec 2023 10:04:55 +0000
In-Reply-To: <20231206100503.564090-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231206100503.564090-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231206100503.564090-6-tabba@google.com>
Subject: [PATCH v2 05/12] KVM: arm64: Handle HAFGRTR_EL2 trapping in nested virt
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, eric.auger@redhat.com, jingzhangos@google.com, 
	joey.gouly@arm.com, tabba@google.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Add the encodings to fine grain trapping fields for HAFGRTR_EL2
and add the associated handling code in nested virt. Based on
the 2023-09 Arm Architecture System Registers xml
specification [*]. Add the missing field definitions as well,
both to generate the correct RES0 mask and to be able to toggle
their FGT bits.

Also add the code for handling FGT trapping, reading of the
register, to nested virt.

[*] https://developer.arm.com/downloads/-/exploration-tools

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h       |  1 +
 arch/arm64/kvm/emulate-nested.c         | 48 +++++++++++++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 11 ++++++
 arch/arm64/kvm/sys_regs.c               |  1 +
 arch/arm64/tools/sysreg                 | 43 ++++++++++++++++++++++
 5 files changed, 104 insertions(+)

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
index f99d8af0b9af..76a3d78b13d9 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -153,6 +153,17 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 
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
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 61cc3bcfc3fa..e5631f4e62f4 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2297,6 +2297,49 @@ Field	1	DBGBVRn_EL1
 Field	0	DBGBCRn_EL1
 EndSysreg
 
+Sysreg HAFGRTR_EL2	3	4	3	1	6
+Res0	63:50
+Field	49	AMEVTYPER115_EL0
+Field	48	AMEVCNTR115_EL0
+Field	47	AMEVTYPER114_EL0
+Field	46	AMEVCNTR114_EL0
+Field	45	AMEVTYPER113_EL0
+Field	44	AMEVCNTR113_EL0
+Field	43	AMEVTYPER112_EL0
+Field	42	AMEVCNTR112_EL0
+Field	41	AMEVTYPER111_EL0
+Field	40	AMEVCNTR111_EL0
+Field	39	AMEVTYPER110_EL0
+Field	38	AMEVCNTR110_EL0
+Field	37	AMEVTYPER19_EL0
+Field	36	AMEVCNTR19_EL0
+Field	35	AMEVTYPER18_EL0
+Field	34	AMEVCNTR18_EL0
+Field	33	AMEVTYPER17_EL0
+Field	32	AMEVCNTR17_EL0
+Field	31	AMEVTYPER16_EL0
+Field	30	AMEVCNTR16_EL0
+Field	29	AMEVTYPER15_EL0
+Field	28	AMEVCNTR15_EL0
+Field	27	AMEVTYPER14_EL0
+Field	26	AMEVCNTR14_EL0
+Field	25	AMEVTYPER13_EL0
+Field	24	AMEVCNTR13_EL0
+Field	23	AMEVTYPER12_EL0
+Field	22	AMEVCNTR12_EL0
+Field	21	AMEVTYPER11_EL0
+Field	20	AMEVCNTR11_EL0
+Field	19	AMEVTYPER10_EL0
+Field	18	AMEVCNTR10_EL0
+Field	17	AMCNTEN1
+Res0	16:5
+Field	4	AMEVCNTR03_EL0
+Field	3	AMEVCNTR02_EL0
+Field	2	AMEVCNTR01_EL0
+Field	1	AMEVCNTR00_EL0
+Field	0	AMCNTEN0
+EndSysreg
+
 Sysreg	ZCR_EL2	3	4	1	2	0
 Fields	ZCR_ELx
 EndSysreg
-- 
2.43.0.rc2.451.g8631bc7472-goog

