Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB9D23A980
	for <kvmarm@lists.linux.dev>; Wed,  2 Apr 2025 13:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743601508; cv=none; b=soNfq52o2oeJOadyUb+2ige2FC17B8u6X9ktqW/MLuO0txuYJv/6f8XAafx6NHlLa/q97WnxY0hNy8VHfKejHKsctVIkLDJjgm6bZxljaO0SLLt6Z9q/XZTK2mIaR7elh4iwZGwL9kKWfRasutcXiMYKJmtGnCvVCekWovoqhko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743601508; c=relaxed/simple;
	bh=sTRLlDut0NE0rxGw8O3zmmuspwpenBHKz76wLbnjUYM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GrXxcqI6c0KeMrA05mAh8jX/lYzMmJbW9Glhw4g49R6VrE9SQrkbEnojhGadGtBpnorAFKFlmBvNnhGCV5+DXvlDcZ5kzoF1ULyEjfgy7MnrV7PPfkzyZcFKNRyJWErvrP9fRZKVjWdRJbU7LwGtddr8/RwOYa4wz5Q57bAQMvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ZSQxx275yz6M4lj;
	Wed,  2 Apr 2025 21:41:25 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 2C6391406AD;
	Wed,  2 Apr 2025 21:45:04 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.48.153.182) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 2 Apr 2025 15:44:59 +0200
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<oliver.upton@linux.dev>
CC: <maz@kernel.org>, <mark.rutland@arm.com>, <lpieralisi@kernel.org>,
	<sudeep.holla@arm.com>, <catalin.marinas@arm.com>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] smccc/kvm_guest: Remove the accidental semicolon
Date: Wed, 2 Apr 2025 14:44:01 +0100
Message-ID: <20250402134401.146156-1-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 frapeml500008.china.huawei.com (7.182.85.71)

Fixes cocci reported warning:Unneeded semicolon

Fixes: 86edf6bdcf05 ("smccc/kvm_guest: Enable errata based on implementation CPUs")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202504020941.VEeL6nVJ-lkp@intel.com/
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 drivers/firmware/smccc/kvm_guest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/smccc/kvm_guest.c b/drivers/firmware/smccc/kvm_guest.c
index 5767aed25cdc..ffe9f3c013df 100644
--- a/drivers/firmware/smccc/kvm_guest.c
+++ b/drivers/firmware/smccc/kvm_guest.c
@@ -103,7 +103,7 @@ void  __init kvm_arm_target_impl_cpu_init(void)
 		target[i].midr = res.a1;
 		target[i].revidr = res.a2;
 		target[i].aidr = res.a3;
-	};
+	}
 
 	if (!cpu_errata_set_target_impl(max_cpus, target)) {
 		pr_warn("Failed to set target implementation CPUs\n");
-- 
2.47.0

