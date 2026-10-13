Received: from mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103974FECC0
	for <kvmarm@lists.linux.dev>; Tue, 13 Oct 2026 13:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896588; cv=none; b=moA/kYn4R7wsUPzQVCh/J8UmWFB+0zWVjJ0H5uXMkdmpOECRAs7v7ml7SdLkvrsvg5LOS+EuMg/r9kYHRKuxEHZH0l8msVSO5po9qkUTtGTj7jcs/4SqeCdE0uwQ1PzAXV+Rdct1QF+l4yKY85G/Wumz5CDxheAQ2wkPW483CV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896588; c=relaxed/simple;
	bh=6pfi29I7iZeVkWM5Pq02jetXzg693tfWNUUszIMV4EE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UeyPbaP+/Ru9QHmt6ILUcYTxru1yvOeFB8a1GqYToWK0n9RpxFnJEDAX88IrnSxQmAjgpWLfNsIv7aMXvv2hMY9fg/8wiIvvSjFZKJHcmlqGSw2z6j7bC8zRDjwG/Lqor0dkOMUDTm29K5gMlMwuEX9JfeXWpnM4Uw+zwAccZP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pqOiIlGx; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pqOiIlGx"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=6pfi29I7iZeVkWM5Pq02jetXzg693tfWNUUszIMV4EE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791896585; v=1; x=1792501385;
 b=pqOiIlGxgUonKJwRaQXd7Z5ju8E/o9w4OPzciRxGcJyg6WF3B/AcLWNT6cYHz4YOE/SIMd9X
 9XIzX10MZ8KF04w/IHZABJo0lcVTut+hw0BOj7vC/4v51QIFrmB6ebeYP2NXDkg4Bk0nUFBsk+7
 yZSjWUkLQaWoLzfo/Sh11hf0=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 89b7ad62b8944177;
	Tue, 13 Oct 2026 13:03:04 +0000
X-Mizu-Trace-ID: 89b7ad62b8944177
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
Subject: [PATCH 2/4] arm64: sysreg: Fix the names of two misspelt fields
Date: Tue, 13 Oct 2026 14:02:45 +0100
Message-Id: <20261013130247.4135515-3-fuad.tabba@linux.dev>
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

Two fields in the sysreg file have the wrong name. In DDI0601 2026-09,
bit 10 of HFGRTR2_EL2 and HFGWTR2_EL2, which traps SCTLR2ALIAS_EL1, is
nSCTLR2ALIAS_EL1, not nSCTLRALIAS2_EL1, and bits [39:36] of SMPRIMAP_EL2
are P9, between P8 and P10, not F9.

Rename both, along with the three KVM users of the first. The second
has no users.

No functional change intended.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/config.c         | 4 ++--
 arch/arm64/kvm/emulate-nested.c | 2 +-
 arch/arm64/tools/sysreg         | 6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 1053676551aff..e93919cadf860 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -804,7 +804,7 @@ static const struct reg_bits_to_feat_map hfgrtr2_feat_map[] = {
 		   HFGRTR2_EL2_nCPACRALIAS_EL1	|
 		   HFGRTR2_EL2_nCPACRMASK_EL1	|
 		   HFGRTR2_EL2_nSCTLR2MASK_EL1	|
-		   HFGRTR2_EL2_nSCTLRALIAS2_EL1	|
+		   HFGRTR2_EL2_nSCTLR2ALIAS_EL1	|
 		   HFGRTR2_EL2_nSCTLRALIAS_EL1	|
 		   HFGRTR2_EL2_nSCTLRMASK_EL1	|
 		   HFGRTR2_EL2_nTCR2ALIAS_EL1	|
@@ -825,7 +825,7 @@ static const struct reg_bits_to_feat_map hfgwtr2_feat_map[] = {
 		   HFGWTR2_EL2_nCPACRALIAS_EL1	|
 		   HFGWTR2_EL2_nCPACRMASK_EL1	|
 		   HFGWTR2_EL2_nSCTLR2MASK_EL1	|
-		   HFGWTR2_EL2_nSCTLRALIAS2_EL1	|
+		   HFGWTR2_EL2_nSCTLR2ALIAS_EL1	|
 		   HFGWTR2_EL2_nSCTLRALIAS_EL1	|
 		   HFGWTR2_EL2_nSCTLRMASK_EL1	|
 		   HFGWTR2_EL2_nTCR2ALIAS_EL1	|
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index f59d89d04ecaf..fc23c793ef176 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1431,7 +1431,7 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
 	SR_FGT(SYS_CPACRMASK_EL1,	HFGRTR2, nCPACRMASK_EL1, 0),
 	SR_FGT(SYS_PFAR_EL1,		HFGRTR2, nPFAR_EL1, 0),
 	SR_FGT(SYS_RCWSMASK_EL1,	HFGRTR2, nRCWSMASK_EL1, 0),
-	SR_FGT(SYS_SCTLR2ALIAS_EL1,	HFGRTR2, nSCTLRALIAS2_EL1, 0),
+	SR_FGT(SYS_SCTLR2ALIAS_EL1,	HFGRTR2, nSCTLR2ALIAS_EL1, 0),
 	SR_FGT(SYS_SCTLR2MASK_EL1,	HFGRTR2, nSCTLR2MASK_EL1, 0),
 	SR_FGT(SYS_SCTLRALIAS_EL1,	HFGRTR2, nSCTLRALIAS_EL1, 0),
 	SR_FGT(SYS_SCTLRMASK_EL1,	HFGRTR2, nSCTLRMASK_EL1, 0),
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index f2812545f336e..341db8e9b6c37 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -4336,7 +4336,7 @@ Field	14	nACTLRALIAS_EL1
 Field	13	nACTLRMASK_EL1
 Field	12	nTCR2ALIAS_EL1
 Field	11	nTCRALIAS_EL1
-Field	10	nSCTLRALIAS2_EL1
+Field	10	nSCTLR2ALIAS_EL1
 Field	9	nSCTLRALIAS_EL1
 Field	8	nCPACRALIAS_EL1
 Field	7	nTCR2MASK_EL1
@@ -4355,7 +4355,7 @@ Field	14	nACTLRALIAS_EL1
 Field	13	nACTLRMASK_EL1
 Field	12	nTCR2ALIAS_EL1
 Field	11	nTCRALIAS_EL1
-Field	10	nSCTLRALIAS2_EL1
+Field	10	nSCTLR2ALIAS_EL1
 Field	9	nSCTLRALIAS_EL1
 Field	8	nCPACRALIAS_EL1
 Field	7	nTCR2MASK_EL1
@@ -4592,7 +4592,7 @@ Field	55:52	P13
 Field	51:48	P12
 Field	47:44	P11
 Field	43:40	P10
-Field	39:36	F9
+Field	39:36	P9
 Field	35:32	P8
 Field	31:28	P7
 Field	27:24	P6
-- 
2.39.5

