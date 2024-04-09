Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA9228379
	for <kvmarm@lists.linux.dev>; Tue,  9 Apr 2024 01:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712626204; cv=none; b=rWbUSvhtC+J5yX/XaqoyvJAQwgqDh0GXXwz1yenqcELpXn+xFNuNxtwr3mmoITRshuKWRmElbr9ErxVwPW/uMIGzY6RT0kiMRd+ZG+w+6wNPTsJHmMeZWird5JeDpTiU3JFKG3HCfjrWy23x5rHN6jSWrf/ZzJf2OXU7Y4O/xCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712626204; c=relaxed/simple;
	bh=OjZmqpTC2ehTHN8Sd68worBXYXZg9Jpv/26xY6sXNS0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XWva5gEoNd39d6y/hrOhQ1oFhsG3feH2rXFkDAQxuVe5zNdZRsU6/uofIzNvGf9T0q94P0bmq0pG8eeRceiYcMsdFe57GFd7X4RqNiUeabSWUCXxZ+CnLfVjTg5B04pCRrSnSp/T47tcJxvpA/XdU+hfMgS93ptiyyezyeL86h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4VD7cf02b2zNn6P;
	Tue,  9 Apr 2024 09:27:46 +0800 (CST)
Received: from kwepemd200013.china.huawei.com (unknown [7.221.188.133])
	by mail.maildlp.com (Postfix) with ESMTPS id 8CEAC18007D;
	Tue,  9 Apr 2024 09:30:00 +0800 (CST)
Received: from huawei.com (10.67.174.28) by kwepemd200013.china.huawei.com
 (7.221.188.133) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.28; Tue, 9 Apr
 2024 09:29:59 +0800
From: Liao Chang <liaochang1@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <james.morse@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <tglx@linutronix.de>, <mark.rutland@arm.com>,
	<ardb@kernel.org>, <broonie@kernel.org>, <liaochang1@huawei.com>,
	<anshuman.khandual@arm.com>, <miguel.luis@oracle.com>, <joey.gouly@arm.com>,
	<ryan.roberts@arm.com>, <jeremy.linton@arm.com>, <liwei391@huawei.com>,
	<daniel.thompson@linaro.org>, <sumit.garg@linaro.org>,
	<kristina.martsenko@arm.com>, <jpoimboe@kernel.org>, <ericchancf@google.com>,
	<robh@kernel.org>, <scott@os.amperecomputing.com>,
	<songshuaishuai@tinylab.org>, <shijie@os.amperecomputing.com>,
	<bhe@redhat.com>, <akpm@linux-foundation.org>, <thunder.leizhen@huawei.com>,
	<horms@kernel.org>, <rmk+kernel@armlinux.org.uk>, <takakura@valinux.co.jp>,
	<dianders@chromium.org>, <swboyd@chromium.org>, <frederic@kernel.org>,
	<reijiw@google.com>, <akihiko.odaki@daynix.com>, <ruanjinjie@huawei.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>
Subject: [PATCH 4/9] arm64/cpufeature: Simplify detect PE support for FEAT_NMI
Date: Tue, 9 Apr 2024 01:23:39 +0000
Message-ID: <20240409012344.3194724-5-liaochang1@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240409012344.3194724-1-liaochang1@huawei.com>
References: <20240409012344.3194724-1-liaochang1@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemd200013.china.huawei.com (7.221.188.133)

From: Jinjie Ruan <ruanjinjie@huawei.com>

Simplify the Non-maskable Interrupts feature implementation with
ARM64_CPUID_FIELDS macro.

Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
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

