Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 385733FE662
	for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 17:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773337990; cv=none; b=HzKx1TEhYpbO/nx8P4T4474mutvZuhWict2HWEQRGBdFtkYAEaCaLA7WCfQ8OYXGY98NHtu1H38q8NC2m/BRqZIHaizc4C3ywesJGLKwWeRL68I2aTCeKBVuhyfNdLPMz5Z9ZqHEn5Ix2feBcjlGddzz6xLHCBiqOEOmzwfbU1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773337990; c=relaxed/simple;
	bh=gC1ASY4XTWOU9NSvQyEf85WEp3yTpQCXJkzGjWaR5EM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=igHMm3jdE3emvo4Vt98cMZpRZ+sltoAa9M6pii+ZXqmTm0LJp7BQ00Y+IR3U8slLerSO4GRA/F+CftelN5WCH+04NuCYgDTCK41HA4eZO97pM3sV+sh2Ttpm7PAwZ97b76VlYRqYDBkOtFlJ/CyLs0jCG9Cp9x2LaHctvYaY7SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 91D731E7D;
	Thu, 12 Mar 2026 10:52:58 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 407463F73B;
	Thu, 12 Mar 2026 10:53:02 -0700 (PDT)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	maz@kernel.org,
	oupton@kernel.org,
	miko.lenczewski@arm.com,
	kevin.brodsky@arm.com,
	broonie@kernel.org,
	ardb@kernel.org,
	suzuki.poulose@arm.com,
	lpieralisi@kernel.org,
	joey.gouly@arm.com,
	yuzenghui@huawei.com,
	yeoreum.yun@arm.com
Subject: [PATCH v16 6/8] arm64: armv8_deprecated: disable swp emulation when FEAT_LSUI present
Date: Thu, 12 Mar 2026 17:52:41 +0000
Message-Id: <20260312175243.1593864-7-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260312175243.1593864-1-yeoreum.yun@arm.com>
References: <20260312175243.1593864-1-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The purpose of supporting LSUI is to eliminate PAN toggling.
CPUs that support LSUI are unlikely to support a 32-bit runtime.
Since environments that support both LSUI and
a 32-bit runtimeare expected to be extremely rare,
not to emulate the SWP instruction using LSUI instructions
in order to remove PAN toggling, and instead simply disable SWP emulation.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/arm64/kernel/armv8_deprecated.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/kernel/armv8_deprecated.c b/arch/arm64/kernel/armv8_deprecated.c
index e737c6295ec7..049754f7da36 100644
--- a/arch/arm64/kernel/armv8_deprecated.c
+++ b/arch/arm64/kernel/armv8_deprecated.c
@@ -610,6 +610,22 @@ static int __init armv8_deprecated_init(void)
 	}
 
 #endif
+
+#ifdef CONFIG_SWP_EMULATION
+	/*
+	 * The purpose of supporting LSUI is to eliminate PAN toggling.
+	 * CPUs that support LSUI are unlikely to support a 32-bit runtime.
+	 * Since environments that support both LSUI and a 32-bit runtime
+	 * are expected to be extremely rare, we choose not to emulate
+	 * the SWP instruction using LSUI instructions in order to remove PAN toggling,
+	 * and instead simply disable SWP emulation.
+	 */
+	if (cpus_have_final_cap(ARM64_HAS_LSUI)) {
+		insn_swp.status = INSN_UNAVAILABLE;
+		pr_info("swp/swpb instruction emulation is not supported on this system\n");
+	}
+#endif
+
 	for (int i = 0; i < ARRAY_SIZE(insn_emulations); i++) {
 		struct insn_emulation *ie = insn_emulations[i];
 
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}

