Return-Path: <SRS0=czFP=WD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4A4CC32751
	for <kvmarm@archiver.kernel.org>; Wed,  7 Aug 2019 14:21:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 27C3C22297
	for <kvmarm@archiver.kernel.org>; Wed,  7 Aug 2019 14:21:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="drMMWUFk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 27C3C22297
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93A044A521;
	Wed,  7 Aug 2019 10:21:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@embeddedor.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ivn1T-rIqFlh; Wed,  7 Aug 2019 10:21:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6402F4A53D;
	Wed,  7 Aug 2019 10:21:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DAAB04A521
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Aug 2019 10:21:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RopnSyy00dro for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Aug 2019 10:21:19 -0400 (EDT)
Received: from gateway33.websitewelcome.com (gateway33.websitewelcome.com
 [192.185.145.221])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E91DA4A51E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Aug 2019 10:21:18 -0400 (EDT)
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
 by gateway33.websitewelcome.com (Postfix) with ESMTP id 438C545068
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Aug 2019 09:19:00 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22]) by cmsmtp with SMTP
 id vMmKhPJLu2qH7vMmKhPzR8; Wed, 07 Aug 2019 09:19:00 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
 Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=Q4XlPP8r8yKUbSLfBeAIYz2SX/WPMQPawI2raqSQbRQ=; b=drMMWUFk1dFukbXswk0QM29P4T
 6q/nUfiCSWASASq7IlnUVX4PQoGKupHId0MBy2lqYQBGBTyLJQMtAS1OsjvtWsULh22vHI7BwN7wM
 PAi1I/hc7mAEwoQP4yJdPrXOh0g0ncp8MPpq6YIJbXv/e5cV88nML+zY9QglDOfKDEYdITAQ1ovkK
 xRQRC1/PpGRXZi0L9QyXUjpqpqr0rOCQSVlnH5nCS1qkQ+s2VTK+bbsVwzxDxZdszANqjtw0h5t0U
 3qYpsfpQMvyV1xJuAnx5DyZuUw7VjqKTKy7c37dbT4CQzzFRBIJe3OKv5l6CF5I6uQc5HGZ7cdfUQ
 JhBBuzng==;
Received: from [187.192.11.120] (port=53418 helo=embeddedor)
 by gator4166.hostgator.com with esmtpa (Exim 4.92)
 (envelope-from <gustavo@embeddedor.com>)
 id 1hvMmI-003qOi-V3; Wed, 07 Aug 2019 09:18:59 -0500
Date: Wed, 7 Aug 2019 09:18:57 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Subject: [PATCH] arm64: KVM: hyp: debug-sr: Mark expected switch fall-throughs
Message-ID: <20190807141857.GA4198@embeddedor>
MIME-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse,
 please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - lists.cs.columbia.edu
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.192.11.120
X-Source-L: No
X-Exim-ID: 1hvMmI-003qOi-V3
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [187.192.11.120]:53418
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 8
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
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

Mark switch cases where we are expecting to fall through.

This patch fixes the following warnings (Building: allmodconfig arm64):

