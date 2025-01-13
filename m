Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9171FDE05
	for <kvmarm@lists.linux.dev>; Mon, 13 Jan 2025 18:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736793331; cv=none; b=dmuxe7ysvK/KZJzTe+nw1HlRTon3iTWCbOEHx1jqbzoP22i9CVwkBylkRUjm4pHqF2eJs3CLpBFoaZIZmHWbTPAfog4/sKlR3vPkMcV186QtcfYCBp5EXgMMhdd5DhsXIVRCnJqlVKEfLSnYf+oL7J19fOO1CqcGLrXE0H8/vjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736793331; c=relaxed/simple;
	bh=+nelPL94A/L/LysjtUbYGn+zQ/ua2mF4cag9OVMG7xc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bXUKjJFM0wsWjFCMxEZS9VynZiHJ4Aq4CVlfe1jjGvKPfutZylt+Tcv7vLLYgnAjmE/BxX1cqd8t41bPt7qVPqO9vtY+L3k4tubF0lxcwWtshMm0npm6A7ruzn4T5fVEfbROigGEc9YnpSmAyc+XlmC4+7V4swgj2QH4Bv2kNuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b5DUKcBd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b5DUKcBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC3DC4CED6;
	Mon, 13 Jan 2025 18:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736793331;
	bh=+nelPL94A/L/LysjtUbYGn+zQ/ua2mF4cag9OVMG7xc=;
	h=From:To:Cc:Subject:Date:From;
	b=b5DUKcBdxFCEyzKF9xG1/3Q96SB8CxtpX6JGK5XKhwOuEIDlouCF3+Xg/K/l4Twwm
	 KdRZSBxnxdX/UqKAaPIg/p4klpa5YwcGGCbvLMnQbTih3ub736z/5byc/jmirlUm7P
	 kFhNMEHu35vLOAScUZ3REMgwZZjX2s10bdhFAdbzcFRRLPZSeI+3J+eJlN1G8tRgNh
	 gDJnRXFBm6TSUBlf89uyW6mcwXY5zo+OtXQIJtPrmUiuxdjxtEjIaewyj4WRLO4MD/
	 kqKEl0sxUok/67vrGBY4v3zHe1VxfOS7ooloaxmdsLgU1GF2TmVvcC9QW36VPQ+Ajv
	 x3GNIs3IVKTsQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tXPHd-00BjrF-Qe;
	Mon, 13 Jan 2025 18:35:29 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [RFC PATCH 0/4] KVM: arm64: vcpu sysreg accessor rework
Date: Mon, 13 Jan 2025 18:35:20 +0000
Message-Id: <20250113183524.1378778-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As a follow-up to this series[1] fixing bugs around the RESx
behaviours, here's another that tries to bring some additional sanity
to the way the RESx masks are applied.

Currently, we have *one* accessor (__vcpu_sys_reg()) that can either
be used as a rvalue or lvalue while that applies the RESx masks behind
the scenes.

However, when used as a lvalue, it does the wrong thing, as it only
sanitises the value we're about to overwrite. This is pointless work
and potentially hides bugs.

Instead, I propose that we move to a set of store-specific accessors
(for assignments and RMW) instead of the lvalue hack. This then allows
the legacy accessor to be converted to rvalue-only.

Note that these patches are on top of the NV series, so not suitable
for the current set of upstream. But assuming I'm getting positive
feedback, I'm happy to rebase that on something less bleeding edge.

Thanks,

	M.

[1] https://lore.kernel.org/r/20250112165029.1181056-1-maz@kernel.org

Marc Zyngier (4):
  KVM: arm64: Add assignment-specific sysreg accessor
  KVM: arm64: Add RMW specific sysreg accessor
  KVM: arm64: Don't use __vcpu_sys_reg() to get the address of a sysreg
  KVM: arm64: Make __vcpu_sys_reg() a pure rvalue operand

 arch/arm64/include/asm/kvm_host.h          | 31 ++++++++++--
 arch/arm64/kvm/arch_timer.c                | 20 ++++----
 arch/arm64/kvm/debug.c                     |  4 +-
 arch/arm64/kvm/fpsimd.c                    |  6 +--
 arch/arm64/kvm/hyp/exception.c             |  4 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h    |  2 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  6 +--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c         |  4 +-
 arch/arm64/kvm/hyp/vhe/switch.c            |  4 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c         | 48 +++++++++---------
 arch/arm64/kvm/nested.c                    |  2 +-
 arch/arm64/kvm/pmu-emul.c                  | 20 ++++----
 arch/arm64/kvm/sys_regs.c                  | 58 +++++++++++-----------
 arch/arm64/kvm/sys_regs.h                  |  4 +-
 arch/arm64/kvm/vgic/vgic-v3-nested.c       | 10 ++--
 15 files changed, 123 insertions(+), 100 deletions(-)

-- 
2.39.2

