Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DFC3201;
	Tue,  1 Oct 2024 11:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727782274; cv=none; b=oABmKVO/J15wC0JsmWr1nzo79cQooOOFTnZgzq9ns9rjX5DP7RaIH4oDOtT8HgUjEaZelQshRpvW77oaB9cs67y5Bdn1EKF6cMjvk1WUibjh4b3HqDRZoua8FymvYJzleNBzO2aZBHci0MotAaz2wpP88v2ENmDW2GwhUsx5gcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727782274; c=relaxed/simple;
	bh=+SrMuE+SoZT7DS0QWsNQUTjAQrr6pG39ChBTBw8C2SA=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=mAq7g4TDjmiHt9xd/koBYiQo+PkP3vYuv7dzO2FSJ5p++Br4OOEm/8TxKQbxWUOSQ0vmLinujoC62WyxvehcDL4Df17t0i0HkoUOMR8/bz+l248jdpmNQ+JN1hHM6C9S5r90g2RskfRWp0kuXZdbn9WT8LYC4Xkwj3sAMNMDQK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VMZANMRJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VMZANMRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE79C4CEC6;
	Tue,  1 Oct 2024 11:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727782273;
	bh=+SrMuE+SoZT7DS0QWsNQUTjAQrr6pG39ChBTBw8C2SA=;
	h=From:Subject:Date:To:Cc:From;
	b=VMZANMRJfCN7tc6o4R68WmEuFqzbBbbNh5U7JcM646/TEMwiXuklg2yLcOT3Zxtzy
	 vtnWhtq7MZIbDy/g22jymIFz4NMOXlnNzhNv6C+Gxvb54kvcsow2Uvhu8CiZO7kVx8
	 GC1fSwnv7+L1+2yraYuS1k+10zTlsgXUIjcS0gm366SmrUI0EfFLa+jNYMx9A/OUTk
	 Fhll32wbymRq5TFu1Zu9WYSAVz+USTGdd4oR7NOh6/YyaYDWI+FQCNTvBb5ut0RDYN
	 KjnuV3wQx+eIMHUndc8mnLORPwkJyqzmdRKPVT/7M+z5eRQAt15wMQUrA5koBeIJ79
	 mPedWtZpkBZDQ==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH v7 0/4] KVM: arm64: Fix underallocation of storage for SVE
 state
Date: Tue, 01 Oct 2024 12:29:05 +0100
Message-Id: <20241001-kvm-arm64-fix-pkvm-sve-vl-v7-0-7b0171a36695@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAHd+2YC/33QTWrDMBAF4KsErauin9FIyar3CF1Y1jgRSewgF
 ZESfPfKgVIXg5ZvmPkG3pNlSpEyO+yeLFGJOU5jDfZtx/pzN56Ix1AzU0KBQAH8Um68SzcEPsQ
 Hvy8xF+LlyqXug5VDsMELVu/vierKyz5+1nyO+WtK369XRS3TXxUbalFc8N65AciDl+A/LpRGu
 r5P6cQWtsg1ZVqUrBQ6EdCD9tDLDaXXlG1RulJmT9ZJKzCg2VDwR9lmbQUq5dHtXeeVDj1sKLO
 mXIsylQpKWmO1A4PbrnBFadGicKm9I9cpEj4g/qPmef4BANhRqToCAAA=
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-99b12
X-Developer-Signature: v=1; a=openpgp-sha256; l=3017; i=broonie@kernel.org;
 h=from:subject:message-id; bh=+SrMuE+SoZT7DS0QWsNQUTjAQrr6pG39ChBTBw8C2SA=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBm+917W0zyKEOxeLKUfLoWm9dMufg/yMmKBCEbdYnW
 hrrEhOqJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZvvdewAKCRAk1otyXVSH0NoNB/
 9mXRyA+ZHKb9RvQIPk0kZP4kdYzbOJR6x8Vak4mEsrGfZz26OBrJz4Z0uJScvLsxfCYGDeqq6EBInz
 VuGwnermd+QIDbG9p6PqMDoFMCd/NkrSFgtQ7L9VFcaR6t6U0Rg4ic9fX0ICOqeIqT62KQbd9kDfv+
 Em0XIvsW85nKJ7158Zv0wfg14wRY6VWz3gmpvSHJ4rci7QkhHHzDajMXbiBNwdPis0W7YxPjUz1IEf
 ZFoaPaYoXpUaS3su6npr1FyJNq9xuK/PtX00Hxm4J5hCipG3fSyscUwdJ5SIE+AlgjtCe4nSffwMKA
 8znrmUfu74BZgbviEqETEwt+XaegUQ
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

