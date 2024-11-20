Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA008C0B
	for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 00:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732063968; cv=none; b=ihA3RJ6EjXw0Yvs72kx/8J8xdQkND1JDkg86CRShUtrhSznh5qhcsdFVStuCpOcTO/mjrYuKv9UNP3ijmFCvZu7EzWvYet9FfkN/xDSgnaORVSU/oScOJZG+h9s5tx4fk0zgInocsDZVrcGFCsq//iAsK9sIcScK/AzNZS3Q40I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732063968; c=relaxed/simple;
	bh=MkCZJUIrbLgB/d4GywaL3IJrAZ+Pd/TiIN0uyuCNLfY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pKBLZHD0XshcGfRQ41UKk/bAv81XOvcdfkyo0lQDE+53w+dTCXUE51+2kw80r99RBX/5Z+BRCuhGFnUAcQ2mlBfUvbhk6WgwNKOvZEUk5qO8z8g+fQm8jXCvhYDKEYDM0QP9cvaYkYjg/lUIOCyr5pAOJ9/VDqaIbrg8hXnMppY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HOth3664; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HOth3664"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732063963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qVJl2gc3o7h1yAy3lDYNSCS50vxN4k6RD4GP/LDCTzA=;
	b=HOth3664PMcHXvmQ62jO0QI6ccrX8wuedBYNAfgj5sL81MDFMMEPQT7GsLIXag+wtIr5dk
	g3yGi5U6XkuR3Duq2lDmVmnMnRT8Yd10z8UZDkY7JpxybM3w6M7qCE4pL2REsbHkH8oV8U
	4qcvZj9nqcd2i+uGJ3yB9OehIWmleL8=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	stable@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 1/2] KVM: arm64: Ignore PMCNTENSET_EL0 while checking for overflow status
Date: Tue, 19 Nov 2024 16:52:29 -0800
Message-Id: <20241120005230.2335682-2-oliver.upton@linux.dev>
In-Reply-To: <20241120005230.2335682-1-oliver.upton@linux.dev>
References: <20241120005230.2335682-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Raghavendra Rao Ananta <rananta@google.com>

DDI0487K D13.1.1 describes the PMU overflow condition, which evaluates
to true if any counter's global enable (PMCR_EL0.E), overflow flag
(PMOVSSET_EL0[n]), and interrupt enable (PMINTENSET_EL1[n]) are all 1.
Of note, this does not require a counter to be enabled
(i.e. PMCNTENSET_EL0[n] = 1) to generate an overflow.

Align kvm_pmu_overflow_status() with the reality of the architecture
and stop using PMCNTENSET_EL0 as part of the overflow condition. The
bug was discovered while running an SBSA PMU test [*], which only sets
PMCR.E, PMOVSSET<0>, PMINTENSET<0>, and expects an overflow interrupt.

Cc: stable@vger.kernel.org
Fixes: 76d883c4e640 ("arm64: KVM: Add access handler for PMOVSSET and PMOVSCLR register")
Link: https://github.com/ARM-software/sbsa-acs/blob/master/test_pool/pmu/operating_system/test_pmu001.c
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
[ oliver: massaged changelog ]
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/pmu-emul.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 8ad62284fa23..3855cc9d0ca5 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -381,7 +381,6 @@ static u64 kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
 
 	if ((kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E)) {
 		reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
-		reg &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
 		reg &= __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
 	}
 
-- 
2.39.5

