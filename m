Received: from out-11.mta1.migadu.com (out-11.mta1.migadu.com [95.215.58.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08211F938
	for <kvmarm@lists.linux.dev>; Thu, 13 Jul 2023 22:17:04 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1689286620;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=p/4ENK9UOIrNW7JeGREJbjtEJAdAdYwM+AT0EM8H0Qk=;
	b=cG6NN3zFcR15NYidebFTT7m81GVCTN6Zcfkho5xmtLicx65zchhbXo8cTR0J0BTqiajNMo
	K9SAaZDJky1ymHyISrcDbfKyW+/Di5VQS7EnRhgXQYAUI/VUi1FJL4U5xa9JObazjxJSj4
	vJ7rVoRN8KFF3lMEXRQBjm378MICOBY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Reiji Watanabe <reijiw@google.com>,
	rananta@google.com,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] KVM: arm64: Correctly handle RES0 bits PMEVTYPER<n>_EL0.evtCount
Date: Thu, 13 Jul 2023 22:16:49 +0000
Message-ID: <20230713221649.3889210-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The PMU event ID varies from 10 to 16 bits, depending on the PMU
version. If the PMU only supports 10 bits of event ID, bits [15:10] of
the evtCount field behave as RES0.

While the actual PMU emulation code gets this right (i.e. RES0 bits are
masked out when programming the perf event), the sysreg emulation writes
an unmasked value to the in-memory cpu context. The net effect is that
guest reads and writes of PMEVTYPER<n>_EL0 will see non-RES0 behavior in
the reserved bits of the field.

As it so happens, kvm_pmu_set_counter_event_type() already writes a
masked value to the in-memory context that gets overwritten by
access_pmu_evtyper(). Fix the issue by removing the unnecessary (and
incorrect) register write in access_pmu_evtyper().

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index bd3431823ec5..fa7597882ed8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -986,7 +986,6 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 	if (p->is_write) {
 		kvm_pmu_set_counter_event_type(vcpu, p->regval, idx);
-		__vcpu_sys_reg(vcpu, reg) = p->regval & ARMV8_PMU_EVTYPE_MASK;
 		kvm_vcpu_pmu_restore_guest(vcpu);
 	} else {
 		p->regval = __vcpu_sys_reg(vcpu, reg) & ARMV8_PMU_EVTYPE_MASK;

base-commit: dcf89d111199562fa5f31a1bb76f17bc4831f6da
-- 
2.41.0.255.g8b1d071c50-goog

