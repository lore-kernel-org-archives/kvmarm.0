Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8889C4332F
	for <kvmarm@archiver.kernel.org>; Sun, 18 Dec 2022 05:15:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 735304A105;
	Sun, 18 Dec 2022 00:15:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@daynix-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZbjP4pnJbRLt; Sun, 18 Dec 2022 00:15:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F0234B491;
	Sun, 18 Dec 2022 00:15:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E55A64B3DA
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Dec 2022 00:15:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3ECuciE1fvZf for <kvmarm@lists.cs.columbia.edu>;
 Sun, 18 Dec 2022 00:15:48 -0500 (EST)
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com
 [209.85.214.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CB67F41021
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Dec 2022 00:15:48 -0500 (EST)
Received: by mail-pl1-f174.google.com with SMTP id s7so6087952plk.5
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Dec 2022 21:15:48 -0800 (PST)
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
 b=IoF4r9n8r3bYgg4qH+v8mr/mpWeQxk+3ShcAzl+6jnOtNaWi6WGder1ssE14wswEt5
 pVciGJpDbPz0hT8Ek+MRPWKee49+ZQ4HckdVZR3KTeDPf/hj2JxzTPNn3Bbg55nWHUbd
 GoL+/ELYQUiwrudrI+Uz+4lLOKOxESpWzIb4I7zrGR+vNPgFsjWLuCfhhrYB1Im0eD8p
 vYl3BiDLcfH8YeIQX+boRnekaFvcSfIOB0UK+wOmyPd78exk2UwGmO4sLvhKNmKz8M2b
 LZYJsOzR3L2tlBsSNUxiPY5YmnKg8cQTD1BdJSTOLzRl5Ml0lY1M9WspKuXm4CX05rY7
 mihw==
X-Gm-Message-State: ANoB5pnOIhxnE0Z7b69+3HS1StYNAKIXV0i3AacMPZbwl5usTXbFIOGX
 KYICvPt1rZX1SEnwE56A6SVhTA==
X-Google-Smtp-Source: AA0mqf7QCiGl5d9+spTzOyPlO6TcWemQOa/HV6d8IE9CviRM8bqJlTDV9iNJCKFfiTU6HuKnpIEFLA==
X-Received: by 2002:a17:90b:253:b0:223:1e7d:67e7 with SMTP id
 fz19-20020a17090b025300b002231e7d67e7mr20682580pjb.21.1671340548041; 
 Sat, 17 Dec 2022 21:15:48 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
 by smtp.gmail.com with ESMTPSA id
 b1-20020a17090a6ac100b002139459e121sm7002417pjm.27.2022.12.17.21.15.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 17 Dec 2022 21:15:47 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: 
Subject: [PATCH v3 6/7] KVM: arm64: Mask FEAT_CCIDX
Date: Sun, 18 Dec 2022 14:14:11 +0900
Message-Id: <20221218051412.384657-7-akihiko.odaki@daynix.com>
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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
