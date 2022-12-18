Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 401C0C4332F
	for <kvmarm@archiver.kernel.org>; Sun, 18 Dec 2022 05:15:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D509E4A105;
	Sun, 18 Dec 2022 00:15:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@daynix-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hYb45LQHg4Gt; Sun, 18 Dec 2022 00:15:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B578843482;
	Sun, 18 Dec 2022 00:15:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 296B143482
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Dec 2022 00:15:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8zMIEbSYx3AO for <kvmarm@lists.cs.columbia.edu>;
 Sun, 18 Dec 2022 00:15:37 -0500 (EST)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
 [209.85.216.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C2B7410FF
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Dec 2022 00:15:37 -0500 (EST)
Received: by mail-pj1-f46.google.com with SMTP id js9so6155381pjb.2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Dec 2022 21:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=4WsGIW0prujF8xnGwWysGoOLhN4qrtpWJqnT9WJSTvs=;
 b=20KqTZ7p9hZYfryC+Vfixvt3usjH4QB21HhVNGKbyBUuo9FRcdt5pDtUHZ0C4OB00k
 Pxkb4TBy4j5Ucx4LvEqYvxz/DBSczM93egGac/fvIai58XcwYxQmzbaOaTH5tfndBTxj
 JRi/iiyrq7N9LEDYbMOd0d/shMofzgLH7ExucYoWaDUQvs4RFnTKTKgOLHcox3BCkcz/
 qlDlCjh4+wKxwbqjTtDSlSaAePBt7ceu4mPvnka+GHbiTPbBdhbiA/SQ5rGpvs+PtiGm
 YBbNd2hkCWttAqwAgUDSjtnqR+YIhmIQXXDUneGSDReHXU81LIFM9OiZ2/6KYcqPMIQp
 yPwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=4WsGIW0prujF8xnGwWysGoOLhN4qrtpWJqnT9WJSTvs=;
 b=j7C/99utLY41QAzyMcDF09vOLynip879Gik3rwM2gRiNOR7LiNDlwtPfdNS2ufNrt1
 R+VvQM9mAPN1uGVCyF89Kjo4/H+Foj04XYXqT9jaVAjJ7XmdUP3XYPo4OimEdRmCSgz5
 2FqN2kHClXwT4kkUHpEULSVka8H6Iy2zq1VC4E/OvsPIo4QaIrXNbngARJI/5PXFpHc/
 EGHr1lwKqt9dQjMp7asStIL60AnRsSp9KJUXtP6/4qtphMPL+WgPs7bOr39LjJ1sQmKX
 rpNhtqZioDxH1DJZZk313EW5UX6Lp/rYFq+4ae4MJ+e6KqOnJPrl7Za20fV8Glbfisa7
 rSOg==
X-Gm-Message-State: AFqh2kqCOsodmMhFCW0TXtBI+t5W5Y+K6lGK9xI5kH7BmwaLsrH2sPUv
 d7S9SafZv3xHD+IboccT8zGLow==
X-Google-Smtp-Source: AMrXdXtRnhfNE+X0n0H526OoGg60rNUh3zsQ7HI3r0L3dVAMmDfmA+k1y46jlVAC89lTx/mkAJPjBw==
X-Received: by 2002:a17:90a:2eca:b0:223:b920:28df with SMTP id
 h10-20020a17090a2eca00b00223b92028dfmr1736781pjs.29.1671340536313; 
 Sat, 17 Dec 2022 21:15:36 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
 by smtp.gmail.com with ESMTPSA id
 b1-20020a17090a6ac100b002139459e121sm7002417pjm.27.2022.12.17.21.15.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 17 Dec 2022 21:15:35 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: 
Subject: [PATCH v3 3/7] arm64/cache: Move CLIDR macro definitions
Date: Sun, 18 Dec 2022 14:14:08 +0900
Message-Id: <20221218051412.384657-4-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221218051412.384657-1-akihiko.odaki@daynix.com>
References: <20221218051412.384657-1-akihiko.odaki@daynix.com>
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
