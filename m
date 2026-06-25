Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FB932B11D;
	Thu, 25 Jun 2026 17:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782406894; cv=none; b=kZ7pWqY3z+IIH6E/AfmByF9K++4rDODOCyjWYiaJqyd7ZK3b2VhPEJkX+SJvQ1EYufwlH3eqZLfUsqQhy/P+DPh5P9PImKv1Roh3QkHA8LkR/k/HFQ380Oux1yShRMCojfx1aVdphdPHu97HEV+ioaM2Kbw5l33ITzocFgR+o0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782406894; c=relaxed/simple;
	bh=qsW0IMHTpwDuA36ssBZ4W6i74HrarexoJaueLvN/Qaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KxQQGcbVIFdgO7b5jQlwBOK49nt9YxUxv0Y81MmbPXvkTGm/sKOIGe4KTBwmKCkSPhR/Y8U1dux8GB0PRE+m0etDP1MlN/thVq+VQ+LBjxu0dgTpYph6Sn1OXeX7/hG4qISEP35V+gouUchYuhwFr+8+cUk/zoXlXHcaWLBGpeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BcxlpDjV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BcxlpDjV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55FF1F00A3A;
	Thu, 25 Jun 2026 17:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782406893;
	bh=Pgndj2O4lUgqBabH5jlv1IWDyp7US4O2X5XAWeenrDw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BcxlpDjVL3KgepCGPu5olhEhUUWGb20VEBYiY5gbIJJBhMaTi48e1Wqjag+LRQZBk
	 t6WI9CtlJd/y79hDWsKOKLmGyf6EZ9dZCpx4RC3t01Xkh9GWpNk5KxAgrierOzhUIV
	 n/K+sOoys5yakZjUG+WISZXkgq2S/HFE0TCVIxe9NaJgjQ2Q8xFdHC7aqEZqGHjou5
	 D+u0PNMNSuww3KVSTsQ4K5LlCXXUbt1tdCkmNmLBV37JW3fKg1doawTkX2mjW5PkHw
	 OQ/86UnadPTFkp3maA0XGX7/1wsU2hHUSxpHXaEmxFQXNzepTAGQCdzwLHcv0bfdNj
	 nLqYb7zb0p+Ag==
Date: Thu, 25 Jun 2026 18:01:28 +0100
From: Will Deacon <will@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH kvmtool 4/4] arm64: Add support for protected VMs
Message-ID: <aj1e6LAKfoTYjraf@willie-the-truck>
References: <20260619115415.5475-1-will@kernel.org>
 <20260619115415.5475-5-will@kernel.org>
 <CA+EHjTww=aY50itZBv=jUA6VeFNxgzyPkz2bktmW_ua1UdGmbQ@mail.gmail.com>
 <ajqnfXfp-fCf9jGF@willie-the-truck>
 <b161c306-5b78-41dd-aab6-79fc35086c8f@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b161c306-5b78-41dd-aab6-79fc35086c8f@arm.com>

On Wed, Jun 24, 2026 at 09:53:07AM +0100, Suzuki K Poulose wrote:
> On 23/06/2026 16:34, Will Deacon wrote:
> > On Fri, Jun 19, 2026 at 02:49:11PM +0100, Fuad Tabba wrote:
> > > On Fri, 19 Jun 2026 at 12:54, Will Deacon <will@kernel.org> wrote:
> > > > diff --git a/arm64/include/kvm/kvm-arch.h b/arm64/include/kvm/kvm-arch.h
> > > > index a50e6a4..e7dd526 100644
> > > > --- a/arm64/include/kvm/kvm-arch.h
> > > > +++ b/arm64/include/kvm/kvm-arch.h
> > > > @@ -87,6 +87,8 @@
> > > > 
> > > >   #define MAX_PAGE_SIZE  SZ_64K
> > > > 
> > > > +/* Size of DMA region for bouncing when running a protected guest */
> > > > +#define DMA_MEM_REGION_SIZE    SZ_32M
> > > 
> > > Worth scaling with guest RAM, or making it overridable for DMA-heavy guests?
> > 
> > It's a bit difficult to know how much to allocate here. It's some
> > function of the number of devices, but then it also depends on dynamic
> > properties such as virtqueue sizes. It shouldn't really be related to
> > the amount of guest RAM or the DMA throughput.
> > 
> > The number of devices isn't readily known, but even if I did something
> > horrible like enumerate them from the arch code, I'd then still need a
> > magic number to multiply that by. I think that making it overridable
> > would give the user of kvmtool the same headache.
> > 
> > For now, I think I'll add a check to fail if the guest has been
> > explicitly provisioned with less memory than the bounce buffer (diff
> > below) but I'll leave anything more advanced for the future if/when we
> > know what the problems are with a constant size for the pool.
> 
> In the future, make it a user problem ? i.e., specify a size for the DMA
> pool. We did have some hack for this in the past. Can dust it up if
> there is interest

Yes, I'm not opposed to adding that in the future. I'd just rather do it
in the context of somebody experiencing a problem with the constant, so
that we can have a better discussion about the right way to fix it.

For example, we might consider per-device pools.

Will
