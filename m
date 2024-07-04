Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8A71AEFF5
	for <kvmarm@lists.linux.dev>; Thu,  4 Jul 2024 14:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720103022; cv=none; b=TsuagY+zvfoyx08MES6ohZJyXhaXPfNSCL3/J2CwvO+FVtHF160a4EoNiFHIQaHDpTvEHxBJQ6q0XvM9/HGal4exeuEIVpopsl9bAn5GqO4yARgp/EqIm/oIpYGpJqyvOGregix9BT8ZIvAsbMk0dk9jTXHoB+/ejLTbjWi5wxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720103022; c=relaxed/simple;
	bh=RT3mJZEAgfpch2Yq2V63FKefWF0svb9Qp7L/VMNA+y8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hZQrJYo2Vsttx45Bp+sBNKX2nAnJKg1u50xW/SXlSXmvJO9HmNOyFdeXZyuuKqIhdaBOk6MoWv/RCMdr6V+tazgZJJ6+OC96OM0FytprKgaENHn355uTkd6HuVYQ2Q3l2z7Afl8oA/mJUbO1nLSBufaq16JWXDxSPXVJL+9ONJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4WFJgl0ZsJzQkHK;
	Thu,  4 Jul 2024 22:19:47 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 73CC4180087;
	Thu,  4 Jul 2024 22:23:36 +0800 (CST)
Received: from DESKTOP-6NKE0BC.china.huawei.com (10.174.185.210) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 4 Jul 2024 22:23:35 +0800
From: Kunkun Jiang <jiangkunkun@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Eric
 Auger <eauger@redhat.com>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<wanghaibin.wang@huawei.com>, Kunkun Jiang <jiangkunkun@huawei.com>,
	<lishusen2@huawei.com>, <tangnianyao@huawei.com>
Subject: [PATCH v2 0/3] KVM: arm64: vgic-its: Some fixes about vgic-its
Date: Thu, 4 Jul 2024 22:23:16 +0800
Message-ID: <20240704142319.728-1-jiangkunkun@huawei.com>
X-Mailer: git-send-email 2.26.2.windows.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600007.china.huawei.com (7.193.23.208)

There are three fixes about vgic-its:
Patch 1: A data length check is added in vgic_its_save_*
Patch 2-3: Fix two bugs in the scenario of continuous save and restore

History:
v1 -> v2:
- Replaced BUG_ON() with KVM_BUG_ON()

Kunkun Jiang (3):
  KVM: arm64: vgic-its: Add a data length check in vgic_its_save_*
  KVM: arm64: vgic-its: Clear dte when mapd unmaps a device
  KVM: arm64: vgic-its: Clear ite when discard frees an ite

 arch/arm64/kvm/vgic/vgic-its.c | 44 ++++++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 4 deletions(-)

-- 
2.27.0

