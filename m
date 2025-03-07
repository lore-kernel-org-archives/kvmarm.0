Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E066B211A07
	for <kvmarm@lists.linux.dev>; Fri,  7 Mar 2025 10:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741344940; cv=none; b=RIFtiy8+fY49MBAnqWmbHLgpHH4PVPzgU/tYf/26rIca78MfXSDXeNzO2RXqDOR3o3ZfSbhMUQLyISmS84JYgzSRJmSP+cXT7mBGO3EaBYmClU2Ju0d3ihTRfrYJ3WYAPjtnk9m921HrBDRyQg+7veUYbn66dHiHf26b2M0tM94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741344940; c=relaxed/simple;
	bh=CtDw6xTemlzhoe3Mf/ikMlb2drvcCXVf6yE4VYRuHlU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=j+uiAQ4QdK2zqd8tL/Z09Cre+OcZAVQfWzF1lNcPtwzRwdXZFQaLAWzI/sa79RySvbis/9ymOfckDCTjxfv7cefGMf2+0r4AJZzhGwIGumGSMmyjqqbRbQiHAJBHUz+CDaR8ZZSc+c4WYc9Nt/m3Fva9meb7iEPdBNZHeC9R/mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=lbqcnq4y; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="lbqcnq4y"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2232aead377so33332805ad.0
        for <kvmarm@lists.linux.dev>; Fri, 07 Mar 2025 02:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1741344938; x=1741949738; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i1Rms3TAKvJ0DWAIQahRYenmqeYz1Pw9/up2OrK8qe4=;
        b=lbqcnq4ykr3bzTQX6n85aGWlS0q+GpCMnYPLWcYfq1SG3a2Fao9gZOaFHW8VLX627E
         dCPZ65kKXXISf8a67VBlvQYHbGDOkhOPXxaojFFSfn//oaNpb637QN3gJ4cLr6emcDx6
         zUtYWi2SIXEWkctyCjr4yqyYdcdKF7RK2w35zNG+r72+jgv+niTO1JZkfhPS5mCUtv0U
         qsZve+2XfOETt7RiukCKNYqXYyv3lNX3bIlrNdS+N0MK77EkSPBeyLdigJekrkwycQYJ
         25dN7uLCCth41CZm/p7HByTlyivenBhFHuChj3uXNyCjJoAYZUSz63c4xfOgYCpaUY8Y
         tLcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741344938; x=1741949738;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i1Rms3TAKvJ0DWAIQahRYenmqeYz1Pw9/up2OrK8qe4=;
        b=dGw2RWs4jLi8Wu19GBOP+5V468GwUa+Z34CRfvZy89CP5fAICRtmu9uPXUaKhTRrFB
         Ju2dG6PWEBV7i3LF87uqXIDhdtqNolcB/n7eor7T7JyvFOW1KcPg/W6LHSo8FpN3xIS5
         vFZ6SExLSvwC4NKzO77IMX9UAYh021xjf8yAbCT8+xHeW39SOYKqnl87nt2A6q7CUNhx
         kx81ia2zFwNfx31IS1P+8hVmuRbv7OWSvMl9GAPLCr9G8g2fRkeYZcdbq1hLeRIqmEQx
         yDUpfk/4oJqYZHIrkD0y2tyVvS/Nju3gjZR7Lmxp2RNdJBTGtSGviwWEMjms1m/5HFu2
         KRmw==
X-Forwarded-Encrypted: i=1; AJvYcCWRalgKU1+luDOVWGIjZU1vZ2f3jxeArVCjSNRqJRslaicLKltpuWPilPmLwPpVLM/cRxqPcIc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy0/taW9qeaQTMIEKlaWPiIZnOTunpvjDTAO2qj/Sc2P1rjCdCg
	byOghkwJN3z5aiJdQ3kRZZ9f2xffkJN64nS6bHnpw/WwBvAD5YSXGhedTngJ2UE=
