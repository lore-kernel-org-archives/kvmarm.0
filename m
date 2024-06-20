Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446491A8C1B
	for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 13:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718888835; cv=none; b=FWs527Mxa2jaGOMRO8mzuXFNifn3O053nAoScj5TflGyuei+i2CIXOYTcznUzfBw4oWyKPW0VrlBf4R+0YIGY6D1SFdUmUxcoCXYtw3ZOR/b6dmrrR4S2g6cFEsMQ2STH07VM7IIbDUjYCA6gv5LjlSIpVBZBn3zZ22LkZYQSdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718888835; c=relaxed/simple;
	bh=yU+NK/hGkNIL5mdmNjeIBzA2t0+seLswRXbJo9rHSg4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PiJbpJKnpuBoJIdnD6msmoQvBPSKTHK3aNuTaSj4Z72KrXU1tNGXusixsms1r+SUhOqnbjYNW3wjXsgGdQUGP5QZr8ABzeW9gW/mfK6KcYSfN3S5YjBoiawlk+0MgnP6QxT7TAEwpIlsL7fK2G/4nIfr0wKz46gC/UOig2300m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4W4gdR05q0z1N8Pj;
	Thu, 20 Jun 2024 21:02:51 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 4FFDE18007E;
	Thu, 20 Jun 2024 21:07:07 +0800 (CST)
Received: from DESKTOP-6NKE0BC.china.huawei.com (10.174.185.210) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 21:07:06 +0800
From: Kunkun Jiang <jiangkunkun@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Eric
 Auger <eauger@redhat.com>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<wanghaibin.wang@huawei.com>, Kunkun Jiang <jiangkunkun@huawei.com>,
	<lishusen2@huawei.com>
Subject: [PATCH 0/3] KVM: arm64: vgic-its: Some fixes about vgic-its
Date: Thu, 20 Jun 2024 21:06:47 +0800
Message-ID: <20240620130650.1279-1-jiangkunkun@huawei.com>
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

Kunkun Jiang (3):
  KVM: arm64: vgic-its: Add a data length check in vgic_its_save_*
  KVM: arm64: vgic-its: Clear dte when mapd unmaps a device
  KVM: arm64: vgic-its: Clear ite when discard frees an ite

 arch/arm64/kvm/vgic/vgic-its.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

-- 
2.33.0

