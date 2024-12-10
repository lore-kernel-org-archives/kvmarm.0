Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52B7A22ACDF
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 05:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810184; cv=none; b=cpfK/UPzias/s9MYnMqEYswggt6ELRpB5tXTu2hi/W1fTgsYPop8BnC5V8HmYAL3I1NfcdxPP8WMoTEmTq6KUOkM6eZHapKACg6uxA3y9MUnAUkoCQL6peEx99Z8THuxqIJPo1QNustsLaMt46+QcnRqAkMr7MYZFzmk94YeU+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810184; c=relaxed/simple;
	bh=938nBJtBrRKWZT5HkfYq9eUO6nVS84CROf9Iurs+qgs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NjQusoMHZztSMgjoJisKZ1ZIHxqa7ivzKbx8EBxQIcbNUNqwfO3gbPmyHIrt1lbLxb52WTBtoSGKxGLG8oBJe5gtl2BVNRQ4X/K8NKLrh4oxqSbiYKzJLwcNORHsNumNhDlZL/mCkg5T1g5ljJnKa+s+QFbUDi1gxapRatViX7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F784113E;
	Mon,  9 Dec 2024 21:56:50 -0800 (PST)
Received: from a077893.arm.com (unknown [10.163.48.173])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D5FAA3F58B;
	Mon,  9 Dec 2024 21:56:17 -0800 (PST)
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
Subject: [PATCH V2 35/46] arm64/sysreg: Add register fields for SPMCFGR_EL1
Date: Tue, 10 Dec 2024 11:23:00 +0530
Message-Id: <20241210055311.780688-36-anshuman.khandual@arm.com>
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

This adds register fields for SPMCFGR_EL1 as per the definitions based
on DDI0601 2024-09.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index d423bb218a9f..f4f5d22948ad 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -178,6 +178,24 @@ Field	15:8	Aff1
 Field	7:0	Aff0
 EndSysreg
 
+Sysreg	SPMCFGR_EL1	2	0	9	13	7
+Res0	63:32
+Field	31:28	NCG
+Res0	27:25
+Field	24	HDBG
+Field	23	TR0
+Field	22	SS
+Field	21	FZ0
+Field	20	MSI
+Field	19	RAO
+Res0	18
+Field	17	NA
+Field	16	EX
+Field	15:14	RAZ
+Field	13:8	SIZE
+Field	7:0	N
+EndSysreg
+
 Sysreg	SPMINTENSET_EL1	2	0	9	14	1
 Field	63	P63
 Field	62	P62
-- 
2.25.1

