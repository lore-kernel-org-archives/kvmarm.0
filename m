Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB8C25745;
	Mon,  8 Jul 2024 14:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720448469; cv=none; b=RKjqNK+B9knfxc/GvE127SBSf3jqOSP3OsmYkYZccxhLpjxiR6qnnwNcRM81kUgMi5FdIw7W3RA1AXrMU9PUAfEYo9aS2sLDbOXva1Nc3lA+JR059YygG2UTjx/Eh6ya0OE4wNZZwiOlWZj95XcPN3/DvmK+EIwvKZ7/huDPurc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720448469; c=relaxed/simple;
	bh=AS//5zgMCQN/h1qCnz0G1cBSnKG6FpnCnY7qDhGUZuE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=gbQD86iNWzeNcZaSWg/n5NDlf4UY1T/m7Fk88T6dziCb14kAWKsWcg7oO7CaPI6grgcQfjy85Fnuf36vbfUKmaGyJBImug+xdGFVc0EzeoF6aCgLxwczb1rLpsUwCfztQmjp8ZEejNsANfYJ74M17vBPKRfyv5RP4BVF6Vyo+oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dnq/5zEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dnq/5zEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E50C116B1;
	Mon,  8 Jul 2024 14:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720448468;
	bh=AS//5zgMCQN/h1qCnz0G1cBSnKG6FpnCnY7qDhGUZuE=;
	h=From:Subject:Date:To:Cc:From;
	b=Dnq/5zEjN2yOZE4iZG9mtW07zJP+fMvDtYuso1bL6rGikEeD0lCTzGd6Q1nDw2u4e
	 xXsr+N/InzfML8PECmci+pssxMxQP8XV471auGR0hnC5EvfYkkP9vfZxvm4Fl77zed
	 CS1L9HHWC0Y1l75NRCoRE/B6RgxJnnHfp0X2ncSTok6exHe+Sdu2qQypP8aGcffluF
	 kmTGow6mvyTy2lS+NqtV4udy6v0GXmECRklxdLK1Zon27VXDY2spbYQBedJ1ZoJwN+
	 /ELM9ldefmo1dEJrM2bQIlYlBwHToPb69RuJtNbDkFhcxzxcRfSeuczsG1tl7jwlkC
	 ZoVUhqVjyU+uw==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH v5 0/4] KVM: arm64: Fix underallocation of storage for SVE
 state
Date: Mon, 08 Jul 2024 15:19:12 +0100
Message-Id: <20240708-kvm-arm64-fix-pkvm-sve-vl-v5-0-d2175738456b@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGH1i2YC/33QzYrCMBDA8VeRnB3JxzSJnnwP2UOTTDWobUkku
 EjffVNhURF6/A+Z30AeLFOKlNlu9WCJSsxx6Gs06xXzp7Y/EsRQm0kukWuOcC5XaNNVI3TxDuO
 cuRCUCwjlgxFdMMFxVvfHRPXJ0z781D7FfBvS7/NUkfP0X9ULapHAwVvbITl0At3+TKmny2ZIR
 zazRbxTzRIlKqUtD9qhcujFF6XeKbNEqUo1WzJWGK6Dbr4ofFFm8dsKVsppu7Wtkyp4/KCmafo
 DlX/GUqQBAAA=
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.14-dev-d4707
X-Developer-Signature: v=1; a=openpgp-sha256; l=2069; i=broonie@kernel.org;
 h=from:subject:message-id; bh=AS//5zgMCQN/h1qCnz0G1cBSnKG6FpnCnY7qDhGUZuE=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmi/XJsOHfwdNXbXkCWTEMGhwVLSVC2tlTEcQYF4is
 6q7AEWqJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZov1yQAKCRAk1otyXVSH0IAyB/
 9Lsqizk8r96lkyMqZtxNGsCwlbxxTf0t6UUi03eVRoXykw24Qli5z8PvHw0SjJtJujr+vDSUk1/xdq
 pLIym0hJCTcTgzXVAj9mdv3cKBS5Y3f62PY8yP/FXjX+w7YUeQDsYvOYfjaVM+hdIhMfizdIoLVo+l
 cJSqxKasaNksxBQqkG9IB1/Iu4fRh4eG6co2SJRmBNOcKGqUwFvWNRTtWnYV5Puv4/kys0LGvvJNno
 OJMB73bBOQdMrmSkpiG5zS70z1mf4PE8VdQ4inStSyIpqO6mb/QC/apq9frCIpfUco0xoVug9ghy+X
 9vRBjNll+DPI67eKkU4BPg8Vo3yGkZ
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

As observed during review the pKVM support for saving host SVE state is
broken if an asymmetric system has VLs larger than the maximum shared
VL, fix this by discovering then using the maximum VL for allocations
and using RDVL during the save/restore process.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
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
base-commit: afb91f5f8ad7af172d993a34fde1947892408f53
change-id: 20240604-kvm-arm64-fix-pkvm-sve-vl-13cd71fd7db0

Best regards,
-- 
Mark Brown <broonie@kernel.org>

