Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9371E376E
	for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 06:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739427291; cv=none; b=ZwY9SkkXb5gElxaOqM7A8dPEwH2kGAqk+6LAv0Xn/sIbP3HtX9LnSlUy+MZvi7xUMlAy5fQq30+lpcnKzt5iv1WC41CRG/xu2ZYNh2uU5ue6thwnZUEdU7hP9Y57TQHFA0g6uDibwq74Bmcn0l6xnW6JrM+Ql7bAIVaqfWDM3vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739427291; c=relaxed/simple;
	bh=1R8tWNZd0Yp5liGmyR9m/i7eEgtPLcC9uwsA3XfHu7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A0YmZ9eYARvzMWqIhOf6G5vLgwaVVfe6UpMrARBE5AkmRKB/Un7OlaCpNc2j4zMih+L0ZwcRgHaYrcXTnQAnQps9vHJ8c51hPOmPSAJzAd6in1yGcEtjFNVW+uhWsakyfQIId+67cEb23/wCBSHnIVmxnIyQzJOBukZocvexsmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rfpa5Zy3; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rfpa5Zy3"
Date: Wed, 12 Feb 2025 22:14:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739427277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5cjQWSwj8nKF9KoRQ2WmbNuDTwdSzRb9QicnW/ugG1M=;
	b=rfpa5Zy3jCDew0wr+3Ap2UlABlwFrZ6W90clYvgaXHX+f1Y2+BkqgfWW+PofMQ7NrAgIYK
	ztM5LIlQ1YH9ZBfGfUI6WM/fJ81qGfighs8088pa79LoCafpufn76YepsKUa5dEqQuJxK2
	yr4wx4OSTqKC8VG+i0vLMqajSkxMh7c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v7] KVM: arm64: Fix confusion in documentation for pKVM
 SME assert
Message-ID: <Z62NxRzbOyt-nBmK@linux.dev>
References: <20250212-kvm-arm64-sme-assert-v7-1-0f786db838d3@kernel.org>
 <Z6yByMUBPDUyEWOr@J2N7QTR9R3>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6yByMUBPDUyEWOr@J2N7QTR9R3>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 12, 2025 at 11:11:04AM +0000, Mark Rutland wrote:
> On Wed, Feb 12, 2025 at 12:44:57AM +0000, Mark Brown wrote:
> > As raised in the review comments for the original patch the assert and
> > comment added in afb91f5f8ad7 ("KVM: arm64: Ensure that SME controls are
> > disabled in protected mode") are bogus. The comments says that we check
> > that we do not have SME enabled for a pKVM guest but the assert actually
> > checks to see if the host has anything set in SVCR which is unrelated to
> > the guest features or state, regardless of if those guests are protected
> > or not. This check is also made in the hypervisor, it will refuse to run
> > a guest if the check fails, so it appears that the assert here is
> > intended to improve diagnostics.
> > 
> > Update the comment to reflect the check in the code, and to clarify that
> > we do actually enforce this in the hypervisor. While we're here also
> > update to use a WARN_ON_ONCE() to avoid log spam if this triggers.
> > 
> > Fixes: afb91f5f8ad7 ("KVM: arm64: Ensure that SME controls are disabled in protected mode")
> > Reviewed-by: Fuad Tabba <tabba@google.com>
> > Signed-off-by: Mark Brown <broonie@kernel.org>

I don't think a Fixes tag is warranted here, this doesn't fix any
functional issue.

> > diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> > index 4d3d1a2eb157047b4b2488e9c4ffaabc6f5a0818..e37e53883c357093ff4455f5afdaec90e662d744 100644
> > --- a/arch/arm64/kvm/fpsimd.c
> > +++ b/arch/arm64/kvm/fpsimd.c
> > @@ -93,11 +93,14 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
> >  	}
> >  
> >  	/*
> > -	 * If normal guests gain SME support, maintain this behavior for pKVM
> > -	 * guests, which don't support SME.
> > +	 * Protected and non-protected KVM modes require that
> > +	 * SVCR.{SM,ZA} == {0,0} when entering a guest so that no
> > +	 * host/guest SME state needs to be saved/restored by hyp code.
> > +	 *
> > +	 * In protected mode, hyp code will verify this later.
> >  	 */
> > -	WARN_ON(is_protected_kvm_enabled() && system_supports_sme() &&
> > -		read_sysreg_s(SYS_SVCR));
> > +	WARN_ON_ONCE(is_protected_kvm_enabled() && system_supports_sme() &&
> > +		     read_sysreg_s(SYS_SVCR));
> 
> As I mentioned on the last round, we can drop the is_protected_kvm_enabled()
> check, i.e. have:
> 
> 	/*
> 	 * Protected and non-protected KVM modes require that
> 	 * SVCR.{SM,ZA} == {0,0} when entering a guest so that no
> 	 * host/guest SME state needs to be saved/restored by hyp code.
> 	 *
> 	 * In protected mode, hyp code will verify this later.
> 	 */
> 	WARN_ON_ONCE(system_supports_sme() && read_sysreg_s(SYS_SVCR));
> 
> Either way:
> 
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> 
> Marc, are you happy to queue this atop the recent fixes from me? Those
> try to ensure SVCR.{SM,ZA} == {0,0} regardless of whether KVM is in
> protected mode.

I'll pick it up for 6.15 if Marc doesn't grab it as a fix.

-- 
Thanks,
Oliver
