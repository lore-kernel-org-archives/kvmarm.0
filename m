Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8629715B0
	for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 01:07:29 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-507aac99fdfso179602747b3.11
        for <kvmarm@lists.linux.dev>; Tue, 14 Feb 2023 17:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I+uK5I847Ub+3lN0aBU7Gcssw6jbSaFlZxnmEwJsF78=;
        b=kEGDGgMAIhF4WS+uWDkyobWv0l+l/abqGQR5J9Ib3vG7/2CW2w00Im9EQC8yt+LmU5
         aBpYEjxKJO5KwUDKL6A+OgHwEdEfdGVlunFgEJ0ktKo0TEkEicL42N/2+6h4LBlqiFlV
         EVPXRfisozsa8/Ak2bQrEuHlDM4KrVy0LUz8NkvwjSwTjDdpxh7Qo5hPw6EFMdFhqqbd
         XNV3Cb7Fm9kGvxLo7Oz0cCu0/JHFejb9zWSDrDz/f0SykUMsKeTkHWF2G77h+yxGfMlP
         1WnpYGTKTmzFCIS7p1IDYnFsG7BN9QAT6YbQ6AfRVEWAaYUAJu4jESt67UodFPKa0cyy
         /ItQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I+uK5I847Ub+3lN0aBU7Gcssw6jbSaFlZxnmEwJsF78=;
        b=z2mISCdH8/8kkt69Q3SbjeJVYZIEWShIDj+bLlRVtuSRXGkwc5detEr2iXd+nClby+
         RZYLb12gNTs1uey5OCKYTrWC5zR5i/Oey1vz2oiL0VrPYn/cx4miuu8CLNIdwoCf/leA
         EZ3XVQEK7fioTDZ7qfUGQFL0qmFriELMrmp5nNPrQWHZ5UivhgkfQJ2cFe1bcKbTCUNI
         qWT6MZn6GqGwCyqgpVZDxaVGK6X/wbDvGCO+fXLN5SxcBYka87LXOmqm/VN9fg9U455Z
         qAfVGqtbjjOJ9gBoyIdviB8BpcJT6yuYkAuUKuSHjW892SjOYa0RdKcbOEJjcN7NRAPV
         MKRg==
X-Gm-Message-State: AO0yUKUpF9ujJTLFdu12aCoQmpdYnbnc6E0LjBgOr9U9gGC8rHFfFPJU
	RGJk2SNVwZe5HyunkPIf93UCPIfimybT
X-Google-Smtp-Source: AK7set91iu1Pp41RZ1Xv7Dro5d0bpbq1rHsaKAxqEIG8x/vMkAhgvV2qniDnuybFL/IYT9ABfXBZ9sg+uh1R
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a5b:c2:0:b0:855:fdcb:446d with SMTP id
 d2-20020a5b00c2000000b00855fdcb446dmr3ybp.6.1676423248137; Tue, 14 Feb 2023
 17:07:28 -0800 (PST)
Date: Wed, 15 Feb 2023 01:07:07 +0000
In-Reply-To: <20230215010717.3612794-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215010717.3612794-7-rananta@google.com>
Subject: [REPOST PATCH 06/16] tools: arm64: perf_event: Define Cycle counter
 enable/overflow bits
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oupton@google.com>, Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>, 
	Ricardo Koller <ricarkol@google.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add the definitions of ARMV8_PMU_CNTOVS_C (Cycle counter overflow
bit) for overflow status registers and ARMV8_PMU_CNTENSET_C (Cycle
counter enable bit) for PMCNTENSET_EL0 register.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/arch/arm64/include/asm/perf_event.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/arch/arm64/include/asm/perf_event.h b/tools/arch/arm64/include/asm/perf_event.h
index 97e49a4d4969f..8ce23aabf6fe6 100644
--- a/tools/arch/arm64/include/asm/perf_event.h
+++ b/tools/arch/arm64/include/asm/perf_event.h
@@ -222,9 +222,11 @@
 /*
  * PMOVSR: counters overflow flag status reg
  */
+#define ARMV8_PMU_CNTOVS_C      (1 << 31) /* Cycle counter overflow bit */
 #define	ARMV8_PMU_OVSR_MASK		0xffffffff	/* Mask for writable bits */
 #define	ARMV8_PMU_OVERFLOWED_MASK	ARMV8_PMU_OVSR_MASK
 
+
 /*
  * PMXEVTYPER: Event selection reg
  */
@@ -247,6 +249,11 @@
 #define ARMV8_PMU_USERENR_CR	(1 << 2) /* Cycle counter can be read at EL0 */
 #define ARMV8_PMU_USERENR_ER	(1 << 3) /* Event counter can be read at EL0 */
 
+/*
+ * PMCNTENSET: Count Enable set reg
+ */
+#define ARMV8_PMU_CNTENSET_C    (1 << 31) /* Cycle counter enable bit */
+
 /* PMMIR_EL1.SLOTS mask */
 #define ARMV8_PMU_SLOTS_MASK	0xff
 
-- 
2.39.1.581.gbfd45094c4-goog

