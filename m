Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16B5F202964
	for <kvmarm@lists.linux.dev>; Wed,  5 Mar 2025 09:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741167674; cv=none; b=HQ+PEwBVaIhnrYiN3WwraV1B+vrj347IXyvNyDXmo1zC4MxLlOwD3dCpC4GkKE4p8yjZRsb/Nyf7fRPPX4c2PLe6Kns+JuzKUy8SntHxOUa0e6KLMBsqztAZ26UI8RF+FG9n+I3FdH8zua89EiFxz3BtkIrK/qamoKxohzxDooM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741167674; c=relaxed/simple;
	bh=Vw+5e0EpzqsLzssyNulWsQ7b6CkuCULIKONC3H5iOgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jnhuBnLG10e9eSCgMAumbnfrnMXxLfwAF30W1hUmu9PpMxsBnPTB625NAWPX98HvUbXS9IkWXVqz/rUcxwgJr+UN1LBYgfHTQiC5z+IGQ7ey0Zna7/EJ9AMfV79JMaeD6w/b+nDE6Kk0ZYmKlFTO9DNtfv15lZxirZc81/XAuwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA06FFEC;
	Wed,  5 Mar 2025 01:41:24 -0800 (PST)
Received: from bogus (unknown [10.57.37.20])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 186323F66E;
	Wed,  5 Mar 2025 01:41:07 -0800 (PST)
Date: Wed, 5 Mar 2025 09:41:04 +0000
From: Sudeep Holla <sudeep.holla@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Sebastian Ene <sebastianene@google.com>, catalin.marinas@arm.com,
	Sudeep Holla <sudeep.holla@arm.com>, joey.gouly@arm.com,
	maz@kernel.org, oliver.upton@linux.dev, snehalreddy@google.com,
	suzuki.poulose@arm.com, vdonnefort@google.com, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com,
	Andrei Homescu <ahomescu@google.com>
Subject: Re: [PATCH v2 4/4] KVM: arm64: Release the ownership of the hyp rx
 buffer to Trustzone
Message-ID: <20250305094104.vctshdtgdukno2aj@bogus>
References: <20250227181750.3606372-1-sebastianene@google.com>
 <20250227181750.3606372-5-sebastianene@google.com>
 <20250305004522.GC31667@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250305004522.GC31667@willie-the-truck>

On Wed, Mar 05, 2025 at 12:45:23AM +0000, Will Deacon wrote:
> On Thu, Feb 27, 2025 at 06:17:49PM +0000, Sebastian Ene wrote:
> > Introduce the release FF-A call to notify Trustzone that the hypervisor
> > has finished copying the data from the buffer shared with Trustzone to
> > the non-secure partition.
> > 
> > Reported-by: Andrei Homescu <ahomescu@google.com>
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > index 861f24de97cb..7da0203f1ee9 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > @@ -725,6 +725,7 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
> >  	DECLARE_REG(u32, uuid3, ctxt, 4);
> >  	DECLARE_REG(u32, flags, ctxt, 5);
> >  	u32 count, partition_sz, copy_sz;
> > +	struct arm_smccc_res _res;
> >  
> >  	hyp_spin_lock(&host_buffers.lock);
> >  	if (!host_buffers.rx) {
> > @@ -741,7 +742,7 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
> >  
> >  	count = res->a2;
> >  	if (!count)
> > -		goto out_unlock;
> > +		goto release_rx;
> >  
> >  	if (hyp_ffa_version > FFA_VERSION_1_0) {
> >  		/* Get the number of partitions deployed in the system */
> > @@ -757,10 +758,12 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
> >  	copy_sz = partition_sz * count;
> >  	if (copy_sz > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
> >  		ffa_to_smccc_res(res, FFA_RET_ABORTED);
> > -		goto out_unlock;
> > +		goto release_rx;
> >  	}
> >  
> >  	memcpy(host_buffers.rx, hyp_buffers.rx, copy_sz);
> > +release_rx:
> > +	ffa_rx_release(&_res);
> 
> Hmm, the FFA spec is characteristically unclear as to whether or not we
> need to release the rx buffer in the case that the flags indicate use of
> the rx buffer but the returned partition count is 0.
> 
> Sudeep -- do you know what we should be doing in that case?
> 

We need to call RX_RELEASE here. I went back to the spec to confirm the
same again.

v1.2 EAC0 spec Section 7.2.2.4.2 Transfer of buffer ownership
(Or just look for the section title in any version of the spec)
"
2. Ownership transfer for the RX buffer takes place as follows.
    2. For a framework message,
       1. Completion of the FFA_PARTITION_INFO_GET ABI transfers the ownership
       of the caller’s RX buffer from the Producer to the Consumer.
3. For both types of messages, an invocation of the following FF-A ABIs
    transfers the ownership from the Consumer to the Producer.
       1. FFA_MSG_WAIT ...
       2. FFA_RX_RELEASE.
"

Hope that helps, can dig deeper if there are any ambiguities around this.

-- 
Regards,
Sudeep
