Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AD471F9F47
	for <kvmarm@lists.linux.dev>; Fri, 28 Nov 2025 10:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764324613; cv=none; b=L9nSCmrz7tHoeDkPjOzFjuR/SBiM57wXeeXzTU0R3RGZVDEZd6m14NGQHCIuLOSsDTjgjs7bbGGTgzJtpeAQ1uAwIwJyB2R+VyvhoXotBKrZkrXa79SzBJQwXKGKs7dBDkjIr8P1/Le/H+JahbqW7EqsuuMJLwsizjIs5zPyFVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764324613; c=relaxed/simple;
	bh=UbxWBS69VnGjjVEE/uR3sKqctGGAJTyWYT+Pm5TQL50=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=AuM5lVESxqFoYUi6LgAaoFHF00U/bl18rbzKeY6IzJ8ijtXnZwuU0kUXBE1mOhutF+jbqW8ZeVPgTwn8UNDuyRlBYJE/kUV5eiD1h+Z6nH5kb7+u7pcsMlMlAAnvN5V0pMPvld6VfrPSOoIkOB4eqODHeOqrsbqG6xQ6LJiTcCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 07BAC176A;
	Fri, 28 Nov 2025 02:10:03 -0800 (PST)
Received: from e140010.arm.com (unknown [10.57.90.76])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F02BF3F73B;
	Fri, 28 Nov 2025 02:10:03 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	yuzenghui@huawei.com,
	suzuki.poulose@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH 0/4] KVM: arm64: nv: HAF fixes
Date: Fri, 28 Nov 2025 10:09:42 +0000
Message-ID: <20251128100946.74210-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Based on kvmarm's next branch.

HAF support for the software translation table walker was merged while I
was in the process of reading the patches, so instead of comments I have
these few fixes.

One thing I didn't touch is this sequence in hyp_set_prot_attr():

	if (prot & KVM_PGTABLE_PROT_X) {
		/* don't set the XN bit */
	} else {
		attr |= KVM_PTE_LEAF_ATTR_HI_S1_XN;
	}

If the caller is executing in nVHE mode, the translation regime is EL2,
which has only PrivExecute permission. Since KVM_PGTABLE_PROT_X is now the
union of PrivExecute and UnprivExecute, if the caller requests only the
UnprivExecute permission, but no PrivExecute permission, the function does
not return an error code and sets the PrivExecute permission.

Something similar happens in kvm_pgtable_hyp_pte_prot() - it will return
KVM_PGTABLE_PROT_X, which includes KVM_PGTABLE_PROT_UX (UnprivExecute) even
if the permission does not apply to the EL2 translation regime.

I have a feeling I am being too pedantic here, that's why I didn't propose
a fix. Though I thought it might be worth confirming that this isn't an
issue.

Alexandru Elisei (4):
  KVM: arm64: Document KVM_PGTABLE_PROT_{UX,PX}
  KVM: arm64: at: Use correct HA bit in TCR_EL2 when regime is EL2
  KVM: arm64: nv: Don't mask VTCR_EL2.HA if FEAT_HAFDBS is present
  KVM: arm64: at: Update AF on software walk only if VM has FEAT_HAFDBS

 arch/arm64/include/asm/kvm_arm.h     | 1 +
 arch/arm64/include/asm/kvm_pgtable.h | 4 +++-
 arch/arm64/kvm/at.c                  | 5 ++++-
 arch/arm64/kvm/nested.c              | 4 +++-
 4 files changed, 11 insertions(+), 3 deletions(-)


base-commit: 81410a2ac378414e9c60c34dac4e2c4d00969b46
-- 
2.43.0

