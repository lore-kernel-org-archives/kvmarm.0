Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450DD33DD
	for <kvmarm@lists.linux.dev>; Wed, 21 Dec 2022 20:40:42 +0000 (UTC)
Received: by mail-pg1-f176.google.com with SMTP id b12so11149387pgj.6
        for <kvmarm@lists.linux.dev>; Wed, 21 Dec 2022 12:40:42 -0800 (PST)
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
        b=wFNUuZaqGEYenYjaS+KR/i4AsSb70p45SVjxh5M/QvCkduQMMoHFSq+TcozYCKAeCX
         F/6txrRmTBKXmJnBLTingGseo9hrrSEtfOeabaS836Yl/ucFzWxllfYxXiJukh9P44x6
         vMg7UemlJxjgdX2E+Gpi2mjmDyQ9jgwUtit8Q/jF+CoHKIyFvlnY5o2nupgfkGtBuRAV
         RA/ssqXMldsPny4pzrqYVhz2l7qYFgBBWwS48OP0vR0lWYf2sDJ7v3/zSd0cesBWY956
         aONY0Ywpb3jdPmr6TxGQ57meXXhlRyYhgmUCKZbLVSlZNHJgxMUklpvGyvphdx+iU/cS
         qc1w==
X-Gm-Message-State: AFqh2kqZRxQPq2eHcjex78aVuU9PLZex6nBK6zQAJUKuKbnsskbCYgHR
	rFcmzmFhcO2yaAZpLK6dln+bvQ==
X-Google-Smtp-Source: AMrXdXv7CZYsyHTYocefuPTzARxhO0WGgu2LfUtC7x0rzE47hkCIXZKXxT/E/wO/l1Z5CSyjB6pSZA==
X-Received: by 2002:a62:1d87:0:b0:572:8b7d:f350 with SMTP id d129-20020a621d87000000b005728b7df350mr3510660pfd.26.1671655241787;
        Wed, 21 Dec 2022 12:40:41 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id r4-20020aa79884000000b005763c22ea07sm11017784pfl.74.2022.12.21.12.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 12:40:41 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: 
Cc: Mark Brown <broonie@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	asahi@lists.linux.dev,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Sven Peter <sven@svenpeter.dev>,
	Hector Martin <marcan@marcan.st>,
	Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH v4 4/7] arm64/cache: Move CLIDR macro definitions
Date: Thu, 22 Dec 2022 05:40:13 +0900
Message-ID: <20221221204016.658874-5-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221221204016.658874-1-akihiko.odaki@daynix.com>
References: <20221221204016.658874-1-akihiko.odaki@daynix.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20221221204013.zOz-7mksPx3ecSUtJJchv4lS-fsaNgO-7mTS_wp9dMM@z>

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

