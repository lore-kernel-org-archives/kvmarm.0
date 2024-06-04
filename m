Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0770146591
	for <kvmarm@lists.linux.dev>; Tue,  4 Jun 2024 13:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717506360; cv=none; b=kLK9OYBT4t2vvYi6ZQPPd3kNHdKpxT+jAG6Dnf1qOL73LcCJjhmkNQDziVk8/vZXoOvKMor3+9+8jcPBtGyIevlY6a3NXy3czyBXFgMxLJ3YJSC1tVcWB0Xv2c8dnKVs+BrjuutIwSYl00jPWWglJbtHiH6eVouT/SqEMwrPxJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717506360; c=relaxed/simple;
	bh=jgiMvoROmKbX19y+Xzc9VR3YZLxO0oGWc5sp//YYw4I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tl5omuIYDweOZGMq2r2YqwV/M+OaLlXnI/FXqstkYtBb+lq7TG+AyZheENnO4MIlELsFhADjBY5i5eTHqlQFByMLEDG1aXsaMOKMd4F59fSdRf14qwzsRCPIVFalGuFSadR7eF755ySB3Yzb/1adLKTfGIu9gClci8Kr+U/7CLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rVlnpwcJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rVlnpwcJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E77FC2BBFC;
	Tue,  4 Jun 2024 13:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717506359;
	bh=jgiMvoROmKbX19y+Xzc9VR3YZLxO0oGWc5sp//YYw4I=;
	h=From:To:Cc:Subject:Date:From;
	b=rVlnpwcJX6z7S2T8s9ky1xTI3wmqe5PWbplpGKa0/5atqTkU7TOI7BpKdP7mN2Ohm
	 VbYtOxiPDgncWM1kBaRBsn6aELQxUK9nKgSoVg/AWtbS+Gb9EIMzmHVHQjVVBs/om+
	 IGmpC1Biv/47XK75WgLx/wOPEOy2mEME/zQfXRlhki6ghAc29b9Iwkk51wp7pPHgFK
	 YX4UglFenKrJ8o6CbEHzTa+SrxLRlf6DlgCoRS3D+vgxMEUT1J3tapR5YMSwLs09ws
	 d+tDDv7OxjFjpq8YWKtH6VJ04U66HwyFtbcus7kZ0UfUiRn4BlHiBC45wBkx5qxmPs
	 ttYAugjLNCt6Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sETrR-000ZSS-CW;
	Tue, 04 Jun 2024 14:05:57 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH 0/4] KVM: arm64: nv: Add CPTR_EL2 handling
Date: Tue,  4 Jun 2024 14:05:49 +0100
Message-Id: <20240604130553.199981-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Building on top of Oliver's NV+SVE series[1], I've put together a
small set of patches handling CPTR_EL2, as the two are pretty closely
related.

This series adds:

- the description on the CPTR_EL2-driven traps in the exception
  routing tables

- the merging of the L1 guest's CPTR_EL2 traps with the host's

- the handling of L1's CPTR_EL2 access via the CPACR_EL1 accessor as a
  trap so that we can emulate writing to the TCPAC/TTA bits

Overall, this is pretty straightforward (for NV, that is...).

[1] https://lore.kernel.org/r/20240531231358.1000039-1-oliver.upton@linux.dev

Marc Zyngier (4):
  KVM: arm64: nv: Add TCPAC/TTA to CPTR->CPACR conversion helper
  KVM: arm64: nv: Add trap description for CPTR_EL2
  KVM: arm64: nv: Add additional trap setup for CPTR_EL2
  KVM: arm64: nv: Handle CPACR_EL1 traps

 arch/arm64/include/asm/kvm_emulate.h |  2 +-
 arch/arm64/include/asm/kvm_nested.h  |  4 +-
 arch/arm64/kvm/emulate-nested.c      | 91 ++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/switch.c      | 55 ++++++++++++++++-
 4 files changed, 148 insertions(+), 4 deletions(-)

-- 
2.39.2

