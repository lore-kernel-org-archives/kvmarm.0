Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722D4261580
	for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 18:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739469925; cv=none; b=QH318v3rz3qCUli9pwrvGoSKW7OzGpQVzT8yMHhoKXUTuQ21z4O1FRnRulbqQvXJPA6CmtQytd5dZ9HnRIczE05GNH2pYid/wPlgKqUnZ0OreA+qT5C5lKptM5Qw7Ebua67ZRyv88l5q+h5GOld8YtY4v4M1Mj+LQ6SiNHznvuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739469925; c=relaxed/simple;
	bh=IPomACu1+8aSUcgHjl+TvhZac7fz1cEIHmspucDQtRM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XKotQQJVMKNcJsrFfNo1U+FHpdTGcPo0f3lvk7GXoHFYS20I+ku6gI34mMBa2A4tqLcYKFBWPbyX9VnhKtW/sjIWPqHuPDr9Vv+qTjC94zGV9qXMDZLHG3o/HI+yJFqHUYzlwk3YTKshWSqJpnDHm1HOjbjwTt6fHA7f0ICQA9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2GQW6tgf; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2GQW6tgf"
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-5fca748d201so806604eaf.3
        for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 10:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739469921; x=1740074721; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bbnJYyoVJc3D9vRYHg6DaJudE2uBzpyQ/LXCAOcJbR0=;
        b=2GQW6tgfsokWb+7kpfmpzPgebVsj835sxl98H0AgFS1ZZTeJGKTsFBRr8pps87XIgZ
         f0VJZj3mpNOSLO9OezFbcQXeBEjpeHkFqyG4wfUFag62XqQpmy5WuEE6twW2zSJlb4DX
         /4MGmjWWJ9oNCt9VXBMCUWm27fRz4pHi4jt4KfWJtiSgVU96jgeHxmzNUMuwZ71RAkeG
         MWToJjkyV3TyoYJ+M/7LEMbcMehVmZkCFFIZTdR2bVc/fbamYhb/Z/o4q65x8t2SGKU7
         IRW2dYDL8p7laQbqats8R69YAv31+HuFvM8N668I+WvzjLRrSOC2lceR6YMj0SA34Qra
         9hsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739469921; x=1740074721;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bbnJYyoVJc3D9vRYHg6DaJudE2uBzpyQ/LXCAOcJbR0=;
        b=TDJJ8iYcT4IVci9ZBomvaFSdmjN5ui8vbLeWfCjU5AQzHms2NG6++pRXzMFBgEwmTl
         1wbWSa4Wvn3Kq/umcLBkqHXkhC8lq0XYUdwFEim0fSfwSNWVw/sEZaPLS2IlM/Bxu+GY
         u43X0G1g5Ne31jPjosSp/W4A3o8409zbhOl5sQghqrSAls7HaWW4pdsrXAEQ/2iDzhzt
         FSdMNxR8BesWErcCRmKYu5d2OrrXzlvhpPtBNg88ifUzriMwJWFAieNdFzka8NsNePiN
         oCDGHm94dJAQ0mbrv8nVyFfKuGy8KrdZYQG4WlPVOByDzGg/f1Mda/6tA47V0xI9eX2T
         Da0w==
X-Forwarded-Encrypted: i=1; AJvYcCWhefw//lx0ZX6mRDc7VXu8YNSTSahBPYkuJgBY7uTyb1bqrt36GN9CYw4PmmFsOjicsvfhLV0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyzwPHxt04O4Mf0KMTWuF+TBUJQZ2Z9hKUdN+Q2YFxKiJOcvAkZ
	IDng2KWe5OHAY0liHKklmJrnLMGBHPyW35vhhOEobXY7CRO7izwf+sVHWJmj4EUJBcwXkLP3GLk
	e8u77mQXj8NRDVSGW0dByEA==
X-Google-Smtp-Source: AGHT+IF2I7xGWAZbPu73m/0jZgOAhV4gawbbUKrOiVZZ7yZX4HGebgHLSfWQvDaf3SHQjpSi0BuBMnr+ogGJwijyPA==
X-Received: from oiww6.prod.google.com ([2002:a05:6808:4d06:b0:3f3:ca1b:13d8])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:3c88:b0:3f3:ca45:4315 with SMTP id 5614622812f47-3f3d8dcbdabmr2920400b6e.9.1739469921296;
 Thu, 13 Feb 2025 10:05:21 -0800 (PST)
Date: Thu, 13 Feb 2025 18:03:15 +0000
In-Reply-To: <20250213180317.3205285-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250213180317.3205285-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250213180317.3205285-7-coltonlewis@google.com>
Subject: [RFC PATCH v3 6/8] perf: arm_pmuv3: Generalize counter bitmasks
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

These bitmasks are valid for enable and interrupt registers as well as
overflow registers. Generalize the names.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 include/linux/perf/arm_pmuv3.h | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/linux/perf/arm_pmuv3.h b/include/linux/perf/arm_pmuv3.h
index d698efba28a2..c2448477c37f 100644
--- a/include/linux/perf/arm_pmuv3.h
+++ b/include/linux/perf/arm_pmuv3.h
@@ -223,16 +223,23 @@
 				 ARMV8_PMU_PMCR_X | ARMV8_PMU_PMCR_DP | \
 				 ARMV8_PMU_PMCR_LC | ARMV8_PMU_PMCR_LP)
 
+/*
+ * Counter bitmask layouts for overflow, enable, and interrupts
+ */
+#define ARMV8_PMU_CNT_MASK_P		GENMASK(30, 0)
+#define ARMV8_PMU_CNT_MASK_C		BIT(31)
+#define ARMV8_PMU_CNT_MASK_F		BIT_ULL(32) /* arm64 only */
+#define ARMV8_PMU_CNT_MASK_ALL		(ARMV8_PMU_CNT_MASK_P | \
+					 ARMV8_PMU_CNT_MASK_C | \
+					 ARMV8_PMU_CNT_MASK_F)
 /*
  * PMOVSR: counters overflow flag status reg
  */
-#define ARMV8_PMU_OVSR_P		GENMASK(30, 0)
-#define ARMV8_PMU_OVSR_C		BIT(31)
-#define ARMV8_PMU_OVSR_F		BIT_ULL(32) /* arm64 only */
+#define ARMV8_PMU_OVSR_P		ARMV8_PMU_CNT_MASK_P
+#define ARMV8_PMU_OVSR_C		ARMV8_PMU_CNT_MASK_C
+#define ARMV8_PMU_OVSR_F		ARMV8_PMU_CNT_MASK_F
 /* Mask for writable bits is both P and C fields */
-#define ARMV8_PMU_OVERFLOWED_MASK	(ARMV8_PMU_OVSR_P | ARMV8_PMU_OVSR_C | \
-					ARMV8_PMU_OVSR_F)
-
+#define ARMV8_PMU_OVERFLOWED_MASK	ARMV8_PMU_CNT_MASK_ALL
 /*
  * PMXEVTYPER: Event selection reg
  */
-- 
2.48.1.601.g30ceb7b040-goog

