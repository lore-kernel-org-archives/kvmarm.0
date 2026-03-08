Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8E4A30C361
	for <kvmarm@lists.linux.dev>; Sun,  8 Mar 2026 22:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773010687; cv=none; b=AE13u4TsY/9bCYENvT2r0y9t5Z1ep+Qc8KzJNRPgKeEI3T+/jbMGurBjNX6NJsqlM+6hz7WNzyXWCWDomjjBf9tJOLRPh62HqPGFfmW6jHjHcFTdOpZy963R5PDh0JLXMwTTTbUV3MNSLhjTwc76j+OhTFahGWG2me+wE8FGBls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773010687; c=relaxed/simple;
	bh=U7gWiSeuFcTw0KDF55OkdOVCRZ2uX7v92b6fs4PJtIU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eHVWqQImcs1uzav/qSRR09eZrZePd7rzNUtP13sRONbM4gHzUBbybtaAz2l2/bMAHbWOWgEuZzailokbINxxfCvM1cuHkklyi4Z3A52Fun8sXX5dpoYEuTt9bgcYFK4ge879pYvIwITncBPLgPRO3d0bntrLBO91A/sxhguzIF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 907971D13;
	Sun,  8 Mar 2026 15:57:57 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 70B3B3F694;
	Sun,  8 Mar 2026 15:58:02 -0700 (PDT)
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 0/2] KVM: arm64: nv: Expose shadow page tables in debugfs
Date: Sun,  8 Mar 2026 22:56:59 +0000
Message-ID: <20260308225701.863369-1-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series exposes shadow page tables in debugfs to improve the
debugability and testability of NV. First we teach the KVM ptdump code
to handle different s2 mmus, then shadow page tables are exposed. This
is gated also behind CONFIG_PTDUMP_STAGE2_DEBUGFS, like the canonical
stage-2 page table.

The file names for the shadow page tables are formatted
0x<vttbr>-0x<vtcr>-s2-{en,dis}abled, which is the most intuitive way of
identifying the s2 mmus but not terribly clear. For now I don't think of
other options that are meaningfully better, any suggestion welcome.

I realized I tend to write long variable and function names, happy to
change if anyone finds it too verbose.

Thanks!


Wei-Lin Chang (2):
  KVM: arm64: nv: Expose shadow page tables in debugfs
  basic L2 selftest

 arch/arm64/include/asm/kvm_host.h             |   7 +
 arch/arm64/include/asm/kvm_mmu.h              |   4 +
 arch/arm64/kvm/nested.c                       |   6 +-
 arch/arm64/kvm/ptdump.c                       |  27 ++
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/arm64/nested_reverse_map.c  | 236 ++++++++++++++++++
 .../selftests/kvm/include/arm64/processor.h   |  28 +++
 .../selftests/kvm/lib/arm64/processor.c       |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  13 +
 9 files changed, 323 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/arm64/nested_reverse_map.c

-- 
2.43.0

