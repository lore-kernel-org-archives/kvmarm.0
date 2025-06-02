Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4E622D795
	for <kvmarm@lists.linux.dev>; Mon,  2 Jun 2025 19:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748892548; cv=none; b=RnsiQ5fTDH4g0eKVP+UTnss8v6khA1K3Vj4aMwbPskeMSfW0UNX5n4fQc6S8gZ5D0a5VyhwsL8KY3LiMk1cHU9RARvPlVdsMMhZqOxqI7+CPJgDnqRkMmCRkpZ+MnRs9Z3xW9t1/lWPqPUo4kUNeBtCZ4q1s8TK1Sq3Oe8YsBWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748892548; c=relaxed/simple;
	bh=zCxK3dISxEfOML4T7vSp5Om1/JdipoyUx0Yzj/yzWcY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kzWrVMSbr/03bybZBlpwYEJNAYHwJC+MoRISduHSvgSGROzgPXTcOZ/M5h2KqHnmWo2Ta8DXeDZwHZHhRbP/s75cAjUcm5TKY6YC+5pFqC6BBSL08g5bldeTMPKVEIZvnsz7MUhNqs2F4yZiCggb5CXp1nG/qGc9w9tU1l+3xns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CoYn54k2; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CoYn54k2"
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3dc7f233258so55962155ab.3
        for <kvmarm@lists.linux.dev>; Mon, 02 Jun 2025 12:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748892544; x=1749497344; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JYJABjVP2iDArJLMl5gj3ep5scI8fjcxHEMsai9rZ0Q=;
        b=CoYn54k2XLSstOe+YmBNBHAxQpf44HAKJx6zY8sxx6joI1RcGEU2eGeDtYBYsbOmTG
         mjHgDUrPOQSxrNv+8vX/T0BHxDpZQre2lFACxgtw8HOnTam6aW4CaEzuObPy10Of9B/z
         38VdPndr0T6+QtaOQM1FrI5613nhWFcFOSLbaE8MRTFGC+nGWWqRJGkwjWvVa+7+qGZR
         UI1+kY1d9xWhbRBA7SHC8ATQITSv2SK9gLCPQn83TsFZaxBvRWV+c2D+1kb6ERq3xSXW
         cyqHe6tLWXetTXYvtIq2VI4UjyL1f3uclfxDHIq3TUftnZtHDzIwpQHH4Rxv03Nx1UgZ
         sJGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748892544; x=1749497344;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JYJABjVP2iDArJLMl5gj3ep5scI8fjcxHEMsai9rZ0Q=;
        b=sAiuqUcty43CUw9NKWVrQbqRFQN1IFUrzgc+10BjI0ISeYoPlElk9pOyGNp3RANWik
         kLRXtO7MbRtK3ksU3ItfrSYdcZ6ly3pi4p4oEfD7PDCRowvZwE+0EooX1s8nNuf/P7vZ
         a904uKMnjF0Gs+kRujLD7ApLiix5h780VAH6YfrH5kUkwaY04cOIgyoj2wpubpv/MgMR
         ZviBreztZDT7A/T/hPFyh62pprE0zLcbkvt/z8gtbuCNSBVVL+QJRJJNo8OYJ72iq2Ql
         6VrLQ4QZSFmO+o4m9tWzCPC9qkAg8FilZPsOzu6QJSTYQDYH4C3uGBmVmJlpXrsLlZQD
         qV6g==
X-Forwarded-Encrypted: i=1; AJvYcCW5MMj18xa6xAGCjyNq7wztqVJThKffvFtNkF9W/F45aGoy7Xl7vdk96eW4dhYyDxXWtyKdl+Y=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx36QkRLuHHiUnCTPT2cisVCaJGkbHk2Bdm9hqkLDIwyEovBznV
	WWJIjkE8uUwmlDsIJ0cfHeWb8oC4xUPs90LbuYPYnluSODMCC1Y7Lbj7SDFUr4boj/EZexjuP1s
	nTfzNpHukJ8OSYhj7ga8vbcmTfw==
X-Google-Smtp-Source: AGHT+IGg2rWIw4S1SBhgIdtyOl3kiwsQOgXvBToZBQsbPlELmXsPKjt1+hk3s/Rllj0rwiuIByf4uJq1ToD1VufkVQ==
X-Received: from ilbbf17.prod.google.com ([2002:a05:6e02:3091:b0:3dc:a282:283e])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:b46:b0:3dd:89c4:bc66 with SMTP id e9e14a558f8ab-3dda3342b61mr86473295ab.9.1748892544754;
 Mon, 02 Jun 2025 12:29:04 -0700 (PDT)
Date: Mon,  2 Jun 2025 19:26:52 +0000
In-Reply-To: <20250602192702.2125115-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250602192702.2125115-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250602192702.2125115-8-coltonlewis@google.com>
Subject: [PATCH 07/17] perf: arm_pmuv3: Generalize counter bitmasks
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

The OVSR bitmasks are valid for enable and interrupt registers as well as
overflow registers. Generalize the names.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 drivers/perf/arm_pmuv3.c       |  4 ++--
 include/linux/perf/arm_pmuv3.h | 14 +++++++-------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index e506d59654e7..bbcbc8e0c62a 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -502,7 +502,7 @@ static void armv8pmu_pmcr_write(u64 val)
 
 static int armv8pmu_has_overflowed(u64 pmovsr)
 {
-	return !!(pmovsr & ARMV8_PMU_OVERFLOWED_MASK);
+	return !!(pmovsr & ARMV8_PMU_CNT_MASK_ALL);
 }
 
 static int armv8pmu_counter_has_overflowed(u64 pmnc, int idx)
@@ -738,7 +738,7 @@ static u64 armv8pmu_getreset_flags(void)
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
2.49.0.1204.g71687c7c1d-goog

