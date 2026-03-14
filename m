Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B069347BA7
	for <kvmarm@lists.linux.dev>; Sat, 14 Mar 2026 17:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773510721; cv=none; b=pip7+K2DyOMVqlcvy1/NtirypLWBLIFDSI9mNlVYTaTUtmAd18tq6LL3wdxhpmo2zs6gr9PoBdyahILs32TZYFdKdXWPfiF3W/sS6V2WI2DhB/Jtj/buS3rrtYgA3JgAwj0AdL1cENofolY0DoMQ5Z7ofNYr5YHCMpXST7x4aLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773510721; c=relaxed/simple;
	bh=iGDW5vhq3Q6kZFtorZ0MiHnTnFizA2hhJE+6ztz9Y9Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l7rxCcAdifG9Az08ZTGSKA7oggcbAfQrQ6gKGhGbWahch/bslVj5V0pnRDZmek84Sf25jkEEScr8fl5N3159REFd8K5By13phSazotlSLucPsChrC7+XcpwX2C3xOcdbMAhn/o9GM+6siMYMjv1cn1tHTKBwR7K4I0aMqaX02pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D2CA9152B;
	Sat, 14 Mar 2026 10:51:53 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7E58B3F73B;
	Sat, 14 Mar 2026 10:51:57 -0700 (PDT)
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
Subject: [PATCH v17 8/8] arm64: Kconfig: add support for LSUI
Date: Sat, 14 Mar 2026 17:51:33 +0000
Message-Id: <20260314175133.1084528-9-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260314175133.1084528-1-yeoreum.yun@arm.com>
References: <20260314175133.1084528-1-yeoreum.yun@arm.com>
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

Add Kconfig option entry for FEAT_LSUI.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/Kconfig | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 38dba5f7e4d2..890a1bedbf4a 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2215,6 +2215,26 @@ config ARM64_GCS
 
 endmenu # "ARMv9.4 architectural features"
 
+config AS_HAS_LSUI
+	def_bool $(as-instr,.arch_extension lsui)
+	help
+	  Supported by LLVM 20+ and binutils 2.45+.
+
+menu "ARMv9.6 architectural features"
+
+config ARM64_LSUI
+	bool "Support Unprivileged Load Store Instructions (LSUI)"
+	default y
+	depends on AS_HAS_LSUI && !CPU_BIG_ENDIAN
+	help
+	  The Unprivileged Load Store Instructions (LSUI) provides
+	  variants load/store instructions that access user-space memory
+	  from the kernel without clearing PSTATE.PAN bit.
+
+	  This feature is supported by LLVM 20+ and binutils 2.45+.
+
+endmenu # "ARMv9.6 architectural feature"
+
 config ARM64_SVE
 	bool "ARM Scalable Vector Extension support"
 	default y
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}

