Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C4CF3B2A2
	for <kvmarm@lists.linux.dev>; Tue, 11 Jun 2024 16:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718122633; cv=none; b=jOmjnBc9CohwnpC64f+Yd05LeBvGke/L30kxbKF2dsO3OBP50Ph3O2iAl17WyW3de+lW5z6U64pUyNPZxypjSr+9jnP556QAlebVdjMVqnwrImI0CBYEibMQUyqSATMSTeVZvWGkoyUMVhGUw/oN85xyKO6TfnG+OYL1ZQ9NBwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718122633; c=relaxed/simple;
	bh=fV7wrZ3sNGHiI+zKDe7q9N9IJZ6mb99iChQJgVB63Cc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qvZi+y/l4bZ3oAlaiFGUErGHQddwjHpCvTTTLICOhbwZggTcQ/2mYvMBAsBduemQlnYFNN4pP8e1aNUd4e75Q0Q2t94jEjdu4Uw0TExuiUvOjitwB2BtwHUjk59usB0FJyeLhGE+RArDJ1DUtpZRLBU5GReuuat5m5qNnzNZ+s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C62811595;
	Tue, 11 Jun 2024 09:17:34 -0700 (PDT)
Received: from bogus (e103737-lin.cambridge.arm.com [10.1.197.49])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1DBDF3F73B;
	Tue, 11 Jun 2024 09:17:09 -0700 (PDT)
Date: Tue, 11 Jun 2024 17:17:06 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: Vincent Donnefort <vdonnefort@google.com>, maz@kernel.org,
	Sudeep Holla <sudeep.holla@arm.com>, oliver.upton@linux.dev,
	will@kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: FFA: Release hyp rx buffer
Message-ID: <Zmh4gmBi7cu5czkn@bogus>
References: <20240530131734.2724454-1-vdonnefort@google.com>
 <ZmhXngA1lYfYoz72@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmhXngA1lYfYoz72@google.com>

On Tue, Jun 11, 2024 at 01:56:46PM +0000, Sebastian Ene wrote:
> On Thu, May 30, 2024 at 02:17:34PM +0100, Vincent Donnefort wrote:
>
> Hello Vincent,
>
> > According to the FF-A spec (1.2 BET0 7.2.2.4.2), after a producer has

I prefer to drop all these section and spec version details as it may be
stale info in few months time. Better to just refer the section by name
if you are referring non release versions of the document.

> > written into a buffer, it is "full" and now owned by the consumer until
> > it is read and "empty". This must be signaled by the consumer with the
> > RX_RELEASE invocation.
>
> I agree the spec is a bit unclear in the ownership transfer of the buffer:
> - it mentions that the producer owns it when it is empty (I think it is
>   a separate state the ownership transfer than being "full"). Some FF-A

I think above statement might add more confusion than clarity IMO.

>   ABIs do the ownership transfer when they are invoked, but not all of
>   them and this is why we need calls like RX_RELEASE, to signal the
>   availability of the buffer and to transfer the ownership from the
>   Consumer to the Producer. Can we add this explanation as part of the
>   commit message to justify why we need this ?
>

This part looks good and can be added. But IMO, not a must, I am fine
either way.

Sorry I don't know how else to improve the commit message.

> I think it is also worth mentioning that this is how TF-A (Trusted
> Firmware) deals with the ownership transfer of the buffer.
>
> >
> > It is clear from the spec (7.2.2.4.2), that MEM_RETRIEVE_RESP is
> > transferring the ownership from producer (in our case SPM) to consumer
> > (hypervisor). We must then subsequently invoke RX_RELEASE to transfer
> > back the ownership (i.e. to let SPM mark the buffer as "empty").
> >

This section clarifies the need for this patch IMO. So I am fine with it
as along as the above info is present.

> > It is less clear though what is happening with MEM_FRAG_TX. But this
> > invocation, as a response to MEM_FRAG_RX writes into the same hypervisor
> > RX buffer. Also this is matching the TF-A implementation where the RX
> > buffer is marked "full" during a MEM_FRAG_RX.
> >

I have responded to this separately, hope that makes sense. You can even
drop this section. I am fine either way.

> > Release the RX hypervisor buffer in those two cases. This will unblock
> > later invocations using this buffer which would otherwise fail.
> > (RETRIEVE_REQ, MEM_FRAG_RX and PARTITION_INFO_GET).
> >
>

The change itself looks good to me.

Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>

--
Regards,
Sudeep
