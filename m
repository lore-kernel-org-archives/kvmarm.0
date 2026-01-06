Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1D5633F394
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 17:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721043; cv=none; b=DC4OAIEj+dMIvtlPS/NJ7x/6Q2dq78fsJVRSRFvKZ0iXGgSNeVRS6ZGq167Kd8qiNwHRGN2nMF8OaLAZO6PJ8XC9Vf41AjK/YfZx9Gz1w1OYs/jlwDq5tDg7FQfHTzf9VKFgI6TLCGvRT/Fe7GLoM5x6Q0kAr1SnUDREBeo4Vi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721043; c=relaxed/simple;
	bh=9fAUzjGsl7GVBB6yOH954237LkyGVIwz8P2bxtYC2J0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=thKDotCeTPCEUY+w+NdWhBx4FqmHApEU91HWR7K7/5BKjJ0QzZiuC5Dj8Q7ra2uqn/9AcgXbda2VHNKIbZZ0EyVXWmoRVYw1igeMzCbaW9AR9/+lORS5RbipwAjjZKXuW3EQZ95oSr4dpcnYZ3lNVAMfNKSvyNbXBSYWEk8vfjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 09D4D497;
	Tue,  6 Jan 2026 09:37:13 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 45A0F3F5A1;
	Tue,  6 Jan 2026 09:37:18 -0800 (PST)
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: broonie@kernel.org,
	catalin.marinas@arm.com,
	mark.rutland@arm.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	tabba@google.com,
	will@kernel.org
Subject: [PATCH 0/3] KVM: arm64: Trivial FPSIMD cleanups
Date: Tue,  6 Jan 2026 17:37:04 +0000
Message-Id: <20260106173707.3292074-1-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This series contains a few trivial cleanup patches left over from all
the FPSIMD/SVE/SME rework last year, all rebased atop v6.19-rc1:

* Patch 1 corrects a comment which I typo'd.
* Patch 2 repacks some flag indices to be adjacent.
* Patch 3 removes an unnecssary ISB.

I'm sending them now before I forget them for another few months.

Mark.

Mark Rutland (3):
  KVM: arm64: Fix comment in fpsimd_lazy_switch_to_host()
  KVM: arm64: Shuffle KVM_HOST_DATA_FLAG_* indices
  KVM: arm64: Remove ISB after writing FPEXC32_EL2

 arch/arm64/include/asm/kvm_host.h       | 10 +++++-----
 arch/arm64/kvm/hyp/include/hyp/switch.h |  6 ++----
 2 files changed, 7 insertions(+), 9 deletions(-)

-- 
2.30.2

