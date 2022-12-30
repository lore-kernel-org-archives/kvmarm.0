Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E93C4167B
	for <kvmarm@archiver.kernel.org>; Fri, 30 Dec 2022 09:55:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7964A4A0D6;
	Fri, 30 Dec 2022 04:55:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@daynix-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5aYtqxskNlR6; Fri, 30 Dec 2022 04:55:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C6034B3E0;
	Fri, 30 Dec 2022 04:55:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FF464B24C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Dec 2022 04:55:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RFU7iaEXg5ly for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Dec 2022 04:55:17 -0500 (EST)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
 [209.85.216.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E3C084A0D6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Dec 2022 04:55:16 -0500 (EST)
Received: by mail-pj1-f49.google.com with SMTP id
 gv5-20020a17090b11c500b00223f01c73c3so20141163pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Dec 2022 01:55:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=4WsGIW0prujF8xnGwWysGoOLhN4qrtpWJqnT9WJSTvs=;
 b=MZ6hFxp5qb6KiM3qQ8o8778D0L6Lw+2wriw4sEEuZvPRigiDoS8q20iBToS0o8mTbr
 8UOGh6wBCkHuycrokxGKZ4NTVN5uQZSEuvHR7gzhS2+91NYif0CMakcWPjQvot4xaAnN
 kIOvYiyWnjVNbJtIDYqZDdSIA+SB8xBhoVH7WJEOnmynYxuSyJ5aBQIjTjrtf9hOSlBL
 AfIX9IV7sdlPCbp4GqUEztdfZ8RTVdjOpZXDELTHY3reO2aczIVPa6xmQIDNkHg9v6kV
 dmQLbjAt4B1fV50c8E0Mk4JkDGZFAas4wwraQ7HBhmWI2p0CDi2RMsjxTycA9zfR08JG
 bGEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=4WsGIW0prujF8xnGwWysGoOLhN4qrtpWJqnT9WJSTvs=;
 b=GQkJ3PuaDN1a9IT6tWkwrB9DCbVUXCc1oa2KWwVgTzwH0p76kXls+53qvRVLrfvFur
 7O6kz8SojFPVxXSiiWrumjp/G9akv+BuxQ61Xo0aLnlnMu5J/+xmOVhGu6CIBdwmvgde
 wvA2Xu6d1s/IJS73wDkgCfzf0tZupAR3eoCka+u7iGEvKjXCEBpJty7xjUE9YCJgg2bp
 +O6MTCJhfoSTIxtw9VBFsqL7CwPoHmoxX/EdJEukmx+bjtdf878PEBMNNCuEZ28KTuGN
 L7GaA61GuyQjmMIFaDdK51q5dng91Yc4ptvHMtv7FARdO9Cv0mS9DvxaTQan0sPOsw9J
 5SFQ==
X-Gm-Message-State: AFqh2krIeM9oiXbJvCaFeI6VWo6hosokABWBt9A5cdhT8sopYQF+mPyR
 ALMh73lSGsL5Rnmp9WoUMZ2ANw==
X-Google-Smtp-Source: AMrXdXss13QkrMhRA6dr0nvpfHQKU4tawzB8AD/+ZDrDtMGJ64TnpAhtOhFlWJsYFDiTDW6CVK9iCg==
X-Received: by 2002:a17:902:d051:b0:192:581b:25d3 with SMTP id
 l17-20020a170902d05100b00192581b25d3mr26381526pll.17.1672394116193; 
 Fri, 30 Dec 2022 01:55:16 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
 by smtp.gmail.com with ESMTPSA id
 b7-20020a170902650700b00189c536c72asm14487719plk.148.2022.12.30.01.55.12
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 30 Dec 2022 01:55:15 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: 
Subject: [PATCH v5 4/7] arm64/cache: Move CLIDR macro definitions
Date: Fri, 30 Dec 2022 18:54:49 +0900
Message-Id: <20221230095452.181764-5-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221230095452.181764-1-akihiko.odaki@daynix.com>
References: <20221230095452.181764-1-akihiko.odaki@daynix.com>
MIME-Version: 1.0
Cc: Alyssa Rosenzweig <alyssa@rosenzweig.io>, Hector Martin <marcan@marcan.st>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Mathieu Poirier <mathieu.poirier@linaro.org>, Marc Zyngier <maz@kernel.org>,
 Sven Peter <sven@svenpeter.dev>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
 asahi@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
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
