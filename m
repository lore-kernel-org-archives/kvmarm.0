Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFBE175D5D
	for <kvmarm@lists.linux.dev>; Fri,  7 Feb 2025 18:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738951814; cv=none; b=CFVWwDDKb/6HPYXYanMSElV0BvQhTGdSi6ALQ3sbBQVip16eSUkEII6G0UfTjl4cD7C/z7/4AqZwksBiqQsEkEETVmVAL9TcWcQ8JQ/3hIaCHsPiBI9xrBfxHMmDzPRKe8MSr/cVprdQO2cMXmrbefiFeNsCUX273Dq2VijR4qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738951814; c=relaxed/simple;
	bh=tEtChQbqDC5VWGaTnPiu5QAw3tL4WSL0apJi/+jOPVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dwcOwi4uI4t5V/9zIG2s4g7ALNMqTFJFQdPUxGlCHAAxQD/gcxFD2lhd8uNoEsT4ztTrkScXK+dEUXTwMWK6FWnuqyAToee2+E+LcjnIxUW1ZFhyzJCIU/HV2POE8pHiC13XiA4hTY3he3sAWp0WCGDI5R8QsKZ57OKRoKTpPmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F219C4CED1;
	Fri,  7 Feb 2025 18:10:10 +0000 (UTC)
Date: Fri, 7 Feb 2025 18:10:08 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	kvmarm@lists.linux.dev, oliver.upton@linux.dev, will@kernel.org,
	mark.rutland@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
	sebott@redhat.com, yuzenghui@huawei.com, wangzhou1@hisilicon.com,
	jiangkunkun@huawei.com, jonathan.cameron@huawei.com,
	anthony.jebson@huawei.com, linux-arm-kernel@lists.infradead.org,
	linuxarm@huawei.com
Subject: Re: [PATCH v6 4/4] arm64: paravirt: Enable errata based on
 implementation CPUs
Message-ID: <Z6ZMgDyyA5oV99hu@arm.com>
References: <20250205132222.55816-1-shameerali.kolothum.thodi@huawei.com>
 <20250205132222.55816-5-shameerali.kolothum.thodi@huawei.com>
 <Z6YT7GxVKGKcnYmL@arm.com>
 <86h655u8r3.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86h655u8r3.wl-maz@kernel.org>

On Fri, Feb 07, 2025 at 02:31:12PM +0000, Marc Zyngier wrote:
> On Fri, 07 Feb 2025 14:08:44 +0000,
> Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Wed, Feb 05, 2025 at 01:22:22PM +0000, Shameer Kolothum wrote:
> > >  static inline bool is_midr_in_range(struct midr_range const *range)
> > >  {
> > > -	return midr_is_cpu_model_range(read_cpuid_id(), range->model,
> > > -				       range->rv_min, range->rv_max);
> > > +	int i;
> > > +
> > > +	if (!target_impl_cpu_num)
> > > +		return midr_is_cpu_model_range(read_cpuid_id(), range->model,
> > > +					       range->rv_min, range->rv_max);
> > > +
> > > +	for (i = 0; i < target_impl_cpu_num; i++) {
> > > +		if (midr_is_cpu_model_range(target_impl_cpus[i].midr,
> > > +					    range->model,
> > > +					    range->rv_min, range->rv_max))
> > > +			return true;
> > > +	}
> > > +	return false;
> > >  }
> > 
> > It's a interesting approach but how does this work in practice if an
> > erratum requires a firmware counterpart? Do we expect firmwares on all
> > machines involved to have workarounds for the other machines? Or is KVM
> > going to intercept those SMCs and pretend the EL3 counterpart is there?
> 
> KVM already traps SMCs, and could do something on behalf of the guest
> (such as pretending that the mitigation has happened if not on the
> correct host) *IF* the mitigation is architected (à la WA{1,2,3}).

That's the main thing I had in mind. I don't think we have any other
errata that requires firmware run-time discovery and interaction, though
you never know when we'll add new one.

> If it is implementation specific, then we can immediately stop
> pretending that a guest running on those systems can be migrated.

Makes sense.

> The only thing it helps a bit is big-little.

It does help a bit or, at least, we have some code for handling these
variations that cab be extended. However, with this patchset, the host
only probes the availability of the workarounds on the SoC it booted. It
has no idea about the extra MIDRs the VMM picks and what the other
machines in the clouds support.

Anyway, let's hope the VMs only migrate between platforms that are
equally broken.

-- 
Catalin
