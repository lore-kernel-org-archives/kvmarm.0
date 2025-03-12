Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2076245005
	for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 11:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741780595; cv=none; b=PpL4UFqWodaQA+YGFwErAJoieD+0gOwQ5IYWAgeNSRLDELzb80DNDoODvKfjEVP9gzQVUNK9TCbvPZsvkcv3nVPiuyx3hlQfYdjt16Ft6lRTLW2WzIlXiw9CwzxXdfVdaygHPDjqHNEJHkL9PLTSolvcPYJNZlmQLuGfyRY4Hkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741780595; c=relaxed/simple;
	bh=5jRu52Q1kPSXe6BSqBZdOYqPbm4DaeUHgm3v+MK2O8o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=C5p9tf3ywYU6zP7kBiuPY7/39IzLb/8mBgi+EeOHamb4KB5r+UCVaVG3i2ks79ezmFeor5KtoA+xxwSGuH0X9Y+ZD3FVLn32ZqZgmkpfIlvrCY84RL+1uz/mxyah/TWg+Qw3T9wKyqVNEou4JwIcf7oFqk0iXRFLeyeq7arTctY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=D4aB7Cjt; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="D4aB7Cjt"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-22401f4d35aso117133125ad.2
        for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 04:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1741780593; x=1742385393; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TCAwKKa1hp4qKIGSTMOyXPQD5trWA7N2WyBVQxGWCbk=;
        b=D4aB7CjtzdnUPoJYWZIN5fJt3vK9x2G0nqW8PgRu4FCpWcVP7/EBwbHqgOvYf47xCA
         GUyh5jDqLjr4EdxpwS6PHUVFKpk7bOwwDtKCKwSga/nxOhr3BuqaQ9XtrPnmv9ttKZ7H
         YTbkl3+5guCKylR1Bwi2flGsF91sMN7cItlZ2YADKybVhOQoPgFe2XffEIGXH3TQgaFv
         OJqKDmt1ipDu1pdD2SMIOOboFMMWn8eUapkoM1joY1+JJoZ5fz9a9hJg1kH6inAfgKPJ
         gED4JP91N2GU7hZxlnaFNdWFO2czeHLGQBeZnsNZc4OvtRkVnDd8Ga9cdJ6kPa5p7JGt
         3Gqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741780593; x=1742385393;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TCAwKKa1hp4qKIGSTMOyXPQD5trWA7N2WyBVQxGWCbk=;
        b=ivLKPoC6wofu4nCF1YQPQY0h5x4xrw2GSF5XwC50RFlRlA/By/RhRk0INjfm/l4yR0
         ESxDkkutnr2Uogg9LzmaAt6+s50p3WzauToQi6gc/Pyt+NcJFQ6iVqeAZJuRC3rWC6Wf
         x4PT3DxCOgCfRTBxTNq/fkHkyf08v7XKbkUAq2QnRl8n09pFcayXk5bqAoXcGoKlxyVV
         eslisZgRMABmRPK3vSuSamYV1O83vzf10Gix6XRZcfVM9YrsjuVypovEel6/pyOkWKTS
         CnPnCZErlXubcb5zoFeeGc80ue385DamOGGkrlLvdUGwqGrB38jOLjCFzw4t8gv6AhPc
         sX3g==
X-Forwarded-Encrypted: i=1; AJvYcCUPRPj081I4sM6Z7oy4zBNfvghEcZpZTT3IVAespRxeuwgFlO+anY2gwVZILsvayAGIoBI/4/Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YxA+QhjQI2JM0SYR4PX+eXRMJnZDyvgzkoE/3tSZZrvfO/s4AY9
	EYMMbPTd2Ie4mGcYS74CvGDA8Qn8Jlk9uZJ8dXLS5Cas/PNVRinEv/sTJvMZVq0=
X-Gm-Gg: ASbGncsjI2QsgLXUXdSq5UO6SkHfh/jNAD2BMMoVTDEF3+BWLkeb7QgWoFmefYzPqRg
	NlS8jfnL27930gMT7kksQMSX3WFEMg76QvBCbr0xwpufuP+5pvwKT/K99b5lOR/bPjucREEcdTD
	j6fI+euOZLh6VO/OmgtTzMvhq/nuNmTtnZg5FQ8i48u9PuTI3mFo9SzBSNS5nqk/jqFki/X8X0M
	je5NNAvvTxOcduw52jzKhYdc41YgoIBaivqNrGlFzbe2wNc9JtaPoZ8687GgB2UC85p10OiVfC7
	oGu+x889X40My7crpOisHOQO2ZbWcXziJXChmKoHe8OHxWBv
X-Google-Smtp-Source: AGHT+IEt7ftF0+X9PEZlO2xjYhcH13J+1KUiYMwfGTA62pbfX70/qK8tdqWOcbGMQp5ETZdkFMGsvQ==
X-Received: by 2002:a05:6a21:6e01:b0:1f0:e706:1370 with SMTP id adf61e73a8af0-1f58cbdcb9emr12506243637.35.1741780593100;
        Wed, 12 Mar 2025 04:56:33 -0700 (PDT)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id 41be03b00d2f7-af2f01909a6sm9911068a12.7.2025.03.12.04.56.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Mar 2025 04:56:32 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Wed, 12 Mar 2025 20:55:59 +0900
Subject: [PATCH v3 5/6] KVM: arm64: PMU: Call kvm_pmu_handle_pmcr() after
 masking PMCNTENSET_EL0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250312-pmc-v3-5-0411cab5dc3d@daynix.com>
References: <20250312-pmc-v3-0-0411cab5dc3d@daynix.com>
In-Reply-To: <20250312-pmc-v3-0-0411cab5dc3d@daynix.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Andrew Jones <drjones@redhat.com>, Shannon Zhao <shannon.zhao@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, devel@daynix.com, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.15-dev-edae6

kvm_pmu_handle_pmcr() expects PMCNTENSET_EL0 only contains valid
counters.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 arch/arm64/kvm/pmu-emul.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 78cfa8b0964d..2d19c6048091 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -831,11 +831,11 @@ void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu)
 {
 	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
 
-	kvm_pmu_handle_pmcr(vcpu, kvm_vcpu_read_pmcr(vcpu));
-
 	__vcpu_sys_reg(vcpu, PMOVSSET_EL0) &= mask;
 	__vcpu_sys_reg(vcpu, PMINTENSET_EL1) &= mask;
 	__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) &= mask;
+
+	kvm_pmu_handle_pmcr(vcpu, kvm_vcpu_read_pmcr(vcpu));
 }
 
 int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)

-- 
2.48.1

