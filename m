Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49EB413786;
	Thu,  6 Aug 2026 09:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786007436; cv=none; b=iCuyo6o1oi36h1OPCJi5vWykGtL3Ug5OYHRRl8xGAyEFn4d0LOErM0enfDDLjSXbcnn1C8tCREfwNTqGAfxG0RTe0e8tck3j1dU2IHNdm42kLCSxlbVisLXi+k5kVUfPcM0PoG5/mzzBekUZFnzbNhoZr4FXORkQXRB0qJkyXBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786007436; c=relaxed/simple;
	bh=8+zqllbEdqgMqzkU1SVo6YBPkX0Z0ssx7JhH/BTKah8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sTH4UqZgvliwwOD/qC5Cv6MMubHNu2EbripV9vwkVwhdPDRts4defLVsLq4m3tMHhYWjx6xnqBIlOu2mdiGn/KnhA4WgJRPhww/odJ2Ukb/Ej2TZfr6n4nsBNdb6BaW0wrvuE1JQnDWfTLDgpQp7aobPzcnARRlko/PUKku8Gkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bjZ38nMP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bjZ38nMP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439701F00A3A;
	Thu,  6 Aug 2026 09:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786007434;
	bh=ekP/15RiyRS1mHmgBngaG2DUHSQ1RkRl7k1DMWmUVvw=;
	h=From:To:Cc:Subject:Date;
	b=bjZ38nMPTWrRhP6qJYO2Hngk6a4aWbndg06pLlj//9Vspo1l+N1sSW7/y7hE3LRcu
	 5yMXQjQzrOBznd3tREJQpbzJT7P9pttE9dUiJha6dUX7ewR95Ct2UtKN0boP4JJYe/
	 il6zgqwFi4Cka4rLo1p/FHHkPSPSLliduSiawurp5nXy0dMKxq9epFET7y6emN6dD8
	 r+2ffw62KVUr75sR6hh1vdpAMAFzjY0dttZ+hs7Ul2Ibib3otWnddNAmzYCcyP2RQK
	 hvGpM/IbCkZP73tDmyQjzWc7qEmznlNHqqBaK2uiuAPDGJOPfzURhBknpf9ZNEkgVL
	 Wy/EtXgINcohw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wru7T-0000000CtHi-2I6S;
	Thu, 06 Aug 2026 09:10:31 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	ljs@kernel.org
Subject: [PATCH v2 0/8] KVM: arm64: VNCR TLB invalidation fixes
Date: Thu,  6 Aug 2026 10:10:18 +0100
Message-ID: <20260806091026.620700-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev, imv4bel@gmail.com, yaoyuan@linux.alibaba.com, ljs@kernel.org
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
  SCTLR_EL2.M into account. Yes, it is a special sort of sport to run
  a hypervisor with its MMU disabled...

- TLB invalidation by VA targeting the last page/block of TTBR1_EL2 is
  dropped on the floor, because I cannot count. This was amusing. Not.

Additionally, Sashiko kindly provided some extra horrors to look at:

- A missing sign extension for range invalidation results in the wrong
  VA range being considered.

- TLBI doesn't participate in the general MMU invalidation retry
  machinery, meaning that VNCR faults and TLBIs race in an
  uncontrolled way.

- TLBI and vcpu_put() can race badly, leading to a TOCTOU pattern
  which results in either a BUG_ON() or a call to vncr_fixmap(-1).

I have fixes for each of these issues, all stable candidates.

On top of that, I have a patch reintroducing the tracking that the
first patch removes, this time in a way that is actually functional.
Or at least I think it is...

I'd like to thank Hyunwoo Kim for their initial patch and for
providing a reproducer that helped me finding these issues by running
it at multiple levels of nesting.

It is now too late for 7.2, so let's try to make this 7.3 material
(hence the early repost).

* From v1 [1]

  - Added sign extension to range invalidation (Sashiko)

  - Use mmu_invalidate_seq to resolve fault vs TLBI races (Sashiko)

  - Speculatively bump the TLB refcount on fault to make sure the TLBI
    takes the slow path when we are going for a S1 walk

  - Clarify the check for the TLB matching for the S1 MMU state

  - Extra sanitisation added on the S2 invalidation path

  - Applied RBs from Yao Yuan to the patches that didn't change, with
    thanks.
    
[0] https://lore.kernel.org/r/ameGoxbn2wzBq2kL@v4bel
[1] https://lore.kernel.org/r/20260801124818.366274-1-maz@kernel.org

Marc Zyngier (8):
  KVM: arm64: Remove VM-wide VNCR mapping counter
  KVM: arm64: Handle negative S1 walk levels in VNCR TLB size evaluation
  KVM: arm64: Consider SCTLR_EL2.M when mapping the L1 VNCR page
  KVM: arm64: Correctly handle end of VA space TLBI invalidation
  KVM: arm64: Handle VNCR TLB invalidation race with vcpu_put() VNCR
    unmapping
  KVM: arm64: Sign-extend VA for range-based TLBI invalidation
  KVM: arm64: Make VNCR invalidation participate in MMU invalidation
    retry
  KVM: arm64: Add VNCR TLB tracking again

 arch/arm64/include/asm/kvm_host.h   |   4 +-
 arch/arm64/include/asm/kvm_nested.h |  14 +++
 arch/arm64/kvm/at.c                 |   2 -
 arch/arm64/kvm/hyp/vhe/switch.c     |  10 +-
 arch/arm64/kvm/nested.c             | 173 +++++++++++++++++++---------
 arch/arm64/kvm/sys_regs.c           |  11 ++
 6 files changed, 155 insertions(+), 59 deletions(-)

-- 
2.47.3

