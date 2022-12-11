Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FF43C4332F
	for <kvmarm@archiver.kernel.org>; Sun, 11 Dec 2022 05:17:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A94F4BDBF;
	Sun, 11 Dec 2022 00:17:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@daynix-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U09lAIwUA6vZ; Sun, 11 Dec 2022 00:17:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A38AE4BDB2;
	Sun, 11 Dec 2022 00:17:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 469154BD42
 for <kvmarm@lists.cs.columbia.edu>; Sun, 11 Dec 2022 00:17:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JzchNguBh0Na for <kvmarm@lists.cs.columbia.edu>;
 Sun, 11 Dec 2022 00:17:34 -0500 (EST)
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com
 [209.85.215.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 15E504BDB2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 11 Dec 2022 00:17:34 -0500 (EST)
Received: by mail-pg1-f173.google.com with SMTP id f9so6129032pgf.7
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Dec 2022 21:17:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=4WsGIW0prujF8xnGwWysGoOLhN4qrtpWJqnT9WJSTvs=;
 b=GBN+ZALj8zfq0AkLO/TC4sIe3TmnWeKtF4IkOeoc8WMusywr6GhDL0Lp0DtV/b9H80
 r2RSn84wFOfLraJwQzSw8Ol3XvzwwKaR78jP0W3F7pKI8ztIpMjiwY7oJlP7/fqHM3kv
 v/E4bchTLczJlx5W3+0bm+/4cqkf/4QcHn7pwjuA19ONjM6eRa66N9fiVQsGGUAP00z2
 sx8n06LW1N+PMYFnNzR5ifRwPduryrrgDjPY0a52UjtVUFRTUVY6JNCKNyX80N7UWcZo
 vL8Q7NaX98ODr5ajcnt5fzUtH/F7U+JVwwZREEy10T39mJ9KC2+mK5uzHk+866J9nufQ
 CJhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=4WsGIW0prujF8xnGwWysGoOLhN4qrtpWJqnT9WJSTvs=;
 b=53caC6U6xi4WO4YdFseemN3ik8Vhx0hVzSd3aG34/FMfthTmPukqQEgpoL7xDKi+ZL
 AUHLSs+yeHxxp2ujQ5seGJe+6grdPDx+pZ9I+8SWoPTc9Uu+Uyi170fG6FEaJL+idqga
 UMncF8HjNs6PR33Y5Ue73nD+slU6hu/2NRmKWpgXsPZHemTiGGx/Jh2vtsAOO8wekZZH
 MPSIVREZzC0spqLvqtj2QBa00Ovfo556V89bJi3H3mjpxsKedXy2O8IYk7myfeupPcYX
 aO2WczFWOL0f7w081gP7XkHCYXovzN6cldI/Mbdsz5zCB0rzXXVeBPAkm7CzPyltbQbq
 UXrg==
X-Gm-Message-State: ANoB5plcivh4qpuDY5fgxZh64dYtBZPq6p5VWPJ+5oBLmx94h7WhxMNI
 ZfXi55M1AVntCVqSvz6jPrJVOQ==
X-Google-Smtp-Source: AA0mqf5Pn3/DOoheq6ZMKTkI4FtFVRm6/0Dm0xremwLepva6byCl9K1Nn5R1XWtPEvLo7An3LPgi3Q==
X-Received: by 2002:aa7:90c5:0:b0:572:6e9b:9f9e with SMTP id
 k5-20020aa790c5000000b005726e9b9f9emr9967229pfk.19.1670735853171; 
 Sat, 10 Dec 2022 21:17:33 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
 by smtp.gmail.com with ESMTPSA id
 f125-20020a623883000000b00575d90636dcsm3463684pfa.6.2022.12.10.21.17.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 10 Dec 2022 21:17:32 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: 
Subject: [PATCH 2/3] arm64/cache: Move CLIDR macro definitions
Date: Sun, 11 Dec 2022 14:16:59 +0900
Message-Id: <20221211051700.275761-3-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221211051700.275761-1-akihiko.odaki@daynix.com>
References: <20221211051700.275761-1-akihiko.odaki@daynix.com>
MIME-Version: 1.0
Cc: Alyssa Rosenzweig <alyssa@rosenzweig.io>, Hector Martin <marcan@marcan.st>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Mathieu Poirier <mathieu.poirier@linaro.org>, Marc Zyngier <maz@kernel.org>,
 Sven Peter <sven@svenpeter.dev>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, asahi@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev,
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

The macros are useful for KVM which needs to manage how CLIDR is exposed
to vcpu so move them to include/asm/cache.h, which KVM can refer to.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 arch/arm64/include/asm/cache.h | 6 ++++++
 arch/arm64/kernel/cacheinfo.c  | 5 -----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/cache.h b/arch/arm64/include/asm/cache.h
index c0b178d1bb4f..ab7133654a72 100644
--- a/arch/arm64/include/asm/cache.h
+++ b/arch/arm64/include/asm/cache.h
@@ -16,6 +16,12 @@
 #define CLIDR_LOC(clidr)	(((clidr) >> CLIDR_LOC_SHIFT) & 0x7)
 #define CLIDR_LOUIS(clidr)	(((clidr) >> CLIDR_LOUIS_SHIFT) & 0x7)
 
+/* Ctypen, bits[3(n - 1) + 2 : 3(n - 1)], for n = 1 to 7 */
+#define CLIDR_CTYPE_SHIFT(level)	(3 * (level - 1))
+#define CLIDR_CTYPE_MASK(level)		(7 << CLIDR_CTYPE_SHIFT(level))
+#define CLIDR_CTYPE(clidr, level)	\
+	(((clidr) & CLIDR_CTYPE_MASK(level)) >> CLIDR_CTYPE_SHIFT(level))
+
 /*
  * Memory returned by kmalloc() may be used for DMA, so we must make
  * sure that all such allocations are cache aligned. Otherwise,
diff --git a/arch/arm64/kernel/cacheinfo.c b/arch/arm64/kernel/cacheinfo.c
index 97c42be71338..daa7b3f55997 100644
--- a/arch/arm64/kernel/cacheinfo.c
+++ b/arch/arm64/kernel/cacheinfo.c
@@ -11,11 +11,6 @@
 #include <linux/of.h>
 
 #define MAX_CACHE_LEVEL			7	/* Max 7 level supported */
-/* Ctypen, bits[3(n - 1) + 2 : 3(n - 1)], for n = 1 to 7 */
-#define CLIDR_CTYPE_SHIFT(level)	(3 * (level - 1))
-#define CLIDR_CTYPE_MASK(level)		(7 << CLIDR_CTYPE_SHIFT(level))
-#define CLIDR_CTYPE(clidr, level)	\
-	(((clidr) & CLIDR_CTYPE_MASK(level)) >> CLIDR_CTYPE_SHIFT(level))
 
 int cache_line_size(void)
 {
-- 
2.38.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
