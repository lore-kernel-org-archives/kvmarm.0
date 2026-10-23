Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792788976;
	b=q/nVamKLmJDV0wej9nNT1iapvv1xydSaeptvhYfEB87JXUcdxBKLYHH8pBl7JfFv5kf7
	 DO88Oj06bWiRNb3N8LRqVW+VNYRACFUovcT4a8FWV22ce1ICyphim9uHUapCwjwqe8Dke
	 uwerMwLJh2/xwtTgOzJDopXi75tgWFSaLcCABhkZb2AyTQr6StQOjvYGgzOM/dzhfQW8t
	 plhQWBL1oDypEbF2929hmVJjMaI8lDHO7iGA+9vrVNiqoOnht5QQalsKxwqy4moTfZnO1
	 0rryCj5GXKU5doGR+SYAYqvCSrw67died6muiF8seHZhUnRbjlasK4t+hMxL7rYEK7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792788976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W96mDA4gkpXuaR20Qz+COdtrqjPlJKkLgYaq2ttMlwY=;
	b=ZaepSiAU62z35+EjRgeZo56eJdTtbZwY+Fb1DFn6FkhY9b7clVq7L9LptYXQ8DICv5YE
	 XqaUEFylqCSqacwJf1N3Ywwt3Gt/66pVLPc92e2SYp/qHZhVXt5V66gqMXEsdJogwk8dc
	 7utS2vr7m5VBen+Kk1AwC0qRFu5KoP2pT8C1bnwjd4TS9Z1XC8AC3Jy+Q7HVEo7joCXc9
	 jhQZwqd8bOQnkTqB25zlQHre0p7oA3kv0hDU9zCN0+CYLz2S9/VghPwjnQa5oCEdb4PVw
	 uV+7euuO4dKRFllK7Kirm+70K3yh3vt6qWpPiMN57BzJ5vvBNX7EtnYdoHQCluu9zJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I01s5MhW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6369E606A31E
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 20:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I01s5MhW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923011F01825;
	Fri, 23 Oct 2026 20:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792788975;
	bh=W96mDA4gkpXuaR20Qz+COdtrqjPlJKkLgYaq2ttMlwY=;
	h=From:To:Cc:Subject:Date;
	b=I01s5MhWbXcNTMpFrkpkEZM+pTOKoh7TRKF4edNQMlE/Q2q3edQuFs+wwxHxsgfWT
	 T6ZzQD9Evduh9FOMj2+0xjF59+LgsUN/VjcHxLykE4ME13HnkvM/M2XHU+VGYHu9Xy
	 uPX1dDl2DlrXxkfXx3QsO04dRaHoIezGMDK0o5jJztDM/f7y+UYWVTxAW8IcS3uGrF
	 LP73cRuHwVOlqg1nXTNixzEQcCjmiWR18jSnTNCNFEZkOZGGwo5tmBXMSzgnaA/QU9
	 oYHJj5tV4Guh6inIuPa/foOB/TabME02XsjvghELUEXrMDfPeSdE/bMIRJW5LWJ/Av
	 SlFM8nh98H85A==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Leonardo Bras <leo.bras@arm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 00/28] KVM: arm64: nv: Implement FEAT_HAFDBS, FEAT_HAFT
Date: Fri, 23 Oct 2026 13:55:42 -0700
Message-ID: <20261023205610.1044532-1-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Here's v2 of the series adding dirty state and table access flags to
KVM's table walkers.

I spent quite a lot of time twiddling with CMO emulation to work around
the architecture. But I eventually got pissed at the whole problem and
tore it up. Ultimately, we shouldn't have to handle every ridiculous
hardware permutation in KVM; assuming FEAT_S2FWB is present on a system
with FEAT_NV2 is not a stretch of the imagination.

So I ran with that and decided to just NOP the CMOs when everything is
observable in the VM at the PoC, including instruction fetches and DMA.

