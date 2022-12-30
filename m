Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84262C4167B
	for <kvmarm@archiver.kernel.org>; Fri, 30 Dec 2022 09:55:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C5FA4B491;
	Fri, 30 Dec 2022 04:55:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@daynix-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SqNp5Kbo7cBS; Fri, 30 Dec 2022 04:55:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D693C4B5E6;
	Fri, 30 Dec 2022 04:55:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 019464B4D7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Dec 2022 04:55:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jB-9znPddXro for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Dec 2022 04:55:05 -0500 (EST)
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com
 [209.85.216.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D640C4B492
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Dec 2022 04:55:04 -0500 (EST)
Received: by mail-pj1-f50.google.com with SMTP id v23so21788953pju.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Dec 2022 01:55:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=nQ3SWUnwOxxOnluQcCUMkWWYY8S0x44bkExbOVLaC48=;
 b=PIewojQzM9gdaK16yPowjVkvS9gJxGqd0smybnMugXbwyRtcY9H2OninVnk985ilXH
 TMWVfHPA6BRCAnxu5fpX77ZfejmB4fbFbMB4bZCf4KFAroubnEKJHZk11sW0q7kA5nIs
 4AiXg5tEX7bf5/QTRMAMlAsnF/sR5DdLlV11Hz22LrvJp6XBYdpK0ojD6wIdst2/HdoE
 h5k+/ypI8nAiyoWOTPOamgGfAJG+2fJQjM6Y3EmvQOda/slt8HZszf64VtPkmYWabqpz
 QvMutBmXygyO0yarbfhdi5U9YqE/M2I+OzeWzKt1l/uzbgi6eArPebW5MjKoXgrdrxha
 Vtxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=nQ3SWUnwOxxOnluQcCUMkWWYY8S0x44bkExbOVLaC48=;
 b=rmRM1Y0JaUgsv1LwDl6n6f+uxklUaaT00I/7JDaHkOfVdtkaG/xvD+qCleWawFjsFX
 nK/rsVElUVXu763maTiWajfMTepVkq36ZMqdzd3XrapYlbj9resBQO8qTdfqIqMqXVFs
 HWIM7avHnEr9bIqBR2lg8hUYX8IIaHZNmpicgkwdTVr7XTD9CoeccreI/AZNIfs1CcHo
 wVTOthqL5TJhV9M2WBzRamdLoP54WFcVb046CHCXe+HSbyq7zmBcJFifhqzJ+zCvSQCl
 wS4zMIlK+l0+ZmKWw+WX1nStcuD3elw7bRIs+DSN/tTMzCBF6Jv/IRmiE4SjJapeRHI6
 9VLg==
X-Gm-Message-State: AFqh2kpo6FWBMNV0eWjK1UiQ9XNtzgpKvl+Sr591I6BpeNQjYRW+TwD4
 G/TbxDomfCeHCD2asT6Z6LCQsQ==
X-Google-Smtp-Source: AMrXdXuxZ5ubvMzAbz1wWO3szh7+ngbcZbwRzttK2BodjwDPRZsxol/hmIC/5rFy4F52A/m9VNKV9A==
X-Received: by 2002:a17:902:f38c:b0:189:5f5c:da1f with SMTP id
 f12-20020a170902f38c00b001895f5cda1fmr25292169ple.5.1672394104051; 
 Fri, 30 Dec 2022 01:55:04 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
 by smtp.gmail.com with ESMTPSA id
 b7-20020a170902650700b00189c536c72asm14487719plk.148.2022.12.30.01.55.00
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 30 Dec 2022 01:55:03 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: 
Subject: [PATCH v5 1/7] arm64: Allow the definition of UNKNOWN system register
 fields
Date: Fri, 30 Dec 2022 18:54:46 +0900
Message-Id: <20221230095452.181764-2-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221230095452.181764-1-akihiko.odaki@daynix.com>
References: <20221230095452.181764-1-akihiko.odaki@daynix.com>
MIME-Version: 1.0
Cc: Alyssa Rosenzweig <alyssa@rosenzweig.io>, Hector Martin <marcan@marcan.st>,
 Mathieu Poirier <mathieu.poirier@linaro.org>, Marc Zyngier <maz@kernel.org>,
 Sven Peter <sven@svenpeter.dev>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
 asahi@lists.linux.dev, Akihiko Odaki <akihiko.odaki@gmail.com>,
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

From: Marc Zyngier <maz@kernel.org>

The CCSIDR_EL1 register contains an UNKNOWN field (which replaces
fields that were actually defined in previous revisions of the
architecture).

Define an 'Unkn' field type modeled after the Res0/Res1 types
to allow such description. This allows the generation of

  #define CCSIDR_EL1_UNKN     (UL(0) | GENMASK_ULL(31, 28))

which may have its use one day. Hopefully the architecture doesn't
add too many of those in the future.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Akihiko Odaki <akihiko.odaki@gmail.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/tools/gen-sysreg.awk | 20 +++++++++++++++++++-
 arch/arm64/tools/sysreg         |  2 ++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/tools/gen-sysreg.awk b/arch/arm64/tools/gen-sysreg.awk
index db461921d256..f6909a6b8380 100755
--- a/arch/arm64/tools/gen-sysreg.awk
+++ b/arch/arm64/tools/gen-sysreg.awk
@@ -98,6 +98,7 @@ END {
 
 	res0 = "UL(0)"
 	res1 = "UL(0)"
+	unkn = "UL(0)"
 
 	next_bit = 63
 
@@ -112,11 +113,13 @@ END {
 
 	define(reg "_RES0", "(" res0 ")")
 	define(reg "_RES1", "(" res1 ")")
+	define(reg "_UNKN", "(" unkn ")")
 	print ""
 
 	reg = null
 	res0 = null
 	res1 = null
+	unkn = null
 
 	next
 }
@@ -134,6 +137,7 @@ END {
 
 	res0 = "UL(0)"
 	res1 = "UL(0)"
+	unkn = "UL(0)"
 
 	define("REG_" reg, "S" op0 "_" op1 "_C" crn "_C" crm "_" op2)
 	define("SYS_" reg, "sys_reg(" op0 ", " op1 ", " crn ", " crm ", " op2 ")")
@@ -161,7 +165,9 @@ END {
 		define(reg "_RES0", "(" res0 ")")
 	if (res1 != null)
 		define(reg "_RES1", "(" res1 ")")
-	if (res0 != null || res1 != null)
+	if (unkn != null)
+		define(reg "_UNKN", "(" unkn ")")
+	if (res0 != null || res1 != null || unkn != null)
 		print ""
 
 	reg = null
@@ -172,6 +178,7 @@ END {
 	op2 = null
 	res0 = null
 	res1 = null
+	unkn = null
 
 	next
 }
@@ -190,6 +197,7 @@ END {
         next_bit = 0
 	res0 = null
 	res1 = null
+	unkn = null
 
 	next
 }
@@ -215,6 +223,16 @@ END {
 	next
 }
 
+/^Unkn/ && (block == "Sysreg" || block == "SysregFields") {
+	expect_fields(2)
+	parse_bitdef(reg, "UNKN", $2)
+	field = "UNKN_" msb "_" lsb
+
+	unkn = unkn " | GENMASK_ULL(" msb ", " lsb ")"
+
+	next
+}
+
 /^Field/ && (block == "Sysreg" || block == "SysregFields") {
 	expect_fields(3)
 	field = $3
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 384757a7eda9..8f26fe1bedc6 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -15,6 +15,8 @@
 
 # Res1	<msb>[:<lsb>]
 
+# Unkn	<msb>[:<lsb>]
+
 # Field	<msb>[:<lsb>]	<name>
 
 # Enum	<msb>[:<lsb>]	<name>
-- 
2.38.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
