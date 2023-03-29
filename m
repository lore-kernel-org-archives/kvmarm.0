Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A152F2F30
	for <kvmarm@lists.linux.dev>; Wed, 29 Mar 2023 15:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4E8C433D2;
	Wed, 29 Mar 2023 15:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1680104777;
	bh=ECi8ImuHUNY25o5az5e3GP69IA7BnEjHQIJXU2senkQ=;
	h=From:Subject:Date:To:Cc:From;
	b=E9G6xSipNrlMPPLsXfSrxiwW6IbNZ0jlp8RwfoFznL5NDh/OokcZxzdzpE5D2tkB0
	 bDKPtvnA4PcOkWaNl8ecLWYnwXGIUpBeQ8iEg+73vpoJSuZM0Qru9N6C8+UP/m2Enn
	 EF5OqBgvGf+LyNA3U2U8QgPRRlFMu6LMgSF8JuoJm/uWIy0xYqIIoMg0fHAnk/N/8H
	 foBhf71Y/kLIeRHbACLHuCSeNgPH0qu42GNhOf0tus1/FNUpi6RdRaU0UsdmxaT0tG
	 Zyb5J5ZNGUMPGLg4+vusYPrYbqT2Sz7dGUU+lRP8ofifHANA7sqQd2r/ryyBKBqCOW
	 hrav1uqVwPxng==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH v3 0/2] KVM: arm64: Support for per-guest fine grained
 traps configuration
Date: Wed, 29 Mar 2023 16:38:16 +0100
Message-Id: <20230301-kvm-arm64-fgt-v3-0-8f59543bb683@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGhbJGQC/32Nyw7CIBBFf8WwdgxDKxhX/odxQWFoSe0j0BBN0
 38XunOhy3OTc+7KIgVPkV0PKwuUfPTTmKE6Hpjp9NgSeJuZCS4qXnGEPg2gwyBrcO0CdLYWhaq
 lk4plp9GRoAl6NF2xlmEu6xzI+df+cn9k7nxcpvDeTxOW9Vc/IXAwzjqF2khlza2nMNLzNIWWl
 VQSf3VRdETDrXEX5PpL37btA0DNgIgAAQAA
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.13-dev-bd1bf
X-Developer-Signature: v=1; a=openpgp-sha256; l=2082; i=broonie@kernel.org;
 h=from:subject:message-id; bh=ECi8ImuHUNY25o5az5e3GP69IA7BnEjHQIJXU2senkQ=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBkJF1EB2+aXKMhQt/BZ+TqPrA7cY1476FSUTabFVEx
 XE827M2JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZCRdRAAKCRAk1otyXVSH0L4tB/
 9/br+g1TqmFDsGOeWPUCoaZWG/2ca0ar1ln0favkv3u3mXzv01ihdHzhSRKLaRekcTJfD5f6vnobE3
 SfzdW4nkI30bk0KHj/go1vs/3sitBNfelJ6bRQwd3JihdFTP0czhpBhkyXJ39Lz8JB802dXWe99Jjk
 oBC8rhHBXdeFfATrM9Io5BItG/ZOhnXHHHq1iMVuN5DBXTi3UlG2AZNj7anZBv463SSgj0GinWUVv0
 9RFx7g+itaLjdOdi5JJuzcayJtpfoL1UBCZ6VgrW9OQMJxKCQQrhWDvjGNYwQTRtwqxQZqorSe1hys
 KpkESOG6POiQMzY+JE+66VB0Z02BPf
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

 arch/arm64/include/asm/kvm_emulate.h    | 16 ++++++++++++++
 arch/arm64/include/asm/kvm_host.h       |  3 +++
 arch/arm64/kernel/cpufeature.c          | 11 ++++++++++
 arch/arm64/kvm/arm.c                    |  1 +
 arch/arm64/kvm/hyp/include/hyp/switch.h | 37 +++++++++++++++++++--------------
 arch/arm64/tools/cpucaps                |  1 +
 6 files changed, 53 insertions(+), 16 deletions(-)
---
base-commit: e8d018dd0257f744ca50a729e3d042cf2ec9da65
change-id: 20230301-kvm-arm64-fgt-e5dd12746f67

Best regards,
-- 
Mark Brown <broonie@kernel.org>

