Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F8852FFF86
	for <kvmarm@lists.linux.dev>; Mon, 22 Sep 2025 10:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758536579; cv=none; b=dXwn/dxmzUpKoBBBT/d4+cHUgGT3r/YEcQQOBiY2YDvb2c2wI4NPQE8/hLzPt0JOviesWgP4C7T48qe22d6EwRGB7ph/DZ99nTA3sXu/Tavok/ybR0Ght47WCOMfhcCQZKfo0T4j8OGcUhR2/erPS1B69EOhlFnn+y9flGfeNbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758536579; c=relaxed/simple;
	bh=BhyM3yAonv/2/TCHGeyE8EMSG3cRlk4qFoT3wlB3Wk0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GRyZOqhA4j729zacs89My2mycEUYkD+I6ES88pUkOGvwCWbm1apD6s0NLjyfXhg3WB4lkIjFS8amMfMWQJWkCJEwyB8cFIuEQRWjrAtcQFe1uPYnFwCRLFabXBT4W3bGPX7jr3OfHlTdNaxf6xpD5iel0AbEbC8uCssP3zg9CJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9134014BF;
	Mon, 22 Sep 2025 03:22:49 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7AEDE3F66E;
	Mon, 22 Sep 2025 03:22:55 -0700 (PDT)
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
Subject: [PATCH v9 3/5] arm64: Kconfig: Detect toolchain support for LSUI
Date: Mon, 22 Sep 2025 11:22:42 +0100
Message-Id: <20250922102244.2068414-4-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250922102244.2068414-1-yeoreum.yun@arm.com>
References: <20250922102244.2068414-1-yeoreum.yun@arm.com>
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
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/Kconfig | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e9bbfacc35a6..89a1a3771ed5 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2239,6 +2239,11 @@ config ARM64_GCS
 
 endmenu # "v9.4 architectural features"
 
+config AS_HAS_LSUI
+	def_bool $(as-instr,.arch_extension lsui)
+	help
+	  Supported by LLVM 20+ and binutils 2.45+.
+
 config ARM64_SVE
 	bool "ARM Scalable Vector Extension support"
 	default y
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}

