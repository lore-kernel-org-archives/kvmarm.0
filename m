Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72E2514884C
	for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 13:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774445644; cv=none; b=TeCn8PEtPd42L6mPAxcQKdkuvjPvBm0tQCglUyRrgYJf8UICnWGNTpU2oQMQovFXFCYgr2JJuu+biUcQrRK3PbukUYYFhomP1FYZ8f/7xD1XJbbiz9tTFZK6FISQr9wJY+9Fi4KwMwjqPY+9guuKUIxONKCZQTT6Ci9XnOL4uLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774445644; c=relaxed/simple;
	bh=lZ4CBq7Ixdqscjj9OP02TD8QGkO3fkLUcmUe5Ywrwt8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K6kN2AWdIzA+9eIzNt8Iu4xyo4RfCnkZ5glqj59nzRhd6iMOLoB+hJoYOtfEk1iQ4VD2UUeMbBkExbfWfrKqBFtHPWyBWhqIHUgdQzC91px6uJtjaRab9YI+Or+5E4BJ7FPUMtJU0JxUXLuAviADpDp/xJo5Du+ixZrXnImWgAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fSp6CPlk; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fSp6CPlk"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C95A61CDD;
	Wed, 25 Mar 2026 06:33:55 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9BC673F836;
	Wed, 25 Mar 2026 06:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774445641; bh=lZ4CBq7Ixdqscjj9OP02TD8QGkO3fkLUcmUe5Ywrwt8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fSp6CPlksiz56QNHDFrh7jhkmfSfbX6IKMXHufXvfnVp24CrQ7HiXg5BrUJVfCq2p
	 C2jM8duFHGe0Hq5IbJDz7RsS0VPQcfcZxGGkHi2BVCfs6ubfHyiWbBVqXAnmz82dWS
	 R78gyDj6te/Vl3XUc7Etkv5pGG/fsSGtIE14Y1Rk=
Date: Wed, 25 Mar 2026 13:33:56 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Sebastian Ene <sebastianene@google.com>,
	Vincent Donnefort <vdonnefort@google.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, catalin.marinas@arm.com, joey.gouly@arm.com,
	oupton@kernel.org, suzuki.poulose@arm.com, tabba@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v2] KVM: arm64: Prevent the host from using an smc with
 imm16 != 0
Message-ID: <acPkROffwAsuqsuX@J2N7QTR9R3>
References: <20260325113138.4171430-1-sebastianene@google.com>
 <acPIdoA8oc7T8wKX@google.com>
 <86ldfg3ze2.wl-maz@kernel.org>
 <acPRIk7_dH5Erul8@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acPRIk7_dH5Erul8@willie-the-truck>

On Wed, Mar 25, 2026 at 12:12:18PM +0000, Will Deacon wrote:
> On Wed, Mar 25, 2026 at 11:46:29AM +0000, Marc Zyngier wrote:
> > On Wed, 25 Mar 2026 11:35:18 +0000,
> > Vincent Donnefort <vdonnefort@google.com> wrote:
> > > 
> > > On Wed, Mar 25, 2026 at 11:31:38AM +0000, Sebastian Ene wrote:
> > > > The ARM Service Calling Convention (SMCCC) specifies that the function
> > > > identifier and parameters should be passed in registers, leaving the
> > > > 16-bit immediate field of the SMC instruction un-handled.
> > > > Currently, our pKVM handler ignores the immediate value, which could lead
> > > > to non-compliant software relying on implementation-defined behavior.
> > > > Enforce the host kernel running under pKVM to use an immediate value
> > > > of 0 by decoding the ISS from the ESR_EL2 and return a not supported
> > > > error code back to the caller.

> > It also begs the question: if you don't want to handle SMCs with a
> > non-zero immediate, why is it OK to do it for HVCs?
> 
> I suppose the difference is that the HVC API is a private interface
> between EL2 and the host. As it stands, EL2 ignores the immediate but we
> don't have a way to know how EL3 responds to the immediate for an SMC.
> 
> When proxying an SMC from the host, EL2 therefore has three choices:
> 
>   1. Ignore the immediate from the host and always use zero when talking
>      to EL3. That's the current behaviour, but it could theoretically
>      lead to problems if EL3 is using the immediate for something.
> 
>   2. Propagate the immediate from the host. That should work, but it's
>      a bit involved.
> 
>   3. Reject non-zero immediates (this patch).

I think (3) is the only safe option. As described in:

  https://lore.kernel.org/linux-arm-kernel/acPi5V0DgGcgHNGO@J2N7QTR9R3/

... regardless of the the conduit (HVS/SMC) used, a non-zero immediate
is NOT a legitimate SMCCC call. (1) is not safe, becuase it could change
the semantic of the call, and (2) is not safe because the calling
convention could differ (and e.g. things might be clobbered that we
don't expect).

We know that the host *SHOULD* use a zero immediate, and so anything
else represents a bug that we will want to catch.

Mark.
