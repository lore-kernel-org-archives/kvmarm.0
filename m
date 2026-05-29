Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8941D30C60E
	for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 09:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780045847; cv=none; b=Scravy2X00FPMwis0j0dn3fRu171nLaRU8FaDaHtVoLBwh5sXkhduqtYA4YSvbvSjsY1qPX2C4KsPI629cxiite0J4xD3IU1iSTrdTMlUaJlTTDw566LFo7Sczhyu2NCisuKnlWHMh1eEsMwbJfMxRcHpphnTyaYS7A1ft+Nwgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780045847; c=relaxed/simple;
	bh=X2wPCYS8sd8ZPqpJFapp4g1rTj2bthmSFl8gViU/14w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dRPG/Ur7diqw1vaCU/VF0Me/GUvcPuDPxSHti6y9WurmcX4ad1JMvZuBx0kNaF6gmq5MNVYg1XaQNU3A28UQ4Zdxxrhv6Cbdjks3zR+eFrgRNakZI/ko8HbeOX0wSkhpdZpTmOL92h03xmJ70aZUXpTDgBl4BE9sjTaPtMaswJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Za2SUu40; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Za2SUu40"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A13502103;
	Fri, 29 May 2026 02:10:35 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 041593F905;
	Fri, 29 May 2026 02:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780045840; bh=X2wPCYS8sd8ZPqpJFapp4g1rTj2bthmSFl8gViU/14w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Za2SUu40QqXq4u/rRr0cmV2rAaU0D1DGXjljjEsx2mQ8UHfTMTWUg/AzhZwLf9FOL
	 d2PnaUeo4VVv8hPkpRhKhl5vS8x57kSq3FfVm3INW9k12u2AsbXC2rHmEcbt04DSKP
	 7GHbD5NyAlv+IippGAsohAw6QNw24bDzyYg2dxow=
Date: Fri, 29 May 2026 10:10:35 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
	maz@kernel.org, oupton@kernel.org, tabba@google.com,
	will@kernel.org
Subject: Re: [PATCH 17/18] arm64: fpsimd: Move SME save/restore inline
Message-ID: <ahlYC2qgqzNQxggP@J2N7QTR9R3>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-18-mark.rutland@arm.com>
 <ahWpST4K3rbMbjWK@J2N7QTR9R3>
 <08e5ce52-be74-4fc5-a0b2-8f405a5eff99@arm.com>
 <ahW8Eba3SNqfVDdk@J2N7QTR9R3>
 <ahXMkPEpgaZQf_Nk@J2N7QTR9R3>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahXMkPEpgaZQf_Nk@J2N7QTR9R3>

On Tue, May 26, 2026 at 05:38:40PM +0100, Mark Rutland wrote:
> On Tue, May 26, 2026 at 04:28:17PM +0100, Mark Rutland wrote:
> > On Tue, May 26, 2026 at 03:39:56PM +0100, Vladimir Murzin wrote:
> > > Hi Mark,
> > > 
> > > On 5/26/26 15:08, Mark Rutland wrote:
> > > > On Thu, May 21, 2026 at 02:25:55PM +0100, Mark Rutland wrote:
> > > >> +static inline void __sme_save_za(struct sme_state *state, unsigned long svl)
> > > >> +{
> > > >> +	/* The <Wv> argument to STR (array vector) can only encode W12-W15 */
> > > >> +	register unsigned long v asm ("12");
> > > > Sorry, I had meant to put "x12" here, but evidently GCC and LLVM accept
> > > > "12" on its own.
> > > > 
> > > > For clarity (e.g. to match the comment) I'll change that to "w12" and
> > > > make the type unsigned int. Likewise in __sme_load_za().
> > > 
> > > I suspect you are intentionally not using "Ucj" constrain to limit register allocator,
> > > if so I'm wondering why?
> > 
> > Thanks for the suggestion; that was ignorance rather than intent.
> > 
> > I was not aware of "Ucj" as it doesn't appear on the public GCC
> > documentation:
> > 
> >   https://gcc.gnu.org/onlinedocs/gcc/Machine-Constraints.html
> > 
> > Looking at the machine description file, that's marked with '@internal',
> > so IIUC GCC folk don't seem to expect/want people to use it. That said,
> > LLVM seems to support it.
> > 
> > I'll go check that all relevant toolchains support this, and poke GCC
> > folk to see if they're happy to promote that to a public constraint.
> 
> GCC folk seem happy to make this public, which is great! I'll cross-link
> a thread here if/when patches appear.

Alex Coplan sent a patch for GCC to make this public:

  https://gcc.gnu.org/pipermail/gcc-patches/2026-May/718560.html

In v2 of the series I stuck with the register variable since the older
end of our supported compilers don't support "Ucj", but we should be
able to move to that in future as we drop support for those older
compilers.

Mark.
