Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A42D2054F9
	for <kvmarm@lists.linux.dev>; Tue,  4 Feb 2025 19:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738699041; cv=none; b=HULHdakP9PyTUmtlZgD1UJ3IGJG+I7HK9prufO3El4Napyk6H48DjwfLQB64d665gNw6p8HFdIYQfAnVyuqlalZOB1xrsUVDQ28/VRseB5hluSQicVXo8iQBpl6sq4fvXgcOgswTonjEKTGiNDiPc4eoQIQ/uUsT9yPteeRcCAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738699041; c=relaxed/simple;
	bh=QqvlrBfQEOlBEj4EME2FtGfO8xnXwuQ2wNlYILdKt90=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y248YOnwoXgbNw4tm+BdA86EAQAuNxGm3lFhDk7DmIpZ0QIUaXJhvVT86fbYFHxGUvHtQWFb050V0NEvPIfbJP+IvDSXQdQX5hX+cOz5ZPZkvDjvN7hbSElOy1sTaSuq4egJNQCkQOcy+V5YOe99bkTOuu4+Rue/clqPEKvwQ3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K1wrZuBl; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K1wrZuBl"
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3d04d216bfcso3463135ab.2
        for <kvmarm@lists.linux.dev>; Tue, 04 Feb 2025 11:57:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738699039; x=1739303839; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y4R+14MvP6+jfAZ/2SDPJZGHYgAQ9ZFZffV6N7sMB9Y=;
        b=K1wrZuBls3RdzOuzOIUev6/npiBP5oDX7Sj0AhiaiTtabnxI+xtRWD+NUHyD054tvA
         W9lOsAZhCZUS946JJy3CQAv/vI8gcW8BqmaOFmadrPJ/NS+ya9NEPaGFDonzt9x6Y4Zd
         mM3/aJxTYrg1Cv7yVduXAmoB7nq/Do5P/zAHWNLu+vFDt7ErJKTe3oGaGtOvyb1mDuoQ
         fvFNaRDXLZK8xAufttiSd+k6qgIhNyQn0GgqdTqQSaodawun6N8aodthj20n/fkb3iwS
         GUGeG2L42Sm4pDTSu0YPpQZcJdLPNsgJhxV0p+KbbjDVXRKdKSA5tDPivMo8nOg+lB+3
         aS9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738699039; x=1739303839;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y4R+14MvP6+jfAZ/2SDPJZGHYgAQ9ZFZffV6N7sMB9Y=;
        b=Tw5FGPkq1g8eHRjctMNFMYbYqPULhBTPRkZ0hdBYL8uGdcGGdBFaP8vuv+iEd7bfHr
         x0ZiC9cWL+7bcqpi/axVLD3+jaJq2j0ewJIBCGTc8BlxTZ/GpIrMS0mbqqEvPPofn227
         xGVuELezRx6yvJl7KOt67OpuyYg9bIjMVinjhuJYLGnF0637MPdgeGmQm6qCXCEU9rty
         mMx6oga36k7bn1dcZh0YksOY1uAHQL44mUPV7zmHcsDD8EQtc08n+K2TbTSJi4ulg7pH
         kXtgBoQZy+M84WsaeHkqgMgka1deRV+POg04OvlN/rZH39di3B3ayilrBfcWgmOnF7Y4
         JDnA==
X-Forwarded-Encrypted: i=1; AJvYcCXqmZ+EGSmAz/kjgwKReuy2IAP3C3XoYSVSFJftE9VojzFEo//Xaz0HuNd84Nb4wjdSCpaKTZ0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzfgjLoRjygk1gRPSDuYHX8pbfyNGNO32WlMB3vXWheh9Tu/9yb
	rMeewyTFuQnmgq//O2nF2cMd2EE7rYQHXL6Cqbk0bj0Mdt2UOleukT56B0W+XmaS1xF9gaZz4Dn
	ZNloEMN8ZEBUTZaKIIDOW5g==
