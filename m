Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A55383CA0
	for <kvmarm@lists.linux.dev>; Fri, 11 Oct 2024 15:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728659488; cv=none; b=pc65OaEZ95JnaDwdWzgLW7OA8otaZfU4oxYUccDlpIV0uhWgqNvj+yV7xuUYZSe5pldtclmj6xb2cRb4BHN/vY4HaeqQZqWWbcZ6LzNy0TnFXWreSzPcdZ3X8uquS+EWyVPrHyuzTeE8ycqIpHDLqDakbCTr0l9y8r0nPgdXOsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728659488; c=relaxed/simple;
	bh=eqkzo2LVTCFXLMVq3B6lW5d/B6kruQE2c8OF6IyfyIc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=svBOpIsWhgRfPs1lC8Ik9stGIYfRc59GOzR3WR+WCchPTZInPFchNkxqkYRZOocxrkJbom89LPuog37sUBvbHQZTnrwwjIWgNiXVauKOC+slHACkTuQG8e3RbzvIjz02Upjs4oyBNVKmRNcS7/9yss3qKEOxhoeKfrTC12lFiM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wvfgoYeN; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wvfgoYeN"
Date: Fri, 11 Oct 2024 08:11:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728659479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZVDpfrPn38iMJttp1evxDmmyklx8JXwqnWkoXRFLgJE=;
	b=wvfgoYeNPuVYgbFWTBuhRaZe+A4cMXn9We0kHN5fhSHh4OOv6q1FF0dIw1yQFVI9OvwaKS
	vg8vYolBR5oTl2pFHaOAMhV5lw5SF3xQgAN+ug2Lcxa/LA6H1QU0wKE+EAf+3wSfVZa5UA
	/BjOWOxcdEMgRndQ4ZSlRpfhGXZ4au8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>,
	"cohuck@redhat.com" <cohuck@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	yuzenghui <yuzenghui@huawei.com>,
	"Wangzhou (B)" <wangzhou1@hisilicon.com>,
	jiangkunkun <jiangkunkun@huawei.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Anthony Jebson <anthony.jebson@huawei.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Linuxarm <linuxarm@huawei.com>
Subject: Re: [RFC PATCH 0/6] KVM: arm64: Errata management for VM Live
 migration
Message-ID: <ZwlADbp-HjkijElX@linux.dev>
References: <20241011075053.80540-1-shameerali.kolothum.thodi@huawei.com>
 <86jzef53iz.wl-maz@kernel.org>
 <3f4469c49625413f9ab2c224d0d3fbea@huawei.com>
 <86ikty6f1b.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ikty6f1b.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Fri, Oct 11, 2024 at 12:43:28PM +0100, Marc Zyngier wrote:
> On Fri, 11 Oct 2024 11:57:10 +0100, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:
> > > >
> > > > Please take a look and let me know your thoughts.
> > > 
> > > Having eyeballed this very superficially, I think we can do something
> > > simpler, and maybe more future-proof:
> > 
> > Thanks Marc for taking a look and the quick feedback.
> 
> No worries, that's the least I could do given that you put the effort
> implementing my silly ideas! ;-)
> 
> > > - I don't think KVM should be concerned about the description of the
> > >   target CPUs. The hypercall you defined is the right thing to do,
> > >   but the VMM should completely handle it. That's an implementation
> > >   detail, but it would make things much simpler.
> > 
> > Ok. So does that mean the hypercall will use some sort of shared memory
> > to retrieve the list of target CPUs from VMM?
> 
> Two possibilities:
> 
> - either shared memory, in which case the hypercall would require the
>   guest to give an IPA and size for the VMM to write its stuff into
>   the guest memory,
> 
> - or more simply return the data as an MIDR/REVIDR pair in registers,
>   the guest requesting an index, and getting an error when out of
>   range, leaving it with the freedom to organise the storage.
> 
> The second option is a bit slower, but way simpler, and it only
> happens once per guest boot, so it would probably be my preferred
> option unless this is proved to be impractical.

Also worth noting there's existing UAPI [*] for allowing userspace to
register range(s) of hypercalls that it services directly. It's a bit
weird that we'd allow userspace to do stuff in KVM's own hypercall
range, but I don't think it really matters at this point since this is
all prototyping.

[*]: https://docs.kernel.org/virt/kvm/devices/vm.html#attribute-kvm-arm-vm-smccc-filter-w-o

-- 
Thanks,
Oliver