Ultimately, the use of noncoherent DMA with forced writeback is
braindead. On top of that, noncoherent DMA isn't worth caring about in
future development of KVM when disabling FWB outright is a perfectly
viable alternative. Patches #19 and #20 enforce this and provide the
necessary escape valve.

v1 -> v2:
 - Limit FEAT_HAFDBS to VMs that are known to be fully coherent
 - Abuse the above dependency to treat CMOs as NOPs that use a
   writable-clean alias to cacheable memory
 - Pick up a fix for programming TCR_EL2.HA when vEL2 is in the EL2
   translation regime
 - Add command line switch for disabling FEAT_S2FWB, aliased in such a
   way that we can select the 'bypass' memory attributes when S2FWB page
   table formats become mandatory
 - Tracepoints for the MMU walk steps at stage-1 and stage-2
 - Address feedback from Leo, Wei-Lin and Sashiko
 - Collect tags
 - Plenty more I'm forgetting.

Oliver Upton (28):
  KVM: arm64: nv: Introduce struct for stage-2 walk step
  KVM: arm64: nv: Consolidate computation of stage-2 permissions
  KVM: arm64: nv: Get rid of kvm_s2_trans*() accessors
  KVM: arm64: nv: Only shadow writable-dirty guest descs as writable
  KVM: arm64: nv: Pass an access descriptor for stage-2 walks
  KVM: arm64: nv: Use a helper for stage-2 descriptor updates
  KVM: arm64: nv: Set dirty state at stage-2
  KVM: arm64: nv: Treat DBM as writable at stage-2
  KVM: arm64: Compute S1 permissions as part of s1_walk()
  KVM: arm64: Plumb through access descriptor for stage-1
  KVM: arm64: Use a struct for stage-1 walk context
  KVM: arm64: Create helper for stage-1 descriptor updates
  KVM: arm64: Set dirty state at stage-1
  KVM: arm64: nv: Respect HA when computing translated TCR
  KVM: arm64: nv: Respect HD when computing translated TCR
  KVM: arm64: Grant write permission when DBM is set at S1
  KVM: arm64: Don't update descriptors for "non-arch" access
  KVM: arm64: nv: Emulate CMOs via writable-clean translations as NOPs
  arm64: Add command line switch to disable FEAT_S2FWB
  KVM: arm64: Reject non-coherent DMA when using forced writeback
  KVM: arm64: nv: Expose FEAT_HAFDBS
  KVM: arm64: Set Access flag on table descriptors at stage-1
  KVM: arm64: nv: Set access flag on table descriptors at stage-2
  KVM: arm64: nv: Expose FEAT_HAFT
  KVM: arm64: selftests: Only test AF behavior for emulated AT insns
  KVM: arm64: selftests: Test AT emulation for FEAT_HAFT
  KVM: arm64: Add tracepoints for S1 page table walk
  KVM: arm64: Add tracepoints for S2 page table walk

 .../admin-guide/kernel-parameters.txt         |   4 +
 arch/arm64/include/asm/kvm_arm.h              |   1 +
 arch/arm64/include/asm/kvm_emulate.h          |   5 +
 arch/arm64/include/asm/kvm_host.h             |   2 +
 arch/arm64/include/asm/kvm_nested.h           | 110 +++----
 arch/arm64/include/asm/kvm_pgtable.h          |  17 +-
 arch/arm64/kernel/pi/idreg-override.c         |   2 +
 arch/arm64/kvm/arm.c                          |  14 +
 arch/arm64/kvm/at.c                           | 277 +++++++++++------
 arch/arm64/kvm/hyp/pgtable.c                  |  11 -
 arch/arm64/kvm/mmu.c                          |  45 ++-
 arch/arm64/kvm/nested.c                       | 288 +++++++++++++-----
 arch/arm64/kvm/trace_arm.h                    |  99 ++++++
 tools/testing/selftests/kvm/arm64/at.c        | 102 +++++--
 14 files changed, 704 insertions(+), 273 deletions(-)


base-commit: dd0bc00e3e9201fd49b62ff9cc07890c89003afe
-- 
2.47.3

