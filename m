Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12F9D3DE44D
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 16:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779898243; cv=none; b=SEcrOkNcKgYl52cWWiZRR+eHVLyjB7jzvahghElqI8eLEJC7QHPYFa6SQ8g98Sk8tPHvAgtD/tHNMxeYIkIwmwsAFnDvCBb4IJZ0LV1TIPx187jkw1duka0rBVuAMw9WFyveY5yLeX2O//O4chUQoAumiYK5D4+Abr0VsqEpFZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779898243; c=relaxed/simple;
	bh=CRZjbl06fUz+NEERLDHhxVn2KAs7qXdskL38TVAJirw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kjfc2pWGmbceQEmDkvOpbWUM6GGwL6TnnRANWAbwOoSCrziR+RE40k3W+1bcrghyLjouSQzlYoQEEWVE7q84bgqvgoOMnYG2a/A4qSJZwtI8td82ULZLUKIt8Roq+kDa5yBUuuCdvvmnPMqr0Xzxb/Dt1Gc32tvNcWQTQpMcTC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PGZmsNrO; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PGZmsNrO"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4444F35B9;
	Wed, 27 May 2026 09:10:36 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9C90B3F905;
	Wed, 27 May 2026 09:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779898241; bh=CRZjbl06fUz+NEERLDHhxVn2KAs7qXdskL38TVAJirw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PGZmsNrOA98FCZxR4M/Nfxq5JQKZUjFgUqgKWOBdjYTN+JCSVc3kJ37C/3BIwZl8i
	 Z6ZtIxLysZX6bFhsMFGagWewz0gJUh5bNQl4OCGJMF15q8iH5G68vef/w9stOrq673
	 wPutH8J/D6XWO5ZOwWD4Wcs+OQxaWP6XLGav0A8s=
Date: Wed, 27 May 2026 17:10:37 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
	maz@kernel.org, oupton@kernel.org, tabba@google.com,
	will@kernel.org
Subject: Re: [PATCH 07/18] arm64: fpsimd: Use assembler for SVE instructions
Message-ID: <ahcXfSz7pNugiWjj@J2N7QTR9R3.cambridge.arm.com>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-8-mark.rutland@arm.com>
 <46c5ae49-e59c-4014-91d3-f00124897d20@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46c5ae49-e59c-4014-91d3-f00124897d20@arm.com>

On Wed, May 27, 2026 at 01:58:09PM +0100, Vladimir Murzin wrote:
> On 5/21/26 14:25, Mark Rutland wrote:
> >  /* STR (vector): STR Z\nz, [X\nxbase, #\offset, MUL VL] */
> 
> Nitpick:
> 
> all these comments now redundant and just repeat the code... I know they are gone by
> the end of the series :)

Yep; if I weren't deleting them later I'd remove them here.

> >  .macro _sve_str_v nz, nxbase, offset=0
> > -	_sve_check_zreg \nz
> > -	_check_general_reg \nxbase
> > -	_check_num (\offset), -0x100, 0xff
> > -	.inst	0xe5804000			\
> > -		| (\nz)				\
> > -		| ((\nxbase) << 5)		\
> > -		| (((\offset) & 7) << 10)	\
> > -		| (((\offset) & 0x1f8) << 13)
> > +	.arch_extension sve
> > +	str	z\nz, [X\nxbase, #\offset, MUL VL]
> >  .endm

[...]

> >  /* WRFFR P\np.B */
> >  .macro _sve_wrffr np
> > -	_sve_check_preg \np
> > -	.inst	0x25289000			\
> > -		| ((\np) << 5)
> 
> Missing ".arch_extension sve"?
> 
> > +	wrffr p\np\().b
> >  .endm

Sorry about that; fixed now.

Mark.
