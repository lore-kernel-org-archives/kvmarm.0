Return-Path: <SRS0=TLTx=B3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E33C433E5
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 11:08:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9BA3820738
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 11:08:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9BA3820738
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 525B34C079;
	Mon, 17 Aug 2020 07:08:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GJ6W7wik53Ap; Mon, 17 Aug 2020 07:08:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C5CF4C067;
	Mon, 17 Aug 2020 07:08:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98AA34BF88
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 07:08:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qxOQcefR0Vid for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 07:08:06 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F1F904BF2B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 07:08:05 -0400 (EDT)
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id DFFEC183E6E7D710B54F;
 Mon, 17 Aug 2020 19:08:00 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.22) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Mon, 17 Aug 2020 19:07:51 +0800
From: Keqian Zhu <zhukeqian1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
Subject: [PATCH v2 1/2] KVM: arm64: Some fixes of PV-time interface document
Date: Mon, 17 Aug 2020 19:07:27 +0800
Message-ID: <20200817110728.12196-2-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20200817110728.12196-1-zhukeqian1@huawei.com>
References: <20200817110728.12196-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Cc: Marc Zyngier <maz@kernel.org>, Steven Price <steven.price@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Rename PV_FEATURES to PV_TIME_FEATURES.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Steven Price <steven.price@arm.com>
---
 Documentation/virt/kvm/arm/pvtime.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/arm/pvtime.rst b/Documentation/virt/kvm/arm/pvtime.rst
index 687b60d..94bffe2 100644
--- a/Documentation/virt/kvm/arm/pvtime.rst
+++ b/Documentation/virt/kvm/arm/pvtime.rst
@@ -3,7 +3,7 @@
 Paravirtualized time support for arm64
 ======================================
 
-Arm specification DEN0057/A defines a standard for paravirtualised time
+Arm specification DEN0057/A defines a standard for paravirtualized time
 support for AArch64 guests:
 
 https://developer.arm.com/docs/den0057/a
@@ -19,8 +19,8 @@ Two new SMCCC compatible hypercalls are defined:
 
 These are only available in the SMC64/HVC64 calling convention as
 paravirtualized time is not available to 32 bit Arm guests. The existence of
-the PV_FEATURES hypercall should be probed using the SMCCC 1.1 ARCH_FEATURES
-mechanism before calling it.
+the PV_TIME_FEATURES hypercall should be probed using the SMCCC 1.1
+ARCH_FEATURES mechanism before calling it.
 
 PV_TIME_FEATURES
     ============= ========    ==========
-- 
1.8.3.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
