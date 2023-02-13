Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C2CA958
	for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 18:02:43 +0000 (UTC)
Received: by mail-io1-f74.google.com with SMTP id q3-20020a5edb03000000b00725625524e5so8679631iop.2
        for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 10:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I+uK5I847Ub+3lN0aBU7Gcssw6jbSaFlZxnmEwJsF78=;
        b=QbdYvBJWHHUW2D1muNpyWaqx7zQissf8ygmzU3xHnetuuSzhAGPmBNebmkvWnEv3Xz
         0jTCK1eWSC3eS7VG05SG9/FEi8vrnebVB2jiUNG9uyANwJOnQEbKNRaRfVC8qN3KlsXd
         Rb7FZJQCo48VHQ5nbIMEllm2vsR2a8e8QO0sBnWaEwoXOJcijWRfplFKi31C6/eZC2hl
         CDRxtjZxnwD6IpsDftFHB8SBdayD9oQvAHBbKF9YvKcJEuRACq+a/5OsQTF53rsLP01P
         9TtEQC0bRtuTmKo8G83KZK+lIFZkGfzIN2Lo/u/KWJLSOnf/yAbo8wQZT1gT4X3o0f7A
         /H3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I+uK5I847Ub+3lN0aBU7Gcssw6jbSaFlZxnmEwJsF78=;
        b=g5Ce4MmqwfBTWa2qlBqF4yp+fnkAjJOvkRqhJ9pGSBD5s1nahqX5ZwNhIZq3UFfI6L
         ASQ7fFt3YXbkbPdz2TDfw0/ziZ9HlcdLTK50BA9fGJ1G/IU4tFozmD6ntrvr1yAhtm1E
         M0YmWX6LR9f8+XCesCgpQ1IQvQ6TQxwY+s/USZ2gADSOz6wD3O+OBNpehIl+6DHgPW3c
         aeBA7jimKD3I1HpXPDNpGZSipbCvZT+HQvGiQSNSanoPe/YjdYmF2WaafCF4wm7bi8W+
         dEpWPJz5P/LSUx3/Mv9h1jDhnEwbvFlpVEwT6Hif0sQzQBvNwdmBvP3m+xQwgZfyOUhf
         rELw==
X-Gm-Message-State: AO0yUKUIEz7HY9KWoegI27wQaAspX9v7TXnMNH1B2xUSdo8QHliQwyfB
	qAbrUhhYPBbiiK8dySjhLnpEOcdrkmuW
X-Google-Smtp-Source: AK7set9juY00LvKn0j/zEJmqdLAxmL1I6OU4HnYIt4dcFolsJ+3w6e8YxMwoo+OzXJYGRW6YP6suEVqRXC4+
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a5d:9c49:0:b0:718:b11d:a972 with SMTP id
 9-20020a5d9c49000000b00718b11da972mr11228352iof.36.1676311362812; Mon, 13 Feb
 2023 10:02:42 -0800 (PST)
Date: Mon, 13 Feb 2023 18:02:24 +0000
In-Reply-To: <20230213180234.2885032-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230213180234.2885032-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230213180234.2885032-4-rananta@google.com>
Subject: [PATCH 03/13] tools: arm64: perf_event: Define Cycle counter
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

