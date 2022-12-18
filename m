Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC544806
	for <kvmarm@lists.linux.dev>; Sun, 18 Dec 2022 05:15:32 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id 3-20020a17090a098300b00219041dcbe9so6066554pjo.3
        for <kvmarm@lists.linux.dev>; Sat, 17 Dec 2022 21:15:32 -0800 (PST)
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
        b=pyw/T53+Sb00QDf5E3iWWQ4lJnPNsoqcPpKyrCgHYk0G4cUbDwyopjZarCuOuHRLmB
         7xyTMow3xvRlTKGQvIUoDlNUJdcHC+ok7qcOAc7wHJYGD00WAKShExUBOFyv0eLrEKX9
         bXmBR7vJDaPvseG1+LlgV5z3jgCI+KHiguLbIOpKxuJcYyXhXJMFvuEME6pByfcxPMch
         Lxeodytl06Iwx9tlcWAP/DErnLz0NPGUBeDIvkWNtA+XiDRDIquDQyx3Zy2oR8SlXnKA
         EkLLJX04dk5WdpxZORyDvQU5muDl2Oko1PiOIJGw9+3cR3BA7FHJFxbRP4OC62xDvC4H
         tbrg==
X-Gm-Message-State: ANoB5pksT2S6zKQwplJWoA9f3ico2ldde+7gP5eQbWwCAzojxtcixe0C
	1NdiBCeaEWPxc6OU8PA22T1Eqw==
X-Google-Smtp-Source: AA0mqf40ve5metyNeR9pqP85whi8pYrughaxn166zWUj52zuKSORgShjFuv3JDhVbBqfLRVYmrDThQ==
X-Received: by 2002:a17:90a:f681:b0:219:6bf0:9861 with SMTP id cl1-20020a17090af68100b002196bf09861mr39034573pjb.10.1671340532431;
        Sat, 17 Dec 2022 21:15:32 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id b1-20020a17090a6ac100b002139459e121sm7002417pjm.27.2022.12.17.21.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 21:15:32 -0800 (PST)
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
Subject: [PATCH v3 2/7] arm64/sysreg: Add CCSIDR2_EL1
Date: Sun, 18 Dec 2022 14:14:07 +0900
Message-ID: <20221218051412.384657-3-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221218051412.384657-1-akihiko.odaki@daynix.com>
References: <20221218051412.384657-1-akihiko.odaki@daynix.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20221218051407.GU32p0s4C6RVQFWcKz8t5F9p1xr9LqJ47gsH-CEW97s@z>

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

