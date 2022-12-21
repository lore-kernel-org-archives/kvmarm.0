Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32AFEC10F1B
	for <kvmarm@archiver.kernel.org>; Wed, 21 Dec 2022 20:40:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAB8F4B920;
	Wed, 21 Dec 2022 15:40:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@daynix-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B2D6xsfzx87q; Wed, 21 Dec 2022 15:40:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 587A14B8DD;
	Wed, 21 Dec 2022 15:40:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA7F44B894
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Dec 2022 15:40:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U7sfZgUmuMTy for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Dec 2022 15:40:42 -0500 (EST)
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com
 [209.85.215.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E57D4B858
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Dec 2022 15:40:42 -0500 (EST)
Received: by mail-pg1-f179.google.com with SMTP id 79so11134029pgf.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Dec 2022 12:40:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=4WsGIW0prujF8xnGwWysGoOLhN4qrtpWJqnT9WJSTvs=;
 b=5BNXcx+yVcvjVST07KdLCwlGojojI6xGkRm4KeY/o+eAzJQ0jMUF3Fdwf77uRZ3bLP
 3PgWtnxnFNfngQMa4EYpwEJAXndL+F6WHN53P6g1XCO+iQCQ3AFv6Z4jtP6R2TytJycv
 k5MblYDaS5RrONaYWAFw9HzXVerlr4oaybDnxAbDj7obSkXdz97+I4FKN75zL+J7+bcH
 xpJMBRlsNL+NQPNE/gFjVMCaSJ5IPyCk3/O4ys70IIktO+HU8yeoPLUkupJsa56MgzLI
 vMSPAcVKaSHL8WoVix7haxr/bHy+ka/se9IX0UWFfFNCYWHWGBQdt6ReGNnSw2cG6rmc
 ++CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=4WsGIW0prujF8xnGwWysGoOLhN4qrtpWJqnT9WJSTvs=;
 b=Dzs5P79f8Ta3+CpKZjfSmUYj0JoGQUUuMm7F1wMOtv0YAffkEriOn1lWdfVXUvX5t+
 KD9j+HrGjgrpZArnPWePyuK9qz/KPliL4nV9ZHSy8Lik5QEAvX9o0IUJhNCpiD9Nz5O5
 lzGQb1hJ2R2SHlPbV/Y7V3nYcdEm6PkupD6ja8BRG0yTMm6QIi2xRgIiCa/9dbmTmLL7
 Aul4QdfJVfTef9rNyD4b1uFN7fQecrOmsHs9wI54Q4tQfX9lNXXUj4rzvDbCoUTU4Ho0
 qLt+SbFmK35qVwnxlJoqA1iE5zne05xnvOT8rIv+zhdKEvI3349nlcBwY/cefSq1dNkT
 HGmQ==
X-Gm-Message-State: AFqh2kqUPEVgSAj+vMV905nwP0YgZQCx6lYom1GmEjAlZakiMthv8n36
 5TxGTWuAr/MoQ9aE9tdsDmQoRw==
X-Google-Smtp-Source: AMrXdXv7CZYsyHTYocefuPTzARxhO0WGgu2LfUtC7x0rzE47hkCIXZKXxT/E/wO/l1Z5CSyjB6pSZA==
X-Received: by 2002:a62:1d87:0:b0:572:8b7d:f350 with SMTP id
 d129-20020a621d87000000b005728b7df350mr3510660pfd.26.1671655241787; 
 Wed, 21 Dec 2022 12:40:41 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
 by smtp.gmail.com with ESMTPSA id
 r4-20020aa79884000000b005763c22ea07sm11017784pfl.74.2022.12.21.12.40.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 21 Dec 2022 12:40:41 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: 
Subject: [PATCH v4 4/7] arm64/cache: Move CLIDR macro definitions
Date: Thu, 22 Dec 2022 05:40:13 +0900
Message-Id: <20221221204016.658874-5-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221221204016.658874-1-akihiko.odaki@daynix.com>
References: <20221221204016.658874-1-akihiko.odaki@daynix.com>
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
