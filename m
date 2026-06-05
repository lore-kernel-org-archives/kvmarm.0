Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF08236F8FD;
	Fri,  5 Jun 2026 16:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780677924; cv=none; b=t573zbsD1jBxSIE4BOjTbDm/3z9OZQ95f2eDzbjQt33NTjj2nfsdEw7hm9z3t81dUrcm3+L7Zd6LQpoEMbGvblCBBLqaFWtSLIG+pMYqAU0eKpK+fNceIeF2AMvA+AbNfvMl5PxLkX9sI4KeTxwTqa+9JEP3QOwdj3ZADjdIGLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780677924; c=relaxed/simple;
	bh=/6/+58xqNx1F/kKe1JhB2RFsBJZa57ebTg2PtlKqWtk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h+f1vldqyec8XmW+r82lfOLlzuVw/EwxkOjYRH54vRzrIIgrUpf15/KhUnEd71WoyhDEPODzcMY6d7VQBfQTXQ4OPSy0j1cpr6ngOj9I4Ta2E4G/1I3tNbBvyCp2oNC8YRvcrs8mTCVUcqltBVfAPY1FP/1QFpGSokuWuY1fmnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OjK8K5k4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OjK8K5k4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDBF1F00893;
	Fri,  5 Jun 2026 16:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780677921;
	bh=KB02rpRMRUcfAvlmeMfhCcaEDyoWU3wB7fjdf8ZKlQw=;
	h=From:To:Cc:Subject:Date;
	b=OjK8K5k4KaldBITb/iA5qTAFwrvV+Gz3sVNozHPSYSqpatHJlA4PAM3PrAgaxalaC
	 yP1GopJ/MRfoC7AlCiiVRmZH+OQYm61MHASiPoFtSdzn/eaSHIKAG2V2ruYdNss4v9
	 JDgryOtfA3DFDORaflk9q9IU2xYM3cmpJ+qnTdd1eECZajiAMv/49yGpIwoU2SntaF
	 kEQdDkge91TndMlGrma9fiUzSNwP8jXtM5q42q0QZistQu1mRwf8cRLhyIbeSSasKd
	 o+xxLRt/6c7mpn1wyUpQLgCpr0oJcYYGZXDWqBoSMBIWcqigeujWfUfd7bSf2YAhoh
	 kc2eHwqaDpaZQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wVXfb-00000009qai-1RCM;
	Fri, 05 Jun 2026 16:45:19 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Hyunwoo Kim <imv4bel@gmail.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 7.1, take #5
Date: Fri,  5 Jun 2026 17:45:16 +0100
Message-ID: <20260605164516.2214533-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, imv4bel@gmail.com, joey.gouly@arm.com, oupton@kernel.org, weilin.chang@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

Yes, I said that last week's pull request was the last. I really meant
it, honest. But people (and their AI best mate) keep finding ugly
stuff in dark corners, and I can't sit on this stuff much longer.

So here we have an assorted mess of bad races, broken userspace, and
architectural bugs. What's not to like? As usual, details in the tag
below.

Please pull,

	M.

The following changes since commit 83726330748981372bde86ed5411d7b306612991:

  KVM: arm64: Correctly cap ZCR_EL2 provided by a guest hypervisor (2026-05-29 10:04:00 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-7.1-5

for you to fetch changes up to 17f073f78fc43280891ecde8f8ec3f84f98bb37c:

  KVM: arm64: Correctly identify executable PTEs at stage-2 (2026-06-05 14:07:57 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 7.1, take #5

- Correctly drop the ITS translation cache reference when it actually
  gets invalidated

- Take the SRCU lock for SW page table walks

- Restore POR_EL0 access to host EL0, avoiding POR_EL0 becoming
  inaccessible from EL0 after running a guest

- Reassign nested_mmus array behind mmu_lock, ensuring that vcpu init
  and MMU notifiers are mutually exclusive

- Correctly handle FEAT_XNX at stage-2

----------------------------------------------------------------
Hyunwoo Kim (3):
      KVM: arm64: vgic-its: Drop the translation cache reference only for the erased entry
      KVM: arm64: Take the SRCU lock for page table walks in fault injection and AT emulation
      KVM: arm64: Reassign nested_mmus array behind mmu_lock

Joey Gouly (1):
      KVM: arm64: Restore POR_EL0 access to host EL0

Oliver Upton (2):
      KVM: arm64: nv: Fix handling of XN[0] when !FEAT_XNX
      KVM: arm64: Correctly identify executable PTEs at stage-2

 arch/arm64/include/asm/kvm_nested.h     |  4 ++--
 arch/arm64/kvm/at.c                     |  6 ++++--
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 ++
 arch/arm64/kvm/hyp/pgtable.c            |  4 +++-
 arch/arm64/kvm/nested.c                 | 33 ++++++++++++++++++++-------------
 arch/arm64/kvm/vgic/vgic-its.c          |  6 ++++--
 6 files changed, 35 insertions(+), 20 deletions(-)
