Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21492184C
	for <kvmarm@lists.linux.dev>; Sat,  7 Jan 2023 09:46:44 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso7769904pjt.0
        for <kvmarm@lists.linux.dev>; Sat, 07 Jan 2023 01:46:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kb7WlyMl1q/VPJpFF+X4TfNx6Lfb11fY4VoBIq7ymlo=;
        b=AqPORj3k62mpcxB7NdBDjopWyyNb5AJfYksrKqYZ8SduFvlN6kk1lK58RTrTPHP73D
         eJf6pkgUiDlGkzbU81ofZ3d2XGwosFeIafV+SYjltN9RsdgD4nxNFJ1NdzVCbYFd49fK
         8dop9omAdGIGlSmtluLbQcU6Z9DJKnRnnRvIhCQ8L2U6m7hoNew+YRm7OVd0L7lb/F2/
         53a/NxL7tlX/8IF4gVOONrKr6AXFIZPFnHBKCAk1OV9ua2nIMwK2oSwvzAaBG+Xl1Rsy
         PKoZvBnDKubcHrcALi1OVoFhST+8207mOGcvae3z3NXKVt9BQSqP5gqT8d19m3pV3giw
         GaqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kb7WlyMl1q/VPJpFF+X4TfNx6Lfb11fY4VoBIq7ymlo=;
        b=o98fWQhBmB5KSNy3zKct9LFjO7Bh0g+qHyywXUMeLITytlAnN5uOntWvl5Zrn2IR7f
         m2I+ATktwA15AwOLHcOGi3SHodUuYIi7zDjRbHJSc8EvVXCth0peu0k+qBk++QVcmy82
         Lqc/bMdL7Tluppf3bl0ybZAaKW5K49wYLorBq6ATfnXkJMyJnLqJt+7WxD3NweJuVPYD
         KMwUNf1J+WpFgIIf7pnC3fqtXKRlJrUDYOUavAWAiBuU6ODJUumBqNBZG2A0F/V0Y362
         Iqby/QgoDPgrabxINIBdRCDi1FpNSTDQWPWGdKBp6xj2p6iZIA81sC8fhtV3uBw1BXTB
         eTJQ==
X-Gm-Message-State: AFqh2koCPCMj+SzrdPgEAxdwkfyZ39d8TspW3FWCCEoMLlwBd+B1d7bx
	CffcSzxYYkx3VojaYcsLxVM39A7BHtzpfN40
X-Google-Smtp-Source: AMrXdXv2MV05CqQ25JMP8AE4lcoTf8VGAHYFqdK+gs3TuWYKAJT4CkVIYnxDYPsdwXkraKiJk5c9bA==
X-Received: by 2002:a17:902:a601:b0:192:910e:6083 with SMTP id u1-20020a170902a60100b00192910e6083mr41156529plq.15.1673084803547;
        Sat, 07 Jan 2023 01:46:43 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:a840:1e00:d54:e521:8bac:7bed])
        by smtp.gmail.com with ESMTPSA id n9-20020a170902d2c900b00183c6784704sm2263449plc.291.2023.01.07.01.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 01:46:43 -0800 (PST)
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
Subject: [PATCH v6 1/7] arm64: Allow the definition of UNKNOWN system register fields
Date: Sat,  7 Jan 2023 18:46:23 +0900
Message-Id: <20230107094629.181236-2-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230107094629.181236-1-akihiko.odaki@daynix.com>
References: <20230107094629.181236-1-akihiko.odaki@daynix.com>
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
2.38.1

