Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390022D2489
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 03:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757389465; cv=none; b=myR69bJixAFGnW1K61fO+82FKnQaQDGKjdWdjOz6iCyae6YggMHIRQQ59WaiPeAJQMimfATraAEDSIqZ9QzzokM1okiafSWf3kP+XpocvLDIhtyQ9vkT8JJoXpjAssW6Z/Cg6D7tOX47pSdJe3yehIKUx+rZyLtVZd0wq76adTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757389465; c=relaxed/simple;
	bh=4XatZ2Ym4v/LaAB5X+n8cxr2bSXfDlHMdqOgB4bcOKs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=okQuCrcpxC9uqGftVAD8k8HdQ5SKVOXneT6CTeGT7KUQN/BTqLiZTC5t822uschCGOndtXEo5ueV3mxD9nK+ZVN+iA8ERHbeR3cdnNCjjG6uit/FVFZa8K0VzPY3VVIl4osn1EMmvvClQE9f9j2Ssq10/eQKH2xnwUJIilIvDFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cLV1w1DVHz2CgJG;
	Tue,  9 Sep 2025 11:39:48 +0800 (CST)
Received: from dggpemf500013.china.huawei.com (unknown [7.185.36.188])
	by mail.maildlp.com (Postfix) with ESMTPS id CD39814013B;
	Tue,  9 Sep 2025 11:44:19 +0800 (CST)
Received: from huawei.com (10.50.165.33) by dggpemf500013.china.huawei.com
 (7.185.36.188) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 9 Sep
 2025 11:44:19 +0800
From: Jinqian Yang <yangjinqian1@huawei.com>
To: <oliver.upton@linux.dev>, <yuzenghui@huawei.com>, <maz@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <liuyonglong@huawei.com>,
	<wangzhou1@hisilicon.com>, <yangjinqian1@huawei.com>
Subject: [PATCH v2 3/3] KVM: arm64: Make ID_AA64MMFR1_EL1.VH writable from userspace
Date: Tue, 9 Sep 2025 11:44:15 +0800
Message-ID: <20250909034415.3822478-4-yangjinqian1@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250909034415.3822478-1-yangjinqian1@huawei.com>
References: <20250909034415.3822478-1-yangjinqian1@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500013.china.huawei.com (7.185.36.188)

Allow userspace to downgrade VH in ID_AA64MMFR1_EL1. Userspace can
only change this value from high to low.

Signed-off-by: Jinqian Yang <yangjinqian1@huawei.com>
---
 arch/arm64/kvm/sys_regs.c                       | 1 -
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index db49beb8804e..5ff14c7ec753 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3003,7 +3003,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 					ID_AA64MMFR0_EL1_ASIDBITS)),
 	ID_WRITABLE(ID_AA64MMFR1_EL1, ~(ID_AA64MMFR1_EL1_RES0 |
 					ID_AA64MMFR1_EL1_XNX |
-					ID_AA64MMFR1_EL1_VH |
 					ID_AA64MMFR1_EL1_VMIDBits)),
 	ID_FILTERED(ID_AA64MMFR2_EL1,
 		    id_aa64mmfr2_el1, ~(ID_AA64MMFR2_EL1_RES0 |
diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index a889550d8aa4..00dd8066b46f 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -172,6 +172,7 @@ static const struct reg_ftr_bits ftr_id_aa64mmfr1_el1[] = {
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR1_EL1, PAN, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR1_EL1, LO, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR1_EL1, HPDS, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR1_EL1, VH, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR1_EL1, HAFDBS, 0),
 	REG_FTR_END,
 };
-- 
2.33.0

