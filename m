Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944703A27E
	for <kvmarm@lists.linux.dev>; Wed, 10 Jan 2024 08:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R541e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=tianruidong@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0W-LGmrI_1704873460;
Received: from localhost(mailfrom:tianruidong@linux.alibaba.com fp:SMTPD_---0W-LGmrI_1704873460)
          by smtp.aliyun-inc.com;
          Wed, 10 Jan 2024 15:57:43 +0800
From: Ruidong Tian <tianruidong@linux.alibaba.com>
To: kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	Ruidong Tian <tianruidong@linux.alibaba.com>
Subject: [PATCH] KVM: arm64: Add missing ERX*_EL1 registers
Date: Wed, 10 Jan 2024 15:57:39 +0800
Message-Id: <20240110075739.8291-1-tianruidong@linux.alibaba.com>
X-Mailer: git-send-email 2.33.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 464f2164da7e ("arm64: Add missing ERX*_EL1 encodings") add some
new RAS registers. Trap them to kvm.

Signed-off-by: Ruidong Tian <tianruidong@linux.alibaba.com>
---
 arch/arm64/kvm/sys_regs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 30253bd19917..76a9ba155d58 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2389,8 +2389,13 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_ERXCTLR_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_ERXSTATUS_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_ERXADDR_EL1), trap_raz_wi },
+	{ SYS_DESC(SYS_ERXPFGF_EL1), trap_raz_wi },
+	{ SYS_DESC(SYS_ERXPFGCTL_EL1), trap_raz_wi },
+	{ SYS_DESC(SYS_ERXPFGCDN_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_ERXMISC0_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_ERXMISC1_EL1), trap_raz_wi },
+	{ SYS_DESC(SYS_ERXMISC2_EL1), trap_raz_wi },
+	{ SYS_DESC(SYS_ERXMISC3_EL1), trap_raz_wi },
 
 	MTE_REG(TFSR_EL1),
 	MTE_REG(TFSRE0_EL1),
-- 
2.33.1

