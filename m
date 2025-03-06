Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5799419F438
	for <kvmarm@lists.linux.dev>; Thu,  6 Mar 2025 09:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741254051; cv=none; b=tn7mLLZvVi3UOS68iM12prWiLuKaTEtNgfHhQn3YQnyByOuymOIow2AfN5QCS/P45esMFw5eHzBebUMQuCjIY5KP0B10Cu44u55DoGRWg/Gv5RkAge/EWsabJJbAICthr+CScFrUA6vxxxxmmQDYV3JBGwgzorGhcaDBiNC5MMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741254051; c=relaxed/simple;
	bh=lHzQ/pK6Ei8uZQYcKUxRemCcZhkOdbNoDAUoz5W3/GI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VqHze4uso23HHcsjt2Hah81dHbIokWh6tNFBhwKjAFJL7xRn29vWEGmbFVbUXlVczRwpSTZO3pNryCI43dQJ3b01YpOOYHMm20Ys9n7El9w+ygQCy6uVrexNx+/NWqDIzSb6VOaXC8aWuHNuU+zg6B9NPiVERMMyiS1F9bUBZNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 44C30FEC;
	Thu,  6 Mar 2025 01:41:02 -0800 (PST)
Received: from bogus (e133711.arm.com [10.1.196.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9CA433F673;
	Thu,  6 Mar 2025 01:40:46 -0800 (PST)
Date: Thu, 6 Mar 2025 09:40:43 +0000
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
Message-ID: <Z8ltm55D1jrv8QtX@bogus>
References: <20250227181750.3606372-1-sebastianene@google.com>
 <20250227181750.3606372-5-sebastianene@google.com>
 <20250305004522.GC31667@willie-the-truck>
 <20250305094104.vctshdtgdukno2aj@bogus>
 <20250305193425.GA32246@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250305193425.GA32246@willie-the-truck>

On Wed, Mar 05, 2025 at 07:34:26PM +0000, Will Deacon wrote:
> On Wed, Mar 05, 2025 at 09:41:04AM +0000, Sudeep Holla wrote:
> > On Wed, Mar 05, 2025 at 12:45:23AM +0000, Will Deacon wrote:
> > > Hmm, the FFA spec is characteristically unclear as to whether or not we
> > > need to release the rx buffer in the case that the flags indicate use of
> > > the rx buffer but the returned partition count is 0.
> > > 
> > > Sudeep -- do you know what we should be doing in that case?
> > > 
> > 
> > We need to call RX_RELEASE here. I went back to the spec to confirm the
> > same again.
> > 
> > v1.2 EAC0 spec Section 7.2.2.4.2 Transfer of buffer ownership
> > (Or just look for the section title in any version of the spec)
> > "
> > 2. Ownership transfer for the RX buffer takes place as follows.
> >     2. For a framework message,
> >        1. Completion of the FFA_PARTITION_INFO_GET ABI transfers the ownership
> >        of the caller’s RX buffer from the Producer to the Consumer.
> > 3. For both types of messages, an invocation of the following FF-A ABIs
> >     transfers the ownership from the Consumer to the Producer.
> >        1. FFA_MSG_WAIT ...
> >        2. FFA_RX_RELEASE.
> > "
> > 
> > Hope that helps, can dig deeper if there are any ambiguities around this.
> 
> Thanks Sudeep, but that also makes it sound like we need the RX_RELEASE
> even if we're not using the RX buffer per the input flags. :/
> 

Good spot, I had forgotten about the input flags that can avoid using the
buffer. I will see if we can improve the spec in that regards.

-- 
Regards,
Sudeep