X-Google-Smtp-Source: AGHT+IFjKjYyuQlNa/ishtIcrEB5bPDdOoTVbdVO7D85Z9CPphU0w8y5cfrKi9gtvFrT4dURbTET8ohchq0pXDfx0g==
X-Received: from ilbdr11.prod.google.com ([2002:a05:6e02:3f0b:b0:3ce:7e27:ea5a])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:3f83:b0:3d0:4eaa:e480 with SMTP id e9e14a558f8ab-3d04f40166emr2549635ab.3.1738699039331;
 Tue, 04 Feb 2025 11:57:19 -0800 (PST)
Date: Tue,  4 Feb 2025 19:57:08 +0000
In-Reply-To: <20250204195708.1703531-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250204195708.1703531-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250204195708.1703531-2-coltonlewis@google.com>
Subject: [PATCH 2/2] perf: arm_pmuv3: Uninvert dependency between {asm,perf}/arm_pmuv3.h
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

perf/arm_pmuv3.h includes asm/arm_pmuv3.h at the bottom of the
file. This counterintiutive decision was presumably made so
asm/arm_pmuv3.h would be included everywhere perf/arm_pmuv3.h was even
though the actual dependency relationship goes the other way because
asm/arm_pmuv3.h depends on the PMEVN_SWITCH macro that was presumably
put there to avoid duplicating it in the asm files for arm and arm64.

Extract the relevant macro to its own file to avoid this unusual
structure so it may be included in the asm headers without worrying
about ordering issues.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm/include/asm/arm_pmuv3.h   |  2 ++
 arch/arm64/include/asm/arm_pmuv3.h |  1 +
 include/linux/perf/arm_pmuv3.h     | 49 ++-------------------------
 include/linux/perf/pmevn_switch.h  | 54 ++++++++++++++++++++++++++++++
 4 files changed, 59 insertions(+), 47 deletions(-)
 create mode 100644 include/linux/perf/pmevn_switch.h

diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
index 2ec0e5e83fc9..a39277b6a365 100644
--- a/arch/arm/include/asm/arm_pmuv3.h
+++ b/arch/arm/include/asm/arm_pmuv3.h
@@ -9,6 +9,8 @@
 #include <asm/cp15.h>
 #include <asm/cputype.h>
 
+#include <linux/perf/pmevn_switch.h>
+
 #define PMCCNTR			__ACCESS_CP15_64(0, c9)
 
 #define PMCR			__ACCESS_CP15(c9,  0, c12, 0)
diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
index 89fd6abb7da6..e22fb26b6169 100644
--- a/arch/arm64/include/asm/arm_pmuv3.h
+++ b/arch/arm64/include/asm/arm_pmuv3.h
@@ -10,6 +10,7 @@
 #include <asm/sysreg.h>
 
 #include <linux/perf_event.h>
+#include <linux/perf/pmevn_switch.h>
 
 #ifdef CONFIG_KVM
 void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
diff --git a/include/linux/perf/arm_pmuv3.h b/include/linux/perf/arm_pmuv3.h
index d698efba28a2..00623b69cdcc 100644
--- a/include/linux/perf/arm_pmuv3.h
+++ b/include/linux/perf/arm_pmuv3.h
@@ -6,6 +6,8 @@
 #ifndef __PERF_ARM_PMUV3_H
 #define __PERF_ARM_PMUV3_H
 
+#include <asm/arm_pmuv3.h>
+
 #define ARMV8_PMU_MAX_GENERAL_COUNTERS	31
 #define ARMV8_PMU_CYCLE_IDX		31
 #define ARMV8_PMU_INSTR_IDX		32 /* Not accessible from AArch32 */
@@ -268,51 +270,4 @@
 #define ARMV8_PMU_BUS_WIDTH	GENMASK(19, 16)
 #define ARMV8_PMU_THWIDTH	GENMASK(23, 20)
 
