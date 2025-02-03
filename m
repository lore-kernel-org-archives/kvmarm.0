Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B0C1D5CC2
	for <kvmarm@lists.linux.dev>; Mon,  3 Feb 2025 18:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738607570; cv=none; b=rI2z1MzakHm36lQViS5Dg7K9VLGMoQKLPplODs4EabiYwvT2Kaq9hv6PU/eSJPwG1Ibl51yOUXJMqHJn6SSCuBIX+Ue+fXJWhkkcOD9e17jQ0RWK9oVFQ6kJU7K3Nvtf5Lm3dbyayyci1RwOSN15iRgEJI5ediGJ+ri2QH2rCPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738607570; c=relaxed/simple;
	bh=AH+nkSEjSOmGlcRzTX6OKf73NS+zmT79gH8M3qzluS4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DKKWXtg9Szxn3/0JO5Cg3DG5bDafC+X2sXb0G3712zIjagjkPffJI9Fx3nIJxx5DWnZWCh+ggTYLURFKXa7SMR9OpKOv/+zmh2yW7XQV99GOBEo/lu7kfck7VI558IuA8qPGTh/7C4ey3A4auPWBUy0GGFKsTTVwrBZGNmeMRu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ASPv2DWs; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ASPv2DWs"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738607562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tsB8DsHJdiQoqXPS3Rw6NkqRDeCazk+YgKLVcGUuCus=;
	b=ASPv2DWsSwlCcEkU96RkM6PGoyvIht2TDFL/inVk8yPyCKy2mLCUUN222fgZQee9DgABM2
	4QZAfFnvlRePJ5Drk4uDoCt+AFlkWHkGVuKJpVqEPGF0SvTddMP6bWlIuh3EQGfGLDzwmy
	vay3ZczDkikQOVpNJAZqwnJH5KOIH44=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Janne Grunau <j@jannau.net>
Subject: [PATCH v2 12/14] KVM: arm64: Advertise PMUv3 if IMPDEF traps are present
Date: Mon,  3 Feb 2025 10:31:09 -0800
Message-Id: <20250203183111.191519-13-oliver.upton@linux.dev>
In-Reply-To: <20250203183111.191519-1-oliver.upton@linux.dev>
References: <20250203183111.191519-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Advertise a baseline PMUv3 implementation when running on hardware with
IMPDEF traps of the PMUv3 sysregs.

Tested-by: Janne Grunau <j@jannau.net>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/pmu-emul.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 57ef4f2814fc..97f29153193f 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1243,7 +1243,17 @@ u8 kvm_arm_pmu_get_pmuver_limit(void)
 	pmuver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer,
 			       read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1));
 
-	/* Treat IMPLEMENTATION DEFINED functionality as unimplemented */
+	/*
+	 * Spoof a barebones PMUv3 implementation if the system supports IMPDEF
+	 * traps of the PMUv3 sysregs
+	 */
+	if (cpus_have_final_cap(ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS))
+		return ID_AA64DFR0_EL1_PMUVer_IMP;
+
+	/*
+	 * Otherwise, treat IMPLEMENTATION DEFINED functionality as
+	 * unimplemented
+	 */
 	if (pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
 		return 0;
 
-- 
2.39.5

