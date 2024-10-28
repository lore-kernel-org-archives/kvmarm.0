Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A67A1DA631
	for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 12:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730119671; cv=none; b=NOeQZRUfRaeOEIHq7FH3Ubcr86J1TurMWstOI7GUqmVv1HV2/8CEag3XVX2j0lY5YwJFVracfgKo4dIEdQ7wVyr8ejk9tW8pXOQiCdbyvKnp7VbNneNQBcoZ2dasvfZU7+0DgJrzmo5IprzA0bFyXiS24Nq2f5A2pIMUMMkG7Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730119671; c=relaxed/simple;
	bh=KiCpJBFGX6RPQsbT7ud6HkFC5svvobH8bXsg2UHOg5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nZStKjbSwyq0FNRLMbByEPq0dkZWxispCmWcH4cR0t/b1bKFPXMHdnCbr1/e4wUrhvQTLc4fE0Suw+4fwoQx3JVih1ZrYIosIpAjEw+CUje6W6Ije0nQmnA7EPvotSTRLPZVUpQ3HVL2RTJ1Td4VOX2tGymLkr9DkZxWk2hu2aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5B88B497;
	Mon, 28 Oct 2024 05:48:18 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D52DE3F73B;
	Mon, 28 Oct 2024 05:47:46 -0700 (PDT)
Date: Mon, 28 Oct 2024 12:47:44 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH 3/3] arm64/hw_breakpoint: Enable FEAT_Debugv8p9
Message-ID: <Zx-H8IU2wZmyowGe@J2N7QTR9R3>
References: <20241001043602.1116991-1-anshuman.khandual@arm.com>
 <20241001043602.1116991-4-anshuman.khandual@arm.com>
 <ZxfGAHAn6I41ZLZV@J2N7QTR9R3>
 <2310454a-99c6-4ff9-80f7-8707fbfaf5a6@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2310454a-99c6-4ff9-80f7-8707fbfaf5a6@arm.com>

On Wed, Oct 23, 2024 at 01:01:52PM +0530, Anshuman Khandual wrote:
> 
> 
> On 10/22/24 21:04, Mark Rutland wrote:
> > On Tue, Oct 01, 2024 at 10:06:02AM +0530, Anshuman Khandual wrote:

[...]

> > Wherever this lives it needs a comment explaining what it is doing and
> > why. I assume this is intended to protect the bank in sequences like:
> > 
> > 	MSR	MDSELR, <...>
> > 	ISB
> > 	MRS	<..._, BANKED_REGISTER
> 
> Correct, it is protecting the above sequence.
> 
> > 
> > ... but is theat suffucient for mutual exclusion against
> > exception handlers, or does that come from somewhere else?
> 
> Looking at all existing use cases for breakpoint/watchpoints, it should
> be sufficient to protect against mutual exclusion. But thinking, do you
> have a particular exception handler scenario in mind where this might
> still be problematic ? Will keep looking into it.

Where does the mutual exclusion come from for the existing sequences?
We should be able to descrive should be able to describe that in the
commit message or in a comment somewhere (or better, with some
assertions that get tested).

For example, what prevents watchpoint_handler() from firing in the
middle of arch_install_hw_breakpoint() or
arch_uninstall_hw_breakpoint()?

Is the existing code correct?

Mark.
