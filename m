Received: from mta0.migadu.com (out-197.mta0.migadu.com [91.218.175.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135704FC33A
	for <kvmarm@lists.linux.dev>; Tue, 13 Oct 2026 13:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896597; cv=none; b=s7QrCndUKMvgzwY5ftVJ9zB/UTer1iykk2j7FytmgL2xtVsAGKud+NRbENBjyTpulBwbVI+rTryp9SsAHzupyGMP6glo6l598Ps5Baxqb9J34h12Ij+YpR0W+WGktnBeeMjfcaPp1x0QFcqHifjfP8Kfrx9s99YCg/j/v2oy6DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896597; c=relaxed/simple;
	bh=CaYuksYIH3T9mue+o25Jw5LFw402j/q0Agp5Li01cWU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=huXP8YSRkS+YZqm+qL6ish1BAVtHAZI7vFtyutmsEhoP3adnW+dM7fnJMNIoTjqJXsLxHTW85OgZGYOscNpRtbDXG9CoWF2lUFIo3eCrShh2pCLDNNw2RzShCaVzDLax16a524prZX9L7fZm/KD+GTNrI8qJbu60roZaNad4HbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IG3Zvy60; arc=none smtp.client-ip=91.218.175.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IG3Zvy60"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=CaYuksYIH3T9mue+o25Jw5LFw402j/q0Agp5Li01cWU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791896594; v=1; x=1792501394;
 b=IG3Zvy601YEUx85CV0MJ+ThtPVQyiTOp0mg35T0kjYR1Cm6RQ7t01K2+F4JkQ86558rWwmdP
 6TayDZw7/hN+7N/+ZABN8GGk6n6bRgZL3y+o+nD+4MXSgNOYLc6oVGtkUBLOX38LFwTqMKzBe3C
 RHS2YH+V2MU2Y+pv0YOLQ8aw=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 5fed7ca6c3443aa9;
	Tue, 13 Oct 2026 13:03:13 +0000
X-Mizu-Trace-ID: 5fed7ca6c3443aa9
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Mark Brown <broonie@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] perf: arm_brbe: Remove the check for TME transaction states
Date: Tue, 13 Oct 2026 14:02:47 +0100
Message-Id: <20261013130247.4135515-5-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261013130247.4135515-1-fuad.tabba@linux.dev>
References: <20261013130247.4135515-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When an event samples branch flags, the BRBE driver warns once if a
branch record has BRBINFx_EL1.T or LASTFAILED set, which its comment
calls TME-related information. FEAT_TME has been withdrawn from the
architecture, and both fields are RES0 in DDI0601 2026-09, so the check
tests fields that no longer exist.

Remove the check and its two accessors, which were the only users of
the fields' defines, and mark both fields RES0 in the sysreg file.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/tools/sysreg |  5 +----
 drivers/perf/arm_brbe.c | 18 ------------------
 2 files changed, 1 insertion(+), 22 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 99af1c39478be..b15a59b9e95dd 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1338,10 +1338,7 @@ Res0	63:47
 Field	46	CCU
 Field	45:40	CC_EXP
 Field	39:32	CC_MANT
-Res0	31:18
-Field	17	LASTFAILED
-Field	16	T
-Res0	15:14
+Res0	31:14
 Enum	13:8		TYPE
 	0b000000	DIRECT_UNCOND
 	0b000001	INDIRECT
diff --git a/drivers/perf/arm_brbe.c b/drivers/perf/arm_brbe.c
index 254be4da8ae29..073d145847417 100644
--- a/drivers/perf/arm_brbe.c
+++ b/drivers/perf/arm_brbe.c
@@ -166,21 +166,11 @@ static bool brbe_record_is_target_only(u64 brbinf)
 	return brbe_record_valid(brbinf) == BRBINFx_EL1_VALID_TARGET;
 }
 
-static int brbinf_get_in_tx(u64 brbinf)
-{
-	return FIELD_GET(BRBINFx_EL1_T_MASK, brbinf);
-}
-
 static int brbinf_get_mispredict(u64 brbinf)
 {
 	return FIELD_GET(BRBINFx_EL1_MPRED_MASK, brbinf);
 }
 
-static int brbinf_get_lastfailed(u64 brbinf)
-{
-	return FIELD_GET(BRBINFx_EL1_LASTFAILED_MASK, brbinf);
-}
-
 static u16 brbinf_get_cycles(u64 brbinf)
 {
 	u32 exp, mant, cycles;
@@ -627,14 +617,6 @@ static bool perf_entry_from_brbe_regset(int index, struct perf_branch_entry *ent
 			entry->mispred = brbinf_get_mispredict(brbinf);
 			entry->predicted = !entry->mispred;
 		}
-
-		/*
-		 * Currently TME feature is neither implemented in any hardware
-		 * nor it is being supported in the kernel. Just warn here once
-		 * if TME related information shows up rather unexpectedly.
-		 */
-		if (brbinf_get_lastfailed(brbinf) || brbinf_get_in_tx(brbinf))
-			pr_warn_once("Unknown transaction states\n");
 	}
 
 	/*
-- 
2.39.5

