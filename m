Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28633CCA17
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 16:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772728131; cv=none; b=sDevO7Lz+GBPr1k4sw1sUZSDhFGHscM0Wl4m3V6LE5phmvFGzvd+lfX6Hs74WgjuM9l6KY3gsNIL1lO3gPtEuqcvL9YYRwJkjnhQPqyNPy+3ReEc6SHBVOuVQk5iFe59MI7CH2aH/Yx7KhcAdY152bWmy1v6Nk0Fh9iL3NenC3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772728131; c=relaxed/simple;
	bh=eGMJHqDbmqpHeKVNhq5RasWcU0PN40UYs50dG3pEfSY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iSpH45kG+bbb8qkphnQRbjp26F0Y9YtYIB84t1tVSBPTQy3zNxHTzh0rheA4jKxepGo4O777WySGPDcj40IPV0BErY/x0HPNNBgJTzBV2PouJUXRIT6vm70ep7Bv6szu2XIomXSddvU58rV5HNXtDtk/KNSe5IOqpCuP4y8UA8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Qrr6ByS2; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Qrr6ByS2"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-439af00d33cso5054897f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 05 Mar 2026 08:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1772728128; x=1773332928; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=956LHPVlfL1rOP3wzpXMeMW0aPaZLWqWprb6Mq5DKY0=;
        b=Qrr6ByS2djFh9gM2UmNNqu9u+YJTFI64zZVWyhtReHE/hT0/6Dj5KjSOMYgNesaCyZ
         8evbwBl+upYqrSrIH2tjXcDfHvLHd4CVQ++pg9LXN7FUdSdCy/TGCf1c4RZo3jsz5eDV
         xOzMSOGQ7+UKSk8FQx2yKaKCoWm8VCKwGBwfDGs6LsDzryQbLBVlXbGF3ZVL6E7Vjr5m
         f/MMJ+ay3PzqAZmEGJaTnFALE5kCiCS7kproniswmRURXpWbzt0RqLblUTMSjcbvZtqg
         TGJVSFQ7yUoEAc1r7R5LDU0iK9NZ6FnCc0iJxl/L0UHJ1NZxJfi9VzzwIAfF4ucKjU2S
         L8Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772728128; x=1773332928;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=956LHPVlfL1rOP3wzpXMeMW0aPaZLWqWprb6Mq5DKY0=;
        b=T33KxcmEP0/c+qRnvtb3llLj0bjjmyYoG/vE3PdqZey7U1HZSThLTCQObRSCTbWAT8
         dRvW4iXEkpLK9Vz7M4SYX7qaccUNs9h13+ws4rT0BOdyFfBTnALlsQ8iDeNyQjcFkwTP
         pP5rPQiq1JRInKs0LO8agnzav4Te4yfPiyP1L7Q+QiekK8puu7hGLG9iABXZFmE9YQgB
         DsyZMc9m9oRrcF48khBR0AAI+XaQvluv+mp2a9wHfSiIOOvrrrm/HTUsTzA0vcmhjF7W
         EDaY5/hgEattBS0Jxdy7ksaqK/X4/oIz4A1z9gWQLAeHzPSqkaR+owdgkh40feCsJ3PA
         VdAA==
X-Forwarded-Encrypted: i=1; AJvYcCUOpYXGEXhz10DtehBD6STfM/soXODgQ0gYWNmGxtfYVxf9BSR0tfL6QryxFVs0UVbiSaJgifI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwrbNHZwoxNWnpjxr9VevmPH3HwRbzr/XyqOMg+jiW73oIPRPQu
	dyjZMn/FCDdVja6x16o7Hw9NNNOoiavrVUqbsQdcnICYg3ySifsTuyUYh02SsCt20ng=
X-Gm-Gg: ATEYQzwu7KHN85Uwokc1EtZ1fcnSpojHPfCdlthlOK0nMduUqc77mJJyqiIx7GL2Fj3
	sAo4j6b2qASgKiBTsbUATScbYnh6crShSeFI7+Q2Rcxxsh0oeKVRTZxZ+ARqZpZqg1A4k8RmRs6
	h7fUH5iCKlzz77gTZ+/n+/M4r6J+cTLcyncR/fAZfJLxROXXJ7ZoqdhXtEs1e/zTXNQ5DPxUqaS
	Pf+M2okZQIud0xqrxs1tMdfs8Lf4j11UqRVV4q4773jFld3kApsJOgEMydPeceVDhFfGpk1QIcV
	Ei3kN1F4Mr5l4FELfXS1//xrViNamlIoiPyRzTjlApdUjuTxVvkPUPlprbzg/w9UodtkgVUlXbf
	m+RIU6JBEH1kMPv/nWcRruvb9uIR+oGo5h7+ztKowc/dvaof8b+n8ipFT7Ib+EBhFcMPJQU6u+J
	zOiAEPLVXJZn02CyUbQkvU0uSxcm4Ivycc
X-Received: by 2002:a05:6000:2881:b0:439:b9bd:51f with SMTP id ffacd0b85a97d-439d721cfc2mr748137f8f.25.1772728128375;
        Thu, 05 Mar 2026 08:28:48 -0800 (PST)
Received: from ho-tower-lan.lan ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439c2f8c0e7sm19596034f8f.29.2026.03.05.08.28.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 08:28:48 -0800 (PST)
From: James Clark <james.clark@linaro.org>
Date: Thu, 05 Mar 2026 16:28:18 +0000
Subject: [PATCH v2 2/3] arm64: cpufeature: Make PMUVer and PerfMon unsigned
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260305-james-kvm-pmuver-sign-v2-2-ee80a125af9b@linaro.org>
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

On the host, this change doesn't make a difference because the fields
are defined as FTR_EXACT. However, KVM allows userspace to set these
fields for a guest and overrides the type to be FTR_LOWER_SAFE. And
while KVM used to do an unsigned comparison to validate that the new
value is lower than what the hardware provides, since the linked commit
it uses the generic sanitization framework which does a signed
comparison.

Fix it by defining these fields as unsigned. In theory, without this
fix, userspace could set a higher PMU version than the hardware supports
by providing any value with the top bit set.

Fixes: c118cead07a7 ("KVM: arm64: Use generic sanitisation for ID_(AA64)DFR0_EL1")
Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/kernel/cpufeature.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c31f8e17732a..07abdfd40756 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -565,7 +565,7 @@ static const struct arm64_ftr_bits ftr_id_aa64dfr0[] = {
 	 * We can instantiate multiple PMU instances with different levels
 	 * of support.
 	 */
-	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_EXACT, ID_AA64DFR0_EL1_PMUVer_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_EXACT, ID_AA64DFR0_EL1_PMUVer_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64DFR0_EL1_DebugVer_SHIFT, 4, 0x6),
 	ARM64_FTR_END,
 };
@@ -709,7 +709,7 @@ static const struct arm64_ftr_bits ftr_id_pfr2[] = {
 
 static const struct arm64_ftr_bits ftr_id_dfr0[] = {
 	/* [31:28] TraceFilt */
-	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_EXACT, ID_DFR0_EL1_PerfMon_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_EXACT, ID_DFR0_EL1_PerfMon_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_DFR0_EL1_MProfDbg_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_DFR0_EL1_MMapTrc_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_DFR0_EL1_CopTrc_SHIFT, 4, 0),

-- 
2.34.1

