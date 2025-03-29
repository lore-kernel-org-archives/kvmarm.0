Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FE115A8
	for <kvmarm@lists.linux.dev>; Sat, 29 Mar 2025 03:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743219841; cv=none; b=BOyvCOq317114UyTnV6wK0Y2PRya+iDGfeGKq/6WWYbzRf4Z+URbIW+y/ipeO6VK1YBQMMJKkv+WBFOjuiF+8cviDclEV+f/YhQ80ylX/aRFNsHBjHTY2GNcmFj79DYa8nj93pyqdbvg6jAKzBisXNtGqxWzPcdww/L6vaEUrmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743219841; c=relaxed/simple;
	bh=9elbt7weZmFkOosml65VxFSBSYiqINUcJ8bQI3/Le+s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ItY6yF5oNlcXy6XK/5BeukgclQkRl/i71Sp4EJtRoKE9ZTmxOyYjtq/G/jFvjxE7ucloLaJO6OCUDPZjhCqLRHsbMwPus7LECnynqtdoO6x0c2UVQ2Q+ST9RBkyLT1rXgVr7C27JBhwsAM+RICBVzcLNohBSCB71WFrrRZo4lYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4ZPjmw5W58z1jBWW;
	Sat, 29 Mar 2025 11:39:12 +0800 (CST)
Received: from kwepemd200014.china.huawei.com (unknown [7.221.188.8])
	by mail.maildlp.com (Postfix) with ESMTPS id 7528A14013B;
	Sat, 29 Mar 2025 11:43:55 +0800 (CST)
Received: from localhost.localdomain (10.50.165.33) by
 kwepemd200014.china.huawei.com (7.221.188.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Sat, 29 Mar 2025 11:43:54 +0800
From: Yicong Yang <yangyicong@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>
CC: <joey.gouly@arm.com>, <suzuki.poulose@arm.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>,
	<prime.zeng@hisilicon.com>, <xuwei5@huawei.com>, <yangyicong@hisilicon.com>,
	<linuxarm@huawei.com>
Subject: [PATCH 1/3] arm64/cpufeature: Add missing id_aa64mmfr4 feature reg update
Date: Sat, 29 Mar 2025 11:44:07 +0800
Message-ID: <20250329034409.21354-2-yangyicong@huawei.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20250329034409.21354-1-yangyicong@huawei.com>
References: <20250329034409.21354-1-yangyicong@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemd200014.china.huawei.com (7.221.188.8)

From: Yicong Yang <yangyicong@hisilicon.com>

Add missing id_aa64mmfr4 feature register check and update in
update_cpu_features(). Update the taint status as well.

Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
---
 arch/arm64/kernel/cpufeature.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9c4d6d552b25..75ef319c1ef8 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1403,6 +1403,8 @@ void update_cpu_features(int cpu,
 				      info->reg_id_aa64mmfr2, boot->reg_id_aa64mmfr2);
 	taint |= check_update_ftr_reg(SYS_ID_AA64MMFR3_EL1, cpu,
 				      info->reg_id_aa64mmfr3, boot->reg_id_aa64mmfr3);
+	taint |= check_update_ftr_reg(SYS_ID_AA64MMFR4_EL1, cpu,
+				      info->reg_id_aa64mmfr4, boot->reg_id_aa64mmfr4);
 
 	taint |= check_update_ftr_reg(SYS_ID_AA64PFR0_EL1, cpu,
 				      info->reg_id_aa64pfr0, boot->reg_id_aa64pfr0);
-- 
2.24.0

