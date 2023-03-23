Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A66BA93A
	for <kvmarm@lists.linux.dev>; Thu, 23 Mar 2023 15:49:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C151FC433EF;
	Thu, 23 Mar 2023 15:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1679586554;
	bh=ykkoEH/Ic9B/Muk/UUNMxlM41PF3jy+A0x8JJcIv1y0=;
	h=From:Subject:Date:To:Cc:From;
	b=FTcFcpjEWr7kOdrkO36YCbT0CwVgs/G3ljE0UKC0W9KaQSSSJoNhn0RXO4VbajTp9
	 0mT2fYj37brU680S/eLwH1rp8UOQz6rD5xTCWK2nkFaXqpZKo1q6QLuQcKC6jgFg3T
	 GBHMBH0Sugy23lDwIcKpkWS8Pl2/1DIToEO+OXxIlsU63SJKk87BXUEmr8vYrtxx0c
	 +4dBxr64awzv5pkrwXXykwn8TzOoeMbCsx9AxGg4uiTu5MJB17lcFlUANMG1TeWFJe
	 3UfQPK18oZJETstArOYL3GBy3uw2liBakrc8d7ph/jtj7ivIsP399mF9DGtNLAxc7V
	 Olp5Eh3giOIFw==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 0/2] KVM: arm64: Support for per-guest fine grained
 traps configuration
Date: Thu, 23 Mar 2023 15:48:34 +0000
Message-Id: <20230301-kvm-arm64-fgt-v2-0-c11c0dcf810a@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANJ0HGQC/3WNwQ6DIBAFf8Vw7jaAFpKe+h/GA8KixIpmMaSN8
 d+L3nucSd6bnSWkgIk9q50R5pDCEgvIW8XsaOKAEFxhJrmsec0FTHkGQ7NqwA8b4MM5IXWjvNK
 sbHqTEHoy0Y7napvX066EPnyuStsVHkPaFvpe0SxO++8/C+BgvfNaGKu0s68JKeL7vtDAuuM4f
 sMXsQDBAAAA
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.13-dev-bd1bf
X-Developer-Signature: v=1; a=openpgp-sha256; l=1930; i=broonie@kernel.org;
 h=from:subject:message-id; bh=ykkoEH/Ic9B/Muk/UUNMxlM41PF3jy+A0x8JJcIv1y0=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBkHHT2vV5m8wxHUdPFUI6xEvbWxHjEu7qu+h3nUUMu
 OqUJjZ+JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZBx09gAKCRAk1otyXVSH0PKXB/
 4t3i8KslzVHVos3Qg6n3j7t/5ovH0creYsWt73Q0Yyx1DkZ4K0sQlPo7eKY797QpbTPkXSzOvhKAGS
 S0nqhBfXLE9BU5+m6btgXdkHDNIJ6I8qxKBmXcswPocmS+crg+Vh14zLo4UWb4z0lak9C1TylB81gH
 jWEWvHSi7BQXNI1OzLrgVcL2jelXVUT1WoIeJJynVY0deAk8rdEyBj55fVbk/oXGVc/mGIWBNpW0uR
 b32tQD9wu+t594chPYLcHDciUlLrLdiJBii52CML04VSmYw1/7u2/CWSIDU+NRyqGQiNpMMtUhk4LD
 t3w7dPvQkSCfYS6M7f2jh2t9sMEJOd
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

Changes in v2:
- List all the traps enabled by setting the registers to 0 by default.
- Save the HWFGxTR_EL2 valus in the vCPU/host sysreg structures.
- Link to v1: https://lore.kernel.org/r/20230301-kvm-arm64-fgt-v1-0-cfdf71ac67dc@kernel.org

---
Mark Brown (2):
      arm64: Add feature detection for fine grained traps
      KVM: arm64: Move FGT value configuration to vCPU state

 arch/arm64/include/asm/kvm_emulate.h       | 16 ++++++++++++++
 arch/arm64/include/asm/kvm_host.h          |  2 ++
 arch/arm64/kernel/cpufeature.c             | 11 ++++++++++
 arch/arm64/kvm/arm.c                       |  1 +
 arch/arm64/kvm/hyp/include/hyp/switch.h    | 35 ++++++++++++++++--------------
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  9 ++++++++
 arch/arm64/tools/cpucaps                   |  1 +
 7 files changed, 59 insertions(+), 16 deletions(-)
---
base-commit: e8d018dd0257f744ca50a729e3d042cf2ec9da65
change-id: 20230301-kvm-arm64-fgt-e5dd12746f67

Best regards,
-- 
Mark Brown <broonie@kernel.org>

