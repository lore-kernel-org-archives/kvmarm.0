Received: from out-214.mta0.migadu.com (out-214.mta0.migadu.com [91.218.175.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9F53214
	for <kvmarm@lists.linux.dev>; Wed, 13 Sep 2023 16:56:55 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1694624213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DhLfcFyA2+nmwrxML7Y1VzCvedGNaW1azCKlPa2eHPA=;
	b=Wrm8lyUbqvCT689fWDZ8Rgueah/pRGc2GQQUBs3ta7lginZ+YRMKIgBRUOcQccuwdrq2WB
	jKw+qsPL93uRDHUL4KF/dI3YamFyYrfc0Fi+scdGWfalqvAHws/uT2Wsw9BlDlaw+FeAbz
	MC8qsTk64BQ1mTqtz/PG8BF7dkGvE5w=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] KVM: arm64: Don't use kerneldoc comment for arm64_check_features()
Date: Wed, 13 Sep 2023 16:56:44 +0000
Message-ID: <20230913165645.2319017-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

A double-asterisk opening mark to the comment (i.e. '/**') indicates a
comment block is in the kerneldoc format. There's automation in place to
validate that kerneldoc blocks actually adhere to the formatting rules.

The function comment for arm64_check_features() isn't kerneldoc; use a
'regular' comment to silence automation warnings.

Link: https://lore.kernel.org/all/202309112251.e25LqfcK-lkp@intel.com/
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e92ec810d449..818a52e257ed 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1228,7 +1228,7 @@ static s64 kvm_arm64_ftr_safe_value(u32 id, const struct arm64_ftr_bits *ftrp,
 	return arm64_ftr_safe_value(&kvm_ftr, new, cur);
 }
 
-/**
+/*
  * arm64_check_features() - Check if a feature register value constitutes
  * a subset of features indicated by the idreg's KVM sanitised limit.
  *

base-commit: 0bb80ecc33a8fb5a682236443c1e740d5c917d1d
-- 
2.42.0.459.ge4e396fd5e-goog

