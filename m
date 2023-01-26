Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C045390
	for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 20:44:59 +0000 (UTC)
Received: by mail-pf1-f201.google.com with SMTP id j1-20020aa78001000000b0057d28e11cb6so1416433pfi.11
        for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 12:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zqM3/Ci1lx/2tZr3NWii0Dt8IoCFwVmRmktSfadot+Y=;
        b=AtzLjLuseZj5IfJaGcz67eE/oecjONgYbERTV8bTih9QC+A3oBltmK9MFkMSv0YccD
         Vw87R9XzDLU6QOsDcXPrwnpEUShrgOoSmlwEzG4VLi2GH/5W5IO9jtvAyAc4dHaDA5kq
         rgbBknjoQ2mz7cj0vEBOP4NlV8qLF9qbw16CSCWzVcV3WnJ5kzpnwenW51IT+fqGjhgJ
         n86IW6+2o6lszwEHosMm0M6IX/XEgMWkU7X6yqL6zgUgsEXBBbq1tZgTn+ewksV0asbq
         mw2tJ5/S885VrDiPzj2IMoJ78LSNJNsYe8+guRMwppiw9mLfe57EgxXGqIYtzaCSrkpB
         IXWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zqM3/Ci1lx/2tZr3NWii0Dt8IoCFwVmRmktSfadot+Y=;
        b=qZDHxgEheG9+9RZJhNpRTKUPQ16Rb0EgJ2FuZgFuVNCx/cd9lMJsROUaj6KvHVDKLl
         oW40YNws8dAHoxWvLB5bGMdsFH0+Bjo1sIPSTCPDedL6ci5DgIit/Lcb/TgA79QLQj9v
         AuaIdgHPvM4qTbuTNFh9kqq0yxN1UfxrGAMMSCQSnrT7m25YTqciHIsyeU3OQfuygfDp
         CECjPnePrqribj0RL88dSIX8+H4muCvPRJ6cNUc+TTCFoNMBi2oRC22EZqDKRnp1m4y5
         y0IGd0hGcXSfzNzcCPyHJqcc7qh9QuOV93f/8DqQZSiIFJdOn1Gr3Dd3cxMxOkHbuIJH
         1XiQ==
X-Gm-Message-State: AFqh2krR5h4wtu1TnfUmLzTfjhlYZLwuHUcSeeWawv7wwxtxelfQnlcg
	xgT94NvZdggix67CS6PRzHBZ38qCl4B4oP4=
X-Google-Smtp-Source: AMrXdXuVOgVY7AWhbaZGyoii9f0mMWnbNgHUxwPn2DnS6IBBl2DP1jJc+mNdVEgrvBEVDl6hSca4Y8riumJsGwg=
X-Received: from zaidcloud.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5325])
 (user=zalbassam job=sendgmr) by 2002:a17:902:968f:b0:193:e89:f610 with SMTP
 id n15-20020a170902968f00b001930e89f610mr4137596plp.31.1674765899077; Thu, 26
 Jan 2023 12:44:59 -0800 (PST)
Date: Thu, 26 Jan 2023 15:44:40 -0500
In-Reply-To: <20230126204444.2204061-1-zalbassam@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230126204444.2204061-1-zalbassam@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230126204444.2204061-5-zalbassam@google.com>
Subject: [PATCH 4/8] perf: pmuv3: Add wrappers for KVM accesses
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

KVM host support is available only on arm64. This patch adds wrappers
to the KVM host function references in the arm_pmuv3.c, so that it is
up to architecture to populate these wrappers if supported.

Signed-off-by: Zaid Al-Bassam <zalbassam@google.com>
---
 arch/arm64/include/asm/arm_pmuv3.h | 16 ++++++++++++++++
 drivers/perf/arm_pmuv3.c           | 11 +++++------
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
index f41a354d1022..9f2a48f5340c 100644
--- a/arch/arm64/include/asm/arm_pmuv3.h
+++ b/arch/arm64/include/asm/arm_pmuv3.h
@@ -20,6 +20,7 @@
 
 #include <asm/cpufeature.h>
 #include <asm/sysreg.h>
+#include <linux/kvm_host.h>
 
 /*
  * This code is really good
@@ -191,4 +192,19 @@ static inline u32 read_pmceid1(void)
 	return read_sysreg(pmceid1_el0);
 }
 
+static inline void armv8pmu_kvm_set_events(u32 set, struct perf_event_attr *attr)
+{
+	kvm_set_pmu_events(set, attr);
+}
+
+static inline void armv8pmu_kvm_clr_events(u32 clr)
+{
+	kvm_clr_pmu_events(clr);
+}
+
+static inline bool armv8pmu_kvm_counter_deferred(struct perf_event_attr *attr)
+{
+	return kvm_pmu_counter_deferred(attr);
+}
+
 #endif
diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 505f0758260c..d7063dd52827 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -16,7 +16,6 @@
 
 #include <linux/acpi.h>
 #include <linux/clocksource.h>
-#include <linux/kvm_host.h>
 #include <linux/of.h>
 #include <linux/perf/arm_pmu.h>
 #include <linux/perf/arm_pmuv3.h>
@@ -607,10 +606,10 @@ static inline void armv8pmu_enable_event_counter(struct perf_event *event)
 	struct perf_event_attr *attr = &event->attr;
 	u32 mask = armv8pmu_event_cnten_mask(event);
 
-	kvm_set_pmu_events(mask, attr);
+	armv8pmu_kvm_set_events(mask, attr);
 
 	/* We rely on the hypervisor switch code to enable guest counters */
-	if (!kvm_pmu_counter_deferred(attr))
+	if (!armv8pmu_kvm_counter_deferred(attr))
 		armv8pmu_enable_counter(mask);
 }
 
@@ -629,10 +628,10 @@ static inline void armv8pmu_disable_event_counter(struct perf_event *event)
 	struct perf_event_attr *attr = &event->attr;
 	u32 mask = armv8pmu_event_cnten_mask(event);
 
-	kvm_clr_pmu_events(mask);
+	armv8pmu_kvm_clr_events(mask);
 
 	/* We rely on the hypervisor switch code to disable guest counters */
-	if (!kvm_pmu_counter_deferred(attr))
+	if (!armv8pmu_kvm_counter_deferred(attr))
 		armv8pmu_disable_counter(mask);
 }
 
@@ -974,7 +973,7 @@ static void armv8pmu_reset(void *info)
 	armv8pmu_disable_intens(U32_MAX);
 
 	/* Clear the counters we flip at guest entry/exit */
-	kvm_clr_pmu_events(U32_MAX);
+	armv8pmu_kvm_clr_events(U32_MAX);
 
 	/*
 	 * Initialize & Reset PMNC. Request overflow interrupt for
-- 
2.39.0.246.g2a6d74b583-goog

