Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79F2340D9D
	for <kvmarm@lists.linux.dev>; Fri, 21 Nov 2025 09:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763717031; cv=none; b=S4KG2ZYq0J9g/Sabwv5aZ3VaoNcjKo/z54HE31feQ6yC+Qua9aMpLLPm6q1atuMdp6foM/pFZABMtTT97Y0FdsOLxzm5zk4oytpRQIrRitWWboutNvUAXQqKV87rRmyzSAGDEybRBL/V9EloJSEmAzUaxpNMD4eaH0WbNBUJGE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763717031; c=relaxed/simple;
	bh=UrY+pCES8Lr8ar4CYQXHO9RG4hQV+PjFmGgWq4oPIAA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u4FiUeC4z1UqP/kTMUfRtqmKUKCM6Maoo7lXnBQbXmbgyIgCfLXqmRzlmEszJOaAjIOYZungKYPgzYHXFCVIvAOvMYqez56WOovBfVqe0XpGTUhQRM4FcTd9yGKUCIQcFG9ix4RcD6RoSpLVtIZx/DI4UDZ0AceUtqOW7sp9ZDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=JEy7kf+6; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="JEy7kf+6"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=UrY+pCES8Lr8ar4CYQXHO9RG4hQV+PjFmGgWq4oPIAA=;
	b=JEy7kf+6F/tBqxGKMOknAV8OX/p+URTD23jg7dHml3kKmPLxmWb7Q3OnpmdoOkZ+jXnAhxHe4
	r6wP+AJNXuTiYE+3it6noIqKNu2gqN2hHYsgSlhxPqOMlYYyxdC7exPJXl7wm94Yp2vdfhHoeKv
	MqwohDLKTjAXmoxMMMhW5Ao=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dCV9418fTzKmWx;
	Fri, 21 Nov 2025 17:22:00 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id B206614022D;
	Fri, 21 Nov 2025 17:23:45 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 21 Nov
 2025 17:23:44 +0800
From: Tian Zheng <zhengtian10@huawei.com>
To: <maz@kernel.org>, <oliver.upton@linux.dev>, <catalin.marinas@arm.com>,
	<corbet@lwn.net>, <pbonzini@redhat.com>, <will@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <zhengtian10@huawei.com>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <yezhenyu2@huawei.com>,
	<xiexiangyou@huawei.com>, <zhengchuan@huawei.com>, <linuxarm@huawei.com>,
	<joey.gouly@arm.com>, <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
	<suzuki.poulose@arm.com>
Subject: [PATCH v2 5/5] KVM: arm64: Document HDBSS ioctl
Date: Fri, 21 Nov 2025 17:23:42 +0800
Message-ID: <20251121092342.3393318-6-zhengtian10@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20251121092342.3393318-1-zhengtian10@huawei.com>
References: <20251121092342.3393318-1-zhengtian10@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr100010.china.huawei.com (7.202.195.125)

A new ioctl (KVM_CAP_ARM_HW_DIRTY_STATE_TRACK) provides a mechanism for
userspace to configure the HDBSS buffer size during live migration,
enabling hardware-assisted dirty page tracking.

Signed-off-by: eillon <yezhenyu2@huawei.com>
Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
---
 Documentation/virt/kvm/api.rst | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 57061fa29e6a..25d60ff136e9 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8703,6 +8703,21 @@ This capability indicate to the userspace whether a PFNMAP memory region
 can be safely mapped as cacheable. This relies on the presence of
 force write back (FWB) feature support on the hardware.

+7.44 KVM_CAP_ARM_HW_DIRTY_STATE_TRACK
+:Architectures: arm64
+:Type: VM
+:Parameters: args[0] is the allocation order determining HDBSS buffer size
+:Returns: 0 on success, negative value on failure
+
+Enables hardware-assisted dirty page tracking via the Hardware Dirty State
+Tracking Structure (HDBSS).
+
+When live migration is initiated, userspace can enable this feature by
+setting KVM_CAP_ARM_HW_DIRTY_STATE_TRACK through IOCTL. KVM will allocate
+per-vCPU HDBSS buffers.
+
+The feature is disabled by invoking the ioctl again.
+
 8. Other capabilities.
 ======================

--
2.33.0

