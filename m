Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6988E1F93C
	for <kvmarm@lists.linux.dev>; Tue, 23 May 2023 18:37:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45A2C433D2;
	Tue, 23 May 2023 18:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684867032;
	bh=85tRnbat52B6IBzDM3UnXuQ+f5nD406kWabSowIdwAA=;
	h=From:Subject:Date:To:Cc:From;
	b=HY+7SGEPmz+PnYzd1K19s5ZCB3+KfWVyYeEwSBtbkUaxVK7rl8J+bKYn6GJGHnzaS
	 AczhTNPG9As3HLTI4bQuSHVUoFLRQjcSfYx1XyuvUIK8xR4OvlAVTgcKBcZNqd2xuE
	 AO5kvpF5ZyJVoNhMnXzwvutuNHjk93lVS1dmv6frNerMjbHVEJca8Qq/UBMtGKZK7G
	 ietkpOULcJhaeUApHmlvRn1Ct9tEEdaya6lgyUOS7XV7XaDxCGoy10kYlGNeQcZ0y7
	 ZsggIjgS81MWC07h764HkakYr45DUIk4slMSm9QaxCV4sxl/inKRZ83kSUSYq7AcEV
	 A5EmeN+DtUQnQ==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 0/7] arm64/sysreg: More conversions to automatic
 generation
Date: Tue, 23 May 2023 19:36:58 +0100
Message-Id: <20230419-arm64-syreg-gen-v2-0-4c6add1f6257@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMoHbWQC/3WNQQ6CMBAAv0L27BoopFJP/sNwaMtSGrQ1W4MSw
 t8t3D3OJJNZIRF7SnAtVmCaffIxZBCnAuyogyP0fWYQpajLplKo+SkbTAuTQ0cBjdC6VdK0epC
 QK6MToWEd7Lh3n8jTrl9Mg/8eo3uXefTpHXk5vnO12/+LucISVS1tf5HKGkW3iTjQ4xzZQbdt2
 w8w/8I3xgAAAA==
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>, 
 Anshuman Khandual <anshuman.khandual@arm.com>, 
 Shaoqin Huang <shahuang@redhat.com>
X-Mailer: b4 0.13-dev-bfdf5
X-Developer-Signature: v=1; a=openpgp-sha256; l=1297; i=broonie@kernel.org;
 h=from:subject:message-id; bh=85tRnbat52B6IBzDM3UnXuQ+f5nD406kWabSowIdwAA=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBkbQfPNZeWD+F+ZKEYK9wEDhAlMa3SfFD2Oh7/dB2S
 xAkMEVCJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZG0HzwAKCRAk1otyXVSH0HxVB/
 43QaDputTKF3OtYBvgFUGwvbT4F88iC4/286aS8jpxDLBL22TKRy8grVT/EGGi3SXKNBsCCYKofvgs
 nQtKK1axKn8Ks/CIcMluLJAyz80IIre0WlpjgMd3Ma3cYB9ZvktetN5uWDHsa2vMCpVKKELSRkHUxl
 8CjAWObXBwOVX/3odXCeQHvH9xvsBbYiQiUaCOAuF4LvYcOXakGGiNjFcVGP+WcTxZU9uifITYDrTA
 TvLC+Yfv64kQyz5Pxgaw8F3ZSYRcUDTVscFBgEo9MOv8xbmQoFs3fT5bRrmuJLTILMewFvB67aApVW
 g/c7S+YI5yvsz9kmCYnVLv9nNwalIs
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Continue working through the register defintions, converting them to
automatic generation.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
Changes in v2:
- Also convert OSECCR_EL1, OSDTRRX_EL1 and OSDTRTX_EL1 instead of
  dropping them.
- Link to v1: https://lore.kernel.org/r/20230419-arm64-syreg-gen-v1-0-936cd769cb9e@kernel.org

---
Mark Brown (7):
      arm64/sysreg: Convert MDCCINT_EL1 to automatic register generation
      arm64/sysreg: Convert MDSCR_EL1 to automatic register generation
      arm64/sysreg: Standardise naming of bitfield constants in OSL[AS]R_EL1
      arm64/sysreg: Convert OSLAR_EL1 to automatic generation
      arm64/sysreg: Convert OSDTRRX_EL1 to automatic generation
      arm64/sysreg: Convert OSDTRTX_EL1 to automatic generation
      arm64/sysreg: Convert OSECCR_EL1 to automatic generation

 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/include/asm/sysreg.h   | 16 +++---------
 arch/arm64/kvm/sys_regs.c         | 10 +++----
 arch/arm64/tools/sysreg           | 55 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 65 insertions(+), 18 deletions(-)
---
base-commit: 44c026a73be8038f03dbdeef028b642880cf1511
change-id: 20230419-arm64-syreg-gen-b2aa896b8af6

Best regards,
-- 
Mark Brown <broonie@kernel.org>

