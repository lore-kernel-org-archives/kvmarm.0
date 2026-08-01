Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF642472B8;
	Sat,  1 Aug 2026 12:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785588522; cv=none; b=lQ+OMvAfGWz9BixPuqizdR19vnbY4SmHjoFW0ecfiIDxY9Izf2n5oX4x5mqxVXC9O2q0jPkZyIpJVJnLd6WSbDfznRfd7Xp1hI24it3JqcgSWtCbUBVgU1b+/BS+YfB3pmiU+JZ+II7kDjXezEnKZyAdZKi3IxZVV4HhpmGpXm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785588522; c=relaxed/simple;
	bh=a40C7S3vmVW5m2CBGcsUTdZYQ9++SwgmdHQF+nYXH5E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r/vzO/kNuwz6GXAog1fY+c7y21iaaoujdP8835Jq8P1dwrWDI2tD4lkB/yTZjwziXolrrZqBreALKW52O9qy2nqXCPzv5mlX5GqijouyBfboHH+0ZUkCxyJnZp54dIg2ThohSXmP3P6Xn7NaqPsafzsrJb0Ta9iOHgI1KrkzQqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UO8sRV1c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UO8sRV1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA9C1F00ACF;
	Sat,  1 Aug 2026 12:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785588521;
	bh=SCuqMDpuQQzx9dcXw3N6jP0KkAKpom7E/b6/DDyvjNo=;
	h=From:To:Cc:Subject:Date;
	b=UO8sRV1cyWGFm1QWOzzy2YPayy1cdlEtK1rfTtHB0LAp6tHuqDATDebldH2Bgvg14
	 8BfTrIoWuFOhs61EyoyB0h9DPaUNqFC+m6kpIlkari57vc3YdReKzLuHuJlo2sos38
	 qOQtDDapFh63mx2zKQbUfT29LExDqf1XJ/z26OoVw2RMoQRIh9o/mtXc8B0V4bG979
	 wy5pu2p8+j9KvAg/oL8jhxAGY5KXdd+o/FIFfhYm+P6uR8E1D7c3HEcOsDCfQaevAB
	 LDmYKsf6jJernlKYsGKySqG005OvIXZITpGd4aoURFL0xJFnlqqti2kv/FNGlwWPwc
	 6mzgdpK2St4sQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wq98p-0000000BGK2-0lGL;
	Sat, 01 Aug 2026 12:48:39 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Hyunwoo Kim <imv4bel@gmail.com>
Subject: [PATCH 0/6] KVM: arm64: VNCR TLB invalidation fixes
Date: Sat,  1 Aug 2026 13:48:12 +0100
Message-ID: <20260801124818.366274-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, imv4bel@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Prompted by a patch [0] from Hyunwoo Kim which was addressing a pretty
annoying corner case, I spent some time looking at what was wrong in
our VNCR TLBI code. And there was a few things to say about it...

- The TLB tracking to get into the slow path is wrong. It tracks what
  is mapped, but not the established TLBs. Kind of annoying.

- Handling IPA invalidation when the TLB was established with the S1
  MMU disabled is failing for a number of reasons. This is the bug
  that Hyunwoo Kim found, but I decided to address it at its root
  rather than just fixing the symptoms.

- Deciding to run with a VNCR TLB doesn't take the state of
  SCTLR_EL2.M into account. Yes, this is a special sort of sport to
  run a hypervisor with its MMU disabled...

- TLB invalidation by VA targeting the last page/block of TTBR1_EL2 is
  dropped on the floor, because I cannot count. This was amusing. Not.

I have fixes for each of these issues, all stable candidates. On top
of that, I have a couple of patches reintroducing the tracking that
the first patch removes, this time in a way that is actually
functional. Or at least I think it is...

I'd like to thank Hyunwoo Kim for their initial patch and for
providing a reproducer that helped me finding these issues by running
it at multiple levels of nesting. It is most probably too late for
7.2, so let's try to make this 7.3 material.

[0] https://lore.kernel.org/r/ameGoxbn2wzBq2kL@v4bel

Marc Zyngier (6):
  KVM: arm64: Remove VM-wide VNCR mapping counter
  KVM: arm64: Handle negative S1 walk levels in VNCR TLB size evaluation
  KVM: arm64: Consider SCTLR_EL2.M when mapping the L1 VNCR page
  KVM: arm64: Correctly handle end of VA space TLBI invalidation
  KVM: arm64: Couple VNCR fixmap clearing and CPU number invalidation
  KVM: arm64: Add VNCR TLB tracking again

 arch/arm64/include/asm/kvm_host.h   |   4 +-
 arch/arm64/include/asm/kvm_nested.h |   7 ++
 arch/arm64/kvm/at.c                 |   2 -
 arch/arm64/kvm/hyp/vhe/switch.c     |   4 +-
 arch/arm64/kvm/nested.c             | 109 +++++++++++++++++-----------
 5 files changed, 78 insertions(+), 48 deletions(-)

-- 
2.47.3

