Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE5B1365
	for <kvmarm@lists.linux.dev>; Sun, 11 Dec 2022 05:17:33 +0000 (UTC)
Received: by mail-pg1-f173.google.com with SMTP id h193so6123273pgc.10
        for <kvmarm@lists.linux.dev>; Sat, 10 Dec 2022 21:17:33 -0800 (PST)
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
        b=mBKqUk9Nryl1xY7L6IPeIunlQpdpv6xGZGOFctf8fIQubeIczcczJ+emCxlR1DyQ2q
         ELSzk4OVR837vrAzNC8o/Lv6ZjEiXaK13W1ac+JkxqNIOxsLCKxNhS9kBPFmX4YaIjfg
         1F/XyFbBgWVa9DzrtnWwzOEYKT2v58U3zmjKp50lX+rNSiRkPLw4NMc4NvU7+5NC5IUf
         XnZnKmKkDX93DoSYOVmdPg7+DMJvD76d5Q10XGNaH5vQvKXjTSf/czV520lW9xRhjqhp
         VApxcUBIPg0JijUhR3vCuxhPF+VucUpvJqOJk9OCjiG0uOsnSYkzb3hc4XyczfMDcm9O
         NdQA==
X-Gm-Message-State: ANoB5plhQeUpoSm6tShcwbVmE1s+VYpOnKmPskRlj5YChLjFtJSKWm26
	Hr4FMkHSTV+bFbMQY228ovhoCw==
X-Google-Smtp-Source: AA0mqf5Pn3/DOoheq6ZMKTkI4FtFVRm6/0Dm0xremwLepva6byCl9K1Nn5R1XWtPEvLo7An3LPgi3Q==
X-Received: by 2002:aa7:90c5:0:b0:572:6e9b:9f9e with SMTP id k5-20020aa790c5000000b005726e9b9f9emr9967229pfk.19.1670735853171;
        Sat, 10 Dec 2022 21:17:33 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id f125-20020a623883000000b00575d90636dcsm3463684pfa.6.2022.12.10.21.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Dec 2022 21:17:32 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: 
Cc: Marc Zyngier <maz@kernel.org>,
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
Subject: [PATCH 2/3] arm64/cache: Move CLIDR macro definitions
Date: Sun, 11 Dec 2022 14:16:59 +0900
Message-ID: <20221211051700.275761-3-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221211051700.275761-1-akihiko.odaki@daynix.com>
References: <20221211051700.275761-1-akihiko.odaki@daynix.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20221211051659.IdYUBWOPRn3y-xb0JQc40-EKkp3kx1yAFora223lXIU@z>

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

