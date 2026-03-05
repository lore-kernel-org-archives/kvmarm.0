Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C83B3D2FE6
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 16:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772728132; cv=none; b=Z5oDezpI+oUqP7i+tuAqPMqmwki3oq4/pAE1EwURXz/ZlRQv+qXCSBVVNF9kQyDWtwsBwhZ8tGNUDfIOm52i89Kd5yZ4wNatamcpUnLxNKGGRg4rJ5bX0PzSrluvJHfUuRuIBwTkarzWWQJoaY/BP8RaL/akC40JsgCjJMQ1CLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772728132; c=relaxed/simple;
	bh=jRbuMwpJsJoLSg/pi0zzkkbxx1hvVOZC7VqjzxcTG6M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=P6W8bwiVuvF8be7XQsNujM5idJSTJcWAP9Bwx1OravaibZpN6+eQyjhW5JdKAXzCRj9fAn8sX94evwvYfgVZO/32BBz7UOF3gH7Eg4p8yuUINkjiHrg4GsT0M+lkt++zu2IjKDLPIcQSFPL46DaULHhDCaq/rkwTa2oGq/5X/NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JomOqlJJ; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JomOqlJJ"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-439b9b1900bso3396310f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 05 Mar 2026 08:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1772728129; x=1773332929; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=11VRqYRJ5Pqc2nNG60kzy1sCOR7Z8KyAMmnGQpaAEQI=;
        b=JomOqlJJj+jxbOVOSrAvEcJitdDBqmoMOOD1/MtPk8GY8LzG9cYU1ezrgySdtJ/p8K
         IzVhgdDHRIAoM9huK5zamC0voyqBRYQN6PE4wfpFVj/2cyssHvV+rkeZoUT8SMKfaoc1
         iEUyWfahdaF9HjDy76IrICNJWGhv73bKVWUL6Ywi1Znf9mVAcLEUOMTsBWIBaraZ49VW
         UVcZ/qn5M8OZFBH5TH0kpU9HNtpPWRuIkjY2pUrzE4ly149aRsFDjpkoL3X8IhWrV9aG
         TrfrWqtLp7gpVOs3FSlKkTK/vD8u+bciacB7mpLSktobOrZ9p0RU282ObZn6pXwYCVjF
         OdMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772728129; x=1773332929;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=11VRqYRJ5Pqc2nNG60kzy1sCOR7Z8KyAMmnGQpaAEQI=;
        b=rMDWo6Cir4FWb6EBlX5GlYkX09+kes5LoVH5a4Onp3xPaLVfxzPzCZagaSvBToEFBO
         4XWw55iPocunw6zQpSShG96qZBaOtGh3JryaXRSEISYxswSSj9HQ4QhuXHj/ZDwRyHzh
         9tnOMoIiTAMOGoOG+0vzWLM3/c7124ulFci5prfW/JcKkNKUGT7gOrhPRMdDeNh75yC2
         C/rgl6LiQVMpMjN4H7zpsVzwjLacjU4vnl4n+wWKJseQnQOMXZrsneuP1FSxL8qziabT
         JF0He01ZnQZeAYQZJpI8lHsuKcujURrIVOnBmiujQwlUPDACNiWbVGPBu+1N7MJJ4+Ys
         ly8A==
X-Forwarded-Encrypted: i=1; AJvYcCUT67j7AtcbZb5vLBcvpMbdhd7T4hpLnkD5qPiXX9cReUMfQiXfOe1f3S58M/xx1cl4foRHpQ4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxYPojsh4G21w9TICqS+xWG/sNNHMUxsM3DycGpNggb52zVmdo0
	4kY0czDlisUx4TlsT4k/6HreN1oUJ7xKrFis0DGfJEhA70RZHjcNDFLx5BTV2Wz5EWc4gD0mNrc
	9cEBmOHY=
