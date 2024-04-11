Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056BA13DDC3
	for <kvmarm@lists.linux.dev>; Thu, 11 Apr 2024 06:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712818524; cv=none; b=ekLyqS6H2NvIuMIdFgz4FcLgpdu9Qwxf2sd6ZR5Mmsb91LAtuy3T8tqwzWg1R6TFzr0UFu6dhrrwPGJSaH0cA4nD9QPEAmByKpUtmCyW5R3hm1MXC5jswRPcRHO+ruo5grH+kzqIUhXtxlMW4UcYpXU8PIWIbFz6nQxZFi2UFu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712818524; c=relaxed/simple;
	bh=vRaAWJBmEkfrKydlBrm0tEA+Ytbuvo+lXPgTBsQ0fvA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ib36SWGz6cxuaR8+AfEBpsw1Sj/GWovey9Cg25aQTMQaGaGlAFq05rr3Y5Jrbwlf1/Tj/hlKvSO3N57cAf/bOrQUy/cVniBl8dYDa2YEbS3NASdB+IqG2492dXIOIzcqXRgcMuesLm8WYTV5Cd8U4l2wMLBz4A2UBptQzLCAhXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4VFVk14F7szXlLJ;
	Thu, 11 Apr 2024 14:52:09 +0800 (CST)
Received: from kwepemd200013.china.huawei.com (unknown [7.221.188.133])
	by mail.maildlp.com (Postfix) with ESMTPS id 1A7D9140E9F;
	Thu, 11 Apr 2024 14:55:19 +0800 (CST)
Received: from huawei.com (10.67.174.28) by kwepemd200013.china.huawei.com
 (7.221.188.133) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.28; Thu, 11 Apr
 2024 14:55:17 +0800
From: Liao Chang <liaochang1@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <james.morse@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <tglx@linutronix.de>, <mark.rutland@arm.com>,
	<ardb@kernel.org>, <broonie@kernel.org>, <liaochang1@huawei.com>,
	<anshuman.khandual@arm.com>, <miguel.luis@oracle.com>, <joey.gouly@arm.com>,
	<ryan.roberts@arm.com>, <jeremy.linton@arm.com>,
	<daniel.thompson@linaro.org>, <sumit.garg@linaro.org>, <liwei391@huawei.com>,
	<peterz@infradead.org>, <jpoimboe@kernel.org>, <ericchancf@google.com>,
	<kristina.martsenko@arm.com>, <robh@kernel.org>,
	<scott@os.amperecomputing.com>, <songshuaishuai@tinylab.org>,
	<shijie@os.amperecomputing.com>, <bhe@redhat.com>,
	<akpm@linux-foundation.org>, <horms@kernel.org>,
	<rmk+kernel@armlinux.org.uk>, <Jonathan.Cameron@huawei.com>,
	<takakura@valinux.co.jp>, <dianders@chromium.org>, <swboyd@chromium.org>,
	<frederic@kernel.org>, <reijiw@google.com>, <ruanjinjie@huawei.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>
Subject: [PATCH v2 4/9] arm64/cpufeature: Simplify detect PE support for FEAT_NMI
Date: Thu, 11 Apr 2024 06:48:53 +0000
Message-ID: <20240411064858.3232574-5-liaochang1@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240411064858.3232574-1-liaochang1@huawei.com>
References: <20240411064858.3232574-1-liaochang1@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemd200013.china.huawei.com (7.221.188.133)

From: Jinjie Ruan <ruanjinjie@huawei.com>

Simplify the Non-maskable Interrupts feature implementation with
ARM64_CPUID_FIELDS macro.

Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Liao Chang <liaochang1@huawei.com>
---
 arch/arm64/kernel/cpufeature.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index fb9e52c84fda..99c3bc74008d 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2905,24 +2905,16 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.desc = "Non-maskable Interrupts present",
 		.capability = ARM64_HAS_NMI,
 		.type = ARM64_CPUCAP_BOOT_CPU_FEATURE,
-		.sys_reg = SYS_ID_AA64PFR1_EL1,
-		.sign = FTR_UNSIGNED,
-		.field_pos = ID_AA64PFR1_EL1_NMI_SHIFT,
-		.field_width = 4,
-		.min_field_value = ID_AA64PFR1_EL1_NMI_IMP,
 		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS(ID_AA64PFR1_EL1, NMI, IMP)
 	},
 	{
 		.desc = "Non-maskable Interrupts enabled",
 		.capability = ARM64_USES_NMI,
 		.type = ARM64_CPUCAP_BOOT_CPU_FEATURE,
-		.sys_reg = SYS_ID_AA64PFR1_EL1,
-		.sign = FTR_UNSIGNED,
-		.field_pos = ID_AA64PFR1_EL1_NMI_SHIFT,
-		.field_width = 4,
-		.min_field_value = ID_AA64PFR1_EL1_NMI_IMP,
 		.matches = use_nmi,
 		.cpu_enable = nmi_enable,
+		ARM64_CPUID_FIELDS(ID_AA64PFR1_EL1, NMI, IMP)
 	},
 #endif
 	{},
-- 
2.34.1

