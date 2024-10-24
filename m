Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09301B219C
	for <kvmarm@lists.linux.dev>; Thu, 24 Oct 2024 08:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729758837; cv=none; b=TkjLNQOrJhd78e1kcpNV4ZMvU+C0M8DXA45QMvUnq1InPkTyoGfkCbVapUHCWHIDtvyIraXZYJHzkIK8kNKfyJkzeH8nedt+rAzT63U8kG97Wbn+vJysOkXHXl1+nLYUC20mU1WCBC0cgITOwIRpK+FTnyrhVNGipsgoRFmEDjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729758837; c=relaxed/simple;
	bh=ORCTv1of3Ib6RzWAYPL7kveKtvX2wmzZwknmTBjQ7V8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IeTgeOhmipNu7YxWdjYlIE8Pkwn7IXaa7Taw4QLelsiRXiM3bxczxpyD71xGhE+q6o1yArjdAyUbeCRP9CpWZ9gQMWFdbU1RtB8UWxJMXZnN1Y22aLAE89dwS/bQ2mO14NM6MUWmFsZx3muwRLGvtNlZ8OoCtBeAESyT1AB2s50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4XYzgG6FtPz1SD3Z;
	Thu, 24 Oct 2024 16:32:26 +0800 (CST)
Received: from kwepemd200011.china.huawei.com (unknown [7.221.188.251])
	by mail.maildlp.com (Postfix) with ESMTPS id C39301A016C;
	Thu, 24 Oct 2024 16:33:51 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemd200011.china.huawei.com (7.221.188.251) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Thu, 24 Oct 2024 16:33:51 +0800
From: Gaosheng Cui <cuigaosheng1@huawei.com>
To: <maz@kernel.org>, <oliver.upton@linux.dev>, <joey.gouly@arm.com>,
	<suzuki.poulose@arm.com>, <yuzenghui@huawei.com>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <sebott@redhat.com>, <cuigaosheng1@huawei.com>,
	<wangweiyang2@huawei.com>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>
Subject: [PATCH -next] KVM: arm64: Fix possible null-ptr-deref in idregs_debug_show
Date: Thu, 24 Oct 2024 16:33:50 +0800
Message-ID: <20241024083350.2828920-1-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemd200011.china.huawei.com (7.221.188.251)

The idregs_debug_show() maybe return nullptr, we need to check desc
before dereference it to avoid possible null pointer dereferences.

Fixes: 410db103f6eb ("KVM: arm64: Make idregs debugfs iterator search sysreg table directly")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ff8c4e1b847e..b1c59773b9c0 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4135,7 +4135,7 @@ static int idregs_debug_show(struct seq_file *s, void *v)
 
 	desc = idregs_debug_find(kvm, kvm->arch.idreg_debugfs_iter);
 
-	if (!desc->name)
+	if (!desc || !desc->name)
 		return 0;
 
 	seq_printf(s, "%20s:\t%016llx\n",
-- 
2.25.1

