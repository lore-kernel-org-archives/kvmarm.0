Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EDCB433A2
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 02:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727750698; cv=none; b=IWK5+cdEt6hwooPlRBVEJ8471LaR/DxPOWi6CASr8/teN4CjG0q/Z1OvR3G7ZAh0MKrUAwsIZFTv2loo74ZeXo92NuYPrj6/7R52Xly8YhtgSvFtvZMhqvx2ZmJ1L7rACIZ6FtbXUwVPgt/qMhgIEManBqiPT1/QHuZgbsB61/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727750698; c=relaxed/simple;
	bh=Hg1b8g0TPM8x0PusuTjVhZRcmZw3bg7qAno4BsXHjS0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hm+u8KVeRln2AHF/+5u6ppKRlkI9XaUxPRtwSWdR0o8vPl16qNxckd8hYEzBoF6PlnN9Ixdg/IfysID6SMvsuZkgu7dSM53Ljzz/fwzZG7WOWx6V0vc5c4GryZF5vfde+Np8cbyNo3Gty4+Xi8RPV506m+sIGuMpn1IK7Z8gv9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 88324DA7;
	Mon, 30 Sep 2024 19:45:26 -0700 (PDT)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 949403F58B;
	Mon, 30 Sep 2024 19:44:53 -0700 (PDT)
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
Subject: [PATCH 13/47] arm64/sysreg: Add register fields for TRBMPAM_EL1
Date: Tue,  1 Oct 2024 08:13:22 +0530
Message-Id: <20241001024356.1096072-14-anshuman.khandual@arm.com>
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

This adds register fields for TRBMPAM_EL1 as per the definitions based
on DDI0601 2024-06.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 5ea714ec8f0e..8d931142e01a 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3142,6 +3142,19 @@ EndEnum
 Field	7:0	Attr
 EndSysreg
 
+Sysreg	TRBMPAM_EL1	3	0	9	11	5
+Res0	63:27
+Field 	26	EN
+UnsignedEnum	25:24	MPAM_SP
+	0b00	SECURE_PARTID
+	0b01	NON_SECURE_PARTID
+	0b10	ROOT_PARTID
+	0b11	REALM_PARTID
+EndEnum
+Field	23:16	PMG
+Field	15:0	PARTID
+EndSysreg
+
 Sysreg	TRBTRG_EL1	3	0	9	11	6
 Res0	63:32
 Field	31:0	TRG
-- 
2.25.1

