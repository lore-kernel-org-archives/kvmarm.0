Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 456E5549382;
	Thu, 10 Sep 2026 18:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789063398; cv=none; b=EaRqAALhts8MCjmzDVWnSYAqpNiZf7FCHqxgaqkBTHFuGeuRUxe7qdiWStyC9us0nZGAfgxvMx1mLCR7jbgKDhPn/L4BzyFFPZJCCjbQio4twE4KxeKWKcLonjmLiBDAJzf4hawIfvRb0DsO0mo9HUx58NQ1vimsURHpTLV29xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789063398; c=relaxed/simple;
	bh=Yz46h4KIY1XXQzuFH2WkQ6074Bz96Y2doBe+4TrWxwY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hkEk9vivsnnk1ZK8Y2bCXkxnUdpQncTfOnMwNGZKUdsb6kIHoGMvO7ttWaoXnZEEXzIe7EPZLpoaF/4xtmzcA9PyLh98esVkMjk+kpXSxN9r6IIX3DE7xtjZe91pegr/cpmYA+ihEQ9ZvZJqSK1gcdJ4oPROoH5JQSYR1fHkxbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QJFed0LK; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QJFed0LK"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA3D2237B;
	Thu, 10 Sep 2026 11:03:12 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A903C3F7B4;
	Thu, 10 Sep 2026 11:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789063396; bh=Yz46h4KIY1XXQzuFH2WkQ6074Bz96Y2doBe+4TrWxwY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QJFed0LKzVe7TTm2ktMn2PJU5aRkmECa/AWldoOjJ4es1g6QJ0MLtLnMiU6RJor6V
	 7sPbPvlrxcGvfm6XsgwWxYifner2fz7ywA0KDx7G/W734l20xwrUegy9GsRwBw17C0
	 oS2xqmZhJHkLX3ToduLQPjDKkT5lfQa+RjbqqyTQ=
Date: Thu, 10 Sep 2026 19:03:12 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v17 1/1] arm64: mm: Handle Granule Protection Faults
 (GPFs)
Message-ID: <aqLw4EsUG5CUFxUR@arm.com>
References: <20260907162204.1479401-1-suzuki.poulose@arm.com>
 <20260907162204.1479401-2-suzuki.poulose@arm.com>
 <20260907163213.018E31F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907163213.018E31F00A3A@smtp.kernel.org>

On Mon, Sep 07, 2026 at 04:32:12PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] Missing untagged_addr() in do_gpf_ptw() causes show_pte() to fail for tagged user addresses.
> --
> 
> commit 33ff4ae42e692cd124830f34b7d3c5368fce252f
> Author: Steven Price <steven.price@arm.com>
> 
> arm64: mm: Handle Granule Protection Faults (GPFs)
> 
> This commit introduces handlers for Granule Protection Faults (GPFs) which
> occur when accessing memory delegated to a realm. It issues a kernel oops
> for GPFs on page walks via do_gpf_ptw(), and sends a SIGBUS for non-page
> walk faults. It also handles fixups for spurious kernel GPFs.
> 
> > diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> > --- a/arch/arm64/mm/fault.c
> > +++ b/arch/arm64/mm/fault.c
> > @@ -910,6 +910,22 @@ static int do_tag_check_fault(unsigned long far, unsigned long esr,
> >  	return 0;
> >  }
> >  
> > +static int do_gpf_ptw(unsigned long far, unsigned long esr, struct pt_regs *regs)
> > +{
> > +	const struct fault_info *inf = esr_to_fault_info(esr);
> > +
> > +	die_kernel_fault(inf->name, far, esr, regs);
> 
> [Severity: Medium]
> Does this code miss untagging the address before passing it to the oops
> handler?

I think that's a valid point, we should use untagged_addr(far) here.

-- 
Catalin
