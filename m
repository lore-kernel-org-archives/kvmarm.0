Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CFC45811A
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 02:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727750793; cv=none; b=X1IGcApJ5I08Mf3EfLuw6yvtyVEaK1IFzC+Ho7lSq7WElvnhOv5+pbQ4he1+RTqSmD59KdpmNLogtkPwFvNsf3UXDHSQE22ESRJVG3sjQm18GbjNYKCIMgB8NXI5rjXDYz1yMTbNZ70nzC2I+8iFpLNpnEzeidGFtalzTXLWS5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727750793; c=relaxed/simple;
	bh=pLQu8xGE55F4N35v7rKltcJJAwb2/9S9HrZG8kTwoLo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=vCE/3yQuuGAENLiZYMxSbDP9UNL90569QmpG4W3/3u7eDMGnrtU/1ahVFIb/wsaX08PQYddSxA7dBYoXQ0zrIsvP65co2xxOQ4gLrGEVSq6tMRbo7Igbpko/k/+pY7Km9oyaPVmX+e3FgxxJTRBTgVbvbuRcEI4AKnzxuEAbVeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C9537367;
	Mon, 30 Sep 2024 19:47:01 -0700 (PDT)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D948B3F58B;
	Mon, 30 Sep 2024 19:46:28 -0700 (PDT)
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
Subject: [PATCH 37/47] arm64/sysreg: Add register fields for PMSSCR_EL1
Date: Tue,  1 Oct 2024 08:13:46 +0530
Message-Id: <20241001024356.1096072-38-anshuman.khandual@arm.com>
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

This adds register fields for PMSSCR_EL1 as per the definitions based
on DDI0601 2024-06.

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
index a07d89e43498..0043268765d5 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2762,6 +2762,13 @@ Res0	63:5
 Field	4:0	SEL
 EndSysreg
 
+Sysreg	PMSSCR_EL1	3	0	9	13	3
+Res0	63:33
+Field	32	NC
+Res0	31:1
+Field	0	SS
+EndSysreg
+
 Sysreg	PMUACR_EL1	3	0	9	14	4
 Res0	63:33
 Field	32	FM
-- 
2.25.1

