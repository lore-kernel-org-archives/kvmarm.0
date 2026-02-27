Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 501213563C2
	for <kvmarm@lists.linux.dev>; Fri, 27 Feb 2026 16:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772211576; cv=none; b=U8kngFoGqbN20duscfUi7UQDRKI/g3I1FG9KZJf4uqEbHVrs7WDKdZgOyma5iidAMPnqxInovBvjfHllTSdjLv8aAbVEkOv2fUhXP2a/QexhwCNJttjPLjSjkGCc/bP4cf9a2bu9lnsENBiJeXnv1lO6XhiRLfLbw9/tsnNsGCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772211576; c=relaxed/simple;
	bh=g//woHQxr4TOtSBosB0wddE9uoBB4QI9LTNK1GhCIvI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZQ7K6oqDRgrM4AgTAhq3NqYzNmONLOW6Qq8SLKhGGHJgSO0sGwoAfBVY+riXN/5I0UABk9IGnH/8F6ZAvcAQNkLxDYXo226a8UNHcjKT9/GNeE0VMIal4xdAZ1TJw5UMJu0KS+rKibOjHy0W8m9EqcyG3u7ziEYC50DwXhBIWCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6D07614BF;
	Fri, 27 Feb 2026 08:59:28 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7B6F83F73B;
	Fri, 27 Feb 2026 08:59:33 -0800 (PST)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	will@kernel.org,
	maz@kernel.org,
	tabba@google.com,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	alexandru.elisei@arm.com,
	oupton@kernel.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvmtool PATCH v6 00/17] kvmtool: arm64: Handle PSCI calls in userspace
Date: Fri, 27 Feb 2026 16:56:07 +0000
Message-ID: <20260227165624.1519865-1-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is version 6 of the patch series, originally posted by Oliver [0].

Use SMCCC filtering capability in to handle PSCI calls in the userspace.

Changes since v5:
Link: https://lkml.kernel.org/r/20260108175753.1292097-1-suzuki.poulose@arm.com
 - Fix build break by importing linux/const.h from Linux UAP headers
 - Clean up the util/update_headers, issue warning for missing files.
 - Fix the psci.h source to Linux UAPI headers.
 - Rebased to Linux headers v6.19 (to match the tip of the tree)

Changes since v4:
Link: https://lkml.kernel.org/r/20250930103130.197534-1-suzuki.poulose@arm.com

 - Update headers to v6.18
 - Remove duplicate assignment of pause_req_cpu (Marc)
 - Flip the command line to opt in for PSCI in userspace, retaining default
   in kernel handling. (Marc)
 - Collect Review from Marc, thanks!

Changes since v3:
 - Address Will's comment on the race between pause/resume - Patch 1
 - Rebase on to v6.17-rc7
 - Drop importing cputype.h, which was not used by the series

[0] https://lore.kernel.org/all/20230802234255.466782-1-oliver.upton@linux.dev/


Oliver Upton (12):
  Import arm-smccc.h from Linux v6.19
  arm64: Stash kvm_vcpu_init for later use
  arm64: Use KVM_SET_MP_STATE ioctl to power off non-boot vCPUs
  arm64: Expose ARM64_CORE_REG() for general use
  arm64: Add support for finding vCPU for given MPIDR
  arm64: Add skeleton implementation for PSCI
  arm64: psci: Implement CPU_SUSPEND
  arm64: psci: Implement CPU_ON
  arm64: psci: Implement AFFINITY_INFO
  arm64: psci: Implement MIGRATE_INFO_TYPE
  arm64: psci: Implement SYSTEM_{OFF,RESET}
  arm64: smccc: Start sending PSCI to userspace

Suzuki K Poulose (5):
  util/update_headers: Update linux/const.h from linux sources
  util/update_headers: Clean up header copying
  util/update_headers: Warn about missing header files
  update_headers: arm64: Track uapi/linux/psci.h for PSCI definitions
  arm64: Sync headers from Linux v6.19 for psci.h

 Makefile                            |   2 +
 arm64/include/asm/smccc.h           |  65 ++++++
 arm64/include/kvm/kvm-arch.h        |   2 +
 arm64/include/kvm/kvm-config-arch.h |   8 +-
 arm64/include/kvm/kvm-cpu-arch.h    |  30 ++-
 arm64/kvm-cpu.c                     |  51 +++--
 arm64/kvm.c                         |  20 ++
 arm64/psci.c                        | 207 +++++++++++++++++++
 arm64/smccc.c                       |  81 ++++++++
 include/linux/arm-smccc.h           | 305 ++++++++++++++++++++++++++++
 include/linux/const.h               |  53 +++++
 include/linux/kernel.h              |   3 -
 include/linux/psci.h                |  52 +++++
 kvm-cpu.c                           |  13 ++
 util/update_headers.sh              |  23 ++-
 15 files changed, 874 insertions(+), 41 deletions(-)
 create mode 100644 arm64/include/asm/smccc.h
 create mode 100644 arm64/psci.c
 create mode 100644 arm64/smccc.c
 create mode 100644 include/linux/arm-smccc.h
 create mode 100644 include/linux/const.h

-- 
2.43.0

