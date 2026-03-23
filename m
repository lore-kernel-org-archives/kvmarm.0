Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483FA36C59E
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 14:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277726; cv=none; b=J+wc7Lt7t4EJ2CzDz2dWv9yLl08qkSU4s+nUTmo9isn+50ubd/R6hNA3eIxTSsg/0a4JImMkHNdtknmZ1jh7HzlPmxsK3SuHY0hG79wi1DlJaQkTCtWnYsF5BK2SumfbAuc0kia18sgGFP0LIV0vQ36kNeW25zqlG/J5wyRqpwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277726; c=relaxed/simple;
	bh=zvxnB3acCyC1+MiM8cMTcK7zo1Dl/uxCRo0/MtOdDdc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o/iFlNJDPAWx5+OdUWMhYFmw5ppyYtYvpC2VPXfTMds0W9+nAIN4d00LhJ96g9sxAMOwoZolqobc4Sv4yOWbHzoBwfgo1WTUmXXH5QueJwzW3iYBGuTnzN14cBKM4dqZq0jsIf3otXsr4bWboWup+Ek5Xvab8a9SGxIc+gehzdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bh1qMlzo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bh1qMlzo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB3AC2BC9E;
	Mon, 23 Mar 2026 14:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774277726;
	bh=zvxnB3acCyC1+MiM8cMTcK7zo1Dl/uxCRo0/MtOdDdc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bh1qMlzoJmJq9BGAis9XPwgrygSchAV0TSmclnBl2dan9xfUjMtxbf+Hwe2DqCFJs
	 7nXwKUaQNQ7PqR1lp/cXRc3Js5ANd4hplBCIgWUhbOu1f+M+lz8mtXd7aJ4ouvwyu7
	 sC8NfwpgwTvkJxaJwFlbZkPCxh4kwVn6WhAE1aOXKxf4HAyyVxhMX0CXUkAyYCcjQq
	 e6B6GxAk14e8HqTqk4dqjOMTaAIuEI20yXu6mehTzP6eHdtXek5fglFQglNoHZAzY6
	 m8vf1a3JFRU6sfRghM9fKgpiGvl/Q7MkM1JrQCzZ7nXlroPW6wp/6fXD/wM52j5j23
	 VSG874U1nEDhA==
Date: Mon, 23 Mar 2026 14:55:20 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v3 11/36] KVM: arm64: Introduce __pkvm_host_donate_guest()
Message-ID: <acFUWC5JULmGQv4B@willie-the-truck>
References: <20260305144351.17071-1-will@kernel.org>
 <20260305144351.17071-12-will@kernel.org>
 <867br665hs.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <867br665hs.wl-maz@kernel.org>

Hi Marc,

Thanks for going through all of this!

On Fri, Mar 20, 2026 at 12:38:07PM +0000, Marc Zyngier wrote:
> On Thu, 05 Mar 2026 14:43:24 +0000,
> Will Deacon <will@kernel.org> wrote:
> > 
> > In preparation for supporting protected VMs, whose memory pages are
> > isolated from the host, introduce a new pKVM hypercall to allow the
> > donation of pages to a guest.
> > 
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/include/asm/kvm_asm.h              |  1 +
> >  arch/arm64/include/asm/kvm_pgtable.h          |  2 +-
> >  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 ++
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 21 +++++++++++++
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 30 +++++++++++++++++++
> >  5 files changed, 55 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > index df6b661701b6..dfc6625c8269 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -79,6 +79,7 @@ enum __kvm_host_smccc_func {
> >  	/* Hypercalls that are available only when pKVM has finalised. */
> >  	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
> >  	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
> > +	__KVM_HOST_SMCCC_FUNC___pkvm_host_donate_guest,
> >  	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_guest,
> >  	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_guest,
> >  	__KVM_HOST_SMCCC_FUNC___pkvm_host_relax_perms_guest,
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index c201168f2857..b6f7595c4979 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -100,7 +100,7 @@ typedef u64 kvm_pte_t;
> >  					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
> >  
> >  #define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
> > -#define KVM_MAX_OWNER_ID		1
> > +#define KVM_MAX_OWNER_ID		3
> >  
> >  /*
> >   * Used to indicate a pte for which a 'break-before-make' sequence is in
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > index 5f9d56754e39..9c0cc53d1dc9 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > @@ -28,6 +28,7 @@ enum pkvm_component_id {
> >  	PKVM_ID_HOST,
> >  	PKVM_ID_HYP,
> >  	PKVM_ID_FFA,
> > +	PKVM_ID_GUEST,
> 
> Is KVM_MAX_OWNER_ID being set to 3 related to PKVM_ID_GUEST being
> introduced?

Yes. At this point, kvm_pgtable_stage2_set_owner() rejects an 'owner_id'
parameter that is '> KVM_MAX_OWNER_ID', so we bump the value so that
PKVM_ID_GUEST isn't rejected outright.

> If so, wouldn't it be better to define one in terms of the other?

I can rework the existing #define if you like, but it actually gets
removed entirely later in the series by "KVM: arm64: Generalise
kvm_pgtable_stage2_set_owner()", so it's less churn just to leave it
in place before nuking it.

> Also, this includes PKVM_ID_FFA as a valid ID, while it wasn't
> included until now. Is that expected?

Huh, so it turns out that this doesn't actually matter, as PKVM_ID_FFA
has been unused since 7cbf7c37718e ("KVM: arm64: Drop pkvm_mem_transition
for host/hyp sharing")! I'll just add a patch to the start of the series
which removes it altogether.

Will
