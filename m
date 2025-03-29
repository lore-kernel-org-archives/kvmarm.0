Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FED487BE
	for <kvmarm@lists.linux.dev>; Sat, 29 Mar 2025 03:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743219846; cv=none; b=lBG17LbkKZZZz0ceu+7E2z4Sk8xJUytXSvaufb80D68DAYkSRn1oxkiQsuqcLt37Se+u/ICmiSCjp7QsAbrWLNxtlsrg4oJg1VUbdLxseHcvMZsJu3QxebWP/b1XcSIxEM6NReVn5lNmPR1Jrn8u74+DYH3AjZAEEi+DTaM+FJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743219846; c=relaxed/simple;
	bh=2tVhtjsD8XqDHEIJNK/TemcG8jZhuED8EMK3pWJGEJI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lg5jhQ3Pg4RfjeVi3HcLG6y0IVoZteiPdbjOIc0VSgpBy5ZhIci0IIwlhM4mnC1mY+NydXdC1cE0o/kk2A5xxd2VmmuHm8LkDGrDz4lb4ZGyxh5wJRCeyOxkNJwyT7iMqNtDwLKPTsJetpstVwhozFkuefazolu2zGozlv0aAh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4ZPjst2Phbz1d0y5;
	Sat, 29 Mar 2025 11:43:30 +0800 (CST)
Received: from kwepemd200014.china.huawei.com (unknown [7.221.188.8])
	by mail.maildlp.com (Postfix) with ESMTPS id 773A41800B4;
	Sat, 29 Mar 2025 11:43:56 +0800 (CST)
Received: from localhost.localdomain (10.50.165.33) by
 kwepemd200014.china.huawei.com (7.221.188.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Sat, 29 Mar 2025 11:43:55 +0800
From: Yicong Yang <yangyicong@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>
CC: <joey.gouly@arm.com>, <suzuki.poulose@arm.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>,
	<prime.zeng@hisilicon.com>, <xuwei5@huawei.com>, <yangyicong@hisilicon.com>,
	<linuxarm@huawei.com>
Subject: [PATCH 3/3] KVM: arm64: Fix boot warning with kvm-arm.mode=nvhe on !FEAT_E2H0 platforms
Date: Sat, 29 Mar 2025 11:44:09 +0800
Message-ID: <20250329034409.21354-4-yangyicong@huawei.com>
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

If platforms don't support FEAT_E2H0, HCR_EL2.E2H is RES1 and nVHE is
not available. The warning in early_kvm_mode_cfg() will be triggered
if boot with kvm-arm.mode=nvhe and no indication for this. Fix this by
skipping the non-VHE checking on !FEAT_E2H0 platform.

Since this should only affect the "nvhe" mode, move "nested" mode check
ahead to avoid being affected.

Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
---
 arch/arm64/kvm/arm.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 68fec8c95fee..a0c0bd936a53 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2905,6 +2905,11 @@ static int __init early_kvm_mode_cfg(char *arg)
 		return 0;
 	}
 
+	if (strcmp(arg, "nested") == 0 && !WARN_ON(!is_kernel_in_hyp_mode())) {
+		kvm_mode = KVM_MODE_NV;
+		return 0;
+	}
+
 	if (strcmp(arg, "protected") == 0) {
 		if (!is_kernel_in_hyp_mode())
 			kvm_mode = KVM_MODE_PROTECTED;
@@ -2914,13 +2919,16 @@ static int __init early_kvm_mode_cfg(char *arg)
 		return 0;
 	}
 
-	if (strcmp(arg, "nvhe") == 0 && !WARN_ON(is_kernel_in_hyp_mode())) {
+	/* If system doesn't support FEAT_E2H0, nVHE host is not available */
+	if (cpu_has_e2h_res1()) {
+		WARN_ON(!is_kernel_in_hyp_mode());
 		kvm_mode = KVM_MODE_DEFAULT;
+		pr_warn_once("FEAT_E2H0 not supported. Ignoring kvm-arm.mode\n");
 		return 0;
 	}
 
-	if (strcmp(arg, "nested") == 0 && !WARN_ON(!is_kernel_in_hyp_mode())) {
-		kvm_mode = KVM_MODE_NV;
+	if (strcmp(arg, "nvhe") == 0 && !WARN_ON(is_kernel_in_hyp_mode())) {
+		kvm_mode = KVM_MODE_DEFAULT;
 		return 0;
 	}
 
-- 
2.24.0

