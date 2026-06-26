Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CF413E559A
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 15:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782487924; cv=none; b=V/yMWuOrDrwCWx9Z8jAaUTN9W8IoVNV4wBnn6NfVHAzCdo7ozaJLotBbDch67Ha1677uT0hhEJYauaoV5MeS2OljD52c9ps6Gb4ucoZHc3n84UdoBllf1HSHkqviqSKZT30Q9Sp9xS0AiUEMN2hhlM1zjF69EvVeIqKwsG7dtVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782487924; c=relaxed/simple;
	bh=QupxKpujNRWQR6aUPinOmOnAwx97mTzDEtfs1dytDhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=JO5ptYc5f5aDTYEj14l3p88YbzanR1SjjRDxa2k3DFKZq82ER8/bE9ePg30sE4iLPh2EzK2GUNgiDO4cOD2AOHGsWL9g8izbGhu9wX21XWWw7u6LnQBByEIpHeroEjlLhvx7EAYE2gpmAC2ROsOPxodTdUO3Xsxhi4CYphOr+Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jYoiti5I; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jYoiti5I"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C6EB61F37;
	Fri, 26 Jun 2026 08:31:57 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 283E13F632;
	Fri, 26 Jun 2026 08:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782487922; bh=QupxKpujNRWQR6aUPinOmOnAwx97mTzDEtfs1dytDhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jYoiti5I5NeNojHkG1QgEr69b1xokk+kUev6ycpPcCUf/xX2sJmrWxi9AtQ5OZc/D
	 0H7oPvYcK7assVb+AJB75iYyla+FDR5InskWibfhs+vW3/mEO/TXFfHjgfvnDWMrwa
	 2KFF1cwTy1/xohbCYd4OINpzs3LykFuVYhP65izw=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 00/22] KVM: arm64: nv: Implement FEAT_HAFDBS, FEAT_HAFT
Date: Fri, 26 Jun 2026 16:31:50 +0100
Message-ID: <aj6bZZLSk24Ze6_S@LeoBrasDK>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260623184201.1518871-1-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jun 23, 2026 at 11:41:39AM -0700, Oliver Upton wrote:
> KVM's support for hardware descriptor updates has been lacking, owing in
> large part to the fact that the most widely available NV2 hardware
> actually lacks HAFDBS :)
> 
> This series brings support for hardware dirty state and table Access
> flags to the nested MMU. While KVM uses neither of these features, the
> kernel definitely does in the stage-1 page tables. Since there is only
> one hypervisor to rule them all, implementing this stuff at stage-2 is
> mostly motivated by the desire to enable guest stage-1 :)
> 
> Implementing dirty state at stage-2 is a bit more challenging than
> anticipated, I'm in the middle of seeking a relaxation from Arm that
> would make this all architectural. See the last patch for the details.

Hi Oliver,

Haven't read your patchset yet, but in regards to stage-2 dirty-state
tracking, there have already been some efforts in the area, also
implementing HDBSS and HACDBS in a way of improving performance / reducing 
impact of live migration on a system.

HDBSS support is being done by Tian, and according to his last message, we
should have a v4 at any moment:
v3 link:
https://lore.kernel.org/all/20260225040421.2683931-1-zhengtian10@huawei.com/

I am working on the HACDBS implementation myself, and plan to send a v2 
next monday. (Just waiting the merge window to close)
v1 link:
https://lore.kernel.org/all/20260430111424.3479613-2-leo.bras@arm.com/

Thanks!
Leo


> 
> Applies to kvmarm/fixes since this depends on some of the earlier VNCR
> rework. Lightly tested on an implementation with HAFT.
> 
> Oliver Upton (22):
>   KVM: arm64: nv: Introduce struct for stage-2 walk step
>   KVM: arm64: nv: Consolidate computation of stage-2 permissions
>   KVM: arm64: nv: Get rid of kvm_s2_trans*() accessors
>   KVM: arm64: nv: Only shadow writable-dirty guest descs as writable
>   KVM: arm64: nv: Pass an access descriptor for stage-2 walks
>   KVM: arm64: nv: Use a helper for stage-2 descriptor updates
>   KVM: arm64: nv: Set dirty state at stage-2
>   KVM: arm64: nv: Treat DBM as writable at stage-2
>   KVM: arm64: Compute S1 permissions as part of s1_walk()
>   KVM: arm64: Plumb through access descriptor for stage-1
>   KVM: arm64: Use a struct for stage-1 walk context
>   KVM: arm64: Create helper for stage-1 descriptor updates
>   KVM: arm64: Set dirty state at stage-1
>   KVM: arm64: Grant write permission when DBM is set at S1
>   KVM: arm64: Don't update descriptors for "non-arch" access
>   KVM: arm64: nv: Expose FEAT_HAFDBS
>   KVM: arm64: Set Access flag on table descriptors at stage-1
>   KVM: arm64: nv: Set access flag on table descriptors at stage-2
>   KVM: arm64: nv: Expose FEAT_HAFT
>   KVM: arm64: selftests: Only test AF behavior for emulated AT insns
>   KVM: arm64: selftests: Test that AT emulation for FEAT_HAFT
>   HACK: KVM: arm64: nv: Set the dirty state for CMOs that fetch for
>     write
> 
>  arch/arm64/include/asm/kvm_arm.h       |   1 +
>  arch/arm64/include/asm/kvm_nested.h    |  94 +++------
>  arch/arm64/include/asm/kvm_pgtable.h   |  17 +-
>  arch/arm64/kvm/at.c                    | 267 +++++++++++++++++--------
>  arch/arm64/kvm/hyp/pgtable.c           |  11 -
>  arch/arm64/kvm/mmu.c                   |  36 +++-
>  arch/arm64/kvm/nested.c                | 251 ++++++++++++++++-------
>  tools/testing/selftests/kvm/arm64/at.c | 102 ++++++++--
>  8 files changed, 515 insertions(+), 264 deletions(-)
> 
> 
> base-commit: d098bb75d14fde2f12155f1a95ec0168160867ce
> -- 
> 2.47.3
> 
