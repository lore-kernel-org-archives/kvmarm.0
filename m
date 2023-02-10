Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0073663B6
	for <kvmarm@lists.linux.dev>; Fri, 10 Feb 2023 16:55:22 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id b5-20020a170902d50500b00198f3be5233so3302676plg.16
        for <kvmarm@lists.linux.dev>; Fri, 10 Feb 2023 08:55:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1eTxS2QhvdNdpvgmUZqkMCnw+JmhuyZ0B0cX/cmTrdw=;
        b=NmReRb3Cda4WNwjHJW58p8tXQoCPNoToXpB97MxrKm630BDvcb1slFqI8uySPLb0n7
         VX1qskQJimagKJppZxLX/w2Rvvoo6deJAst6tEyaGXCVqBvpUr9dRERXHjFHx7lNWAMm
         xXIBmfWtRSj/6plxfwJgXcP40ieCBA5e5Pr9G3uLtfsuo3VzeseKxIhNy9Jui7lczkE/
         DJBWMmOJLZYd677Gx3mk+ZtIjakHoymHLPiOzdITuuA+vlEWtX3sExV9dZMMOBxJsRKM
         kA23dRyNZ56nWF+I6VrxcKi3UiiifejJiV0+7OEcg3ro09wANzVIyG6rwnweQrzJZiw9
         fP1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1eTxS2QhvdNdpvgmUZqkMCnw+JmhuyZ0B0cX/cmTrdw=;
        b=l0nrct3sVou3xLdEPBp7vkOjVqmPjnO8yKQnaetwNxCdS8vGj7YgUlfhiLBRDjdB/j
         xPkFj24Kx1jRB/7UA3qjV6AKgqkqc8NkMJWzIVk2UAS9XKPeZCL9ek+M//ic68gjLtCb
         uAVQhRAaiJqGVv9ONfp3PCqi5pZl3t/0WheGBb5aKPtAD3jFJiLoO56YjPZsWsVc5ZPk
         AwfNbtonIskuPGiBI0IFTScZ2WWFFez9ccxFoWvkTZPtzsB6XFaaxJsciBQcKpVPRjqa
         62FvkrvTp8ilDC0zutqCgjAeaY0JkD4f6AAcLb3cEeZI+/TyZN20bMifrtgC7TR5OC9h
         PGtA==
X-Gm-Message-State: AO0yUKXx9ifS2ZjNDPqW45bwG7AFepK6VBnN06okuZGO1AQN9ZySQdE0
	+X9ZUNyoyfw/1OsuvNDO+jACMD1naG3E2Fo=
X-Google-Smtp-Source: AK7set+YMfD8sTDVabPOQ78qWERVLHMXj74nYgIQleRKqKxZRIemnhE4Bpwus4okiwWg/wZaOL9+ZSgBe0Ek2U0=
X-Received: from zaidcloud.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5325])
 (user=zalbassam job=sendgmr) by 2002:a17:902:a512:b0:199:554c:39c with SMTP
 id s18-20020a170902a51200b00199554c039cmr2149652plq.19.1676048122399; Fri, 10
 Feb 2023 08:55:22 -0800 (PST)
Date: Fri, 10 Feb 2023 11:54:56 -0500
In-Reply-To: <20230210165500.2292608-1-zalbassam@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230210165500.2292608-1-zalbassam@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230210165500.2292608-5-zalbassam@google.com>
Subject: [PATCH v2 4/8] perf: pmuv3: Move inclusion of kvm_host.h to the
 arch-specific helper
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
Cc: Zaid Al-Bassam <zalbassam@google.com>
Content-Type: text/plain; charset="UTF-8"

KVM host support is available only on arm64.

By moving the inclusion of kvm_host.h to an arm64-specific file,
the 32bit architecture will be able to implement dummy helpers.

Signed-off-by: Zaid Al-Bassam <zalbassam@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230126204444.2204061-5-zalbassam@google.com
---
 arch/arm64/include/asm/arm_pmuv3.h | 2 ++
 drivers/perf/arm_pmuv3.c           | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
index b13651a06adf9..1c460515b02bd 100644
--- a/arch/arm64/include/asm/arm_pmuv3.h
+++ b/arch/arm64/include/asm/arm_pmuv3.h
@@ -18,6 +18,8 @@
 #ifndef __ASM_PMUV3_H
 #define __ASM_PMUV3_H
 
+#include <linux/kvm_host.h>
+
 #include <asm/cpufeature.h>
 #include <asm/sysreg.h>
 
diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 46e89e92f8236..b3683fdf8d0b9 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -16,7 +16,6 @@
 
 #include <linux/acpi.h>
 #include <linux/clocksource.h>
-#include <linux/kvm_host.h>
 #include <linux/of.h>
 #include <linux/perf/arm_pmu.h>
 #include <linux/perf/arm_pmuv3.h>
-- 
2.39.1.581.gbfd45094c4-goog

