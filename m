Return-Path: <SRS0=mpH5=NJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3EE6C4338F
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 21:32:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 546DD610CD
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 21:32:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 546DD610CD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D16A04B0C6;
	Wed, 18 Aug 2021 17:32:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ItX8RAVZoa89; Wed, 18 Aug 2021 17:32:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFE5F4B0D2;
	Wed, 18 Aug 2021 17:32:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 066D74B0B6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 17:32:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YP0WWA33XuBg for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Aug 2021 17:32:10 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E9E4B49FB0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 17:32:10 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id
 s39-20020a05622a1aa700b00298bbc58d2fso1626209qtc.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 14:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=ecRcCckqyWwTUzyjSNSqRmDARBDpmN5st2LAlkhtd3M=;
 b=rndIgZ9W3RXr8Fv3KFQJgk7GH7BdVZcJ9F3Vz208W/QTj7Gz33vs9KOTj/kgpPYeYJ
 go0/ouGDHDiRvhofKXAp7iydUAoi3pUwmkdwgD6MO5tMcgtneJiNJTEk4qMSr680997x
 FUxuoQKU7+yAaoChYMFkN8eZSyHcNKDJprNjgXMNLGAwiDryRoxuD/Bh7rI8UtmM6jHX
 7NtuG2NyjtygIO3hWqzhBnM9uZ80/2Y4nP2rf3xOshbtIjxbvtwREe39emDEXSZt5Ayq
 zwJS5nzD82mZjftx6rJVYWrH2kICdyw/Szpw0B64opeZB7L+1AvGMlAqqksdknF375aY
 TxFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=ecRcCckqyWwTUzyjSNSqRmDARBDpmN5st2LAlkhtd3M=;
 b=fGrmm9O4Qho3TSmGpetzYYBwfaFx+KfiAJthK/KbynkIhX8PKdraZ99n8QxM9G8l3s
 9d/v6udIWyU1zd5rmhG6F55AFWWTxlDmyrl6yUxt4bBlxv+xVj51DdwAqFf/cITR3Tp6
 fEgYHVcoJA7nW7+4yvaJ0pnUYnR+A20A0mZI4VUFZenlnVOQa9qnmuhooqRYGSyj4ykY
 yXxmmWtTr6x6ZCsfCymb/jh6A2MBnNgl2rl+1ts4OnhUjrc9DI+Lwe+ztuipwospJfO5
 PTzZN7j4thWNrx/t6aqBMvkR1YDnv6TmSivCCCJaRKPkVg+qYJNdfGMbiAYY7zZ3w/rS
 a4bw==
X-Gm-Message-State: AOAM530IPlLsmp6Lvpk+yzdEFCpVM6m8UBH8qMdxMju9XlCH7yIjbANg
 f4mWhK/2vBtawly9D+bT3BmXE94KiMTCmhWuLcF4TSaJxPsiJG5yMU3oATzXRUg+jpGazD0wgPy
 wKMdaLIwcNCHs5z2fdOYW9JoufN2EnfwJ3n1mA3ERj9fd1t1SOnUNPzR9GzhGV/Wq6nDYvL9NaC
 o=
X-Google-Smtp-Source: ABdhPJziTwCi/d/SGVcituWivK5VPhdCVw8HgSkbX/OjYax72lgG7DFYhq9ryf8JeuNmbcDbxIuMRNIUHygZ0Q==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6214:144e:: with SMTP id
 b14mr11084163qvy.44.1629322330417; Wed, 18 Aug 2021 14:32:10 -0700 (PDT)
Date: Wed, 18 Aug 2021 14:32:05 -0700
Message-Id: <20210818213205.598471-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH] KVM: arm64: vgic: drop WARN from vgic_get_irq
From: Ricardo Koller <ricarkol@google.com>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: maz@kernel.org, rananta@google.com, pshier@google.com,
 catalin.marinas@arm.com
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

vgic_get_irq(intid) is used all over the vgic code in order to get a
reference to a struct irq. It warns whenever intid is not a valid number
(like when it's a reserved IRQ number). The issue is that this warning
can be triggered from userspace (e.g., KVM_IRQ_LINE for intid 1020).

Drop the WARN call from vgic_get_irq.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 111bff47e471..81cec508d413 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -106,7 +106,6 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	if (intid >= VGIC_MIN_LPI)
 		return vgic_get_lpi(kvm, intid);
 
-	WARN(1, "Looking up struct vgic_irq for reserved INTID");
 	return NULL;
 }
 
-- 
2.33.0.rc2.250.ged5fa647cd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
