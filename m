Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CC34C10CE
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 21:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790027161; cv=none; b=QUvAONC//Q7zJOaUkYED2xVn9ORfWPa3p/xb+Nje9svqf33F5VnVMtEyEN8P3Dn2kR8CxKejcvvDoleeOUjdYoyNIfQJ0Cf0dnrudi7sJYAOV3/rxv1Jq+8P2xu7+6w/OmRtn6mjwzTbPrMoaEyCpHRKEaKC/qdhqkjfU/9p8yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790027161; c=relaxed/simple;
	bh=rKQiGdZigwUgqZXAwI2hfXHdA6L9lNOw6Xs9KwAxQyk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZzmssRVYOIe3YoEBFAEUD0ryegPdz5DGE6MmByRVmqzsIng2n+gIG8M9lRu7iopQUlWnRwMKZTC+TU+iV2A6vrfZTczRCytjy54Ay3TOZWpbNgnLvjSASnl80zfRiqCJJ9X6n4ioWGry5LrKfSlb70f6sjYVyYYqgDKTm35tpRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TPawom64; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TPawom64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E90751F000FF;
	Mon, 21 Sep 2026 21:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790027160;
	bh=YYYm0m0eBnfXI3MnZVbQsmtD1hRFQXeRkRiGgJi/pLw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TPawom64qwnuRhXBOh+b1TEsVwBWdiAOqyMtY0DISgLjhgXU5bQEC2BwJ9w/FMP0w
	 NQR3y6aUAzqHtbgu91ovYlIg7ALPty86Wuum65m3fHGyO0kWZ7inW2vR5Fm7n7HD5p
	 SWnPTMvtp/rYAL/mxyazudvaxCvOOQqQsm1lcv3XUhicOL5Hlkzp7sHBaq4W3pbQDV
	 nVR8enUcAa7BIldsgxx0HBmHam0icIEY3TTx/1+10intmF1Rdl4Iq31Eda7UQfAj6E
	 bjQ7urBjdgIrQ/DK3ynTKuLF58grGR9pJtprz7nffvmhMgc0y6bnF95VPYuJ/quMFE
	 RRZuolEPU4zgw==
Date: Mon, 21 Sep 2026 14:45:58 -0700
From: Oliver Upton <oupton@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 05/22] KVM: arm64: nv: Pass an access descriptor for
 stage-2 walks
Message-ID: <arGllj6E0C33cc20@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-6-oupton@kernel.org>
 <arFpUtyq7sphiJzw@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arFpUtyq7sphiJzw@LeoBrasDK>

On Mon, Sep 21, 2026 at 06:28:50PM +0100, Leonardo Bras wrote:
> > @@ -1642,9 +1655,11 @@ int __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
> >  		return 0;
> >  
> >  	/* Do the stage-2 translation */
> > -	ipa = (par & GENMASK_ULL(47, 12)) | (vaddr & GENMASK_ULL(11, 0));
> > +	access.type = WALK_ACCESS_AT;
> > +	access.ia = (par & GENMASK_ULL(47, 12)) | (vaddr & GENMASK_ULL(11, 0));
> 
> What does this mask represent?

Keep in mind, this is pre-existing code... This mask is taking the GFN
from the output address of stage-1 translation and using it as the input
for stage-2.

Keep in mind nested only supports up to 48 bits of PA space.

> 
> IIUC, in general terms most of the changes are adapting the typing on 
> kvm_walk_nested_s2() & co to make use of the new struct kvm_walk_access 
> instead of just a PA.
> 
> I also see that flags & write are also added here, but not used anywhere.
> Maybe it would  be worth moving them to the patch that makes use of them, 
> instead leaving them here?

I can do that

Thanks,
Oliver
