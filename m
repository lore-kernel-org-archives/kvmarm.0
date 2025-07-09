Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61E712877EC
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 09:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752053902; cv=none; b=Ine+mz8PAxuy0H2hS70Pq9TLr066dTNSQP6Dyh+A83/wTcQuWhNcFVLBRUZB9RRcu6X2Ve0MDijaXlUZ47Ali5VvcUJjqRVbfCkxVEf02CnxzbgPvHuiv08p7k2HMEy1w0rtq+tKNP4TJYNzx1fk4XX3qslkVLMcfW6eMAJB71c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752053902; c=relaxed/simple;
	bh=mjLMzIDwWbx4AkwCTV1y8FunILTBZWlCvO3Wg4zMasc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MpmofBvKHBq+eIG6fv8S6Y2cjyveZ0neMJ2UgaraViBatc5QErImnRplFHEhf7nWBjh+EtBMDbNKLrPgBDJBV6IJFuuPU1zFYHa78eOy4SD+gdp2w4ZOTqrcaLZxjTOalHgfRzLpjl4Y1HSl0rzh+ChzVdoR0+/oCwEe3UeikFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 07DB9153B;
	Wed,  9 Jul 2025 02:38:08 -0700 (PDT)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 947B43F738;
	Wed,  9 Jul 2025 02:38:17 -0700 (PDT)
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
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	linux-kernel@vger.kernel.org
Cc: james.morse@arm.com,
	Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH v2 0/2] Fix and add warning of misuse of type##_replace_bits()
Date: Wed,  9 Jul 2025 10:38:06 +0100
Message-ID: <20250709093808.920284-1-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

By inspection there is one mistake in the use of u64_replace_bits(). Fix
this and while I'm here add a __must_check annotation to help avoid the
same mistake happening again.

Changes since v1:

Patch 1: Add Rb tag from Zenghui Yu - thanks!
Patch 2: Extend to add __must_check on _get_bits() and _encode_bits()

Ben Horgan (2):
  KVM: arm64: Fix enforcement of upper bound on MDCR_EL2.HPMN
  bitfield: Ensure the return values of helper functions are checked

 arch/arm64/kvm/sys_regs.c | 2 +-
 include/linux/bitfield.h  | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

-- 
2.43.0

