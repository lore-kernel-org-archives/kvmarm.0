Return-Path: <SRS0=JEd/=JO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10DD4C433B4
	for <kvmarm@archiver.kernel.org>; Sat, 17 Apr 2021 11:38:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7F02A611AC
	for <kvmarm@archiver.kernel.org>; Sat, 17 Apr 2021 11:38:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F02A611AC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C381B4B35A;
	Sat, 17 Apr 2021 07:38:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xYhfq-p8WHRT; Sat, 17 Apr 2021 07:38:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF5FB4B358;
	Sat, 17 Apr 2021 07:38:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B6D14B358
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Apr 2021 07:38:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cAEsj1MKzAR5 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 17 Apr 2021 07:38:33 -0400 (EDT)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 333D24B354
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Apr 2021 07:38:33 -0400 (EDT)
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FMrdG1BcFzlYCP;
 Sat, 17 Apr 2021 19:36:34 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.185.179) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Sat, 17 Apr 2021 19:38:19 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>
Subject: [PATCH] KVM: arm64: Fix Function ID typo for PTP_KVM service
Date: Sat, 17 Apr 2021 19:38:04 +0800
Message-ID: <20210417113804.1992-1-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Cc: maz@kernel.org
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

Per include/linux/arm-smccc.h, the Function ID of PTP_KVM service is
defined as ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID. Fix the typo in
documentation to keep the git grep consistent.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---

On branch kvm-arm64/ptp

 Documentation/virt/kvm/arm/ptp_kvm.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/arm/ptp_kvm.rst b/Documentation/virt/kvm/arm/ptp_kvm.rst
index 5d2bc4558b9d..aecdc80ddcd8 100644
--- a/Documentation/virt/kvm/arm/ptp_kvm.rst
+++ b/Documentation/virt/kvm/arm/ptp_kvm.rst
@@ -7,11 +7,11 @@ PTP_KVM is used for high precision time sync between host and guests.
 It relies on transferring the wall clock and counter value from the
 host to the guest using a KVM-specific hypercall.
 
-* ARM_SMCCC_HYP_KVM_PTP_FUNC_ID: 0x86000001
+* ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID: 0x86000001
 
 This hypercall uses the SMC32/HVC32 calling convention:
 
-ARM_SMCCC_HYP_KVM_PTP_FUNC_ID
+ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID
     ==============    ========    =====================================
     Function ID:      (uint32)    0x86000001
     Arguments:        (uint32)    KVM_PTP_VIRT_COUNTER(0)
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
