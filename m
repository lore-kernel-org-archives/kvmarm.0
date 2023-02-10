Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97EE63B6
	for <kvmarm@lists.linux.dev>; Fri, 10 Feb 2023 16:55:26 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-527501b56ffso54308597b3.15
        for <kvmarm@lists.linux.dev>; Fri, 10 Feb 2023 08:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EO6j55oy/7Ai9ABZKCWhv0W9Kemf/0xaKUwrsinlv10=;
        b=pmg8YuVuutfwzk67a6fQ0thz/qO1HJ+AiUNB8ypdHPX3sPaYKhE+A4EISldV27ciY1
         Y7reHJNL+7uHbu35hXy/I9PemRIyodRKwdmcQEFKvankBQjwaBXw4VDHV+jQlSb5LafG
         rkx2BUzCminsA5HZQMxh7EMMoG3hPh20I3XxYVzKMcrjLB96sHySriCB54E3vU2+HuVS
         bMG5ycpz4mF7kuLAfLQTEgoTmEPIUx1RqTCd2Mmaygc6qTlvyO5VufPYiUKCFkzrjzgN
         r4MR++CUiNJiuqFFvkJQBjXqPNtRqMxoBswFpox3JuuHEfGvSBra5vH2tMOZf2z3+pNN
         zI+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EO6j55oy/7Ai9ABZKCWhv0W9Kemf/0xaKUwrsinlv10=;
        b=0oynjestiozoqYnSjI2T0bePKglvYir+oRpoW7VwyM0G/Cr1L6Sw03ivzsNJD0oAQ8
         kexRCIw3Mdh7Alj/8pXE2N3y2jmqZ1GRilddbhBR2MzO82GeUDAutlGMb8P+oLAYjYjE
         2aJ0kp7lgYpjG0xKqS0k0vOMcfHTNMBcJsi1sHj9FldSJunmKKEIw8+a1dNj8FWa41ai
         few0ZMR8MbOvumGLtjDrzgzdcmeT1xs05NJ5FHChMhJmfP8PO4TlBjqy9WzYDbPZZCcz
         Y4nlavc+VllNyf90HZmUO9I0jo1c5GIcnwdwX4J236RqyHTkGVUM1oVDKf17TH4OsFEn
         2nLA==
X-Gm-Message-State: AO0yUKXljrA4Rm86SIwy6dWt8AkynDWaVnuNyjbbmDAD7oE7IzjBTD+2
	nHdSXrK0XKpKMcaO9r319vp5kcKcUk9q9g4=
X-Google-Smtp-Source: AK7set9S/i/zSZYwD8sZLxL0uhpI93QJizSijAGISTAM9LeCfv59AIMQxCXfhWUDZ04AgqxYON6CtRVYX0VEe0Q=
X-Received: from zaidcloud.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5325])
 (user=zalbassam job=sendgmr) by 2002:a5b:1c3:0:b0:80b:72cc:3967 with SMTP id
 f3-20020a5b01c3000000b0080b72cc3967mr1793786ybp.123.1676048125892; Fri, 10
 Feb 2023 08:55:25 -0800 (PST)
Date: Fri, 10 Feb 2023 11:54:58 -0500
In-Reply-To: <20230210165500.2292608-1-zalbassam@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230210165500.2292608-1-zalbassam@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230210165500.2292608-7-zalbassam@google.com>
Subject: [PATCH v2 6/8] ARM: Make CONFIG_CPU_V7 valid for 32bit ARMv8 implementations
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

ARMv8 is a superset of ARMv7, and all the ARMv8 features are
discoverable with a set of ID registers. It means that we can
use CPU_V7 to guard ARMv8 features at compile time.

This commit simply amends the CPU_V7 configuration symbol comment
to reflect that CPU_V7 also covers ARMv8.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Zaid Al-Bassam <zalbassam@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230126204444.2204061-7-zalbassam@google.com
---
 arch/arm/mm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index e949e84a2decd..b77f4a0d9072e 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -403,7 +403,7 @@ config CPU_V6K
 	select CPU_THUMB_CAPABLE
 	select CPU_TLB_V6 if MMU
 
-# ARMv7
+# ARMv7 and ARMv8 architectures
 config CPU_V7
 	bool
 	select CPU_32v6K
-- 
2.39.1.581.gbfd45094c4-goog

