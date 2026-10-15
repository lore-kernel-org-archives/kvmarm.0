Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50A13E95A4;
	Thu, 15 Oct 2026 17:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792085783; cv=none; b=XifsLirprDI+HTBil2sUlQz2gv22Y6EFD/MpLhnFZcMktmIi/JZYfLec6M2pmg4pmV6J2fQ3jvjQWZJu4LmkGU9mxUws68XlNDz+iNkGJ7sL1r3YFRL91moTT1CjCw4P29L0yDbX0AxTIp2J9+98DUccR48bhmV1V5sdc5t5GI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792085783; c=relaxed/simple;
	bh=MDcOzzOIwvBLEKl93FbwvTIwFI3DXgd7BqiQTpgzt2k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q3fvca7XJe3rMuemk1WV5xgx7aUtVl8ag6gqxldsBBzVeuSnX5rFiKb68TtXt3/a3rQxgYhlNacX8fnM3klvXZ4rpAc9D8ts1B5NLttMUbebPO2KGY9o7UnjJKBhLT+SjrPy5QlpetiVSG5B4Nme8k/fYfNve5cAyfwoVNtxkaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dPXO9WxG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dPXO9WxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC961F000C4;
	Thu, 15 Oct 2026 17:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792085770;
	bh=FEG/VAjAcHH5Q/D2MIVWcgHJsvBvnxs5hUqZT/aI/yc=;
	h=From:To:Cc:Subject:Date;
	b=dPXO9WxGcZniEhYNw0YlmFZlGsspCf76PXmzpJQT+No+9oHJrX5PJf63lWEtse+qZ
	 /Ew/LjiSbE0bgaadMnqfOFVdbsYjgfStoe50rvwimtMK9UJjbSRi6siqtEs342kxaJ
	 ZWMaXYvM7P7xBoWiw9z4JhtzSac/mYqFKSNqWeb66gQbT7vIdjMP3kMYpYvxOlf5tG
	 GBzoSS1UafdrUZZrQKVQ5xkibimyPIYgZDup186Z1UpUut0YABDvyExM3/juzdtgXa
	 yR5aVquaS6KUGv0zg+bT4IFSRQXGlEkEpTymqa4UujuKq88IWDAkWXcoxdcAPiJpBv
	 v02wu1pSVEKrg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xHPNA-00000003Q3a-06QO;
	Thu, 15 Oct 2026 17:36:08 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: [PATCH 0/2] KVM: arm64: Cleanup the HCR_xyz macros
Date: Thu, 15 Oct 2026 18:36:03 +0100
Message-ID: <20261015173605.1072963-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

I've been postponing this for some time, but it finally happened: no
more HCR_xyz macros.

This series converts the whole thing in one go, using the script
fragment contained in the first patch. No AI agent involved, all bugs
are mine! I intend to take this in for 7.4-rc1.

Patches on top of kvmarm-7.4.

Marc Zyngier (2):
  KVM: arm64: Convert HCR_xyz to HCR_EL2_xyz
  KVM: arm64: Get rid of compatibility HCR_EL2 aliases

 arch/arm64/include/asm/el2_setup.h      |   4 +-
 arch/arm64/include/asm/hardirq.h        |   6 +-
 arch/arm64/include/asm/kvm_arm.h        |  79 ++--------------
 arch/arm64/include/asm/kvm_emulate.h    |  18 ++--
 arch/arm64/include/asm/kvm_mte.h        |   4 +-
 arch/arm64/include/asm/kvm_ptrauth.h    |   4 +-
 arch/arm64/kernel/head.S                |   4 +-
 arch/arm64/kvm/arm.c                    |  28 +++---
 arch/arm64/kvm/at.c                     |  18 ++--
 arch/arm64/kvm/emulate-nested.c         | 116 ++++++++++++------------
 arch/arm64/kvm/guest.c                  |   2 +-
 arch/arm64/kvm/handle_exit.c            |   2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  14 +--
 arch/arm64/kvm/hyp/nvhe/host.S          |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S      |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  20 ++--
 arch/arm64/kvm/hyp/nvhe/mem_protect.c   |   6 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c          |  32 +++----
 arch/arm64/kvm/hyp/vgic-v3-sr.c         |   4 +-
 arch/arm64/kvm/hyp/vhe/switch.c         |  12 +--
 arch/arm64/kvm/hyp/vhe/tlb.c            |   2 +-
 arch/arm64/kvm/inject_fault.c           |   6 +-
 arch/arm64/kvm/mmu.c                    |   8 +-
 arch/arm64/kvm/nested.c                 |   8 +-
 arch/arm64/kvm/sys_regs.c               |  24 ++---
 arch/arm64/kvm/vgic/vgic-v3-nested.c    |   4 +-
 26 files changed, 182 insertions(+), 247 deletions(-)

-- 
2.47.3