arch/arm64/kvm/hyp/debug-sr.c:20:19: warning: this statement may fall through [-Wimplicit-fallthrough=]
arch/arm64/kvm/hyp/debug-sr.c:21:19: warning: this statement may fall through [-Wimplicit-fallthrough=]
arch/arm64/kvm/hyp/debug-sr.c:22:19: warning: this statement may fall through [-Wimplicit-fallthrough=]
arch/arm64/kvm/hyp/debug-sr.c:23:19: warning: this statement may fall through [-Wimplicit-fallthrough=]
arch/arm64/kvm/hyp/debug-sr.c:24:19: warning: this statement may fall through [-Wimplicit-fallthrough=]
arch/arm64/kvm/hyp/debug-sr.c:25:19: warning: this statement may fall through [-Wimplicit-fallthrough=]
arch/arm64/kvm/hyp/debug-sr.c:26:18: warning: this statement may fall through [-Wimplicit-fallthrough=]
arch/arm64/kvm/hyp/debug-sr.c:27:18: warning: this statement may fall through [-Wimplicit-fallthrough=]
arch/arm64/kvm/hyp/debug-sr.c:28:18: warning: this statement may fall through [-Wimplicit-fallthrough=]
arch/arm64/kvm/hyp/debug-sr.c:29:18: warning: this statement may fall through [-Wimplicit-fallthrough=]
arch/arm64/kvm/hyp/debug-sr.c:30:18: warning: this statement may fall through [-Wimplicit-fallthrough=]
arch/arm64/kvm/hyp/debug-sr.c:31:18: warning: this statement may fall through [-Wimplicit-fallthrough=]
arch/arm64/kvm/hyp/debug-sr.c:32:18: warning: this statement may fall through [-Wimplicit-fallthrough=]
arch/arm64/kvm/hyp/debug-sr.c:33:18: warning: this statement may fall through [-Wimplicit-fallthrough=]
arch/arm64/kvm/hyp/debug-sr.c:34:18: warning: this statement may fall through [-Wimplicit-fallthrough=]

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 arch/arm64/kvm/hyp/debug-sr.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index 26781da3ad3e..0fc9872a1467 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -18,40 +18,70 @@
 #define save_debug(ptr,reg,nr)						\
 	switch (nr) {							\
 	case 15:	ptr[15] = read_debug(reg, 15);			\
+			/* Fall through */				\
 	case 14:	ptr[14] = read_debug(reg, 14);			\
+			/* Fall through */				\
 	case 13:	ptr[13] = read_debug(reg, 13);			\
+			/* Fall through */				\
 	case 12:	ptr[12] = read_debug(reg, 12);			\
+			/* Fall through */				\
 	case 11:	ptr[11] = read_debug(reg, 11);			\
+			/* Fall through */				\
 	case 10:	ptr[10] = read_debug(reg, 10);			\
+			/* Fall through */				\
 	case 9:		ptr[9] = read_debug(reg, 9);			\
+			/* Fall through */				\
 	case 8:		ptr[8] = read_debug(reg, 8);			\
+			/* Fall through */				\
 	case 7:		ptr[7] = read_debug(reg, 7);			\
+			/* Fall through */				\
 	case 6:		ptr[6] = read_debug(reg, 6);			\
+			/* Fall through */				\
 	case 5:		ptr[5] = read_debug(reg, 5);			\
+			/* Fall through */				\
 	case 4:		ptr[4] = read_debug(reg, 4);			\
+			/* Fall through */				\
 	case 3:		ptr[3] = read_debug(reg, 3);			\
+			/* Fall through */				\
 	case 2:		ptr[2] = read_debug(reg, 2);			\
+			/* Fall through */				\
 	case 1:		ptr[1] = read_debug(reg, 1);			\
+			/* Fall through */				\
 	default:	ptr[0] = read_debug(reg, 0);			\
 	}
 
 #define restore_debug(ptr,reg,nr)					\
 	switch (nr) {							\
 	case 15:	write_debug(ptr[15], reg, 15);			\
+			/* Fall through */				\
 	case 14:	write_debug(ptr[14], reg, 14);			\
+			/* Fall through */				\
 	case 13:	write_debug(ptr[13], reg, 13);			\
+			/* Fall through */				\
 	case 12:	write_debug(ptr[12], reg, 12);			\
+			/* Fall through */				\
 	case 11:	write_debug(ptr[11], reg, 11);			\
+			/* Fall through */				\
 	case 10:	write_debug(ptr[10], reg, 10);			\
+			/* Fall through */				\
 	case 9:		write_debug(ptr[9], reg, 9);			\
+			/* Fall through */				\
 	case 8:		write_debug(ptr[8], reg, 8);			\
+			/* Fall through */				\
 	case 7:		write_debug(ptr[7], reg, 7);			\
+			/* Fall through */				\
 	case 6:		write_debug(ptr[6], reg, 6);			\
+			/* Fall through */				\
 	case 5:		write_debug(ptr[5], reg, 5);			\
+			/* Fall through */				\
 	case 4:		write_debug(ptr[4], reg, 4);			\
+			/* Fall through */				\
 	case 3:		write_debug(ptr[3], reg, 3);			\
+			/* Fall through */				\
 	case 2:		write_debug(ptr[2], reg, 2);			\
+			/* Fall through */				\
 	case 1:		write_debug(ptr[1], reg, 1);			\
+			/* Fall through */				\
 	default:	write_debug(ptr[0], reg, 0);			\
 	}
 
-- 
2.22.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
