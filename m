Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C414468C05
	for <kvmarm@lists.linux.dev>; Sat, 12 Sep 2026 10:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210127; cv=none; b=MXshdIxQwUDESNpI/BHdS24QrAwW1KWYgdNSEms2sxZ2kQ4PlMYsWfl+topGgtPfXwXkXmJb16GKbSEhzFKv/9TWGSoBxCXFP1755AZOylela6mBSR/nDouauWymnIVphhm5G18bXd+9wt/l27/JPMjymS3azfiSEee3fAkZOKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210127; c=relaxed/simple;
	bh=WrbBvb1R2HFPdTdstBB7DqtIy/JOb0xMHqEZ5G1D/gA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bgPZZemJGZrJ3lh5Fae6FopIPyv/QhYzR3EJ9LPaEJJeApbu+ylTXv4+u4hO2kkW14Tq181EDpvrhQv8JZEyhZUv9c4phC1J8KEBdxaEmi/UvnDiuUkg/SpWSKNLX2vF9qUgx2zrNNmBFf71LLnyMNrU5KB+BrCoWS/XLO3oGWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=icHDUr/Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="icHDUr/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2551F00898;
	Sat, 12 Sep 2026 10:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789210121;
	bh=bdbvte0+CitU7dEGN6OVeRkmpffddfmnG/xB5jCYKZk=;
	h=From:To:Cc:Subject:Date;
	b=icHDUr/QHpVJPWBa6qt/im9UB1tpQSq1Mmpk9TKwOK/8nJPqrnHz5ALgSJOiW/8GT
	 ClOt1sE5TLHYvUY2RT6Jl1fEU8DQWqc0jIhy5GaRkpeuoclWwY//FdpIEH4Y33Zb/r
	 h68aki7kj75q1A6vjh1JtWaVyWXOcgpdA2IdxhkmkyVKBwu0oe70dK3M+aPjD99uJD
	 KSHVi7FCKAluCHBtas5xqTwpap9X9uHUVGDUy/oOMnsJzQet5jDbL5oIkd7KwdrVwf
	 4yxIg+lCh4eJf8fTVYPOEsIZuoDzB2OBQz5dkLFpqmCAcwNLZ635YMUmDFJU8+0XpZ
	 7By741Joqf+2w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1x5LHj-000000084hK-1QCw;
	Sat, 12 Sep 2026 10:48:39 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Wei-Lin Chang <weilin.chang@arm.com>,
	Wang Han <wanghan@linux.alibaba.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: [PATCH 0/4] KVM: arm64: Reduce overhead of full S2 teardown
Date: Sat, 12 Sep 2026 11:48:30 +0100
Message-ID: <20260912104834.3093878-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, weilin.chang@arm.com, wanghan@linux.alibaba.com, xueshuai@linux.alibaba.com, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Tearing down a full S2 is a pretty involved process, resulting in a
lot of TLB invalidation. These TLBIs are either on a per leaf basis if
the HW doesn't support range invalidation, or by top-level range if it
does. Amusingly, the latter occurs even when nothing has been
unmapped.

Things are made worse with NV, as we have a bucket-load of shadow S2s,
and the need to invalidate them all on the back of an MMU notifier.
The latter will eventually be solved by the reverse-map tracking that
Wei-Lin is working on, but we need to be better at full-S2 teardown.

This small series adds a "no TLBI" unmapping primitive, which allows
the caller to then whack the TLBs using a VMID-wide invalidation. This
results in far fewer TLBIs, and a better recursive virtualisation as
we get far fewer traps as a consequence.

This applies on top of my shadow-s2 lifetime fixes, and is expected to
be a prefix to Wei-Lin's series.

Marc Zyngier (4):
  KVM: arm64: pgtable: Add Stage-2 unmap without TLBI primitive
  KVM: arm64: MMU: Add kvm_stage2_unmap_all() helper
  KVM: arm64: nv: Move full s2_mmu unmap over to kvm_stage2_unmap_all()
  KVM: arm64: nv: Move TLBI VMALLS12E1* emulation over to
    kvm_stage2_unmap_all()

 arch/arm64/include/asm/kvm_mmu.h     |  1 +
 arch/arm64/include/asm/kvm_pgtable.h | 17 +++++++++++++
 arch/arm64/include/asm/kvm_pkvm.h    |  1 +
 arch/arm64/kvm/hyp/pgtable.c         | 38 +++++++++++++++++++++-------
 arch/arm64/kvm/mmu.c                 | 15 +++++++++++
 arch/arm64/kvm/nested.c              |  4 +--
 arch/arm64/kvm/pkvm.c                |  2 ++
 arch/arm64/kvm/sys_regs.c            | 18 ++++++-------
 8 files changed, 75 insertions(+), 21 deletions(-)

-- 
2.47.3

