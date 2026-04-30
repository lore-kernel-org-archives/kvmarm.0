Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A462406264
	for <kvmarm@lists.linux.dev>; Thu, 30 Apr 2026 12:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777552671; cv=none; b=inPg/EHd2Tth8eEy/TxXVnapbH01vHeWzkgjGcEYw+EvYk95qblvZdVFi8buhBn+EChics2qbZTAtRjMSkIla8VvtooT3k3jx2KI0wXud0601tYkY2mBRQxnbpCoShKkGSbF83MqnJKFQkXvq36xyeHhLY8kwGPISVpyDx9JNyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777552671; c=relaxed/simple;
	bh=7HPUcR8285oASPEPdQ3uCkZCcDoT78pU2f7CPixIm4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hwlYxIWgcTmKxZRvgBHxo+IIwYm9z2kBy07FAiqG8ixNb1P61PmNzQ7jCXwzMDEeot7Gt71PJ0KiQ62LaGuHrd9RKW9qgf2bqhi8/ZyC3gJpt5qMUBS1gZz9+apowZDsf+l8cUssPl2jdBQZ7cBBtsoJluWhcSpepCTZNwpM8pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ezRKIkMg; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ezRKIkMg"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2F08B19F6;
	Thu, 30 Apr 2026 05:37:44 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 464D43F7B4;
	Thu, 30 Apr 2026 05:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777552669; bh=7HPUcR8285oASPEPdQ3uCkZCcDoT78pU2f7CPixIm4U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ezRKIkMgNpnf2rFG7bNWqgnB1U/ESgHDMInNeRwgf/Q0UB9pO0E+arQrNfdeVH0aC
	 O0joOZ+gJtN1+m3MfJ9h8WF4Y8ODT04kdMcjG5A2aUcxKXVGZAhggg8LpQ6iEJDCY1
	 wUI+AuCSaPhxbAdaub9eNaVRjmyez7/rxAxlzYnw=
Date: Thu, 30 Apr 2026 13:37:42 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Fuad Tabba <tabba@google.com>
Cc: Will Deacon <will@kernel.org>, maz@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	qperret@google.com, vdonnefort@google.com, catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/8] KVM: arm64: Make EL2 exception entry and exit
 context-synchronization events
Message-ID: <afNNFtoZJk2IXwwU@J2N7QTR9R3>
References: <20260428103008.696141-1-tabba@google.com>
 <20260428103008.696141-2-tabba@google.com>
 <afMb7uuPlUbLeu7k@willie-the-truck>
 <CA+EHjTw6rx5rCVnR7Dfva3xmmgGjqUeUaT=3zDCEsN0J909Wsg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+EHjTw6rx5rCVnR7Dfva3xmmgGjqUeUaT=3zDCEsN0J909Wsg@mail.gmail.com>

On Thu, Apr 30, 2026 at 01:18:48PM +0100, Fuad Tabba wrote:
> On Thu, 30 Apr 2026 at 10:08, Will Deacon <will@kernel.org> wrote:
> > On Tue, Apr 28, 2026 at 11:30:01AM +0100, Fuad Tabba wrote:
> > > Fixes: fe2c8d19189e ("KVM: arm64: Turn SCTLR_ELx_FLAGS into INIT_SCTLR_EL2_MMU_ON")
> >
> > I don't think this Fixes: tag is accurate:
> >
> > 1. That commit doesn't do anything with EIS/EOS afaict.
> > 2. Back in 5.12 (when that thing landed), SCTLR_EL2_RES1 did actually
> >    include EIS and EOS
> >
> > so I think the issue here might be that the auto-generated sysreg file
> > quietly changes the RES1 definitions as bits get allocated, but the
> > macros using the RES1 definition don't get updated. That's a pretty
> > horrible pit that it feels like we might keep falling into :/

I think that's a review failure, and people need to be careful when
updating the sysreg file (e.g. looking at whether any new bits were
previously RESx, and considering the impact). Regardless of tooling, we
need people to conciosuly review that.

> > Looking at 0a35bd285f43 ("arm64: Convert SCTLR_EL2 to sysreg
> > infrastructure"), I think we ended up dropping a whole bunch of fields
> > from the RES1 mask (which became 0!). Have you checked all of those?

> On the wider question of the other bits dropped from the old mask,
> I went through them against DDI 0487 M.b §D24.2.175. The summary
> (SCTLR_EL2 with E2H=0):
> 
>   bit  field    E2H=0 status                  kernel cares?
>   -------------------------------------------------------------
>    4   SA0      RES1 unconditionally          no
>    5   CP15BEN  RES1 unconditionally          no
>   11   EOS      RES1 iff !FEAT_ExS, else RW   yes (this fix)
>   16   nTWI     RES1 unconditionally          no
>   18   nTWE     RES1 unconditionally          no
>   22   EIS      RES1 iff !FEAT_ExS, else RW   yes (this fix)
>   23   SPAN     RES1 unconditionally          no
>   28   nTLSMD   RES1 unconditionally          no
>   29   LSMAOE   RES1 unconditionally          no
> 
> The seven non-EIS/EOS bits all fall under the "Otherwise: Reserved,
> RES1" clause for the E2H=0 layout, with no feature guard. Writing 0
> to them is a no-op, so dropping them from the mask should be harmless
> I think. EIS and EOS are the only positions where the bit
> becomes RW (with UNKNOWN reset) on FEAT_ExS hardware and the
> kernel actively relies on the value being 1, which is what this
> patch addresses.
> 
> I agree the auto-generator silently zeroing previously hand-rolled
> RES1 masks is a real problem. Happy to look at either teaching the
> sysreg infrastructure to express conditional RES1 (so config.c's
> AS_RES1/FEAT_X facts can flow back into the header masks), 

Please don't add that to the syreg code; that's deliberately *only* the
architectural definitions, and overloading that is going to make things
even more confusing, because "I want to treat this as RESx in this piece
of code" isn't a global property.

> or at least adding a build-time check that flags any auto-generated
> <REG>_RES1 that shrinks. After this series, though. Let me know if
> you'd like me to take a stab.

FWIW, having tooling to compare before/after would be useful, but I
don't think that can be a standard build-time check, given that this
would depend on having the old and new sysreg files available for
comparison.

Mark.
