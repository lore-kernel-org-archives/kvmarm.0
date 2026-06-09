Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3717A3B27EC
	for <kvmarm@lists.linux.dev>; Tue,  9 Jun 2026 18:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781031321; cv=none; b=nHaKZhZBcuXva0xRZN7XLttutxUZBT+Ur2KqJJ6C/yRo2U1i/QF1YShDkZH6AU1mxDoTVQH56db4L05SLonCwfgHGDuci6TOM3dNETCxYUUshlGBvBT2tAnVjz5rkvo6GF9Cx4JHoVI+Uztx4ASR7anjvO/u/aszqdkLT/pU4Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781031321; c=relaxed/simple;
	bh=NApicFWs2EeFGhFg80oq+kFniEG1RghtPeWHNNHgaBE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IU/nWo6796tBOS7GnlrmPnO7faWrulyYVeuwjeK0szYap6Fl18HebiXz/T7QkBm/mKfQgmMYt7Z3N0rpgjlE0QxYyB+RYe4gPWmvu7TSSvECmBCxCeZqQrIiQ7esKKmINiUtWHMn2coj9erLE3nbUi3c/lT05CHdnHG0nkGm4Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jKB6q5mO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jKB6q5mO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06481F00893;
	Tue,  9 Jun 2026 18:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781031319;
	bh=dGzp5cXTivHGeXtJ5cnc6r8CicmghrZq8NjxACDfGCE=;
	h=From:To:Cc:Subject:Date;
	b=jKB6q5mOC2UScYk75b+FIoichLhaFjYMIrCCSMmFJmqxFQgnT07e9oWBGT5ol7fxl
	 VnPEuwJ1hAhIDs/na5RqPKru7kYKhcSGUP/tVTktAVJ2hXlN366mxikYGmOpSAbJra
	 ywSjyOdNvUW3iLx/2ZVkDg9OhFhHnRLpEjC/kTEXg848UPmMdhdinxCOk5zGr1gwWj
	 lZ/6nSFQT3/J11uRRZTaqDDl4V7YbKvtvGRBBKopmXv2Lbk2wexE6LX69LSvoAosXS
	 lA4I3BTP/rsi8uZzMVLw9JKT5RaSCeI1M/onNAypTqtNBIkzOp+BmXiTyimxo0qg26
	 VdPls852ET1iA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH RESEND v2 0/5] KVM: arm64: nv: Even more VNCR fixes
Date: Tue,  9 Jun 2026 11:55:09 -0700
Message-ID: <20260609185514.746507-1-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Argh, resending. Forgot to clean out my staging directory first. Sorry!

Yes, even more.

On top of the first pile:

 - KVM needs to fault in the PFN for write before mapping the L1 VNCR
   with write permissions in the host stage-1

 - Hack to prevent KVM from mapping a non-memory PFN with cacheable
   mappings. This doesn't align perfectly with the semantics at stage-2,
   boo hoo.

 - Bonus change to break VNCR abort loops in case by bugging the VM if
   KVM doesn't know how to handle the fault

Tested by running an L3 VM with kvmarm/next

v1: https://lore.kernel.org/kvmarm/20260608161446.718957-1-oupton@kernel.org/

Oliver Upton (5):
  KVM: arm64: nv: Respect read-only PFN when mapping L1 VNCR
  KVM: arm64: nv: Inject SEA if kvm_translate_vncr() can't resolve PFN
  KVM: arm64: nv: Re-translate VNCR before injecting abort
  KVM: arm64: nv: Inject SEA if guest VNCR isn't normal memory
  KVM: arm64: nv: Mark VM as bugged for unexpected VNCR abort

 arch/arm64/include/asm/kvm_nested.h |   8 ++
 arch/arm64/kvm/at.c                 |   8 --
 arch/arm64/kvm/nested.c             | 164 ++++++++++++++--------------
 3 files changed, 92 insertions(+), 88 deletions(-)


base-commit: 406f0c31f47877db036e885f15830106b89ca950
-- 
2.47.3

