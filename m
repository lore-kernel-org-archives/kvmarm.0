Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05E863D;
	Tue, 30 Jul 2024 13:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722346260; cv=none; b=gQsmdTjiakF6JsM8H5hzELACefCTfLxU/TGX5JNp3uMwaAbU9WLfvsQp5ZfTnGgOQdIJwfN3gmDy9SpPUvBDDURQt58iJQHCIe3iZGqd0LFBghESUyl6lGRgaIHmuFZQEG9LmFFrenzAzmiQo5fmmm29OTyRRjP8HmUSsjVX6N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722346260; c=relaxed/simple;
	bh=yy7+5mJanhSnLny9/z+l3tsyVx0RSv5rtYylirglrzA=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Xl0qr8Sm9LXhqF7hxu6ywQFRxKzTY3U4tb3/dKxVfMivbYqq/bOm+PRRRJ8RBDOoPfIGTrQ0+eADBt4uf+PDhF9Ugifso+7CGzRNUM76u0QuIIqjsUl+ljBqKGL3lHCq+t4Ewf+Gtl8hpY/FhTAag9BTKhGohaE5vmnXxdIxSpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=brxI5y5+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="brxI5y5+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0DFC32782;
	Tue, 30 Jul 2024 13:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722346260;
	bh=yy7+5mJanhSnLny9/z+l3tsyVx0RSv5rtYylirglrzA=;
	h=From:Subject:Date:To:Cc:From;
	b=brxI5y5+ueGJkOCI3yHtZTXCSXMZnPdO4pOcQxjAzZY3MTMHq1ARACPHMXzKcaVxm
	 snAP/VyJVG0NFBLMnvZRQUXfsNvTWl4GxVcyiJJ3Pve+qH4wyxQtsc9M7zmvcx4OJP
	 wuE1ZlhmIb9GH4S+A8OxR384km5s+ZusCcNI915Pof2JnyeMRINijWyA3PviY4Qfyx
	 st2sIrjrtAlvG8JIsc1/H5DO4+TO6AAKqHz7GUpmEn+qf/Ovv0p9Xrl2/3FRkJg9SB
	 g+AihyWv1gOpwZ9oiJVM1wlALxc954F7Hh+W/V6mzj0qAuA06UHXfxHi2UjDXNV+7E
	 fVAMCTgq2YYKA==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH v6 0/4] KVM: arm64: Fix underallocation of storage for SVE
 state
Date: Tue, 30 Jul 2024 14:29:12 +0100
Message-Id: <20240730-kvm-arm64-fix-pkvm-sve-vl-v6-0-cae8a2e0bd66@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKjqqGYC/33QTWrDMBAF4KsErauin9FIyar3CF1Y1jgRSewgF
 ZESfPfKgVIXg5ZvmPkG3pNlSpEyO+yeLFGJOU5jDfi2Y/25G0/EY6iZKaFAoAB+KTfepRsCH+K
 D35eYC/Fy5VL3wcoh2OAFq/f3RHXlZR8/az7H/DWl79eropbpr4oNtSgueO/cAOTBS/AfF0ojX
 d+ndGILW+SaMi1KVgqdCOhBe+jlhtJryrYoXSmzJ+ukFRjQbCj4o2yztgKV8uj2rvNKhx42lFl
 TrkWZSgUlrbHagcH/Xc3z/AOeMHbx7wEAAA==
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-37811
X-Developer-Signature: v=1; a=openpgp-sha256; l=2551; i=broonie@kernel.org;
 h=from:subject:message-id; bh=yy7+5mJanhSnLny9/z+l3tsyVx0RSv5rtYylirglrzA=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmqOsNqaeRRdie8SdDAQ1lneq5D6pOxAZk+JOkgK1T
 u5d7SHSJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZqjrDQAKCRAk1otyXVSH0KxZB/
 49KowH0dC5AqjvGa56kImJwH54qJ+8xxn8+/i4xsXTkGObox6ZvOgGSo0TraoMKT9Qll/hDZ03IWmP
 SFD94uuj5FauK0rAoGn6Vj62Zd86banU5TfpapC7jWyMQ99+Kvdihv/dm951YlTwNk6AolPrqCwNgx
 QnPb7tuHeWkWfmFT5fvJAz40N3XZ+VtLuB+BypWWGc2e6gVzM/IfP5cZHazTCB1DALVHB3ruJVXLpA
 qWuiFwlt8HNOyo+UY172RIFVg9Xad1pSknK3F8eBIrH/C23FngcxSgXSG+sFCwjdPRekw4vv8CveD9
 Nwpt3j9rwcWmVm0LxFM4BcZXmE0mMU
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

As observed during review the pKVM support for saving host SVE state is
broken if an asymmetric system has VLs larger than the maximum shared
VL, fix this by discovering then using the maximum VL for allocations
and using RDVL during the save/restore process.

Fuad posted[1] another attempt to address this issues but as indicated
in review I have maintanability concerns since the VL configuration does
not follow best practices and the enumeration is not well integrated
with the rest of the enumeration code.

[1] https://lore.kernel.org/r/20240606092623.2236172-1-tabba@google.com

Signed-off-by: Mark Brown <broonie@kernel.org>
---
Changes in v6:
- Rebase onto v6.11-rc1.
- Link to v5: https://lore.kernel.org/r/20240708-kvm-arm64-fix-pkvm-sve-vl-v5-0-d2175738456b@kernel.org

Changes in v5:
- Clarify commit message on patch 3.
- Link to v4: https://lore.kernel.org/r/20240704-kvm-arm64-fix-pkvm-sve-vl-v4-0-b6898ab23dc4@kernel.org

Changes in v4:
- Roll in Catalin's acks.
- Link to v3: https://lore.kernel.org/r/20240607-kvm-arm64-fix-pkvm-sve-vl-v3-0-59e781706d65@kernel.org

Changes in v3:
- Replace %u with %lu in late CPU error message.
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
base-commit: 8400291e289ee6b2bf9779ff1c83a291501f017b
change-id: 20240604-kvm-arm64-fix-pkvm-sve-vl-13cd71fd7db0

Best regards,
-- 
Mark Brown <broonie@kernel.org>

