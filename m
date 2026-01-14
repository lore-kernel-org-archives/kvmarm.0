Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44D7D395263
	for <kvmarm@lists.linux.dev>; Wed, 14 Jan 2026 11:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768391931; cv=none; b=b56IBT1J8OyRYainTn52rVVdQRDh0cdP8DTu439ZE1rxVFSq22CNR9PXwVOgQFBTnpAK/lyqcS4XyZF6VP42tpxe7UGVWAnDoKs+FzzcyOsBnQMrA3d0YsPMboH0nmtOqWcY6f5Jh7+xib27TLLkkPZcZpeRvTIhNRN31uCButg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768391931; c=relaxed/simple;
	bh=sHU6Ozm+zslLq5gDaJSDJN+Dv4Cqt08DO2oJ/8Eihrg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=owGBj9tW4QZCmes4smHdYFDWxnD3gLMkLFAC1kEH3DL3fIT6EvPR5JxY/7LkKS94IwFupuEvPpZoG5g5vUE83hLekX0gk8+iXNX5bOf/r6eeBmSwcjiA3o9pVbIZux2jdnqpdw99aarsvYHIAbroTB9fs0tNVba8oJxn1I3+W78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F24ED1424;
	Wed, 14 Jan 2026 03:58:37 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 731D03F632;
	Wed, 14 Jan 2026 03:58:43 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v5 00/11] arm64: EL2 support
Date: Wed, 14 Jan 2026 11:56:52 +0000
Message-Id: <20260114115703.926685-1-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This series is for adding support to running the kvm-unit-tests at EL2.

Changes since v4[1]:
	- changed env var to support EL2=1,y,Y
	- replaced ifdef in selftest with test_exception_prep()

Thanks,
Joey

[1] https://lore.kernel.org/kvmarm/20251204142338.132483-1-joey.gouly@arm.com/

Alexandru Elisei (2):
  arm64: micro-bench: use smc when at EL2
  arm64: selftest: update test for running at EL2

Joey Gouly (9):
  arm64: set SCTLR_EL1 to a known value for secondary cores
  arm64: drop to EL1 if booted at EL2
  arm64: efi: initialise SCTLR_ELx fully
  arm64: efi: initialise the EL
  arm64: timer: use hypervisor timers when at EL2
  arm64: micro-bench: fix timer IRQ
  arm64: pmu: count EL2 cycles
  arm64: run at EL2 if supported
  arm64: add EL2 environment variable

 arm/cstart64.S             | 66 ++++++++++++++++++++++++++++++++++++--
 arm/efi/crt0-efi-aarch64.S |  5 +++
 arm/micro-bench.c          | 26 +++++++++++++--
 arm/pmu.c                  | 13 +++++---
 arm/run                    |  7 ++++
 arm/selftest.c             | 22 ++++++++++---
 arm/timer.c                | 12 +++++--
 lib/acpi.h                 |  2 ++
 lib/arm/asm/setup.h        |  8 +++++
 lib/arm/asm/timer.h        | 11 +++++++
 lib/arm/setup.c            |  4 +++
 lib/arm/timer.c            | 19 +++++++++--
 lib/arm64/asm/sysreg.h     | 19 +++++++++++
 lib/arm64/processor.c      | 14 ++++++++
 14 files changed, 208 insertions(+), 20 deletions(-)

-- 
2.25.1

