Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71535E3A5
	for <kvmarm@lists.linux.dev>; Wed,  6 Mar 2024 09:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709718917; cv=none; b=mwPUZnSl8tZgQhidWR7/yd0Lu3PkyFIvNxMWdyJgsJCQ7B6VI9KPbRubZJ5EdPPHCvzwFdD786Sfuebp4H4N782X+WOoZ7bzaoJMgbEmcgp70+mj2Z87k6c4iq7RDzDMNoe5PxjMfFTT3kz/N41GIyJEOHvac4M//lJ5EicCFrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709718917; c=relaxed/simple;
	bh=xe/8BNyOe0FdmV7rrvFidQYfVcvZ05uM4VTebf7edVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JorFTOi4riVeE/RP5YSZ1DZK4JVRz9Tod8Q3G+YJtkUni3P3lbHFyRhZqvgvzCvmsomqG+2KAqc51gze0a8Z6/HWePWQRvO7JG2bBQu2o9xC9DJMitYVQlytcwNrPYghqEM4SFvFkF5c+Nhk2AGEJjhGVrW9gV2rNjaJ6kf8zD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=N8YxATPV; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="N8YxATPV"
Date: Wed, 6 Mar 2024 01:54:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709718912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t3d+m6hNXl5hgwMOZADU2m+gnqGKs+7BcKatO6r/la8=;
	b=N8YxATPVwyV/BW1RGQhrVKaYvGKUtPCcNtXuU/V/39TXneJyi43nSP4b9UTnQKNFUxebey
	rDhkSIOkRCHO1kt43r6SfGh+slsJ4XObP6Y6SiDuc1tFVX5oCaMCA7jg3uh7iAc8pdEK4J
	hnetHbt7C8PjrMIQUqxskF28KnANNck=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH 3/3] KVM: arm64: Do not disable preemption in
 kvm_vcpu_pmu_restore_guest()
Message-ID: <Zeg9c15-PAy8pOmV@linux.dev>
References: <20240305184840.636212-1-oliver.upton@linux.dev>
 <20240305184840.636212-4-oliver.upton@linux.dev>
 <87cys7r8jr.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87cys7r8jr.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 06, 2024 at 09:52:56AM +0000, Marc Zyngier wrote:
> On Tue, 05 Mar 2024 18:48:40 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > The caller has already disabled preemption, no need to nest further.
> 
> A quick survey indicates that it doesn't seem to be the case, I'm
> afraid. access_pmu_evtyper() and access_pmcnten() both seem to be
> preemptible.

Dammit. Someone forgot to grep...

> Which probably means that these spots are doing the wrong thing and
> that we should instead turn it into a KVM_REQ_RESYNC_PMU_EL0 request.
> 
> Then the preemption can be actually dropped, and even replaced by an
> assertion.

Agreed, thanks for the suggestion.

-- 
Best,
Oliver
