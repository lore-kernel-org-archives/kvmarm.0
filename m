Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC3E7B
	for <kvmarm@lists.linux.dev>; Thu, 27 Oct 2022 21:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE8FC433C1;
	Thu, 27 Oct 2022 21:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666904883;
	bh=H4eH+zL+zrzFH4iemp1WhHXta4CiMOVlxh8vGX+RCbk=;
	h=From:To:Cc:Subject:Date:From;
	b=rbySZqclz0L53QZGTiieMx18ObOBD6RAFPPuHFZpDeJIWC7WuNlE0Ja0ImcYMMz1w
	 99C9HRw16aitzCubOiRx0LQ2k/mdhiBvArQrxIK6OzFHezOjoRsxF3TViURb6Pwtco
	 fsOHsvYEU1VTSmH6dPPmnMhXTvZkDKDBjVWkUYENu3VTHr+jdU7D21c12HjhRRNReN
	 l9O+PXfWU0MuLu05nmLHUCCLwL9Txzg+lSasiQMwD4dBo08+3ZLwxweecqGyzZA8hW
	 vJ5/kxS0C+Kax/ivMt7Z9I8r6QKZZDnS1yIWCQ2H+/QwNgFWVM+PFa9/0ENMd3bXUa
	 19NuRfnpN4nGw==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v1 0/2] arm64/sme: Fix SMPRI_EL1 traps for KVM guests
Date: Thu, 27 Oct 2022 22:04:38 +0100
Message-Id: <20221027210441.814061-1-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1084; i=broonie@kernel.org; h=from:subject; bh=H4eH+zL+zrzFH4iemp1WhHXta4CiMOVlxh8vGX+RCbk=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjWvJmrDwFSMVspb1ZyaTdTPIxpUv/TM7pqZrwk77h 1BXOAz6JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY1ryZgAKCRAk1otyXVSH0KTeB/ 46Mig0qtWT6ZbfeVc/bPeW8e7OC6w5hIrPtKE6cIdawiKSJD4BNo4c3SVI4Q7qO1DbqH9irnTRwAic BuqOzUTPzPGngHvKjHcNUZ7tDU1sUvhoT7tSzNJyUprjEIcJVwg2U58zo925Epa2GT7UNPgGJc4MwJ t27vt063ForuRPKdo/5A/sLuaOqSRR9cLwYhOCtU9DSsJ7Ca6zkWk/OOdO0iDlEsRciH0yzrW5TDhK YKRRCVSD/zgeOSVHLnNoUPDC4XhYa0IZfLMp+26t+7R9tUdU6/6WNkZMLFH+HSJyYXNeo4apswfK1a dKMJh6K/7VLPfDDfBa3snoJG4PkKgs
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

When adding support for SME I missed management of traps for SMPRI_EL1
in KVM guests.  This series adds that management, and also updates the
documentation to help avoid such issues in future.

This was noticed due to Vincent Donnefort noticing that qemu has
implemented support for SME virtualisation but not fine grained traps
which was causing problems for qemu in nVHE mode since that already used
fine grained traps with SME, the FGT registers are not implemented and
UNDEF.  As a result of this change VHE will also be affected so a
separate series "KVM: arm: Refuse to enable KVM on systems with SME but
not FGT" has been sent which will ensure we don't run on such systems.

Mark Brown (2):
  arm64: booting: Document our requirements for fine grained traps with
    SME
  KVM: arm64: Trap access to SMPRI_EL1 in VHE mode

 Documentation/arm64/booting.rst |  8 ++++++++
 arch/arm64/kvm/hyp/vhe/switch.c | 24 ++++++++++++++++++++++--
 2 files changed, 30 insertions(+), 2 deletions(-)


base-commit: 9abf2313adc1ca1b6180c508c25f22f9395cc780
-- 
2.30.2

