Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D77EE1A76A9
	for <kvmarm@lists.linux.dev>; Tue, 24 Sep 2024 15:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727190327; cv=none; b=UicdXeySd4kjhnlhOKlntbLiXaDXc9Y2n7EFhU3kUhgJjqZ3ppguFAktaYfkY487l3zunuKgLF/448eHHJr0D80xyD/CqLNnf2mls++mpn24aq4blqylCoD6SPJ5twQHeN9EflSoMdXxKDGAkDpzWYZg5u6ZaPK+YL4AeApfLTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727190327; c=relaxed/simple;
	bh=QtmtI/XsOxI4ganGGiCkXFRl2cFP6LPOQ66sNlWb99w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JrqzHffW0mXq+/nCoQ9BdYk2HUGK8TDdFYmDhPocThWDpWA79PGw6IV5O6Aomzn0qr/WwvSJiVcWpFxp1RoyQ6gvkyEAoiSR/RHLRmg95anZ/DG2K0WM+cTGHLjNFfDb5J+SwE0sBzcSU6okZbwmwnBprSdPmjWCXjb6/6BZ694=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 68898DA7;
	Tue, 24 Sep 2024 08:05:54 -0700 (PDT)
Received: from e133380.arm.com (e133380.arm.com [10.1.197.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9B4EF3F7A6;
	Tue, 24 Sep 2024 08:05:20 -0700 (PDT)
Date: Tue, 24 Sep 2024 16:04:43 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org,
	nd@arm.com, akpm@linux-foundation.org, aneesh.kumar@kernel.org,
	aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com, bp@alien8.de,
	broonie@kernel.org, catalin.marinas@arm.com,
	christophe.leroy@csgroup.eu, dave.hansen@linux.intel.com,
	hpa@zytor.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, maz@kernel.org, mingo@redhat.com,
	mpe@ellerman.id.au, naveen.n.rao@linux.ibm.com, npiggin@gmail.com,
	oliver.upton@linux.dev, shuah@kernel.org, skhan@linuxfoundation.org,
	szabolcs.nagy@arm.com, tglx@linutronix.de, will@kernel.org,
	x86@kernel.org, kvmarm@lists.linux.dev,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 19/30] arm64: add POE signal support
Message-ID: <ZvLVC0/baXfJHgww@e133380.arm.com>
References: <20240822151113.1479789-1-joey.gouly@arm.com>
 <20240822151113.1479789-20-joey.gouly@arm.com>
 <47e1537f-5b60-4541-aed1-a20e804c137d@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47e1537f-5b60-4541-aed1-a20e804c137d@arm.com>

On Tue, Sep 24, 2024 at 01:27:58PM +0200, Kevin Brodsky wrote:
> On 22/08/2024 17:11, Joey Gouly wrote:
> > @@ -1178,6 +1237,9 @@ static void setup_return(struct pt_regs *regs, struct k_sigaction *ka,
> >  		sme_smstop();
> >  	}
> >  
> > +	if (system_supports_poe())
> > +		write_sysreg_s(POR_EL0_INIT, SYS_POR_EL0);
> 
> At the point where setup_return() is called, the signal frame has
> already been written to the user stack. In other words, we write to the
> user stack first, and then reset POR_EL0. This may be problematic,
> especially if we are using the alternate signal stack, which the
> interrupted POR_EL0 may not grant access to. In that situation uaccess
> will fail and we'll end up with a SIGSEGV.
> 
> This issue has already been discussed on the x86 side, and as it happens
> patches to reset PKRU early [1] have just landed. I don't think this is
> a blocker for getting this series landed, but we should try and align
> with x86. If there's no objection, I'm planning to work on a counterpart
> to the x86 series (resetting POR_EL0 early during signal delivery).
> 
> Kevin
> 
> [1]
> https://lore.kernel.org/lkml/20240802061318.2140081-2-aruna.ramakrishna@oracle.com/

+1, all the uaccess in signal delivery is done by the kernel on behalf
of the signal handler context, so we should do it with (at least) the
same memory permissions that the signal handler is going to be entered
with.

(In an ideal world, userspace would save this information itself, using
its own handler permissions -- well, no, in an ideal world we wouldn't
have the signal delivery mechanism at all, but hopefully you get the
idea.)

Cheers
---Dave
> 
