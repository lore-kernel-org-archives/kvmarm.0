Return-Path: <SRS0=xfyP=MU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 175B3C4338F
	for <kvmarm@archiver.kernel.org>; Wed, 28 Jul 2021 15:25:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7C1F260F91
	for <kvmarm@archiver.kernel.org>; Wed, 28 Jul 2021 15:25:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7C1F260F91
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cdjrlc.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E71CC4ACC9;
	Wed, 28 Jul 2021 11:25:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3O-CpKwp8c8K; Wed, 28 Jul 2021 11:25:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DF5E4AED4;
	Wed, 28 Jul 2021 11:25:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56C0D49FE6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jul 2021 09:06:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pTbWHC8U8mys for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jul 2021 09:06:37 -0400 (EDT)
Received: from smtpbg604.qq.com (smtpbg604.qq.com [59.36.128.82])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BBB1940870
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jul 2021 09:06:36 -0400 (EDT)
X-QQ-mid: bizesmtp40t1627477586t4r18s2j
Received: from ficus.lan (unknown [171.223.99.141])
 by esmtp6.qq.com (ESMTP) with 
 id ; Wed, 28 Jul 2021 21:06:24 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000B00A0000000
X-QQ-FEAT: 5gms5Di3ODhwcUaoG5y/inyFUTUQBomNyL29HOE+eLy3B7jVXWO0qnWknMCqS
 4EUzJ1s5k48LQGmjdCtJtRVrtVGrdVJMGodSu1RhfXpRANy7M2HNEbQ4jBbTUQbxrSHYKWZ
 Ef7BSVcL+XJ6DYqoo6ve8NxCaOqG3DOZpuPSe4iQ4wnhcjXox0xP4k9W1rdx1VBwaabWW25
 BIyQLdhcPLtq7f6hOq87jovC/3zZNYy7xYEthpLUOUvvvVuqK5GF2U9j9cvfK0/lc11hZhM
 4gv0by9DALqMd2QWqoOGZpDBL/YgWtJLrc62mJUbtkkIjFip2R0iyRCQs=
X-QQ-GoodBg: 0
From: Jason Wang <wangborong@cdjrlc.com>
To: maz@kernel.org
Subject: [PATCH] KVM: arm64: fix comment typo
Date: Wed, 28 Jul 2021 21:06:23 +0800
Message-Id: <20210728130623.12017-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam4
X-Mailman-Approved-At: Wed, 28 Jul 2021 11:25:20 -0400
Cc: will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 Jason Wang <wangborong@cdjrlc.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Remove the repeated word 'the' from two comments.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 arch/arm64/kvm/vgic/vgic-mmio-v2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v2.c b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
index a016f07adc28..5f9014ae595b 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
@@ -282,7 +282,7 @@ static unsigned long vgic_mmio_read_vcpuif(struct kvm_vcpu *vcpu,
 	case GIC_CPU_PRIMASK:
 		/*
 		 * Our KVM_DEV_TYPE_ARM_VGIC_V2 device ABI exports the
-		 * the PMR field as GICH_VMCR.VMPriMask rather than
+		 * PMR field as GICH_VMCR.VMPriMask rather than
 		 * GICC_PMR.Priority, so we expose the upper five bits of
 		 * priority mask to userspace using the lower bits in the
 		 * unsigned long.
@@ -329,7 +329,7 @@ static void vgic_mmio_write_vcpuif(struct kvm_vcpu *vcpu,
 	case GIC_CPU_PRIMASK:
 		/*
 		 * Our KVM_DEV_TYPE_ARM_VGIC_V2 device ABI exports the
-		 * the PMR field as GICH_VMCR.VMPriMask rather than
+		 * PMR field as GICH_VMCR.VMPriMask rather than
 		 * GICC_PMR.Priority, so we expose the upper five bits of
 		 * priority mask to userspace using the lower bits in the
 		 * unsigned long.
-- 
2.32.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
