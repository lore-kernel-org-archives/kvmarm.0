Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01DDFC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jan 2022 03:09:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0E4E49DED;
	Wed, 26 Jan 2022 22:09:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id g4UjneI0K7aM; Wed, 26 Jan 2022 22:09:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B9B949EE3;
	Wed, 26 Jan 2022 22:09:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC87649ED8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 22:09:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6TQcKuIiTdlB for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 22:09:14 -0500 (EST)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 64C1449F07
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 22:09:12 -0500 (EST)
Received: by mail-pg1-f201.google.com with SMTP id
 k13-20020a65434d000000b00342d8eb46b4so675844pgq.23
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 19:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=GwfeejbMqNEQvaZ8Yfe9ml4jBewW/ulWJB+/b/aTwrs=;
 b=EtpS3gSBZUOjBB1L/nudYXj30b9atzdjUMoj0Vv7eotLi8QKfuVja6weD7hkUnZI0v
 jftGfz5POew9BfPZJCZpWWTYSQUgj9hZNhEmXqLLReVz1zIy8PO2r9qhg/ZY1aYPlqUn
 Qrwygd5W2/GdFzsPv3b8dlZ7+CF8A3y0ctD18o8RywKqD0Us6tq/eClsMvWSERUqEolK
 GStpjjO3ZcLhQIpM81/O48PGIOdpJVk0qfgBwH1NFjLf8kR4xu7EyNDj3mdLqxVcwAZJ
 eF/z8aW8VLIHxZInFiBqS7QkFEMQrVg4GGZnUrHi0dPtueK3M+TmevW1KNI5aN3wwAXH
 /zIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=GwfeejbMqNEQvaZ8Yfe9ml4jBewW/ulWJB+/b/aTwrs=;
 b=Hz2qX1o1A/BP9Hn0Ed44nAvTpWSb1w6SdqT5Bwm0cfK8uocmbIlRp0su2BY6vTn7Uk
 dgwjsH65jVWQ393571V8LSqnVtaEtHMjHcJlMrtFF+9yNxvDg3rDMQ4p9/Wfnl8eaouC
 QglI0fdIWGHzxFDw6ha8CVE6NWt5PGylZEYKoi9CA4xxPXMM/LuMIk0dCugwGe2p9G3D
 u4lAfouH4h3kklU7b6MMJ6C4Nk9tuNN0WiAPKVOwL0UFrk7orTfYnsGMwXWcaYNJr3zE
 Q3dxqrxkgNk1jy/SsoOW6wDtO7ZrEcqhnxyoeE0geT8IA91N3F3O2BkZyomMMfIDEr7y
 WUJg==
X-Gm-Message-State: AOAM533CSyQC3nPTLsvTTIrRiEfD3FVXwwn4tINQApyJ/0X341tV5FQ5
 FTh185GsHiJvIfazBS0DnQ2MaFdiD2lYrA==
X-Google-Smtp-Source: ABdhPJy3JpRpBg4WMXBaYNzVrdWKDl4Dc5lDHaJc1a/ZjIUD9OyrnUNOAFFGNGVpScKQcaVXo9pxXppP2Sh1oA==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:4d82:: with SMTP id
 oj2mr1328529pjb.1.1643252951408; Wed, 26 Jan 2022 19:09:11 -0800 (PST)
Date: Wed, 26 Jan 2022 19:08:58 -0800
In-Reply-To: <20220127030858.3269036-1-ricarkol@google.com>
Message-Id: <20220127030858.3269036-6-ricarkol@google.com>
Mime-Version: 1.0
References: <20220127030858.3269036-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 5/5] kvm: selftests: aarch64: use a tighter assert in
 vgic_poke_irq()
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc: maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>
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

vgic_poke_irq() checks that the attr argument passed to the vgic device
ioctl is sane. Make this check tighter by moving it to after the last
attr update.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reported-by: Reiji Watanabe <reijiw@google.com>
Cc: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/lib/aarch64/vgic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
index 79864b941617..f365c32a7296 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -138,9 +138,6 @@ static void vgic_poke_irq(int gic_fd, uint32_t intid,
 	uint64_t val;
 	bool intid_is_private = INTID_IS_SGI(intid) || INTID_IS_PPI(intid);
 
-	/* Check that the addr part of the attr is within 32 bits. */
-	assert(attr <= KVM_DEV_ARM_VGIC_OFFSET_MASK);
-
 	uint32_t group = intid_is_private ? KVM_DEV_ARM_VGIC_GRP_REDIST_REGS
 					  : KVM_DEV_ARM_VGIC_GRP_DIST_REGS;
 
@@ -150,6 +147,9 @@ static void vgic_poke_irq(int gic_fd, uint32_t intid,
 		attr += SZ_64K;
 	}
 
+	/* Check that the addr part of the attr is within 32 bits. */
+	assert((attr & ~KVM_DEV_ARM_VGIC_OFFSET_MASK) == 0);
+
 	/*
 	 * All calls will succeed, even with invalid intid's, as long as the
 	 * addr part of the attr is within 32 bits (checked above). An invalid
-- 
2.35.0.rc0.227.g00780c9af4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
