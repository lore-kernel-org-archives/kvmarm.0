Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755CA3FBB50
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 11:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783338940; cv=none; b=E+hEUU82Td2VuqQWjNxJYh4MMGWETk1yag9a9B5cyQvbh0gcNjW0KnAEurGf5UlFPK76+eBI4y3llPJhwszfLV6qUjUG2EVxrJnrGMtezoItLC653aaECk+9yxs1/p036/xa2siXxvayjYFEm7fSZRnUYgBiMmWScO4/L7bbtYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783338940; c=relaxed/simple;
	bh=AMdW6H3+3SGI8l0328lJg+GUpNhMSpQ1XU29cDO6a8g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=d7XMCEak6h4KnotGGwpsQlThQW3PnEoXEhkR10s8eLnG90CDbCSNtpyllpn2YBu6zcIiBnoOGXyOC5DTHAaFun2+qSP1Hd4f4YL8XbNWIjNyhNSeCgdw6TwOSM2o7URCtzuigwPoHz/7830JZGtyLmElvLbZpzjwjyd66HVglis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RPo4BBm4; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RPo4BBm4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783338937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0KqFlUzI+r7fz8PgRhgJxiSLsepZs7soxZuF0t57/Ms=;
	b=RPo4BBm4aFVqEWQ9X2uWnhT6L/zSSk1BSwIwOxf83fMSxGrVOPE+oS9itsN1gpgRxm7QbX
	AuA4dTuQ1xdyN6LMfnQXrz+A9Czsvc324ya/QDBEI2wiZLd3WpphMQLzoHP3LjLi+waey2
	Im7j7sakINsdCXsiP9ctbbZKB7y8XKA=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Christoffer Dall <christoffer.dall@linaro.org>,
	Victor Kamensky <victor.kamensky@linaro.org>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] KVM: arm64: Fix and test MMIO sign-extending loads
Date: Mon,  6 Jul 2026 12:55:20 +0100
Message-Id: <20260706115522.954913-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi folks,

Changes since v2 [1]:
  - Patch 2: dropped the second make_el0_accessible() call and the
    el0_be_loads_end symbol; the EL0 code page does not need its
    user-access bit set because it is fetched, not loaded. (sashiko)

Oliver's Reviewed-by is on patch 1 only: the code there is unchanged
since v1.

A sign-extending load (LDRSB/LDRSH/LDRSW) from emulated MMIO returns a
zero-extended value rather than the sign-extended one the architecture
requires; vcpu_data_host_to_guest() strips the sign bits when it masks
the data to the access width.

If my git archeology is right, the masking dates to 2014 (b30070862edbd,
big-endian support) and has been wrong ever since, but sign-extending
loads from device memory are rare enough that nobody hit it. Patch 1
fixes it; patch 2 adds a selftest so it doesn't regress.

Both passes run under QEMU, which reports mixed-endian support.

Based on Linux 7.2-rc2 (8cdeaa50eae8d).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260625144807.2603272-1-fuad.tabba@linux.dev/

Fuad Tabba (2):
  KVM: arm64: Fix sign-extension of MMIO loads
  KVM: arm64: selftests: Add MMIO sign-extending load test

 arch/arm64/kvm/mmio.c                         |   7 +-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/arm64/mmio_sign_ext.c       | 255 ++++++++++++++++++
 3 files changed, 260 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/arm64/mmio_sign_ext.c

-- 
2.39.5

