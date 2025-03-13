Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA172676E0;
	Thu, 13 Mar 2025 12:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741868166; cv=none; b=C6BecevUwwyT756xVfSJG9U1Bdh4G4tR6qEtzjRJc7IdD3W+fk31CBMhNnWJJe50o8Kh6mJVNKGtbrkIDcoh7fDH9Ej2Byhn8CkHFUZyxub02zQ2/8P96jS+sCRgHWZHCy+vX1rLRFmciaRgjuAEpqTc+5glzTRMt9iZYpF+f7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741868166; c=relaxed/simple;
	bh=ZWHDQFZydgFLF+pZhM5zaTgB/SRGh95yQ/J43duDfo4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AXoEr+5Q6tn5F2KwLPCIu75cSCkOK/TSixJdSyNnTeIWlDaVWsn51HKFbcNXOf8DnHJX4lImBobwHAKAmP0NvBSWHKG+vcVAH4nFSWOONzXw491UMYfhgelgG5Skjyy97XOhxZ3PIz+H4FHnYiI+qBQZqIgmAr2URM+eHGxijSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mvpnul61; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mvpnul61"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DBAEC4CEEB;
	Thu, 13 Mar 2025 12:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741868166;
	bh=ZWHDQFZydgFLF+pZhM5zaTgB/SRGh95yQ/J43duDfo4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mvpnul617r3+1dJblDjuGGF3ygGimnd4POqbjFo4+O44NuhkG8MrwnO4J7SN96WfS
	 Eg2ju52wMFzIKWlWGxAafV0lhzgdgNg3/4R12d/n1OI8YH+hBSdjITulP9baWQf1g7
	 4ZNcfDFOO0YoabVlIfJpBV+8WdB92DhaHXXo3V8zGi0tZ2915gd6CIV0IYwkxMB3ZD
	 9XjHE9QsRB9AD+dEhS4KMrTYEYUC67YyOfo5ocyJ/0nUmdq0UYBhih2r1skkSY6IOK
	 k6HV4X3z21S4/yKifPdRROwdqOsixPHowbEuoo66WoObj7bk9GHrVEsvCz/CcMVB9i
	 1ECWlKglNYubQ==
Date: Thu, 13 Mar 2025 12:15:59 +0000
From: Will Deacon <will@kernel.org>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: Sebastian Ene <sebastianene@google.com>, catalin.marinas@arm.com,
	joey.gouly@arm.com, maz@kernel.org, oliver.upton@linux.dev,
	snehalreddy@google.com, suzuki.poulose@arm.com,
	vdonnefort@google.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com, Andrei Homescu <ahomescu@google.com>
Subject: Re: [PATCH v2 4/4] KVM: arm64: Release the ownership of the hyp rx
 buffer to Trustzone
Message-ID: <20250313121559.GB7356@willie-the-truck>
References: <20250227181750.3606372-1-sebastianene@google.com>
 <20250227181750.3606372-5-sebastianene@google.com>
 <20250305004522.GC31667@willie-the-truck>
 <20250305094104.vctshdtgdukno2aj@bogus>
 <20250305193425.GA32246@willie-the-truck>
 <Z8ltm55D1jrv8QtX@bogus>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z8ltm55D1jrv8QtX@bogus>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Mar 06, 2025 at 09:40:43AM +0000, Sudeep Holla wrote:
> On Wed, Mar 05, 2025 at 07:34:26PM +0000, Will Deacon wrote:
> > On Wed, Mar 05, 2025 at 09:41:04AM +0000, Sudeep Holla wrote:
> > > On Wed, Mar 05, 2025 at 12:45:23AM +0000, Will Deacon wrote:
> > > > Hmm, the FFA spec is characteristically unclear as to whether or not we
> > > > need to release the rx buffer in the case that the flags indicate use of
> > > > the rx buffer but the returned partition count is 0.
> > > > 
> > > > Sudeep -- do you know what we should be doing in that case?
> > > > 
> > > 
> > > We need to call RX_RELEASE here. I went back to the spec to confirm the
> > > same again.
> > > 
> > > v1.2 EAC0 spec Section 7.2.2.4.2 Transfer of buffer ownership
> > > (Or just look for the section title in any version of the spec)
> > > "
> > > 2. Ownership transfer for the RX buffer takes place as follows.
> > >     2. For a framework message,
> > >        1. Completion of the FFA_PARTITION_INFO_GET ABI transfers the ownership
> > >        of the caller’s RX buffer from the Producer to the Consumer.
> > > 3. For both types of messages, an invocation of the following FF-A ABIs
> > >     transfers the ownership from the Consumer to the Producer.
> > >        1. FFA_MSG_WAIT ...
> > >        2. FFA_RX_RELEASE.
> > > "
> > > 
> > > Hope that helps, can dig deeper if there are any ambiguities around this.
> > 
> > Thanks Sudeep, but that also makes it sound like we need the RX_RELEASE
> > even if we're not using the RX buffer per the input flags. :/
> > 
> 
> Good spot, I had forgotten about the input flags that can avoid using the
> buffer. I will see if we can improve the spec in that regards.

Thanks. In the meantime, what do you think is the correct behaviour in that
case? I guess _not_ doing the release when the flags don't request the RX
buffer? In other words:


	if (flags & PARTITION_INFO_GET_RETURN_COUNT_ONLY)
		goto out_unlock;

	if (!count)
		goto release_rx;

	[...]

	if (copy_sz > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
		ffa_to_smccc_res(res, FFA_RET_ABORTED);
		goto release_rx;
	}

	memcpy(host_buffers.rx, hyp_buffers.rx, copy_sz);
release_rx:
	ffa_rx_release(&_res);
out_unlock:
	hyp_spin_unlock(&host_buffers.lock);
}


What do you reckon?

Will
