Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A272533CF
	for <kvmarm@lists.linux.dev>; Wed, 21 Dec 2022 20:40:33 +0000 (UTC)
Received: by mail-pg1-f170.google.com with SMTP id 79so11133858pgf.11
        for <kvmarm@lists.linux.dev>; Wed, 21 Dec 2022 12:40:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cbFQ+J5fs5BdCa+m7U3HiXNal18DTSvVi/iSf3zznx4=;
        b=18h10GUg0vVIZjuVhPGsjv6haTyX1xXm0fs1oK6cXpMzO9Q+tV38Yokj9e74NrYojp
         FeNHxIzWBf2ySgHYIzgLjcGesUuvFH6a+Srq4hqQsWy/p97WPv3c0gdTH2FOIwmniMkW
         zv6O5Skz7TQf3tDU07Vh8+ZcGaFBCwx7+ORX3ryJurzUZALXh29abwAuL/ZuNcxeD+U/
         HVOlKOv3qgi2G+b14vQqmHWCfjxGnohvzeC4FJ2DiYjDFjMv3NLr1MYlyP6M/s1/MD7C
         hOwrViSfyFkVVjfiCbn4+COqzMKTLuMnlpTg4C6KlTqKKSKr8v/hd1Z+0ijSgB39FxNe
         JI3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cbFQ+J5fs5BdCa+m7U3HiXNal18DTSvVi/iSf3zznx4=;
        b=qe8L//8CIg4vVf3XtCV/p4dzkIbtBT05aIQVBGrra3BIFu4pcCV6b0Dc1xv3UFd0t0
         a2n+hpuWFIf9RV51jWPWB5lke3UXdqBuPWi/owBdu7euN9A6VGVYiOVQ1cSeK+44gtBC
         rUDF7ALxknKpP5VV/N4VRZOBiGhi0a+1CCFLrwib9VgFFsVPshRpjnDzC+vb8cQiEH4A
         MlSN2Xss4kNPP8nrMVeqlCsuvFzohmRCSlnvmVdKtgt8EYwA8jldHX9xcHWotyWVYdCw
         t3hVXB97OdxIz6LBwIxN7Oab4XD5xzDwtVq3k77sSA6HVzMpzfD/gSbi1eZrphA4+Zeb
         hbWg==
X-Gm-Message-State: AFqh2krK9I+MmQNFbGeREzJNq7SOTckYgQs0bgsVtwKiXOQoU0yY47iR
	37bQcUQPqfwjpuB18pyhWVI0mg==
X-Google-Smtp-Source: AMrXdXvlAmSAHNGVh71PvP1fhyI+g3oX+xufwQp6Y95KtVUC/TBW27Yvk+rzxZQ57dE++5uVHJO1jA==
X-Received: by 2002:a05:6a00:26ee:b0:578:777e:7f18 with SMTP id p46-20020a056a0026ee00b00578777e7f18mr3088234pfw.3.1671655233393;
        Wed, 21 Dec 2022 12:40:33 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id r4-20020aa79884000000b005763c22ea07sm11017784pfl.74.2022.12.21.12.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 12:40:33 -0800 (PST)
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
Subject: [PATCH v4 2/7] arm64/sysreg: Convert CCSIDR_EL1 to automatic generation
Date: Thu, 22 Dec 2022 05:40:11 +0900
Message-ID: <20221221204016.658874-3-akihiko.odaki@daynix.com>
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
Message-ID: <20221221204011.pOsBhi72Ln7NaiNBJcwscsN7xnatFZmMXbRoKNiaiFs@z>

Convert CCSIDR_EL1 to automatic generation as per DDI0487I.a.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 arch/arm64/include/asm/sysreg.h |  1 -
 arch/arm64/tools/sysreg         | 10 ++++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 7d301700d1a9..910e960661d3 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -425,7 +425,6 @@
 
 #define SYS_CNTKCTL_EL1			sys_reg(3, 0, 14, 1, 0)
 
-#define SYS_CCSIDR_EL1			sys_reg(3, 1, 0, 0, 0)
 #define SYS_AIDR_EL1			sys_reg(3, 1, 0, 0, 7)
 
 #define SYS_RNDR_EL0			sys_reg(3, 3, 2, 4, 0)
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 8f26fe1bedc6..097d6faafc87 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -873,6 +873,16 @@ Sysreg	SCXTNUM_EL1	3	0	13	0	7
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
2.38.1