-/*
- * This code is really good
- */
-
-#define PMEVN_CASE(n, case_macro) \
-	case n: case_macro(n); break
-
-#define PMEVN_SWITCH(x, case_macro)				\
-	do {							\
-		switch (x) {					\
-		PMEVN_CASE(0,  case_macro);			\
-		PMEVN_CASE(1,  case_macro);			\
-		PMEVN_CASE(2,  case_macro);			\
-		PMEVN_CASE(3,  case_macro);			\
-		PMEVN_CASE(4,  case_macro);			\
-		PMEVN_CASE(5,  case_macro);			\
-		PMEVN_CASE(6,  case_macro);			\
-		PMEVN_CASE(7,  case_macro);			\
-		PMEVN_CASE(8,  case_macro);			\
-		PMEVN_CASE(9,  case_macro);			\
-		PMEVN_CASE(10, case_macro);			\
-		PMEVN_CASE(11, case_macro);			\
-		PMEVN_CASE(12, case_macro);			\
-		PMEVN_CASE(13, case_macro);			\
-		PMEVN_CASE(14, case_macro);			\
-		PMEVN_CASE(15, case_macro);			\
-		PMEVN_CASE(16, case_macro);			\
-		PMEVN_CASE(17, case_macro);			\
-		PMEVN_CASE(18, case_macro);			\
-		PMEVN_CASE(19, case_macro);			\
-		PMEVN_CASE(20, case_macro);			\
-		PMEVN_CASE(21, case_macro);			\
-		PMEVN_CASE(22, case_macro);			\
-		PMEVN_CASE(23, case_macro);			\
-		PMEVN_CASE(24, case_macro);			\
-		PMEVN_CASE(25, case_macro);			\
-		PMEVN_CASE(26, case_macro);			\
-		PMEVN_CASE(27, case_macro);			\
-		PMEVN_CASE(28, case_macro);			\
-		PMEVN_CASE(29, case_macro);			\
-		PMEVN_CASE(30, case_macro);			\
-		default: WARN(1, "Invalid PMEV* index\n");	\
-		}						\
-	} while (0)
-
-#include <asm/arm_pmuv3.h>
-
 #endif
diff --git a/include/linux/perf/pmevn_switch.h b/include/linux/perf/pmevn_switch.h
new file mode 100644
index 000000000000..1f211468d8bf
--- /dev/null
+++ b/include/linux/perf/pmevn_switch.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __PMEVN_SWITCH_H
+#define __PMEVN_SWITCH_H
+
+#include <asm-generic/bug.h>
+
+/*
+ * This code is really good
+ */
+
+#define PMEVN_CASE(n, case_macro) \
+	case n: case_macro(n); break
+
+#define PMEVN_SWITCH(x, case_macro)				\
+	do {							\
+		switch (x) {					\
+		PMEVN_CASE(0,  case_macro);			\
+		PMEVN_CASE(1,  case_macro);			\
+		PMEVN_CASE(2,  case_macro);			\
+		PMEVN_CASE(3,  case_macro);			\
+		PMEVN_CASE(4,  case_macro);			\
+		PMEVN_CASE(5,  case_macro);			\
+		PMEVN_CASE(6,  case_macro);			\
+		PMEVN_CASE(7,  case_macro);			\
+		PMEVN_CASE(8,  case_macro);			\
+		PMEVN_CASE(9,  case_macro);			\
+		PMEVN_CASE(10, case_macro);			\
+		PMEVN_CASE(11, case_macro);			\
+		PMEVN_CASE(12, case_macro);			\
+		PMEVN_CASE(13, case_macro);			\
+		PMEVN_CASE(14, case_macro);			\
+		PMEVN_CASE(15, case_macro);			\
+		PMEVN_CASE(16, case_macro);			\
+		PMEVN_CASE(17, case_macro);			\
+		PMEVN_CASE(18, case_macro);			\
+		PMEVN_CASE(19, case_macro);			\
+		PMEVN_CASE(20, case_macro);			\
+		PMEVN_CASE(21, case_macro);			\
+		PMEVN_CASE(22, case_macro);			\
+		PMEVN_CASE(23, case_macro);			\
+		PMEVN_CASE(24, case_macro);			\
+		PMEVN_CASE(25, case_macro);			\
+		PMEVN_CASE(26, case_macro);			\
+		PMEVN_CASE(27, case_macro);			\
+		PMEVN_CASE(28, case_macro);			\
+		PMEVN_CASE(29, case_macro);			\
+		PMEVN_CASE(30, case_macro);			\
+		default: WARN(1, "Invalid PMEV* index\n");	\
+		}						\
+	} while (0)
+
+
+#endif
-- 
2.48.1.362.g079036d154-goog

