Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3522E377547;
	Tue, 17 Mar 2026 20:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773778248; cv=none; b=KrURkwca28NzfqvavofrwQU/S6vSvB2seDEyjLrSNjMBxeGFfCRkUSJA25mVGoa6q6KYMc9T5tpY2hREsm2uCxjdbSaSMddWrQDtLoMDJFWAPCAZ9LHEECp9I9j54+HHR46a8DQazvlxRfHF6bfyQfv5eTYlBPU0uAqaeibCzS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773778248; c=relaxed/simple;
	bh=+6Zxzezsh4eCjXwLVVqESoM+xpbSNtskzunvjvtmVS4=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=oR5PBVXtNFh6xXOIuhY00bgupYsjs+XhFW5zdKDwSHmuRzCbzdoG9qL9oUD5MIryfo+hKu0p+Iix4QI29orfWGXjOmcQB9MWPyJ0GYNI+sj5NddHD4UuDeqDby4WbELaHi0opsrHNqYUMpjD66fEfx6STZhdCNjNNnqt3zYkCAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fm/OFvb3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fm/OFvb3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4581BC4CEF7;
	Tue, 17 Mar 2026 20:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773778247;
	bh=+6Zxzezsh4eCjXwLVVqESoM+xpbSNtskzunvjvtmVS4=;
	h=From:Subject:Date:To:Cc:From;
	b=Fm/OFvb3kneo1FQvzjrbM4a29y8Lg6tV6bE4YdXaD63RF6j7QB+x0VPQ4/xEWpMh7
	 JJ3+JQkyuZTMErWYP8zrav6hdAXr8N2pCNW5RlxQsk3ungAe3t3KafvcdJFnnOfKcY
	 UQ6Q9pb6UVLb+epNlNHNiezabsbl+cYxCnHy+7eETshs0vvAhetFeWh/qEm6bqM7yj
	 /tqYm5ck0gzJgeDyPaaNiylQmV0eGjzAuC1XvWviz7t3YBVC772cVm6JLYcDCPSZ7U
	 4X9U62OSJ5NxoEu8SPanJpuTYo1UugiqmDn2L4GncY4B+fXKdjyhMurhwhEDLhqJAK
	 2dQDZzOZ7MKbg==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH v5 0/5] KVM: selftests: arm64: Improve diagnostics from
 set_id_regs
Date: Tue, 17 Mar 2026 20:10:33 +0000
Message-Id: <20260317-kvm-arm64-set-id-regs-aarch64-v5-0-a60f2b956e22@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADm1uWkC/4XNQW7DIBCF4atErEvFDGOwu+o9qiyADDZKY1cQo
 VSR714StYqqLLz830jfXEXhnLiIt91VZK6ppGVu0b3sRJjcPLJMh9YCFXagsJfHepIunwzJwud
 2lJnHIp3LYWobe2/tYAZSEEQzvjLHdLn7H/vWUyrnJX/f31W4rb+yVhtyBankYCKrA3qwPb8fO
 c/8+brkUdzoig8OgLY4bJyxGBEoEvj4xOkHhzBscbpxPjqyxEEj9E8c/XFGgTJbHDUuWI7UdeC
 i1/+4dV1/AB+u2XC4AQAA
X-Change-ID: 20251028-kvm-arm64-set-id-regs-aarch64-ebb77969401c
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
 Oliver Upton <oupton@kernel.org>
Cc: Ben Horgan <ben.horgan@arm.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-e1b5b
X-Developer-Signature: v=1; a=openpgp-sha256; l=2142; i=broonie@kernel.org;
 h=from:subject:message-id; bh=+6Zxzezsh4eCjXwLVVqESoM+xpbSNtskzunvjvtmVS4=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBpubVAnYutCrQRjOp77R0NgCeHPxRanQHwdmOwR
 DrpStOs5AuJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCabm1QAAKCRAk1otyXVSH
 0PX9B/sGWR9wpk5wsfDy2EW7SUKuf4HTffxuwpV9fXjDTWM4uQToawjfHjXJwKnxT94X8XhkSX7
 pGM6H32UKO79M0fHBlG9jpLZOJiIcfYoaf5uEhniMfMEDD/z8W1y0+OuXtJ23Pd09RV7Fsu22wU
 mBfwfeUfOSWflXWTER4r1cOz/HwrCGhLepDoBs3n2948rEwuS1qhnVEHsXWEBaFAVpUvnflt3vH
 xFYzdvhAZYAN5ve8fRtBBj/wsykdzWZZ3Atpg4sAABcsyznXc21GLPs1OOheOTt//HIKEGWMYWt
 ONNzPxUYc/rS3FDwcdNYHivyRcr6Nsk5hbO1Sj7SaBO2Q4bf
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

While debugging issues related to aarch64 only systems I ran into
speedbumps due to the lack of detail in the results reported when the
guest register read and reset value preservation tests were run, they
generated an immediately fatal assert without indicating which register
was being tested. Update these tests to report a result per register,
making it much easier to see what the problem being reported is.

A similar, though less severe, issue exists with the validation of the
individual bitfields in registers due to the use of immediately fatal
asserts. Update those asserts to be standard kselftest reports.

Finally we have a fix for spurious errors on some NV systems.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
Changes in v5:
- Rebase onto v7.0-rc1.
- Link to v4: https://patch.msgid.link/20260106-kvm-arm64-set-id-regs-aarch64-v4-0-c7ef4551afb3@kernel.org

Changes in v4:
- Correct check for 32 bit ID registers.
- Link to v3: https://patch.msgid.link/20251219-kvm-arm64-set-id-regs-aarch64-v3-0-bfa474ec3218@kernel.org

Changes in v3:
- Rebase onto v6.19-rc1.
- Link to v2: https://patch.msgid.link/20251114-kvm-arm64-set-id-regs-aarch64-v2-0-672f214f41bf@kernel.org

Changes in v2:
- Add a fix for spurious failures with 64 bit only guests.
- Link to v1: https://patch.msgid.link/20251030-kvm-arm64-set-id-regs-aarch64-v1-0-96fe0d2b178e@kernel.org

---
Mark Brown (5):
      KVM: selftests: arm64: Report set_id_reg reads of test registers as tests
      KVM: selftests: arm64: Report register reset tests individually
      KVM: selftests: arm64: Make set_id_regs bitfield validatity checks non-fatal
      KVM: selftests: arm64: Skip all 32 bit IDs when set_id_regs is aarch64 only
      KVM: selftests: arm64: Use is_aarch32_id_reg() in test_vm_ftr_id_regs()

 tools/testing/selftests/kvm/arm64/set_id_regs.c | 159 ++++++++++++++++++------
 1 file changed, 119 insertions(+), 40 deletions(-)
---
base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
change-id: 20251028-kvm-arm64-set-id-regs-aarch64-ebb77969401c

Best regards,
--  
Mark Brown <broonie@kernel.org>

