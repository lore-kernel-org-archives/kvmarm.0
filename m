Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6903F49640;
	Thu,  4 Jul 2024 17:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720114123; cv=none; b=N2aBdeSD7keUNouFHjrgbAjL1fvP4t+twtLBwec2dXoO73sA7JzQjlq3HFc7lP5oMVi7ZcCuH+QhLWS/W685G9FyN98c0LVBDf6DH+YAsyRNywVS7jRZF7WNFGGpQV5fOg9mUL/UTbYy4Lqsze9bPuj5GqTnqrXBv3MWQN9n3aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720114123; c=relaxed/simple;
	bh=tAfv1BaL1iUUqXnX9Z5FvigYgE4xYEQucoc/CaZ1L6k=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=n0vYzDTeRkCLtHN8WtvwCN5W3M2vyWuYKtjkPMklrbHHSasdeH6cavFIgJGDzRATwkW2Fr83e8HEO7XSWVMppJ8bb0RsOysXW7SqCZqxcvAJXQQ/Ly9u8Qi+1N+WxFYu1ST0wQHC02zm5n6vFYiU9TY5/aroYas5/H5wZJ6KgWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ixopY0S8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ixopY0S8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E9CC3277B;
	Thu,  4 Jul 2024 17:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720114122;
	bh=tAfv1BaL1iUUqXnX9Z5FvigYgE4xYEQucoc/CaZ1L6k=;
	h=From:Subject:Date:To:Cc:From;
	b=ixopY0S8I3pDbvaHEwwlvybyzT7wY8SOEyc03XGKGvSSqyyKIZN13TNL8vL+J6AXU
	 jC/N6/zsV81jQBLUkWkor9eFCGqz+cgZd84mVZziThOJHK/X+hfv6rTsJM8XN9QXRj
	 pvOK8kjcs23VYIy6NFChLSP2Ncstcw7F1kemtsXmMz55rdWVFRPn0c82a21xqOcDTS
	 QBf1WjnF0PXl9nkRTRvqx9io4UKh/02aarx2J4GyIsx2eCQJiuvanpFHtdC0HIId5z
	 /Gap+LDt+KfWJg+cHVAtDHJLCSSzV7F0/iIV13wX9BPabmiTOF8799tSFKwDwPPnDm
	 z3BwMVt7i8DnA==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 0/4] KVM: arm64: Fix underallocation of storage for SVE
 state
Date: Thu, 04 Jul 2024 18:28:15 +0100
Message-Id: <20240704-kvm-arm64-fix-pkvm-sve-vl-v4-0-b6898ab23dc4@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALDbhmYC/33NzQrCMAzA8VcZPRtpu6ydnnwP8WDXbCv7pJWiy
 N7dThAUYcd/SH55skDeUWDH7Mk8RRfcNKbAXcaq9jo2BM6mZpJL5IojdHGAqx8UQu3uMK8ZIkH
 sQeSV1aK22hrO0v3sKa287fMldevCbfKP96so1+lHVRtqlMChKssayaARaE4d+ZH6/eQbtrJRf
 FPFFiUSpUpulcHcYCX+qPyb0ltUnqjiQLoUmiurih9qWZYXCmQaqVkBAAA=
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.14-dev-d4707
X-Developer-Signature: v=1; a=openpgp-sha256; l=1908; i=broonie@kernel.org;
 h=from:subject:message-id; bh=tAfv1BaL1iUUqXnX9Z5FvigYgE4xYEQucoc/CaZ1L6k=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmhtvE5jQaTpD8ZhDPn8DqiYalF5DszeadfNNtlx+f
 foCRQCmJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZobbxAAKCRAk1otyXVSH0B+1B/
 9rJLpd/MmNXdmbQYsLI2+RCatIbty19wmYGq6fYC7YOCwE7WuhCXUDOCqlX5W/2FzQDHqQBmDALnIE
 EYYYQ7nBIE129bO9I3iQUrJz0wJP0hpkXm/ywCjjGujTPNe/+jE5477w7jaoN+thvcfwTfYybHyKno
 oxykg8ddVmYxKJ9YJwB6Oe7oNeJbHD22a5DcAPfCz+olj7eypIX5dada+7ongd/X4/HVnIDbcNxDFV
 UqWKekxNN38yRf4OvtNHfRSaf48c+MnIUnTf6XZwR3gx4padpJyZX83wKlWbhmcwgAxbItbs6sX1vs
 zQAJdT+iSOXfVcToIQqx56L/y8Bwb9
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

As observed during review the pKVM support for saving host SVE state is
broken if an asymmetric system has VLs larger than the maximum shared
VL, fix this by discovering then using the maximum VL for allocations
and using RDVL during the save/restore process.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
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
base-commit: afb91f5f8ad7af172d993a34fde1947892408f53
change-id: 20240604-kvm-arm64-fix-pkvm-sve-vl-13cd71fd7db0

Best regards,
-- 
Mark Brown <broonie@kernel.org>

