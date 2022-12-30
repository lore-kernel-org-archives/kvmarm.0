Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD8C1FD4
	for <kvmarm@lists.linux.dev>; Fri, 30 Dec 2022 09:55:16 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id v23so21789359pju.3
        for <kvmarm@lists.linux.dev>; Fri, 30 Dec 2022 01:55:16 -0800 (PST)
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
        b=a9HLPPrsuPN7Ych3GBKWdGCKNaVKy9kLrQNBWARwgUAmKkVdLZTqpDp9RSozBSBSL7
         PEdaU0flV0P5of4EdEpaHL9MIYp/sgU7/nWjeSbfcDkLL1eKQeosAIYDnzjbmJBKRtfw
         QkNmhT1B2Pcr8Rkh99NJkv9Bt6Mmj5QUTAjhgKyfPAeqXi6t1ib+21R4ax9MO5+SRCW4
         1bBEyDDfK5UF7drUgt17d8wMOXEVyPDBFXqoEXT4ogacGJLfyqCkCitDWB1tzox9fXEQ
         LvgtsqI2mi1vi1CyY9OHU3MkHdXRk8pyG5mCpUA7g0r6+H/FlzRTVd+ZaAuYFe7Dbore
         GMqw==
X-Gm-Message-State: AFqh2krwrS6E4U/olm8H2R3qWPcNVO28r/2CsvoKD9b1xL1bY5wKIGOF
	4Dewu97IeCn3UC78dExF2uQB4A==
X-Google-Smtp-Source: AMrXdXss13QkrMhRA6dr0nvpfHQKU4tawzB8AD/+ZDrDtMGJ64TnpAhtOhFlWJsYFDiTDW6CVK9iCg==
X-Received: by 2002:a17:902:d051:b0:192:581b:25d3 with SMTP id l17-20020a170902d05100b00192581b25d3mr26381526pll.17.1672394116193;
        Fri, 30 Dec 2022 01:55:16 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id b7-20020a170902650700b00189c536c72asm14487719plk.148.2022.12.30.01.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 01:55:15 -0800 (PST)
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
Subject: [PATCH v5 4/7] arm64/cache: Move CLIDR macro definitions
Date: Fri, 30 Dec 2022 18:54:49 +0900
Message-ID: <20221230095452.181764-5-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221230095452.181764-1-akihiko.odaki@daynix.com>
References: <20221230095452.181764-1-akihiko.odaki@daynix.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20221230095449.FQGsDjwS-WAjNUJIBbUzx-QtCv6aNtmON7-EodeiPSc@z>

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

