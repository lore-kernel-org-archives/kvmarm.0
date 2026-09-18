Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFBFF4F5E14
	for <kvmarm@lists.linux.dev>; Fri, 18 Sep 2026 14:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789743317; cv=none; b=MEhUgSsOu+ha2/eHV4amlhnLbZRFjMRrwy3fdpthDhBZRCe+OEEbCSCQ+2S6k9uQKv1lYern8agr4L3kc42xd9IXZin8kwqBVrkDnFkSqLf252sk67BIrC5i96n62iUQ2sn/8CqVwHI9/mEwLdZDaO1hfz0Vg9CEOt0b3CLsjEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789743317; c=relaxed/simple;
	bh=95Lr+PmMj7HxN1XXw1kqIJrzTIPr/Sc8TW+cNaDyjn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=ug4/g1lbs2bzl7hMIv2Y2pEv7ZMBrkbJnXsWNBPsZyWTNZz9pCzzA7/nCs/o7i+4D2GFceUv3szsTH7rr6CpZtFZzGojxMPy1FU2fpgVLMLGwPXf7wzvhOFzbPQ6TpLCXbBfL8kiKstPMM7kgsL36sBEj49u1w1A5AT1KLmBmjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=b/NZSPRy; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="b/NZSPRy"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5FC49168F;
	Fri, 18 Sep 2026 07:55:09 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (unknown [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7D5D13F86C;
	Fri, 18 Sep 2026 07:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789743312; bh=95Lr+PmMj7HxN1XXw1kqIJrzTIPr/Sc8TW+cNaDyjn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b/NZSPRyN/bSoalpu3s5V5H20FRSOcJzsD81iElRkXTaKFAoGewQ/s/UNwuafals/
	 iHVXNR3LedtXDn/t9CGHPbp4E6VicXkPtS6pLTmrhqi9ULV6pLAYuAwP+GiK+BWaZM
	 zIdMrFPruAoPHFSA9pw8xWVHTTbi3mz5P6FFAoxQ=
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
Date: Fri, 18 Sep 2026 15:55:03 +0100
Message-ID: <aq1Qx0z_aUNvm44n@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
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

Hi Oliver,

I spent some time trying to study NV, and I think I can understand the 
patchset a bit better now, so I would like to share my review on it.

I will start reviewing it, so please let me know if you prefer if I wait 
for a next version, or something like that.

Thanks!
Leo
