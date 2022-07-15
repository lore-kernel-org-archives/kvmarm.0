Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8087FC43334
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 06:11:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 360144BC20;
	Fri, 15 Jul 2022 02:11:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pWGKyNodfLzf; Fri, 15 Jul 2022 02:11:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E9A74BD07;
	Fri, 15 Jul 2022 02:11:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5B3D4BDC9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:11:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Fx8ZTqrNY-YM for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 02:11:17 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9BE5D4BC31
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:11:16 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 m123-20020a253f81000000b0066ff6484995so64371yba.22
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 23:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=SVXMXCA9EUcm/U2NL9bFju/llGCppObF5hU8u8qx8a0=;
 b=KmS2wN930EG2IxdxCnUBJhmowSVq6hfGSEB+wly2itZQ8X0cteyEWcAfiVvdqRbU42
 yYenX7Dwez5VU+bNvMLNDm0ctaQ8BCMSiSb//Vn6c9oX9+SeTSiSZ36Uppd4JnBxxR78
 znl5dMF7OcbOnChFRV8zbNqv7wgOjwrgyxDU7Zpy0l4ynJg4HhJ/jccQUGXF4i2S8cNB
 pmV7nKb0B8X7Ula4KBpHNLEaM8aGRY3TVfgMp+m21+vceYD9GUOqJg6gPXDD2fptehJA
 kKrsWzYrZSbpOf11gT0kv72fBfdnYXt/tvhluVpxYNQ4o6shoPvFr2NEyL983QhMwnAC
 Jx5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=SVXMXCA9EUcm/U2NL9bFju/llGCppObF5hU8u8qx8a0=;
 b=s5M7Wagn+mDw1hDFa57EigDTkadoy9rW7YiG2B9MJtSOPf2UJnUnxIi4y7LV6ZH90g
 Ui/+TmT6akaykfy8jB6zCjjTQQgsTFissW6g6s5LmrbX0OjrScyPGcvTcNToTWIGAeMf
 /iIze8oGqGk/q5BdNNVaUhK/OGIQN36KmvjArA956i/uQC+x0jKCM3IUnGs5blhZLcNb
 mw55BL7sWNs2+cRWdx7NiCztCAGvAMuIQfwXEcTOXX4z7EnXYfUCGaibIjQam4H4ZgPG
 J1Y2c0LUtGsGZP8dFyUkgDSA4NXAIwRxLdHnGpvbJDbILQmQP8SSgQFuxCEWEhNJtpI8
 MUzA==
X-Gm-Message-State: AJIora8hGHaKacArPi//rx7rDNA+V2T5VJn6085cZy6sIBR/hC1/6dJN
 IV4HuvUu6t64Jx8vnE2gkY6g0IBo9XG99mj0CQ==
X-Google-Smtp-Source: AGRyM1s7bBaJTn0X9XWOnvyD6RIVfSqUuJ1lmnLuGoAg+cY+w4t8dDFpOLAfqJACW8rVgQZNFvvWoSacW1dpR4y6cQ==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:f010:455b:62ce:19e])
 (user=kaleshsingh job=sendgmr) by 2002:a81:6fc3:0:b0:31c:8c75:3eb8 with SMTP
 id k186-20020a816fc3000000b0031c8c753eb8mr14112217ywc.225.1657865476241; Thu,
 14 Jul 2022 23:11:16 -0700 (PDT)
Date: Thu, 14 Jul 2022 23:10:15 -0700
In-Reply-To: <20220715061027.1612149-1-kaleshsingh@google.com>
Message-Id: <20220715061027.1612149-7-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v4 06/18] arm64: stacktrace: Add description of
 stacktrace/common.h
From: Kalesh Singh <kaleshsingh@google.com>
To: maz@kernel.org, mark.rutland@arm.com, broonie@kernel.org, 
 madvenka@linux.microsoft.com
Cc: wangkefeng.wang@huawei.com, elver@google.com, catalin.marinas@arm.com,
 ast@kernel.org, vincenzo.frascino@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, android-mm@google.com, andreyknvl@gmail.com,
 kernel-team@android.com, drjones@redhat.com,
 linux-arm-kernel@lists.infradead.org, russell.king@oracle.com,
 linux-kernel@vger.kernel.org, mhiramat@kernel.org
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

Add brief description on how to use stacktrace/common.h to implement
a stack unwinder.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 arch/arm64/include/asm/stacktrace/common.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
index f86efe71479d..b362086f4c70 100644
--- a/arch/arm64/include/asm/stacktrace/common.h
+++ b/arch/arm64/include/asm/stacktrace/common.h
@@ -2,6 +2,14 @@
 /*
  * Common arm64 stack unwinder code.
  *
+ * To implement a new arm64 stack unwinder:
+ *     1) Include this header
+ *
+ *     2) Provide implementations for the following functions:
+ *            - on_overflow_stack()
+ *            - on_accessible_stack()
+ *            - unwind_next()
+ *
  * Copyright (C) 2012 ARM Ltd.
  */
 #ifndef __ASM_STACKTRACE_COMMON_H
-- 
2.37.0.170.g444d1eabd0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
