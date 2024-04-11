Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85F151422C4
	for <kvmarm@lists.linux.dev>; Thu, 11 Apr 2024 09:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712826330; cv=none; b=O6NkOecLH1kMbXPqFAeUdEsmJ2MAiXkOSONYHSYLVADF6QBkjPankSlNEDqDnx+CrqpKgW9jARhV664QrelICW4xrJ5+SQ//xEj+zowNquVBxa0jjqf6cfVhuQQRZKkFptdvCi97+05M06qJFLbz9On1WmWOslcG2JzK1ueL4iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712826330; c=relaxed/simple;
	bh=3J8VwlqSTyKVYZlEvnQs+5Q4mGuokIAZh0swPNLVISI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e0n3G7MtwNqqtxi3MnqkUCes9oKXzVXNr2qm1qKGc1EckRbuow4LL6P1rIN5X0ESZrXhq3RTVhApXmD5iInAYFPTawAKL3392RIjjE+4iUWgJh+hx51hR9ztI05wiKtOT1fxjbxOG+4737qqlrPN2N/OYjUXH69jtVeO4YYW3wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D8DC7113E;
	Thu, 11 Apr 2024 02:05:51 -0700 (PDT)
Received: from bogus (e103737-lin.cambridge.arm.com [10.1.197.49])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 01D263F6C4;
	Thu, 11 Apr 2024 02:05:19 -0700 (PDT)
Date: Thu, 11 Apr 2024 10:05:17 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
To: Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc: Sebastian Ene <sebastianene@google.com>, catalin.marinas@arm.com,
	james.morse@arm.com, jean-philippe@linaro.org, maz@kernel.org,
	Sudeep Holla <sudeep.holla@arm.com>, oliver.upton@linux.dev,
	qperret@google.com, qwandor@google.com, suzuki.poulose@arm.com,
	tabba@google.com, will@kernel.org, yuzenghui@huawei.com,
	vdonnefort@google.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Add support for FFA_PARTITION_INFO_GET
Message-ID: <ZhenzfndkNwIehhj@bogus>
References: <20240409151908.541589-1-sebastianene@google.com>
 <Zhaoz9E/sw6jVnci@lpieralisi>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zhaoz9E/sw6jVnci@lpieralisi>

On Wed, Apr 10, 2024 at 04:57:19PM +0200, Lorenzo Pieralisi wrote:
> On Tue, Apr 09, 2024 at 03:19:08PM +0000, Sebastian Ene wrote:
> > Handle the FFA_PARTITION_INFO_GET host call inside the pKVM hypervisor
> > and copy the response message back to the host buffers. Save the
> > returned FF-A version as we will need it later to interpret the response
> > from the TEE.
> >
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 49 +++++++++++++++++++++++++++++++++++
> >  1 file changed, 49 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > index 320f2eaa14a9..72fc365bc7a8 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > @@ -67,6 +67,7 @@ struct kvm_ffa_buffers {
> >   */
> >  static struct kvm_ffa_buffers hyp_buffers;
> >  static struct kvm_ffa_buffers host_buffers;
> > +static u32 ffa_version;
> >
> >  static void ffa_to_smccc_error(struct arm_smccc_res *res, u64 ffa_errno)
> >  {
> > @@ -640,6 +641,49 @@ static bool do_ffa_features(struct arm_smccc_res *res,
> >  	return true;
> >  }
> >
> > +static void do_ffa_part_get(struct arm_smccc_res *res,
> > +			    struct kvm_cpu_context *ctxt)
> > +{
> > +	DECLARE_REG(u32, uuid0, ctxt, 1);
> > +	DECLARE_REG(u32, uuid1, ctxt, 2);
> > +	DECLARE_REG(u32, uuid2, ctxt, 3);
> > +	DECLARE_REG(u32, uuid3, ctxt, 4);
> > +	DECLARE_REG(u32, flags, ctxt, 5);
> > +	u32 off, count, sz, buf_sz;
> > +
> > +	hyp_spin_lock(&host_buffers.lock);
> > +	if (!host_buffers.rx) {
> > +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> > +		goto out_unlock;
> > +	}
> > +
> > +	arm_smccc_1_1_smc(FFA_PARTITION_INFO_GET, uuid0, uuid1,
> > +			  uuid2, uuid3, flags, 0, 0,
> > +			  res);
> > +
> > +	if (res->a0 != FFA_SUCCESS)
> > +		goto out_unlock;
> > +
> > +	count = res->a2;
> > +	if (!count)
> > +		goto out_unlock;
> > +
> > +	if (ffa_version > FFA_VERSION_1_0) {
> > +		buf_sz = sz = res->a3;
> > +		if (sz > sizeof(struct ffa_partition_info))
> > +			buf_sz = sizeof(struct ffa_partition_info);
>
> We are copying buf_sz but (correctly ?) returning res->a3 to the caller,
> which is allowed to expect res->a3 bytes to be filled since that's what
> firmware reported.
>
> Technically this is not a problem at present, because the caller
> (ie the FF-A driver) and the hypervisor rely on the same descriptor
> structures (and buf_sz can't be != sizeof(struct ffa_partition_info),
> anything else is a bug as we stand); they must be kept in sync though as
> the firmware version changes (*if* there are changes in the partition
> descriptor - eg fields are added).
>

Indeed, this will break if the size of the descriptor changes in the future
and the kernel has not yet added the support for that though it is unlikely
as we negotiate the version and the response for all the messages should
be as per the negotiated version.

> An option would consist in just copying res->a3 bytes as firmware reports
> (obviously keeping the RX buffer boundary checks for the memcpy).
>

Yes I prefer that.

> It is just a heads-up because I noticed it, no more, I will let Sudeep
> comment on this since he knows better.
>

I think you had it all covered, nothing much to add.

--
Regards,
Sudeep
