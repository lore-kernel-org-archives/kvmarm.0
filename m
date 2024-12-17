Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FED1F8925
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 17:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734458192; cv=none; b=oxtmo3EJgkK4IyAo4SNnSSUU0g8skJiW8BpYjbsrbEQqI3Ayydz4vxTAuaUXY/MDvwJhhYWVOq6R30jQ+Ape5pFpkU5t9GKVdsIx2OlYVJSndsD2cTDxDdafbPZngK3mo+t4O9Pr3Pt0mOQ//98OxlXzuwGyZBo3PA/kERU4U50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734458192; c=relaxed/simple;
	bh=SRNvdsDnj7pE45rJIoxRTJXz5MjmKAv5n7BiMb5oUaI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eKbceolh/392pA4mEQQSwoMFDLLS+w/T8Dxwh0H7GjgYmQIWUhHtcAeD/stmmBpiZ4wrmCOJ/BaRmm/REVja/AKbzeXDBjNAOBrek2yqw1IYt0hY20/6F3xwdOlFJk7gRPfLLxrQTFJFMQJngzVIrjFMO7uBsHlP8IWSTXmf3Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Fi45UOh1; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Fi45UOh1"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734458189;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CDgr0mr176E5xiO0kHiuxiG6mLUMJNXRv037b+CSgSo=;
	b=Fi45UOh18wWfHm58v0U0DXxIozByNLBzulB147dN0Kt28eAE1+Y0yk0Xi99phniGRDSf1U
	jJy09LbFbrC6Uf1Rb2Wj/ow/LDAE7rrgPc6U2GAdjdWiFw4a+nhF4nAK2wK8QZjXUBJyDG
	GFC023gWGcEw36dcqLmBERkmFoRSTII=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 4/4] KVM: arm64: Only apply PMCR_EL0.P to the guest range of counters
Date: Tue, 17 Dec 2024 09:56:11 -0800
Message-Id: <20241217175611.3658290-1-oliver.upton@linux.dev>
In-Reply-To: <20241217175336.3657966-1-oliver.upton@linux.dev>
References: <20241217175336.3657966-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

An important distinction from other registers affected by HPMN is that
PMCR_EL0 only affects the guest range of counters, regardless of the EL
from which it is accessed. Ensure that PMCR_EL0.P is always applied to
'guest' counters by manually computing the mask rather than deriving it
from the current context.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/pmu-emul.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index c6423782a8aa..6c5950b9ceac 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -617,8 +617,14 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 		kvm_pmu_set_counter_value(vcpu, ARMV8_PMU_CYCLE_IDX, 0);
 
 	if (val & ARMV8_PMU_PMCR_P) {
-		unsigned long mask = kvm_pmu_accessible_counter_mask(vcpu);
-		mask &= ~BIT(ARMV8_PMU_CYCLE_IDX);
+		/*
+		 * Unlike other PMU sysregs, the controls in PMCR_EL0 always apply
+		 * to the 'guest' range of counters and never the 'hyp' range.
+		 */
+		unsigned long mask = kvm_pmu_implemented_counter_mask(vcpu) &
+				     ~kvm_pmu_hyp_counter_mask(vcpu) &
+				     ~BIT(ARMV8_PMU_CYCLE_IDX);
+
 		for_each_set_bit(i, &mask, 32)
 			kvm_pmu_set_pmc_value(kvm_vcpu_idx_to_pmc(vcpu, i), 0, true);
 	}
-- 
2.39.5

