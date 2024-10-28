Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB33415E5B8
	for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 15:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730128084; cv=none; b=U0Ml+hFiqzxzjzDNNwS1DKSC/2jgLyjaAcxMsKoQ0IC0oVOE0H1Kv0tgvMm5ASs4zH357385anpPVvm1naGS4ICB/JxI00u3k9stfCZ9rIkTp80lHdxmBo1/Q7IS+8ZfMnRrq9DmweQDAOsZz4+0OWAb6WPqbfJbzbE8hG0nW6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730128084; c=relaxed/simple;
	bh=bTkOOclMFzY6PGJSiqRt7P0MiUzbfdzYbsNpNdCHGKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YqlumBI0qeKrUlFA0Z3iRvpyQD5/eZTvPkotHMuhhbzNURun/0RWDWG0tHgAXORgbdgZZRoHZ0j8Onf245YNvQ3BmonRhk9MrjhGoVi52Fq3CWxtIPVtqJkhtNYvqw5w89uI6nZxOxFT7TQCNzaHxfa//P62JYijuR22vGS8WWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=klecebep; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="klecebep"
Date: Mon, 28 Oct 2024 15:07:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730128079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G9p4eTT42fRRi/aG3dYCIILkL00If6Y9C4jHec4Ibr8=;
	b=klecebeplNRZUQqOUCeOw34Qixgb8QzGW9DuqiouxKrHB5W5WWItPRZJ6eKtfTMlUDe4iK
	P8yqkinF5WEWL1Gu34xZIJewEXbVjnWdOU1q18KnQrsf6uigR/0x9ei5xi1pSNykkLLWbC
	dTiCxPfF+le0YHnc3FQM5rMIp+MZwSs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 4/4] arm64: mte: Use stage-2 NoTagAccess memory attribute
 if supported
Message-ID: <Zx-oyZWF12M_ka-m@linux.dev>
References: <20241028094014.2596619-1-aneesh.kumar@kernel.org>
 <20241028094014.2596619-5-aneesh.kumar@kernel.org>
 <Zx-jWyF7xvFS-Vs6@linux.dev>
 <yq5amsiocmb1.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5amsiocmb1.fsf@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Oct 28, 2024 at 08:22:02PM +0530, Aneesh Kumar K.V wrote:
> 
> Hi Oliver,
> 
> 
> Thanks for reviewing the changes.
> 
> Oliver Upton <oliver.upton@linux.dev> writes:
> 
> > On Mon, Oct 28, 2024 at 03:10:14PM +0530, Aneesh Kumar K.V (Arm) wrote:
> >
> 
> > NOTE: We could also use KVM_EXIT_MEMORY_FAULT for this. I chose to
> > add a new EXIT type because this is arm64 specific exit type.
> >
> > Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> > ---
> 
> I have used KVM_EXIT_MEMORY_FAULT as part of the initial prototype.

Ah, apologies, I clearly didn't read the changelog.

> >> +		/* KVM_EXIT_ARM_NOTAG_ACCESS */
> >> +		struct {
> >> +			__u64 flags;
> >> +			__u64 gpa;
> >> +			__u64 size;
> >> +		} notag_access;
> >
> > Can you please look into reusing the memory fault exit infrastructure?
> >
> > The entire point of that is for KVM to tell the VMM it cannot make
> > forward progress because of ${SOMETHING} unexpected at the specified
> > GPA. You can add a new flag that describes tag access.
> >
> 
> The only reason I dropped the change was because the flag will be very much
> arm64 specific.

Eh, making it arm64-specific is very much the right call. There's no
shortage of available bits in that structure, and we should make no
attempt to provide a generic description of what is otherwise a very
architecture-specific thing.

> Based on your feedback, I will switch to KVM_EXIT_MEMORY_FAULT in the next
> update.

Excellent, thanks!

-- 
Thanks,
Oliver
