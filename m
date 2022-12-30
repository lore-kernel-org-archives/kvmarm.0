Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78DAB7E
	for <kvmarm@lists.linux.dev>; Fri, 30 Dec 2022 09:55:24 +0000 (UTC)
Received: by mail-pl1-f173.google.com with SMTP id d15so21373775pls.6
        for <kvmarm@lists.linux.dev>; Fri, 30 Dec 2022 01:55:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DlWUJTvQq+dZLt1EiuVf3fldzhye5smOXD/qjtYfqYw=;
        b=q8gfFC2rx20mZ8f21CGm8m6P3RgItI4xjQEcG4ZFyFoA1/rqgjhzRZGPTQQOsGaq0w
         JLVSBYqLkrlkfVmySikCPck0cjomgaAd+gpSF3PXEP5Uyin0foTd7CIyHB5EBCIJ+9d5
         rZZkzquT1bvA7a7iomZBitMmehYHU62TgrFJ3Qrb5WN2tHd4195cyEt76t/WkKdvy9t0
         bvZ43yf7TcFmdi6Uc5jbVuZHjp4JSNcM7Z/SdUNg19uu/PfKC0EIxdqL3QFS4fZA/HSY
         DZ/q0pnYUJaHcQ6tqhxxwbs6bSdWWasEQ6DF74zPw8uM/Ai1/lew+a/Wv8mRoVQ5rR/K
         vS7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DlWUJTvQq+dZLt1EiuVf3fldzhye5smOXD/qjtYfqYw=;
        b=siBDQKC9QWJ7A4SHggBO4NktlX+8+FvkSTHbcnXUxG6ABDs/fniSdFhwvJYlWGdjEb
         FCkrqYqoUpWL3VLwUZm+RYoDIXO8mqRQcN2PetWbOderd8zvGrgCulh16Hvr9UtTxeKz
         5o2AkYsHroMNMbouO9YnDqqgoagXo2Gf2tp0gmhiJ3P+TuwqAcMjTrXLOuHZo5E/uYIr
         aBHsxAglNYOx39UQ/P5EoMZKTVGeomGtOBkOFIVVxeadJSD8OjzOJCnlKB3SmiBe3SZP
         1Fn+JLBleud93prCsycInzwG+aa1o8oZCeGaioCOUpEcyEjR5+DFhBTJJamJPRmtq1Ap
         Zb4g==
X-Gm-Message-State: AFqh2krzA1BSmVni9N8SBZ5aXUAEjJkq6eydjjyMzChU6Ffo6IF+MCy8
	qJPZCOiXBMJ7WBjoF5yPZP1qHA==
X-Google-Smtp-Source: AMrXdXt2wFAYM+BYT46pbundxQWM4pSsWH6zvrxdrN1FlBVVyA/LCeYCxWgdfk9ZZzLdSfoQsWgauA==
X-Received: by 2002:a17:903:1306:b0:192:5ec4:c439 with SMTP id iy6-20020a170903130600b001925ec4c439mr24986835plb.16.1672394124246;
        Fri, 30 Dec 2022 01:55:24 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id b7-20020a170902650700b00189c536c72asm14487719plk.148.2022.12.30.01.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 01:55:23 -0800 (PST)
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
Subject: [PATCH v5 6/7] KVM: arm64: Mask FEAT_CCIDX
Date: Fri, 30 Dec 2022 18:54:51 +0900
Message-ID: <20221230095452.181764-7-akihiko.odaki@daynix.com>
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
Message-ID: <20221230095451.JiIUmEBAQnAKnVh5V5TXJB6GwdNa6-QdUiio_L5StJA@z>

The CCSIDR access handler masks the associativity bits according to the
bit layout for processors without FEAT_CCIDX. KVM also assumes CCSIDR is
32-bit where it will be 64-bit if FEAT_CCIDX is enabled. Mask FEAT_CCIDX
so that these assumptions hold.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 arch/arm64/kvm/sys_regs.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f4a7c5abcbca..aeabf1f3370b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1124,6 +1124,12 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r
 						      ID_DFR0_PERFMON_SHIFT,
 						      kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_4 : 0);
 		break;
+	case SYS_ID_AA64MMFR2_EL1:
+		val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
+		break;
+	case SYS_ID_MMFR4_EL1:
+		val &= ~ARM64_FEATURE_MASK(ID_MMFR4_CCIDX);
+		break;
 	}
 
 	return val;
@@ -1605,6 +1611,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_CCSIDR_EL1), access_ccsidr },
 	{ SYS_DESC(SYS_CLIDR_EL1), access_clidr },
+	{ SYS_DESC(SYS_CCSIDR2_EL1), undef_access },
 	{ SYS_DESC(SYS_SMIDR_EL1), undef_access },
 	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
 	{ SYS_DESC(SYS_CTR_EL0), access_ctr },
@@ -2106,6 +2113,10 @@ static const struct sys_reg_desc cp15_regs[] = {
 
 	{ Op1(1), CRn( 0), CRm( 0), Op2(0), access_ccsidr },
 	{ Op1(1), CRn( 0), CRm( 0), Op2(1), access_clidr },
+
+	/* CCSIDR2 */
+	{ Op1(1), CRn( 0), CRm( 0),  Op2(2), undef_access },
+
 	{ Op1(2), CRn( 0), CRm( 0), Op2(0), access_csselr, NULL, CSSELR_EL1 },
 };
 
-- 
2.38.1

