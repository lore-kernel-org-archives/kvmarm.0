Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76B991862
	for <kvmarm@lists.linux.dev>; Sun,  8 Mar 2026 23:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773011969; cv=none; b=R5CsI7Wd2HLLlEC/IvYIfIy8iW8in3QTocjpuAelp2o484JoD25DTcwqe5slRC5xzy89kmrPHeUD3ODcqP2NnSEcL3GfllMRjVOZ6ovbmpurlXcZaB19xAaMJkUGFY4IT2vSEgoV4E5Wim368osICuQWJfWOmTctdKLwuzZg5fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773011969; c=relaxed/simple;
	bh=YIn7dplVfHKPPksfmYcZc0WWNVrlXPZL31yKW3CaSiY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YXNvS9qOv+hT18viHSTj1dC5ClHTkx8/bVaJIMxS0prx8ArJugoUFPc3r2Rsw+D6PyLN+6PK5dEcQ6Vg95AJWqZ7lw3HZJ7iF97WJ2sr8vXrW0Y769Hu4yiGw8DPw4cCdoq19nT7Q1DDWFCDUfLulOIdsG3JuNAr8T0lLkbZ5o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 84B9D1D13;
	Sun,  8 Mar 2026 16:19:19 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 211A13F5CA;
	Sun,  8 Mar 2026 16:19:24 -0700 (PDT)
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
Subject: [PATCH RESEND 0/2] KVM: arm64: nv: Expose shadow page tables in debugfs
Date: Sun,  8 Mar 2026 23:18:27 +0000
Message-ID: <20260308231829.864983-1-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[sorry for the resend, I generated the cover letter with the wrong
commits previously, I should automate this :P]

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
  KVM: arm64: ptdump: Make KVM ptdump code s2 mmu aware
  KVM: arm64: nv: Expose shadow page tables in debugfs

 arch/arm64/include/asm/kvm_host.h |  7 ++++
 arch/arm64/include/asm/kvm_mmu.h  |  4 +++
 arch/arm64/kvm/nested.c           |  6 +++-
 arch/arm64/kvm/ptdump.c           | 60 ++++++++++++++++++++++---------
 4 files changed, 60 insertions(+), 17 deletions(-)

-- 
2.43.0

