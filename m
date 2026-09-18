Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7651E344DB9
	for <kvmarm@lists.linux.dev>; Fri, 18 Sep 2026 08:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789719794; cv=none; b=eMyG6bEfqjtofSI2H+jjd3EV/nbwy9Ifl1z2ujVH1YQxwjKCur5qNQJ3bKJJbV9pU+UDkCPJX2ffIrBFh0IzwMjFqdMcSKppkUnpjpA4qfqTQdUWx4lozcxqV0nNVd0BD/rEG8aSjNDdAKp88cbMEmldMaiU5gw4boGFssAcluk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789719794; c=relaxed/simple;
	bh=kgpSkL2haZgcDxiteaSedE60Fz3220AerE95UpX2hU0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E/ciNE3tM6EtPtU3Oe/ztRww6qi1tovri9XxeFbTzpvpAasziWQ1HjhGfhpPQpxJLrMxj9qZZXQGsz/AvjKASWsMgHiTI+MZwZK+oR88vOQNAnFUzWXTa31hIB7OeB9IzO4KWyyloQiiknK+A6YYGKehtIw32UmwdDd0lynEPjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=lgtSmOeP; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="lgtSmOeP"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=FCmI3leX1pSmZveS+R3odec3VGT0tP4oB9BLzPo+eRY=;
	b=lgtSmOePElVqGFDjBJrpu3DHav4matcZPo1VeybjopEa14RMmu82Kgom9oIHG8JEEL5tvBfJh
	u8LwzRvTffwM6z3rWwSWOxrg25XVXbZV3YZILfNe2Sg6V7LHDgJUqpnlDQuyjaAl0xh0Y3YU5sA
	OhtH8z7IuD/QWllOzQvQ/HM=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hmQML6MVTzKm5t;
	Fri, 18 Sep 2026 16:11:58 +0800 (CST)
Received: from dggpemr200003.china.huawei.com (unknown [7.185.36.25])
	by mail.maildlp.com (Postfix) with ESMTPS id 75A8040563;
	Fri, 18 Sep 2026 16:23:02 +0800 (CST)
Received: from huawei.com (10.50.159.234) by dggpemr200003.china.huawei.com
 (7.185.36.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Fri, 18 Sep
 2026 16:23:01 +0800
From: Yize Wang <wangyize7@huawei.com>
To: <maz@kernel.org>, <kvmarm@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <oupton@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<fuad.tabba@linux.dev>, <joey.gouly@arm.com>, <seiden@linux.ibm.com>,
	<suzuki.poulose@arm.com>, <yuzenghui@huawei.com>, <mark.rutland@arm.com>,
	<zhengchuan@huawei.com>, <jiangjiacheng@huawei.com>, <wangyize7@huawei.com>,
	<yize_w1110@163.com>
Subject: [PATCH 1/2] KVM: arm64: Add batch group constant and data structure to UAPI header
Date: Fri, 18 Sep 2026 16:18:14 +0800
Message-ID: <20260918081930.4014735-2-wangyize7@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260918081930.4014735-1-wangyize7@huawei.com>
References: <20260918081930.4014735-1-wangyize7@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemr200003.china.huawei.com (7.185.36.25)

Add KVM_DEV_ARM_VGIC_GRP_BATCH_REGS group ID, KVM_DEV_ARM_VGIC_BATCH_MAX
limit, and struct kvm_dev_arm_vgic_batch_entry for batch VGIC register
access. These UAPI definitions allow userspace to read/write multiple
VGIC registers in a single ioctl call.

Signed-off-by: Chuan Zheng <zhengchuan@huawei.com>
Signed-off-by: Yize Wang <wangyize7@huawei.com>
---
 arch/arm64/include/uapi/asm/kvm.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 019e5e3d892e..f84530274edd 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -418,12 +418,22 @@ enum {
 #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
 #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
 #define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
+#define KVM_DEV_ARM_VGIC_GRP_BATCH_REGS 10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK	0x3ff
 #define VGIC_LEVEL_INFO_LINE_LEVEL	0
 
+#define KVM_DEV_ARM_VGIC_BATCH_MAX	4096
+#define KVM_DEV_ARM_VGIC_ATTR_FLAG_LOCKED 12
+struct kvm_dev_arm_vgic_batch_entry {
+	__u32 group;
+	__u64 attr;
+	__u32 val;
+	__s32 error;
+};
+
 #define   KVM_DEV_ARM_VGIC_CTRL_INIT		0
 #define   KVM_DEV_ARM_ITS_SAVE_TABLES           1
 #define   KVM_DEV_ARM_ITS_RESTORE_TABLES        2
-- 
2.43.0

