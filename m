Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AED18C19F2A
	for <kvmarm@archiver.kernel.org>; Thu, 11 Aug 2022 12:24:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 234434E46F;
	Thu, 11 Aug 2022 08:24:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mIDFfGT2g9IP; Thu, 11 Aug 2022 08:24:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7518A4E46D;
	Thu, 11 Aug 2022 08:24:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38DC94E478
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Aug 2022 08:20:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f-J--SJ-JX+u for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Aug 2022 08:20:49 -0400 (EDT)
Received: from bg5.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E267D4E476
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Aug 2022 08:20:48 -0400 (EDT)
X-QQ-mid: bizesmtp86t1660220438tdmfl1qy
Received: from localhost.localdomain ( [182.148.14.53])
 by bizesmtp.qq.com (ESMTP) with 
 id ; Thu, 11 Aug 2022 20:20:36 +0800 (CST)
X-QQ-SSF: 01000000002000G0V000B00A0000000
X-QQ-FEAT: k0mQ4ihyJQP2Bpmbn/1SZC8/THmmEo80BPJqBWLE3wvy9Nrej8PJId7DSZhBF
 Dg2Tw3KjpN4N4czRwo7G91yGEgrbZ8LV6u2N8bm4qktlq7PWkTaN3X28EbNM7HVZikcIC1w
 FMhgXgJE51VgDF70SdMHrujxL+EnBXlCGyK9Piksq7+r7QsN83STdcHAoGmAQreuCj/wrxY
 pNtg7Gq9Ax/HShjhaYUjPFl8+gqpp6nQwbfthuo6lVyZeROIoXKzpqOudz13Um8v7h+nsJk
 N01Ama53mftLdHIMSKP/ZVXoQK/QgGD9cCwNhKCVx0ruwRn1+3ACaqm0xF4dwnIS3AA+Sfd
 fmMl2N55UEnkw3pZvQVV7gmMzrKG0Z9hd7F+BwmdXcZRijBZpq09XbyIc4AHsptfIh4tDXY
X-QQ-GoodBg: 0
From: Jason Wang <wangborong@cdjrlc.com>
To: catalin.marinas@arm.com
Subject: [PATCH] KVM: arm64: Fix comment typo
Date: Thu, 11 Aug 2022 20:20:29 +0800
Message-Id: <20220811122029.28978-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
X-Mailman-Approved-At: Thu, 11 Aug 2022 08:24:15 -0400
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

The double `to' is duplicated in the comment, remove one.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 arch/arm64/kvm/inject_fault.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index f32f4a2a347f..92de0f817be4 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -155,7 +155,7 @@ void kvm_inject_size_fault(struct kvm_vcpu *vcpu)
 	 * Size Fault at level 0, as if exceeding PARange.
 	 *
 	 * Non-LPAE guests will only get the external abort, as there
-	 * is no way to to describe the ASF.
+	 * is no way to describe the ASF.
 	 */
 	if (vcpu_el1_is_32bit(vcpu) &&
 	    !(vcpu_read_sys_reg(vcpu, TCR_EL1) & TTBCR_EAE))
-- 
2.36.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
