Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F6BC185B71
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 02:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727750706; cv=none; b=FkgWPvUDH3skdgRd51IF+pwS8mjKZnfT35cyar6NIWxj5O0hOL9P6up1NkfEHuPUFavyQjiHGMk5MKuBRuGK5tKFBEKC/IGobrIeVlOZgpevrVChTDZGMcu8ZJu+OWIAenMQdlWuhjf+3TWNztt1iwLO6WMv8xEd62M9EayjrTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727750706; c=relaxed/simple;
	bh=FmFgT7i4AWqEXHQB7lv0Vtfna1SJAAlcwLCClwLwyn4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rZ8tIhgvfjRDj5qWWIxQeYmhjv9yzY70ecWqYo29jedPgPkE7ANdCmjWXCIMHJ+jUXe/5JHriSkyJDJUdoBP2jyHMHxKIKOxxp51YubXrd46VgcBbGjl/mfXeTUzXD0J0t3AXr3eUElNCtnybzfvO6g0ULM7CRmRXAFAG9j71ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 78D01367;
	Mon, 30 Sep 2024 19:45:34 -0700 (PDT)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 871D43F58B;
	Mon, 30 Sep 2024 19:45:01 -0700 (PDT)
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
Subject: [PATCH 15/47] arm64/sysreg: Add register fields for SPMDEVAFF_EL1
Date: Tue,  1 Oct 2024 08:13:24 +0530
Message-Id: <20241001024356.1096072-16-anshuman.khandual@arm.com>
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

This adds register fields for SPMDEVAFF_EL1 as per the definitions based
on DDI0601 2024-06.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 865de0549a07..5d76c0ddcb85 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -114,6 +114,18 @@ Res0	63:1
 Field	0	OSLK
 EndSysreg
 
+Sysreg	SPMDEVAFF_EL1	2	0	9	13	6
+Res0	63:40
+Field	39:32	Aff3
+Field	31	F0V
+Field	30	U
+Res0	29:25
+Field	24	MT
+Field	23:16	Aff2
+Field	15:8	Aff1
+Field	7:0	Aff0
+EndSysreg
+
 Sysreg ID_PFR0_EL1	3	0	0	1	0
 Res0	63:32
 UnsignedEnum	31:28	RAS
-- 
2.25.1

