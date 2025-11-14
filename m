Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30FF9265630
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136461; cv=none; b=uO4tXlj9ciNAJCVLrtoSgfoELGQF5CP5g+R76ds8xLzRBKPc4k1zeqLzWzUBZyVcZir+jAbZA2UVrlkotjhOiex7GkqILJN9TGPAjMTrBW5P6Ue4b479gRwQOXh6E/j9z0uzrBH6e3wV+udLorzYSe4brVN7HEM1iQBKJ3rREgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136461; c=relaxed/simple;
	bh=TuPlASHMC/jAYjnlMpyeKfVNZqda7IBRmzMX8ugd2XI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uvuwRsUAPE/3XR2hxdP4Q8J1MfLl8/aIbqw5+arv7xoUUg/tJ91kg1WWpSgV/eDckRvDCzdSWZBvEMxb0DIh7NOGJ4qLv08SMBZ2OyxpLGQh0xVNctl0xchS32ZJ2OsciXr1zhT6kIdRpttTSVmQf0040/CEvx1wZLurbeupx2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BDC8F19F6;
	Fri, 14 Nov 2025 08:07:31 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3FB8C3F5A1;
	Fri, 14 Nov 2025 08:07:37 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: james.clark@linaro.org,
	mark.rutland@arm.com,
	james.morse@arm.com
Subject: [RFC PATCH v6 02/35] arm64/sysreg: Define MDCR_EL2.E2PB values
Date: Fri, 14 Nov 2025 16:06:43 +0000
Message-ID: <20251114160717.163230-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251114160717.163230-1-alexandru.elisei@arm.com>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM will make use of the different values for MDCR_EL2.E2PB, document them.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/tools/sysreg | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 1e7b69594f04..0de8af0e0778 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3851,7 +3851,12 @@ Field	17	HPMD
 Res0	16
 Field	15	EnSPM
 Field	14	TPMS
-Field	13:12	E2PB
+UnsignedEnum	13:12 E2PB
+	0b00	EL2
+	0b01	RESERVED
+	0b10	EL1_TRAP
+	0b11	EL1
+EndEnum
 Field	11	TDRA
 Field	10	TDOSA
 Field	9	TDA
-- 
2.51.2

