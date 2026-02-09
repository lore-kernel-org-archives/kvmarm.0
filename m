Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF46319601
	for <kvmarm@lists.linux.dev>; Mon,  9 Feb 2026 22:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770676853; cv=none; b=rdtxniggVDlf9Wk/X9MKzbpka7E+L+CYaVKxN6gD9J/bCmGBXgE5D1ph5z2nCtHonC5ymBTdpKTOPTOwWu8AUXKt6YiVoLcaQBHobuA1AzgNw0jETlJVgBUo25HTxGYUt9ZqfihMBalgeyVAvcnBQmNIyzGCrUEj1eGUtZHeWB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770676853; c=relaxed/simple;
	bh=dXTvn4qocYHpwQDXijQpcg4yhTZjehQMfz5QbgqWF8w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IIn7pJdzLWbuva4fer99qktcQPdO9jKV4+YLilINm9SwGpOJqSZd7yRpTyjNIa+75E3f8aG1n7WlTsJawm8DYje7Ok4vMNcx3ji/ofow/Z+T1DJPedCN4e2grTpz0SUmv4KGcKEfTcObShHBpAk4B8AGGSR04Yzx53d5Q+xMSCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1dM300nO; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1dM300nO"
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-7d185984792so1110071a34.1
        for <kvmarm@lists.linux.dev>; Mon, 09 Feb 2026 14:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770676849; x=1771281649; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=imeQaLzXrnVqs2xwe1B4fumETENHcf/y9Tb2xZBjKCc=;
        b=1dM300nOZIIV7+GjGcGBknZjxxE627qUqKt5xXks7nnGUDYSfJ+7e+bKXO5L1hF/AN
         hLDNn7IXv0bI+qCuXkVQPmyjUqTQeYl4V1fDG2Br62fvnWA7KOf3Z+C45VgePzS94Pqg
         QyVQ8qU8th9G2MC/KEh18tPLOcUw5e+sExigV0F+jr8FXucVG/T5QGB43CadwVfojBC0
         7MV2jfvMOKxtMT417JRFQt+G0zSh6fKfa4I5oVAi2B2XmD1jMRk0WkkLVrBAZGGCWW8a
         B9T5uZ1UxEy44Z0uGMh51rcNPD42qWjYhaw2snzG7DxJFNzatVYn0MdYgjYbJe0xNmTd
         ojPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770676849; x=1771281649;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=imeQaLzXrnVqs2xwe1B4fumETENHcf/y9Tb2xZBjKCc=;
        b=N/FcR1b4UilrkbACuNr2TYUgfcwFp3mK+pTZNNPBaTolLmh86quewTf5M9+K6gn8N3
         GqiUi1iOVYgH+xViA/0NGwwiBdUSEWgW+1uPzZwRf3EipIossbhvZTyR1pmf4KUjELXv
         geL7OcSzJHlHLWJY6aWXtyo5+5cX19ydhaOrS22xvF6bJ/JSjIYJQ+MOvtBV6VbOr58+
         ONdCXO8ZI1YNS5fvXMKSxNqxwD6xosgpiRY0j4dt8mPFUb9NjzxFUFVVC1WQKT9tmMHJ
         lhuQlgDe3dWJyXxQ2Y2CXma1sSqU6egi7dtxbJ6rigNGXdIGcSrOilPWXH2HmybsgfT2
         f5DQ==
X-Forwarded-Encrypted: i=1; AJvYcCX/Z2IFCSXQOMkeBIZqPw4fmRAIsiEsjBmJUK62R0ieVdhYChT4bS3nFloX492UneC1hQ+7+yI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyZG5McGra6eNjI+7vFhlVRls1ugvdiRXFfj/QBq1KvYuwogAit
	+560xNCBeWaLAzkc3pyMGqvlDx3vmshd8T7F15ziTQDk1iYOJJQOWBYqRiFY7qAX5XM+5JxCQRV
	vKuJT2HNF85am9TeuFAisxf/feQ==
X-Received: from jabfq6.prod.google.com ([2002:a05:6638:6506:b0:5ce:3e9c:22c9])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:3088:b0:662:f61e:759d with SMTP id 006d021491bc7-66d0c666b89mr6055036eaf.62.1770676849224;
 Mon, 09 Feb 2026 14:40:49 -0800 (PST)
Date: Mon,  9 Feb 2026 22:14:00 +0000
In-Reply-To: <20260209221414.2169465-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260209221414.2169465-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260209221414.2169465-6-coltonlewis@google.com>
Subject: [PATCH v6 05/19] perf: arm_pmuv3: Generalize counter bitmasks
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Mingwei Zhang <mizhang@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
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
index 798c93678e97c..b37908fad3249 100644
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
2.53.0.rc2.204.g2597b5adb4-goog

