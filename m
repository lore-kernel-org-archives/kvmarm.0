Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90961DD9A4
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 17:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728323204; cv=none; b=cNJUxCpm3JiN7R2t+C8S8jyCKg2+GNSbr/yQD2nFZNLK50CAAJ0k4BRENJw6l+E5LpfFDKbS0RAmzQ7pvTKn/fw0MlCX+c/8aW4t8HP2Ogk7c3wMIrnOIwwEopcLwatBJjlnO5RBQo6AI+FdE2xvReqziqzW373jIY8S+rEDlpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728323204; c=relaxed/simple;
	bh=u2c0YdMKh6xC82sae1+Gi3BxzGEeBp+HcNDdcz76RHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=trCf9ubzyslIW7fp5niOu/djV5Ae/aM/tYOQDfluot3Pptl8jExn7DAOGe+so+qFzOlclIsL+c0UMtjVFy3wbeS58YyA2npo45d8L25A2F5DYWFPGV0rjBE91r84cijmq1nn+473u+mmoydsgjLxugzKe4fyoVjEG7tckCmihW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IMgrmEAT; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IMgrmEAT"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728323201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=09opFow0HVQv79uX70tQuQU/YoIhGDZt9jeKuE5Wf5A=;
	b=IMgrmEAToDC9cCqnVXWbBkogZFBxZ17g68VThKQN7BuPx3K1FcYvKnFU7loE3gE8Vo0LUb
	Lr+wU9/VwIjMp/rhSAnzzgwYI4NgMTYzoKvp6mfOIfn4BlI7pj1S87fHGKD1fLpLJ1IDoh
	RaoSw5uf/5ZguVeccOcbRuQcsZLhwfA=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 15/17] KVM: arm64: nv: Honor MDCR_EL2.HLP
Date: Mon,  7 Oct 2024 17:45:57 +0000
Message-ID: <20241007174559.1830205-16-oliver.upton@linux.dev>
In-Reply-To: <20241007174559.1830205-1-oliver.upton@linux.dev>
References: <20241007174559.1830205-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Counters that fall in the hypervisor range (i.e. N >= HPMN) have a
separate control for enabling 64 bit overflow. Take it into account.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/pmu-emul.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index e45f5de278c6..69c11c46c79a 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -89,7 +89,11 @@ static bool kvm_pmc_is_64bit(struct kvm_pmc *pmc)
 
 static bool kvm_pmc_has_64bit_overflow(struct kvm_pmc *pmc)
 {
-	u64 val = kvm_vcpu_read_pmcr(kvm_pmc_to_vcpu(pmc));
+	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
+	u64 val = kvm_vcpu_read_pmcr(vcpu);
+
+	if (kvm_pmu_counter_is_hyp(vcpu, pmc->idx))
+		return __vcpu_sys_reg(vcpu, MDCR_EL2) & MDCR_EL2_HLP;
 
 	return (pmc->idx < ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LP)) ||
 	       (pmc->idx == ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LC));
-- 
2.47.0.rc0.187.ge670bccf7e-goog

