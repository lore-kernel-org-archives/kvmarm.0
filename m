Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB662AE8D;
	Tue,  4 Mar 2025 01:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741053401; cv=none; b=qhdFn0s0OeaWBFTWhdx/i8KDgpDTlkG9h6IeYczZ8rk7QYxpldulhtGWJXskne7Rnij/tIiwv6e3llzGcCUzjkmQZ7UPv61/9hldSLqC11MhX13zzjQuWydS1FzEa5z1lCm6+HLQgPcIl8yPWGM8Yc1Lr/UJTgftjzGO31ZnEf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741053401; c=relaxed/simple;
	bh=FUVChTxusLCMBLUVlti1YUL8LW7/tvUKTXZZlRvP6rI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kUjfbIvpoCRn2rFVI7+ceLshRAZLFCJ7mdQdieeHY9lK8Pvug6WDP88sufTJKuObJum7Tt5ZRquHpjOLVpL9+0LAxYQLW00b5g4S006AocNqTPICGnCv/iJETGHDRIAYK1Q+S8V60zk6hA0QSQzCH8ch6g4ayb9pwyg2PMINRdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uNJEIl1/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uNJEIl1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA13C4CEE4;
	Tue,  4 Mar 2025 01:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741053401;
	bh=FUVChTxusLCMBLUVlti1YUL8LW7/tvUKTXZZlRvP6rI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uNJEIl1/t95dU9GT2B34a8VuVRjvsPNcprE9PkVvHlHbKTTyXm5zK9o6p0m85fEgW
	 n7mEtMyT6uP5e/QBv6B+2lzevvUwBWjfSVcsFiyFxnT8nFqpT7nLEAv0Ns65jzlGws
	 MyPyha38P/a4MDUGjLtM2ckh809jCe1Ens/9DTIIWwEqCI4V5SfZGemgEFbijV7qpW
	 XvgiN7sn7H4LYbGeKfqhdTbBOhLL3xXGl4QZ9IyNYVhnEakHqrBDE95LS6Ni29DYLi
	 5xrOtEesB3mJ58Rjjalw24MyHMsXPGSdVGqne40sgY4qaEDOEgvBx4c6X5XGClGeAR
	 +hvX72HSm51pw==
Date: Tue, 4 Mar 2025 01:56:35 +0000
From: Will Deacon <will@kernel.org>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org,
	oliver.upton@linux.dev, snehalreddy@google.com,
	sudeep.holla@arm.com, suzuki.poulose@arm.com, vdonnefort@google.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH v2 3/4] KVM: arm64: Map the hypervisor FF-A buffers on
 ffa init
Message-ID: <20250304015633.GA30882@willie-the-truck>
References: <20250227181750.3606372-1-sebastianene@google.com>
 <20250227181750.3606372-4-sebastianene@google.com>
 <20250303234259.GA30749@willie-the-truck>
 <Z8ZPBZF7J-qKdb_i@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8ZPBZF7J-qKdb_i@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Mar 04, 2025 at 12:53:25AM +0000, Sebastian Ene wrote:
> On Mon, Mar 03, 2025 at 11:43:03PM +0000, Will Deacon wrote:
> > On Thu, Feb 27, 2025 at 06:17:48PM +0000, Sebastian Ene wrote:
> > > Map the hypervisor's buffers irrespective to the host and return
> > > a linux error code from the FF-A error code on failure. Remove
> > > the unmap ff-a buffers calls from the hypervisor as it will
> > > never be called.
> > > Prevent the host from using FF-A directly with Trustzone
> > > if the hypervisor could not map its own buffers.
> > > 
> > > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > > ---
> > >  arch/arm64/kvm/hyp/nvhe/ffa.c | 46 +++++++++++++----------------------
> > >  1 file changed, 17 insertions(+), 29 deletions(-)
> > 
> > [...]
> > 
> > > @@ -861,6 +842,7 @@ int hyp_ffa_init(void *pages)
> > >  {
> > >  	struct arm_smccc_res res;
> > >  	void *tx, *rx;
> > > +	int ret;
> > >  
> > >  	if (kvm_host_psci_config.smccc_version < ARM_SMCCC_VERSION_1_2)
> > >  		return 0;
> > > @@ -911,5 +893,11 @@ int hyp_ffa_init(void *pages)
> > >  		.lock	= __HYP_SPIN_LOCK_UNLOCKED,
> > >  	};
> > >  
> > > +	/* Map our hypervisor buffers into the SPMD */
> > > +	ret = ffa_map_hyp_buffers();
> > > +	if (ret)
> > > +		return ret;
> > 
> > Doesn't calling RXTX_MAP here undo the fix from c9c012625e12 ("KVM:
> > arm64: Trap FFA_VERSION host call in pKVM") where we want to allow for
> > the host to negotiate the version lazily?
> 
> We still have the same behaviour where we don't allow memory
> sharing to happen until the version is negotiated but this
> separates the hypervisor buffer mapping part from the host.

Sadly, the spec doesn't restrict this to the memory sharing calls:

  | [...] negotiation of the version must happen before an invocation of
  | any other FF-A ABI

We're also probing the minimum rxtx size in hyp_ffa_post_init() so doing
this here is doubly wrong.

So I think we should probably just drop this patch.

Will
