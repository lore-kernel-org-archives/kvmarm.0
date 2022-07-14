Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AB9EC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jul 2022 15:35:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 51F5D4C5E9;
	Thu, 14 Jul 2022 11:35:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HZUNBM0BWdXH; Thu, 14 Jul 2022 11:35:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8894C4C5B7;
	Thu, 14 Jul 2022 11:35:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 481E84C519
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 11:35:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kOGeeiaCYXq1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jul 2022 11:35:38 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 42C804C598
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 11:35:38 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id C564661F20;
 Thu, 14 Jul 2022 15:35:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9355AC34114;
 Thu, 14 Jul 2022 15:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1657812937;
 bh=FpY82Bo73/mGS1EBtfSIggY4YO4B5LLIsNhuHWTGgZc=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=LSI+9FrWCMped+P1iDOzmSIAERmHMZzxniw81JzSfl3Z5C2KjFZgQqyhBlVppubAJ
 zDfa8SgqyaYtAxy38IFPJ8Xv/LY5xnbkHob1F++IcuqSvO3bU0QcN1KJs7yFMuUE44
 QCgCPuK8vc5VmSYpmMdQb9CdDkqp4mvaz7+D2A3PcnWXfrmKgU711sSGMiaE/le5bM
 8bDscgLdHMVxvto29evOie6sFNbp9Oy/z7DoQnw9XLk1n/5/pTNQw5iYsjK4dPHoQJ
 w7ZINCCn8ldM9h4wmB1iPhjfFG1590PYzw5awfkTMcBaCSybyeSG8lyMgwti3Lcb5y
 Y15bZ+gyfVV6A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oC0dk-007UVL-0E;
 Thu, 14 Jul 2022 16:20:32 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 14/20] KVM: arm64: vgic: Use {get,
 put}_user() instead of copy_{from.to}_user
Date: Thu, 14 Jul 2022 16:20:18 +0100
Message-Id: <20220714152024.1673368-15-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220714152024.1673368-1-maz@kernel.org>
References: <20220714152024.1673368-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 reijiw@google.com, schspa@gmail.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Schspa Shi <schspa@gmail.com>, kernel-team@android.com,
 Oliver Upton <oliver.upton@linux.dev>
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

Tidy-up vgic_get_common_attr() and vgic_set_common_attr() to use
{get,put}_user() instead of the more complex (and less type-safe)
copy_{from,to}_user().

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 066b95d606fd..c17e5502c0b3 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -170,7 +170,7 @@ static int vgic_set_common_attr(struct kvm_device *dev,
 		u64 addr;
 		unsigned long type = (unsigned long)attr->attr;
 
-		if (copy_from_user(&addr, uaddr, sizeof(addr)))
+		if (get_user(addr, uaddr))
 			return -EFAULT;
 
 		r = kvm_vgic_addr(dev->kvm, type, &addr, true);
@@ -233,14 +233,14 @@ static int vgic_get_common_attr(struct kvm_device *dev,
 		u64 addr;
 		unsigned long type = (unsigned long)attr->attr;
 
-		if (copy_from_user(&addr, uaddr, sizeof(addr)))
+		if (get_user(addr, uaddr))
 			return -EFAULT;
 
 		r = kvm_vgic_addr(dev->kvm, type, &addr, false);
 		if (r)
 			return (r == -ENODEV) ? -ENXIO : r;
 
-		if (copy_to_user(uaddr, &addr, sizeof(addr)))
+		if (put_user(addr, uaddr))
 			return -EFAULT;
 		break;
 	}
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
