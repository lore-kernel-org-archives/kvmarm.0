Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCDF1C2E
	for <kvmarm@lists.linux.dev>; Sun, 21 Apr 2024 16:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713717031; cv=none; b=AoXM6bJxaSRN6hPg29IbTGYMahNKIM/Ki1HrN9Q0w2wQ8bu998hsbqkHT4j3lWICQWaCq11SCV7nEdMPvD2RO5d1J6WwWWRzgJCON1K8OMCYjTKgzxehIqNI7FsOu66nC5HDqbgasKSCtoRzbzLon4+/ph8RXHu5Lq2lSimdsJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713717031; c=relaxed/simple;
	bh=s5bVMO+HDAhrB0UxHPhxZc9MimSQS86DPbYy5AAJfoM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hw4HJU4jxbp7/L9+wKcOwchw6LX1RcXspV98QJq9kVXKWweQTfmtoVFZ7XjRZ2y+x1c2o4rGgkL/TMpHLmvN+FnYDt0Ezt25iyEQ5Rox/X+1VsrBcQtPHoVHftT0tvXzlBbAjNjAhNGZE3uSQh5/2103NoS+KFaK5fNEBGdDQ3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=R/AS6B++; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="R/AS6B++"
Date: Sun, 21 Apr 2024 09:30:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713717026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2wFokZP7SI/0jU5iHSEj/IYWG/zdCFSBGY2PtEpbLg4=;
	b=R/AS6B++O9E0FO5dddy2/aDI8qPCTvinyNh3UoSz00qpVVXSKQhq4HiDRxgoVWK0JxrdTG
	LRZSQdYUUXtDc71MeTlZhtN7XuEPMKmjYDSllOxn0VwxzYHOSs3eZ4jt0aib3IBAXjpsYi
	mDrlRO7J5Jm6+C3RHjtNkxPlRPV3yPI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v2 07/19] KVM: arm64: vgic-its: Scope translation cache
 invalidations to an ITS
Message-ID: <ZiU_Hfnn49Z4yZHb@linux.dev>
References: <20240419223842.951452-1-oliver.upton@linux.dev>
 <20240419223842.951452-8-oliver.upton@linux.dev>
 <86o7a3qbw3.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86o7a3qbw3.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sun, Apr 21, 2024 at 10:54:20AM +0100, Marc Zyngier wrote:
> > -void vgic_its_invalidate_cache(struct kvm *kvm)
> > +static void vgic_its_invalidate_cache(struct vgic_its *its)
> >  {
> >  	struct vgic_dist *dist = &kvm->arch.vgic;
> 
> Err. How does this work? Looks like you got the patch splitting wrong
> and that it doesn't bisect until patch #11.

I had a fixup for this but I seemed to have dropped it, sorry about
that.

-- 
Thanks,
Oliver
