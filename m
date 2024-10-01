Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB27D176AC3
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 02:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727750806; cv=none; b=JJUfxvrXoytFpf9WGV7A9aLJKsGNwyXXLhO2NJO9tDSS2WaD444R27+JRDf8Vpnwx00P8vGJE94nDTGij6lc4N3pzjiql1FD/tsf0I44iPzdUhSX2QHzRb68pmPGsrKMuCCEwdCcLjjcC9SmrG4y6M/ScAcfhg+APR8lDOzFeko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727750806; c=relaxed/simple;
	bh=Z7TScUmHHCtsxMxrUnLqllB6ap7TuudPJwolTLaBJAA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cYUHY5bHpjx13xxEKsxATpDN0f2OiudchUJyJ4PXFB7MaP2KqugjpAOcmpsnmSKVRry8HpyTn5rWCSfolAqCK76fSl0gG3dsJkCRTxyaO2WVf9ROXYlvontMIjJBioc0J2MQ+4BhzQULYC+pLaf5o98FKOfoC17uTGGsCQgZjnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C072F367;
	Mon, 30 Sep 2024 19:47:13 -0700 (PDT)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CDA4F3F58B;
	Mon, 30 Sep 2024 19:46:40 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 40/47] arm64/sysreg: Add register fields for SPMCGCR1_EL1
Date: Tue,  1 Oct 2024 08:13:49 +0530
Message-Id: <20241001024356.1096072-41-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241001024356.1096072-1-anshuman.khandual@arm.com>
References: <20241001024356.1096072-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds register fields for SPMCGCR1_EL1 as per the definitions based
on DDI0601 2024-06.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 50397a1a5799..ad7a1dc05f8a 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -129,6 +129,10 @@ Sysreg	SPMCGCR0_EL1	2	0	9	13	0
 Fields	SPMCGCRx_EL1
 EndSysreg
 
+Sysreg	SPMCGCR1_EL1    2       0       9       13      1
+Fields	SPMCGCRx_EL1
+EndSysreg
+
 Sysreg	SPMACCESSR_EL1	2	0	9	13	3
 Field	63:62	P31
 Field	61:60	P30
-- 
2.25.1

