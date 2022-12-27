Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE000801
	for <kvmarm@lists.linux.dev>; Tue, 27 Dec 2022 14:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2FDC433EF;
	Tue, 27 Dec 2022 14:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1672151647;
	bh=NNm/Vqv/A02HvpAy5RtyOgZ/ulZTNuvXWhxdqNBXEm8=;
	h=From:Subject:Date:To:Cc:From;
	b=ka5OSX4F9v96FLjwYV8gb3qnbwqZe0UgseNfCy+FexjMpktIa4Ve7ndsTv9yM/S0x
	 eo3qR5VpB2MeCPCAyXTjn0Hpowuzlhn+BgiWPchDp45pmw/uzH5ie9c8PzAFb2vNqp
	 1Ncx8/fNKC90+yajTDAeNMsAdQUBzxrQMYo2/RDXSehkg3JPgQq8MCicXHsHNDMcCU
	 VXIFywmybMcqmTWLjHbha9GrmKrqkvrItjYzbEXhmlHkGkUUeTmL9ERNZAfBGYAiHQ
	 y+1X5c2GXrjXClxF+VHrBtActG0E7FoubrYZ1EueYgXFTjzbe1j9hMIFldq1VY5atM
	 tKSDB7Bzb4/Kw==
From: Mark Brown <broonie@kernel.org>
Subject:
 [PATCH 0/3] KVM: arm64: Floating point documentation updates and code tweaks
Date: Tue, 27 Dec 2022 14:33:38 +0000
Message-Id:
 <20221214-kvm-arm64-sme-context-switch-v1-0-383b4699de06@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEICq2MC/x2OQQrCMBBFr1Jm7VATq4hXERfJdGKCNJGZUAuld
 zft8sF/j7+CsiRWeHQrCM9JU8kNzKkDii6/GdPYGOzZWmPNgJ95QifTbUCdGKnkyktF/aVKEa8X
 OxIHF/zdQEt4p4xeXKa4Rw6vD0UwN6mnIryvvsIhLceJ52vb/ppa4miUAAAA
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.12-dev-7ab1d
X-Developer-Signature: v=1; a=openpgp-sha256; l=1702; i=broonie@kernel.org;
 h=from:subject:message-id; bh=NNm/Vqv/A02HvpAy5RtyOgZ/ulZTNuvXWhxdqNBXEm8=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjqwJacF/5DKZ547Td+6K/tGhXezIdYK8Cv0YdK4qb
 7DW335eJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY6sCWgAKCRAk1otyXVSH0PMKB/
 0aj7yAY6fh+eNPIfM+PeSn05fjJUe/DMEMFfu6K9hvn0Ffuk3D/6klawenKR3WwKeowR/gYzTh3x3M
 s2amHdIk8/VPZ2ceplJs4iEOiehrRkwNfy6oVPECguE/G4slotP1iT/qAnUv45IimkqPrI3vZaYnQ0
 xqAbuvgSdNtbe8rloj5xqfndPD6Ki5cf0i1PY79IWUk9lh8Gx4UiXYr/WUm7/1ULxu+fXHr+vUDm05
 LzczLoeJzDBMshVhcjWcBGKkbNaFy45yhkTa5nRDuNXEE/y1ab5qvPXZvGZ6ePj2GbHoIuNBV10rTe
 IrI4nnfFSM0Wa2A7fpzhWaWVXF3Ygj
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

This series has some improvements to the documentation and code for the
KVM floating point code, the main one being that it documents that the
current behaviour where we disable streaming mode and ZA prior to
running guests as being the intended behaviour. There's a more detailed
discussion of that change in the patch commit log, but briefly we need
to disable streaming mode in order to avoid EL1 triggering SME traps to
itself due to executing instructions which should be valid.

Support for SME in guests is still in progress, due to the introduction
of new register state in SME2 it interacts with the pending SME2 support
series so I was hoping to get that merged first.

To: Marc Zyngier <maz@kernel.org>
To: James Morse <james.morse@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
To: Oliver Upton <oliver.upton@linux.dev>
To: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.linux.dev
Signed-off-by: Mark Brown <broonie@kernel.org>

---
Mark Brown (3):
      KVM: arm64: Document check for TIF_FOREIGN_FPSTATE
      KVM: arm64: Restructure check for SVE support in FP trap handler
      KVM: arm64: Clarify host SME state management

 arch/arm64/kvm/fpsimd.c                 | 33 +++++++++++++++++++---------
 arch/arm64/kvm/hyp/include/hyp/switch.h | 38 +++++++++++++++++++++++++++++++--
 2 files changed, 59 insertions(+), 12 deletions(-)
---
base-commit: 1b929c02afd37871d5afb9d498426f83432e71c2
change-id: 20221214-kvm-arm64-sme-context-switch-532dcefafb81

Best regards,
-- 
Mark Brown <broonie@kernel.org>
