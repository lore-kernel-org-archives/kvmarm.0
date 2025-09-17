Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738E62EC54D
	for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 16:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758128326; cv=none; b=nmZbpFKW/esL1h8LVRLQTE4PNE431KNmPRALE1mHdXq/E1fyg+AyjmfSSzXERP7MYi3wH222PXQ73MTYDaPMaDbVG6sF2liJqiB+kyjZ3KaSUBAujo3qW9gpJoMfHjwrqsD+DyGZBMSpX+97504ukfbn93ShVfyixxf1Dh9qxcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758128326; c=relaxed/simple;
	bh=lfE5dcjv3uWH+89g23EZCRRzk3NgPDLaSKgxceY/RUQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ojYs8DySdMXmQmMYMFKI5mHwXJAG7r4z9HYI92LQQ7h5u67VI5XxEvkVT2l5/GMVtQrNulSR2/qJ13H+gaOTQFFpumJ6wSm9xi1RpHPKZbUvxaVOg6wdVOvX2B8/opRYzrK716WSPd7XEoNoOYgtcBd5PqfffuHp15dkl9F4uwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vGRLL+j5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vGRLL+j5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5C4C4CEF7;
	Wed, 17 Sep 2025 16:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758128326;
	bh=lfE5dcjv3uWH+89g23EZCRRzk3NgPDLaSKgxceY/RUQ=;
	h=From:To:Cc:Subject:Date:From;
	b=vGRLL+j5TGVpCQ+KyUodnMS3MpUflaQEPDvOpxjWU54gvBJYEfhILhVKj4Bo/SlmJ
	 JHnd8FtIOgKEimWV1xLp6P8xx+nNrsVfiXlvIiK7owQK1o6aupOcb3MkU5pr7/grz7
	 9gDJMClBZEzpOUV3fL+jUmarc8Fq9BxtIcADSmvEegg/lWtHahoBlXX1HxB3IjKCjW
	 TFVY7qjTZM26RgNs20JCFXGuVdO7cFbFejiU3g/kYv4GnoUZWXCFOc8fl8gahmCiVR
	 UAxTiSKh6ZIwKq1743qhi3oBnSPTrUHwWdzZEMSR4d+0btpvdFAePETgFkpmmCq6vS
	 Zt8H5TUaHs6Sw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uyvUS-00000007AQw-01Uh;
	Wed, 17 Sep 2025 16:58:44 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>
Subject: [PATCH 0/8] KVM: arm64: Handle effective RES0 behaviour of undefined registers
Date: Wed, 17 Sep 2025 17:58:32 +0100
Message-Id: <20250917165840.1633412-1-maz@kernel.org>
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

Marc Zyngier (8):
  KVM: arm64: Enforce absence of FEAT_FGT on FGT registers
  KVM: arm64: Enforce absence of FEAT_FGT2 on FGT2 registers
  KVM: arm64: Enforce absence of FEAT_HCX on HCRX_EL2
  KVM: arm64: Convert HCR_EL2 RES0 handling to compute_reg_res0_bits()
  KVM: arm64: Enforce absence of FEAT_SCTLR2 on SCTLR2_EL{1,2}
  KVM: arm64: Enforce absence of FEAT_TCR2 on TCR2_EL2
  KVM: arm64: Convert SCTLR_EL1 RES0 handling to compute_reg_res0_bits()
  KVM: arm64: Convert MDCR_EL2 RES0 handling to compute_reg_res0_bits()

 arch/arm64/kvm/config.c | 385 +++++++++++++++++++++++++---------------
 1 file changed, 240 insertions(+), 145 deletions(-)

-- 
2.39.2

