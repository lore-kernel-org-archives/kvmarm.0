Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151B5154BB
	for <kvmarm@lists.linux.dev>; Mon, 22 May 2023 16:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6A9C433EF;
	Mon, 22 May 2023 16:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684772649;
	bh=I3YlnBhxCD0gEcml/CcInHo3e5hMQBL8zuDgV1zgfTk=;
	h=From:Subject:Date:To:Cc:From;
	b=VANP4UsdACd9ZuXA/xC5fsgPQ6Ld6r03FBaG2cuVsZA8PZyqMbuZna9hPI6IqqZF9
	 yz+c2EwSVLKGa7c8BfADkPxZCeJ0J8gzQwLdGMgs0PASO9GXgjLyOlmUmT2MfhM0XR
	 m5W7uaalNEcL0RZqg79Q1x8hvjRmrl9mkg5xvQkv2MXDg6XMeIibWIvlCaufqeLH0n
	 TKByW6b1Yuj/BJBqbkDw8RMd1YJxKXvJPPFo7HvQ22LtaPJVBU9w8TAAqvwrlocqOC
	 M+Tj7aJAHjGpc1xWfVPE2Ln5OfnC7XYpCOdpDgMj8nxvyU3zug6g4+l4oYQY1S+jxZ
	 hdSib2Mz88V3A==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 0/2] KVM: arm64: Support for per-guest fine grained
 traps configuration
Date: Mon, 22 May 2023 17:23:55 +0100
Message-Id: <20230301-kvm-arm64-fgt-v4-0-1bf8d235ac1f@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABuXa2QC/33NSw6DIBgE4KsY1qXhoWi76j2aLhB+lFjRgCFtj
 HcvuGuaupxJvpkVBfAWAroWK/IQbbCTS6E8FUj10nWArU4ZMcI44YTiIY5Y+lGU2HQLhkpryup
 SGFGjZFoZALdeOtVntYxzbmcPxr72l/sj5d6GZfLv/TTS3P7bjxQTrIw2NZVK1FrdBvAOnufJd
 yhPRXbIWeaUKqKVaSiRP5wfcp54Y6pLVfK2FQ3/4tu2fQC8oETYPwEAAA==
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.13-dev-bfdf5
X-Developer-Signature: v=1; a=openpgp-sha256; l=2217; i=broonie@kernel.org;
 h=from:subject:message-id; bh=I3YlnBhxCD0gEcml/CcInHo3e5hMQBL8zuDgV1zgfTk=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBka5ck/fW5JvaA+zWZGNCCdlvr+FuHCtCowNiW21s9
 pyQQZKuJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZGuXJAAKCRAk1otyXVSH0AM4B/
 4miRA+qjaR6pqwAZxr9VhEbZZNmLChAzg/WSdQA22cTU8UxrAOht9U06s2IMMF0/SUjwKMghssDSVi
 Nrlc6S/XolJMsb0hoGELYK8srGd/CVKX/IBg/hzxgmxV53x37thxP7yGm8wdK9B9Hf7tx2hjoKk4WM
 aIPrO7xazdNh/A3BkBYHICDXLOacDY+N7S1mjiJ9kYn+d25InhVYS+6qscylNM5LE0tKMgCHNPnRNV
 lWK2tY7Tkbw/Lmb/2D0UoluvU7Kdn11dgOCYqT8udChkpJsAkL5A3i4tJNN+zg7Bygl+wWvDPesddL
 hSiDAF2yPPHXUMI+H8I1GrHOlu7Z0B
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

Changes in v4:
- Reboase onto v6.4-rc3.
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

 arch/arm64/include/asm/kvm_emulate.h    | 16 ++++++++++++++
 arch/arm64/include/asm/kvm_host.h       |  3 +++
 arch/arm64/kernel/cpufeature.c          | 11 ++++++++++
 arch/arm64/kvm/arm.c                    |  1 +
 arch/arm64/kvm/hyp/include/hyp/switch.h | 37 +++++++++++++++++++--------------
 arch/arm64/tools/cpucaps                |  1 +
 6 files changed, 53 insertions(+), 16 deletions(-)
---
base-commit: 44c026a73be8038f03dbdeef028b642880cf1511
change-id: 20230301-kvm-arm64-fgt-e5dd12746f67

Best regards,
-- 
Mark Brown <broonie@kernel.org>

