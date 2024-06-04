Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C9514A0A2
	for <kvmarm@lists.linux.dev>; Tue,  4 Jun 2024 17:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717523068; cv=none; b=WBPphxM4agHQ0/W5jsDP4GfEoBXClgbf7F9pfyyrYNITf+e5sTJfCRXl8LRRX/9V32HFXG7FJ1KAt3e4pqcipj7KhQFWkHg3yKdPG7Zr97UzCDsi0tTO2Qi/fzulyLf3K/yGpRl2XAMXTuid2JWdEXNtYunkNdnnUg0c3152r/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717523068; c=relaxed/simple;
	bh=jM4mSqy+AI9HpHGZsruR5Kt2mKRgsssuL884tWH9nbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FuB8X0f/+y3CA7Agjb1rytmsPpzL5JK8W3Q3LTaYLBUqVe7kNIHvLOOE89bjvDguD8M+g6DJFBAgP/bupxYsUQogozQwj2M/KhIrc5pCl1kPj8QU49UeCnfSAuNza0mA4QzagT9Xd7C231Rw9E/ObyV8oQwmjk6i9rqqmnzKs8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=B4OW+KRt; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="B4OW+KRt"
X-Envelope-To: maz@kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717523063;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J14GhY9Slr22lIIhXHm2oSjBsS6w7JOeWjlZlqB2f1M=;
	b=B4OW+KRtg70XljWt9tcXev1W1QeHjbAA77gEKmB+BiW4/38q2QawKLTsaC/8eymMUpfRsh
	nQKsdVuGFiCM+qRUZLV85PCkFCwxcIinpaplbK+8WE8P0dGrpZA7wdeJklU7Z6Q7HjzYFC
	yD0tChAgx3W7ZTGLyM5sjMZrVOEjW40=
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
Date: Tue, 4 Jun 2024 17:44:18 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 10/11] KVM: arm64: nv: Honor guest hypervisor's FP/SVE
 traps in CPTR_EL2
Message-ID: <Zl9ScqvwNI9MEx3J@linux.dev>
References: <20240531231358.1000039-1-oliver.upton@linux.dev>
 <20240531231358.1000039-11-oliver.upton@linux.dev>
 <86le3mkxsp.wl-maz@kernel.org>
 <Zl39WCKpyaDmccgY@linux.dev>
 <86frttkli5.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86frttkli5.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 04, 2024 at 12:14:42PM +0100, Marc Zyngier wrote:
> On Mon, 03 Jun 2024 18:28:56 +0100, Oliver Upton <oliver.upton@linux.dev> wrote:
> > Anyway, my _slight_ preference is towards keeping what I have if
> > possible, with a giant comment explaining the reasoning behind it. But I
> > can take your approach instead too.
> 
> I think the only arguments for my own solution are:
> 
> - slightly better codegen (no function call or inlining), and a
>   smaller .text section in switch.o, because the helpers are not
>   cheap:
> 
>   LLVM:
> 
> 	0 .text         00003ef8 (guest_hyp_*_traps_enabled)
> 	0 .text         00003d48 (bit ops)
> 
>   GCC:
> 	0 .text         00002624 (guest_hyp_*_traps_enabled)
> 	0 .text         000024b4 (bit ops)
> 

Oh, that's spectacular :-)

>   Yes, LLVM is an absolute pig because of BTI...
> 
> - tracking the guest's bits more precisely may make it easier to debug
> 
> but these are pretty weak arguments, and I don't really care either
> way at this precise moment.

Yeah, so I think the right direction here is to combine our approaches,
and do direct bit manipulation, but only on bit[0]. That way we still
have an opportunity to document the very intentional simplification of
trap state too.

-- 
Thanks,
Oliver
