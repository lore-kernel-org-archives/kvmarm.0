Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C25168C10;
	Thu,  6 Jun 2024 15:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717687921; cv=none; b=isJV2TXs4pTaUF7N9Zt1dJbPo2lFyrc6aVJwWYIxvmPcMEXeW7EgG1XT96vWjij2Po2Uq3/5p6xVufbbyvjaeB86m5O4nmU/EwYpqbWMNQEcAyWmqccBpB8juG7pJDwDdejAGcciuJQc20QPAuobqDMROGGaNK1j6SS4ehjV5gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717687921; c=relaxed/simple;
	bh=MBj93tShhJEdKEFfTZPRFKbwlvTXnMNXIe0ENrGbOUA=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=SQramMJ8GX4yIM0RwreVgU5gj3nC9ZeDZhbhvidWlOgGHX7xSgK8E0mSbZnJnmRqEJm/uvlYbmQrrKrO3CQiQLCLBmRUuR/cjkicTlt6v/DbubyAo2miYYnJJpr8sWWftdOPt1I6tGzYXP4ZG3BHFKASVt479aFf7qdzwfzBaHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f4KYvT4s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f4KYvT4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27476C2BD10;
	Thu,  6 Jun 2024 15:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717687920;
	bh=MBj93tShhJEdKEFfTZPRFKbwlvTXnMNXIe0ENrGbOUA=;
	h=From:Subject:Date:To:Cc:From;
	b=f4KYvT4sbACZrFzq6EkD59u/+4A+yjivijeFwqRALKTqlAxK/P/9GRJXj2FFaRtzk
	 a/+p0un4DD+KWmqhUDVAWutOG5kizjh0ZX/Xhujm1kKDUeKXikxbgFn7nWbkNvnZDg
	 pGea7YFscmUiKvnwVnC6EYJ2x5Q7tPvanWItiyeSR5E/rYbd4RpsynLmqJXr8DpT+Y
	 ayGzeuk5gEonbdez0HPGCAJ5sfZVuG6WcX15jHobQPEInCFVlwyp78PAPiAQ36AGwb
	 YET+OsfOwAE4JSCSZvK61EtCTsZgzLy+/4cxiOeNF1PgoJprRZrdvpuzh5lBhSdkOm
	 USyUKZYVDR+Dg==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 0/4] KVM: arm64: Fix underallocation of storage for SVE
 state
Date: Thu, 06 Jun 2024 16:21:42 +0100
Message-Id: <20240606-kvm-arm64-fix-pkvm-sve-vl-v2-0-c88f4eb4b14b@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAbUYWYC/32NzQqDMBCEX0X23C2JprH05HsUD5qsGvxlU0KL5
 N0bhV57/IaZb3bwxI48PLIdmILzbl0S5JcMzNAsPaGziSEXuRJaKBzDjA3PWmHn3rgd6ANhmFA
 Wxpays6VtBaT9xpQqp/tZJx6cf638Oa+CPNKf9fbHGiQK1HdhdauKVhlZjcQLTdeVe6hjjF9U3
 cBPwwAAAA==
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.14-dev-d4707
X-Developer-Signature: v=1; a=openpgp-sha256; l=1692; i=broonie@kernel.org;
 h=from:subject:message-id; bh=MBj93tShhJEdKEFfTZPRFKbwlvTXnMNXIe0ENrGbOUA=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmYdZpmhq7uXSep2fj5uyu/TYvCSCdCgV45er4yujH
 sT+KG+CJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZmHWaQAKCRAk1otyXVSH0EvKB/
 4u50d8HLRj/agRdCJ9VydUH2z+VnaQl1ygnW09kAoaZgsV67HJbRswoDMWd88AnnP7PfPuAu08YVQS
 UBAFQZ3hc8wYw7te0x8UlrdyFG/FTLnAgMCBxULb6Y4kwA6c0suwU+LkNdUIrCv1tNDBathBWohnM+
 oypYSPIDhf6s9kMLeeCbTt5uBTBDXomcvFtH6qgwYMnHwLVrMhXkGBDahYxxTMBu8pu1jcwFfjette
 w2h9JTE/UJ/9VlTlncqZyYv8uZM2mqV/0CAlJxUCyAKsTkASgH/haYTHi+4yyu4c3zQYfGhADQgA3j
 6kPnUc6LVIpf9vhXS5Pdfq61Dk8bWT
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

As observed during review the pKVM support for saving host SVE state is
broken if an asymmetric system has VLs larger than the maximum shared
VL, fix this by discovering then using the maximum VL for allocations
and using RDVL during the save/restore process.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
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

