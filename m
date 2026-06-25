Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68679375F8E
	for <kvmarm@lists.linux.dev>; Thu, 25 Jun 2026 14:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782398898; cv=none; b=WrXTg7lVDST5Tu1PF2GdzoDjuyE4tgNMzTWj3m8gGrJcFYnxffvO3hBopxrfLHJZ9vfSv3plWH9YH/K2H7Nux7AifvId/MEdE5IW8mIYkYKPl64Lu0aIj0cqRJ4EQNcBuRGM86fkSQ/f8SdoR0FAv2XjlvyQV85Z3PctSdLi0EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782398898; c=relaxed/simple;
	bh=32dE08MPYNTPLVGV+WUPAm39Mjl3xoarW75Qi1CZb2E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sBbkxj1h0NrQyFprLWebMiwdzonkBKlEYqp3rm/or1c8ClhZ05Jo/xBTTWjOjym4Q1Mwgm2ID6AKGl/mPnnRyvgO3t8iqlKXZBmPlU15GwBX5byYzeYk7PDc4Fk/hRX5W6rJI4gtswxQiTCIqnE9L6GjvQvITGTJQBgUMfXY8HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jhMVHxVx; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jhMVHxVx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782398893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=EGMmvy6ftzwFlTcHswppZl2sY7USu5gMaULF9M6YB6U=;
	b=jhMVHxVxPkeFP3VUyjIWb7QSDQ3VqU1gMzHLWFb3Th48bXl+vcZtTvBWYyxhcNdlyVLdou
	tvkrP+MO8FTbk1ygyjZgOO+98W064LMV9LAEL6o853vTlXdQNeoZpRSHJFpn6jGJUkjOMd
	AGT7OyMCawE4DXBtOn7g2vT83VPDCis=
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
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] KVM: arm64: Fix and test MMIO sign-extending loads
Date: Thu, 25 Jun 2026 15:48:05 +0100
Message-Id: <20260625144807.2603272-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi folks,

Changes since v1 [1]:
  - Patch 1: rewrote the commit msg in the Arm ARM's terms, with the Mem
    accessor performing the access keyed on the access size and SignExtend
    handling the register width. No code change. (Marc)
  - Patch 2: added a big-endian pass to the test. The big-endian loads run
    at EL0 with SCTLR_EL1.E0E set, so the access is big-endian while the
    stage-1 walk stays little-endian. (Marc)

Oliver's Reviewed-by is on patch 1 only: the code there is unchanged, while
the test in patch 2 gained the big-endian coverage above.

A sign-extending load (LDRSB/LDRSH/LDRSW) from emulated MMIO returns a
zero-extended value rather than the sign-extended one the architecture
requires; vcpu_data_host_to_guest() strips the sign bits when it masks
the data to the access width.

If my git archeology is right, the masking dates to 2014 (b30070862edbd,
big-endian support) and has been wrong ever since, but sign-extending
loads from device memory are rare enough that nobody hit it. Patch 1
fixes it; patch 2 adds a selftest so it doesn't regress.

Based on Linux 7.1 (8cd9520d35a6c).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260622190701.2039766-1-fuad.tabba@linux.dev/

Fuad Tabba (2):
  KVM: arm64: Fix sign-extension of MMIO loads
  KVM: arm64: selftests: Add MMIO sign-extending load test

 arch/arm64/kvm/mmio.c                         |   7 +-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/arm64/mmio_sign_ext.c       | 259 ++++++++++++++++++
 3 files changed, 264 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/arm64/mmio_sign_ext.c

-- 
2.39.5

