Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C685E194A77;
	Wed, 26 Jun 2024 22:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719441166; cv=none; b=EU6ziOI6oO8h+6bu54DvOs/4fYnBUorHq/wjAYHO0gZrBlEntUp+mYyTi4CXBNA926xQMiqJAw1PDACjKBEXv+AzqOuFH7PrdDiT3+rdlFngykgskORqrCvhaZhFR9AvyGKRBx5AeQcbkg/eMm3A/KvGTsbf3lnPlVIUrp37/94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719441166; c=relaxed/simple;
	bh=6GkA/fPaiRxw9Ny+x8zxq13aEdGN9LuiDrvGZ0QKC6M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Bxo7x+3EDYPNn8G9cjDg3dq6hymDPq/vVP4EU/4E6cFiU/Uzol2vPBT2OysvxJF33oDEwHKXofayoH659SjN9WXXo+1EbHPCee0VzDx8NfE5y1ifJ0YaB1z76DCTtaEO71kGAPPqc0rCRzC45U1uAZ4jGuxEahLreGpLJVfi8Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kKW1at+G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kKW1at+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D086C4AF10;
	Wed, 26 Jun 2024 22:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719441165;
	bh=6GkA/fPaiRxw9Ny+x8zxq13aEdGN9LuiDrvGZ0QKC6M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=kKW1at+GlPWFliTg1aXL9AfLvX2rYNkYnNxrlEq1EzaDOqWieeI+cv1OpZ2HzNP7Q
	 Mbe7HPge4Gx8DuJYHFSeHixvC/cvDeW9F7pwcb8x+2U/iYGwCcEeUEp7cmsqGCs+iY
	 n3rAMVhdFyYCiFqjM2MLeobXTT6/jYCaHIGc58maRu6HI3bml2TJ9Zb74HygUbck8v
	 4qou3lYjS7iW7H7L1T/nKGBYAP6E4pJlzlauVjcAZFZkQeFaIYNnoTr5+wT46k2gBE
	 OJzXmL0+MLlrKlqahrpxxy9v0GQzUWWi4KbXsyAhCtQ7Fy944kgom2je2wW+Nzynjv
	 MpV5mRZiH63QQ==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Wed, 26 Jun 2024 16:32:29 -0600
Subject: [PATCH v2 05/12] perf: arm_pmuv3: Include asm/arm_pmuv3.h from
 linux/perf/arm_pmuv3.h
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240626-arm-pmu-3-9-icntr-v2-5-c9784b4f4065@kernel.org>
References: <20240626-arm-pmu-3-9-icntr-v2-0-c9784b4f4065@kernel.org>
In-Reply-To: <20240626-arm-pmu-3-9-icntr-v2-0-c9784b4f4065@kernel.org>
To: Russell King <linux@armlinux.org.uk>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 James Clark <james.clark@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev
X-Mailer: b4 0.14-dev

The arm64 asm/arm_pmuv3.h depends on defines from
linux/perf/arm_pmuv3.h. Rather than depend on include order, follow the
usual pattern of "linux" headers including "asm" headers of the same
name.

With this change, the include of linux/kvm_host.h is problematic due to
circular includes:

In file included from ../arch/arm64/include/asm/arm_pmuv3.h:9,
                 from ../include/linux/perf/arm_pmuv3.h:312,
                 from ../include/kvm/arm_pmu.h:11,
                 from ../arch/arm64/include/asm/kvm_host.h:38,
                 from ../arch/arm64/mm/init.c:41:
../include/linux/kvm_host.h:383:30: error: field 'arch' has incomplete type

Switching to asm/kvm_host.h solves the issue.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
v2:
 - new patch
---
 arch/arm64/include/asm/arm_pmuv3.h | 2 +-
 arch/arm64/kvm/pmu-emul.c          | 1 -
 drivers/perf/arm_pmuv3.c           | 2 --
 include/linux/perf/arm_pmuv3.h     | 2 ++
 4 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
index c27404fa4418..a4697a0b6835 100644
--- a/arch/arm64/include/asm/arm_pmuv3.h
+++ b/arch/arm64/include/asm/arm_pmuv3.h
@@ -6,7 +6,7 @@
 #ifndef __ASM_PMUV3_H
 #define __ASM_PMUV3_H
 
-#include <linux/kvm_host.h>
+#include <asm/kvm_host.h>
 
 #include <asm/cpufeature.h>
 #include <asm/sysreg.h>
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index a35ce10e0a9f..d1a476b08f54 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -14,7 +14,6 @@
 #include <asm/kvm_emulate.h>
 #include <kvm/arm_pmu.h>
 #include <kvm/arm_vgic.h>
-#include <asm/arm_pmuv3.h>
 
 #define PERF_ATTR_CFG1_COUNTER_64BIT	BIT(0)
 
diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 3e51cd7062b9..6cbd37fd691a 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -25,8 +25,6 @@
 #include <linux/smp.h>
 #include <linux/nmi.h>
 
-#include <asm/arm_pmuv3.h>
-
 /* ARMv8 Cortex-A53 specific event types. */
 #define ARMV8_A53_PERFCTR_PREF_LINEFILL				0xC2
 
diff --git a/include/linux/perf/arm_pmuv3.h b/include/linux/perf/arm_pmuv3.h
index 46377e134d67..7867db04ec98 100644
--- a/include/linux/perf/arm_pmuv3.h
+++ b/include/linux/perf/arm_pmuv3.h
@@ -309,4 +309,6 @@
 		}						\
 	} while (0)
 
+#include <asm/arm_pmuv3.h>
+
 #endif

-- 
2.43.0

