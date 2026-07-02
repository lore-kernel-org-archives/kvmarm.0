Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7C703537FB
	for <kvmarm@lists.linux.dev>; Thu,  2 Jul 2026 07:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782976621; cv=none; b=S0KLUitlJoc3AFd/mUz0+RfSk3tX05oQdfy1U0mwyxfT6dEcAeGLZVHdV15GBLneDF1mrtOebWcBC9ZObjpCoDXt1BczsOmSL2MMwumsTiTon/0lRgJdreZG72oUuZlJfl/wFxIQAgsSaz/21p22jZ0nL7b7nizqGXW3NzavPiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782976621; c=relaxed/simple;
	bh=ux+5K91c8irZvOPBKxeYjz66GivC/IDAZ6O8pJgTbyk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EnUedHuyQhJ6Orp+ucTEfaNO7r+qqJRFYrSYzdAERXVhLWPQuETg84OFPjpI5Ytyv1rPRGrjr8+OtzHPfVTzjik8a/qbEVozAFkDjjuXmMK4aA8HP+ymjuyB5od6yV37H5yJTNH4haAp7zS4xrFr0D1WpBgDmnTDvoq41PNUje0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=atPGVHcO; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="atPGVHcO"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE9453587;
	Thu,  2 Jul 2026 00:16:53 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8529E3F85F;
	Thu,  2 Jul 2026 00:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782976618; bh=ux+5K91c8irZvOPBKxeYjz66GivC/IDAZ6O8pJgTbyk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=atPGVHcO75xpJERy4CA5tF+12sXDKB0J30ZUMSJLy2fuC5fval1k5AWkjyxBZtKwt
	 9Xi34DTEY0GdffljAGJ6vhXq5hOBLczwQyDAftWFWKWVbD0myoYnCrpYahx+aS4zkr
	 woIvS8xLhUXXSTEqRz0rawlaRBegV8+mZXtWqzhI=
Date: Thu, 2 Jul 2026 08:16:39 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Fixes for S2 permission relaxation
Message-ID: <gc4lz3mna2ddx3ixkuuhxvrapbt3qy3h63msrzsxuiltehtxjc@dohrdlfgjb5w>
References: <20260701231620.3300204-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701231620.3300204-1-oupton@kernel.org>

On Wed, Jul 01, 2026 at 04:16:18PM -0700, Oliver Upton wrote:
> Couple of small fixes for S2 permission relaxation.
> 
> The first patch looks a bit worse than it actually is, potentially
> consuming an uninitialized stack variable as a TLBI TTL hint in the
> event of a race to update the PTE. However, if the bad TTL value results
> in the stale TLB entry remaining valid, the vCPU will just fault again
> and (hopefully) avoid the race.
> 
> Second patch is of a similar flavor, where the permission relaxation was
> unconditionally updating XN, potentially reaping execute permissions
> when handling a write fault. The consequence of this is taking an
> unintended execute permission fault to restore the original XN value.
> 
> Applies to 7.2-rc1.
> 
> Oliver Upton (2):
>   KVM: arm64: Ensure level is always initialized when relaxing perms
>   KVM: arm64: Only update XN attr when requested during S2 relaxation
> 
>  arch/arm64/kvm/hyp/pgtable.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)

For the series,

Reviewed-by: Wei-Lin Chang <weilin.chang@arm.com>

> 
> 
> base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
> -- 
> 2.47.3
> 
