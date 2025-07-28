Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2443D274B4D
	for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 15:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753716379; cv=none; b=WD/6gBfg/YbkVCghn6NMW6SxC5Ujz3ES5HoIBMLwneMhfdg0fk6hn98e9B24ZbF5nlRvx6u6IbP4wnEt7AsAHDhT/g6hmk5jo5taUB9EYsokbN8IonAXQSELh/xUYkWgmO+hkDCauZG8LWgTZN1lK6iIix36qdgldznKcO3YKuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753716379; c=relaxed/simple;
	bh=HzNdXgLGXQn5JgZsUnpigXTR4eBfzFVOsenCpfXlvVw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oYkn1bUY+YITnP2QKN67pbMBg/JmXdyGj6pF7Qx63O0G7Z+jAhReoehztNEeSk7j9OY+3tW6robZEYnDWe2DDGjKpUcq6E8AijdjjPkV+IwoFuPyWxSRJvwO6DAszsqf4uoYICcbV4N5VW3aAdCQ8mF7kJ6YdI/wmT9KjB1oijo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YsObaEKh; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YsObaEKh"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753716375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xKuiSwTjzOqtH7vSyNP0hV9AY+QTvZHgPxX1SpuACFs=;
	b=YsObaEKhDso0UNShh/AKua1Gcj+afZ7JHFmfDYETuFz85roVDPcrfAitSKYOR553Q5LpF5
	465gmmdN7rMO3LujNstLlETOErMAsQW64G9gHcWfgPm/5IjXB4djdsQl1LskQT6sEZ6mcx
	M19nIvm1I/CUyIXh1V3UI30K9R9sZbE=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] KVM: arm64: selftests: Add FEAT_RAS EL2 registers to get-reg-list
Date: Mon, 28 Jul 2025 08:26:03 -0700
Message-Id: <20250728152603.2823699-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

VDISR_EL2 and VSESR_EL2 are now visible to userspace for nested VMs. Add
them to get-reg-list.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/arm64/get-reg-list.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/get-reg-list.c b/tools/testing/selftests/kvm/arm64/get-reg-list.c
index f4f85d12d42e..011fad95dd02 100644
--- a/tools/testing/selftests/kvm/arm64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/arm64/get-reg-list.c
@@ -63,6 +63,8 @@ static struct feature_id_reg feat_id_regs[] = {
 	REG_FEAT(HDFGWTR2_EL2,	ID_AA64MMFR0_EL1, FGT, FGT2),
 	REG_FEAT(ZCR_EL2,	ID_AA64PFR0_EL1, SVE, IMP),
 	REG_FEAT(SCTLR2_EL1,	ID_AA64MMFR3_EL1, SCTLRX, IMP),
+	REG_FEAT(VDISR_EL2,	ID_AA64PFR0_EL1, RAS, IMP),
+	REG_FEAT(VSESR_EL2,	ID_AA64PFR0_EL1, RAS, IMP),
 };
 
 bool filter_reg(__u64 reg)
@@ -749,6 +751,8 @@ static __u64 el2_regs[] = {
 	SYS_REG(CNTHV_CTL_EL2),
 	SYS_REG(CNTHV_CVAL_EL2),
 	SYS_REG(SP_EL2),
+	SYS_REG(VDISR_EL2),
+	SYS_REG(VSESR_EL2),
 };
 
 #define BASE_SUBLIST \
-- 
2.39.5

