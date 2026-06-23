Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F343537F7
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 18:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782240126; cv=none; b=VX+2INIFeXwLpAm4bKew1RzPx3wKbCHGnTW/wx7rGysuErpZ9I8lEF2+VeC0PFg3SQdz0MuWo1RIPs4gbW0LZxpmTxHq2C19DbGfk3CqeIX3zKo+tK/2ayiQpYBhUsLN7Sddu0q98SGdjGGO3MONAaRqn9LfFnPLl+OoBH9tdww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782240126; c=relaxed/simple;
	bh=48F/MNXQw25EdrdBGNZyWMsqTl17ELdUDcaRkK5MuRI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=imZ1wtKCpqi/GIKiIM7gElW+Q01RD078osMArNNKVW7f/PU1IN7vxiO0wXQl1pnsqZCeyfgbLImTmCP+DSsfO/yLj3gLrvV/3VqQ8cQQp+Mr6aDnT7XHChTeSb11ogbiFq7GwGz0/B/ytfNwZ5f3zzTWrUk/HjR0w/QLdJwMGX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DA94hy2O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DA94hy2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFCEB1F000E9;
	Tue, 23 Jun 2026 18:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782240125;
	bh=b2MWNe9vaeoNNWdmvoPYJxgIovugyYHaGXkGawEOHbg=;
	h=From:To:Cc:Subject:Date;
	b=DA94hy2O+ooe4hJJvCvL3JLJKH8oXhfHMduWsjEc2BBxGT6YmU8Q60YRvT/jIvv8g
	 /eVlnY9BOyAUeamYLNYlMMnZn5knL047+UpxQeDbYHqPD/Swwy8vjJ6l6Od/AWk7eu
	 TQQ2liM/Yg9KREQfi+53s3QZ7fIOPYC8GvOwgA61cNusTK65bZ+hO2NXW73D3kDTfw
	 bQM0n0fUoW+8Ky5Uva6kvwJwl85SpCXG4hljQv0r+zTbLoWTlg0aOcCYNFHYxFEgPH
	 cJhFYaFzUZA7v/zhnNClYPavU0qjZ0rC4EDS0dHMgpHF+7ZE1l8+FTwoeiUxU0eP/t
	 4McWaTM4I9npg==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 00/22] KVM: arm64: nv: Implement FEAT_HAFDBS, FEAT_HAFT
Date: Tue, 23 Jun 2026 11:41:39 -0700
Message-ID: <20260623184201.1518871-1-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM's support for hardware descriptor updates has been lacking, owing in
large part to the fact that the most widely available NV2 hardware
actually lacks HAFDBS :)

This series brings support for hardware dirty state and table Access
flags to the nested MMU. While KVM uses neither of these features, the
kernel definitely does in the stage-1 page tables. Since there is only
one hypervisor to rule them all, implementing this stuff at stage-2 is
mostly motivated by the desire to enable guest stage-1 :)

Implementing dirty state at stage-2 is a bit more challenging than
anticipated, I'm in the middle of seeking a relaxation from Arm that
would make this all architectural. See the last patch for the details.

Applies to kvmarm/fixes since this depends on some of the earlier VNCR
rework. Lightly tested on an implementation with HAFT.

Oliver Upton (22):
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
  KVM: arm64: Grant write permission when DBM is set at S1
  KVM: arm64: Don't update descriptors for "non-arch" access
  KVM: arm64: nv: Expose FEAT_HAFDBS
  KVM: arm64: Set Access flag on table descriptors at stage-1
  KVM: arm64: nv: Set access flag on table descriptors at stage-2
  KVM: arm64: nv: Expose FEAT_HAFT
  KVM: arm64: selftests: Only test AF behavior for emulated AT insns
  KVM: arm64: selftests: Test that AT emulation for FEAT_HAFT
  HACK: KVM: arm64: nv: Set the dirty state for CMOs that fetch for
    write

 arch/arm64/include/asm/kvm_arm.h       |   1 +
 arch/arm64/include/asm/kvm_nested.h    |  94 +++------
 arch/arm64/include/asm/kvm_pgtable.h   |  17 +-
 arch/arm64/kvm/at.c                    | 267 +++++++++++++++++--------
 arch/arm64/kvm/hyp/pgtable.c           |  11 -
 arch/arm64/kvm/mmu.c                   |  36 +++-
 arch/arm64/kvm/nested.c                | 251 ++++++++++++++++-------
 tools/testing/selftests/kvm/arm64/at.c | 102 ++++++++--
 8 files changed, 515 insertions(+), 264 deletions(-)


base-commit: d098bb75d14fde2f12155f1a95ec0168160867ce
-- 
2.47.3

