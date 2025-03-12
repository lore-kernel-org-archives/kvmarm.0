Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B936E242934
	for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 11:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741780586; cv=none; b=Esi+6eaRgk3gd/r1At6zi/BHbRBNYZLjHfAetggZsw95Vh/VxBejARhmZYa8OtWBOvsR1talooCsj/zvRDf45voYM5WaBKTCNmBiTdROKEpN1JwVZsdBTcVR9qi5ud7gnIhZVblFEoQOy/cdBwscHmX+CCQdsepzHJJcDNuU3RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741780586; c=relaxed/simple;
	bh=T5ZrCuiwP99CKRJiyuMFvbhV9YXqT9moZhal0ysaEVQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=R8WwGonIyXO6cFVoMHpdg6pxCgtejbyX7g63il2baAvf5O45jZVOFVJ7Wx4fxLEGvQvs18EKNGyDlKBHzTkd9zSw0bUgOIhKAx0ojKA1NtsRykVFF6+5StpP5VHwpFjRRqPPIPp4bB11CrcoY/JKYsMTL49aI9YUBZsji8DIWOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=a7FEQ/Cl; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="a7FEQ/Cl"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-225a28a511eso25385385ad.1
        for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 04:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1741780584; x=1742385384; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LSsGsr3kAuFxcrtpSfRGA99t0k+DUOp8ehJUjKxyPeQ=;
        b=a7FEQ/ClKhIlxAzSKph3CAdDU68N8TH1DR++N8/AeQChKlF3I2bh/69T8jt/03tpcf
         QixIo3CiiX3zKpu4zux1Y42Jex0mUBaMPIDPD++Cb76Vh2HMxYhNYDi7H9C7TXXPTLsH
         0o3yLWrAX9E45X+i1+hGKZ04he0hqIoq80xT4NWlBeWFvcld7y5rpFalbuUyLcVJUR1x
         iPUeo5AvsxUN65jtSEClayHD8fjjBsXbYSEkem2C7I1TP8wZ0V9j7b9NNTybFeUb3Wfq
         1mrbOSL80f23Hxg/G5G2+G6WC6htZxKYARZUlQ6vIMSifYaNEq8otfcmJ2ePelnCkp4X
         a0Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741780584; x=1742385384;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LSsGsr3kAuFxcrtpSfRGA99t0k+DUOp8ehJUjKxyPeQ=;
        b=d+SHjazjX4J9/Q9tHozjUYmyV2O3nAzOpde5tjfO+pZZyHkDkGu5JWgFt/M3XCN1YP
         ZqTJvI5H4CYrpEUrZYlY+tReGrXAXGAVYxs93sFenpZHeiUnrqT40rsy3ohC4FImJHaN
         0r++60wEgcC7Y0ahaXfDqIit9bsriKIw+GYTa0e93ZPjUr+p0JYair8gpB8povIONWL8
         eY0KMA/KILN7rnzXPW5Zmk1MLtqh2VkrGrVAJVQWe9aRRCoYPkT7LOJzFW8XmrLTppUn
         XScyaPdsDOEcAj452Y0Ap4inshYnxbQEFRKTltqYRh8PQw0EyIIJaXt9wfVVkO4fVJRd
         ePMg==
X-Forwarded-Encrypted: i=1; AJvYcCUQccO3GruKL8ohnyqIRVYEMMrXpc6ewDTX5dGQftGMH4RlEr46bafRmw6wxB3bzSaXDW2n/Z4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzlDVgu4V+Ohe6YyKoIV4dlWI3vBKY8LBsuqx16nevAFCJxKB8D
	6CRuuf7lL3Cb+OStF2ZTYVMKj2IOjmf7JrpoXkqMwWlBV9AqAHvProAKIX3xEKA=
X-Gm-Gg: ASbGnct1WMQzxxlHpHwxqQeV7ul8eqitqeDb2MyV6DKsOwOPfFX3ltKsfBAhF9fgpdO
	mtB4lSGU68RuiD3xHE5+IQn8jIMWFATTm7Dijpuytvmgm5lRUZZlQRiUAIAgLbYRe1O+7fk6/KR
	qyMTUiNXgNaMu5trr7nY35R1TR7oeWxL9TM3z6VjEPJGeM703FqwO10sc4u2zVaKZKHDe8FjMUA
	QKi3RAgHxuEnBwfnYnV+zdciUUWqiqgvpZvKTW63LWOijFZZNRAfbSQCzcEnMJCsGwN8lmjaXwM
	7SCt079AfwouNTJg0o1NIoFjAgmLtPdqcpabUovCiNtvI/E5rTGWubP7EA0=
X-Google-Smtp-Source: AGHT+IEySYB2KOvAVkEbdUGCk7PaLmynA5DtA3ifevnpQFe/NSoQ7IgcTUmRgz4PK00aGrJKKcPhDQ==
X-Received: by 2002:a05:6a00:8e09:b0:736:ff65:3fcc with SMTP id d2e1a72fcca58-736ff65443emr3402126b3a.16.1741780584028;
        Wed, 12 Mar 2025 04:56:24 -0700 (PDT)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-736b7bb0bf2sm9336341b3a.42.2025.03.12.04.56.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Mar 2025 04:56:23 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Wed, 12 Mar 2025 20:55:57 +0900
Subject: [PATCH v3 3/6] KVM: arm64: PMU: Fix SET_ONE_REG for vPMC regs
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250312-pmc-v3-3-0411cab5dc3d@daynix.com>
References: <20250312-pmc-v3-0-0411cab5dc3d@daynix.com>
In-Reply-To: <20250312-pmc-v3-0-0411cab5dc3d@daynix.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Andrew Jones <drjones@redhat.com>, Shannon Zhao <shannon.zhao@linaro.org>
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
index 3e5bf414447f..1cfe53b6353e 100644
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

