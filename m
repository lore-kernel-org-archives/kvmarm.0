Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6511FC102
	for <kvmarm@lists.linux.dev>; Thu, 13 Mar 2025 06:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741849092; cv=none; b=SVAQZO+i+Zxx16pL1ex65k79VQbx8Ef0Yib/P5r1ghzyzfcaS/ti4Lw/bB4uoiE+eEPUKXKZ/xy7LIAPgkjMXPSlL6lH9HUDcbn3WRca00z0TwZj4NnD39pBmiso4jZf7PYYxSaYdjF+TdNT798+Uk4J8QmSHVcMOFrcLHhltIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741849092; c=relaxed/simple;
	bh=IJXHD7sx8FOQ/TCbz0hTrjmBv+Lvr54IEhabSGoOnKU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UPY9HsobV+yXC2GeyTcCIIbQwyw4e1OKAQJkmweUlAUA2/77jqn6tDzpwU3V7+JkvYXjVE/r5jyH9Lz/gx4ba3knp1GSOoLk0Z2G/RsHNuFN2pREopGVBdWh7T1DSJvgA1WmKCdgZ6mY/C+8KoGQm+egzQKhkLKwp04c2Dns8qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=Qfmi8bo5; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="Qfmi8bo5"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-223f4c06e9fso11001765ad.1
        for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 23:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1741849090; x=1742453890; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i6iz2Tb4ku//H3AxfAexQ9B2Bw11aMopngIm2weGw1M=;
        b=Qfmi8bo5dpthF/0buMzs0OnfeAWAktRzzotbTJDaxydzOgaEv17U1Jc6fHxIooxw+k
         9mlIvZsre67GJrq20AqVmgcB3jiWwrxWylZa3E1JsXTASu0tZl7MouZ9QarXLccur7Dq
         JtOpZBKQVChBdS0vA3YmrrEXE1U4jHMySu+90vK2o9vOctYUjgiOQyFPflYrBN0O5ZeQ
         H3P/mVwa0pS0rrrQVHeupUwbRAk7d8sAPfIGXlubSNtSN8HbfANlQRIAr/dmXhSQGutu
         RnW6voDJ7gaig8wDLnxScYUYEFGxUnfNTeTJNZCGY0W3YMUC5UWEvlnzPLtw4ot8KmZO
         lxIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741849090; x=1742453890;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i6iz2Tb4ku//H3AxfAexQ9B2Bw11aMopngIm2weGw1M=;
        b=AYZpkSkJQ4zR7cyH0pLNuZDWQk908DVXpfQ+ktNKBrvZ7Ux2KNyNX68H+P0dyPAf2P
         t2D5kSPhK/d2MpTYGycyQ8hAM1Udt93dI5zfTho17+FdBAstt/SX/2DJMMoR42ep4Ou5
         v29r1iJmKKPMLYQGtXYmk9qQzdGHqUaMLs9rPy/8HbINHELY/h3JYOEhl9hLP/yr2CME
         ZePPaOXh+56Dclr0ns7Ar2bJ/Wx2V1ztiWdxybmXtZun7r2Lk1aWjbXe0vjCm5uV8NBJ
         1/xZsQqTIfm3Bd49Ij2BkEgS/nVmfX/PFh/VmRhSG/TQFioLjl4sKZE+l361ihMWcmSG
         rQmA==
X-Forwarded-Encrypted: i=1; AJvYcCUeqp0wecbOOf87DA9BnVsAumz6Zb53cr9/C9i08GUo0TMUGDtLbtDs49XaM8xuc9C7C5FCVKA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yydc5ymd5TK8naB1XE5l0riQ23K2TXSOSWeOCkNtdNWkBpy+MfG
	0/a4Jhyri+Jk8mDoFTtJSV0l5y9zWM6rGxx1Np5+qUwS+ltngWnG3F8Urt/iq3Y=
X-Gm-Gg: ASbGncuS/OhNGMzRVhZ1sU2Y4FdXN56D0xRhDJBKJJ689anu+ixstB+z/wom4On99I9
	3DnLYzVi3Qn4ZVHye4rOm6HTDGkV10/7611ildZ3BY2MPFcmZQ1cdNBUm8zm3/2zma9xk+HBHrv
	+dcl9EgmGZlS+fKe/JpCjqPlh+ebqUwpZBeQvxrfbKOMMchj2hCd5+H4xjB1VEA84H37bbC7YdF
	tQFYxtJdyyRC7ol32WlL671AdY+Szv8ZR/v8pIo6zghaodoM9RKIbL/XvvJfezUPgvPCsDxlaMj
	G4SMlqGM9ndsmtkvvY6ZfCTuSI3wbkNyyJqj2s1fEvEo9NhW
X-Google-Smtp-Source: AGHT+IE5NpWqZ+PooCqPvK48p4HWbGtSfd6lTwIKoKKHaXf2OMgXMo53qPDLD1AgcAjnRYmc4YTHGw==
X-Received: by 2002:a17:902:d2c6:b0:215:742e:5cff with SMTP id d9443c01a7336-225c6672ca0mr23251545ad.16.1741849090214;
        Wed, 12 Mar 2025 23:58:10 -0700 (PDT)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-225c6bbe960sm6398075ad.200.2025.03.12.23.58.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Mar 2025 23:58:09 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Thu, 13 Mar 2025 15:57:44 +0900
