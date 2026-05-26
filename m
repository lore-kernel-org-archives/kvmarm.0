Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEA232C0F84
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 14:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779804500; cv=none; b=m50bE/sn7wU3o9a6OcjCIJJM3VKMR5idUxG3K4Wf8FSFi7naimIgQnRWvTKsVO23+1AQKoagtIuiua3YCNbOAcgfASYNSHKaGiL03kLs5W13+f6zvr2Q4zbFRp7JW5jDxkPmD2MPzT1nMtce/9Xax4FB5IzTrpNiGmMNeJZAFKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779804500; c=relaxed/simple;
	bh=tBzhwHahomz6uwc8GUYFU3AAPX0bK9V3VDvg/q4LsYY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rSxK36n1o2d3zpjXR9AyfdCxCqfe2PJJJmFN3q0L5S88mpc7H2Nxxszp5bppXjzJFDBd/AYD9TWyKsfz4TrdnIkZqV9Lxmd0pIbHUGNNkTpIUQWJbX4jYfkcz0RHWprutmq0oQaUn5OD2QJL8H8D9/uJBJ4/zkbGxCkjQTU96Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mgRQezl+; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mgRQezl+"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 05EA3169C;
	Tue, 26 May 2026 07:08:11 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 83C773F7B4;
	Tue, 26 May 2026 07:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779804496; bh=tBzhwHahomz6uwc8GUYFU3AAPX0bK9V3VDvg/q4LsYY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mgRQezl+HdnVQoGPfPLj94IQdXbQUmhV7d5+JWdu6CTZjWRZdbvvCvGdfbyOny9/D
	 wrI8S5M4+DcLB0jWV7YhiOE5vS9NK93pCOAJAB2POFgBsVg8SPNKXC4zUIbYfGE7J1
	 WDKyw59fgDaG1w+yC6evrBumz9TYjbI/qqVBd2dU=
Date: Tue, 26 May 2026 15:08:09 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Cc: broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
	maz@kernel.org, oupton@kernel.org, tabba@google.com,
	will@kernel.org
Subject: Re: [PATCH 17/18] arm64: fpsimd: Move SME save/restore inline
Message-ID: <ahWpST4K3rbMbjWK@J2N7QTR9R3>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-18-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521132556.584676-18-mark.rutland@arm.com>

On Thu, May 21, 2026 at 02:25:55PM +0100, Mark Rutland wrote:
> +static inline void __sme_save_za(struct sme_state *state, unsigned long svl)
> +{
> +	/* The <Wv> argument to STR (array vector) can only encode W12-W15 */
> +	register unsigned long v asm ("12");

Sorry, I had meant to put "x12" here, but evidently GCC and LLVM accept
"12" on its own.

For clarity (e.g. to match the comment) I'll change that to "w12" and
make the type unsigned int. Likewise in __sme_load_za().

Mark.
