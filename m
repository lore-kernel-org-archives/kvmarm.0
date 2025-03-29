Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F2018C31
	for <kvmarm@lists.linux.dev>; Sat, 29 Mar 2025 03:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743219846; cv=none; b=NttOPAlyFCG1Yu3UkWkcEwAenLII84kDxkbM6RqgEsZonoVv7rJ9eUB+LQfOpUGsT16wLvodDiuZ51f6M7S/PjIuxkADxok9rOdBRWcX6ojC6MS53mSeGZoKaUKPkCHp0AFHxNuFH1XvO3mIJhzzezcJSuc8dzQi/Gp5ItogQXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743219846; c=relaxed/simple;
	bh=xtKfgoGun25Tm9HuLG8LNhKA2JzsEcm3Tkw2l8Edf8Y=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZaWX8e2jRUOsIYL4La5ksODIxFNQc6VnPabAwh8/AesKXtDjXG5g79g773HXQCCogkT7v6i3qICYpfJi0++Tlbp1paYOlw1NSCWZGpekl2BHACmHLwDiTfzloJMcqBuZTrCNw3kkAWlfxIFJLTHPXBd7LN76lUucJW8x6GvW+A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4ZPjpX3TPJzHrJb;
	Sat, 29 Mar 2025 11:40:36 +0800 (CST)
Received: from kwepemd200014.china.huawei.com (unknown [7.221.188.8])
	by mail.maildlp.com (Postfix) with ESMTPS id E42E91800B4;
	Sat, 29 Mar 2025 11:43:54 +0800 (CST)
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
Subject: [PATCH 0/3] Two minor fixups around FEAT_E2H0
Date: Sat, 29 Mar 2025 11:44:06 +0800
Message-ID: <20250329034409.21354-1-yangyicong@huawei.com>
X-Mailer: git-send-email 2.31.0
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

Two minor fixups for the FEAT_E2H0:
1) add missing feature register update
2) fix boot warning with kvm-arm.mode=nvhe if !FEAT_E2H0

Add a cpucap identify the HCR_EL2.E2H RES1 (!FEAT_E2H0) support.

Yicong Yang (3):
  arm64/cpufeature: Add missing id_aa64mmfr4 feature reg update
  arm64/cpufeature: Add cpucap for HCR_EL2.E2H RES1 (!FEAT_E2H0)
  KVM: arm64: Fix boot warning with kvm-arm.mode=nvhe on !FEAT_E2H0
    platforms

 arch/arm64/include/asm/cpufeature.h | 23 +++++++++++++++++++++++
 arch/arm64/kernel/cpufeature.c      | 14 ++++++++++++++
 arch/arm64/kvm/arm.c                | 14 +++++++++++---
 arch/arm64/tools/cpucaps            |  1 +
 4 files changed, 49 insertions(+), 3 deletions(-)

-- 
2.24.0

