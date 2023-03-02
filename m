Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34659110B
	for <kvmarm@lists.linux.dev>; Thu,  2 Mar 2023 05:51:14 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id g5-20020a25a485000000b009419f64f6afso2980660ybi.2
        for <kvmarm@lists.linux.dev>; Wed, 01 Mar 2023 21:51:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JIeZqQDsplqWeP29HSexHYJ737JRXcOhQ7J6+HeNN2w=;
        b=G7n5xRm8RuF8DWUa4l/dLwnWK40+IWpfuZf0ysJNlcCfBoklRxlEITp3YycBMOORKJ
         B1TCLExmdY4QQO8YBfGSb1K8/NdSEuqGiPOpnbvcVa0XUuYZOTsXKHWJkZiy5ydEippp
         d5dLg66/P6IfBlW1CMH5eFq8MQhHQhFkD1S27UABk5qRXTdCPMWuoeiqxwgOdbW3agzZ
         xcDn9pMYTT/2TcSno3TOuLAZL3SIzukVCHBGqoQ6PFhGe8HOVYcfwSUe82Jlsorf50zg
         eRRIKDMiN94VfqUUSM2An1jKG22Q8worBPPp0YTpyxoXdwi8jl5E9oD+BQPNFMpSsJrt
         L+MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JIeZqQDsplqWeP29HSexHYJ737JRXcOhQ7J6+HeNN2w=;
        b=aJGfcn35iVI/vMOVMRFL+dA/P+dZDKQZIJSb1J2yCNHYnFPed2PZq4NlkQAZTga8Ir
         BRmE35OwBBRKf/aqT0rThCJeJH96JwI1XXtjPndxWmqs+UvDXuGKrSOV8E1BYmb3F0lC
         ZeIV3xyolGa/cvoRqrPZwEVEtnZoWBiX/HxRHkXtd3SOARkgnyrAGbMDNhB5dUNnQeav
         ryFICshEm3wGNBHftJh17oCXbJ+LoMjLU490M/WOExEy32R6POiuVGx8vnftpZapKuUI
         lNFZsqC3Tafk2XzYi2p/TOhmMZBxXI+tsxA9tR9ghBr8WH0Gu72yJPQ8+amQmpoLQcI4
         uXkQ==
X-Gm-Message-State: AO0yUKVm0O1b0r8dHtmfmkU04f3DK66h/C8qsEV8yc6kR0DN8lOFqvkb
	+TvI0mmcsA3jjyMzVbFAfAMO7CZwOGk=
X-Google-Smtp-Source: AK7set8kXeijwpd5IrzgWApLjro6tbe3Ft4KHgEVuEL6iPTP37OQY2fZkgCjZ3ALNfhQIYq/8IZYFpXUm4U=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:ac4e:0:b0:535:5e8c:65ef with SMTP id
 z14-20020a81ac4e000000b005355e8c65efmr5482065ywj.6.1677736273146; Wed, 01 Mar
 2023 21:51:13 -0800 (PST)
Date: Wed,  1 Mar 2023 21:50:32 -0800
In-Reply-To: <20230302055033.3081456-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230302055033.3081456-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230302055033.3081456-2-reijiw@google.com>
Subject: [PATCH 1/2] KVM: arm64: PMU: Fix GET_ONE_REG for vPMC regs to return
 the current value
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Will Deacon <will@kernel.org>, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

Have KVM_GET_ONE_REG for vPMU counter (vPMC) registers (PMCCNTR_EL0
and PMEVCNTR<n>_EL0) return the sum of the register value in the sysreg
file and the current perf event counter value.

Values of vPMC registers are saved in sysreg files on certain occasions.
These saved values don't represent the current values of the vPMC
registers if the perf events for the vPMCs count events after the save.
The current values of those registers are the sum of the sysreg file
value and the current perf event counter value.  But, when userspace
reads those registers (using KVM_GET_ONE_REG), KVM returns the sysreg
file value to userspace (not the sum value).

Fix this to return the sum value for KVM_GET_ONE_REG.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c6cbfe6b854b..c48c053d6146 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -765,6 +765,22 @@ static bool pmu_counter_idx_valid(struct kvm_vcpu *vcpu, u64 idx)
 	return true;
 }
 
+static int get_pmu_evcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+			  u64 *val)
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
+	*val = kvm_pmu_get_counter_value(vcpu, idx);
+	return 0;
+}
+
 static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 			      struct sys_reg_params *p,
 			      const struct sys_reg_desc *r)
@@ -981,7 +997,7 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 /* Macro to expand the PMEVCNTRn_EL0 register */
 #define PMU_PMEVCNTR_EL0(n)						\
 	{ PMU_SYS_REG(SYS_PMEVCNTRn_EL0(n)),				\
-	  .reset = reset_pmevcntr,					\
+	  .reset = reset_pmevcntr, .get_user = get_pmu_evcntr,		\
 	  .access = access_pmu_evcntr, .reg = (PMEVCNTR0_EL0 + n), }
 
 /* Macro to expand the PMEVTYPERn_EL0 register */
@@ -1745,7 +1761,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ PMU_SYS_REG(SYS_PMCEID1_EL0),
 	  .access = access_pmceid, .reset = NULL },
 	{ PMU_SYS_REG(SYS_PMCCNTR_EL0),
-	  .access = access_pmu_evcntr, .reset = reset_unknown, .reg = PMCCNTR_EL0 },
+	  .access = access_pmu_evcntr, .reset = reset_unknown,
+	  .reg = PMCCNTR_EL0, .get_user = get_pmu_evcntr},
 	{ PMU_SYS_REG(SYS_PMXEVTYPER_EL0),
 	  .access = access_pmu_evtyper, .reset = NULL },
 	{ PMU_SYS_REG(SYS_PMXEVCNTR_EL0),
-- 
2.39.2.722.g9855ee24e9-goog

