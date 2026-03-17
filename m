Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F3161A0BD6
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 18:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773772047; cv=none; b=oyxxbvuXVC4yu604sOmhv8MVLeGGx18mRGOFUjKveV6uLIVvRFWtzqCHX01KRnXaSckJEmTfyjF817AYgLu5dpxDAJO6PjSyMAZv56MGK3orKEvdB0MNWPkHM0sm1P93WBYhkkYbcU9LRt5GezusJ7jEZp7RD3Yv0ejHCjWTAys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773772047; c=relaxed/simple;
	bh=yTP78qyzL3FsYqNqAoQ+oISmjDoRD8tiqYXpY+JKtac=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=twIFPiTUBi9CgSg/XEwfzuJlE+3cHtApD0P/QUn7w2/gSmoco5tjseoJ3WRcTJNRICPZ4CI56rd0NlWvL8sweY34zNCkU3Pm3JRB6X8K69hQ4koHlFV4EZQBGBaMZ2qf4398RzMu4sk7q18xgcKL4VDXUg6LUHQi2qrzit77Q3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C01FC1477;
	Tue, 17 Mar 2026 11:27:18 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 417BB3F7BD;
	Tue, 17 Mar 2026 11:27:23 -0700 (PDT)
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
Subject: [PATCH v2 0/2] KVM: arm64: nv: Expose shadow page tables in debugfs
Date: Tue, 17 Mar 2026 18:26:36 +0000
Message-ID: <20260317182638.1592507-1-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is v2 of exposing shadow page tables in debugfs, there are a few
small improvements, please see below.

Changes in v2:
 - move debugfs_nv_dentry also behind CONFIG_PTDUMP_STAGE2_DEBUGFS
 - use a macro to define the file names of shadow ptdumps, also
   explicitly spell out the string to get its maximum size
 - add Reviewed-by tag from Sebastian (thanks!)
 - Link to v1: https://lore.kernel.org/kvmarm/20260308231829.864983-1-weilin.chang@arm.com/

Wei-Lin Chang (2):
  KVM: arm64: ptdump: Make KVM ptdump code s2 mmu aware
  KVM: arm64: nv: Expose shadow page tables in debugfs

 arch/arm64/include/asm/kvm_host.h |  9 +++++
 arch/arm64/include/asm/kvm_mmu.h  |  4 +++
 arch/arm64/kvm/nested.c           |  6 +++-
 arch/arm64/kvm/ptdump.c           | 60 ++++++++++++++++++++++---------
 4 files changed, 62 insertions(+), 17 deletions(-)

-- 
2.43.0

