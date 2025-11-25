Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B3C42BF001
	for <kvmarm@lists.linux.dev>; Tue, 25 Nov 2025 10:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764065541; cv=none; b=JjGBiyDrhtP7/Ad7F1C/r9yRgQUhqPMsbqzxGIjYLM1ESPuwQDoEaH9CFsoSqDfb8vR5VQfMsS/QHVY2ub6sY0tcGh0QOusyGY3PKYgaff2v+6eZ69n4ojeLQEfySHxejFrnQyfljJuA+tapfopbg2hjjlaaxx+l1wH/nWX42n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764065541; c=relaxed/simple;
	bh=E+r2yQ+Qzz1Idg8/S7sGGPH7vET6sQnlFB655QvH41I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=URNA1G5lc/f5rWXXlSxmE4OkOvXyMA6rWZB7N8FOvlPqFKSX1zVnQNEIVIcC9gtuVqmQxViBBY7XKWTyzGllql/CmwkYw2T4ZxiHOtk7RS4zKFogA/0zmPXxwrRdwq7QxGKJELjLiGdVyYKDXzCLjP9H2ogJWeopoP6k2Nzofqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E1A641477;
	Tue, 25 Nov 2025 02:12:10 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B35C13F86F;
	Tue, 25 Nov 2025 02:12:16 -0800 (PST)
From: Ben Horgan <ben.horgan@arm.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	shuah@kernel.org
Cc: Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH v2 0/2] set_id_regs cleanup
Date: Tue, 25 Nov 2025 10:12:05 +0000
Message-ID: <20251125101207.1492580-1-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For this v2 I've dropped the ksft_test accounting fix. Mark Brown has
more extensive changes [1] and looks to be a user of the set_id_regs
test rather than someone just doing some cleanup. The other change in
this series is to remove ARM64_FEATURE_FIELD_BITS from the tools
sysreg.h header rather than the kernel version. I'll send a separate
patch to remove the kernel version.

Tidies up a few small things in set_id_regs. The removal of
ARM64_FEATURE_FIELD_BITS touches other code only so much as it removes
the define but set_id_regs.c is the only place its used.

Based on v6.18-rc4

Link to v1: https://lore.kernel.org/kvmarm/20251114-kvm-arm64-set-id-regs-aarch64-v2-0-672f214f41bf@kernel.org/

[1] https://lore.kernel.org/kvmarm/20251114-kvm-arm64-set-id-regs-aarch64-v2-0-672f214f41bf@kernel.org/

Ben Horgan (2):
  KVM: arm64: selftests: Remove ARM64_FEATURE_FIELD_BITS and its last
    user
  KVM: arm64: selftests: Consider all 7 possible levels of cache

 tools/arch/arm64/include/asm/sysreg.h           |  2 --
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 10 +++++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

-- 
2.43.0

