Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337E32417EC
	for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 11:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741780599; cv=none; b=dDSwqIwCutl/UvoOZpWmGAm+M9Humkgw9XRgZyzPgvFEZnfFZqitfM6U1xrL8bUSn9EA+V/XD9brQ9CN2ArSk4ftHqV8YbzTu/EzEdLJ0hDNKE8pZx5fyHcYyGuz5e2vHTOQy2frZiQUBvY3gmMNp0aGFkVTBIjhmD8aqwOtVqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741780599; c=relaxed/simple;
	bh=HzzfwQzBMa06gpOYm7ED9Z4TNgABvoHrMUKZXgLGOoE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nNhIgANGNkO2KSCz2O/swuPs7/AKpb1WsP160ldZi66R4LnIAs2zkTS8Z5lycMxQK06751oUZOQDqYlhHa7noJi1Jr/rnl4gNtDP+RGoluOL7ObyHik3x+xX2NY/eIqOWweK1oqWsS0SS+p8ACri2j7SdNqgOqQ53MX5822AJu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=WomohgZA; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="WomohgZA"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2255003f4c6so72464105ad.0
        for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 04:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1741780597; x=1742385397; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u2W4Xv+9VQWQQBSPngguZ3XObUjYW0AuhHcxMG6Wj0Y=;
        b=WomohgZAPy70ifgKRD5Bz90mxjptYgglgQrwV5IAp0K30mvipmY8K6LYNbLTYgNPtU
         AYLZy37Fn4IX2Jw37mXEcQTHAoGjC/pdpmcmQhVJks/bxHeXvdzWQUcu5GjriICz9BvJ
         yY9um7/4ghCHkjGX+KKc+PmEtBySXsVumMqrMKt/b+A67IT5ETL/wei+bWdoqDWMlFYU
         PNWtA8waQhTmXIdI7Mzk9THCo5yqNIIYqYRkG204ZjJ0kUv0LZ7EHcSC14L5Es96q5Gq
         F6EFBgCZ/4DZ0gz4MycP2Ijtdk2kl9uilGaYL7XORQGzv0a7vtLD2/xq+uRyA4CgzlAb
         thgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741780597; x=1742385397;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u2W4Xv+9VQWQQBSPngguZ3XObUjYW0AuhHcxMG6Wj0Y=;
        b=mX7t5AASvoc47AJC5CcAH2IvUdH69m8+bE96jAAR9oZOkTRB5ojbfAy3Lt6ziJD8l+
         BtFtg+oDdvvhNLI+QI0hH93ICuwUjJ1sZGvxrV95IvPRhy/aW4cHdkO1U0aT11w9fN8B
         N1FHBYIK9rkYFLMGMmjev9MSpzzWQNclirXGsQAirnCoFgDjuQPL9r9fixkWNKjXrIN9
         b1huJcjKNyM7tdWLfdsB/MUtvbsGgG9/9fdiF1PypV4laPnOH6X+Igddp4qSC4tryr0g
         sOLtRj14rgQ5l+2C0gd9G39OYRb+Q66Q0wYzlmWaVmnZxx9nFv46Su8m7tXCtz4SrSPa
         CU1A==
X-Forwarded-Encrypted: i=1; AJvYcCV10yDCmC0idpeT6fVXlhBPZ/pKUXkNwbIdOH9chYUt+KpiLfQNlVRfaIrwnfw7uC3AltOFX18=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzg6qTi760V0fYKMUj3lI7P7b8fIRyu9Gm48SqVXXLkjUj9ujKD
	DDSwWjtbNg08q4A4Lm/PpnoInFlpLbFtzhJ/hraptbJtOVnQApE7xWm0veRvBvI=
X-Gm-Gg: ASbGncvm9Kgrygk3zIpYJaubA91hVjIfVfvY3qDdpDkN1FWraNeXZmrEw1RbxT9+x91
	FW4A01XdEruFascOGEFPPXpW+FfrwFgd6aoQY2pD1Qh80L1VgMKiohYRQ/odxF6WUflQ593RDo1
	R7LkBsLdDDogtMew559LTgmh5GcWiIT0QfV+jf90sRa+7OVdGbA0DryZG7iTaCJGIZsIPslyDu8
	AbE6FFgOZgSooCksC/YhSDiWUAj0eODrHk6MZsfH7Bjf3wWr8CcPuRD+PJ0cv2lqZfwk0h9oYD1
	vLibKGb0mQjU+D918JwPW4xqBNCTD+H1ovfV59l8+9cvszk9
X-Google-Smtp-Source: AGHT+IFKd8JzPs00shGeDPszPVRqf7Tdd+CUl4POW8V13KNLbNVMybkA3YJRReDGIm9qT/E2zqWsNQ==
X-Received: by 2002:a05:6a21:9d48:b0:1f5:8a1d:38fd with SMTP id adf61e73a8af0-1f58caefbf9mr12020498637.2.1741780597517;
        Wed, 12 Mar 2025 04:56:37 -0700 (PDT)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-736d4f20913sm6410407b3a.13.2025.03.12.04.56.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Mar 2025 04:56:37 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Wed, 12 Mar 2025 20:56:00 +0900
Subject: [PATCH v3 6/6] KVM: arm64: Reload PMCNTENSET_EL0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250312-pmc-v3-6-0411cab5dc3d@daynix.com>
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

Disable counters that are no longer included in PMCNTENSET_EL0. It is
not necessary to enable counters included in PMCNTENSET_EL0 because
kvm_pmu_handle_pmcr() does so if appropriate.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 arch/arm64/kvm/pmu-emul.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 2d19c6048091..b14655dda6db 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -831,6 +831,8 @@ void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu)
 {
 	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
 
+	kvm_pmu_disable_counter_mask(vcpu, ~__vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
+
 	__vcpu_sys_reg(vcpu, PMOVSSET_EL0) &= mask;
 	__vcpu_sys_reg(vcpu, PMINTENSET_EL1) &= mask;
 	__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) &= mask;

-- 
2.48.1

