Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE64255E55
	for <kvmarm@lists.linux.dev>; Tue, 25 Mar 2025 12:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742904695; cv=none; b=FW7cOPQDFCBUBH3Rz7h9fpvGV1+7dsFnaqy5I3ULN56c//YkLerURM8v2kZIDNXkGcQAtJHOrd7iJryHZ1JkMAFnk+H40C6zVUoKg4zktTjnT+U6HT8b6ao76vDjSxIb15yo2WajYPLMSLhqyjX+bIMl6GS6kMqzNffbo5qVDAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742904695; c=relaxed/simple;
	bh=DEC5ifR+Mt8gyk9Zce/fh7iv6TUCsXEt+U7XN+jEuvU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OKjpuGzj4hLqpaLBhYJjJnqFS9b2J2lVeAHfFvcfduUQBE8fZ24TjSDYZyIG9QwwOatdAxpBmJP/fwodmG9bccOJEvuzbzr4TRioAarmG/pM9eXy4K/fiY8Y4ph0U2QUBH0PuqbdNUFmtrELKFJTrtwQGo+Laatk5TkwOIhYjyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4ZMTG54bqgzHrFd;
	Tue, 25 Mar 2025 20:08:13 +0800 (CST)
Received: from kwepemg100001.china.huawei.com (unknown [7.202.181.18])
	by mail.maildlp.com (Postfix) with ESMTPS id 72AC618006C;
	Tue, 25 Mar 2025 20:11:30 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemg100001.china.huawei.com
 (7.202.181.18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 25 Mar
 2025 20:11:29 +0800
From: Jinqian Yang <yangjinqian1@huawei.com>
To: <maz@kernel.org>, <oliver.upton@linux.dev>, <yuzenghui@huawei.com>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <wangzhou1@hisilicon.com>,
	<shameerali.kolothum.thodi@huawei.com>, <liuyonglong@huawei.com>,
	<jiangkunkun@huawei.com>, <yangjinqian1@huawei.com>
Subject: [PATCH] KVM: arm64: Make HCX writable from userspace
Date: Tue, 25 Mar 2025 20:11:26 +0800
Message-ID: <20250325121126.1380681-1-yangjinqian1@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemg100001.china.huawei.com (7.202.181.18)

Allow userspace to modify guest visible value for HCX in
ID_AA64MMFR1_EL1.

Signed-off-by: Jinqian Yang <yangjinqian1@huawei.com>
---
 arch/arm64/kvm/sys_regs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 82430c1e1dd0..b105f156bdf6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2666,7 +2666,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 					ID_AA64MMFR0_EL1_TGRAN16_2 |
 					ID_AA64MMFR0_EL1_ASIDBITS)),
 	ID_WRITABLE(ID_AA64MMFR1_EL1, ~(ID_AA64MMFR1_EL1_RES0 |
-					ID_AA64MMFR1_EL1_HCX |
 					ID_AA64MMFR1_EL1_TWED |
 					ID_AA64MMFR1_EL1_XNX |
 					ID_AA64MMFR1_EL1_VH |
-- 
2.33.0

