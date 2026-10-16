Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F531423E9E
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 10:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792144893; cv=none; b=GTL4uWmnGOGajtCvl0VqpOUBcGDXHma/CZ5MWg9qeQE2ucYDsVnL7tOYRO12hEdT0YPoUOnafinMVFBo61ccteLSoFk/5s7AmmA/LG5KT9ffR5ur3L9upXKoAWA4Ycyu4ffQb1yixVtHLys/NBP1w9ooOBgrZVRn7u2U6r7hdBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792144893; c=relaxed/simple;
	bh=Kb1L0Jz22Bdu0wiudnLgsasoZRk2+Y5lFCpZprecvXE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=stnQNybHpbIBGNewWFHuVPw6WFrZDJqHyOydAm3j4svEWHL0H6mQoce7wUmLVk5SypMg4MoSufE+VRcXLJ5FIvxQNlw3SbAJcvXw15s0q9TlWp4yOPXcDvnsW2lHtZWl+Uh+ZZZqx9t+4X/PHIVFrVEIBAJgG0ycXeT4lBZPEdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=aaUo3ffJ; arc=none smtp.client-ip=207.54.90.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="aaUo3ffJ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1792144891; x=1823680891;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=Kb1L0Jz22Bdu0wiudnLgsasoZRk2+Y5lFCpZprecvXE=;
  b=aaUo3ffJyQ5yrHKX0cbKEP4g0AS3O/b66N8ZKdaEbVr9DYVRxlDtauLz
   XniVmnw7JE8WoJDqb8hTJ64d9vSQOEtNWIWeoapjcmaPPAi7YJV3v9Cdy
   9uMoM+VzSFj0StKWvdIE23OVZAmWePyP+LPyFpLpj6iio7pIUWrNoE5BF
   5e+qgA8phIrHCSrE74u9YpocMq9J7kW1lNZqr4JfECopjc9o6fUiPG0y3
   C6ll4kfUM1d6e3F+M9+eUSckKYIQeKkVAIcQiVY6yGLROydUhaNYEURbW
   Tjh07b/BW6hwCSr/0ij3EEipA5/2tueAVi02UHVPvEwpt1L5hovXqd+wv
   A==;
X-CSE-ConnectionGUID: rZU0QMcCRDqd3WkQ4gb0kQ==
X-CSE-MsgGUID: H8h4sAyRQkK27rF2RJ5t0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11936"; a="258434337"
X-IronPort-AV: E=Sophos;i="6.27,161,1786978800"; 
   d="scan'208";a="258434337"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2026 19:01:24 +0900
Received: from az2nlsmgm1.o.css.fujitsu.com (unknown [10.150.26.203])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id BA26210008C7
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 10:01:23 +0000 (UTC)
Received: from az2nlsmom3.fujitsu.com (unknown [10.150.26.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id 6CA84C00FC1
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 10:01:23 +0000 (UTC)
Received: from [127.0.1.1] (unknown [10.124.178.20])
	by az2nlsmom3.fujitsu.com (Postfix) with ESMTP id 2229010005E9;
	Fri, 16 Oct 2026 10:01:15 +0000 (UTC)
From: Tomohiro Misono <misono.tomohiro@fujitsu.com>
Subject: [PATCH v2 0/4] arm64: Add workarounds for FUJITSU-MONAKA CPU
Date: Fri, 16 Oct 2026 19:00:44 +0900
Message-Id: <20261016-monaka-fix-for-upstream-v2-0-fc7ede7f9f48@fujitsu.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMz10WoC/4WNQQ6CMBBFr0Jm7ZhpJQRdeQ/CopSpjAZK2kI0h
 LtbuYDL9/P/+xtEDsIRbsUGgVeJ4qcM+lSAHcz0YJQ+M2jSlSLSOPrJvAw6eaPzAZc5psBmxKq
 mmlTP5qod5PUcOHcOc9NmHiQmHz7H0ap+6X/nqpCwNGypI9vxpby75SkpLmfrR2j3ff8Crj7Q1
 sAAAAA=
To: Tomohiro Misono <misono.tomohiro@fujitsu.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Marc Zyngier <maz@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Radu Rendec <radu@rendec.net>, 
 Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>
Cc: Kohei Enju <enju.kohei@fujitsu.com>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-perf-users@vger.kernel.org, 
 kvmarm@lists.linux.dev
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792144875; l=2143;
 i=misono.tomohiro@fujitsu.com; s=20261002; h=from:subject:message-id;
 bh=Kb1L0Jz22Bdu0wiudnLgsasoZRk2+Y5lFCpZprecvXE=;
 b=yAQ9E8iiX3yBD0SZ7Tof0begEfs+mYDP9Y1rcSqpF+YhaoajTyR1fNFANXIVL3EGum+8JuYHL
 osQZgXOAnddCuDZl4ELCmSlJn8yZa2ucVnECEriaEBDdl5VWjblmA8y
X-Developer-Key: i=misono.tomohiro@fujitsu.com; a=ed25519;
 pk=VLRxj5y4GJrHLmj3e2NBg30fX2U//ydi7c2G2qiNo10=

Changes in v2:
 - Address review comments in patch 2-4. See each commits for the details
 - rebased on 7.3-rc7
 - Link to v1: https://lore.kernel.org/r/20261002-monaka-fix-for-upstream-v1-0-4aec0b0cbe34@fujitsu.com

This series adds three workarounds for the FUJITSU-MONAKA CPU.
 - Patch 1 ... Add the FUJITSU-MONAKA CPU type definition
 - Patch 2 ... Add a workaround for TLBI operation on 64k page size
 - Patch 3 ... Add a workaround for perf operation
 - Patch 4 ... Add a workaround for GIC operation

Although the three workarounds do not depend on each other functionally,
I have combined them into one series because patch 2-4
use the CPU type definition added by the first patch,
and all the workarounds update silicon-errata.rst.

If preferred, I will resend them as separate patches.

This series is based on v7.3-rc7.

Best Regards,
Tomohiro Misono

Signed-off-by: Tomohiro Misono <misono.tomohiro@fujitsu.com>
---
Kohei Enju (1):
      irqchip/gicv3: Add workaround for FUJITSU-MONAKA erratum E#030003

Tomohiro Misono (3):
      arm64: cputype: Add FUJITSU MONAKA definition
      arm64: tlb: Add tlbi workaround for FUJITSU-MONAKA Erratum E#030001
      perf: arm_pmu: Add workaround for FUJITSU-MONAKA Erratum E#030002

 Documentation/arch/arm64/silicon-errata.rst |  6 ++++
 arch/arm64/Kconfig                          | 36 +++++++++++++++++++++++
 arch/arm64/include/asm/cpucaps.h            |  4 +++
 arch/arm64/include/asm/cputype.h            |  2 ++
 arch/arm64/include/asm/tlbflush.h           | 35 +++++++++++++++++++++++
 arch/arm64/kernel/cpu_errata.c              | 20 +++++++++++++
 arch/arm64/kvm/hyp/vhe/tlb.c                | 44 +++++++++++++++++++++++++++++
 arch/arm64/tools/cpucaps                    |  2 ++
 drivers/irqchip/irq-gic-v3.c                | 32 +++++++++++++++++++++
 drivers/perf/arm_pmu.c                      | 13 +++++++++
 10 files changed, 194 insertions(+)
---
base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
change-id: 20261002-monaka-fix-for-upstream-680801dea92f

Best regards,
-- 
Tomohiro Misono <misono.tomohiro@fujitsu.com>

