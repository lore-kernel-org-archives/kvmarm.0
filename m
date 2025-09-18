Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40BB22538F
	for <kvmarm@lists.linux.dev>; Thu, 18 Sep 2025 15:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758208468; cv=none; b=ZkdKog8l6wvmMYEqi0DtYg7leHEYQbz5y2CXYoD0SIRdGPuPKTR3+kUJYml9Lh6AGDKmbtLm7vcrk4S4qHyzv04tYl+NYU4r2ZiqzfkzkaGry/ok1VfOasjcW+EPTokfPUBiVGzoLxxQBaz5mQpXMa/eIKdrqOcv+2mSknQWtNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758208468; c=relaxed/simple;
	bh=lySSroNwuLPO9Po2mMkpeuuB5AfkkzflRth74TTL0bU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ivqwyXHOe1rSwWceiqZH7tvKWrsR8DnIwGljOcplQe5f+0nYgp4n9jo/RcxGskw/3/I9y4ZON/FDQxTW9mHiJFoSRfwiTMwv6NqRj7wG7GsBKM8RTmfha2GmiNcVq4XzXtQtETE0gpBPHPsvQBcVKt4k02dGoKVzle0ClrmaaR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vP+SQseV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vP+SQseV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A0CC4CEF7;
	Thu, 18 Sep 2025 15:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758208468;
	bh=lySSroNwuLPO9Po2mMkpeuuB5AfkkzflRth74TTL0bU=;
	h=From:To:Cc:Subject:Date:From;
	b=vP+SQseV0wUM7tXyxUy/F8GJnb3kAJLp9q0siYT48MB4h5Nm2K2JMa5naKb/sO6w+
	 fB3+0EEZObxkjPdVQyImBCLEtv+2V4/90aJAgqVkWujAyYW8p/OnPjAhwSIZuVL3bW
	 UQlX+sdWlcaOTmZBIJm+23DeYZgbTw+/uVH7/Wu78l5t1SHko0qQHgRAlA0ky2m0Uz
	 xaGSYHQRvdEXlrQObqTAy1b2ynEVR1lv4/4UzPlI3BtKAK+vyNBpR+81EzsRobc6q+
	 vWn5Yz+2EEB7iB1PtuB/4yn4RXuw+sCKo56oXfzDdR13ZDjKJXQtoxm+JT6Q161sKB
	 zlq7nm7RR0R4w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uzGL4-00000007TmF-0Yts;
	Thu, 18 Sep 2025 15:14:26 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>
Subject: [PATCH v2 00/10] KVM: arm64: Handle effective RES0 behaviour of undefined registers
Date: Thu, 18 Sep 2025 16:13:52 +0100
Message-Id: <20250918151402.1665315-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, yangjinqian1@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

[After yesterday's blunder, I'm reposting this, with proper commit
 messages, and having taken Oliver's feedback into account.]

When a feature is removed from a guest, we ensure that the trap and
control bits for that particular feature are made RES0.

For example, SCTLR2_EL2 contains a large number of bits. For any
feature FEAT_FOO that is controlled by a bit FOO in SCTLR2_EL2, we
make sure that SCTLR2_EL2.FOO is RES0 if FEAT_FOO is not visible to
the guest.

However, nothing makes SCTLR2_EL2 RES0 if FEAT_SCTLR2 is not visible.

This series aims at solving this sort of situations. It is still quite
incomplete, but aims at bridging a couple of other series:

- 20250911114621.3724469-1-yangjinqian1@huawei.com which wants to
  make EL2-related fields writable to allow migration

- 20250912212258.407350-1-oliver.upton@linux.dev which wants to align
  the NV support with the rest of the kernel

Hopefully this helps getting to a point where we everything is
sanitised according to the architecture, EL2 on the same footing as
EL1, and everything migrating in every possible case.

And winning the lottery.

* From v1:

  - Commit messages!

  - Simplified declaration macros

  - Added helpful comments (or so I hope)

  - Changed type names according to Oliver's suggestion

Marc Zyngier (10):
  KVM: arm64: Remove duplicate FEAT_{SYSREG128,MTE2} descriptions
  KVM: arm64: Add reg_feat_map_desc to describe full register dependency
  KVM: arm64: Enforce absence of FEAT_FGT on FGT registers
  KVM: arm64: Enforce absence of FEAT_FGT2 on FGT2 registers
  KVM: arm64: Enforce absence of FEAT_HCX on HCRX_EL2
  KVM: arm64: Convert HCR_EL2 RES0 handling to compute_reg_res0_bits()
  KVM: arm64: Enforce absence of FEAT_SCTLR2 on SCTLR2_EL{1,2}
  KVM: arm64: Enforce absence of FEAT_TCR2 on TCR2_EL2
  KVM: arm64: Convert SCTLR_EL1 RES0 handling to compute_reg_res0_bits()
  KVM: arm64: Convert MDCR_EL2 RES0 handling to compute_reg_res0_bits()

 arch/arm64/kvm/config.c | 357 +++++++++++++++++++++++++---------------
 1 file changed, 227 insertions(+), 130 deletions(-)

-- 
2.39.2

