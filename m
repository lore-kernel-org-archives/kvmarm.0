Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A44910E6
	for <kvmarm@lists.linux.dev>; Fri,  3 Feb 2023 04:23:32 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id p202-20020a25d8d3000000b00858a2a2cc15so3788193ybg.21
        for <kvmarm@lists.linux.dev>; Thu, 02 Feb 2023 20:23:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ninu9t9khJ537NvgTgh0SdQwYTtXrvr6XzPdAKmZIas=;
        b=WGULXC2QPAXoA4h/oZtvz4aNUv7DSZK/ONRwUzYMLoP592X5Q/E5BRHxp8BZknpYPN
         LzOXTwfE6GzZQGgHClpFJRrZhq045B6jl+4uEW47EBEwllRae/x20XHGSfIwsFgEIAGm
         d64MX2ffTMJhoe0WZ+aI7TgEAog8Wl5c9qRgrSi10MTuB/XB+8uE4i4LIoi5jUR5prr1
         iy9I3E3C9k/b4bBdV/7HJ1dsPZRFGJ6TgI08LOJrnPjN0ThtqnfW7ZT1p1Rgfw8X3+dK
         2x9BELzDb6a+DzDiAFthgvIm8O+pp082VhQ5HGdkc0PXFzr4/jnRRClSvgOIZq98t6GA
         esPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ninu9t9khJ537NvgTgh0SdQwYTtXrvr6XzPdAKmZIas=;
        b=YUNL08EiF36+Nn8bwuDT9fz3u2C8puaYRpSe5mcgDVMYRx0LyA6oirZCdKimgO/e+K
         k89UEKuQmv8O7XdhmybMWw4Ioo75RDdN4wriBm3/J7RHRNSjc0QPxDT0i7ehQ6H2BeKi
         uyC2lkgp2N1PeLx4oSi0MC3eMEcd/x8PQfi2S5ki23HTpLtX3Y5EwzjEQ4+QjNYNa6Kl
         PBK/izUbzLB/fs61aRFocDJqibVB5WhIH1rH5D8ilbqTi6mW7mYQ739ZKuiO5990S5+c
         bhRmKfaMGcheVhmcvijhU7bPY2On+9U1qMSd7lygX49tHqVLBJ9N0Vlxp1uZ0VzrhshT
         Anng==
X-Gm-Message-State: AO0yUKVGyf+QfwoaF7mV/qjaUsR0s6K5QsDUXflLNsDv2NLu+JN20uAO
	s55kR5pouhhH64kBNoKeclhU9tfBUAI=
X-Google-Smtp-Source: AK7set9BfDCBCkZHMuaDtYMLVaqKLlk8U79SXBDu/y2Co+a51NjKGyqtXjdF+Ce+/Hsy9OH5ScLNMezBLhY=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:d46:0:b0:4ff:e4bc:b56f with SMTP id
 67-20020a810d46000000b004ffe4bcb56fmr977377ywn.488.1675398211280; Thu, 02 Feb
 2023 20:23:31 -0800 (PST)
Date: Thu,  2 Feb 2023 20:20:51 -0800
In-Reply-To: <20230203042056.1794649-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230203042056.1794649-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230203042056.1794649-8-reijiw@google.com>
Subject: [PATCH v3 09/14] KVM: arm64: PMU: Set PMCR_EL0.N for vCPU based on
 the associated PMU
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Jing Zhang <jingzhangos@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

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
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/pmu-emul.c         | 14 +++++++++++++-
 arch/arm64/kvm/sys_regs.c         | 17 ++++++++++-------
 3 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 33839077a95c..734f1b6f7468 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -233,6 +233,9 @@ struct kvm_arch {
 		u8 imp_limit;
 	} dfr0_pmuver;
 
+	/* PMCR_EL0.N value for the guest */
+	u8 pmcr_n;
+
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
 
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 5ff44224148f..3053c06db7a9 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -680,6 +680,9 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
 	if (!entry)
 		goto out_unlock;
 
+	WARN_ON((pmu->num_events <= 0) &&
+		(pmu->num_events > ARMV8_PMU_MAX_COUNTERS));
+
 	entry->arm_pmu = pmu;
 	list_add_tail(&entry->entry, &arm_pmus);
 
@@ -881,6 +884,13 @@ int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
 	kvm->arch.dfr0_pmuver.imp_limit = min_t(u8, arm_pmu->pmuver, ID_AA64DFR0_EL1_PMUVer_V3P5);
 	kvm->arch.dfr0_pmuver.imp = kvm->arch.dfr0_pmuver.imp_limit;
 
+	/*
+	 * Both the num_events and PMCR_EL0.N indicates the number of
+	 * PMU event counters, but the former includes the cycle counter
+	 * while the latter does not.
+	 */
+	kvm->arch.pmcr_n = arm_pmu->num_events - 1;
+
 	return 0;
 }
 
@@ -1074,5 +1084,7 @@ u8 kvm_arm_pmu_get_pmuver_limit(void)
 
 u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
 {
-	return __vcpu_sys_reg(vcpu, PMCR_EL0);
+	u64 pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0) & ~ARMV8_PMU_PMCR_N;
+
+	return pmcr | ((u64)vcpu->kvm->arch.pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9f8c25e49a5a..aba93db29697 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -624,12 +624,8 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 pmcr;
 
-	/* No PMU available, PMCR_EL0 may UNDEF... */
-	if (!kvm_arm_support_pmu_v3())
-		return;
-
 	/* Only preserve PMCR_EL0.N, and reset the rest to 0 */
-	pmcr = read_sysreg(pmcr_el0) & ARMV8_PMU_PMCR_N;
+	pmcr = kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_N;
 	if (!kvm_supports_32bit_el0())
 		pmcr |= ARMV8_PMU_PMCR_LC;
 
@@ -946,6 +942,13 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
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
@@ -1719,8 +1722,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CTR_EL0), access_ctr },
 	{ SYS_DESC(SYS_SVCR), undef_access },
 
-	{ PMU_SYS_REG(SYS_PMCR_EL0), .access = access_pmcr,
-	  .reset = reset_pmcr, .reg = PMCR_EL0 },
+	{ PMU_SYS_REG(SYS_PMCR_EL0), .access = access_pmcr, .reset = reset_pmcr,
+	  .reg = PMCR_EL0, .get_user = get_pmcr },
 	{ PMU_SYS_REG(SYS_PMCNTENSET_EL0),
 	  .access = access_pmcnten, .reg = PMCNTENSET_EL0 },
 	{ PMU_SYS_REG(SYS_PMCNTENCLR_EL0),
-- 
2.39.1.519.gcb327c4b5f-goog

