Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 880F3333ABB
	for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 14:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758121008; cv=none; b=ItbB4d52fKMDoKRUEG9uQCILMjRZijS5Yf6LdSVisYG7S+szLgr2ZWO15jtrPqWzq81s6wBPuyBoXa6P2eervgbgqWf4p6SUWwxTf3OlGgvKmKQCKgzd5NTP/WO8y6T04ew+MjO2+dzshHI68BnvTYe4P2pfTEAOsqCPv71+F0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758121008; c=relaxed/simple;
	bh=N8YLYPkl4tKVv6OcchZf05oQ0VXHePRCzLklXY2vJXk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EgRsKReRJGp3wZFf0dsrnvgIheXGjJY0Ha7JESxxF3FPVUEXXsVMlOqu0il+OnkmnPUBTkTXwPMHG84yDKdOsJS5FWFDazZfIIR/2GVDf9CC5QB1qImEqMu4UVVX61mgSCoKnDvTyNVgItF7AmonPxi34J0aZaQtni9vXGc8q0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E05F3267F;
	Wed, 17 Sep 2025 07:56:38 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 98C6C3F66E;
	Wed, 17 Sep 2025 07:56:43 -0700 (PDT)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	broonie@kernel.org,
	oliver.upton@linux.dev,
	anshuman.khandual@arm.com,
	robh@kernel.org,
	james.morse@arm.com,
	mark.rutland@arm.com,
	joey.gouly@arm.com,
	Dave.Martin@arm.com,
	ahmed.genidi@arm.com,
	kevin.brodsky@arm.com,
	scott@os.amperecomputing.com,
	mbenes@suse.cz,
	james.clark@linaro.org,
	frederic@kernel.org,
	rafael@kernel.org,
	pavel@kernel.org,
	ryan.roberts@arm.com,
	suzuki.poulose@arm.com,
	maz@kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v5 6/6] docs: arm64: Document booting requirements for FEAT_SCTLR2
Date: Wed, 17 Sep 2025 15:56:18 +0100
Message-Id: <20250917145618.1232329-7-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917145618.1232329-1-yeoreum.yun@arm.com>
References: <20250917145618.1232329-1-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Martin <Dave.Martin@arm.com>

Support for FEAT_SCTLR2 imposes some requirments on the configuration
of traps at exception levels above the level at which the kernel is
booted.

Document them.

For now, don't document requirements on the initial state of SCTLR2_ELx
at the kernel boot exception level.  The general wording under "System
registers" appiles.  (SCTLR_ELx is similarly undocumented.)

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 Documentation/arch/arm64/booting.rst | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
index 2f666a7c303c..e8fe1b2023a9 100644
--- a/Documentation/arch/arm64/booting.rst
+++ b/Documentation/arch/arm64/booting.rst
@@ -545,6 +545,16 @@ Before jumping into the kernel, the following conditions must be met:
 
    - MDCR_EL3.TPM (bit 6) must be initialized to 0b0
 
+  For CPUs with the SCTLR2_ELx registers (FEAT_SCTLR2):
+
+  - If EL3 is present:
+
+    - SCR_EL3.SCTLR2En (bit 44) must be initialised to 0b1.
+
+  - If the kernel is entered at EL1 and EL2 is present:
+
+    - HCRX_EL2.SCTLR2En (bit 15) must be initialised to 0b1.
+
 The requirements described above for CPU mode, caches, MMUs, architected
 timers, coherency and system registers apply to all CPUs.  All CPUs must
 enter the kernel in the same exception level.  Where the values documented
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}

