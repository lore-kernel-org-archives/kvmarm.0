From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH 0/3] Three fixes for KVM ARM64
Date: Wed, 13 Jan 2016 17:16:38 +0800
Message-ID: <1452676601-14796-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D470949B32
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2016 04:16:47 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CScN322p1L34 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Jan 2016 04:16:46 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C351949B17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2016 04:16:45 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

These bugs are found when I test the 32 bit part of guest PMU patch set.

Shannon Zhao (3):
  KVM: ARM64: Fix wrong use of the CPSR MODE mask
  KVM: ARM64: Fix comments of the CP handler
  KVM: ARM64: Fix guest dead loop when register accessor returns false

 arch/arm64/include/asm/kvm_emulate.h | 8 ++++++--
 arch/arm64/kvm/sys_regs.c            | 9 ++++-----
 2 files changed, 10 insertions(+), 7 deletions(-)

-- 
2.0.4