As observed during review the pKVM support for saving host SVE state is
broken if an asymmetric system has VLs larger than the maximum shared
VL, fix this by discovering then using the maximum VL for allocations
and using RDVL during the save/restore process.

Fuad posted[1] another attempt to address this issues but as indicated
in review I have maintanability concerns since the VL configuration does
not follow best practices and the enumeration is not well integrated
with the rest of the enumeration code.  I also posted[2] an alternative
which restricts the host to the maximum shared VL.

This bug has persisted for multiple kernel releases at this point in
spite of being identified prior the original patch being applied.

[1] https://lore.kernel.org/r/20240606092623.2236172-1-tabba@google.com
[2] https://lore.kernel.org/r/20240912-kvm-arm64-limit-guest-vl-v2-1-dd2c29cb2ac9@kernel.org

Signed-off-by: Mark Brown <broonie@kernel.org>
---
Changes in v7:
- Rebase ont v6.12-rc1.
- Link to v6: https://lore.kernel.org/r/20240730-kvm-arm64-fix-pkvm-sve-vl-v6-0-cae8a2e0bd66@kernel.org

Changes in v6:
- Rebase onto v6.11-rc1.
- Link to v5: https://lore.kernel.org/r/20240708-kvm-arm64-fix-pkvm-sve-vl-v5-0-d2175738456b@kernel.org

Changes in v5:
- Clarify commit message on patch 3.
- Link to v4: https://lore.kernel.org/r/20240704-kvm-arm64-fix-pkvm-sve-vl-v4-0-b6898ab23dc4@kernel.org

Changes in v4:
- Roll in Catalin's acks.
- Link to v3: https://lore.kernel.org/r/20240607-kvm-arm64-fix-pkvm-sve-vl-v3-0-59e781706d65@kernel.org

Changes in v3:
- Replace %u with %lu in late CPU error message.
Changes in v2:
- Downgrade check for a late CPU increasing maximum VL to a warning only
  but do it unconditionally since pKVM prevents late CPUs anyway.
- Commit log tweaks.
- Link to v1: https://lore.kernel.org/r/20240605-kvm-arm64-fix-pkvm-sve-vl-v1-0-680d6b43b4c1@kernel.org

---
Mark Brown (4):
      arm64/fpsimd: Introduce __bit_to_vl() helper
      arm64/fpsimd: Discover maximum vector length implemented by any CPU
      KVM: arm64: Fix FFR offset calculation for pKVM host state save and restore
      KVM: arm64: Avoid underallocating storage for host SVE state

 arch/arm64/include/asm/fpsimd.h         | 17 +++++++++++++++
 arch/arm64/include/asm/kvm_host.h       |  2 +-
 arch/arm64/include/asm/kvm_hyp.h        |  3 ++-
 arch/arm64/include/asm/kvm_pkvm.h       |  2 +-
 arch/arm64/kernel/fpsimd.c              | 38 +++++++++++++++++++++++++++------
 arch/arm64/kvm/hyp/fpsimd.S             |  5 +++++
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  6 +++---
 arch/arm64/kvm/hyp/nvhe/pkvm.c          |  2 +-
 arch/arm64/kvm/reset.c                  |  6 +++---
 10 files changed, 65 insertions(+), 18 deletions(-)
---
base-commit: 9852d85ec9d492ebef56dc5f229416c925758edc
change-id: 20240604-kvm-arm64-fix-pkvm-sve-vl-13cd71fd7db0

Best regards,
-- 
Mark Brown <broonie@kernel.org>

