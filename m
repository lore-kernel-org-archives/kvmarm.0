Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14AB9199943;
	Wed, 21 Aug 2024 13:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724246041; cv=none; b=AELbWQPikTw/B9yLOs/uwDLFivb5GQHIeq5lH7JGOrBMwoO3R2th66P29RRrnd1JplpAtlNGN67DQ+9aWi2FdTXNzE6PNrwOJIbywz7+EQkWysK35VNJeT01iU9FlzMnYxo6htCOECrxo8faosNU59c3KQDnmSW10eFEFC0XxDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724246041; c=relaxed/simple;
	bh=Fp/kBiHhGW3ypUrMjF3hQ3gJlZW1Yk2OBO3LISE+nPA=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=VtaslAJXiv2RN4dg4ua3SSet9FlQjpHVpH2AW9FxC1F9PBbu7C6ZZNGw71B5l/ppp1pc8ko3wvvUCvxmBPxalJINMTKbdlyB8oVYp1g5QTQTBo2b3sPA8HFaiPjM8fEy9r3oW92Ye/kKOcGbeC7PCEvrcRSJMZ0F/6w7dR+lPOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m8GbwIcA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m8GbwIcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445D1C4AF09;
	Wed, 21 Aug 2024 13:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724246039;
	bh=Fp/kBiHhGW3ypUrMjF3hQ3gJlZW1Yk2OBO3LISE+nPA=;
	h=From:Subject:Date:To:Cc:From;
	b=m8GbwIcAnkvNooBUabiD42uIEi7h1gcYlSrqALGUzHKRpz4LHaCMVHXabZUeYVKt4
	 LRhcEMYGDb3ok5ILZfRLFGI7mpUUmM6BtL5U3+C90wRwSU3/u9DAj+grqu53E2w381
	 VQYPsW1J51anpvk9HfHwQwPxX0bVpLWY66pH6lvM9T70Pkai5mXWBEU+sPVx7XncgJ
	 hNb0wk3laXHHanoFOCdKbDyTzeyN+5mHort1alyepGByJTTpBHF87LJI+3NCj24ewC
	 tfrdwl7DboduahXiutL3uUMCfnozghKaV4b+k7h2uJKezsqU7DljumNz3n04ONVFOE
	 NKIWkNEkwTnUQ==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH 0/2] KVM: arm64: Control visibility of S1PIE related
 sysregs to userspace
Date: Wed, 21 Aug 2024 14:07:14 +0100
Message-Id: <20240821-kvm-arm64-hide-pie-regs-v1-0-08cb3c79cb57@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAILmxWYC/x3MSwqAMAwA0atI1gZilCpeRVxUjTWIH1IQQby7x
 eVbzDwQxVQitNkDJpdGPfaEIs9gXPweBHVKBiauqGHC9drQ2+YqXHQSPFXQJERkLt1cU02lHyD
 Vp8ms93/u+vf9AObAoa9pAAAA
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-37811
X-Developer-Signature: v=1; a=openpgp-sha256; l=858; i=broonie@kernel.org;
 h=from:subject:message-id; bh=Fp/kBiHhGW3ypUrMjF3hQ3gJlZW1Yk2OBO3LISE+nPA=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmxegR90BAwaQnJTILyD4vHttQU9B/QKF3cFt5DPVl
 0tcmFXaJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZsXoEQAKCRAk1otyXVSH0OJsB/
 0Xeckx36onhHACU75Xlrqk8Peem3AyN0vY2O/ewZ4ri8qEOuTKl2U6ZTelpfYIa8mW6cV2tWSTEM2Y
 O+HxSWIb0M5kDMslZgiawHY5x+JtgoaxD5B8cIcjekFGcKbEOiyljQWShOV2AoVn9mf4WFlYtIlg2L
 D2/yFA6eMkbjhh1olHFUniBaE/h+yf9lW1C/bnje38UCZzJLOjREcb17ozPjYWMl4CDu7CZTg0d7EM
 QfXqg9D7htYXcwdtI72Z7KuKmJg0KfaAS+FLhCxdSwjUx5fosAvtBo8DlhFDAtqLzhJzop9ugjqpJp
 XYgJ8DuSlY8guPF6jcXg0CkJicRuE7
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

While looking at the KVM system register code I noticed that we do not
have visibility operations for TCR2 or the S1PIE registers, I may be
missing some reason why they are not required but in case I'm not I
figured the most direct way to ask was to propose adding the operations.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
Mark Brown (2):
      KVM: arm64: Hide TCR2_EL1 from userspace when disabled for guests
      KVM: arm64: Hide S1PIE registers from userspace when disabled for guests

 arch/arm64/include/asm/kvm_host.h |  6 ++++++
 arch/arm64/kvm/sys_regs.c         | 31 ++++++++++++++++++++++++++-----
 2 files changed, 32 insertions(+), 5 deletions(-)
---
base-commit: 6e4436539ae182dc86d57d13849862bcafaa4709
change-id: 20240820-kvm-arm64-hide-pie-regs-2236f70703ab

Best regards,
-- 
Mark Brown <broonie@kernel.org>

