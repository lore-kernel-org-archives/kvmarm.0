Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD30CECAAD1
	for <kvmarm@archiver.kernel.org>; Wed, 31 Aug 2022 10:23:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E62E34BA00;
	Wed, 31 Aug 2022 06:23:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Y8O+xqPTo8yP; Wed, 31 Aug 2022 06:23:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 238EC4B9FC;
	Wed, 31 Aug 2022 06:23:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B002B4B4C4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 20:53:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xqLlGtUV8x4s for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Aug 2022 20:53:08 -0400 (EDT)
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.154.221.58])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3A6FC4B497
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 20:53:07 -0400 (EDT)
X-QQ-mid: bizesmtp76t1661907179tg3l23sq
Received: from localhost.localdomain ( [182.148.13.26])
 by bizesmtp.qq.com (ESMTP) with 
 id ; Wed, 31 Aug 2022 08:52:58 +0800 (CST)
X-QQ-SSF: 01000000000000D0E000000A0000000
X-QQ-FEAT: xqT8U4SkSpgzoaMTZ/E4s2zF0bg8XhCWtigOgoAz5Gm4Sy/x5vzrFa8GnrgmG
 Pw8m4EqlHz4NA/RDsu+nxMgzRjyTJd2mfSaVWqu7sgjSK5BYKpKbXW/2tZQMKQYWoYyCyXt
 8RcTDyR3uBQPZQn2495sleIAY5f1oTUNPfxZvca6p8HXdxMqFsNRT5y247H6GCK1fSBHL1c
 Tmp8nGl4Il/Dhf2hvK/NjdtCNlnbnWSJqhcBnkVO9gLeJsF2nVwi9yKB4n+0v4+BPumEiKR
 QAXNnfxSRCZfsJI4e7+LZ7GQ+eikynCFmw7A6xBYs/sEUq6MsxuuL9jcTozhhyDtRB+T/HK
 Sz8z56n20rMVg2Abx0Kd3a/DDy+RhnJ4MQhPqc1j/WkUKvJz6M=
X-QQ-GoodBg: 0
From: Jilin Yuan <yuanjilin@cdjrlc.com>
To: maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
 suzuki.poulose@arm.com, oliver.upton@linux.dev, catalin.marinas@arm.com,
 will@kernel.org
Subject: [PATCH] KVM: arm64: fix repeated words in comments
Date: Wed, 31 Aug 2022 08:52:51 +0800
Message-Id: <20220831005251.39427-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Mailman-Approved-At: Wed, 31 Aug 2022 06:23:50 -0400
Cc: Jilin Yuan <yuanjilin@cdjrlc.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

Delete the redundant word 'to'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
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
