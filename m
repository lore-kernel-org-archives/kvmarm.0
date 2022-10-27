Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41C37B
	for <kvmarm@lists.linux.dev>; Thu, 27 Oct 2022 20:54:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75B7C433D6;
	Thu, 27 Oct 2022 20:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666904085;
	bh=uY+beVsexjZ3IOtGA54wUMsSAxtwAcfSowyTBS9PR3g=;
	h=From:To:Cc:Subject:Date:From;
	b=GYAneqQmclW+0RQ/f5Ntu0mYx4ulh16f0BylyAv4VjPd6Q614cDri0itNbflypyGO
	 phcxkR5huV4F7T5dXbBLdbMKyZ9oxCEeIv9Yfg9kMsVNF1zQ0bUrqtSfHN3m6MzT3l
	 PeQNEdZN5P4Wh1UpZMR+gvG2JbmI7YP0UyJTwetLyOZ291qNBj7OS+yQpYdPvXS/dl
	 zG/N5/cHZhGp9z4KvTQqJRlAQpDkgo3YganZuRNNcuq49hfbpkI4FYimISn4fNGhZ7
	 /HiZnX16/m+uwjgYyZ6La1AL/kozBxiNI87T8/IHPxqRDtGoJyIiowxLJZDNvtamZt
	 dlNWRMhiI5Zdw==
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
Subject: [PATCH v1 0/2] KVM: arm: Refuse to enable KVM on systems with SME but not FGT
Date: Thu, 27 Oct 2022 21:52:44 +0100
Message-Id: <20221027205246.812586-1-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1278; i=broonie@kernel.org; h=from:subject; bh=uY+beVsexjZ3IOtGA54wUMsSAxtwAcfSowyTBS9PR3g=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjWu+cr/OjtnoKu/V6lvt5UmFjVvXCHgqig2Ygv+zM YWjT3aKJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY1rvnAAKCRAk1otyXVSH0L3ZB/ sF96rrRlFwpxPNlfTV4SEQ7VpIfP/O7IcCIWEdDkTKhoSUfy0Vzb8rFxGHWeXA0L1lSOzC1s3qMYNz wqsKYNouS37lGNqPpfBa7GYLxSUrzAEnwzWptWX2HLTrk/r95tjnK8YtjUX8YPhuNalwQTtd8kZiSB DusaeWrcWtnsXpWeYcEQU7G3465e3s6PubUhRU5dHEpbYx8vgS+stVqU2R6VZhQwQvC5DTuuuuqvTt 0gbE2e/Mr9d58Qo1MnzNEl36CNf/THrFIELjozRrfPW/+gIJe2KvQ+fXnszSw12mQYtKNv+6GF2VLE SJqDcKX/LKRT8ghjtPIEZMbCp1mn6g
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

The architecture requires that any system which implements SME also has
fine grained traps since SME is a v9.2 feature, meaning that v8.7 must be
implemented, and FGT is mandatory from v8.6. SME relies on fine grained
traps to control access to SMPRI_EL1 and in nVHE mode to TPIDR2_EL0,
without traps SMPRI_EL1.Priority and TPIDR2_EL0 can be used as side
channels. 

This series adds support for detecting FGT and refuses to allow KVM to
be used in architecturally invalid configurations which have SME but not
FGT, without detection the issue presents as faults due to EL2
attempting to access the FGT registers which isn't obvious to users.
Currently fine grained traps are only used in nVHE but but a series
"arm64/sme: Fix SMPRI_EL1 traps for KVM guests" sent along with this
will add usage for VHE mode too making the issue more pressing.

Mark Brown (2):
  arm64/cpufeature: Add feature detection for fine grained traps
  KVM: arm: Refuse to enable KVM on systems with FEAT_SME but not
    FEAT_FGT

 arch/arm64/kernel/cpufeature.c | 11 +++++++++++
 arch/arm64/kvm/arm.c           | 15 +++++++++++++++
 arch/arm64/tools/cpucaps       |  1 +
 3 files changed, 27 insertions(+)


base-commit: 9abf2313adc1ca1b6180c508c25f22f9395cc780
-- 
2.30.2

