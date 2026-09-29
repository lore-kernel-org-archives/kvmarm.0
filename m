Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490433DC856;
	Tue, 29 Sep 2026 11:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790683111; cv=none; b=hDXoSZ/LyQCkVOOeJaXu74ST0TwNMZnAK8Ya7FeimnoHInsHZkqXbMGvZCJ677H1Yv9QAgHiIlm8uNALCIpHw3r/onNLERqEE9ajMHbZHy+9venwlp14Cygrd3M/eq+zBbxWtG8ajmPKPzV73mAw4HYFf0ujX9xb773k4rV2ihk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790683111; c=relaxed/simple;
	bh=3fRHoFrdFC/+mzB3bxZWw4z3Bm5m1AurpfMP4seD45M=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Y3YAK/WW+x41sRhWEvs2mXNJUkGTEftG3dYpAXcK2eYHJ2VFjGuIcl7XlUjtafxzJhW6e2X+TIaNq476xUvjZobVTGi25XoHC3go/2hVSb4j9fzJ3m43y2DGGb0saAqgDaDIDvP3QhnHTQLUg9Rh+8rpn+t7Tax09PRXtd072qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XLPSLl//; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XLPSLl//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4866F1F00893;
	Tue, 29 Sep 2026 11:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790683109;
	bh=2ZtNrk6Feyb46SX9NsCxGZaoPNBMUhdFMGziOw7Z23U=;
	h=From:Subject:Date:To:Cc;
	b=XLPSLl//hsV/lQrXXyHVg2sTRVxKvp6MFRqspNnu+geEl68vjOq9iZvgKdd8AYZG4
	 9kAJPNdv1FaaW0dGg5AuXLLsPvphF+YBOI5RRZxIcD8Ri9hMdjP9MYHAu4lNvDljer
	 pSK0EY5n7eUJFCHm8aPCC/YP53VovWjg66gQkS2i3hT8c3FH1zSGYq9reXDkzbTc3A
	 UoCWTzSI159TbR6nmKKLhVdRtgIPPNYbl7M/Hv4Y/3qaMa0SoEfth3n0ViYZTUVDLl
	 yM6jT8PQw/gcQ9ZUXx6d+omsMsbiHCK2awcQvuS026dMZ60LMmkMqSEHoOhqvjRCiB
	 8gp0STOG49l5g==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 0/3] KVM: arm64: ID register finalisation fixes
Date: Tue, 29 Sep 2026 12:57:57 +0100
Message-Id: <20260929-kvm-arm64-idreg-final-v4-0-75296dde994d@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMWnu2oC/3XOTQ7CIBAF4Ks0rMVQoNC68h7GBYWhxZ/WgBJN0
 7tLq0ljTJcvM/O9GVAA7yCgXTYgD9EF13cp8E2GdKu6BrAzKSNKqCCSVvgcr1j5q+Bp4KHB1nX
 qgqXUteaiLopSoXR782Ddc3YPx08Oj/oE+j5h00brwr33r7k45tPet4PlKx0xxwQzA1QVIhdGi
 /0ZfAeXbe8bNJVEujAlYWsMTYyRRgIHqwUnfwxbmIqsfsMSo4i1igirSkl/mHEc31WJFvBbAQA
 A
X-Change-ID: 20260729-kvm-arm64-idreg-final-77cbc46b558a
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1905; i=broonie@kernel.org;
 h=from:subject:message-id; bh=3fRHoFrdFC/+mzB3bxZWw4z3Bm5m1AurpfMP4seD45M=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqu6feKMIrvZsHSK/zFAg3R5tYhRpxnNfzrr2qH
 Zyvimut24GJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCarun3gAKCRAk1otyXVSH
 0DLeB/448XCpgPI9But5nNSXH4cx69w/oaJ0novPibHHj8MYUFDozhfVSeBKksleTevffKxKmHA
 etGGGl/S3qWJMIg+LVqJX2M8bNZn6ocs4EX4uAUu+1rq7sJYDyR3MyrRvQXm7nOEqsjwQNgkWD1
 RZvgsWadIF4fW8K4NtyPn9XKkswV58cDgTI2I5wcDQKE9sy9xdM0Lgq5hEktxDU4JXypTFwJW9A
 tsduRmSd7eP1dKQU2dwGGB+vUZMH5sRh0J92yR3v9iqiiMjWjfK8Hi+MMPUPEr/pKGpmm+1ewIE
 QKt7SLcO3U3VyC/HKx7EXJzZ2a3z5hrB3xkURcEac4oviJOn
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

While looking at some feature enablement I noticed that there are some
scenarios where we can end up with an inconsistently configured vCPU due
to finalizing configuration based on ID registers before we have blocked
writes to the ID registers. This series aims to clean up these issues.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
Changes in v4:
- Rebase onto v7.3-rc3.
- Add a lockdep assert.
- Update Fuad's LLM tag.
- Link to v3: https://patch.msgid.link/20260901-kvm-arm64-idreg-final-v3-0-a0ffa06fa872@kernel.org

Changes in v3:
- Rebase onto v7.3-rc1.
- Explain why KVM_ARCH_FLAG_ID_REGS_INITIALIZED is not reused.
- Pull in Fuad's test cases.
- Link to v2: https://patch.msgid.link/20260803-kvm-arm64-idreg-final-v2-0-d7d7e4efc640@kernel.org

Changes in v2:
- Also replace the kvm_vm_has_ran_once() usage in kvm_set_vm_id_rg() and
  kvm_vm_finalize_sys_regs() with kvm_id_regs_final().
- Link to v1: https://patch.msgid.link/20260731-kvm-arm64-idreg-final-v1-0-3de2a5616dc6@kernel.org

---
Fuad Tabba (1):
      KVM: arm64: selftests: Check ID regs are immutable after a failed run

Mark Brown (2):
      KVM: arm64: Finalize guest-wide sysregs prior to per-vCPU sysregs
      KVM: arm64: Block ID register changes after we rely on the values

 arch/arm64/include/asm/kvm_host.h               |   8 ++
 arch/arm64/kvm/arm.c                            |   2 +-
 arch/arm64/kvm/sys_regs.c                       |  57 ++++++++-----
 arch/arm64/kvm/sys_regs.h                       |   2 +-
 arch/arm64/kvm/vgic/vgic-init.c                 |   6 +-
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 106 +++++++++++++++++++++++-
 6 files changed, 154 insertions(+), 27 deletions(-)
---
base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
change-id: 20260729-kvm-arm64-idreg-final-77cbc46b558a

Best regards,
--  
Mark Brown <broonie@kernel.org>

