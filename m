Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DD8928683
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 02:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727750710; cv=none; b=WuElESQrsfEPGLERhBiMh6/ot2JTGEZt69NvIrBTNp/5not06IoPF0ausc5SHCeIVtFSAAOiVCFMODgYnavjpHQKj69n+Drr9HhfGaXiK9Xuom2TQ7C8zovUar9iShzxblSRoVdL409Uelppg4Y5dU71qHZFEkGCfEHDzliay4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727750710; c=relaxed/simple;
	bh=YFSb3ZsAqNsZ4XsrD/4QG2OoAqj9LuUp28hiPLF3Nbo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UiTZtUDcz/i+zV76Zwo2dUdaJmFwrUQXm/YrkVtivNapEABiBatZosVR1gD+kuC4okMhrUdIIkQUS9qQyn+bGq657qCciZgbXqxAtg9SEcp0usLLCPsXHwQ9dd4LUtsxU95PEA2c05DZQhBFN+Jc8a/Gsp6vgIouYkK1XGHgQkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 71BE8DA7;
	Mon, 30 Sep 2024 19:45:38 -0700 (PDT)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 80BC43F58B;
	Mon, 30 Sep 2024 19:45:05 -0700 (PDT)
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
Subject: [PATCH 16/47] arm64/sysreg: Add register fields for PFAR_EL1
Date: Tue,  1 Oct 2024 08:13:25 +0530
Message-Id: <20241001024356.1096072-17-anshuman.khandual@arm.com>
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

This adds register fields for PFAR_EL1 as per the definitions based on
DDI0601 2024-06.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 5d76c0ddcb85..ad0ab412e42f 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3193,3 +3193,10 @@ Field	5	F
 Field	4	P
 Field	3:0	Align
 EndSysreg
+
+Sysreg	PFAR_EL1	3	0	6	0	5
+Field	63	NS
+Field	62	NSE
+Res0	61:56
+Field	55:0	PA
+EndSysreg
-- 
2.25.1

