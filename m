Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B193C6A21
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 16:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772728131; cv=none; b=rtiWwWlx6YYP8W8fgePyAInepkqR4OLtksS9ZeiBWLWLTgRWvFIZ6IRLtak9+Nd4/3ZReB/AMlR5NEwdi0YSTNo8gMwhThCwQp0fTtJrEAau5iC7ZQA/MKofurgq+lP8dKWramfCBm8EP9fRgEc33HLl3P9G1wLekjBaKol20vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772728131; c=relaxed/simple;
	bh=suVlOkK2FxaMrVmsSWeDXx31yW5F+MdOw/3w+mpbd44=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=L4TkgOFfTTeqc+HpnoBYCqP410HGDjXXsrvuOK26SFrlA3perfisJMGPNRr8Qth2uIukg2OUl+KLsOTtzHj3gzcNpeeiNxp3DlrnkPTrHiHkB+r7Q3PfitOICDnnLRd3Hx/yhJPHi7yalMfwW8UysZoIC77RECI3i6Mn25Z9Tvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nmpYogwX; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nmpYogwX"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-439b6d9c981so3307931f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 05 Mar 2026 08:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1772728128; x=1773332928; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b/8Q0uO9fn7N2aNObdrJAfX+BnNEdYRQNZ6cnN9zLhE=;
        b=nmpYogwXCl/cUsQmXM7ZT8utaImXtZWSlFDh+9VR0G2fORkxfClNNMPx70g7Ee9JSI
         ZMSLW0JBlHqTKaxXFu7mKDxoEF7ltVPfNSch6hIcKl//9+Ya69gFb2qjfCU+rMzz8aUN
         DAPFH3e1Ugsg17xcBKCqBB15BjEDnk71t57Ns1RSpmUzjL9WnUjssBGPF6u0I/eXSD89
         U591YBOZcfGiabmpHI6kYr0fHllyDIWy2fV2yKPVDT0NpmLpEfDgC7QS7PhFeN/Codjm
         nGB3NB0X99MIANC36yx17e189svslAKOO2rXFBC8dYOIM8Z70WOMa0SbOBRKKTbW/2Am
         m+FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772728128; x=1773332928;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=b/8Q0uO9fn7N2aNObdrJAfX+BnNEdYRQNZ6cnN9zLhE=;
        b=gTIjZ/t1JaCrVboUJW8nML2MGbQGTuihk5lgudTDT3Do6JSt/zqCCmIazo7DcfOEbl
         x9vsCcnDbCmgDr2CbgpD9ELD9lSv9tESpN0/wPUmc3X4M0JB1OLk/FBhuYw6YnDcMJMB
         8hEBKWS7FYvdTmrU8Uhrskd0qKD7OmsCxT24fSNfMv1cddhQ1ITTiErTIcsa708rpPBh
         Ry0phPmp6cQ7dn1Z2I8JzcRqWfiyNaLR95rdIfoxdNFTeV5WOxID4LgYyiaBbHYCX2c5
         /hvYqnfk+Rso2OG3vFX+4/5k0tfRgn/Z0KijWQRfHKlsr4cDY/gb1f4F+id4NQ23mP5T
         hwbw==
X-Forwarded-Encrypted: i=1; AJvYcCWDEOxJxVJP2w4AHvYqWI0gVwNuWa7nxVItcpx/Ez9s+FjdPT74ur+SZcsPMMOR4HKjBX/KsoE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx3XFX6+Pp0aImqo61Ln8O39/m3BQvKufPww/6fQB1j4LiD1baP
	sRI7VTjOX6R+utcIk/k/onCGoED2dk+2kbS1UySVgkwnnYGbvevdoI0y4iWNnEMmRRc=
X-Gm-Gg: ATEYQzzQdRsJ1IYsBKUAcwEdKFr6I8Vpmi4pkQjqMKUI4wKwnwuumqYFAL5KQf8OrK8
	ss/mlZQgI1rx2o8noLF8AdwPE/hLapKhhcHzifrtKdWoFiWFg9MErNGkObZjnRIG0VBInB65bOX
	W655+ZBtdUNEO8bh8tcDfiHcuMl9PG0opWKUgSSMz4XIPhH7rfBn8oxxnKYheC5zDMBzBFlpiRq
	IzYB9gexTxQrY4VTnvw96zvXCpc5Ekp9m5dbWnj5xEt5GisT2uVvNeZZZo2p6WGGQgYs0s4Fbav
	k96qZuV9p0iohyfpY/7QjfExmQktNejYWnRkj+P8Gb3O2rYo+DfjwWkjbjww4cdWfayDEGNOyui
	VDEnnowvRlypjllIGJSghM+WpcZzpF0502zh5pisiCqhnfkqCHWan5I+78pkAjpO56f7p2jInac
	NyF0VlhDvhrn+y23qYKNbJUMckjak9nB3m
X-Received: by 2002:a05:6000:1849:b0:439:ccd7:cdcc with SMTP id ffacd0b85a97d-439cfd65a3amr5335384f8f.18.1772728127425;
        Thu, 05 Mar 2026 08:28:47 -0800 (PST)
Received: from ho-tower-lan.lan ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439c2f8c0e7sm19596034f8f.29.2026.03.05.08.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 08:28:47 -0800 (PST)
From: James Clark <james.clark@linaro.org>
Date: Thu, 05 Mar 2026 16:28:17 +0000
Subject: [PATCH v2 1/3] KVM: arm64: Read PMUVer as unsigned
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260305-james-kvm-pmuver-sign-v2-1-ee80a125af9b@linaro.org>
References: <20260305-james-kvm-pmuver-sign-v2-0-ee80a125af9b@linaro.org>
In-Reply-To: <20260305-james-kvm-pmuver-sign-v2-0-ee80a125af9b@linaro.org>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Colton Lewis <coltonlewis@google.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, James Clark <james.clark@linaro.org>
X-Mailer: b4 0.14.0

ID_AA64DFR0_EL1.PMUVer is an unsigned field, so this skips
initialization of host_data_ptr(nr_event_counters) for PMUv3 for Armv8.8
onwards as they appear as negative values.

Fix it by reading it as unsigned. Now ID_AA64DFR0_EL1_PMUVer_IMP_DEF
needs to be special cased, so use pmuv3_implemented() which already does
it.

Fixes: 2417218f2f23 ("KVM: arm64: Get rid of __kvm_get_mdcr_el2() and related warts")
Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/kvm/debug.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 3ad6b7c6e4ba..f4d7b12045e8 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -10,6 +10,7 @@
 #include <linux/kvm_host.h>
 #include <linux/hw_breakpoint.h>
 
+#include <asm/arm_pmuv3.h>
 #include <asm/debug-monitors.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_arm.h>
@@ -75,8 +76,10 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 void kvm_init_host_debug_data(void)
 {
 	u64 dfr0 = read_sysreg(id_aa64dfr0_el1);
+	unsigned int pmuver = cpuid_feature_extract_unsigned_field(dfr0,
+								   ID_AA64DFR0_EL1_PMUVer_SHIFT);
 
-	if (cpuid_feature_extract_signed_field(dfr0, ID_AA64DFR0_EL1_PMUVer_SHIFT) > 0)
+	if (pmuv3_implemented(pmuver))
 		*host_data_ptr(nr_event_counters) = FIELD_GET(ARMV8_PMU_PMCR_N,
 							      read_sysreg(pmcr_el0));
 

-- 
2.34.1

