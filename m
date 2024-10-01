Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F9AC3B782
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 02:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727750674; cv=none; b=BSt0Fe8jQSkwpVqmF3BkIoY7NoOsumaIfiblcTiBPeqRB/vixBOjaCoBVLdWu/iYw0HOk2jyfk22SRwbnmfNu37NjK/JIwL0ZLk/OT/cgipQpe/5KLv4tXfYNFfiFf9wcsfvmkyGzZSm9cngGaxLEqv1T4wClukSoWmA6qy3sBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727750674; c=relaxed/simple;
	bh=I72ucOlZXOs0xBlhQi+IZX6bPCqUlvn2yLnrl4aZU+M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L44h5xzZWfE4ZOHVyq7YjVmGcCwqsRLwKCe2IApE5N1BJf6+DQW+uyTPCVXMrR3S7zLbe+2QEjf6978LO4uen6M/9nv/Va2Qwh9AGbJz/VsHeEGhe3t8hQH2x0M1oZNKIiw+tOlOFu+VwHuJ52Mt+CMZPGx3pLm1xYmYTeA0AdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A9355DA7;
	Mon, 30 Sep 2024 19:45:02 -0700 (PDT)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B89FD3F58B;
	Mon, 30 Sep 2024 19:44:29 -0700 (PDT)
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
Subject: [PATCH 07/47] arm64/sysreg: Add register fields for HFGITR2_EL2
Date: Tue,  1 Oct 2024 08:13:16 +0530
Message-Id: <20241001024356.1096072-8-anshuman.khandual@arm.com>
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

This adds register fields for HFGITR2_EL2 as per the definitions based
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
index bd1dfcbcff79..300c19b09f1b 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2714,6 +2714,10 @@ Field	1	AMEVCNTR00_EL0
 Field	0	AMCNTEN0
 EndSysreg
 
+Sysreg	HFGITR2_EL2	3	4	3	1	7
+Res0	63:0
+EndSysreg
+
 Sysreg	ZCR_EL2	3	4	1	2	0
 Fields	ZCR_ELx
 EndSysreg
-- 
2.25.1

