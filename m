Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01A4A20CCF4
	for <kvmarm@lists.linux.dev>; Thu, 27 Mar 2025 09:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743068935; cv=none; b=aBmI52c2ZITAgcbRv5X39HYHEvadOHwtyjgZj85VZbiZ5PnN3pxi1z5UdWEyFvu3+42i23QnvPqjDCB+FBcQNw6EzBGTJekdn+NsnXwMfi02PNELjctkyadOSLuEQ8Hu34yBrNIygv4BuvDyTzk2xecefbF3O0l1FeS0NJ6Z0eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743068935; c=relaxed/simple;
	bh=uSZ3ssY/xlzW1nr2WrEshK+RgrR9LQhRC0rad3D6Jzk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UcY7ZlKX/W/CC+w+sgTKsFyV8awd4zaoPaRMqb9LbUc+p6n29NP/NayoT3E5/5lHiOAA3+1ZVHVJd+EbeGBDMIHmstFE4YRwGfjJddhIK7LVCgHl/0GD+AGGApiy+WVRnloIXGrDp3VDoHOKoFT/IXY+zMCkyUBaEXCo2/t1uqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com; spf=none smtp.mailfrom=foss.arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=foss.arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 65F99106F;
	Thu, 27 Mar 2025 02:48:58 -0700 (PDT)
Received: from bogus (e133711.arm.com [10.1.196.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5DE9A3F63F;
	Thu, 27 Mar 2025 02:48:50 -0700 (PDT)
Date: Thu, 27 Mar 2025 09:48:47 +0000
From: Sudeep Holla <sudeep.holla@arm.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: Quentin Perret <qperret@google.com>, catalin.marinas@arm.com,
	Sudeep Holla <sudeep.holla@arm.com>, joey.gouly@arm.com,
	maz@kernel.org, oliver.upton@linux.dev, snehalreddy@google.com,
	suzuki.poulose@arm.com, vdonnefort@google.com, will@kernel.org,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com, Andrei Homescu <ahomescu@google.com>
Subject: Re: [PATCH v4 3/3] KVM: arm64: Release the ownership of the hyp rx
 buffer to Trustzone
Message-ID: <20250327-greedy-hopeful-rook-56c6a1@sudeepholla>
References: <20250326113901.3308804-1-sebastianene@google.com>
 <20250326113901.3308804-4-sebastianene@google.com>
 <Z-Qv4b0vgVql2yOb@google.com>
 <Z-UcW32Hk6f_cuxc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-UcW32Hk6f_cuxc@google.com>

On Thu, Mar 27, 2025 at 09:37:31AM +0000, Sebastian Ene wrote:
> On Wed, Mar 26, 2025 at 04:48:33PM +0000, Quentin Perret wrote:
> > On Wednesday 26 Mar 2025 at 11:39:01 (+0000), Sebastian Ene wrote:
> > > Introduce the release FF-A call to notify Trustzone that the hypervisor
> > > has finished copying the data from the buffer shared with Trustzone to
> > > the non-secure partition.
> > >
> > > Reported-by: Andrei Homescu <ahomescu@google.com>
> > > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > > ---
> > >  arch/arm64/kvm/hyp/nvhe/ffa.c | 9 ++++++---
> > >  1 file changed, 6 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > index 6df6131f1107..ac898ea6274a 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > @@ -749,6 +749,7 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
> > >  	DECLARE_REG(u32, uuid3, ctxt, 4);
> > >  	DECLARE_REG(u32, flags, ctxt, 5);
> > >  	u32 count, partition_sz, copy_sz;
> > > +	struct arm_smccc_res _res;
> > >  
> > >  	hyp_spin_lock(&host_buffers.lock);
> > >  	if (!host_buffers.rx) {
> > > @@ -765,11 +766,11 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
> > >  
> > >  	count = res->a2;
> > >  	if (!count)
> > > -		goto out_unlock;
> > > +		goto release_rx;
> > >  
> > >  	if (hyp_ffa_version > FFA_VERSION_1_0) {
> > >  		/* Get the number of partitions deployed in the system */
> > > -		if (flags & 0x1)
> > > +		if (flags & PARTITION_INFO_GET_RETURN_COUNT_ONLY)
> > >  			goto out_unlock;
> > >  
> > >  		partition_sz  = res->a3;
> > > @@ -781,10 +782,12 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
> > >  	copy_sz = partition_sz * count;
> > >  	if (copy_sz > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
> > >  		ffa_to_smccc_res(res, FFA_RET_ABORTED);
> > > -		goto out_unlock;
> > > +		goto release_rx;
> > >  	}
> > >  
> > >  	memcpy(host_buffers.rx, hyp_buffers.rx, copy_sz);
> > > +release_rx:
> > > +	ffa_rx_release(&_res);
> 
> Hi,
> 
> > 
> > I'm a bit confused about this release call here. In the pKVM FF-A proxy
> > model, the hypervisor is essentially 'transparent', so do we not expect
> > EL1 to issue that instead?
> 
> I think the EL1 should also issue this call irrespective of what the
> hypervisor is doing. Sudeep can correct me here if I am wrong, but this
> is my take on this.
>

Indeed, the driver will not know if it is running in EL1 with or without
FF-A proxy or even at EL2.

> I am looking at this as a way of signaling the availability of the rx
> buffer across partitions. There are some calls that when invoked, they
> place the buffer in a 'locked state'.
> 
> 
> > How is EL1 supposed to know that the
> > hypervisor has already sent the release call?
> 
> It doesn't need to know, it issues the call as there is no hypervisor
> in-between, why would it need to know ?
> 

Exactly.

> > And isn't EL1 going to be
> > confused if the content of the buffer is overridden before is has issued
> > the release call itself?
> 

Yes good point. I need to recall the details, but I am assuming FF-A proxy
in pKVM maps the Tx/Rx buffers with the host in EL2 and maintains another
Tx/Rx pair with SPMC on the secure side right ?

> The hypervisor should prevent changes to the buffer mapped between the
> host and itself until the release_rx call is issued from the host.

OK, this sounds like my understand above is indeed correct ?

> If another call that wants to make use of the rx buffer sneaks in, we
> would have to revoke it with BUSY until rx_release is sent.
>

Sounds good to me.

-- 
Regards,
Sudeep
