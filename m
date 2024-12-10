Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0088A228CA1
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 05:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810198; cv=none; b=fhxXCWbx9KjtKOGrNGEln6pNSl23w2D5jdY0VIFPjE0EhQJxDUm9UHYFniJGpgK95PdFNUiSYtiLxYeGiz4hgiLt8D0/dEw8rGLLieQL6YGj9zNiWndtMddZYZhsuJv5oqqVoJmIhRIHeoCirKn8pweNhDQXzsOj7rHwCips8Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810198; c=relaxed/simple;
	bh=AKGqnRlsbpGjxwcSvfGpMEawxkUsWP6aZRz3F+X4Q/o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jW7aGphIncOxBLw1DZa8FOmod//SR8C5x+SDA0L66ZI8gmwFj3chRgBU2BM+OcziQm7qYayntkBSGpQyPhA8f+rsuTFizCEMffUG8K/gHN1CjUEiCU6NAJe6ozCLvaum9Ww4Sa7TJFSgq66XE9e0tw7f1ej5l7d6GuqKr4RVeIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B2A2113E;
	Mon,  9 Dec 2024 21:57:04 -0800 (PST)
Received: from a077893.arm.com (unknown [10.163.48.173])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E03233F58B;
	Mon,  9 Dec 2024 21:56:30 -0800 (PST)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org
Cc: ryan.roberts@arm.com,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH V2 38/46] arm64/sysreg: Add register fields for SPMCGCR0_EL1
Date: Tue, 10 Dec 2024 11:23:03 +0530
Message-Id: <20241210055311.780688-39-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241210055311.780688-1-anshuman.khandual@arm.com>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds register fields for SPMCGCR0_EL1 as per the definitions based
on DDI0601 2024-09.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 05f548b11470..e97572c4f370 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -114,6 +114,21 @@ Res0	63:1
 Field	0	OSLK
 EndSysreg
 
+SysregFields	SPMCGCRx_EL1
+Field	63:56	N7
+Field	55:48	N6
+Field	47:40	N5
+Field	39:32	N4
+Field	31:24	N3
+Field	23:16	N2
+Field	15:8	N1
+Field	7:0	N0
+EndSysregFields
+
+Sysreg	SPMCGCR0_EL1	2	0	9	13	0
+Fields	SPMCGCRx_EL1
+EndSysreg
+
 Sysreg	SPMACCESSR_EL1	2	0	9	13	3
 Field	63:62	P31
 Field	61:60	P30
-- 
2.25.1

