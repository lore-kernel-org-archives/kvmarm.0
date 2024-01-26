Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3C514A90
	for <kvmarm@lists.linux.dev>; Fri, 26 Jan 2024 10:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706265041; cv=none; b=s52h6hdnATxjoPJKq5JBuhk21KARZS5iaJV89zeTOEzWS0a8YmS8b7Cg42N9r5D4f392Vtm8KcX/N/5bf9NyhFYvZ5DKAyruAKHNM0kwAWu3WItnBsVRuUm615m8cGgqHrikM7nMnyQK5z/j4zgZ/BhAQeaS5HQV2NuU56wXJm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706265041; c=relaxed/simple;
	bh=NKPNx5MCX0F2NvzOk6iFTbsUF/eOQIo5oNZt0SrM0iQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=e16SuKQQW4dCXCkoroOp8I+0+3ZwYH/JM5SHELZ8IKmDLdq1rzOODCxsDXFrU0n8IEI/QUO9xmuivL2U6Xa7Md3XEEQEYeiQZHu5HOvh53zv6CyGBrmEpoNnasRy+vsthfLxRQjeUgFgWl8lPhn7L08xaj0JZHQFY894wc1RSFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4TLv7t62QYzsW7W;
	Fri, 26 Jan 2024 18:29:30 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 4A4CC140136;
	Fri, 26 Jan 2024 18:30:36 +0800 (CST)
Received: from DESKTOP-6NKE0BC.china.huawei.com (10.174.185.210) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 26 Jan 2024 18:30:35 +0800
From: Kunkun Jiang <jiangkunkun@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Thomas Gleixner <tglx@linutronix.de>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<wanghaibin.wang@huawei.com>, Kunkun Jiang <jiangkunkun@huawei.com>
Subject: [PATCH v2 0/2] irqchip/gic-v4.1: Two bugfixes about doorbell affinity
Date: Fri, 26 Jan 2024 18:30:10 +0800
Message-ID: <20240126103012.1020-1-jiangkunkun@huawei.com>
X-Mailer: git-send-email 2.26.2.windows.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600007.china.huawei.com (7.193.23.208)

There are two bugs in current doorbell affinity settings. May cause lost
interrupts. See the patches commit message for details.

Kunkun Jiang (2):
  irqchip/gic-v4.1: Fix GICv4.1 doorbell affinity
  irqchip/gic-v4.1: Fix skipping VMOVP in cpu offline scenario

 drivers/irqchip/irq-gic-v3-its.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

-- 
2.33.0

