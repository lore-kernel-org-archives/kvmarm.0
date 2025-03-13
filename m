Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01C71FBEA5
	for <kvmarm@lists.linux.dev>; Thu, 13 Mar 2025 06:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741849101; cv=none; b=dJfF11qctXtpQtIvOmVQx80ZAMi87n9GJzs6Jn3AJXMX09+zJ5FhzNFsA+gPuSi5+BUpN9YaYb+SQ7ZeuBmU0Lt23aO5ekwjCP3uuUUPZaAN9EBjfXfFUJAJT66v/BknwgWkZtVuwfj7PPMFJU0Y44Pj0X1AU5XF9vMnU2EC6uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741849101; c=relaxed/simple;
	bh=Tj645q9eNem2mWG0f9T8+quM62XYJmnNKPTtUs1bzek=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MS6mLbS60CQk7OAaz4JbTxBOQNQQjYey7vMvMFlPCLhMozqRmGx/waFgKMtnJHDJyGvaaB1hciOe5dF0rEnu/zCWsgWI/IlccOYsaxYbS4EUt73OwqiW8EW7YEEIRb3tS6C+ZoKxYemoezFzdpINoo3enL0EQRgcFJQI5/ywCus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=kfRSF0pu; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="kfRSF0pu"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3011737dda0so1181366a91.1
        for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 23:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1741849099; x=1742453899; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dV52GHaIMEPgQHguZuBTFzmZYTI1o5W7vkJBLWdUl1Q=;
        b=kfRSF0pu7rKuN+bE4B2slHGroRj41ZfSxi0xAm1EQN9jco2HMv7kLDNvjmQr2QAJMq
         DjMFIj0a6gtbtCXubCwnXkD9Mx9EN0m8tl2xNNsylBVjvXoh2t3IKtl1SRF2AUY+SPIy
         uyB3jt6oYxhL1RAmveYasy3O2j/R7pugOm46tsMtUEnRQ1ga8uqsmocczIKovg8BxHgX
         pMm2im57e6Vrduhy+Vdo1BCvNryhUYqHmQBudNBQfTf6GYVlkmbeEB9Dglqfkj27AHzm
         XDHFoEpFNUSsLP16RP42N8tFjpsAabJehj4m1kVzs95fjrrcPT1qZMOc/qIQgoGPqwNH
         bo8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741849099; x=1742453899;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dV52GHaIMEPgQHguZuBTFzmZYTI1o5W7vkJBLWdUl1Q=;
        b=uXY5/HAeBmApV2kZOf22kqk8DLyQ1zewBFghZDgiLdodpz25TK17m3X7Exr4zFxwt9
         67nU0yPy15qySIMdhx3Yr/DOQPJX3MO9y/DrDMs+7EH7zMM0C434CFDaOq3yDJCbbsBl
         Zl4DWAc1xpNHtceObZoPQjWoXX1iEFzvqRN91a9s2NRgh8Kp0Q/dD58PWhKsdTK7bVAw
         1M3KJkmr5sBi1Ar4FIadhTc5gZCZ06BkLEIYhWWPqpUrfpeJxblZW66BliZ02ZGYmaXW
         lfsgvaSRdZiKp83bMa9nN78zeOSMd1Hrqofv3zlmocP74nP/EI8y+JNbwRuso1QDQZ8I
         zvMQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNWuus2eXGDZEoIzIPZrGXKL1A634fn9zMqZ/44C06i4gpb5PAY5iPmJghLuQ4/r5GMiqfvx4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3PUaRj22oZ/J9p1ShGuTZSEcw1czHWYwsN6Uzrg3SUEULTFsf
	MU5nHHYYcTM8/5vFr17+Uv1dzOSXmMF8jJLr0MOPZINTvN8IPzZUNqcqhwkabJo=
X-Gm-Gg: ASbGnct9S+njiGgLCKgixT/WlXHMp1VcQ8pgqlAiTNZOXLj8o9CSAW+7Kl+UfuTQCiU
	CJ1HwLo5R0/NRPZPBEKZWLQLALl8E8W6FUo6A/ozTmIvThUB+l4aFJgesfOE3cZapEft8QHBBrT
	s6Fawpz97tK9DFjQ5JJ414x9cDB3GW14J536nn2LSfjgr+ZYbRIVLAZeX7Eu91D38bTNL2QZy0j
	ROjG2ZHYsc+Jiy6TPXcwYQ8eXMPfQIxI2eSyGyTiqtVXrhsNxMWuh5UwRuS8Z/KGdSc0WApj27D
	0OP7jtXxp2e1OcbqF1t1z6O+77b6C83IEQ9oJblOz9Dm5R9S
X-Google-Smtp-Source: AGHT+IEdM86wLdPa/J6rG1pbebGy/mfNmQe+uLQUEr6OB03UsH6Ds/Qp3ZpxLVj4ahH7YgLID6TR2g==
X-Received: by 2002:a17:90b:4ad0:b0:2ff:6fc3:79c4 with SMTP id 98e67ed59e1d1-2ff7cef5cdamr34627616a91.27.1741849099153;
        Wed, 12 Mar 2025 23:58:19 -0700 (PDT)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-30138b5d229sm610894a91.22.2025.03.12.23.58.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Mar 2025 23:58:18 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Thu, 13 Mar 2025 15:57:46 +0900
Subject: [PATCH v4 5/7] KVM: arm64: PMU: Call kvm_pmu_handle_pmcr() after
 masking PMCNTENSET_EL0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250313-pmc-v4-5-2c976827118c@daynix.com>
References: <20250313-pmc-v4-0-2c976827118c@daynix.com>
In-Reply-To: <20250313-pmc-v4-0-2c976827118c@daynix.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Andrew Jones <andrew.jones@linux.dev>
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
index 3ed8b74d9925..461c76a9cb6b 100644
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

