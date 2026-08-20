Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE3F9381B0E
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 23:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787269165; cv=none; b=MXs/jBUc0z0lFxRXnxsUleyubQOsrIhFfJ2rDbnhzfb9Q+xMf13lryQRN6YGPWqyPfvHBDQ+PeWItsyooS7CZHxV4+2bMUEEbu55eM35pMPsu2NJcr17HT/QnMsWUh7EydAoRMeYTZUHms9GO5/9X7pbGjMlJaN0O7dykWWB+fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787269165; c=relaxed/simple;
	bh=N9bzHgTPT7M5yE8AGOin8doDdx+BxPy1gflF77tWeWE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SSb1W097QGz0EjCpwL0S5xKoH0gr+qpEVzN1n32mK/V00njuvPSA6oqVud54Y+vx0PdoYRrZwiCWvT1OnXXyJfqOmFsBRQCR+E/KkZ3XY1Nvw2RGt2yF+7poBYjMNd1K4gwymhFMY9WMvs/55Al+ZAHVQKeOFGCwQ0rRj/G91iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PjPN+x0c; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PjPN+x0c"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EF9CB202C;
	Thu, 20 Aug 2026 16:39:17 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E8C753F763;
	Thu, 20 Aug 2026 16:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787269161; bh=N9bzHgTPT7M5yE8AGOin8doDdx+BxPy1gflF77tWeWE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PjPN+x0cxlDOswhIzxMCFYv/hiq2OPnMflZZyAmGlXpZI138ae27wQt0tkiIDbEsd
	 qoymqmWY4oFuX5oDW+1M09I8WaO8CCjK4bVluvkOct9CuAx4+dFfNT+J9rB036STEV
	 AWYWdESLhUmNcc5u9Ryl84d1s6h2vct2UnVunHWg=
Date: Fri, 21 Aug 2026 00:39:08 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Leonardo Bras <leo.bras@arm.com>, Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, 
	Oliver Upton <oupton@kernel.org>, Peter Maydell <peter.maydell@linaro.org>, 
	Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v19 03/14] KVM: arm64: Manage GCS access and registers
 for guests
Message-ID: <hwz52absjxap7n6olwt3lmjakmtgxxaku5gcofsrcfa45zdygh@dqgylcillnud>
References: <aoXamcdKoMynTkpX@LeoBrasDK>
 <48be9e5d-357a-4863-8682-8b3f34c69723@sirena.org.uk>
 <aobUGyq8nInJYkdA@LeoBrasDK>
 <97ad6e83-b22b-4881-b644-66fa99f68d64@sirena.org.uk>
 <aocOi3wjcliZqoe7@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aocOi3wjcliZqoe7@LeoBrasDK>

On Thu, Aug 20, 2026 at 03:28:39PM +0100, Leonardo Bras wrote:
> On Thu, Aug 20, 2026 at 03:07:14PM +0100, Mark Brown wrote:
> > On Thu, Aug 20, 2026 at 11:16:59AM +0100, Leonardo Bras wrote:
> > > On Wed, Aug 19, 2026 at 05:46:00PM +0100, Mark Brown wrote:
> > 
> > > > This is just because there isn't a preexisting ctxt_has_tcrx() check
> > > > already there, FEAT_GCS architecturally depends on FEAT_TCRX and there
> > > > was a request to make this explicit in the code to try to optimise
> > > > things a bit.  The compiler should skip over both blocks at once if TCRX
> > > > isn't there rather than having two separate tests or static branches.  I
> > > > didn't add new checks where there were none since I expect that to be
> > > > unhelpful for code generation, you'd get the reverse situation and emit
> > > > two checks.
> > 
> > > Humm, but then why saving GCSPR_EL2 does not depend on TCRX/E2H? Or maybe a 
> > > better question, why are not GCSPR_EL2 and GCSCR_EL2 saved in the same 'if' 
> > > clause under ctxt_has_tcrx() (and E2H set), if they are restored in the 
> > > same 'if' clause?
> > 
> > > As you mentioned, GCS depends on TCRX, so it should be fine, but just by 
> > > reading the code I see:
> > > - GCSCR_EL2 :
> > > 	Save if 	GCS=1, TCRX=1, E2H=1
> > > 	Restore if 	GCS=1, TCRX=1
> > > - GCSPR_EL2 :
> > > 	Save if 	GCS=1,
> > > 	Restore if	GCS=1, TCRX=1
> > 
> > > Which looks kind of confusing for the as a first time reader.
> > 
> > > Does it make sense?
> > 
> > I agree that the current situation is a bit hard to follow, I'd actually
> > originally written things without the explict dependency because of that
> > but Marc wanted the optimisation.
> 
> Well, I am not against the explicit dependency thing, it just looks odd 
> to me that some save/restore have a dependency and it's counterpart does 
> not. As well as the dependencies for both registers being different.

Hey I feel the question wasn't answered completely :)

Here is the reason for the asymmetric save restore (besides the tcr2
part):

GCSCR
 If guest E2H == 1:
 - L1 accesses to GCSCR_EL2 and GCSCR_EL1 have the same intent -> they
   both mean access the vCPU GCSCR_EL2.
 - L1 access to GCSCR_EL2 (e.g. msr GCSCR_EL2, x0) traps, KVM updates
   both the in-memory vCPU GCSCR_EL2, and the hardware GCSCR_EL1 for the
   the guest. In-memory copy stays up to date.
 - L1 access to GCSCR_EL1 does not trap -> in-memory vCPU GCSCR_EL2
   becomes stale if it's a write.
 - From above, must save on exit.

 If guest E2H == 0:
 - Only L1 accesses to GCSCR_EL2 mean access the vCPU GCSCR_EL2.
 - L1 accesses to GCSCR_EL2 always traps.
 - In-memory vCPU GCSCR_EL2 always stay up to date.
 - From above, no need to save on exit.

GCSPR
 - Regardless of the guest E2H value, hardware could write to the
   hardware GCSPR_EL1, making the in-memory vCPU GCSPR_EL2 stale.
 - From above, must save on exit.

Restore is trivial, vCPU GCSCR_EL2/GCSPR_EL2 must be written to the
hardware EL1 registers because someone else could be using it.

Quite a few other registers are saved only if guest E2H == 1 because of
the same reason.

Thanks,
Wei-Lin Chang

> 
> >  There's similar things with other
> > registers in the current code (eg, the PIE and POE registers are in the
> > same situaton as GCSCR_EL2).  One thing I did miss here is some nesting
> > inside the PIE checks for EL2, I'll update for that.
> > 
> 
> Awesome!
> 
> > I think what would help here would be to move to generating more of the
> > save/restore sequences rather than open coding them, we could have lists
> > of registers and then use data about the feature dependencies that the
> > architecture has (hopefully it's already in the MRS, I didn't check) to
> > generate these optimised feature checks rather than having to open code
> > them.  Possibly even list features and generate some of the register
> > lists, though that would need far more special case handling and it's
> > *much* less clear if there could be a benefit.
> 
> Yeah, that would automatize the feature dependency for register loading, 
> but maybe code would not be that clear on how it works? I have questionable 
> taste, though.
> 
> Thanks!
> Leo
