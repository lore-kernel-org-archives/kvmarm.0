Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B69211C
	for <kvmarm@lists.linux.dev>; Fri,  4 Oct 2024 05:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728018092; cv=none; b=Od0JXpf/j8D3zP4QMRisx9mptE2pIs6vFfulV4pMoLjh+8JcYqQnjm9Mb5ZVyWlaWxc3m+2EfmedbnK5kyAEeUydJxQObwDFTUwXCS9vs5FGZxxyARgFX04PqmAFBhyEIfbcCmYUoUef2+Y6t5kErlAlkpkyQMeyNxr4bJjW0ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728018092; c=relaxed/simple;
	bh=n+hq+ke8KIBDS78Wt9NIB7KmLpdUY9ZL/UEBkJnixbU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hlpsb0lnDf96phxlh+tu2OmDodXq2CHieCid3ow0pqyUJKS3aJN4dMFbZ2rVOsKze6J/phEbhQY/GnI694TjNXat82ao4zD44EmDNNI1J0xvRoJ5N68tN17c7vvpEKzGcifNJKm8ixztTcdo+jBhAJsBXNvuLx5ByrGaRy1tsKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=drUKYhiU; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="drUKYhiU"
Date: Thu, 3 Oct 2024 22:01:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728018087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AbVygyhcJER/ikyVDJU/xvRALSb1JCr8R5Un1y4HJmM=;
	b=drUKYhiUO0iMloMMld3oZWw9NerZxmcRjYAbDR8dbiSXzYTLATw/ksPKMV4v3CQkudNnXS
	7dwu7pQXP5n5UU9bO46cGGjoLhEBxv+jlKTxtkeevgBmW3xJjH5Ocx6jrc5uE6+J2CVRFP
	hZ9/ZYIPHd40c4N1lrYPzLTHj8iJf0Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 47/47] KVM: arm64: nv: Add trap forwarding for FEAT_FGT2
 described registers
Message-ID: <Zv92nsoLxbfI45Ji@linux.dev>
References: <20241001024356.1096072-1-anshuman.khandual@arm.com>
 <20241001024356.1096072-48-anshuman.khandual@arm.com>
 <ZvwLRWOKpggCvmH4@linux.dev>
 <cae8c6ca-d999-4b93-a82d-7a1f9924fcee@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cae8c6ca-d999-4b93-a82d-7a1f9924fcee@arm.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 03, 2024 at 09:46:08AM +0530, Anshuman Khandual wrote:
> > I have a patch in the nested PMU series that uses a single complex trap
> > ID to evaluate HPMN, and derives the index from ESR_EL2. I think it
> > could also be extended to the PMEVCNTSVR<n> range as well.
> 
> Just for reference - the mentioned complex trap ID function from the
> given link below.
> 
> static enum trap_behaviour check_mdcr_hpmn(struct kvm_vcpu *vcpu)
> {
> 	u32 sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
> 	u64 mask = kvm_pmu_accessible_counter_mask(vcpu);
> 	unsigned int idx;
> 
> 
> 	switch (sysreg) {
> 	case SYS_PMEVTYPERn_EL0(0) ... SYS_PMEVTYPERn_EL0(30):
> 	case SYS_PMEVCNTRn_EL0(0) ... SYS_PMEVCNTRn_EL0(30):
> 
> ---------------------------------------------------------------------
> Just add the new system register range here ?
> 
> +	case SYS_PMEVCNTSVR_EL1(0)... SYS_PMEVCNTSVR_EL1(31):
> ---------------------------------------------------------------------
> 
> 		idx = (sys_reg_CRm(sysreg) & 0x3) << 3 | sys_reg_Op2(sysreg);
> 		break;

Yes, so long as the layout of encodings matches the established pattern
for value / type registers (I haven't checked this).

> > 
> > Also, keep in mind that the HPMN trap is annoying since it affects Host
> > EL0 in addition to 'guest' ELs.
> 
> Does this require any more special handling other than the above complex trap
> ID function ?

There's another patch in that series I linked that allows EL2 traps to
describe behavior that takes effect in host EL0.

So I don't believe there's anything in particular related to HPMN that
you need to evaluate. I wanted to mention it because some of the PMU
related traps besides HPMN take effect in Host EL0, so do keep it in
mind.

With that said, I haven't seen an FGT yet that applies to Host EL0.

-- 
Thanks,
Oliver
