Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B764AD52
	for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 21:03:46 +0000 (UTC)
Received: by mail-pg1-f202.google.com with SMTP id t17-20020a635f11000000b004fb9472bb16so1715732pgb.11
        for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 13:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7d5Y9CwOq9CkLMA/pzajcIbcjKDJQOL+VAkXtqdrmoQ=;
        b=dQUCK+3atvzjAYnG6diZ749RR4YR1PjBljouKrQXGQ1jhV0ZMQ0ytCKw7uOSonFRaP
         scXi1sRg6thyg+6ldgeP5rzi78mly8cke/IMPcv9qWsCtpOkSQei4quBvfLN0HLs9nEs
         /BBALLqR863Yln2NaRRgr5ICFSTE9rTDtvre6So1yrA+4VNsqUk9ZKHgwWuy+OyZtWzn
         P8BsBL7dEEdGxwpYn7K5WCYExVUhArxceaJ4ezy6fl4U0cpWAIeOrLHgqxur/GBlTtTA
         rpd9IbIG6/bOTywsMcSUTtw1ZK755V/zzQerNorhGLQEMnakuOQi3Sq2//FiRgIpaU4B
         CCtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7d5Y9CwOq9CkLMA/pzajcIbcjKDJQOL+VAkXtqdrmoQ=;
        b=FqMxDepacJDhrlTDTiiFhRxpES45Ud8kLo8RHPzEz8Zh4148ZapZfQkicXWARTR2/U
         gzi18qbSnZx1+mwD7nfr1oLdY6j7hPClaBUZk5X1XNnwlZVwBysEtNw1288KaLS9co9k
         BC2Nmk0+CKJQd6yIS1xFqP6NJwdDIJ43FalcN5JqQSZvG1XjGbrLmrf/+JwQphkq4qlp
         Ft5rlAp5c58uoQiyYSoTYdvw3i5X7gHo9ZuBJc5IFamw4mBiNLv8yI3SZcOREeOFLlj8
         Vf6Ke4RG8P7pwa36t9XRTXv+mSoi27LesLIRkKoNlB9LnznhZKkuhtbZX4EmcJ9YSiyk
         7mig==
X-Gm-Message-State: AO0yUKWPWTzd2aUPV45NHkmRptw1muYQcI2ggBG0IUGgamp1crmWtZDI
	R2M067AhDL75eCISJUNgweHYxvl+OsAM1e8=
X-Google-Smtp-Source: AK7set/acRsddQkT9b91dxC7gpzYx4jToPjVSTJJ/eAZPdxerL9ylmXMUS+Raxg5ZILhlWxD65DXjP3BZXzpS2Y=
X-Received: from zaidcloud.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5325])
 (user=zalbassam job=sendgmr) by 2002:a17:90a:7d13:b0:230:eeba:2176 with SMTP
 id g19-20020a17090a7d1300b00230eeba2176mr4399859pjl.56.1676322225854; Mon, 13
 Feb 2023 13:03:45 -0800 (PST)
Date: Mon, 13 Feb 2023 16:03:19 -0500
In-Reply-To: <20230213210319.1075872-1-zalbassam@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230213210319.1075872-1-zalbassam@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230213210319.1075872-9-zalbassam@google.com>
Subject: [PATCH v3 8/8] ARM: mach-virt: Select PMUv3 driver by default
From: Zaid Al-Bassam <zalbassam@google.com>
To: Jesus Sanchez-Palencia <jesussanp@google.com>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Zaid Al-Bassam <zalbassam@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Marc Zyngier <marc.zyngier@arm.com>

Since 32bit guests are not unlikely to run on an ARMv8 host,
let's select the PMUv3 driver, which allows the PMU to be used
on such systems.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Zaid Al-Bassam <zalbassam@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 137f89ad05211..3802997fb36e6 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -400,6 +400,7 @@ config ARCH_VIRT
 	select ARM_GIC_V3
 	select ARM_GIC_V3_ITS if PCI
 	select ARM_PSCI
+	select ARM_PMUV3 if PERF_EVENTS
 	select HAVE_ARM_ARCH_TIMER
 
 config ARCH_AIROHA
-- 
2.39.1.581.gbfd45094c4-goog

