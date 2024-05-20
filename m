Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABC5A2D
	for <kvmarm@lists.linux.dev>; Mon, 20 May 2024 17:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716226666; cv=none; b=W+9zZ2MjiNz2hQP6GutOAJi0JwS9Mv84CUfb4wLoEHhT6Lc81Sxpu1I4G63lo8qvpQM3MsadnV/Im9UO5zAxmA1qoGuqN22FvzIAHLDGXck5iqfouYezR7OQ79sAe90itoQsi9yOOQE15PWjqPtiKgwnNmZPcVsT41G4N0mcxhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716226666; c=relaxed/simple;
	bh=6dTDISkA1uDSZsfqNoSwRSGV7VTJ2Bi880HJ+nWopd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GA1xUzHySWQlFIJo9e3vAdbsVYyw+46WCqWZLYeh2i8MCjKXPj8A3oS+ZN7oImI1lG4xBOPdneeVca0D8McfoNjiKOXlGTM0p8Xz4oUjdl40ITvmNdo27p8tFtZ8xJbjBx2VWdPAS0bPUd5NWLyzLD6bbqBmCngKv5DgfjNyYKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cs0JNGpP; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cs0JNGpP"
X-Envelope-To: maz@kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1716226662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0UFDFH5b5m6TrAVtyz9w4Ybcvme8O+mFn9zOakWTzAU=;
	b=cs0JNGpPvpaHu+UOguOadWwNyzBKIoYjEUVvcDcN5xrajYxcWKWKdaLJRqhMbv8Dt035Ff
	6t1mVBoLPy3nTmf7/NyBR7Wy2WZV8r0dWd/Bu18U/hsGdj8rpDnH15DIFhPlsw5LAy72vN
	GgQFWszBe8sK3prkNK/D7YzzZmVi89k=
X-Envelope-To: tabba@google.com
X-Envelope-To: broonie@kernel.org
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: will@kernel.org
X-Envelope-To: qperret@google.com
X-Envelope-To: seanjc@google.com
X-Envelope-To: alexandru.elisei@arm.com
X-Envelope-To: catalin.marinas@arm.com
X-Envelope-To: philmd@linaro.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: mark.rutland@arm.com
X-Envelope-To: joey.gouly@arm.com
X-Envelope-To: rananta@google.com
X-Envelope-To: yuzenghui@huawei.com
Date: Mon, 20 May 2024 17:37:36 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Mark Brown <broonie@kernel.org>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	will@kernel.org, qperret@google.com, seanjc@google.com,
	alexandru.elisei@arm.com, catalin.marinas@arm.com,
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v1 0/7] KVM: arm64: Fix handling of host fpsimd/sve state
 in protected mode
Message-ID: <ZkuKYA6-u-eZmBOO@linux.dev>
References: <20240517131814.719933-1-tabba@google.com>
 <ZkeUTix0Ojn5eHKP@linux.dev>
 <b73372b3-e032-4afd-a7cd-e08a687b1d3f@sirena.org.uk>
 <CA+EHjTxJe8yjVkhc=2fENJoMZs+MTR=9AZLmYcxZ5HxNnUOaQw@mail.gmail.com>
 <87pltg3ntq.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pltg3ntq.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, May 20, 2024 at 09:11:13AM +0100, Marc Zyngier wrote:
> On Mon, 20 May 2024 08:35:47 +0100, Fuad Tabba <tabba@google.com> wrote:
> > The reason for that is that in pKVM we want to avoid leaking any
> > information about protected VM activity to the host, including whether
> > the VM might have performed fpsimd/sve operations. Therefore, we need
> > to ensure that the host SVE state looks the same after a protected
> > guest has run as it did before a protected guest has run.

Wouldn't it be equally valid to just zero the state that will not be
preserved regardless of whether or not the guest used fpsimd/sve?

> > It would be correct to only save/restore the host's fpsimd state
> > (i.e., first 128 bits of the vector registers), which is what KVM does
> > in other modes. However, unless we always zero out the rest of the
> > state, regardless whether the protected guest has used fpsimd/sve,
> > then the host would be able to find out that the guest has in fact
> > performed fpsimd/sve operations.
> > 
> > This isn't necessary for non-protected VMs, but Marc thought that for
> > now it would be better to simplify things and have pKVM behave the
> > same way for both protected and non-protected VMs. As a future
> > optimization for non-protected VMs, we could have them behave as VMs
> > in other modes.
> 
> And I stand by what I said. Having a hybrid mode is a maintenance
> burden, and it will absolutely lead to some sort of horrible bugs (it
> just take a look at the mailing list to see that we have no shortage
> of bugs related to lazy FP/SVE handling).

Agree, but I don't think the suggestion is in any way incompatible with
eager save/restore of FP/SVE state.

From the looks of it, we're *still* adding protected-mode specialization
to save/restore the host's SVE state, even though we decided in commit
8383741ab2e7 ("KVM: arm64: Get rid of host SVE tracking/saving") that
this was completely unnecessary in non-protected configurations.

What I'm instead suggesting is that we make it part of the __kvm_vcpu_run() API
that the non-overlapping SVE state gets discarded by the callee, which
would align with an expectation that the host kernel has already done
this upon syscall entry.

Then all of the FPSIMD/SVE save/restore logic we have in the hyp 'just
works' so long as we 0 the SVE registers before loading in the host's
FPSIMD state.

-- 
Thanks,
Oliver
