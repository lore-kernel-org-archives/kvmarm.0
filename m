Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EA410E6
	for <kvmarm@lists.linux.dev>; Fri,  3 Feb 2023 04:23:24 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-4b34cf67fb6so39903507b3.6
        for <kvmarm@lists.linux.dev>; Thu, 02 Feb 2023 20:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+lTOMqZEuFEaNT61qUBO+2GaxyavVhauG1igBc20tgA=;
        b=PK76gQxhOVDeyvTP2E//JguBNyOHQYe6aDfiMNG68uFtZ9Mt4eIqGhceH3w4Tv7uK6
         Ps8Ut5EjxC3aMnq6OJYmBBigANjGhqm+gCn+KuQ9YBPVKD/qwjeSRqBGfODmGmRWLJdj
         2PMnBQ6d6M75FDeTIMhss8wGcYnF9vyYi3oUQh8fiNqXeFCpu/828VnUB2mEFMws9Ifx
         J8WiePKArOMpW4alrfqJEgQC5SUW/VpG/BKR7R+qp7s/eimIrxAHcCo6OLMkRxEZauZH
         399ohqTJulad0xDkIoLYjzzxMQ48OPDQvNH2s+ZZdkyt3BUeMAz8N/g+Hz37CEWdycwb
         OEvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+lTOMqZEuFEaNT61qUBO+2GaxyavVhauG1igBc20tgA=;
        b=VrIC3+TleZOKpzhKZEcupSbCucdB91ivj+SBs+fBX6LpMZT0SXQOQLcSDO4yI4njPB
         bzF5zGhxsvhQPSqS6duH1ra4ktSjkG545vujlS3O4c8Cn+RSKR0y820xI9F+v1MFp+XC
         l5TyEqr5AYXRJ1Yk16vv8Ib39pKQzPjG1BKXWKK4BwzPj5jOlFqTYoA2ereyvCIEKAYX
         gR5pOfoJBggCG7IjudLBFQ0N95TM8gYF6e/Stt/wp+xaE3ASrhUdaguh9a8ELgiE+27x
         jZtsmDsOU2LXabQZI42qNTHZnK2pLnaoARi1nVXYHtj2DnBYxk2WIgG/xSLm4K9myoql
         FvNQ==
X-Gm-Message-State: AO0yUKVQdCspl/kvPcCbfldZqYWpT5RcAkDyNYyqx1Wr7O8LLdtq0fFf
	xyKV4e02LIL4mYHx7PhHw2HL6vmMjec=
X-Google-Smtp-Source: AK7set9IanJjSULDLBxl3uXOGzf9AFE8QBFbNG5ZQ2mcI+jJcEc6I9RwVCGqxiME38zDnC7Jl4VQnbJ+yNI=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:b285:0:b0:855:fdcb:4460 with SMTP id
 k5-20020a25b285000000b00855fdcb4460mr2ybj.1.1675398203551; Thu, 02 Feb 2023
 20:23:23 -0800 (PST)
Date: Thu,  2 Feb 2023 20:20:47 -0800
In-Reply-To: <20230203042056.1794649-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230203042056.1794649-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230203042056.1794649-4-reijiw@google.com>
Subject: [PATCH v3 05/14] KVM: arm64: PMU: Clear PM{C,I}NTEN{SET,CLR} and
 PMOVS{SET,CLR} on vCPU reset
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

On vCPU reset, PMCNTEN{SET,CLR}_EL0, PMINTEN{SET,CLR}_EL1, and
PMOVS{SET,CLR}_EL1 for a vCPU are reset by reset_pmu_reg().
This function clears RAZ bits of those registers corresponding
to unimplemented event counters on the vCPU, and sets bits
corresponding to implemented event counters to a predefined
pseudo UNKNOWN value (some bits are set to 1).

The function identifies (un)implemented event counters on the
vCPU based on the PMCR_EL0.N value on the host. Using the host
value for this would be problematic when KVM supports letting
userspace set PMCR_EL0.N to a value different from the host value
(some of the RAZ bits of those registers could end up being set to 1).

Fix this by clearing the registers so that it can ensure
that all the RAZ bits are cleared even when the PMCR_EL0.N value
for the vCPU is different from the host value. Use reset_val() to
do this instead of fixing reset_pmu_reg(), and remove
reset_pmu_reg(), as it is no longer used.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c1ec4a68b914..e6e419157856 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -602,23 +602,6 @@ static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
-static void reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
-{
-	u64 n, mask = BIT(ARMV8_PMU_CYCLE_IDX);
-
-	/* No PMU available, any PMU reg may UNDEF... */
-	if (!kvm_arm_support_pmu_v3())
-		return;
-
-	n = read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
-	n &= ARMV8_PMU_PMCR_N_MASK;
-	if (n)
-		mask |= GENMASK(n - 1, 0);
-
-	reset_unknown(vcpu, r);
-	__vcpu_sys_reg(vcpu, r->reg) &= mask;
-}
-
 static void reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	reset_unknown(vcpu, r);
@@ -976,7 +959,7 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	  trap_wcr, reset_wcr, 0, 0,  get_wcr, set_wcr }
 
 #define PMU_SYS_REG(r)						\
-	SYS_DESC(r), .reset = reset_pmu_reg, .visibility = pmu_visibility
+	SYS_DESC(r), .reset = reset_val, .visibility = pmu_visibility
 
 /* Macro to expand the PMEVCNTRn_EL0 register */
 #define PMU_PMEVCNTR_EL0(n)						\
-- 
2.39.1.519.gcb327c4b5f-goog

