Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5C9441F
	for <kvmarm@lists.linux.dev>; Wed, 12 Jul 2023 12:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44FC5C433C7;
	Wed, 12 Jul 2023 12:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689166232;
	bh=zfpto4DMnBrcAI2aBm78QC3uIFFGioQek+XIR3kJRco=;
	h=From:Subject:Date:To:Cc:From;
	b=gBMEvldx59BBCtMxgFZlquNew0msQk+qNBIB1BCOFQXu4/qTHxIVbeNqEOEk862qV
	 6ImfwWgCmMDyJzPBGJu+S5dxLifUGn6VBLnvZ0Om26phZhUMk6w/5hu0L1sOekBDla
	 dtv28W7NIy+Sck5djrTzXQj0yYLfgV3mnzWIf5LYgbpHLW9gOSjbzU7fQ4HsUXOwDi
	 arZUK2In1ogB8CgM+nyjhv1wQfgpq0foeIo8gQYAWIGVGuS2LhTjgOFbgl55QDP+N5
	 NDtMgELJg8DKHF66pWPCkjulpRuZoo1XxzBq0rdMsqBYZNvGw1LNl5DQjzBaGeTfdu
	 UA8ls5vP4f7gA==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH v5 0/2] KVM: arm64: Support for per-guest fine grained
 traps configuration
Date: Wed, 12 Jul 2023 13:50:10 +0100
Message-Id: <20230712-kvm-arm64-fgt-v5-0-dae3ec236288@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIOhrmQC/33Ny27CMBQE0F9BXtfI16+krPgPxMKvm1g0CbIji
 wrl32uzQ6hZzkhn5klySDFkcjo8SQol5rjMNaivA3GjmYdAo6+ZcMYFEwzorUzUpElLisNKg/I
 eeCc16o5UY00O1CYzu7Gpdbq39p4Cxsfr5XKteYx5XdLv67RAa//bL0AZdeixA+N05935FtIcf
 o5LGkibKnyX88YBHPMOe2Dmg4tdLirvUX0rKazVvfjgcpfLysFi77lQxgG+8W3b/gBugwr+fgE
 AAA==
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.13-dev-099c9
X-Developer-Signature: v=1; a=openpgp-sha256; l=2375; i=broonie@kernel.org;
 h=from:subject:message-id; bh=zfpto4DMnBrcAI2aBm78QC3uIFFGioQek+XIR3kJRco=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBkrqGTHYDW2ywjoHZjYfoySJuakVXpiVWVOrWXtsNX
 v09Hj3WJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZK6hkwAKCRAk1otyXVSH0EBiB/
 9BGnYMNgxcniqiEjibf9EwC8En8EYpXHaHdsGUWzt+kq9IuA5ZsEsFcS0IMKBAhBLeGG5aOHq0vv1h
 U5ItBLzC20Rv39IFeff42qio9zmgMtS3Qs1cnfV5UnSTjA6voTFSt5W7QU2CbFf7L+uUZXSgPXj87H
 ntCIbDVyt59axXmibN6CNJgoqCH0XmvcaFRqfOrxWkkvzN12JMIZmPqem+eIeS0sdAb5u8CVAWSZqd
 GuizYhgeuvhd01DbcpcQ6gQVI6GCjQO76pvR8x1nMGtDG3LBWy228bCR/WMyEiZ3Oy8JiD5HZLsYd3
 ji9C2aPkzqyxbwxA0c4sf/C30Hodjt
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

A number of upcoming features will require per guest configuration of
the fine grained traps enabled in the guest.  At present the only
management we do is for SME where we don't yet have guest support so we
unconditionally enable the traps while guests are running but this will
change going forward and at present the code isn't particularly
scalable.  This series aims to make it easier to configure which traps
are enabled for the guest by making the value set for the guest into
configuration in the vCPU data which we can set up based on the chosen
features rather than requiring conditional code in the trap enable and
disable paths.

This will have no benefit until one of the features that requires
configuration of these traps is merged but since there's a number of
such features it seems useful to decide on an approach to handling traps
for them which can be shared.

Changes in v5:
- Rebase onto v6.5-rc1, this required a bit of rework.
- Link to v4: https://lore.kernel.org/r/20230301-kvm-arm64-fgt-v4-0-1bf8d235ac1f@kernel.org
Changes in v4:
- Rebase onto v6.4-rc3.
- Link to v3: https://lore.kernel.org/r/20230301-kvm-arm64-fgt-v3-0-8f59543bb683@kernel.org
Changes in v3:
- Move the HFGxTR_EL2 storage from the sys_regs array to a member
  variable directly in struct kvm_vcpu_context.
- Link to v2: https://lore.kernel.org/r/20230301-kvm-arm64-fgt-v2-0-c11c0dcf810a@kernel.org
Changes in v2:
- List all the traps enabled by setting the registers to 0 by default.
- Save the HWFGxTR_EL2 valus in the vCPU/host sysreg structures.
- Link to v1: https://lore.kernel.org/r/20230301-kvm-arm64-fgt-v1-0-cfdf71ac67dc@kernel.org

---
Mark Brown (2):
      arm64: Add feature detection for fine grained traps
      KVM: arm64: Move FGT value configuration to vCPU state

 arch/arm64/include/asm/kvm_emulate.h    | 21 +++++++++++
 arch/arm64/include/asm/kvm_host.h       |  6 ++++
 arch/arm64/kernel/cpufeature.c          | 11 ++++++
 arch/arm64/kvm/arm.c                    |  1 +
 arch/arm64/kvm/hyp/include/hyp/switch.h | 62 +++++++++------------------------
 arch/arm64/tools/cpucaps                |  1 +
 6 files changed, 56 insertions(+), 46 deletions(-)
---
base-commit: 06c2afb862f9da8dc5efa4b6076a0e48c3fbaaa5
change-id: 20230301-kvm-arm64-fgt-e5dd12746f67

Best regards,
-- 
Mark Brown <broonie@kernel.org>

