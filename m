Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 840EA18A92F
	for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 12:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784809835; cv=none; b=JALevLeZsGHFzPIeyNrn6mUadz1+RiHfEMtNbV3r3Y3riEQwunm4BXva05e8UBt6z6/hdaRoIakgoRexbbMevBnx0JwfM05KMHjxgLM+ke64nkd3cfL+1Kj3cn/3jksYaj/Q+41TAJ838+tOqUfmOKE5lhIo9786EWq5RpI84mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784809835; c=relaxed/simple;
	bh=D9b7QZwBuuV0OrDRC/6goX+R19G+8jmXb8K0TVh5EMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kknBj+CMO5M4GXEss5mN+53a9y61GxMQgNXei6IdfLyOPTtlJ5nlkvKj/bS5HAJc4//DpFcpROAQpdfprSsoh+sx7gvoygW1WZVsxFDYgUM670DY6oaEP3YajUJHaW1719/5AcdIySFvCt0FDmKAgniIAxgY65psaqjfLBeZmrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JgVcMkeT; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JgVcMkeT"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5B9E01477;
	Thu, 23 Jul 2026 05:30:28 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C9D983F59E;
	Thu, 23 Jul 2026 05:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784809832; bh=D9b7QZwBuuV0OrDRC/6goX+R19G+8jmXb8K0TVh5EMs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JgVcMkeTJJ4P4FfZC2DKTIG2CK3JiugQN8UJUQ3GhN1/bKw8b0wDBvTCg4Y3Vrjsk
	 z52idKXbarz8sd0UvNX6oWtOSwNsblHV0O56U5g95iiRceM67pCkvKW+SMDgzcBhcn
	 +2gIRwAChHRW1BRbfLWA17HpoSK1Hzo4okc6lrfA=
Date: Thu, 23 Jul 2026 13:30:23 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Fuad Tabba <tabba@google.com>, Ben Horgan <ben.horgan@arm.com>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v12 02/29] arm64/fpsimd: Update FA64 and ZT0 enables when
 loading SME state
Message-ID: <amIJX3j6VHto1YWs@J2N7QTR9R3.cambridge.arm.com>
References: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
 <20260709-kvm-arm64-sme-v12-2-d0301d79ef58@kernel.org>
 <ali39DG6qie7XTuD@J2N7QTR9R3.cambridge.arm.com>
 <15a9ae14-395d-472a-a5be-9e46524fb493@sirena.org.uk>
 <3c76650f-ddda-47ae-a676-86016d8e39a6@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c76650f-ddda-47ae-a676-86016d8e39a6@sirena.org.uk>

On Sat, Jul 18, 2026 at 01:35:21AM +0100, Mark Brown wrote:
> On Thu, Jul 16, 2026 at 04:28:02PM +0100, Mark Brown wrote:
> > On Thu, Jul 16, 2026 at 11:52:36AM +0100, Mark Rutland wrote:
> 
> > > >  		if (test_thread_flag(TIF_SME)) {
> > > > -			unsigned long vq = sve_vq_from_vl(sme_vl);
> > > > -			sysreg_clear_set_s(SYS_SMCR_EL1, SMCR_ELx_LEN, vq - 1);
> > > > +			sysreg_cond_update_s(SYS_SMCR_EL1, task_smcr(current));
> > > > +			isb();
> > > >  		}
> 
> > > What's the ISB for? That mysteriously appeared in v11 without
> > > explanation. It wasn't in the original code, prior versions of the
> > > series, or my suggested rework with the task_smcr() helper.
> 
> > > I don't believe it's necessary to add an ISB here.
> 
> > I can't remember or figure it out, I'll delete.
> 
> Actually I remembered: while SCMR_EL1.LEN is self synchronising the
> "without the need for explict synchronization" wording is not present
> for SMCR_EL1.{FA64,EZT0} and this is no longer explicitly just an update
> of LEN.  It's possible I'm being overly paranoid here, I'll leave the
> isb() and add a comment for the next version.

Ok.

Given we've already forgotten that once so far, that definitely needs a
comment.

Mark.
