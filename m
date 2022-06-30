Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 350B5CCA47B
	for <kvmarm@archiver.kernel.org>; Fri,  1 Jul 2022 14:25:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A9DEA4B5B7;
	Fri,  1 Jul 2022 10:25:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QR6EPXWzYNkr; Fri,  1 Jul 2022 10:25:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77A904B5C4;
	Fri,  1 Jul 2022 10:25:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 677014B4D4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2022 12:12:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Zp6FgWuAFskR for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jun 2022 12:12:31 -0400 (EDT)
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com
 [209.85.219.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6854B4B471
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2022 12:12:31 -0400 (EDT)
Received: by mail-qv1-f49.google.com with SMTP id u7so8024467qvm.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2022 09:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=HIeZ7ZUFR8uUdavug06JIRw9ETH7oXgy29YJGJmtVOc=;
 b=b+M1vpvBViKPkT7LE/wlsBdInOEtZXiDskB4CB2QW8+u5WsEPZF0c1RMTs2h9V3xZs
 pfIZKzeFDEP6J/hbU1K0tq5ZovFpcUV+u9+O56dor8++DCNgfXqQc4mnBtSZkGHlVOqh
 VR/SMgpXHDLtwHmihcb2288zkxNweUUqu76i4ke3qQmQiZLoSYWT/3waOCXJ975kQNp3
 G3CDLaQJl45OvtgT5ElISQgnBF3OmbgRogKE2McTxZxpwjXnJHP331Wy5fVKUBr5gVla
 BADiWcfdnke7tA6xZ3LEGvCAhLh7sb3mtZuJrN+DQ7NMpx5pg3HH8d6AkU+v2ZRj9iHr
 CSIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=HIeZ7ZUFR8uUdavug06JIRw9ETH7oXgy29YJGJmtVOc=;
 b=Hgt/VQXGRd2caQ4EJoWycth8Lh5VTWSaW3Af1ZBNQfW0ahHP/reXUMLMqI6egg+Sgf
 6IXS6UFHRsGRctBMMTrxZXngfGE18hH5XwngxoHHtJ/0DFUE87PNp/cF8QhL/0Eft6lg
 d1THPu/imgkvBBWpNalVMRW9OWf2JvayckI5G0fsEjeMaL8TVaJDyQf6vhxghfyqxtMN
 Gzd9NEEI+t3gUcgosYBdxMEc14sVp5Ulp9oNsac+wvkODY7heLAAZO8b64JEu4pdzkkB
 hVKSIaeSIsXKb1558d1KzOAE+Bcdi+5wEMzfNoO/lMyiwA/RoK9Lm7peSiW52uqGxabc
 QSBg==
X-Gm-Message-State: AJIora9jnX1SmsAKeX+qrCVtgU2CURkyrDU0ga4TCTS8yEkHEIchBJaH
 3xyElJ1A2URfiN9kqrc65zA=
X-Google-Smtp-Source: AGRyM1tAaGFAfiUdUktuJ8iBabBFgwZixm+u5RXS89XZXpvo6BcLDkTfSf7S7wxlSX5pUf+1WfdSsQ==
X-Received: by 2002:ac8:5c0c:0:b0:31b:b39b:12b0 with SMTP id
 i12-20020ac85c0c000000b0031bb39b12b0mr8264577qti.4.1656605550844; 
 Thu, 30 Jun 2022 09:12:30 -0700 (PDT)
Received: from MBP.hobot.cc (ec2-13-59-0-164.us-east-2.compute.amazonaws.com.
 [13.59.0.164]) by smtp.gmail.com with ESMTPSA id
 m14-20020a05620a24ce00b006af59e9ddeasm6623151qkn.18.2022.06.30.09.12.26
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Thu, 30 Jun 2022 09:12:30 -0700 (PDT)
From: Schspa Shi <schspa@gmail.com>
To: maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
 suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org
Subject: [PATCH] KVM: arm64: Fix 64 bit mmio handle
Date: Fri,  1 Jul 2022 00:12:20 +0800
Message-Id: <20220630161220.53449-1-schspa@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
X-Mailman-Approved-At: Fri, 01 Jul 2022 10:25:03 -0400
Cc: Schspa Shi <schspa@gmail.com>, kvmarm@lists.cs.columbia.edu,
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

If the len is 8 bytes, we can't get the correct sign extend for
be system.

Fix the mask type len and the comparison of length.

Signed-off-by: Schspa Shi <schspa@gmail.com>
---
 arch/arm64/kvm/mmio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index 3dd38a151d2a6..0692f8b18f35c 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -81,8 +81,8 @@ unsigned long kvm_mmio_read_buf(const void *buf, unsigned int len)
 int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
 {
 	unsigned long data;
+	unsigned long mask;
 	unsigned int len;
-	int mask;
 
 	/* Detect an already handled MMIO return */
 	if (unlikely(!vcpu->mmio_needed))
@@ -97,7 +97,7 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
 		data = kvm_mmio_read_buf(run->mmio.data, len);
 
 		if (kvm_vcpu_dabt_issext(vcpu) &&
-		    len < sizeof(unsigned long)) {
+		    len <= sizeof(unsigned long)) {
 			mask = 1U << ((len * 8) - 1);
 			data = (data ^ mask) - mask;
 		}
-- 
2.37.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
