Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92504486BB9
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 17:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788282966; cv=none; b=ZoylekrBOTTg1LPZf2cWNeIUSYqbltm+6Yf4xeWE35SzLqcjx/ccWaczCEKvl9FIGhg+4JsdNeWZ0Ml3b1xZZOuILwDiFEUtASlNQ4RjrXBa3wWNnqFYOLZ34La1CRlCHYbKAjKk1mHgNV/spfs3cXla02giw57d0edGUJT0orU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788282966; c=relaxed/simple;
	bh=LPbF21iE9ep8LNYPWYLCmBh5eBtWwnTLW2zpejTK+uM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mTbftyq8f/Fpoq7tWHrkuoqCQEEWigFaM7/IJbngdTBvMz0weyB59NGwlKMdPWpKGu4Bp7Jn1XGH+7uThRU7t6l95l0OOZ1AosKRtCuSkTM97kzf5pVhYb/gLBWZqQFEt46I73Jq87QMWPM9mVYG9bw0p1Fk75YUgZeWom0pHsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BLJGPw59; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BLJGPw59"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 23B441756;
	Tue,  1 Sep 2026 10:16:00 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DABA83F7D8;
	Tue,  1 Sep 2026 10:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788282963; bh=LPbF21iE9ep8LNYPWYLCmBh5eBtWwnTLW2zpejTK+uM=;
	h=From:To:Cc:Subject:Date:From;
	b=BLJGPw59ghk0iGEn/Xo+nJCxYpjfDuyKJQ/An5HQZwkuFRmeCug1iR1JoCNTkGxz1
	 cY+PoFVYEB2SO/PfWwx4+sUVA4oOvbDqq/p7yYpHoBq4/C0Ft8jauPMOy1fuagqg+U
	 5x+ShIzKTjsojlTYEmmdHEqEq0TD+k/bUK5fLASE=
From: Leonardo Bras <leo.bras@arm.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Tian Zheng <zhengtian10@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/5] KVM: arm64: New PTE dirty-page encoding, HAFDBS new usage
Date: Tue,  1 Sep 2026 18:15:51 +0100
Message-ID: <20260901171558.2674031-1-leo.bras@arm.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2083; i=leo.bras@arm.com; h=from:subject; bh=LPbF21iE9ep8LNYPWYLCmBh5eBtWwnTLW2zpejTK+uM=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLKms82R+l6aLevoLPTlevrjXj+xN0X5Dw80573/FLDZL OEZ5/QLHaUsDGJcDLJiiiyyj+av4vk+JePIlR8LYOawMoEMYeDiFICJWDAx/M822rbU95bGj2U7 BIREbi46WyIsOXGdcyy/imhR69apEpwM/0PLPCdczPnF+W1Ga8H74w7V9z0XvvvxSWi96/uv32W CPdgA
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit

This series have 2 main goals:

1 - Patches #1,#2,#3 : Change the PTE descriptor to use WD/WC/RO encodings
    making use of the DBM bit, adapting all usages, and
2 - Patches #4,#5 are an RFC on using HAFDBS on a guest to avoid resetting
    all PTEs to WC when dirty-logging starts, speeding-up startup.

(1) will also introduce a new walker for cleaning the dirty-bit, which will
clear the DBM bit if it's a block mapping (hugepage). This is needed as on
lazy-splitting we need to fault a write so we can do the lazy splitting.
This is needed for both the next patches, and for HDBSS & HACDBS
enablement.

On (2), I really just want feedback to understand if it's worth pursuing.
My main idea is that we can use HAFDBS _outside_ dirty-logging to only mark
dirty the pages that were actually written to. That is supposed to make it
faster to transverse the pagetables when we need to clean the dirty-bit, as
there is potentially less atomic writes to perform. The price paid for that
is disabling HAFDBS on every vcpu before we can start cleaning the pages,
done by a (new) vcpu request.

Please let me know of what do you think!

Thanks!
Leo

Leonardo Bras (5):
  KVM: arm64: pgtables: Change write bit from S2AP_W to DBM
  KVM: arm64: Add KVM_PGTABLE_PROT_DIRTY
  KVM: arm64: Introduce a dedicated walker for stage2 write-protect
  KVM: arm64: Add KVM_REQ_RELOAD_STAGE2
  KVM: arm64: Enable HAFDBS for guests not on migration

 arch/arm64/include/asm/kvm_host.h    |  2 ++
 arch/arm64/include/asm/kvm_mmu.h     |  6 ++++
 arch/arm64/include/asm/kvm_nested.h  |  9 +++--
 arch/arm64/include/asm/kvm_pgtable.h | 12 +++++--
 arch/arm64/kvm/arm.c                 | 15 ++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 49 +++++++++++++++++++++-----
 arch/arm64/kvm/mmu.c                 | 51 ++++++++++++++++++++++------
 arch/arm64/kvm/nested.c              |  4 ++-
 arch/arm64/kvm/ptdump.c              | 10 ++++--
 9 files changed, 130 insertions(+), 28 deletions(-)


base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
2.55.0

