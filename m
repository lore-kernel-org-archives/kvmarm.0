Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8642F3632
	for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 20:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750968364; cv=none; b=BvpFc7C8uJiz3MMox5e7AqD7Ru5/r3glYTTkQOa/WoXe0/0VujWMtKazovNqo6xq7HZdubqkfMehhmW6F+f2Npd9HNVySeXcRCxhC5JlNOGCR82oODnGukbH6ZKKTNy132ob/g+PbQRKwKo23xuGC29SfVrI2QGGwdAATJGJYOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750968364; c=relaxed/simple;
	bh=zDfO2v8ZbtcP2RnCvD+2EHC8b8R/WWM29bYxaxnNoHY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MqfJw5ETtff50vxffWGQRql9/U7Y8FEwz4FZmGUiRv+RYdQQCm9BAsdb9fkUY+JQGjHks6QTFNJlEk3a5QLLp+pC9/IO5gToTktKfaCwSXA7jx/gnEbCS5oFO8CBneHLzyghoNwNbepji9YGZ2y0rOKQ31ZspMugP0AjutWOjZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=InZ3JnZF; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="InZ3JnZF"
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-86d0aa2dc99so136420739f.1
        for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 13:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750968358; x=1751573158; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mBWQmXlElKRqufKLx0IJBng3uEmJIOP/0SNzHgrfiOQ=;
        b=InZ3JnZF1kWrZ5FPWuOnqIdicacnGOW0kGGhXKCq6P73q5PbMEfazbwvZp70EtlT1R
         K0B/cRkKRtVpm5W/HAnKRgAcF8QEaWUzE5W201cdMcFcrgZEMBN73WMqBXqPiQqllbcr
         jC+UCWVH4EVqBR130CRThN0Wp7bo6Uw3nBzReLVSm6qn87E5hr5pg8udNROmGmMeQmDq
         9JIwAKlfT3JRhz1cNCRLG9UugEJdP9CfJFzZzwTH/8nylGOQFAXLIsAkKjj3R3lp02Ey
         a5Osk30on0wkzmczPuWRCO/aS6aD5m1MPjN159w8AsR+kphezQpOk574dbdLM/8igDBl
         FlMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750968358; x=1751573158;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mBWQmXlElKRqufKLx0IJBng3uEmJIOP/0SNzHgrfiOQ=;
        b=uEja8GRsF29EHw9j44uN9d1GfHWcwaVKHeAgucGBYp29xDK8vIjUn5Me251MlrRm2d
         rseSeQcNMrc63ZLPT00nEXU9JfBCK3mDeUULjLdsfBv3ioY5yyzdpGLpP7AB6qOKLEcu
         0AT2/SoG2OnT9IGj/eBgZUB+YQfwC9bqdhZ92FB9bVhJBbAHhWE55xmF9u+EKc6AuwP/
         hrfJNC0OVhcNieAljLSqGC5g4Klx/ZWIoa2aIJT97lbr1ak5d+y21bCglic7ADUR3AlG
         wZXMNBxN/jZ1RRV2piRActTews/HVByHn7ahonTANyrZ2w4lchWoiKHmNesSWEI8ikQx
         RdQA==
X-Forwarded-Encrypted: i=1; AJvYcCU8EP4VSQqt8eyH17rB9gjWhz2qNqPajjBYTSRgBFXEb5MgLD92XP1ioVC1tj0FJHF9JQqtfEk=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywhb/wtapag9jvTTDOfEGYVXcaRFqAMrB0JoM77nXXPMMKQrXrc
	utDv5CZYlEr4V1DgeHOLVWa/r9wuivEe0hpR4npMAwguh0NMreE4CTkVEyS8AUufQ35mhZpyTRG
	9rkgIB/kgTSrOxzHVh7GscqNvog==
X-Google-Smtp-Source: AGHT+IGgfwcSnINywDElIvOUq/qNOGZjEQuNJ0HSkOlhtmSxQvzs3JhS67z89W+d6j0EUhWxDQaGOM9wiefkiUhZhQ==
X-Received: from ilbea18.prod.google.com ([2002:a05:6e02:4512:b0:3dd:bec6:9d56])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:2683:b0:3df:385d:50a8 with SMTP id e9e14a558f8ab-3df4ab62001mr10858775ab.6.1750968358575;
 Thu, 26 Jun 2025 13:05:58 -0700 (PDT)
Date: Thu, 26 Jun 2025 20:04:43 +0000
In-Reply-To: <20250626200459.1153955-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250626200459.1153955-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626200459.1153955-8-coltonlewis@google.com>
Subject: [PATCH v3 07/22] perf: arm_pmuv3: Generalize counter bitmasks
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

The OVSR bitmasks are valid for enable and interrupt registers as well as
overflow registers. Generalize the names.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 drivers/perf/arm_pmuv3.c       |  4 ++--
 include/linux/perf/arm_pmuv3.h | 14 +++++++-------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 6358de6c9fab..3bc016afea34 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -513,7 +513,7 @@ static u64 armv8pmu_pmcr_n_read(void)
 
 static int armv8pmu_has_overflowed(u64 pmovsr)
 {
-	return !!(pmovsr & ARMV8_PMU_OVERFLOWED_MASK);
+	return !!(pmovsr & ARMV8_PMU_CNT_MASK_ALL);
 }
 
 static int armv8pmu_counter_has_overflowed(u64 pmnc, int idx)
@@ -749,7 +749,7 @@ static u64 armv8pmu_getreset_flags(void)
 	value = read_pmovsclr();
 
 	/* Write to clear flags */
-	value &= ARMV8_PMU_OVERFLOWED_MASK;
+	value &= ARMV8_PMU_CNT_MASK_ALL;
 	write_pmovsclr(value);
 
 	return value;
diff --git a/include/linux/perf/arm_pmuv3.h b/include/linux/perf/arm_pmuv3.h
index d698efba28a2..fd2a34b4a64d 100644
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
2.50.0.727.gbf7dc18ff4-goog

