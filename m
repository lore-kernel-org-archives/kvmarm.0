Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB791F4611
	for <kvmarm@lists.linux.dev>; Sat, 15 Mar 2025 09:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742029979; cv=none; b=PEjy8ALhupGMbjCuHmk2w9Vk1p4czqdlMTF2CeX0LaHcsHqJqmCoc43LavXX4Bxxlg+aMp6njYmjweyd7diw7ZljlUsAxogq/+1Y/EtWerLaehdq3vk9S2bcSbVLVeQomN4T7eazx0wbrds5UwHhX9sZtX5U52TKbDinZLsfRRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742029979; c=relaxed/simple;
	bh=55NhlBArV0bxMhOMhIHB8X/BAl2ygANfTR+Wz8xFj8s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RH2x9Ka26kRq6errA5Oxjw3j5hohO4aj5KNlp/lbG0xTe+78nJFWCa+mYewYd2CcmJNLOXvneh1S+IxxfzhARlgnE1N7tYhPxdnLzWw6OrxP9d2gCH4UL38+28jCxB8qiXWwXcXUUu2VVQZK6WUGuAx9o8SLc+UsJxP0HXz8TMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=SSQoAFbR; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="SSQoAFbR"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2f9d3d0f55dso809773a91.1
        for <kvmarm@lists.linux.dev>; Sat, 15 Mar 2025 02:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1742029976; x=1742634776; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z45wX6sTn0j+WP194BbrDZyhFp7C/BntrOrXCNO4tBM=;
        b=SSQoAFbRfne4bk+sKjCeyPho9kVq2PCAOjutHgs6elButFlovKVgvCE1HP067R0t0n
         lq9W1ERNW8+lmyMb/Ml+RFL8bSV8J9RP+KbD8v4lDUCPN4uftU6vVhYsioK04LuQPsFX
         U76A9Arvtpa48qw8KqO/xi3bgZa9m1qury4qM6iRvbvxf4Qt3txR58iGHAvzQB0l1CVK
         dvcDSU7bBPDJIiUMBNs+1r7oGRa+vEq6K0c679UyXRdYFDMTEs3MAuxztsx0gULS2CXc
         ATBS78PYMcQzOVIUne4erZLtiIDmMuAW1jkJ9+XvaLH8jq9yh3Fi7GzsdCZWjk2YFYua
         tk4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742029976; x=1742634776;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z45wX6sTn0j+WP194BbrDZyhFp7C/BntrOrXCNO4tBM=;
        b=SamPzhKytonP7ey1XWA49qtD0rqtX5LCatFfz1UqOjom1qwapa6qtIydmFIDWIPB7d
         tc02TQyqVpJx12MkYyR7t607k71u91sD2liqM5Uz1DQkpoJdfQt6QomRUFgAtCKZz2hV
         OUeuZZJn4bmw30QxUSFhPyWOwBAGbKBOgH1wrEdhVEk19Lvu+UZZX2r29ifP2pT/wIze
         aSKoioGmuUZA+inMMEN8uNwkGg8Zg67Y2n+n4pg/mnxGe/UOzHpWAr5YC/NH7LEYmSFc
         AC9utQ6sMZHF+yhAGpoh1sp9bRLYhg0WopY6FdEplyuZhbJ0k6GyNd4xZ91BZ0s6j0Ad
         pn2Q==
X-Forwarded-Encrypted: i=1; AJvYcCX/svC6GSfXy3eBg4aPlPZsgQxttvB5roLCLK95wN7FJoEoVuh52mQbeSsAFF+RBj86eRJxOB0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6PrGBkIMjIHsaz4Cz3JWtu5jIO1IwcZOmGn/5myMTPfHpjKlt
	axl/nRInJNu7XpV5jW2cpSFcZi155cH7q8sWT5fFot+KfKJhtg2SKELJl2WXnYw=
X-Gm-Gg: ASbGncvDud0wRO14PkaMU1HIVGa/t8qpajCy0cxnXYPPEySwmjWtCSDXAAxhWeKekTA
	EFXXxyfmHYIIeKuo6jOMrXB6v8tDoeSG5Ekt0FuUxWRYz0Ct8DuuMCimvg9LPvfGRE9jLgO6Ulr
	WqFEEGbWyD8ffmL/CLOiZ4ASrViScJ6gTMvZBfkzsjP7QMH62M0N2UFADlbpltc7TjbWRwWfY86
	K29kALOp1YmYIaTltzZR1k28tbzzs99g9iU2acHvBukJSiJxnFIXMHe0iTb/89Qwy8a0bGXJXK1
	KkV0loOyIAn/VT6CRjIft7VZZy+y54PouIEMION/A1GfXJe8
X-Google-Smtp-Source: AGHT+IFM01ujgQGmxWWrZqVb8b6dOpUickjIAuSWkmx+lJTnPzesouNeLYIaUrB/yeU1KLg5VJSBcQ==
X-Received: by 2002:a05:6a20:2d08:b0:1f3:1d13:96b3 with SMTP id adf61e73a8af0-1f5c1132fcfmr7792054637.5.1742029976132;
        Sat, 15 Mar 2025 02:12:56 -0700 (PDT)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id 41be03b00d2f7-af56ea7c7ffsm3280291a12.55.2025.03.15.02.12.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Mar 2025 02:12:55 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Sat, 15 Mar 2025 18:12:12 +0900
Subject: [PATCH v5 3/5] KVM: arm64: PMU: Fix SET_ONE_REG for vPMC regs
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250315-pmc-v5-3-ecee87dab216@daynix.com>
References: <20250315-pmc-v5-0-ecee87dab216@daynix.com>
In-Reply-To: <20250315-pmc-v5-0-ecee87dab216@daynix.com>
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
 include/kvm/arm_pmu.h     |  2 ++
 3 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 98fdc65f5b24..593216bc14f0 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -191,6 +191,19 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
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
index e8e9c781a929..4d1ef47d0049 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -960,6 +960,22 @@ static int get_pmu_evcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
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
@@ -1238,6 +1254,7 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 #define PMU_PMEVCNTR_EL0(n)						\
 	{ PMU_SYS_REG(PMEVCNTRn_EL0(n)),				\
 	  .reset = reset_pmevcntr, .get_user = get_pmu_evcntr,		\
+	  .set_user = set_pmu_evcntr,					\
 	  .access = access_pmu_evcntr, .reg = (PMEVCNTR0_EL0 + n), }
 
 /* Macro to expand the PMEVTYPERn_EL0 register */
@@ -2835,7 +2852,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
index 147bd3ee4f7b..b6d0a682505d 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -47,8 +47,10 @@ static __always_inline bool kvm_arm_support_pmu_v3(void)
 #define kvm_arm_pmu_irq_initialized(v)	((v)->arch.pmu.irq_num >= VGIC_NR_SGIS)
 u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
 void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val);
+void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu, u64 select_idx, u64 val);
 u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu);
 u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu);
+u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu);
 u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1);
 void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu);
 void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu);

-- 
2.48.1

