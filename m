Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1881E3B2D00;
	Mon,  3 Aug 2026 13:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785765016; cv=none; b=izOhEyAS2IfuQBBxmGOkWQu0IrvA4S4aYSIRq8Zodtw3CN9HaKpS9mW2dX092CIKDKyMsD02Kj/xPmRDgcoSkyynJ4j0q588hEp/SBvYCzfF+uNKc1h3J/ym+E4TqZqrSdMiejd88Ea7XT4JWVf3db0T5fNpL7S9ctKQXfx0MG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785765016; c=relaxed/simple;
	bh=NjyDjGRzfHjbohZU2w2EV+uiABmPcJeEg1XGu42/EJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=NrfLG1Ewo4dunoUZ0SqexjEjgifcelbCOhkhO/orUznH+p0V3up8EkOrf64HsoxxaPgQx2Pi4nZyqUd8B8q19hLQMCVGNYhpKbmTOKIs1W9hEXGxNEE3APcJLPkWAWkQuZFd/yg5LIgvjKFh1vKnuhjXQ8Q1CuXR1gqYAQ+uBZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Z26mBvt6; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Z26mBvt6"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 76DFD1476;
	Mon,  3 Aug 2026 06:50:09 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AB16D3F66F;
	Mon,  3 Aug 2026 06:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785765013; bh=NjyDjGRzfHjbohZU2w2EV+uiABmPcJeEg1XGu42/EJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z26mBvt6MT2NXtX5GnM6tVcMC+MbIotRwilmHneQHLPQ1rVPy7gVHpYF5sqDTjp1V
	 TMzPN4eUd/BZhCEmVZ9YgL+quE48btjTmtiBv4Hh871SD2w9ipPydqKpa1xXi3J1rE
	 Lt+nVeU4+YfmkhGhKafHVmN1Q5RY39zz/74pDDPs=
From: Leonardo Bras <leo.bras@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH v3 02/11] arm64/cpufeature: Add system-wide FEAT_HACDBS detection
Date: Mon,  3 Aug 2026 14:50:10 +0100
Message-ID: <anCckqI9pXVRAHIF@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729110212.3183A1F000E9@smtp.kernel.org>
References: <20260729104548.3439958-1-leo.bras@arm.com> <20260729104548.3439958-3-leo.bras@arm.com> <20260729110212.3183A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

]On Wed, Jul 29, 2026 at 11:02:11AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Critical] Missing KVM ID register filtering exposes FEAT_HACDBS to guests, preventing VMMs from hiding the feature and breaking VM migration.
> - [Low] The new capability HACDBS is not alphabetically sorted in the cpucaps list.
> --
> 
> --- Patch [2]: [PATCH v3 02/11] arm64/cpufeature: Add system-wide FEAT_HACDBS detection ---
> commit 79552fba5f033b2becee395a64d0ccf3fbde7b1a
> Author: Leonardo Bras <leo.bras@arm.com>
> 
> arm64/cpufeature: Add system-wide FEAT_HACDBS detection
> 
> This commit adds system-wide CPU feature detection for FEAT_HACDBS
> (Hardware dirty bit Cleaning). It updates the cpufeature structures
> and cpucaps list to track the feature across the system.
> 
> > diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> > index aa327eebaf1ca..62f56bbd0a65c 100644
> > --- a/arch/arm64/kernel/cpufeature.c
> > +++ b/arch/arm64/kernel/cpufeature.c
> > @@ -523,6 +523,7 @@ static const struct arm64_ftr_bits ftr_id_aa64mmfr3[] = {
> >  static const struct arm64_ftr_bits ftr_id_aa64mmfr4[] = {
> >  	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR4_EL1_E2H0_SHIFT, 4, 0),
> >  	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR4_EL1_NV_frac_SHIFT, 4, 0),
> > +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR4_EL1_HACDBS_SHIFT, 4, 0),
> 
> [Severity: Critical]
> Does exposing this feature here break VM live migration for KVM?
> 
> By adding HACDBS to the host's sanitised ID register, it is subsequently
> read by KVM to form the guest's ID register limit.
> 
> Looking at arch/arm64/kvm/sys_regs.c:__kvm_read_sanitised_id_reg(), there is
> no case handling SYS_ID_AA64MMFR4_EL1, which means the host's HACDBS value
> unconditionally leaks into the guest's limit.
> 
> Furthermore, looking at sys_reg_descs in arch/arm64/kvm/sys_regs.c:
> 
> 	ID_WRITABLE(ID_AA64MMFR4_EL1, ID_AA64MMFR4_EL1_NV_frac),
> 
> The writable mask for ID_AA64MMFR4_EL1 does not include HACDBS. Because KVM
> strictly enforces that non-writable fields must match the destination host's
> limit, a VMM attempting to restore a saved VM state will fail if the source
> and destination hosts have different HACDBS support.
> 
> Could this be addressed by either masking HACDBS from the guest view or
> making the field writable by the VMM?

IIUC, this means the value is being leaked to guest, which means the guest 
could try to use it to clean an L2 guest's dirty-bits. 

In general usage, it should not happen as this feature is limited to VHE,
and requires the kernel to write to HACDBS*_EL2 registers, which should not 
be directly done by the guest. In any case, I guess it's fair to mask 
that out so guest does not believe it has access to that feature.
 
> 
> >  	ARM64_FTR_END,
> >  };
> 
> [ ... ]
> 
> > diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
> > index a87706c9d160e..bd2c0bb98da61 100644
> > --- a/arch/arm64/tools/cpucaps
> > +++ b/arch/arm64/tools/cpucaps
> > @@ -72,6 +72,7 @@ HAS_XNX
> >  HAS_HDBSS
> >  HAFT
> >  HW_DBM
> > +HACDBS
> 
> [Severity: Low]
> This isn't a bug, but HACDBS is inserted out of alphabetical order here.
> 
> Does this violate the "# Internal CPU capabilities constants, keep this list
> sorted" comment at the top of the arch/arm64/tools/cpucaps file?

Okay, will do.

Thanks!
Leo
