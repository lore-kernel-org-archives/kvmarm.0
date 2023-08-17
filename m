Received: from mail-oa1-f74.google.com (mail-oa1-f74.google.com [209.85.160.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B190712B7E
	for <kvmarm@lists.linux.dev>; Thu, 17 Aug 2023 00:30:40 +0000 (UTC)
Received: by mail-oa1-f74.google.com with SMTP id 586e51a60fabf-1c4c8010715so5068321fac.0
        for <kvmarm@lists.linux.dev>; Wed, 16 Aug 2023 17:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692232239; x=1692837039;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RZwROTfypdAjyAUBEkppwBtRWVB6YQ3Zf4TY7/KQaqk=;
        b=0Rd8XNXiQiYFczCHCXlKHlffpcm+W2wITe8hsUM/uxiJ/HKRNbM6ChEABNuKQllQEI
         DjmXL8hn1f3rT929hWMvLGKqKrLKcUEAAnPfs+2ciErlusjhqjl7B28Ow8xPXj3tLx2R
         TXI2OcbUtBuSC9EugpcAfs0oWIgODoZzjrfWlfuHS45y1VNVFXmesWVMRrm3uuU570YY
         hSwib+KkPQRz8ZHU3MyPH15qacLEd7x7enkpB1mywj3sBClCQesAwrbiNEpFkcI4jrUF
         O9yNo6HBGlhZ0uX+5Rkz+rRmIa/s4c3z1+vL11q5LxTOAKGr9qFe3FIArKy3KMkLdDCK
         FaRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692232239; x=1692837039;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RZwROTfypdAjyAUBEkppwBtRWVB6YQ3Zf4TY7/KQaqk=;
        b=V7zXLCxPQcvS+r/dHErOzPl+jtd8dB/aM0TDvOZBA95kECxFwxit9RZ6h+/yllHXqE
         2jBnXSjWhF5610X6i5+O1iqpkbCh4YPLCnmxahyxnKN2U0IfJ6pSpU4+dPoXRrQXlQn3
         eAqGMsJTKYyk/q6/sYYGIueWEM7/pN0AX5R5y/XJlmYNbQR/sDXPuPmyRFfXU79hBXbz
         R26+2wGyH3+Co3f9hQzJ2gzZsWjaazz1wOpwLrSEh/SdQvUX+RC83eqcb9yxA4BDJOOf
         x+TeFawQtcVGlij84zCFDROmkmE79AmPFpbSD9xkotDYZio4bMg1S59rdIJrgxm34BBH
         JoRg==
X-Gm-Message-State: AOJu0Yy/mTQgJc0X53ymSxltvwzca7j6Bu2cmW49QQY4f9gWNbFSr3/I
	GDGozLD5dr4/XtSDn++UIHtdTD2PcDxl
X-Google-Smtp-Source: AGHT+IEivFY9QQDx3QmUGiM1VRwGeePX6csw/PBzVWQ3N230MRxCTWjuemsW6hfUCviQt4Xy2/6rcaw0zaFQ
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6870:5aaa:b0:1c0:fa9d:8fd8 with SMTP
 id dt42-20020a0568705aaa00b001c0fa9d8fd8mr64168oab.1.1692232239826; Wed, 16
 Aug 2023 17:30:39 -0700 (PDT)
Date: Thu, 17 Aug 2023 00:30:24 +0000
In-Reply-To: <20230817003029.3073210-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230817003029.3073210-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230817003029.3073210-8-rananta@google.com>
Subject: [PATCH v5 07/12] KVM: arm64: PMU: Set PMCR_EL0.N for vCPU based on
 the associated PMU
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Reiji Watanabe <reijiw@google.com>

The number of PMU event counters is indicated in PMCR_EL0.N.
For a vCPU with PMUv3 configured, the value is set to the same
value as the current PE on every vCPU reset.  Unless the vCPU is
pinned to PEs that has the PMU associated to the guest from the
initial vCPU reset, the value might be different from the PMU's
PMCR_EL0.N on heterogeneous PMU systems.

Fix this by setting the vCPU's PMCR_EL0.N to the PMU's PMCR_EL0.N
value. Track the PMCR_EL0.N per guest, as only one PMU can be set
for the guest (PMCR_EL0.N must be the same for all vCPUs of the
guest), and it is convenient for updating the value.

KVM does not yet support userspace modifying PMCR_EL0.N.
The following patch will add support for that.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/pmu-emul.c         | 14 +++++++++++++-
 arch/arm64/kvm/sys_regs.c         | 15 +++++++++------
 3 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d3dd05bbfe23f..0f2dbbe8f6a7e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -256,6 +256,9 @@ struct kvm_arch {
 
 	cpumask_var_t supported_cpus;
 
+	/* PMCR_EL0.N value for the guest */
+	u8 pmcr_n;
+
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
 	struct maple_tree smccc_filter;
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 42b88b1a901f9..ce7de6bbdc967 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -681,6 +681,9 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
 	if (!entry)
 		goto out_unlock;
 
+	WARN_ON((pmu->num_events <= 0) ||
+		(pmu->num_events > ARMV8_PMU_MAX_COUNTERS));
+
 	entry->arm_pmu = pmu;
 	list_add_tail(&entry->entry, &arm_pmus);
 
@@ -887,6 +890,13 @@ int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
 
 	kvm->arch.arm_pmu = arm_pmu;
 
+	/*
+	 * Both the num_events and PMCR_EL0.N indicates the number of
+	 * PMU event counters, but the former includes the cycle counter
+	 * while the latter does not.
+	 */
+	kvm->arch.pmcr_n = arm_pmu->num_events - 1;
+
 	return 0;
 }
 
@@ -1072,5 +1082,7 @@ u8 kvm_arm_pmu_get_pmuver_limit(void)
 
 u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
 {
-	return __vcpu_sys_reg(vcpu, PMCR_EL0);
+	u64 pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0) & ~ARMV8_PMU_PMCR_N;
+
+	return pmcr | ((u64)vcpu->kvm->arch.pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index cf4981e2c153b..2075901356c5b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -745,12 +745,8 @@ static u64 reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 pmcr;
 
-	/* No PMU available, PMCR_EL0 may UNDEF... */
-	if (!kvm_arm_support_pmu_v3())
-		return 0;
-
 	/* Only preserve PMCR_EL0.N, and reset the rest to 0 */
-	pmcr = read_sysreg(pmcr_el0) & ARMV8_PMU_PMCR_N;
+	pmcr = kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_N;
 	if (!kvm_supports_32bit_el0())
 		pmcr |= ARMV8_PMU_PMCR_LC;
 
@@ -1083,6 +1079,13 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static int get_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+		    u64 *val)
+{
+	*val = kvm_vcpu_read_pmcr(vcpu);
+	return 0;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	{ SYS_DESC(SYS_DBGBVRn_EL1(n)),					\
@@ -2145,7 +2148,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_SVCR), undef_access },
 
 	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr,
-	  .reset = reset_pmcr, .reg = PMCR_EL0 },
+	  .reset = reset_pmcr, .reg = PMCR_EL0, .get_user = get_pmcr },
 	{ PMU_SYS_REG(PMCNTENSET_EL0),
 	  .access = access_pmcnten, .reg = PMCNTENSET_EL0 },
 	{ PMU_SYS_REG(PMCNTENCLR_EL0),
-- 
2.41.0.694.ge786442a9b-goog

