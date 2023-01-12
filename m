Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698DB378
	for <kvmarm@lists.linux.dev>; Thu, 12 Jan 2023 02:39:23 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id o1-20020a17090a678100b00219cf69e5f0so22119014pjj.2
        for <kvmarm@lists.linux.dev>; Wed, 11 Jan 2023 18:39:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q11Z4l9+meOu0rzmEtmKXYHwkGk1nv/AXC1xA1NUM9A=;
        b=oL3TZ2dQxMBhcKitnoQhS1LoJ6uR2+zkvR8Eqz84efKSa0hVT8TfnGnO7R6drx+20E
         PNdOLie+7x4MOuZr4VI87moTqvVmPRKURVNWr4Bat8BBueScZjuYH75Gtesd8J3U4nO9
         GCepPYEPp5As+lhcQeDXihSh7ny+enh8oSYTD/gX02dL5gB5mEIUvU/0icGTXJv3zChb
         LMcriZSgeA8hD0Vo1yXV3I+l3jAmqvNG/ho1FaTbgR/GDFbZWEPEBU++O8Pz6S4LahrU
         yesMbxzBcKMRmwjElahvrCSTJk+uKumdCYCyGCbhxdd92RGq2+lJQShqQLS+0lM/u15Q
         JaKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q11Z4l9+meOu0rzmEtmKXYHwkGk1nv/AXC1xA1NUM9A=;
        b=FzQ4m9qKPn9y3rteZwwS8WwBqnGeGXuWXAVIqjbp0H11Pq+HzxCSAvmYwgsz/hffSo
         o2m1P7OJuf9O8Y1gsEf6xHdmEe3NZsQ3romtL5cXqpg00hbf7s9LjnBkDQGMFvNTT6NM
         7TNGlKOnkWjxk/vIqvB5vX56W7fvlK09B9A/X+yqWnew7MYryt6AMq2SxOLYNgNw5q3b
         QKhHVcPpoofev7jj0ZWZ6u4Jbl8QkDBjYLXne1diKgkbAqJY/03Vl98xpjyAAOuA3wJH
         EZFRwYwesORLPC/gv8AwQkbdCV6ohXrxHm4vx/Arj4jL2MWFdubZG7E6KhRZ74gZTi4u
         roVw==
X-Gm-Message-State: AFqh2krHsfStVvSeOxt8IYvKDG/9NJxREIr8rDwFPgdTwRUblZ2nCaue
	OJI8EZvolSNzrzcZ1iFQmpMr+w==
X-Google-Smtp-Source: AMrXdXs4JCW4EgJN6T2CnYFlcBDqDu57etx9LSqwZ4HIj1zhBxa77MgspzOEkuOdlzRn/jHdjb+kuQ==
X-Received: by 2002:a17:902:cd0e:b0:193:37a7:cc1c with SMTP id g14-20020a170902cd0e00b0019337a7cc1cmr12189330ply.56.1673491162975;
        Wed, 11 Jan 2023 18:39:22 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:a840:1e00:d54:e521:8bac:7bed])
        by smtp.gmail.com with ESMTPSA id w7-20020a1709027b8700b001944b1285easm2310331pll.198.2023.01.11.18.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 18:39:22 -0800 (PST)
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
Subject: [PATCH v7 4/7] arm64/cache: Move CLIDR macro definitions
Date: Thu, 12 Jan 2023 11:38:49 +0900
Message-Id: <20230112023852.42012-5-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112023852.42012-1-akihiko.odaki@daynix.com>
References: <20230112023852.42012-1-akihiko.odaki@daynix.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
2.39.0

