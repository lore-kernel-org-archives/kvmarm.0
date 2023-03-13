Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9678615CA
	for <kvmarm@lists.linux.dev>; Mon, 13 Mar 2023 03:32:14 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id x63-20020a17090a6c4500b00237731465feso4104344pjj.8
        for <kvmarm@lists.linux.dev>; Sun, 12 Mar 2023 20:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678678334;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nr9tcr5LV12ufzOmQGswUuR6NF1d70rt+DF2oLQIx/o=;
        b=apH4r5wNHPpZ5CWLQC1fVNzyZyD2uZsNpLprREbMqFfn1aaVdqg0k6gsB3Wu86L+X8
         LlhyePAcswCC0G6Al9xkDwaChQ2CEjGuk2KhZpMJBWm6kpnh9v2ijxrYmft2Gw1Z5ZQ8
         w5zI8E/F69m3d+wuw9uUhUwBE1WOrZ+uNhjTU2OO4XQnSaQEpt1Ex5KI1U7IsykGQa0N
         K/C89t1pxoBcgIk6nll5KwxNOktMkbdNatLeySfctKU2IpPABQIEtJ+AH1SnihnQsyV+
         1OSdcvMfAZSy4psffFT5qkY5I+76CKqsmWGR+BIYFS91MJYoTWYmhEYCuyzG5tDXNK4V
         GHjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678678334;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nr9tcr5LV12ufzOmQGswUuR6NF1d70rt+DF2oLQIx/o=;
        b=FwKnFt0XifFZGC7OfntZcLqKUaHnAXV7V6C+2A9V45YfU6YVAIgJvvOL/XMAq9urn2
         1uXxkD6mZVTMf7o7k2PXPcylQ1XoeDY+0F+n8ymnqdw7aj88zPD8YRw07be8VREiTDEb
         QPFR2uIKX5LPujUBO+07lvYUlW6aC0EWoN3S/wbSXXN4ZGmnRoKpq5xGpGgJAqmdzetB
         qUvTn8TkCH/crdONszLICjt8qY5w6V7q9cPyZBY6u2XjDxOYir1MNpVxSZ3sAmuCPmNL
         8epECk+2kNfSZ1BI16cFMsOcv6gUjIER6JtOB0oHQrQYkq+s3qFsCX/ouOREds93IeUt
         t5KA==
X-Gm-Message-State: AO0yUKX01Ih8Xu3yMHWB7Mx11q5IPTspNx5Fvz8CPJ7iWZd//WHoEm/Z
	XFqxPpxY3BLSxXO9aAzOBzRoLFdU9KY=
X-Google-Smtp-Source: AK7set8lnq+TDeHTGVE7DhLCdqN+7xuqVd/ZZqS+fE3fJxKZcQkLEbPPK+zKol9LZJSRGg5SyT5VtxdQFqk=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a17:90a:b798:b0:22c:3ee1:db3b with SMTP id
 m24-20020a17090ab79800b0022c3ee1db3bmr3251880pjr.3.1678678334056; Sun, 12 Mar
 2023 20:32:14 -0700 (PDT)
Date: Sun, 12 Mar 2023 20:32:08 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230313033208.1475499-1-reijiw@google.com>
Subject: [PATCH v2 1/2] KVM: arm64: PMU: Fix GET_ONE_REG for vPMC regs to
 return the current value
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Will Deacon <will@kernel.org>, Reiji Watanabe <reijiw@google.com>, stable@vger.kernel.org
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

Fixes: 051ff581ce70 ("arm64: KVM: Add access handler for event counter register")
Cc: stable@vger.kernel.org
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 53749d3a0996..1b2c161120be 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -856,6 +856,22 @@ static bool pmu_counter_idx_valid(struct kvm_vcpu *vcpu, u64 idx)
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
@@ -1072,7 +1088,7 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 /* Macro to expand the PMEVCNTRn_EL0 register */
 #define PMU_PMEVCNTR_EL0(n)						\
 	{ PMU_SYS_REG(SYS_PMEVCNTRn_EL0(n)),				\
-	  .reset = reset_pmevcntr,					\
+	  .reset = reset_pmevcntr, .get_user = get_pmu_evcntr,		\
 	  .access = access_pmu_evcntr, .reg = (PMEVCNTR0_EL0 + n), }
 
 /* Macro to expand the PMEVTYPERn_EL0 register */
@@ -1982,7 +1998,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
2.40.0.rc1.284.g88254d51c5-goog

