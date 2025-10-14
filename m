Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 454522F5468
	for <kvmarm@lists.linux.dev>; Tue, 14 Oct 2025 10:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760437278; cv=none; b=Eug6TVdMW6HywEoxDXJGnEggQ5tevRFmTtZWaSPEJRli9C3M/ZnS5ZugNaX8cDqtTl+VC/l4dfDpyKodASlbW5/85pOghVx08cm01KFNm9QCgSZsgEHIotNXltOHPeHQeH2n9PUruyKWRf6bVSkzh2KwPaNX7fAvxw6+iSJB1e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760437278; c=relaxed/simple;
	bh=/DarjTY2o5nKRTrsiQwnrnJ42bafWIM90Ki1mpHGWEg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ffqwhGQ+vv2LtFkuB8jG/+/04h238Mproay/o0F6HdmqVuigFFS03xrKGmNau44PXTbcScsD3Rcyap0qlT2LX/6fwB589J8A5Je4nZKxBQlsDIsHWyN9Mj7Ahn48e0my2b38T4UPYegKN/rwW7IAGV8+xPuYLKW+6ujGFi84mlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A37C41A9A;
	Tue, 14 Oct 2025 03:21:08 -0700 (PDT)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D452E3F6A8;
	Tue, 14 Oct 2025 03:21:14 -0700 (PDT)
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
Subject: [PATCH 0/3] set_id_regs cleanup
Date: Tue, 14 Oct 2025 11:21:05 +0100
Message-ID: <20251014102108.2442391-1-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Tidies up a few small things in set_id_regs. The removal of
ARM64_FEATURE_FIELD_BITS touches other code only so much as it removes
the define but set_id_regs.c is the only place its used.

Based on v6.18-rc1

Ben Horgan (3):
  KVM: arm64: selftests: Count test_guest_reg_read() as a test
  KVM: arm64: selftests: Remove ARM64_FEATURE_FIELD_BITS and its last
    user
  KVM: arm64: selftests: Consider all 7 possible levels of cache

 arch/arm64/include/asm/sysreg.h                 |  2 --
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 14 ++++++++++----
 2 files changed, 10 insertions(+), 6 deletions(-)

-- 
2.43.0

