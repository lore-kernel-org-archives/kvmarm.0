Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18280481668
	for <kvmarm@lists.linux.dev>; Tue,  9 Jun 2026 18:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781031128; cv=none; b=QQs7WrmuvHGxlgSoJTCjjQ7/xcXhM3FRiEHHmKSvYlzLwADUMyubDQNhzB1x01X7HporYKvI8pg8nQN0MD//WoFKTOpws3tWnvMEB0gvfA39bzNam1GayzddfY5B7TXd9u3WWxyBXYkoGmGTJ91ozIU30SqOA8uT6XdnSk0Q9cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781031128; c=relaxed/simple;
	bh=dVXHGfmGiWGcZ8widkmO/tjhzM98DEDGgWzWTL+BKaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gLWtHuLyB18YzSoBPmab0IyeBRRIhvyYxkR2xNAkVJSlqhaee+nubVDfn/SWDd3m0CCxqj4fAVe//8fgO9Qv5gESpwV9GyNPQ6ONvZUCBZHNXwRYXGUUI3k0ydjgmDc9BG8p2exu7Y2OlyBEfDKFKCe+1fe9hpJWdNGhdwHMaq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mb6G8Qbu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mb6G8Qbu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DADCB1F0089C;
	Tue,  9 Jun 2026 18:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781031127;
	bh=zgpXKV6dTzbajip+l1+DrPqam2Kj0F/Ycqk+qeoAKuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mb6G8Qbu8/xtJtBq9fb1MkgAez3pwNTTFds/l8UIzsxx4cNQO0OxGe/4+ktkMHuE5
	 8yPOLzr5+cfMxxju4aMUPEEt9/0+jPaX5Lp13q3vhhT+xm4oTp/kkkL7lG5DAY9q9q
	 R5r9YaSVk4ohMzuyGyqEQGvKThXBlFagHnYdWTWLz2W245YwW/k5kyxOsiGwePk9mp
	 btnfYlelgLj5MkLRiqgiC2hE926b9eFr6auQZxmG4k/KmfVuJlxUEQ3dvdLu/lYB83
	 J8LA3wy1ptu6Yfr5iQ/jfSRBmwyPxOkCrT5KnMpvHPDqmE3sl+xg2WrLNTO1mzzkRG
	 9kbUwiX0QMOlg==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 0/5] KVM: arm64: nv: Even more VNCR fixes
Date: Tue,  9 Jun 2026 11:51:59 -0700
Message-ID: <20260609185204.745929-4-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260609185204.745929-1-oupton@kernel.org>
References: <20260609185204.745929-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