X-Gm-Gg: ATEYQzzrSksIGG81FvsBtI6Uy7DCWun9hHfzVOsU6Ku8CYxrk14JonueLSBceN9EX/O
	7jjIBXPB8aTuYhtcGqqVX2+Z1vvZ/efDVBgiroIPiH++vgsnF8q5IjBD6JRmJm5rT2mOajsKRen
	fyGMNnSFu21DTvOtJXyt8sESbK9gwk6BfHQHdhphw7Em1IGNvt/HJFSD41b2CO+Eq+nE34Hm60j
	6pu5RHqRdGH1BzY1icQ4PjQkRIub/uLOtwfPMAgQzBi0IDOYCZoArLyREdty1+NI/I+dMrOmCNy
	2w+DFeVT1YPWMeULo2IOVRm7i8UsfqFT+qUQCJwCQqj49BhHwUvyLobV19PCrfziq3pgE3aaID/
	CPr3brOkigWCxpz35LZ+3eeMI7NopGgyLqm+p+xjhcdYaJQWHFo8wM7icwyNNq2FfmukJasQcaj
	5UcB2ZxTaExWa7ykaEADraXilRBOWA/puQ
X-Received: by 2002:a05:6000:2401:b0:439:c1ca:82be with SMTP id ffacd0b85a97d-439c7fffe76mr12612831f8f.28.1772728129352;
        Thu, 05 Mar 2026 08:28:49 -0800 (PST)
Received: from ho-tower-lan.lan ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439c2f8c0e7sm19596034f8f.29.2026.03.05.08.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 08:28:49 -0800 (PST)
From: James Clark <james.clark@linaro.org>
Date: Thu, 05 Mar 2026 16:28:19 +0000
Subject: [PATCH v2 3/3] arm64: cpufeature: Use pmuv3_implemented() function
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260305-james-kvm-pmuver-sign-v2-3-ee80a125af9b@linaro.org>
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

Other places that are doing this version comparison are already using
pmuv3_implemented(), so might as well use it here too for consistency.

Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm/include/asm/arm_pmuv3.h |  7 +++++++
 arch/arm64/kernel/cpufeature.c   | 12 ++----------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
index 2ec0e5e83fc9..ecfede0c0348 100644
--- a/arch/arm/include/asm/arm_pmuv3.h
+++ b/arch/arm/include/asm/arm_pmuv3.h
@@ -238,6 +238,13 @@ static inline void kvm_vcpu_pmu_resync_el0(void) {}
 
 static inline bool pmuv3_implemented(int pmuver)
 {
+	/*
+	 * PMUVer follows the standard ID scheme for an unsigned field with the
+	 * exception of 0xF (IMP_DEF) which is treated specially and implies
+	 * FEAT_PMUv3 is not implemented.
+	 *
+	 * See DDI0487L.a D24.1.3.2 for more details.
+	 */
 	return !(pmuver == ARMV8_PMU_DFR_VER_IMP_DEF ||
 		 pmuver == ARMV8_PMU_DFR_VER_NI);
 }
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 07abdfd40756..cc9783b26443 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -77,6 +77,7 @@
 #include <linux/percpu.h>
 #include <linux/sched/isolation.h>
 
+#include <asm/arm_pmuv3.h>
 #include <asm/cpu.h>
 #include <asm/cpufeature.h>
 #include <asm/cpu_ops.h>
@@ -1927,19 +1928,10 @@ static bool has_pmuv3(const struct arm64_cpu_capabilities *entry, int scope)
 	u64 dfr0 = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
 	unsigned int pmuver;
 
-	/*
-	 * PMUVer follows the standard ID scheme for an unsigned field with the
-	 * exception of 0xF (IMP_DEF) which is treated specially and implies
-	 * FEAT_PMUv3 is not implemented.
-	 *
-	 * See DDI0487L.a D24.1.3.2 for more details.
-	 */
 	pmuver = cpuid_feature_extract_unsigned_field(dfr0,
 						      ID_AA64DFR0_EL1_PMUVer_SHIFT);
-	if (pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
-		return false;
 
-	return pmuver >= ID_AA64DFR0_EL1_PMUVer_IMP;
+	return pmuv3_implemented(pmuver);
 }
 #endif
 

-- 
2.34.1

