Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CB3195F0C;
	Wed,  5 Jun 2024 11:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717588205; cv=none; b=pq6+7ezT4tlVZQsRJa3IgLMD/YH6K7tLbf7kPhua2NYGeVztUOvGwUhaZhGAWoByJkA2+xiXsW6dIx2yW8y74RxdCVJP1TFKu5+GUUi5FkwDLcuLeMf2Emck7wFJxqZy0YFQ/llnihuX5jvZdvcOEKx1/rQP+iEy0tyXsc/6Ma0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717588205; c=relaxed/simple;
	bh=SBQCKZifEPOxIOTgbUM/XODaGoNdobSf2QES1yw7iAA=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=EO++8lOSC004RVn7e8vXDeOzgFBKzBBfC0A4cmnODY4218cTrmPzmFziymKpVp3srH3v0pIQ4Uy7THgbVfU9hL2UDvBdwO7UJlH0qa92eZp5HjN8t5VlGAHhucxfU9pm2FPjb6rJ7Sqo81jnPmYbQ/VY0r0HeoYYYAu5IaY3B44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Keh9xRST; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Keh9xRST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1A4C32786;
	Wed,  5 Jun 2024 11:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717588204;
	bh=SBQCKZifEPOxIOTgbUM/XODaGoNdobSf2QES1yw7iAA=;
	h=From:Subject:Date:To:Cc:From;
	b=Keh9xRST+Rj9UveGAcphGxlIbytEGvAKf2tTEbsoLlQaSP+AAoKYPqRrgCmMPe4fh
	 CfWxq8d6wIzS/I8AhgK2lJnaMBtoP9+O9JUzkAeEq1DurTwsXwplNLZCcW6nJxJtNl
	 PJ2fCjhd2FD5CDrjIZvXqMC+naEPhGr/TT2JzAsafNVdu1hpSe5p/o0uHusoNcWeYU
	 cHs+t7SLNj6wTzERdP5pm5jlunM/RyaYM8x4nfHYCBbQQz3TyXEeOzozOjuORdyWSt
	 2v/b/aICBkJJP8Yc+5KFaaPoDnbjwi1U+VmAJAHFwMBNvLHltubSoLFUGdNzCuoUeG
	 CtJI9PDr/Hf7A==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH 0/4] KVM: arm64: Fix underallocation of storage for SVE
 state
Date: Wed, 05 Jun 2024 12:41:26 +0100
Message-Id: <20240605-kvm-arm64-fix-pkvm-sve-vl-v1-0-680d6b43b4c1@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOdOYGYC/x3MQQqAIBCF4avIrBvQkoSuEi0qpxrKEgUJpLtnL
 T/438sQKTBF6ESGQIkjX2eBqgTM23iuhGyLoZa1lq3UuCeHY3CtxoVv9B9jIkwHqma2Ri3W2El
 C2ftAJfm/++F5Xi6OVr1rAAAA
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.14-dev-d4707
X-Developer-Signature: v=1; a=openpgp-sha256; l=1401; i=broonie@kernel.org;
 h=from:subject:message-id; bh=SBQCKZifEPOxIOTgbUM/XODaGoNdobSf2QES1yw7iAA=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmYFDm6hO8bPCS7tdj//OV90xJulySV0nlZRmUoVx7
 atNp/EeJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZmBQ5gAKCRAk1otyXVSH0NmEB/
 9kIzl7JVowupzSHv5DNrF6MZgboFE8vKIcWYpcWQXTx0AJb/cC+D0KcIPrxQM0CnuFeUaxA3Lh8ni4
 wxwSqyA302Vwl35F3cIRN6dXsWtbVz4U9ztR3Kz6N0EufvQL5ipNOkWhvnDcwX7aCIfJl0cfDqB1qW
 asqTC8yHBCNu627cZ9MzeWhPJlDuw4PrfdyhT7jdpWXJA2X9JpylQ33MOvlkge9YxYpIyoN/8i7Cw0
 vOMkjv5ONz3Rb9KWQJUFfLhLXy5Brmvr7Uq5kBvifKOMwgRgQjlUtXpucOoyJx6V8ocDBkn+LXQvjw
 q/Wk6CiY3L0mvlRycBEvI0Y0T7a0nI
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

As observed during review the pKVM support for saving host SVE state is
broken if an asymmetric system has VLs larger than the maximum shared
VL, fix this by discovering then using the maximum VL for allocations
and using RDVL during the save/restore process.

Signed-off-by: Mark Brown <broonie@kernel.org>
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

