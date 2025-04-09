Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752601CDFD4
	for <kvmarm@lists.linux.dev>; Wed,  9 Apr 2025 16:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744214482; cv=none; b=lx9fCMl8a9zwfaF0aqkgmKHR8+KDVJxcQ1UDCUY3mugaf7yMWoupWVfA6IYrYhQpiQX9JKyt8eNSc3idg/hk0DHBpmKDABvxP4tZy9cctN8TviKqAfCCgu6SpE5gVmIL8goSZZSVJLQwq0yPBO25bVHK1DhFLw3luXx+tbPR+1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744214482; c=relaxed/simple;
	bh=DHz376aawgvSsxJ0B6qhnTizqqNaXEuRGrIx/tSGW18=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AMmg1yOb81damyYGOlfXf7SH6Nj3TNRzBdWq07XzRf57cRYH66GBPhudMSErlp1TEd8nO5uPWk8BSIBm0jIegr7cHH7W8TyV3cYhykkFrTgIh8gwOF6gDv71vHFoCXOFR6PG5qEN3rCGFTo68KkTuzqdlaWMtWIer5AXV2N3Rvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AMQXwYud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AMQXwYud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486B4C4CEEC;
	Wed,  9 Apr 2025 16:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744214482;
	bh=DHz376aawgvSsxJ0B6qhnTizqqNaXEuRGrIx/tSGW18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AMQXwYudUx6ShJLREac/0zMnj7zJOIiGAGOk6oNMfi+XrKJGjizhGDHjnJToym3qa
	 DHErx8QYMBarPGokHjnLDT0jQDQLiGPvJURpcvox9I34IlALY8Clfl6uQToah/V0ea
	 38vk/UhIBA3zfsQNbZmunRx9yvIGIuyQRDEOaXWCxP0E2Xq4aWDdpRghQ8+1ZylPDQ
	 wde9OIGb3boDO1QeeVCBajP08JBsuAmIOLB5oQUlVanHusy1vv51GFn+Yn20MOvkGc
	 zSAdnJTsQhyh1A03XiiWAvO2bA6IPnOYXkMiJYsLpeW+LjnwiNsgZ/WoeUDVY9LF1v
	 OXc2nXE9rjj8g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u2Xrc-003vQT-CS;
	Wed, 09 Apr 2025 17:01:20 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 2/6] KVM: arm64: Contextualise the handling of PMCR_EL0.P writes
Date: Wed,  9 Apr 2025 17:01:02 +0100
Message-Id: <20250409160106.6445-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250409160106.6445-1-maz@kernel.org>
References: <20250409160106.6445-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Contrary to what the comment says in kvm_pmu_handle_pmcr(),
writing PMCR_EL0.P==1 has the following effects:

<quote>
The event counters affected by this field are:
  * All event counters in the first range.
  * If any of the following are true, all event counters in the second
    range:
    - EL2 is disabled or not implemented in the current Security state.
    - The PE is executing at EL2 or EL3.
</quote>

where the "first range" represent the counters in the [0..HPMN-1]
range, and the "second range" the counters in the [HPMN..MAX] range.

It so appears that writing P from EL2 should nuke all counters,
and not just the "guest" view. Just do that, and nuke the misleading
comment.

Reported-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 4dc4f3a473c3f..f3650f2f2d468 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -608,14 +608,12 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 		kvm_pmu_set_counter_value(vcpu, ARMV8_PMU_CYCLE_IDX, 0);
 
 	if (val & ARMV8_PMU_PMCR_P) {
-		/*
-		 * Unlike other PMU sysregs, the controls in PMCR_EL0 always apply
-		 * to the 'guest' range of counters and never the 'hyp' range.
-		 */
 		unsigned long mask = kvm_pmu_implemented_counter_mask(vcpu) &
-				     ~kvm_pmu_hyp_counter_mask(vcpu) &
 				     ~BIT(ARMV8_PMU_CYCLE_IDX);
 
+		if (!vcpu_is_el2(vcpu))
+			mask &= ~kvm_pmu_hyp_counter_mask(vcpu);
+
 		for_each_set_bit(i, &mask, 32)
 			kvm_pmu_set_pmc_value(kvm_vcpu_idx_to_pmc(vcpu, i), 0, true);
 	}
-- 
2.39.2

