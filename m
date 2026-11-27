Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=139.138.61.253
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795757839;
	b=zosd0hWyPWRqq0++mw4mz+RZuYGX9Etcp89aNrrEPUs/rM8C0+eZFjXHnzoS0ZGixlbF
	 XfIELh2EKztDK2XAjfMt9XOkm6S3YnxEMEN0VOtyzvuGDwNZPzximaYzVEPECjua9Rg6U
	 p66/mjPTTpw+Kq5kuOgXZdITy2liYXqiVs1lYYe13F6g04wu/ijtblyacIaPYuYAXha03
	 K35UhfFMXYGQUx2dEkoldK82p7JS6UXa1NNM6HOivdRazptmdAx5XdTB9EEUYN1Bp9pIW
	 ykKq7uX49jYRdGLyFA+WrSVQkoaYm5DGBSxrmbiDzk2/wbGpRD8DZmq+HXcxCwTX2AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795757839;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:From:
	 Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-B4-Tracking:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=Ju+S9oyc85uwedQeaMX1bcIVrmnLI/frBGJF0DcZf6E=;
	b=Q75kThwWdDDZ8gxIeDyvo1VwKqAV2782+nXd6RiY4eDy7T1JXprpTGcERN4eqrvrOGte
	 moxk8XAlfWtbanGArA46ePMte//rwDF443pqs/3jLEHfa8d6iZjmCDDAx2WBLuydvVWOx
	 rTWetC/6zAFePiYQV0OdnPKMfEVF6JODXMLWPqINeG40wAmM0KGtOyeQ2QyLUKXTHf5t7
	 r5MIDWgB7Y42nyy9XtTpJV+SRKPX+DWO3vxxY2O3EW3Q52t05kFgl4uyKitqPBs+PI6+p
	 YqtxAM2J31vwnOVwjN/Cb/leUJkHadPygbrX28OEzGYscGFjPp8jnb9G6M+0MhZWrJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=DMVU9HxM;
	arc=none smtp.remote-ip=139.138.61.253
Received: from esa8.hc1455-7.c3s2.iphmx.com (esa8.hc1455-7.c3s2.iphmx.com [139.138.61.253])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73C3606A31E
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 05:37:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A73C3606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=DMVU9HxM
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1795757847; x=1827293847;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=idb+jXkILVxT03f1Wmltme/YCGuPkM4rAloBqQ13i5s=;
  b=DMVU9HxMOaDp2ZBKnaUgcMQd60ZV+PNQN7GkS6W+A69/ONkeCKXwn627
   1hJFK7eggyaCpYGr39bqp9RiLPhU9MAEhqdTgFAfbOhKrSE8TaEZL/Zzn
   mpNL2FqslZjPL1Y85ER7kmFeVE2NIDNktLG+uGStSOi6AEddVX6gs3RtG
   bJY35I5HMccDUL4v8LajvHUMkqyWyLsVgKzKM6n/3ghtJpQU8QLylIXFJ
   78r+Z4qmXonnn55O24ErUhCwYA1q98CxRMSqZdRdGDk5XYBnUUG/hcM8U
   8+wgG6Q2cqQQyNAnVtfbUD+/laDqj0SH3HGTaytlnfBB2gCfiN5BqzASi
   g==;
X-CSE-ConnectionGUID: wbjleI5bSIKwr5qCEvjGfQ==
X-CSE-MsgGUID: zH14mJv/Q+q7MTmK1naUBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11978"; a="251279391"
X-IronPort-AV: E=Sophos;i="6.27,236,1786978800"; 
   d="scan'208";a="251279391"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa8.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2026 14:37:19 +0900
