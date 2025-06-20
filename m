Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A436248888
	for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 22:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750457928; cv=none; b=D8dU1w7pAAyEYDsW1ca80zNlPZ5R1VXJ2Hfy+eqIELM7aIswOz3j/2r21CX7m963LeIsHUizJYnmhkZhBrE92lO4wfO3O4ZCEYnKw0WPGEpmJH9ufZmMd4DPxdVgFGbQGgRHjx/vddIoKIVefKeOJxo5WXYzOr4trEjF+NqEaAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750457928; c=relaxed/simple;
	bh=V5QuFFtEFS1le6XC0EQ62amHSr4v2C/GQj21LgKvsUg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=b/TYcc0dta2BGdE/H+jwcml12gNiqe7uxvS8R34eQCPoMBQ1ynEsWScs1li93kZ2bu1ROvdYJ9xgNOt0tuW+K2nZmIXJM1e8Xx8wFvfn96dkaZOjTnL7R2wy8LWQO+tHnML2LpAUyxrGw8rZu1+npFhMW7hTBXSTCl2nUNSZsTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gxqZFyBu; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gxqZFyBu"
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-3de0dc57859so22297375ab.2
        for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 15:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750457925; x=1751062725; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W8bfLeP3qqrBDCFJ2FU2DOZ6I9ab7gAt7xxGlDeoSjE=;
        b=gxqZFyBuIij4beu4veJwyZoPEbO0i7yr7imaVRgQCMZ26Mm9j0B8qNsfMSogS+fim/
         CFRJ+bEkmu5bL46BIZAHzLoYJFWcJLyLDIDi4JHY1hcqbX3jIfAjCzX5WOebt6l1ojKS
         oXHV50V0K9xsaFTZG4WBnW8HFx2VA9cEKT3gvJdAItM8RffAWpSGkwhyqmrZUJf9v0Ln
         lcBBxYZFmmsMr3SRgmVznXKS7a1OGjArzmTC/cOD37ocZ/ItgjB4/AvpxjR56RcqPVZk
         7+aBSIn7jmO1+L8CLrf0wzUcBr3J/vjkWUjoB03JLSaKxzoIC8mY56vaXZpAAOyBFpyj
         hSvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750457925; x=1751062725;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W8bfLeP3qqrBDCFJ2FU2DOZ6I9ab7gAt7xxGlDeoSjE=;
        b=po3hJuXj7L3c1UV4uXLN0TC1pPDxabKI17soFl8yAVENdgik/YISL+LZsODH1iHnGt
         hzDNmcFgCkLdLcdahQC1EuETaFydDFHDwSgGlNOe3Lr+ZMt1f6y41o2iA9BRNwQ70xX7
         HEWNrQAOvJpR/qYitpRfUCDDVlBUhQFZhYkGPHbr9pvH5S8XMl7Yg2hcmRk5KVf+erTS
         v1z+kjXr7t2/bo/6decKgwTk4uDZbT5qsgvb31OYuW0XL2D7BLCDFbtGv39AJd/sjcwk
         ubQYW3qOjCqgU0VbcCIARCBvjOfq/g4kUsUxLnyRdlrv2DfSV/RLf0hqFiXE09wxGPGl
         QtLA==
X-Forwarded-Encrypted: i=1; AJvYcCWcR1VDyieGgfEXK4pz9Sf0HKxrTPxeuO3+GfiFG8HLjl6hi7PQR84Q6dzUR1osgpC0T4HquWc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/Be8XeFcv2PPLumjdedo7IFQxBQj2zEZegb1h5vZocaA5zmHw
	Izu6AERDGiDWh8rgGrxZmS55yGZBkGfaaInIEhzMR7x0JEBz6AXvRZ+F0Lv8h5YbiFvyo/tppwu
	5vUorX/lnl4JtiJnbFyHT2mhQig==
X-Google-Smtp-Source: AGHT+IFNu9JHRQIB7XTy2Ob9SNBqkVdGcONXmzfrAwfGHzD/c/g9AEFFIMXAac8kpjhLkSQL3RhwV1XbrB993VdGhQ==
X-Received: from ilbeb7.prod.google.com ([2002:a05:6e02:4607:b0:3dd:f56e:32fc])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1b07:b0:3dd:f745:1c1a with SMTP id e9e14a558f8ab-3de38c1572dmr55614125ab.4.1750457925391;
 Fri, 20 Jun 2025 15:18:45 -0700 (PDT)
Date: Fri, 20 Jun 2025 22:13:09 +0000
In-Reply-To: <20250620221326.1261128-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250620221326.1261128-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Message-ID: <20250620221326.1261128-10-coltonlewis@google.com>
Subject: [PATCH v2 08/23] perf: arm_pmuv3: Generalize counter bitmasks
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
index 26230cd4175c..e47f5953928a 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -518,7 +518,7 @@ static u64 armv8pmu_pmcr_n_read(void)
 
 static int armv8pmu_has_overflowed(u64 pmovsr)
 {
-	return !!(pmovsr & ARMV8_PMU_OVERFLOWED_MASK);
+	return !!(pmovsr & ARMV8_PMU_CNT_MASK_ALL);
 }
 
 static int armv8pmu_counter_has_overflowed(u64 pmnc, int idx)
@@ -754,7 +754,7 @@ static u64 armv8pmu_getreset_flags(void)
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
2.50.0.714.g196bf9f422-goog