Subject: [PATCH v4 3/7] KVM: arm64: PMU: Fix SET_ONE_REG for vPMC regs
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250313-pmc-v4-3-2c976827118c@daynix.com>
References: <20250313-pmc-v4-0-2c976827118c@daynix.com>
In-Reply-To: <20250313-pmc-v4-0-2c976827118c@daynix.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Andrew Jones <andrew.jones@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, devel@daynix.com, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.15-dev-edae6

Reload the perf event when setting the vPMU counter (vPMC) registers
(PMCCNTR_EL0 and PMEVCNTR<n>_EL0). This is a change corresponding to
commit 9228b26194d1 ("KVM: arm64: PMU: Fix GET_ONE_REG
for vPMC regs to return the current value") but for SET_ONE_REG.

Values of vPMC registers are saved in sysreg files on certain occasions.
These saved values don't represent the current values of the vPMC
registers if the perf events for the vPMCs count events after the save.
The current values of those registers are the sum of the sysreg file
value and the current perf event counter value.  But, when userspace
writes those registers (using KVM_SET_ONE_REG), KVM only updates the
sysreg file value and leaves the current perf event counter value as is.

It is also important to keep the correct state even if userspace writes
them after first run, specifically when debugging Windows on QEMU with
GDB; QEMU tries to write back all visible registers when resuming the VM
execution with GDB, corrupting the PMU state. Windows always uses the
PMU so this can cause adverse effects on that particular OS.

Fix this by releasing the current perf event and trigger recreating one
with KVM_REQ_RELOAD_PMU.

Fixes: 051ff581ce70 ("arm64: KVM: Add access handler for event counter register")
Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 arch/arm64/kvm/pmu-emul.c | 13 +++++++++++++
 arch/arm64/kvm/sys_regs.c | 20 +++++++++++++++++++-
 include/kvm/arm_pmu.h     |  1 +
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 3dd0b479c6fd..1b91e5188d52 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -185,6 +185,19 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
 	kvm_pmu_set_pmc_value(kvm_vcpu_idx_to_pmc(vcpu, select_idx), val, false);
 }
 
+/**
+ * kvm_pmu_set_counter_value_user - set PMU counter value from user
+ * @vcpu: The vcpu pointer
+ * @select_idx: The counter index
+ * @val: The counter value
+ */
+void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
+{
+	kvm_pmu_release_perf_event(kvm_vcpu_idx_to_pmc(vcpu, select_idx));
+	__vcpu_sys_reg(vcpu, counter_index_to_reg(select_idx)) = val;
+	kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
+}
+
 /**
  * kvm_pmu_release_perf_event - remove the perf event
  * @pmc: The PMU counter pointer
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6e75557bea1d..26182cae4ac7 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1035,6 +1035,22 @@ static int get_pmu_evcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	return 0;
 }
 
+static int set_pmu_evcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+			  u64 val)
+{
+	u64 idx;
+
+	if (r->CRn == 9 && r->CRm == 13 && r->Op2 == 0)
+		/* PMCCNTR_EL0 */
+		idx = ARMV8_PMU_CYCLE_IDX;
+	else
+		/* PMEVCNTRn_EL0 */
+		idx = ((r->CRm & 3) << 3) | (r->Op2 & 7);
+
+	kvm_pmu_set_counter_value_user(vcpu, idx, val);
+	return 0;
+}
+
 static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 			      struct sys_reg_params *p,
 			      const struct sys_reg_desc *r)
@@ -1309,6 +1325,7 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 #define PMU_PMEVCNTR_EL0(n)						\
 	{ PMU_SYS_REG(PMEVCNTRn_EL0(n)),				\
 	  .reset = reset_pmevcntr, .get_user = get_pmu_evcntr,		\
+	  .set_user = set_pmu_evcntr,					\
 	  .access = access_pmu_evcntr, .reg = (PMEVCNTR0_EL0 + n), }
 
 /* Macro to expand the PMEVTYPERn_EL0 register */
@@ -2665,7 +2682,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .access = access_pmceid, .reset = NULL },
 	{ PMU_SYS_REG(PMCCNTR_EL0),
 	  .access = access_pmu_evcntr, .reset = reset_unknown,
-	  .reg = PMCCNTR_EL0, .get_user = get_pmu_evcntr},
+	  .reg = PMCCNTR_EL0, .get_user = get_pmu_evcntr,
+	  .set_user = set_pmu_evcntr },
 	{ PMU_SYS_REG(PMXEVTYPER_EL0),
 	  .access = access_pmu_evtyper, .reset = NULL },
 	{ PMU_SYS_REG(PMXEVCNTR_EL0),
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 28b380ad8dfa..9c062756ebfa 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -41,6 +41,7 @@ bool kvm_supports_guest_pmuv3(void);
 #define kvm_arm_pmu_irq_initialized(v)	((v)->arch.pmu.irq_num >= VGIC_NR_SGIS)
 u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
 void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val);
+void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu, u64 select_idx, u64 val);
 u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu);
 u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1);
 void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu);

-- 
2.48.1

