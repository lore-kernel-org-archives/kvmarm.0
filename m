Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA0562F9997
	for <kvmarm@lists.linux.dev>; Sat, 16 Aug 2025 15:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755357584; cv=none; b=QOwMgWTTMDZkfVb8pgyWw46QumOzKHVAw0+SUzeALlfSaeD4kPGD0t97O5S3m9+61JknEiEFyCj941Z2lKWvxs/Wi5pbMRl+jgBJ2bMTNBJbnmAvYoJSMn3GA+faLsCPi0HlsRMAQ+9bq/HAUVlgLNvrcB4yYKjnPtyzIwnNv7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755357584; c=relaxed/simple;
	bh=mWlaHIYFvrbjnse489cRguLYnlB/L5WCvjGWIOCmJZo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sm7viUiyF+8VFA/wvvsGfJJuVY5c6FgMzoQlQbEYeNx5ZXkvYUh+cOHpCUlil395v9uKN+5fQZEdgv82K1X14rHVfyYtrul59/v9BaC1kMh4eAbDvsT9o9c3OXH7Ux3T3rIpq8sfb55ZlKwmMKcHaOniJy+q1MlXFjqIlwWEWrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DEEA71F60;
	Sat, 16 Aug 2025 08:19:33 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CEF0F3F5A1;
	Sat, 16 Aug 2025 08:19:39 -0700 (PDT)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	broonie@kernel.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	james.morse@arm.com,
	ardb@kernel.org,
	scott@os.amperecomputing.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	mark.rutland@arm.com
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH RESEND v7 3/6] arm64: Kconfig: add LSUI Kconfig
Date: Sat, 16 Aug 2025 16:19:26 +0100
Message-Id: <20250816151929.197589-4-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250816151929.197589-1-yeoreum.yun@arm.com>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since Armv9.6, FEAT_LSUI supplies the load/store instructions for
previleged level to access to access user memory without clearing
PSTATE.PAN bit.
It's enough to add CONFIG_AS_HAS_LSUI only because the code for LSUI uses
individual `.arch_extension` entries.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/arm64/Kconfig | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e9bbfacc35a6..c474de3dce02 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2239,6 +2239,11 @@ config ARM64_GCS

 endmenu # "v9.4 architectural features"

+config AS_HAS_LSUI
+	def_bool $(as-instr,.arch_extension lsui)
+	help
+	 Supported by LLVM 20 and later, not yet supported by GNU AS.
+
 config ARM64_SVE
 	bool "ARM Scalable Vector Extension support"
 	default y
--
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}

