Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 989103C5832
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 16:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779813529; cv=none; b=LkLZIUr8qoUa6veZjVFwUTcmB1pmKx7wVxJSxiCSQpT4p9a32SdaHsXHancZUfUa8c+vj4gTl+QNPNKRYCsP0MTzL8DWJsx4cflS3utiF0WULy3yUSoqSZE9UGGdgyPX45C6S/+yZxeA80vS+rOhdwURYsJD2g8i6E//BJJZmoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779813529; c=relaxed/simple;
	bh=hgd1a5KIJvCclvHmLPaarvh/x6qz4vlG4cI8Vl8saEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BoCgZbaWkmpJeah0P5L2+Ib/5h/Cpmosn2UaObkRC+U2ppVvTkuW/L8u0W14o5XlVxVEs4BpOcM0JPNAk1tVl7oofg8EvjvJ79VIlvVPpAIB4g9RNGmRjUGlUTSRHOwPjeo7AdeQi7NeeT7ruz50B4unS/7tnHFgQx+Dnr60dlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kVtWIPKz; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kVtWIPKz"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 86BD62936;
	Tue, 26 May 2026 09:38:40 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A8FB83F7B4;
	Tue, 26 May 2026 09:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779813525; bh=hgd1a5KIJvCclvHmLPaarvh/x6qz4vlG4cI8Vl8saEw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kVtWIPKzazU6BuSfUf/We1In6vv915fVFqrrQplqcLlQwy/jhbeNSLl7bpTrN+DUZ
	 aM+jCXfuD3MTZwEUQl204iRsb9nNIelbclSXHM94zFqmXMHcgNFmqXcM/Pb2v/jnbF
	 eJUFR/HV98gAxo5OmQlcMgqLCXhC0OVVJUMYDdUA=
Date: Tue, 26 May 2026 17:38:40 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
	maz@kernel.org, oupton@kernel.org, tabba@google.com,
	will@kernel.org
Subject: Re: [PATCH 17/18] arm64: fpsimd: Move SME save/restore inline
Message-ID: <ahXMkPEpgaZQf_Nk@J2N7QTR9R3>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-18-mark.rutland@arm.com>
 <ahWpST4K3rbMbjWK@J2N7QTR9R3>
 <08e5ce52-be74-4fc5-a0b2-8f405a5eff99@arm.com>
 <ahW8Eba3SNqfVDdk@J2N7QTR9R3>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahW8Eba3SNqfVDdk@J2N7QTR9R3>

On Tue, May 26, 2026 at 04:28:17PM +0100, Mark Rutland wrote:
> On Tue, May 26, 2026 at 03:39:56PM +0100, Vladimir Murzin wrote:
> > Hi Mark,
> > 
> > On 5/26/26 15:08, Mark Rutland wrote:
> > > On Thu, May 21, 2026 at 02:25:55PM +0100, Mark Rutland wrote:
> > >> +static inline void __sme_save_za(struct sme_state *state, unsigned long svl)
> > >> +{
> > >> +	/* The <Wv> argument to STR (array vector) can only encode W12-W15 */
> > >> +	register unsigned long v asm ("12");
> > > Sorry, I had meant to put "x12" here, but evidently GCC and LLVM accept
> > > "12" on its own.
> > > 
> > > For clarity (e.g. to match the comment) I'll change that to "w12" and
> > > make the type unsigned int. Likewise in __sme_load_za().
> > 
> > I suspect you are intentionally not using "Ucj" constrain to limit register allocator,
> > if so I'm wondering why?
> 
> Thanks for the suggestion; that was ignorance rather than intent.
> 
> I was not aware of "Ucj" as it doesn't appear on the public GCC
> documentation:
> 
>   https://gcc.gnu.org/onlinedocs/gcc/Machine-Constraints.html
> 
> Looking at the machine description file, that's marked with '@internal',
> so IIUC GCC folk don't seem to expect/want people to use it. That said,
> LLVM seems to support it.
> 
> I'll go check that all relevant toolchains support this, and poke GCC
> folk to see if they're happy to promote that to a public constraint.

GCC folk seem happy to make this public, which is great! I'll cross-link
a thread here if/when patches appear.

In the short term, using "Ucj" would require bumping our minimum
supported toolchain necessary for SME:

* GCC gained "Ucj" in 14.1.0, tagged on 7 May 2024.

* LLVM gained "Ucj" in 18.1.0, tagged on 27 Feb 2024.

... so using that would require adding a dependency on a newer
toolchain, e.g. via a CC_HAS_UCJ_CONSTRAINT to match the existing
CC_HAS_K_CONSTRAINT.

Aligned with the rationale on patch 8, v6.16 (tagged 27 July 2025) was
contemporary with GCC 15.1.0 (tagged 25 April 2025) and LLVM 20.1.0
(tagged 4 March 2025), both of which supported "Ucj".

> If that's all good, I'll move over to "Ucj". If not, I'll update the
> commit message and/or comments to explain why.

If Will and Catalin are happy to depend on a toolchain as above, I'll go
add the necessary CC_HAS_UCJ_CONSTRAINT Kconfig logic.

Otherwise I'll go note the above in a comment, and stick with the
register variable for now.

Mark.
