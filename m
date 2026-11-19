Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795114343;
	b=trm5FlcN5f3g7r1Y+Ebo85lJMsVgq4g65FhupmLdVQGbkiMvWbUc3zQxXb4KSMTk41ri
	 4WhwawNYJIqNO2aSW31jyYxgUiotVrkXh/rID1FpeSyR7GXtatJIlV1PDRINPm2sv5t3D
	 rZTHjObRvQdOr6BLFd+HlHSPQU9GAOQ9gq8eUBA4xrwRuRvxEFckYwz3IpULe0muQ/Cgt
	 geS6SL+RnOv1PqAv748TO4LPVXfdreDGFnLssYzh9ndTxjRfesyTYeHmWlkCqn8Zsy83I
	 mNMgtyoKwmnWe0fSpnhPforf9QS0t4jeHPvFT1EyWOyglLyK8+k9FSNexnagzMu2cWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795114343;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=B71Ljk+UIM1gXp9I8DKkVnuHdcZAuyllvZTiO1ZgbS8=;
	b=zd6e4QzHZYjhgNZdmlfcWKOBUpmF3jNXPvImF3olloRjm/48wJynl5IEinLsAItlUYVm
	 3ppQZjku3NETHr0m0psNGT8rXIs+ZIrW0Bpta/9uSPo4AVyflB0+UTl8wLVIeiqr+vEOP
	 MywV+yB/CqfVHsUMkJUr7Zk27jQ9gXr5+OIkzdkwTbA3OpjnGitIr6s07Hxt7ULZFHsTE
	 0RcCSJbTRNXwHCde/as3+mQyGFU43j0ilAwzXNy2FNo6RAyQ5J+lj4Zl5vqVwYNqPggTz
	 8T3ONqdDIiJpUZT+M4JDL8VoDHOnm1UDAbwE7x2z+lAKxfoCg2Z5MAtJIJGywMVQlRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BKv0UzBF;
	arc=none smtp.remote-ip=209.85.210.70
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5B660A5BC7
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 18:52:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF5B660A5BC7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BKv0UzBF
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-86313f7f4faso128923a34.1
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 10:52:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795114342; x=1795719142; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B71Ljk+UIM1gXp9I8DKkVnuHdcZAuyllvZTiO1ZgbS8=;
        b=BKv0UzBFatEmAJ4KUxt0cf+rIQTb5Zbg7gvEF3VDZwAPJOF85qMotjuVy8U1+oD1NY
         nFoDFHcc2eKqyDpTa3q547lXMFINwtU7g1ax81ySe6+nyiHt+btG8i+7jQNSkaEflCTW
         GVV5ZzPoWwuCUUlXRAd1VURY2odJSm9xFMu2gV+aFFJUdXGI1f+chSonjZSkwUsrcylc
         eCF25MK3EcSa7QKLeHc/T35pVMv5yxpXRxfz4Ulnq0im8mU8ZspIeRyOMNySJ5nyLwEU
         uPymf6y0ODrmAyieFC0jHknuXTrlKTERL7PSPOGxX/HTPZFoVQqW1bHqbevLScEcSDAD
         hafQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795114342; x=1795719142;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B71Ljk+UIM1gXp9I8DKkVnuHdcZAuyllvZTiO1ZgbS8=;
        b=mM76kysP3RfRs2Goi7HwTFCVG/u8xeoW2srV9FOY13KV3MkbticNA3G6Az4EfaBhbZ
         e3568h0ztczrr1FISHKlLmu0yzHdEqHhT3iarHT465wCDjm65kUv8m+nT6ELWBP9X3Rp
         x9kpsWKbv1YEM6ML96W7iriVQVgNoP2mfHrvSnqoOyjU6TmiiFUbBbRuNOHcOiZT25mM
         rTp8HvP9ZDLGz4EngGlJcqRYp8X2OvezvhQW+ijnBf1OiDZWlqdgrPFKwq06w1VEibxG
         eO3vpvQXE5jKQmQMgakGuz9mz82fCeSRBR5bB7/R/M9Kb8KTi7FyWzhTq6dREX8wAVb5
         Wxag==
