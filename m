Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 371C247F5D
	for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 06:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718866739; cv=none; b=sToLkz15pYQ+kVU4ob4z/9xdmcAPXAjgLeWr0QO7c3eAMiR/W4N4jGqpDnXO3AqErLvpwZritBfuv4uE0lk7DRWTwe+XQWK6dxYRpAmtCo1H8nwEnNRl1eUhv42w6EMd4tziX3ZqbzMxI9R9fdqpMBps7fqvutswTk8xtAPPL9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718866739; c=relaxed/simple;
	bh=QIuJ7eHArijbgqvnVwOF+HA0Sai02Q5aBta+a0jbVjY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GWJrGKSEeqokV5V4Am6oeeak5cTTEaoP0IU28iIjWVv7BB89LVNTibG8OJXURnaoGSJy5AMH5pR5UQUR5cOJt6n14l35Kv32oUcbKMrTNzML1RHyBTbLyfve2XNR7dx8QinqaqnSodqCJ0tgpFS9udYVo8+oFjibS9g6+1GTXXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8FAC6DA7;
	Wed, 19 Jun 2024 23:59:22 -0700 (PDT)
Received: from a077893.arm.com (unknown [10.163.46.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BEF963F73B;
	Wed, 19 Jun 2024 23:58:52 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	maz@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC 08/10] arm64/sysreg: Add register fields for TRBIDR_EL1
Date: Thu, 20 Jun 2024 12:28:05 +0530
Message-Id: <20240620065807.151540-9-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240620065807.151540-1-anshuman.khandual@arm.com>
References: <20240620065807.151540-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds register fields for TRBIDR_EL1 as per the definitions based
on DDI0601 2024-03.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index ee2038f6f3a3..d057e57d74e7 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3098,7 +3098,12 @@ Field	31:0	TRG
 EndSysreg
 
 Sysreg	TRBIDR_EL1	3	0	9	11	7
-Res0	63:12
+Res0	63:16
+UnsignedEnum	15:12	MPAM
+	0b0000	NI
+	0b0001	PMG
+	0b0010	IMP
+EndEnum
 Enum	11:8	EA
 	0b0000	NON_DESC
 	0b0001	IGNORE
-- 
2.25.1