X-Gm-Gg: ASbGncuHEcQ1LAJ1ZhqXu5CyhczauOvwIAVnfB+N5Kzn+l7iqX/B2+5T9u5F4tuXFBq
	5JIV7S6hIaVHy5Z1a8v2gSne2DaEUMuZ1Br0KZg/hBUkRrLRyh1AYhs+NcMy3X6qO8+734NTwvR
	GBLJrhYCTLMsYnxut4WO/EOBjaENltt2993+BxGwaPBU2t6oe5tWet6FvbnoAN6hs0nx2C4jEch
	hNIzHWY9OIJp27K/2L/owJFXCkVJFMWQt3cFeJmtYcWgoIGrS8qsckr2Gl0vaplXjaPBVI7Diar
	t7qlhY5jV1z2pIY10AmyhyUFjGAb54exhP6THaDd7BQFg9Y0
X-Google-Smtp-Source: AGHT+IHp21Tz3W1NVSkiBkXo05zCKdRXsyhKUTTj6kvZ1eTKmFZGZ/WkqB5Jrack/mZQWt+UsvaCdA==
X-Received: by 2002:a17:902:e80a:b0:224:13a4:d61e with SMTP id d9443c01a7336-22428c0a43bmr38314595ad.51.1741344938150;
        Fri, 07 Mar 2025 02:55:38 -0800 (PST)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-22410a908a0sm27232235ad.162.2025.03.07.02.55.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 02:55:37 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Fri, 07 Mar 2025 19:55:28 +0900
Subject: [PATCH v2 1/3] KVM: arm64: PMU: Fix SET_ONE_REG for vPMC regs
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250307-pmc-v2-1-6c3375a5f1e4@daynix.com>
References: <20250307-pmc-v2-0-6c3375a5f1e4@daynix.com>
In-Reply-To: <20250307-pmc-v2-0-6c3375a5f1e4@daynix.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Andrew Jones <drjones@redhat.com>, Shannon Zhao <shannon.zhao@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, devel@daynix.com, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.14.2

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

Fix this by releasing the current perf event and trigger recreating one
with KVM_REQ_RELOAD_PMU.

Fixes: 051ff581ce70 ("arm64: KVM: Add access handler for event counter register")
Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 arch/arm64/kvm/pmu-emul.c | 16 ++++++++++++++++
 arch/arm64/kvm/sys_regs.c | 20 +++++++++++++++++++-
 include/kvm/arm_pmu.h     |  1 +
 3 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index e3e82b66e2268d37d5e2630e47ddf085a6846e1c..1402cce5625bffa706aabe5e6121d1f3817a0aaf 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -191,6 +191,22 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
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
+	if (!kvm_vcpu_has_pmu(vcpu))
+		return;
+
+	kvm_pmu_release_perf_event(kvm_vcpu_idx_to_pmc(vcpu, select_idx));
+	__vcpu_sys_reg(vcpu, counter_index_to_reg(select_idx)) = val;
+	kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
+}
+
 /**
  * kvm_pmu_release_perf_event - remove the perf event
  * @pmc: The PMU counter pointer
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 42791971f75887796afab905cc12f49fead39e10..27418dac791df9a89124f867879e899db175e506 100644
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
@@ -1328,6 +1344,7 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 #define PMU_PMEVCNTR_EL0(n)						\
 	{ PMU_SYS_REG(PMEVCNTRn_EL0(n)),				\
 	  .reset = reset_pmevcntr, .get_user = get_pmu_evcntr,		\
+	  .set_user = set_pmu_evcntr,					\
 	  .access = access_pmu_evcntr, .reg = (PMEVCNTR0_EL0 + n), }
 
 /* Macro to expand the PMEVTYPERn_EL0 register */
@@ -2682,7 +2699,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
index 28b380ad8dfa942c4275e0c7ed3535d309b81b2f..9c062756ebfad5ea555362154459ffe9f8311c6d 100644
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

