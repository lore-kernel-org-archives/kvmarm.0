Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C93F206505
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 18:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729880654; cv=none; b=X7EmUawV5JWldM9HBn8LHXx0omnZYxKf4yaUKCT1qr1bYA+iPsVYe5CcDDWd/gEd6qnW4AmP8qTs6Vc3P8o8mlCw4KeavqzLRkewQRhorrfleJqZkesRx/P+j1eEAZLm2m1C5jvovQXspEvSlvtwqtPd1vnJHs39CaM3309048U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729880654; c=relaxed/simple;
	bh=5hfrBegQJ+ZnoqKqylzYAuKuo/qmiAnNrTvu/0ZGM8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EtO7cO4wEhiDQk2LIbIqukxSOr0t5eP1ZGhxhylUvaqtbav7U9ezA1GctvSeCor4c5klI21sI/plLCPKRUOaMzts9NvNzzsZo6wq5KVorq3HvMb+JwZCUF9eQ1zPHDUpJI/EVbSKqZsicPvE2MJwg1oOWIJSuLryGRAqbS2Y3M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=I5ZziLi5; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="I5ZziLi5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729880650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X+s7YOZIeIWAs/5W19BCTzijIhqnkURfVQCL2Dnr1iE=;
	b=I5ZziLi59uBxmOn9KsacgP2NIz3Ie6Lhy8SqDAM6jRPm/4eud6+Qlq9lUmhzo3O9N+ZgaV
	WTsy494La1HGQqrXB5hEpsrZyYNGl1xECZ9hCyu+E336CwQCBpjSDKC/H61OjALXM3OWJv
	6dHXKahNrismibLkAD5VTxOFypxi2GQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 02/18] arm64: sysreg: Describe ID_AA64DFR2_EL1 fields
Date: Fri, 25 Oct 2024 18:23:37 +0000
Message-ID: <20241025182354.3364124-3-oliver.upton@linux.dev>
In-Reply-To: <20241025182354.3364124-1-oliver.upton@linux.dev>
References: <20241025182354.3364124-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Describe the new ID register in line with DDI0601 2024-09.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/tools/sysreg | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 8d637ac4b7c6..5670e51a6f90 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1287,6 +1287,32 @@ Field	15:8	BRPs
 Field	7:0	SYSPMUID
 EndSysreg
 
+Sysreg	ID_AA64DFR2_EL1	3	0	0	5	2
+Res0	63:28
+UnsignedEnum	27:24	TRBE_EXC
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	23:20	SPE_nVM
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	19:16	SPE_EXC
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Res0	15:8
+UnsignedEnum	7:4	BWE
+	0b0000	NI
+	0b0001	FEAT_BWE
+	0b0002	FEAT_BWE2
+EndEnum
+UnsignedEnum	3:0	STEP
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+EndSysreg
+
 Sysreg	ID_AA64AFR0_EL1	3	0	0	5	4
 Res0	63:32
 Field	31:28	IMPDEF7
-- 
2.47.0.163.g1226f6d8fa-goog

