Return-Path: <SRS0=DlSC=3K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E43DBC32771
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 03:10:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5EAB022522
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 03:10:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=lixom-net.20150623.gappssmtp.com header.i=@lixom-net.20150623.gappssmtp.com header.b="obSsmlOZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5EAB022522
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lixom.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A964F4AF36;
	Mon, 20 Jan 2020 22:10:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@lixom-net.20150623.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GDyM7asAnrd3; Mon, 20 Jan 2020 22:10:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B09704AF62;
	Mon, 20 Jan 2020 22:10:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 388264AF41
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jan 2020 22:10:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ErAAHOFQ+ldu for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jan 2020 22:10:16 -0500 (EST)
Received: from mail-ot1-f67.google.com (mail-ot1-f67.google.com
 [209.85.210.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3F5E64AF36
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jan 2020 22:10:16 -0500 (EST)
Received: by mail-ot1-f67.google.com with SMTP id k14so1683511otn.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jan 2020 19:10:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=lixom-net.20150623.gappssmtp.com; s=20150623;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=7MzOR4y/pXguWn5IQ89Q0tDjVovjCl/+UcDac9xvay4=;
 b=obSsmlOZyGgl53mldrUHp5ESb6XMeWgbX60wlkoH+RUO531i7SPFp9ijCtUKMjl/Iq
 YKyD9NE3Mvt1wXPOBNlJe9asmirSV96DwsfoW/0xFi0bu2S65zjZS+BhMAkUOs1tVLBp
 sOU1mOBOLUwWQZ5VZs1DxiMk+umcN6Zx7kJmgtPZAu0FO9v8LnNRwUokKU2n2LONTHDv
 XqP2x5Rnwi0hTdPPZ5cJRqnEgHEmLlZ475J69CcBATxfS4YSr6ECun6reH8QUBznLwYf
 f2UUH+C2nKX02AAmTNrrqepSlhNk62FuzSnxh96PIqBt4rMfDV86VXDz292u6MBV1pFC
 e+VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=7MzOR4y/pXguWn5IQ89Q0tDjVovjCl/+UcDac9xvay4=;
 b=fosIwt4qUws/XDCZ1wXx9UCJXoOmMg0VA++izeop7sEZQhcQvdfwnXR3Mv4gwAI6Yf
 G3aBymjxUZpMxdBmxScPy2myXBj7LdoCxbhzzLR70S4sEhEsc0og6tOceNeqCLt8y32i
 poEbZHXnTxRVJg2GUNDj/rFIa0NrIkmfgteceIXALAW1Rpg6U+JRiPc52brwHDbAH+E8
 gwSQ3llDujPwb/udaf30YrBbQvMQr+rPhT9YUEn1VXDRpFfl6ZBMeYOWA5vFYR9kPu1e
 Qgt0DcsbQkAx0LESI9cgvAsxZQ2GddM2ou5U5/4oB8A8u6FGwIBWDbsno7rao4Zu7UUN
 nByg==
X-Gm-Message-State: APjAAAXUMPala4Y1AYFnCGRvUwBJM1C5a5mwQeAhgXrtVxGyG/AgAGSE
 gJDrCh8V0YUDDwVNjkUZCQjfqA==
X-Google-Smtp-Source: APXvYqyvaV2rCEBgvI10MHLlZ0aSdyhfnWyYXTCOVnmWZxuLw1UwCgWSEWAlb8sQ0KkG2J7R9RkY2w==
X-Received: by 2002:a9d:7315:: with SMTP id e21mr2079400otk.255.1579576215363; 
 Mon, 20 Jan 2020 19:10:15 -0800 (PST)
Received: from rip.lixom.net (99-152-116-91.lightspeed.sntcca.sbcglobal.net.
 [99.152.116.91])
 by smtp.gmail.com with ESMTPSA id l17sm13384612ota.27.2020.01.20.19.10.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 20 Jan 2020 19:10:14 -0800 (PST)
From: Olof Johansson <olof@lixom.net>
To: maz@kernel.org
Subject: [PATCH] KVM: arm: Fix build after MMIO cleanup
Date: Mon, 20 Jan 2020 19:10:07 -0800
Message-Id: <20200121031007.106259-1-olof@lixom.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200119181116.374-1-maz@kernel.org>
References: <20200119181116.374-1-maz@kernel.org>
MIME-Version: 1.0
Cc: Olof Johansson <olof@lixom.net>, kvmarm@lists.cs.columbia.edu,
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

Looks like the mmio_decode field was accidentally left in on 32-bit:

In file included from /build/include/linux/kvm_host.h:36,
                 from /build/arch/arm/kernel/asm-offsets.c:15:
arch/arm/include/asm/kvm_host.h:205:20: error: field 'mmio_decode' has incomplete type

Fixes: 480bfa6478c8 ("KVM: arm/arm64: Cleanup MMIO handling")
Cc: Marc Zyngier <maz@kernel.org>
Signed-off-by: Olof Johansson <olof@lixom.net>
---
 arch/arm/include/asm/kvm_host.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index acf4c87e8321a..bd2233805d995 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -201,9 +201,6 @@ struct kvm_vcpu_arch {
 	 /* Don't run the guest (internal implementation need) */
 	bool pause;
 
-	/* IO related fields */
-	struct kvm_decode mmio_decode;
-
 	/* Cache some mmu pages needed inside spinlock regions */
 	struct kvm_mmu_memory_cache mmu_page_cache;
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
