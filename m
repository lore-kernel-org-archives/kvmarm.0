Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77637C10F1B
	for <kvmarm@archiver.kernel.org>; Wed, 21 Dec 2022 20:40:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1371C4B8F4;
	Wed, 21 Dec 2022 15:40:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@daynix-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0+Q6eaygEW4E; Wed, 21 Dec 2022 15:40:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFD4A4B91E;
	Wed, 21 Dec 2022 15:40:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35E034B8DD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Dec 2022 15:40:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RxbI4Qw0HBOV for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Dec 2022 15:40:34 -0500 (EST)
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com
 [209.85.215.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 22E134B937
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Dec 2022 15:40:34 -0500 (EST)
Received: by mail-pg1-f175.google.com with SMTP id e190so6707138pgc.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Dec 2022 12:40:34 -0800 (PST)
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
 b=gszOjm1GC2d0hMnnc8iRYFqprcWgClVGmhMoaR2OJG7FoasEa5hS2i63gI1hEc0Wz6
 plXBGtOAz68laHnTQctv2WENfIltDCEjB4rADx2XwJrACy07VKlBb7lLg8byAlPUSxQb
 Ji0HethiwtyVLjhNJz6GjPtDZZZU61Gwfe83tq5uvmQqdCdTYun7VW9EQHng2V8TZjEG
 +jTp41yMev3jnU43tEzYLpV0v8BMSSD2DTz8hM7eqxXK9/lDu6mxLTDXAA2oBa1F/rzn
 vNqqJEfgdy4KSFiNqed3sVKB8USD1DiJWXAXHCYt+uF8oV5qJoWeWJfebSpPkn4uBoCz
 yreA==
X-Gm-Message-State: AFqh2krS0dkL65lSgdoHxa17D95zu9PA7Ms18nbshlGKiPKIjMh1yIVL
 fdtprjuiS3+foNLUXoNHzra8Og==
X-Google-Smtp-Source: AMrXdXvlAmSAHNGVh71PvP1fhyI+g3oX+xufwQp6Y95KtVUC/TBW27Yvk+rzxZQ57dE++5uVHJO1jA==
X-Received: by 2002:a05:6a00:26ee:b0:578:777e:7f18 with SMTP id
 p46-20020a056a0026ee00b00578777e7f18mr3088234pfw.3.1671655233393; 
 Wed, 21 Dec 2022 12:40:33 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
 by smtp.gmail.com with ESMTPSA id
 r4-20020aa79884000000b005763c22ea07sm11017784pfl.74.2022.12.21.12.40.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 21 Dec 2022 12:40:33 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: 
Subject: [PATCH v4 2/7] arm64/sysreg: Convert CCSIDR_EL1 to automatic
 generation
Date: Thu, 22 Dec 2022 05:40:11 +0900
Message-Id: <20221221204016.658874-3-akihiko.odaki@daynix.com>
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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
