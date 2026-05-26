Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E8C03FE354
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 14:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779805261; cv=none; b=nAugqjE+HqBQXnKKN+NfdOegq33p8OXQH06bgD7vorWREHRNfO8u7MZiqzT2flHgBQ8S4mvjGiZffLFjfT1GgX9/eFsaJ0NLTdNr0YsutrNDbcwWx5zyNJC9Ef0AQJy9sOh1r08SBfZGVWg/Xgz/UGfqeW+wAJxuea5AJ9ADYhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779805261; c=relaxed/simple;
	bh=oKeqOBlOW8Be2H98W+ENHlID/l7YbOJiPsGt4yqgS+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=losB1KSP1AmemhVCFZfQrtcEd1/QAuR3SMXdi1+OZsGN2o4CKE5xmz2Cep5jv/mYeqJg6AHT4ajXdjD57UOHeqPgQAfVvELWl5VdlvtknCre00+lgOpzEWKrpFq1D0esAFHwKdRiMz1GWJvG10WBICHq0tOj7B3Ncb988rCkG3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=F14nbYYP; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="F14nbYYP"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7A69B169C;
	Tue, 26 May 2026 07:20:53 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D58D33F7B4;
	Tue, 26 May 2026 07:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779805258; bh=oKeqOBlOW8Be2H98W+ENHlID/l7YbOJiPsGt4yqgS+M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F14nbYYPYB2LN8COACBdN+twjwuAYIeYGM2J8IXo78QE4ABzj31FapUzVEAbdR68/
	 vp89J59Lbka/24fD+2rVIhuJpEKbpJxb6Or8JQDk7VkpomwibdibkkRcNe87C/CqSW
	 6o4tvmW4yUVy510uaZnZh+LaHy1N+NcMfmkLyvic=
Date: Tue, 26 May 2026 15:20:52 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Fuad Tabba <tabba@google.com>, Ben Horgan <ben.horgan@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v10 02/30] arm64/fpsimd: Update FA64 and ZT0 enables when
 loading SME state
Message-ID: <ahWsRNb9uZhf46hG@J2N7QTR9R3>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
 <20260306-kvm-arm64-sme-v10-2-43f7683a0fb7@kernel.org>
 <ahWWqU51Zffmhlo5@J2N7QTR9R3>
 <d8074c6b-9bc9-496e-8a74-94ac18ce9a55@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8074c6b-9bc9-496e-8a74-94ac18ce9a55@sirena.org.uk>

On Tue, May 26, 2026 at 02:25:56PM +0100, Mark Brown wrote:
> On Tue, May 26, 2026 at 01:48:41PM +0100, Mark Rutland wrote:
> > On Fri, Mar 06, 2026 at 05:00:54PM +0000, Mark Brown wrote:
> 
> > > We provide a helper which does the configuration as part of a
> > > read/modify/write operation along with the configuration of the task VL,
> > > then update the floating point state load and SME access trap to use it.
> 
> > > +		if (fa64)					\
> > > +			__new |= SMCR_ELx_FA64;			\
> > > +		if (zt0)					\
> > > +			__new |= SMCR_ELx_EZT0;			\
> 
> > I'd strongly prefer that we make it the caller's responsiblity to track
> > all the bits within SMCR, rather than requiring each caller to pass a
> > bag of booleans.
> 
> I was explicitly going for the opposite of that in order to make it
> harder for someone implementing a future extension to miss a place where
> an update is required, having the callers independently constructing the
> register values feels like it's asking for trouble.

I didn't say callers should *construct* the value independently, and I
showed how to centralize the construction in a __task_smcr() function.

I think callers should pass the entire value around rather than a
collection of discrete booleans: constructing a collection of discrete
booleans is functionally equivalent to construction the entire value,
and we can more easily manage the construction and passing of the entire
value.

> > 	unsigned long __task_smcr(const struct task_struct *tsk)
> > 	{
> > 		unsigned long vq = sve_vq_from_vl(task_get_sme_vl(tsk));
> > 		unsigned long smcr = vq - 1;
> 
> I agree that's a better pattern for the main kernel - we could also do
> something similar with a task_set_smcr() which wraps the explicitly
> specifed version.

I don't think a task_set_smcr() function would gain much vs
using sysreg_cond_update_s(). I expect that we'd use the SMCR value as
the source of truth (and hence that would need to be generated outside
of task_set_smcr()), at which point either task_set_smcr() would be a
thin wrapper that just hides the register name, or it would generate the
value independently and obscure the connection.

I expect that what we should have eventually is something like:

	unsigned long smcr = __task_smcr(task);

	sysreg_cond_update_s(SYS_SMCR_EL1, smcr);

	if (za) {
		__sme load_za(sme_state);
		if (smcr & SMCR_ELx_EZT0)
			__sme_load_zt(sme_state);
	}

... or:

	const unsigned long smcr = __task_smcr(task);
	const bool zt0 = smcr & SMCR_ELx_EZT0;

	sysreg_cond_update_s(SYS_SMCR_EL1, smcr);

	if (za) {
		__sme load_za(sme_state);
		if (zt0)
			__sme_load_zt(sme_state);
	}

... where in either case it's clear at the function level that the value
programmed into SMCR matches what we're using for boolean decisions, and
it's clear at a higher level that functions are consistent given
consistent usage of __task_smcr().

> That would I think avoid most of the issue you're seeing?

I'm not sure what you mean here.

I don't think we need task_set_smcr(), and I'd prefer what I suggested.

Mark.
