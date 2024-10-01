Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC0DC149E03
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 02:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727750778; cv=none; b=YkoXb3QEDWmKtBQuKuWLU5wg2uk6AGs5zdK92TjSHUPtb2WZyr9PC3xpas356H7yhivbGuRcZe/JmtM614QwGOwB6dFV1b2XNn6dpYDiWL+aXFZKYaLUa3DaSCw+pJOtonNBpExLuVvqUrztZ8Yzyk3aid6X4GCIv+YlTEb1/+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727750778; c=relaxed/simple;
	bh=ubfRMvxZ5Lv9bgIsKArS+CAeVMvdnhHm+EeXakFjK6c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ciah3rJGZ1T0ZPMoZBkwOqjFoVeOSlfvhffhAOULlaCxkXh/PVQzAjDmLhHtnQQNhLEoho38zWL2dt7A+MITJmn6ssTj+7R+w628f9S57baSZvddSgsohl/cmZlw9ABJghiuASBOsgGRHoRyY6WO3eLl3xdcxql6jC095C/jtAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DC050367;
	Mon, 30 Sep 2024 19:46:45 -0700 (PDT)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EB09E3F58B;
	Mon, 30 Sep 2024 19:46:12 -0700 (PDT)
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
Subject: [PATCH 33/47] arm64/sysreg: Add register fields for PMICNTSVR_EL1
Date: Tue,  1 Oct 2024 08:13:42 +0530
Message-Id: <20241001024356.1096072-34-anshuman.khandual@arm.com>
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

This adds register fields for PMICNTSVR_EL1 as per the definitions based
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
index 7144a65aed5e..a649958b9fe8 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -299,6 +299,10 @@ Sysreg	PMCCNTSVR_EL1	2	0	14	11	7
 Field	63:0	CCNT
 EndSysreg
 
+Sysreg	PMICNTSVR_EL1	2	0	14	12	0
+Field	63:0	ICNT
+EndSysreg
+
 Sysreg	SPMCR_EL0	2	3	9	12	0
 Res0	63:12
 Field	11	TR0
-- 
2.25.1

