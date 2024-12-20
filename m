Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EBD01A4E77
	for <kvmarm@lists.linux.dev>; Fri, 20 Dec 2024 07:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734679382; cv=none; b=fQPLvph9NdLSoFbmaQGrzSRR73/f54YPH29IKPUNzGd/Y9Zi5Nzz5vMIZ+ZNDhKufOF8OVyzFoP9n7KEO3WI7VxPTBlUEJvEUIWBR/1Tur2DRQxuZ9FvaQfMJUbNxeSZOULg2QQleXfPcLnbto1yDNgZ7bQfULTAKg2S5Ued0FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734679382; c=relaxed/simple;
	bh=Rv2fDgk3NSsy+yodD2WxigI/6HaXKujPQ+9sBsPdaWE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P3fZMlxm/Wu25sZlVK9DDHZNPPqFwhMeTtLF6JqF86m3Jgk3d/75ttx/wciredm1kiFlwRmtOWeV4q/DFvhgiKE+nVRfOMUNxtfhUwbYo4bRv34oTfjIF6hOG5Y675mhLQJzCnh7J9a/zyFQ9nKpRHVbQ/KzKvZ3wrtEcGcETFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 92AC01596;
	Thu, 19 Dec 2024 23:23:27 -0800 (PST)
Received: from a077893.arm.com (unknown [10.163.51.72])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E98F03F58B;
	Thu, 19 Dec 2024 23:22:53 -0800 (PST)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <robh@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Eric Auger <eric.auger@redhat.com>,
	kvmarm@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 1/7] arm64/sysreg: Update register fields for ID_AA64MMFR0_EL1
Date: Fri, 20 Dec 2024 12:52:34 +0530
Message-Id: <20241220072240.1003352-2-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241220072240.1003352-1-anshuman.khandual@arm.com>
References: <20241220072240.1003352-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This updates ID_AA64MMFR0_EL1 register fields as per the definitions based
on DDI0601 2024-09.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index b081b54d6d22..a6cbe0dcd63b 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1591,6 +1591,7 @@ EndEnum
 UnsignedEnum	59:56	FGT
 	0b0000	NI
 	0b0001	IMP
+	0b0010	FGT2
 EndEnum
 Res0	55:48
 UnsignedEnum	47:44	EXS
@@ -1652,6 +1653,7 @@ Enum	3:0	PARANGE
 	0b0100	44
 	0b0101	48
 	0b0110	52
+	0b0111	56
 EndEnum
 EndSysreg
 
-- 
2.25.1

