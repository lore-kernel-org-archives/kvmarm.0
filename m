Received: from out-193.mta1.migadu.com (out-193.mta1.migadu.com [95.215.58.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0403B7A7
	for <kvmarm@lists.linux.dev>; Thu,  5 Oct 2023 18:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Uzgc9b0u"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1696529026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Tureg2m9XbvXMu5THHgF3eRFwznEfRjXAAD0FdkzkLo=;
	b=Uzgc9b0uCw1rPM/5/bI9rx+0ms7sEWeBrThOZwMJ1sOKo3tblQr7qosDLovH7xUPOpnhwd
	thuyI92s3Es6QzinXVu8YJTPEjeKMgAftMMgE/0pikHc9IWvRTn5G4ZPe62p6iPzedyqi4
	Nm882lSOyb+zZJuqRkN5En9lZyC+mjg=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/2] tools: arm64: Sync sysreg.h with the kernel
Date: Thu,  5 Oct 2023 18:03:22 +0000
Message-ID: <20231005180325.525236-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM selftests needs to use the full set of sysreg definitions for an
upcoming change [1]. We took a stab at copying the entire sysreg
generation infrastructure into the tools directory, but that exploded
and broke the build for perf, oops [2].

Short of better build infrastructure in tools for handling common
prerequisite tasks, this series takes the lazy route and copies the
generated output of the sysreg infra from the kernel.

Plan is to apply this series as part of the 'writable' ID register
series, replacing the broken change.

[1]: https://lore.kernel.org/kvmarm/20231003230408.3405722-13-oliver.upton@linux.dev/
[2]: https://lore.kernel.org/linux-next/20231005123159.1b7dff0f@canb.auug.org.au/

Jing Zhang (1):
  tools: arm64: Sync sysreg.h with the kernel source

Oliver Upton (1):
  tools: arm64: Add a copy of sysreg-defs.h generated from the kernel

 tools/arch/arm64/include/asm/gpr-num.h        |   26 +
 tools/arch/arm64/include/asm/sysreg-defs.h    | 6806 +++++++++++++++++
 tools/arch/arm64/include/asm/sysreg.h         |  839 +-
 .../selftests/kvm/aarch64/aarch32_id_regs.c   |    4 +-
 .../selftests/kvm/aarch64/debug-exceptions.c  |   12 +-
 .../selftests/kvm/aarch64/page_fault_test.c   |    6 +-
 .../selftests/kvm/lib/aarch64/processor.c     |    6 +-
 7 files changed, 7038 insertions(+), 661 deletions(-)
 create mode 100644 tools/arch/arm64/include/asm/gpr-num.h
 create mode 100644 tools/arch/arm64/include/asm/sysreg-defs.h

-- 
2.42.0.609.gbb76f46606-goog

