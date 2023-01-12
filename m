Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B012386
	for <kvmarm@lists.linux.dev>; Thu, 12 Jan 2023 02:39:15 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso22160729pjt.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Jan 2023 18:39:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SWGlTS8+yHcgXZKRtAzBrKdh4sbwRwlmgz2Vd7srghs=;
        b=6gAjtKNnIaTPJBhOC31QUnQAENMLhTTnXyG9U4wR7LqVdyWYCj5FwgBR0YBYk+Uwn5
         9VZpwi0U3dL4puxYQi98k7+YqN+T6IgAZqXUfkvolQ3gC9/nrn5bFy8FuIh0je95Vpp1
         askvGKIJskp3GkF67XlpSZteo/0E/gKLusdq08nvHqZsrKC5/xnvqs5u5x4Uklx9OshT
         jD/16aMbK2ZhOHiVPX7KNU5HJ4Y6unXTDUQgXO14lgMXvvvpfg5ZnkCoLQNt+aqof/Du
         6ru9i5khQ8xAEPn9Ked57yZ9J75lQD+hFhMoO2Mh0MYxkZYHQ6EvBQWjY6McT1wt7qFV
         FT0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SWGlTS8+yHcgXZKRtAzBrKdh4sbwRwlmgz2Vd7srghs=;
        b=xKT5rPlzZbElFlRkAIGHZEV8MgMMdxZkFxBsYB4ARQhuHsjVBBh/Igg/vU2OBcEvsQ
         QEsqCZatWq+1B/yD/x6XxQi8SETJjwJTfU6AuLMUVbwEVZ04i3lQJ5IvqdztqYPDSY+u
         d1OPfz/P7yaDoS7GhBS6D3O18yBNv3JaqrxwWR6YUsZDncxuD8gOHWFPPfL06cq+pBT8
         EBRyuurVj9iQRf047NaMse0QOAsHmWoJ+FURSjZHomB7fnUAR3R6V0N/9iVEimlFT4sX
         pULcseXIANs15Xlt3AbvoVTjYQ9v8IsUjbOVrq9kEuYyT9GYsI8kv/fF1K70luS4Qr2a
         gJzg==
X-Gm-Message-State: AFqh2krqDAlEN50tABuDfL9g1QeS50O1vftlJLw0MXvfztMGJDoWfGAe
	VlRovEVc2T6B8rBhZvDoCoz/Kw==
X-Google-Smtp-Source: AMrXdXtWWWycGnURjan6UARSOEmwP/lbYNDRVbY4DK7ruYKAglN8VqBmCIRpKg4ZdfTsSwzHDZJIjQ==
X-Received: by 2002:a17:902:d5c8:b0:193:38b4:b9a7 with SMTP id g8-20020a170902d5c800b0019338b4b9a7mr12733028plh.31.1673491154915;
        Wed, 11 Jan 2023 18:39:14 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:a840:1e00:d54:e521:8bac:7bed])
        by smtp.gmail.com with ESMTPSA id w7-20020a1709027b8700b001944b1285easm2310331pll.198.2023.01.11.18.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 18:39:14 -0800 (PST)
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
Subject: [PATCH v7 2/7] arm64/sysreg: Convert CCSIDR_EL1 to automatic generation
Date: Thu, 12 Jan 2023 11:38:47 +0900
Message-Id: <20230112023852.42012-3-akihiko.odaki@daynix.com>
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

Convert CCSIDR_EL1 to automatic generation as per DDI0487I.a.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/sysreg.h |  1 -
 arch/arm64/tools/sysreg         | 10 ++++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 1312fb48f18b..a2a93b3fc557 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -404,7 +404,6 @@
 
 #define SYS_CNTKCTL_EL1			sys_reg(3, 0, 14, 1, 0)
 
-#define SYS_CCSIDR_EL1			sys_reg(3, 1, 0, 0, 0)
 #define SYS_AIDR_EL1			sys_reg(3, 1, 0, 0, 7)
 
 #define SYS_RNDR_EL0			sys_reg(3, 3, 2, 4, 0)
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index f754265aec5f..45648fa89be8 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1637,6 +1637,16 @@ Sysreg	SCXTNUM_EL1	3	0	13	0	7
 Field	63:0	SoftwareContextNumber
 EndSysreg
 
+# The bit layout for CCSIDR_EL1 depends on whether FEAT_CCIDX is implemented.
+# The following is for case when FEAT_CCIDX is not implemented.
+Sysreg	CCSIDR_EL1	3	1	0	0	0
+Res0	63:32
+Unkn	31:28
+Field	27:13	NumSets
+Field	12:3	Associativity
+Field	2:0	LineSize
+EndSysreg
+
 Sysreg	CLIDR_EL1	3	1	0	0	1
 Res0	63:47
 Field	46:33	Ttypen
-- 
2.39.0

