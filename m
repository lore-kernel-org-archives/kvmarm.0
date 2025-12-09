Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBCF309EE9
	for <kvmarm@lists.linux.dev>; Tue,  9 Dec 2025 20:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313560; cv=none; b=ENZv40ffe8UaEnZayVL/FulZkDntBZZujGCdD1Mazu2cU12S5zkm1zNtOykzTmWgrfFhyxDhiKiovu71aCPVovqB8wj4gqBzQe6yXZKMgzLl6kQ8cLddtjebD7ajrI1GZiEFht6Lst7rYL4uJNRIzxRGWIDJ19lwPXXKPECBRZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313560; c=relaxed/simple;
	bh=0D8f0lGMl9e4KEAGFc7uVXhORDpuK8IH9gEX8a1WgT8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P3YH0cVM2B3LY+3EhKGQMq5DHAEeN4EImFGz20VFchLKHYxmErIW+LrttRgjVl92RD+jdIj4rEeEbDChr+hJ3ZIlKs9AbNLcptAjDRoTuN+q7b4gTosQ/+1FrJ8V8O57h47AihnnkJ0Xt4MxZiDKdsK8+9NCdtm8zXw+1A92UG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZadTiiFT; arc=none smtp.client-ip=209.85.167.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZadTiiFT"
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-453799e65bbso7446619b6e.1
        for <kvmarm@lists.linux.dev>; Tue, 09 Dec 2025 12:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765313554; x=1765918354; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A5yWZRzHwonF0ybTPKNr07gTZcgByeP7H9fiRk7DESE=;
        b=ZadTiiFTTtKbxQ8C8Szu6+615crSP+kaOYGiYaM0VgK5gWdRasaYFnYst4AICnP93S
         uozXA88agwOuShEC6AIuFVlf5uQcB/Otey6rsPrQSo5FP5glYoNJ8eGnlfmHXkptzkmv
         bOJQUvyVJYRLQDnshjWxu+MQ1fB5YHtI8ykArrjRBCuqEi0qz5vJlbKIpsOymtlfem2p
         lt650NczQp/ZGxj3MWdJCC7xXlPrriy73pcIfar5mdepCsCQucfsuGBpRF7eX2gCDaMd
         +24MuWiugQ4+JWepg1LXwEBpDBlJ4AWIkdu9InDCsnO440rIiz+S8slFzN/NK4M9i97C
         xw5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313554; x=1765918354;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A5yWZRzHwonF0ybTPKNr07gTZcgByeP7H9fiRk7DESE=;
        b=jELNm3FGc4BW/EPGpm0U5GnPv4s8+BDC2NysvnL56sPmomC50cuAU+cgaKqd4mITDr
         JAd6y9T6H+s2Ty0+yiYQT1m60rPpHSBr72sgCBJSvwWG1mBvo/wPxMnXF5BqD8AMxDKJ
         mrNPa3QAHmc1MfvRbYD7ThEnTaSSyMsB2cAy69kuc2lLBWXUvVAY2oi4HxTNU60/vlmw
         mzCkrHqgkG/0GNfSiS6iSkm8BqtH1XQIAlIWrcYfZw0iHG9Jf8KZHTuwW6X3sRUoJngM
         DnoJAjPHGK2xSjFoAdrpz7ms9sY0hissWUpFp6GxdD08fNgft3wofhpkRLEvvFwZ+IG4
         sFJg==
X-Forwarded-Encrypted: i=1; AJvYcCXsWFM6lYqZcYtS4sECz4odIa7GsmPzUWG0XnglRutDdkjywNDYscVnU9SzCUTx4HrHtkW87Y4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyO7gwmgCuFP0tuh6b65peVXZ1YzBfalMSEFzKSAbzmlqrPx6l/
	lKqXI6KYptXXnbJMcI8qkJbHsqnORrOV+kSNOqZyql4d5zbXBwD4wOcBD24cnm4bRGFwFh+cJvM
	YWBstTjB8MuMVjPNgk2jOSZqOjA==
X-Google-Smtp-Source: AGHT+IH2y/y/c/VHwW7FsQzg6cEqGCqxyR53g3FW4QbocbYeWU2m/DAvppskfkGhYMkbAciwVFKu+/4Kb6/59MH36Q==
X-Received: from oibbx18.prod.google.com ([2002:a05:6808:1b12:b0:453:f2f:fd82])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:191d:b0:44d:aa8b:58f2 with SMTP id 5614622812f47-45586554d1fmr140748b6e.9.1765313553989;
 Tue, 09 Dec 2025 12:52:33 -0800 (PST)
Date: Tue,  9 Dec 2025 20:51:05 +0000
In-Reply-To: <20251209205121.1871534-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251209205121.1871534-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251209205121.1871534-9-coltonlewis@google.com>
Subject: [PATCH v5 08/24] perf: arm_pmuv3: Generalize counter bitmasks
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

The OVSR bitmasks are valid for enable and interrupt registers as well as
overflow registers. Generalize the names.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 drivers/perf/arm_pmuv3.c       |  4 ++--
 include/linux/perf/arm_pmuv3.h | 14 +++++++-------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 379d1877a61ba..3e6eb4be4ac43 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -546,7 +546,7 @@ static u64 armv8pmu_pmcr_n_read(void)
 
 static int armv8pmu_has_overflowed(u64 pmovsr)
 {
-	return !!(pmovsr & ARMV8_PMU_OVERFLOWED_MASK);
+	return !!(pmovsr & ARMV8_PMU_CNT_MASK_ALL);
 }
 
 static int armv8pmu_counter_has_overflowed(u64 pmnc, int idx)
@@ -782,7 +782,7 @@ static u64 armv8pmu_getreset_flags(void)
 	value = read_pmovsclr();
 
 	/* Write to clear flags */
-	value &= ARMV8_PMU_OVERFLOWED_MASK;
+	value &= ARMV8_PMU_CNT_MASK_ALL;
 	write_pmovsclr(value);
 
 	return value;
diff --git a/include/linux/perf/arm_pmuv3.h b/include/linux/perf/arm_pmuv3.h
index d698efba28a27..fd2a34b4a64d1 100644
--- a/include/linux/perf/arm_pmuv3.h
+++ b/include/linux/perf/arm_pmuv3.h
@@ -224,14 +224,14 @@
 				 ARMV8_PMU_PMCR_LC | ARMV8_PMU_PMCR_LP)
 
 /*
- * PMOVSR: counters overflow flag status reg
+ * Counter bitmask layouts for overflow, enable, and interrupts
  */
-#define ARMV8_PMU_OVSR_P		GENMASK(30, 0)
-#define ARMV8_PMU_OVSR_C		BIT(31)
-#define ARMV8_PMU_OVSR_F		BIT_ULL(32) /* arm64 only */
-/* Mask for writable bits is both P and C fields */
-#define ARMV8_PMU_OVERFLOWED_MASK	(ARMV8_PMU_OVSR_P | ARMV8_PMU_OVSR_C | \
-					ARMV8_PMU_OVSR_F)
+#define ARMV8_PMU_CNT_MASK_P		GENMASK(30, 0)
+#define ARMV8_PMU_CNT_MASK_C		BIT(31)
+#define ARMV8_PMU_CNT_MASK_F		BIT_ULL(32) /* arm64 only */
+#define ARMV8_PMU_CNT_MASK_ALL		(ARMV8_PMU_CNT_MASK_P | \
+					 ARMV8_PMU_CNT_MASK_C | \
+					 ARMV8_PMU_CNT_MASK_F)
 
 /*
  * PMXEVTYPER: Event selection reg
-- 
2.52.0.239.gd5f0c6e74e-goog