X-Forwarded-Encrypted: i=1; AL+hErGM3eIrvxV4k3sc0lmRleIGchIsSHOYaX45cXb9TRPbAelfO0hRswEGgjwNFlGj9ViZwUUx7Qg=@lists.linux.dev
X-Gm-Message-State: APuU4Z89TzGS7aCjCkk64Y38ThaFhCbHV5hIdSsaRfkYUG4vyzhJO6r4
	1r4MiRStyf6fr/RSFCdfzPQbgAn5HRA16eJs/IB13OWqb/rKZ7UliIr83Nob+VPoIRm7SJQ0M/a
	B1NavqH7gzH/W1hwUWBbc7bqhew==
X-Received: from ilpp13.prod.google.com ([2002:a92:d28d:0:b0:53b:ef4a:649b])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1b87:b0:576:217a:6740 with SMTP id 5614622812f47-57a0a60d756mr914272b6e.22.1795114341585;
 Thu, 19 Nov 2026 10:52:21 -0800 (PST)
Date: Thu, 19 Nov 2026 18:51:48 +0000
In-Reply-To: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261119185215.632334-7-coltonlewis@google.com>
Subject: [PATCH v10 06/33] perf: arm_pmuv3: Generalize counter bitmasks
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Russell King <linux@armlinux.org.uk>, Jonathan Corbet <corbet@lwn.net>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, James Clark <james.clark@linaro.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Mingwei Zhang <mizhang@google.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The OVSR bitmasks are valid for enable and interrupt registers as well as
overflow registers. Generalize the names.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 drivers/perf/arm_pmuv3.c       |  4 ++--
 include/linux/perf/arm_pmuv3.h | 14 +++++++-------
 tools/include/perf/arm_pmuv3.h | 12 +++++++-----
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index fbd631ec71a65..4a6c1f3bcea1f 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -535,7 +535,7 @@ static void armv8pmu_pmcr_write(u64 val)
 
 static int armv8pmu_has_overflowed(u64 pmovsr)
 {
-	return !!(pmovsr & ARMV8_PMU_OVERFLOWED_MASK);
+	return !!(pmovsr & ARMV8_PMU_CNT_MASK_ALL);
 }
 
 static int armv8pmu_counter_has_overflowed(u64 pmnc, int idx)
@@ -771,7 +771,7 @@ static u64 armv8pmu_getreset_flags(void)
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
diff --git a/tools/include/perf/arm_pmuv3.h b/tools/include/perf/arm_pmuv3.h
index 1e397d55384ed..d045b0f3b93fe 100644
--- a/tools/include/perf/arm_pmuv3.h
+++ b/tools/include/perf/arm_pmuv3.h
@@ -226,12 +226,14 @@
 				 ARMV8_PMU_PMCR_LC | ARMV8_PMU_PMCR_LP)
 
 /*
- * PMOVSR: counters overflow flag status reg
+ * Counter bitmask layouts for overflow, enable, and interrupts
  */
-#define ARMV8_PMU_OVSR_P		GENMASK(30, 0)
-#define ARMV8_PMU_OVSR_C		BIT(31)
-/* Mask for writable bits is both P and C fields */
-#define ARMV8_PMU_OVERFLOWED_MASK	(ARMV8_PMU_OVSR_P | ARMV8_PMU_OVSR_C)
+#define ARMV8_PMU_CNT_MASK_P		GENMASK(30, 0)
+#define ARMV8_PMU_CNT_MASK_C		BIT(31)
+#define ARMV8_PMU_CNT_MASK_F		BIT_ULL(32) /* arm64 only */
+#define ARMV8_PMU_CNT_MASK_ALL		(ARMV8_PMU_CNT_MASK_P | \
+					 ARMV8_PMU_CNT_MASK_C | \
+					 ARMV8_PMU_CNT_MASK_F)
 
 /*
  * PMXEVTYPER: Event selection reg
-- 
2.56.1.708.g77570a6a1d-goog

