Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F80442391;
	Fri,  4 Sep 2026 11:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788521371; cv=none; b=nSBBY0H4ycBxKhgYAoOf+TqAVeFVqBu40hoWy9aLlMWCmz6LCViFgTKGmtATq2cBcG2mKjRLniK6sVD9mf0aAbQjriA46fGMUAiFrdWzRvBFTDe/0BEpUmNU6taGhDmESOycTRE2tEP3VjtVIZuBTXdP737wM67Vx8RKQFOtC5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788521371; c=relaxed/simple;
	bh=mvKYjcYn7lnbgrKG2nj9gDufBHNQ8X9EMhA7/nciXjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RG0w46FbKnWUEq7euWaw14nGDaUJyjFmkBm+UnIBPT6zn9gy9GcBESSaqio7ud6hlXLBZp+Zka1QWW3vkecKK8AdrbR2ojv3nv8M6BApy4TOw32KV78FQgr0XTvgOrqsOIxgmkmauCmsirIz12d24ZX45CTsMzlEkuSh4vGHuYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S3CW6oLx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S3CW6oLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A148C1F00A3D;
	Fri,  4 Sep 2026 11:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788521370;
	bh=nYpjpY9VpDbdUoIIwbwVBXNpp2PNQ8zhNKLEb84EfHU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S3CW6oLxq2m/d2er71gcF7/MEcC2C3Zyuzp3q8J50daHhYe3UiXkZJ9KoEaLSd+5C
	 kuMeT3+jZkBRHoYpvzrExZkOtjpBsBGbubNUr52OiR8vHHp5Po+vnb3JqXgQRvpOlr
	 x/bKiZiCrfMaeWqG0efDs7l8s7hs0Y9/hF41NtlZjoNoToxCyO6FbPBkVtM0gNpLKl
	 NIrEsjKSAt2fBa+Vueb3zT08UWPTSBS4mCMwTz0RaGA2xJzjzRL+lXrdjPowASEPXP
	 LalJghHsVQdMYISf+XJPy+8Y2YKuWMvM60Ivcp+S3WnzcPgg2BgezXqOQK01gLxA/k
	 ngQcjBD7Uumgw==
Date: Fri, 4 Sep 2026 12:29:23 +0100
From: Will Deacon <will@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: arm64: Enable S1PIE for nVHE and hVHE
Message-ID: <apqrky27mJmUV9UA@willie-the-truck>
References: <20260904-kvm-arm64-nvhe-pie-v1-0-29d59f245e6c@kernel.org>
 <20260904-kvm-arm64-nvhe-pie-v1-2-29d59f245e6c@kernel.org>
 <86pkyt4gvt.wl-maz@kernel.org>
 <eb788ad5-5bb3-4767-87b8-d35d9e3ab220@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb788ad5-5bb3-4767-87b8-d35d9e3ab220@sirena.org.uk>

On Fri, Sep 04, 2026 at 11:33:24AM +0100, Mark Brown wrote:
> On Fri, Sep 04, 2026 at 08:25:58AM +0100, Marc Zyngier wrote:
> > Mark Brown <broonie@kernel.org> wrote:
> 
> > > When FEAT_S1PIE (stage 1 permission indirection) is supported we
> > > currently enable and use it in the hypervisor when running in VHE mode
> > > but not when running in nVHE or hVHE mode.  While systems with
> > > FEAT_S1PIE would normally use VHE users can configure them for nVHE or
> > > hVHE, for example in order to run protected guests.  Enable FEAT_S1PIE
> > > with nVHE and hVHE.
> 
> > No. nVHE is dead, and I'm not adding support for random stuff that
> > appeared over 10 years after v8.0. If you have S1PIE, you have VHE.
> 
> > If you force the kernel to run with E2H==0, that's your own problem.
> 
> What about pKVM, my understanding was that that is very much an ongoing
> concern and uses the nVHE hypervisor?  My expectation was that this
> would only ever get used in hVHE configurations when people enable pKVM
> on modern hardware, actual nVHE mode was mostly just carried along with
> that.

pKVM uses hVHE wherever it can nowadays, so I'm fine with only supporting
S1PIE on hVHE and VHE configurations if that's easier to maintain. We
just need to make sure that the failure mode for nVHE results in the
feature being gracefully disabled, rather than e.g. crashing or quietly
doing the wrong thing.

Will
