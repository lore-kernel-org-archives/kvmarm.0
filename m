Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com [209.85.167.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671E5346A0A
	for <kvmarm@lists.linux.dev>; Mon,  4 May 2026 21:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777929519; cv=none; b=gockkfujE3TkaCZmBMj8J7V+ZSvbxQZ0fMLqemkJfo758ONZcmyVo2AwRZbuRoQK3Q6JYP/8WOkLoC7qfwCcdQNlc6gwB2kGhuyteRqPmsJ6+J5plSjHy17cKax7Vqf1Iks0HkzCexiL3na1wxkF7VaCbCeje0T+8HDEAJdTwyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777929519; c=relaxed/simple;
	bh=ueTqc2Ph7z17HXoEzMvMnAeIJNA23UDUjdS2CztRW2k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I6utDiX3SZdiWMwf5Y2N7aNI1PWghVMp/ldaRHF9NkJfdpDhiodFD22yANsWMBZUde36Q4SIXzZXdNQpueSgzxPWNp5+aGOvvAM2eYRQJakoAsF5oRQprCOyDoX0yEr3G3B6yKGAtW2m2GsCnjBLwtKXccCMyjVOBtMQ9AzWsxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MtIg0gX/; arc=none smtp.client-ip=209.85.167.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MtIg0gX/"
Received: by mail-oi1-f201.google.com with SMTP id 5614622812f47-47bd318565dso6711439b6e.1
        for <kvmarm@lists.linux.dev>; Mon, 04 May 2026 14:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777929513; x=1778534313; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=thCWuABQmlCLQCDjA65mDdmemz/sfk/Mfmpa4HEmTAo=;
        b=MtIg0gX/U/GzE76vsPTWttRf6ia/4ue0oeugFdhF9gm+u3tzexaCeXqg0RnkJyBS2B
         YEt1hMf4o33xlQIdRHSLHQ3NSaeA5IOowiAms97CWZg6358KhVvic8XWfpuaz90lMU+Y
         BQ/MIZ53BhfZG6gAE2RLhUESNZ5wPr4WglL/sUHFDNc4aR8Mghs4XkpkVOhxZGoRSZdi
         vbxn0YpaeZQxR3DY4QvjNymcLHWPR0bm6XGmi/+hLyOduFBdu8ClsQNXdb7nrMdWgt4I
         Dx5uz7shJNHxljyYz0T9V3rtPFUef56D7Vxjs3ioqtylrgX4xIaBXuE7YxKaIvWfu2M9
         w6Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777929513; x=1778534313;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=thCWuABQmlCLQCDjA65mDdmemz/sfk/Mfmpa4HEmTAo=;
        b=XxX9SWWkh3JVBgQeaAyZkQGGCmgtcbka85MtD/tlpca+lVFOP9xyBa7a+Z6wZDa+oj
         LoKHE9VFGyh4RK11iohiYhLQz2K8GZQOX/7iUnJ9BeyP2sKPm6Q8R3OrdSX9lH6v4CzL
         YjBJPme8yZBQY6JZMUb/osQaD2ELvaUSR8Qm5h8iAMRc0NsEQr2rQfiOpDBNJUWEcf26
         aP7u4+alMxNwK+f4ZZJJyR9pPDIpRWohoy6XX/ZYpSs6XlHmrKSGLZtYC54NDAr8uZwU
         5QwYpAapvUpOFwu08BJA5I6mmeC+F+7LgYXkscefKTRrt4bdSvVL4Kkxd8KJGsKVWUjf
         u9Ug==
X-Forwarded-Encrypted: i=1; AFNElJ90CVkgqdjWN+UkatUkL46/SlKJRd606/q+/sp1WpPKkuChBCx8FgGYd51YymEs80o44YmjD0I=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxbhs5AMBwWUGQFX6d3fdk484kzLFe6Uw4mW/IJnCQlnOkPgMQD
	Q9Zk6L1BZJgtEaluCQ+sAXqFJUzZcSkKLxxvso4UHTCsRRVp2rpS1QwfXyfC/nCvyHaIpZSIlq1
	mACPArnCgJuFmItc/mUyp1ssriw==
X-Received: from ilst10.prod.google.com ([2002:a05:6e02:60a:b0:4fc:39c6:a601])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:f08:b0:696:32ad:e894 with SMTP id 006d021491bc7-696979ec5c7mr5763143eaf.23.1777929512987;
 Mon, 04 May 2026 14:18:32 -0700 (PDT)
Date: Mon,  4 May 2026 21:17:57 +0000
In-Reply-To: <20260504211813.1804997-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260504211813.1804997-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260504211813.1804997-5-coltonlewis@google.com>
Subject: [PATCH v7 04/20] perf: arm_pmuv3: Generalize counter bitmasks
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Mingwei Zhang <mizhang@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	James Clark <james.clark@linaro.org>, linux-doc@vger.kernel.org, 
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
index 8d3b832cd633a..1cceb1f614515 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -534,7 +534,7 @@ static void armv8pmu_pmcr_write(u64 val)
 
 static int armv8pmu_has_overflowed(u64 pmovsr)
 {
-	return !!(pmovsr & ARMV8_PMU_OVERFLOWED_MASK);
+	return !!(pmovsr & ARMV8_PMU_CNT_MASK_ALL);
 }
 
 static int armv8pmu_counter_has_overflowed(u64 pmnc, int idx)
@@ -770,7 +770,7 @@ static u64 armv8pmu_getreset_flags(void)
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
2.54.0.545.g6539524ca2-goog

