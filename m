Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B39806
	for <kvmarm@lists.linux.dev>; Sun, 18 Dec 2022 05:15:48 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id l10so6074153plb.8
        for <kvmarm@lists.linux.dev>; Sat, 17 Dec 2022 21:15:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QbwMfys3+9WZoYtA5YRufReD7fZRc1BEVtWsfBO6EFw=;
        b=o5urDT3PQQZ9b78JxurBz0P876mpfVVMU9PTg5Iv9tcINeCNgkvc+u33ksU8NQLWG3
         hXcDR+BX3XsEf5TRJmVO/Ks+pZZ2QtcUo1RKxEcafRKktF5onby8aDQZeYDB4R/XWzWC
         mIn8LBypGMXEaO/FrSu3AVnyBBfyhzeBfx2IRKTG6InEMIL1QMqbI5NMy2JnY1Wn8imv
         9gmVkG+BM25iUzCCwyGClYiUpo9zHzIv2q1+qadhjzgYJkd0F45/w/Qx/xud54MqKX8a
         DA4I6x//NnfDgXDGBZOzypKIRiaaW7hPRB6p8K8ssDpIRV6e2gLNpUe2e02dh1KnQa+U
         5ARg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QbwMfys3+9WZoYtA5YRufReD7fZRc1BEVtWsfBO6EFw=;
        b=j1wAxifKheFFDLvBd9IBjIg3rWvyBCBTK0VDvjBKnHn8CYYj0SZ7clQVa+7PAmphvz
         u5nP74URTEa+Is/igF6JaSlgFKi5IfB5uxytZf7XktH2na06Dx85BVRLZ+OFqKaL1zFy
         Bs9D/8V/v0IZGwTIcaHAX1b8gDd8lGsZqgFoQdEOWndWkiI2EocZhZOv8LTD3nA99xZh
         6xV/jkU7iLHi6aHLUlaM3eOyrIiOx4ce95+f+ljaPgDUJ2SIAEOXDzyJD/a4niLyTFN5
         /wrOsw8jvCtAA4vMpY9jYgS3ny4MQVntja3rIcJRZfZgfi/nFlGKLr7H+MauL1Z/QP0u
         HPgg==
X-Gm-Message-State: ANoB5pmFJx95HGKZllXeP3BN73G0IsPpApV2uPhRI5yQhgv9M+Y+dXDX
	Kx0XzqD9csyXrj4EmEkqIhqm9Q==
X-Google-Smtp-Source: AA0mqf7QCiGl5d9+spTzOyPlO6TcWemQOa/HV6d8IE9CviRM8bqJlTDV9iNJCKFfiTU6HuKnpIEFLA==
X-Received: by 2002:a17:90b:253:b0:223:1e7d:67e7 with SMTP id fz19-20020a17090b025300b002231e7d67e7mr20682580pjb.21.1671340548041;
        Sat, 17 Dec 2022 21:15:48 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id b1-20020a17090a6ac100b002139459e121sm7002417pjm.27.2022.12.17.21.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 21:15:47 -0800 (PST)
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
Subject: [PATCH v3 6/7] KVM: arm64: Mask FEAT_CCIDX
Date: Sun, 18 Dec 2022 14:14:11 +0900
Message-ID: <20221218051412.384657-7-akihiko.odaki@daynix.com>
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
Message-ID: <20221218051411.kiDnTxX42ltN5oJn6sgM96YYIzciZHtpXr5Vfb3_5Uo@z>

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
index f48a3cc38d24..a7199f34e321 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1195,6 +1195,12 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r
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
@@ -1676,6 +1682,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_CCSIDR_EL1), access_ccsidr },
 	{ SYS_DESC(SYS_CLIDR_EL1), access_clidr },
+	{ SYS_DESC(SYS_CCSIDR2_EL1), undef_access },
 	{ SYS_DESC(SYS_SMIDR_EL1), undef_access },
 	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
 	{ SYS_DESC(SYS_CTR_EL0), access_ctr },
@@ -2177,6 +2184,10 @@ static const struct sys_reg_desc cp15_regs[] = {
 
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

