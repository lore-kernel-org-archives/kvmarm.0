Return-Path: <SRS0=hpqd=QB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF1E3C433EF
	for <kvmarm@archiver.kernel.org>; Sun, 14 Nov 2021 10:01:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4383F60F22
	for <kvmarm@archiver.kernel.org>; Sun, 14 Nov 2021 10:01:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4383F60F22
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cdjrlc.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E61D14A1B0;
	Sun, 14 Nov 2021 05:01:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gh9i2LO+nLet; Sun, 14 Nov 2021 05:01:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2C244B16F;
	Sun, 14 Nov 2021 05:01:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 513804B190
 for <kvmarm@lists.cs.columbia.edu>; Sun, 14 Nov 2021 01:40:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lbS21DMBZqtK for <kvmarm@lists.cs.columbia.edu>;
 Sun, 14 Nov 2021 01:40:42 -0500 (EST)
Received: from smtpbg.qq.com (smtpbg127.qq.com [109.244.180.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4DA824B18A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 14 Nov 2021 01:40:40 -0500 (EST)
X-QQ-mid: bizesmtp31t1636872029td6k2uq2
Received: from localhost.localdomain (unknown [125.69.41.88])
 by esmtp6.qq.com (ESMTP) with 
 id ; Sun, 14 Nov 2021 14:40:27 +0800 (CST)
X-QQ-SSF: 01000000002000C0F000C00A0000000
X-QQ-FEAT: XwMLFaztUQgg4HPywJhWjL3+jGKnrZMzxf7F0clzzs3LgAJk9jOR+hP3XdaCX
 lafjBJI5ykQrQz5McRCtxOw9jeCi2MBm0CyME6iZ6CfaH9Tqrx3X6h09EpeTzGHrTrKTjFK
 p/28iD0qmT71IB5vuCAK1Yoaw00rg9NIWkkT/NDLIqJXtQD6ohqfliEFKsFXJCrkvRwUHGD
 CvxwDHgHuwmvVmSW9O0/smk7KPYlvmKfGqxqEgNzqaVkBGyInr9WW24FRSr8rI7e9xh1wLY
 nEycAMD903Tj6f6M1uUtJeO58ur60ZAn6c6T+Fy1Thnh0jvibJlE4SLg7M0W598xSCXhQnP
 ImvmUtQu9ud/s5vBP2rvVcveiYL+WiABEl9LRIn
X-QQ-GoodBg: 0
From: Jason Wang <wangborong@cdjrlc.com>
To: catalin.marinas@arm.com
Subject: [PATCH] KVM: arm64: remove unneeded comparison
Date: Sun, 14 Nov 2021 14:40:26 +0800
Message-Id: <20211114064026.277024-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam1
X-Mailman-Approved-At: Sun, 14 Nov 2021 05:01:07 -0500
Cc: maz@kernel.org, linux-kernel@vger.kernel.org,
 Jason Wang <wangborong@cdjrlc.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

The unsigned expression compared with zero `target < 0' is
unneeded and its result is always false. we can also check the
target's value returned from `kvm_target_cpu' is one of the
KVM_* macros, and these macros are defined greater than or equal
to 0.
Therefore, the comparison code block:
    if (target < 0)
        return -ENODEV;
is unneeded. We can safely remove it.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 arch/arm64/kvm/guest.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 5ce26bedf23c..1605cb71dd52 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -873,9 +873,6 @@ int kvm_vcpu_preferred_target(struct kvm_vcpu_init *init)
 {
 	u32 target = kvm_target_cpu();
 
-	if (target < 0)
-		return -ENODEV;
-
 	memset(init, 0, sizeof(*init));
 
 	/*
-- 
2.33.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
