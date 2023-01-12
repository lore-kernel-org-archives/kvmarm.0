Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02721388
	for <kvmarm@lists.linux.dev>; Thu, 12 Jan 2023 02:39:10 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id d3so18787466plr.10
        for <kvmarm@lists.linux.dev>; Wed, 11 Jan 2023 18:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IxO3NMAhDGwGa5X2zGDE0i6ZC8nh/RTmvR+znDzc56E=;
        b=L7ms7+u8QSHi8Z/8RNakK19C6sRx4knfDzbqVR612CqX3qI3FV3zprkks2hu4DcC4y
         +VuUesvSeA8nJvx7n4xo8NWR6CISadidiIPsrjj2Q0RS5+V7R5XLUnj2A52mgtUgOhW9
         k9cPBwB185hjda01AqtyxF0O5a4XDEQbLCTQziL0QHZHRSLeniY87ebe7A5seFeH4J7A
         HNni9V9fB7/L3Iq02HIkKvQtts1SA0GEki9PS5yTq0b65rIJrXGvaMLs6+zZlrSwNZpm
         GpuQiC48DOGNeJWwDV91vSgm7qYlyEkdcrn9bOa4GI5TDwNwmZd6EZg6Tbbtjp2blh6R
         H7pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IxO3NMAhDGwGa5X2zGDE0i6ZC8nh/RTmvR+znDzc56E=;
        b=Iy4tsENSMg+XgKv9VFyaBuBcUqSPv2yk1LdeBDzlWZo1qA2FaFwcnsI7l6ZHhPyYZY
         t7OtTdWbUcSBUzeua3wZ3T7ztTph4ervBUXVoIJ4z1G0tMCOtPGLeNX2z/ngTHJ79RpA
         PpZWwa2jddgEDjWF2oJpP/mhQLMWdS6xR5/CbgyTEh1tf5b3M2VfpoW3HZYQHsu+f4aC
         YLH5iElkCx87b0/sUEJSEhJ0BUSk6Y5dxFCaioQRXT1pqHgiZ6vvbqNSB73oppLxOoIU
         0eTbE/1umFBkVO3oD7LLlWGUudIRkqsZKKqLcvqSyG9H3cQxK7VInsFuV9f9LRqG4rjV
         mgWQ==
X-Gm-Message-State: AFqh2koDmOJ/JBpqnsaNvLHvgajKJeEuNrml2ADdBfBAG+JiMTQYjM3d
	jnYeUnElB7vm1SA9RHNKMSB0BA==
X-Google-Smtp-Source: AMrXdXuMfcnqymlqo5XUQfsnd/LLwhCwzAct3TWdVlWRd6At3sguvNRBgM25P7G1BSV9vvnS5bzO3A==
X-Received: by 2002:a17:902:bf45:b0:189:fa12:c98a with SMTP id u5-20020a170902bf4500b00189fa12c98amr65213379pls.66.1673491150506;
        Wed, 11 Jan 2023 18:39:10 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:a840:1e00:d54:e521:8bac:7bed])
        by smtp.gmail.com with ESMTPSA id w7-20020a1709027b8700b001944b1285easm2310331pll.198.2023.01.11.18.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 18:39:10 -0800 (PST)
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
	Akihiko Odaki <akihiko.odaki@gmail.com>
Subject: [PATCH v7 1/7] arm64: Allow the definition of UNKNOWN system register fields
Date: Thu, 12 Jan 2023 11:38:46 +0900
Message-Id: <20230112023852.42012-2-akihiko.odaki@daynix.com>
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
index c350164a3955..e1df4b956596 100755
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
index 184e58fd5631..f754265aec5f 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -15,6 +15,8 @@
 
 # Res1	<msb>[:<lsb>]
 
+# Unkn	<msb>[:<lsb>]
+
 # Field	<msb>[:<lsb>]	<name>
 
 # Enum	<msb>[:<lsb>]	<name>
-- 
2.39.0

