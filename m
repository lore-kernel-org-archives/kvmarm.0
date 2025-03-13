Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27BE311CA9
	for <kvmarm@lists.linux.dev>; Thu, 13 Mar 2025 14:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741874429; cv=none; b=kHge1JO19tHS/gM/9edkrZe838eJm+ccfcv+pnWuf0hSTqPXNJ3imSfFRbkZbx8dxLjXOC+bO+16EzvAUi9HZDNx0XrrxCzIRk38Zqtzzzvn/3VyErtj5Edt7v5MhgvCjJoOUG9UrlE/xmxCKPMQ01oWWDHNFW8fB4PX3PamqL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741874429; c=relaxed/simple;
	bh=eretv0LIR39IzkiHxmfUE3MrQAkp3aA1zPmW1cyB2oE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KMUQ5qS6ti2GQwOavJyovLANKCIKakOSxE7/40qa08q386+nuVZLaElUYBZ1XfYPMHF6r9ssI9d7GTJ0CMXehY3IVECydPu36i0rdac/hqHCVkZFXL915KzQ/vVubX73mOYhZP3kjfWJqeXz1LMr2xxN5USSZf4e/Q3jHULkxqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com; spf=none smtp.mailfrom=foss.arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=foss.arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C62F91424;
	Thu, 13 Mar 2025 07:00:37 -0700 (PDT)
Received: from bogus (e133711.arm.com [10.1.196.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CD2283F694;
	Thu, 13 Mar 2025 07:00:24 -0700 (PDT)
Date: Thu, 13 Mar 2025 14:00:21 +0000
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
Message-ID: <Z9Lk9QwAGhYxk8lC@bogus>
References: <20250227181750.3606372-1-sebastianene@google.com>
 <20250227181750.3606372-5-sebastianene@google.com>
 <20250305004522.GC31667@willie-the-truck>
 <20250305094104.vctshdtgdukno2aj@bogus>
 <20250305193425.GA32246@willie-the-truck>
 <Z8ltm55D1jrv8QtX@bogus>
 <20250313121559.GB7356@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250313121559.GB7356@willie-the-truck>

On Thu, Mar 13, 2025 at 12:15:59PM +0000, Will Deacon wrote:
> On Thu, Mar 06, 2025 at 09:40:43AM +0000, Sudeep Holla wrote:
> > On Wed, Mar 05, 2025 at 07:34:26PM +0000, Will Deacon wrote:
> > > On Wed, Mar 05, 2025 at 09:41:04AM +0000, Sudeep Holla wrote:
> > > > On Wed, Mar 05, 2025 at 12:45:23AM +0000, Will Deacon wrote:
> > > > > Hmm, the FFA spec is characteristically unclear as to whether or not we
> > > > > need to release the rx buffer in the case that the flags indicate use of
> > > > > the rx buffer but the returned partition count is 0.
> > > > >
> > > > > Sudeep -- do you know what we should be doing in that case?
> > > > >
> > > >
> > > > We need to call RX_RELEASE here. I went back to the spec to confirm the
> > > > same again.
> > > >
> > > > v1.2 EAC0 spec Section 7.2.2.4.2 Transfer of buffer ownership
> > > > (Or just look for the section title in any version of the spec)
> > > > "
> > > > 2. Ownership transfer for the RX buffer takes place as follows.
> > > >     2. For a framework message,
> > > >        1. Completion of the FFA_PARTITION_INFO_GET ABI transfers the ownership
> > > >        of the caller’s RX buffer from the Producer to the Consumer.
> > > > 3. For both types of messages, an invocation of the following FF-A ABIs
> > > >     transfers the ownership from the Consumer to the Producer.
> > > >        1. FFA_MSG_WAIT ...
> > > >        2. FFA_RX_RELEASE.
> > > > "
> > > >
> > > > Hope that helps, can dig deeper if there are any ambiguities around this.
> > >
> > > Thanks Sudeep, but that also makes it sound like we need the RX_RELEASE
> > > even if we're not using the RX buffer per the input flags. :/
> > >
> >
> > Good spot, I had forgotten about the input flags that can avoid using the
> > buffer. I will see if we can improve the spec in that regards.
>
> Thanks. In the meantime, what do you think is the correct behaviour in that
> case? I guess _not_ doing the release when the flags don't request the RX
> buffer? In other words:
>
>
> 	if (flags & PARTITION_INFO_GET_RETURN_COUNT_ONLY)
> 		goto out_unlock;
>
> 	if (!count)
> 		goto release_rx;
>
> 	[...]
>
> 	if (copy_sz > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
> 		ffa_to_smccc_res(res, FFA_RET_ABORTED);
> 		goto release_rx;
> 	}
>
> 	memcpy(host_buffers.rx, hyp_buffers.rx, copy_sz);
> release_rx:
> 	ffa_rx_release(&_res);
> out_unlock:
> 	hyp_spin_unlock(&host_buffers.lock);
> }
>
>
> What do you reckon?

Yes matches my understanding. I also cross checked with FF-A spec authors
to be sure. Now I got to fix that in the driver, currently it releases
buffer unconditionally which is wrong 🙁.

-- 
Regards,
Sudeep
