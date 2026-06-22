Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FAF346A01
	for <kvmarm@lists.linux.dev>; Mon, 22 Jun 2026 19:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782155230; cv=none; b=M6QH6biVVYqCcalIYtLLvPGcJgXpOGJ5bMDQVw2npTgXaIJVkM2btRJHB2mOZ6TDvr8tmNRk+S1DDS0qLDeZFzSRgqNijR//8zjmM8PRDQpgPq66MqibM8aWLLft/bCASmkt7JDoxcx92cslUfHo8xn3t7PHFho9hW1NWdpgjgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782155230; c=relaxed/simple;
	bh=o8/ETh2KvvIGLooB5L6U1oBWO/K+boAmmF232hc/70k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=d0WckyFoovysVSNO4Ki4YQcSBk1rccU8Okl5rap7ZdAWd2X55/fD7riCpWeX8pxd0Ud0fs1fxvzBpk+dC0NTPwhGYUzSreHZTmzlB+wY+HCYQACZGqvWzFWkB+kZvZGHkOgHXxu2O+mZuZq947CVntMp+0Oa+2jcjB3riQj8AEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RYniqaT6; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RYniqaT6"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782155224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qOVFrG/Te+BEiiQDl3ih9whA6aExlG2UyJj9/8nk5R0=;
	b=RYniqaT6fK6bMzx3PMItfT0iElyVNpTiCHOLmEBQbYeohLMJKI0YyazkwTTuPCMclDKIS6
	mn3AaWuFRZ8Gp/1Bev/aKBUnUpOWql6bM+Efy4g9EMt1MgYl5SxjHPc5yxrAl30RBgS/rh
	dEJvHafxDiqUjncYWhOqNc7X5J7KsTg=
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
Subject: [PATCH 0/2] KVM: arm64: Fix and test MMIO sign-extending loads
Date: Mon, 22 Jun 2026 20:06:59 +0100
Message-Id: <20260622190701.2039766-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi folks,

A sign-extending load (LDRSB/LDRSH/LDRSW) from emulated MMIO returns a
zero-extended value rather than the sign-extended one the architecture
requires; vcpu_data_host_to_guest() strips the sign bits when it masks
the data to the access width.

If my git archeology is right, the masking dates to 2014 (b30070862edbd,
big-endian support) and has been wrong ever since, but sign-extending
loads from device memory are rare enough that nobody hit it. Patch 1
fixes it; patch 2 adds a selftest so it doesn't regress.

Cheers,
/fuad

Fuad Tabba (2):
  KVM: arm64: Fix sign-extension of MMIO loads
  KVM: arm64: selftests: Add MMIO sign-extending load test

 arch/arm64/kvm/mmio.c                         |   7 +-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/arm64/mmio_sign_ext.c       | 133 ++++++++++++++++++
 3 files changed, 138 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/arm64/mmio_sign_ext.c


base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
-- 
2.39.5

