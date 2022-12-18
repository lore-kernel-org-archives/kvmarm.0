Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 238BEC4332F
	for <kvmarm@archiver.kernel.org>; Sun, 18 Dec 2022 05:15:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3DE641021;
	Sun, 18 Dec 2022 00:15:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@daynix-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xyZbzAgoXMgC; Sun, 18 Dec 2022 00:15:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CA144A105;
	Sun, 18 Dec 2022 00:15:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DA9B4B3F5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Dec 2022 00:15:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cMXWtOvwGHQf for <kvmarm@lists.cs.columbia.edu>;
 Sun, 18 Dec 2022 00:15:33 -0500 (EST)
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com
 [209.85.216.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 250854B5ED
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Dec 2022 00:15:33 -0500 (EST)
Received: by mail-pj1-f41.google.com with SMTP id
 e7-20020a17090a77c700b00216928a3917so9946501pjs.4
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Dec 2022 21:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=fOI4ejQZZiODftrBSHrXI1yj065pP5UP36eyaXzR3dw=;
 b=5vOoY2ROQYHTbYM3+RnIE9hlmPwzzQgFUeowIh+C/4V9gTf+l5bnTa2QzkNUnqQwxr
 3GgkF6GUjCXw9MZFqkdBaBeMYIL59Cc0WtqAI9/oj1HmwjGy3flLLlS8WOMO6Pbob/Gx
 jfGlhJe3VFYnBiWMGf8du0YwYHYTQB0gnZUmWqLr2GwB9S6eTRGdZdtbF+a+mxGQ8lVb
 8Mj1VU5avG7zyE24Rk/OHZnHGBhit9avvW+NyeY4DKssVug5N7YvvKNSYQPL3FBzsHI8
 0DgZwsBfWfirRYsZFPZKwCAEOdbAIL0GAH+UYx221RmJDoHsYlz8pxB7RMqDMZ1rho4b
 1x3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=fOI4ejQZZiODftrBSHrXI1yj065pP5UP36eyaXzR3dw=;
 b=cIYyLhlFn8DGuEFRueqcXuGsO7QDK5zVQ6btXvcHY2BsgAbLmKJpcOCnym/bP9wJVG
 wy8Gbzcx0Nb2zWZ9RKVCujINI4tXTX0+W0ppPZx84BtZBz+zWFJcor2Y/OOVyjQScYSz
 Ig9GgkD/WyyQil1vf4rlRPdn6Hq7i5tUnJ1PCkH/cSEH++4qERyT21h3TavOwA2Bz4tV
 DAC0pBedB94WU1N3UtVo3LaJARcWvC99grKf+2rrb8PgWcgE7Vxs9H/CqJ4iSHMXSoyw
 iZDpE0gls+ZJhtIMIOdvQ2VVpMyY9KaHbG2GFkrh8sfwAR2KD54n1LTykoCD8bwSRKDD
 1c9Q==
X-Gm-Message-State: ANoB5plC2tm6ljQGHDzEAhEdmP6VOaDJscVLCXcvN7xL+k2nAlY5ZqPi
 aBt5nXMXZ4Np0o3q3A0ZSa88wA==
X-Google-Smtp-Source: AA0mqf40ve5metyNeR9pqP85whi8pYrughaxn166zWUj52zuKSORgShjFuv3JDhVbBqfLRVYmrDThQ==
X-Received: by 2002:a17:90a:f681:b0:219:6bf0:9861 with SMTP id
 cl1-20020a17090af68100b002196bf09861mr39034573pjb.10.1671340532431; 
 Sat, 17 Dec 2022 21:15:32 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
 by smtp.gmail.com with ESMTPSA id
 b1-20020a17090a6ac100b002139459e121sm7002417pjm.27.2022.12.17.21.15.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 17 Dec 2022 21:15:32 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: 
Subject: [PATCH v3 2/7] arm64/sysreg: Add CCSIDR2_EL1
Date: Sun, 18 Dec 2022 14:14:07 +0900
Message-Id: <20221218051412.384657-3-akihiko.odaki@daynix.com>
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

CCSIDR2_EL1 was added with FEAT_CCIDX.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 arch/arm64/tools/sysreg | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index acc79b5ccf92..0a302b4e6d7a 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -898,6 +898,11 @@ Field	5:3	Ctype2
 Field	2:0	Ctype1
 EndSysreg
 
+Sysreg	CCSIDR2_EL1	3	1	0	0	2
+Res0	63:24
+Field	23:0	NumSets
+EndSysreg
+
 Sysreg	GMID_EL1	3	1	0	0	4
 Res0	63:4
 Field	3:0	BS
-- 
2.38.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
