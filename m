Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A340383C97
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 16:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779899030; cv=none; b=jHhvpHIewdYfWwJ8DzWiwJMYM0sz+iXiPE67d2qIIT2Qyj0nt1UMwwHotKkXnvHa8ZU5gyRkYOm+hZAkCTrNtPhXWyqumx0I+gsvJTC34XJHJxRdqWlMwX5WAdp7VGy2/SyFUwol0vYb2v3gmb4tmNIl9jWuetWv0VhFt4F+A9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779899030; c=relaxed/simple;
	bh=InqS0OB5sXHJnaWxKY98YA1/vqiX1EgRZ7YEPyZzGxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JF+UKOtRSnpTMGr86Eg80tlyWQ3dgmNN9Rg+pSUL3noPJD5ftlmgfrFTabFGf8xnw/2TwHRyxNrwnoJfdOII5eRDDx+dO5xykjpgTDMUCnELsM3wXMwnsHkOgPVg7kmfUQ8P+aIt0Aqb3xVXlzHjpX29o1eHYoyGYl/YOIsw/ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=a5AGH8Pf; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="a5AGH8Pf"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F14B435B9;
	Wed, 27 May 2026 09:23:37 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AE3D63F905;
	Wed, 27 May 2026 09:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779899022; bh=InqS0OB5sXHJnaWxKY98YA1/vqiX1EgRZ7YEPyZzGxc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a5AGH8PfHk7vb+yoJ0nscckmvGxnZGjktW9L9rRBYjdcN4FCfTyLGrS+yUO39DMMP
	 p5H+P4Y5GnRAfsvjBYVmJTHQ/PZzrAHZJWgtgv93++KALizHl9h1ZByVCshMLHsnBk
	 dy8zYvLS9BLaS3a3/HRhpHJpx3n1Eb0Q5l2hJMNE=
Date: Wed, 27 May 2026 17:23:39 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, james.morse@arm.com, maz@kernel.org,
	oupton@kernel.org, tabba@google.com, will@kernel.org
Subject: Re: [PATCH 16/18] arm64: fpsimd: Move sve_flush_live() inline
Message-ID: <ahcai1BV71rDmGLa@J2N7QTR9R3.cambridge.arm.com>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-17-mark.rutland@arm.com>
 <0f34443d-222e-42d3-b6c2-d15bb656e1d2@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f34443d-222e-42d3-b6c2-d15bb656e1d2@sirena.org.uk>

On Wed, May 27, 2026 at 01:54:42PM +0100, Mark Brown wrote:
> On Thu, May 21, 2026 at 02:25:54PM +0100, Mark Rutland wrote:
> > Currently sve_flush_live() is written in out-of-line assembly. It would
> > be nice if we could move it inline such that control flow can be written
> > more clearly in C, and to permit the removal of otherwise unused
> > assembly macros.
> 
> > +static inline void sve_flush_live(void)
> > +{
> > +	unsigned long vl = sve_get_vl();
> > +
> > +	if (vl > sizeof(__uint128_t)) {
> 
> It feels odd to use sizeof(__unit128_t) here rather than u128.  Whatever
> colour the bikeshed is:

FWIW, that was just to match __fpsimd_to_sve(). If there was nothing
else to be consistent with, I agree that using u128 woul2d be
preferable.

> Reviewed-by: Mark Brown <broonie@kernel.org>

Thanks!

Mark.
