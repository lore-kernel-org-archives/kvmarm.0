Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE15716A94F;
	Wed, 21 Aug 2024 23:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724283377; cv=none; b=m8DPoCwTMOcIzlCdDiCpOsSOH8wp4w8hzAopgw4tgu9hmPZ64jXdcUtGokse34sdGJupRqZ1+ejEEnW5ZYMQKZwA1z0/9Sz5YR7LIV48srX+ELa/4cgMSP4UaSq1uQrPHSYGgICu60r5/q2pye0ncJ6Yh/cFx8vpkLtARRxivBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724283377; c=relaxed/simple;
	bh=brdzSmFxxU9/yqU24WmdMPuHbC0JPXjGsAbpj8ZmrZ4=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=jgaH1/p/KtSrpn3VPFRAd4Yy73CYaWH+lNeBRw/kAQ9RquE7ILC/+BxS5PmOiUZBMBshkI+BW4HjjIFzUdDokYcwsqQ1IwCY1OyZGduhUR7lzlQ3mEiDQaWP+hV7Od4VHPcdmM1W/QTnN4Eehf7X1fhbEgkcz+yI0LTIvYVdoYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hdy8/RKS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hdy8/RKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4E9C32781;
	Wed, 21 Aug 2024 23:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724283376;
	bh=brdzSmFxxU9/yqU24WmdMPuHbC0JPXjGsAbpj8ZmrZ4=;
	h=From:Subject:Date:To:Cc:From;
	b=Hdy8/RKS7vtZnQzBzb4jZ4FB6deBgkOouQHpXgvGb6g0R5Pde7NL93mHcJd9ASBCJ
	 03P+oOPLKKIUoKNBJvvmRNzgy897zDxBLqkjo2yy2rj1Ftp045/+mZ6tnLMN9kOjQm
	 h+fFVkKzuLnVfcLmOeLuw3hcgayMF5IJJpiJG8qY/I6vggavl0l3QBNFX9zwTpxnIP
	 vTdROTdec7Z4tZUY5veVLz358vr8N7eOKjIABZ8ZgJmLFAuxMGDDKqdMGUPkndglCL
	 XN49lQeM3Pbxm/UXYEPAQrCvTmkb1R5soqGYPmXS7V1Cyo1NlwDAw9m+COFNmUcW1U
	 x9Ld+rWGHt2MQ==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 0/3] KVM: arm64: Control visibility of S1PIE related
 sysregs to userspace
Date: Thu, 22 Aug 2024 00:35:35 +0100
Message-Id: <20240822-kvm-arm64-hide-pie-regs-v2-0-376624fa829c@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMh5xmYC/3WPyw6CMBBFf8V07ZjpQ4uu/A/DouAAjfJwikQl/
 LsV4sKFy3uTOefOKAKxpyAOq1EwDT74tolBrVcir1xTEvhzzEKhMpgohMtQg+N6Z6DyZ4LOEzC
 VAZTSu8KiRe0yEa87psI/ZvIpjbnyoW/5OYsG+Wm/TPmXOUhAwCTPdG73eba1xwtxQ9dNy6VIp
 8XCdLvH2f2iEjWF4ObZ8YtZILU0xupko9AkGhVIqN3rFzW9AUZ88gQJAQAA
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>, 
 20240813144738.2048302-1-maz@kernel.org
X-Mailer: b4 0.15-dev-37811
X-Developer-Signature: v=1; a=openpgp-sha256; l=1995; i=broonie@kernel.org;
 h=from:subject:message-id; bh=brdzSmFxxU9/yqU24WmdMPuHbC0JPXjGsAbpj8ZmrZ4=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmxnnoOWysVLhxSWycGXZ8N9XZwL9wb3sAprSecenR
 +uMKq8SJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZsZ56AAKCRAk1otyXVSH0O6hB/
 0RJ5zr+dhVm9vjv5mbW+0pOYknpegjpcfRrhn1XOua8/+PO9lekL0bw7bijwe7Foyi9eFn7Z0x5I5K
 Z6+QXKM1IrNJdFhBUUO1ygJhedI/6wuELWDM65Xu2xNfb4zrZdrbjcc2xmLMFDUFhI3dreO/xlTqrG
 XuBTHRRWe/Mo0DGcfXrUpFHakrJ0UngN3FvYi8hKcB6o/U/U8WIldRs5nFCqrs/p5kdK2ooc7q6gHQ
 l7CIm/7vFXf8JF88TiRYvlNp1KrRVZyb9wBY1C247HGMNvAHPL5k2LH55S6/oUlD+1Dm0S+Com+Z2y
 exi9UuWwqyUgMA3nsT+RHYfiR/S03Z
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

While looking at the KVM system register code I noticed that we do not
have visibility operations for TCR2 or the S1PIE registers, I may be
missing some reason why they are not required but in case I'm not I
figured the most direct way to ask was to propose adding the operations.

This is based on Marc Zyngier's series:

   https://lore.kernel.org/all/20240813144738.2048302-4-maz@kernel.org/

Signed-off-by: Mark Brown <broonie@kernel.org>
---
Changes in v2:
- Rebase on top of Marc's series adding EL2 S1PIE support.
- Handle EL2 versions of registers.
- Link to v1: https://lore.kernel.org/r/20240821-kvm-arm64-hide-pie-regs-v1-0-08cb3c79cb57@kernel.org

---
Mark Brown (3):
      KVM: arm64: Define helper for EL2 registers with custom visibility
      KVM: arm64: Hide TCR2_EL1 from userspace when disabled for guests
      KVM: arm64: Hide S1PIE registers from userspace when disabled for guests

 arch/arm64/include/asm/kvm_host.h |  6 +++
 arch/arm64/kvm/sys_regs.c         | 77 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 73 insertions(+), 10 deletions(-)
---
base-commit: 6998fa93fbbf237b518bf921f8c21e71514e5aed
change-id: 20240820-kvm-arm64-hide-pie-regs-2236f70703ab
prerequisite-message-id: 20240813144738.2048302-1-maz@kernel.org
prerequisite-patch-id: 7e65cb84e9a1ac67ec6174bc2c8e6f8a3cd7a2b8
prerequisite-patch-id: 0e79993ba049d517f676a461104379fa0c34f963
prerequisite-patch-id: 075ad9eb54d31d099a9e30ad914e29e927156ee9
prerequisite-patch-id: d61f24087c8e4c6c650969ed2db55681aa0a5562
prerequisite-patch-id: abb476d6ac155c9060656eb383e4f42cf3465c10
prerequisite-patch-id: f0cace2aabf2385d74514a3733ddbbdb1e6d575d
prerequisite-patch-id: 62ce04c9f054610b9a992a2c65d30c6cb0a0c23b
prerequisite-patch-id: efc96c4b2c999e86de8e8cbd2e5a66a3640ee187
prerequisite-patch-id: df53b3c1bc3339de587651f1f884f2bcad11a36f
prerequisite-patch-id: 58095341c1baa606c91dac8b2fc1446f5d5178de

Best regards,
-- 
Mark Brown <broonie@kernel.org>

