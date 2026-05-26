Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 617D11D9663
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 15:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779809307; cv=none; b=Uy+2nr1blbT2sINkUZWHLXJYxx94y++QtOYsAWeINDzbwpKBPno7CnMkhHwAhWJjjppK/MXuu+ArylOSyCKmZD6MMwbNQkGsNYfS5vyPlWyUxJXrek5MeSZuOYO9th97CsUf9T965+LCMsiY53GA6lKwmLQxuklDTwCqDNlOrvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779809307; c=relaxed/simple;
	bh=Vn96Xv1urpIQgHp5+8KzXszTCaXvdSDbQYLCgOToJmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pIspQHsIRPEfrmlCsYQtYXg9JmVXYTECzPZCY3WyNr6pY1ix3mmtrJas8BKt9i2g6qXTtbs4PPP1SqpiebnIPTImtxv6U18PX23YCjb4RmCIagjDCySVzMCMmjSEDoLy832TJoAE3j3A9TjSEImppS2KHs7LThX2Bq+a8Z+cRAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=POEqMYRW; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="POEqMYRW"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 24338168F;
	Tue, 26 May 2026 08:28:20 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6E99A3F7D8;
	Tue, 26 May 2026 08:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779809305; bh=Vn96Xv1urpIQgHp5+8KzXszTCaXvdSDbQYLCgOToJmM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=POEqMYRWyqgVTmrQqYt8a94MDpa71Msui1uZ2AQ6N3re2QZmtBMgdrHP8K56bap4J
	 KFa5fJcGcAAqfvljGbZWva33zxPMGHhyXNaJVimz4TuiQ5NQ+OsJwgj7RLQ886eGy+
	 FXiHO9rRUmBwAtChf9FHRrgNMoH5lx2ah6+sJuZw=
Date: Tue, 26 May 2026 16:28:17 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
	maz@kernel.org, oupton@kernel.org, tabba@google.com,
	will@kernel.org
Subject: Re: [PATCH 17/18] arm64: fpsimd: Move SME save/restore inline
Message-ID: <ahW8Eba3SNqfVDdk@J2N7QTR9R3>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-18-mark.rutland@arm.com>
 <ahWpST4K3rbMbjWK@J2N7QTR9R3>
 <08e5ce52-be74-4fc5-a0b2-8f405a5eff99@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08e5ce52-be74-4fc5-a0b2-8f405a5eff99@arm.com>

On Tue, May 26, 2026 at 03:39:56PM +0100, Vladimir Murzin wrote:
> Hi Mark,
> 
> On 5/26/26 15:08, Mark Rutland wrote:
> > On Thu, May 21, 2026 at 02:25:55PM +0100, Mark Rutland wrote:
> >> +static inline void __sme_save_za(struct sme_state *state, unsigned long svl)
> >> +{
> >> +	/* The <Wv> argument to STR (array vector) can only encode W12-W15 */
> >> +	register unsigned long v asm ("12");
> > Sorry, I had meant to put "x12" here, but evidently GCC and LLVM accept
> > "12" on its own.
> > 
> > For clarity (e.g. to match the comment) I'll change that to "w12" and
> > make the type unsigned int. Likewise in __sme_load_za().
> 
> I suspect you are intentionally not using "Ucj" constrain to limit register allocator,
> if so I'm wondering why?

Thanks for the suggestion; that was ignorance rather than intent.

I was not aware of "Ucj" as it doesn't appear on the public GCC
documentation:

  https://gcc.gnu.org/onlinedocs/gcc/Machine-Constraints.html

Looking at the machine description file, that's marked with '@internal',
so IIUC GCC folk don't seem to expect/want people to use it. That said,
LLVM seems to support it.

I'll go check that all relevant toolchains support this, and poke GCC
folk to see if they're happy to promote that to a public constraint.

If that's all good, I'll move over to "Ucj". If not, I'll update the
commit message and/or comments to explain why.

Mark.