Received: from az2uksmgm2.o.css.fujitsu.com (unknown [10.151.22.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 3468E8317F8
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 05:37:11 +0000 (UTC)
Received: from az2uksmom4.o.css.fujitsu.com (unknown [10.151.22.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm2.o.css.fujitsu.com (Postfix) with ESMTPS id D5B681801FDF
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 05:37:10 +0000 (UTC)
Received: from [127.0.1.1] (unknown [10.124.178.20])
	by az2uksmom4.o.css.fujitsu.com (Postfix) with ESMTP id E2031406873;
	Fri, 27 Nov 2026 05:37:02 +0000 (UTC)
From: Tomohiro Misono <misono.tomohiro@fujitsu.com>
Subject: [PATCH v4 0/5] arm64: Add workarounds for FUJITSU-MONAKA CPU
Date: Fri, 27 Nov 2026 14:36:29 +0900
Message-Id: <20261127-monaka-fix-for-upstream-v4-0-3395c415bbe4@fujitsu.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAN4WCWsC/4XNSw6CMBCA4auQrq2ZlsrDlfcwLko7lWqgpAWiI
 dzdwkaNIS7/ycw3EwnoLQZyTCbicbTBujaG2CVE1bK9IrU6NuHAMwbAaeNaeZfU2Ac1ztOhC71
 H2dCsgAKYRllyQ+J15zHurPL5Eru2oXf+uT4a2TL9b46MAhUSFVSgKkzFyQw324dhr1xDFnXkH
 xLLtiUeJaNy1Jib0ojiV0rfEmPltpRGCQ65NkJzJVP1Lc3z/AKELkvHVAEAAA==
To: Tomohiro Misono <misono.tomohiro@fujitsu.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Marc Zyngier <maz@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Radu Rendec <radu@rendec.net>, 
 Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Vladimir Murzin <vladimir.murzin@arm.com>
Cc: Kohei Enju <enju.kohei@fujitsu.com>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-perf-users@vger.kernel.org, 
 kvmarm@lists.linux.dev
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795757822; l=3047;
 i=misono.tomohiro@fujitsu.com; s=20261002; h=from:subject:message-id;
 bh=idb+jXkILVxT03f1Wmltme/YCGuPkM4rAloBqQ13i5s=;
 b=E8iwiA3EcZe5FSPZBag5pkUBQwUCUj0DqfD2h7OqcAjnzD2HeqTUwXIe9Y8NNlaHx/8Ef/ELv
 tqg7cY7bsKiDvn3NKaY++EwlUwqas92kYhYGa1ugGUVtHZl+tRooNmj
X-Developer-Key: i=misono.tomohiro@fujitsu.com; a=ed25519;
 pk=VLRxj5y4GJrHLmj3e2NBg30fX2U//ydi7c2G2qiNo10=

This series adds workarounds for the FUJITSU-MONAKA CPU.
Unfortunately, another erratum has been found since v2 and
I added patch 5 for this new workaround.
 - Patch 1 ... Add the FUJITSU-MONAKA CPU type definition
 - Patch 2 ... Add a workaround for TLBI operation
 - Patch 3 ... Add a workaround for perf operation
 - Patch 4 ... Add a workaround for GIC operation
 - Patch 5 ... Add a workaround for WFE operation

Although these workarounds do not depend on each other functionally,
I have combined them into one series because patch 2-5
use the CPU type definition added by the first patch,
and all the workarounds update silicon-errata.rst.

If preferred, I will resend them as separate patches.

Best Regards,
Tomohiro Misono

Changes in v4:
- Address Sashiko review, see each commits for the details
 - Rework TLBI workaround(patch 2)
 - Fix build error in GIC workaround(patch 4)
- Link to v3: https://lore.kernel.org/r/20261119-monaka-fix-for-upstream-v3-0-057df4d2ca3c@fujitsu.com

Changes in v3:
 - Add new workaround for WFE as patch 5
 - Address review comments in patch 2-4.
   Especially now patch 2 disables TLBI range operations on MONAKA CPU.
   See each commits for the details
 - Add Acked-by by Mark in patch 1
 - Rebased on 7.4-rc3
 - Link to v2: https://lore.kernel.org/r/20261016-monaka-fix-for-upstream-v2-0-fc7ede7f9f48@fujitsu.com

Changes in v2:
 - Address review comments in patch 2-4. See each commits for the details
 - rebased on 7.3-rc7
 - Link to v1: https://lore.kernel.org/r/20261002-monaka-fix-for-upstream-v1-0-4aec0b0cbe34@fujitsu.com

Signed-off-by: Tomohiro Misono <misono.tomohiro@fujitsu.com>
---
Kohei Enju (1):
      irqchip/gicv3: Add workaround for FUJITSU-MONAKA Erratum E#030003

Tomohiro Misono (4):
      arm64: cputype: Add FUJITSU MONAKA definition
      arm64: tlb: Add tlbi workaround for FUJITSU-MONAKA Erratum E#030001
      perf: arm_pmu: Add workaround for FUJITSU-MONAKA Erratum E#030002
      arm64: Add workaround to replace WFE with NOP for FUJITSU-MONAKA Erratum E#030004

 Documentation/arch/arm64/silicon-errata.rst |  8 ++++
 arch/arm64/Kconfig                          | 58 +++++++++++++++++++++++++++++
 arch/arm64/include/asm/assembler.h          |  4 ++
 arch/arm64/include/asm/barrier.h            |  3 +-
 arch/arm64/include/asm/cmpxchg.h            |  4 +-
 arch/arm64/include/asm/cpucaps.h            |  6 +++
 arch/arm64/include/asm/cputype.h            |  2 +
 arch/arm64/kernel/cpu_errata.c              | 32 ++++++++++++++++
 arch/arm64/kernel/cpufeature.c              | 17 +++++++++
 arch/arm64/tools/cpucaps                    |  3 ++
 drivers/irqchip/irq-gic-v3.c                | 35 +++++++++++++++++
 drivers/perf/arm_pmu.c                      | 13 +++++++
 12 files changed, 182 insertions(+), 3 deletions(-)
---
base-commit: b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f
change-id: 20261002-monaka-fix-for-upstream-680801dea92f

Best regards,
-- 
Tomohiro Misono <misono.tomohiro@fujitsu.com>

