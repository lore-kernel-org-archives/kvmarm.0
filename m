Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5970125A9
	for <kvmarm@lists.linux.dev>; Tue, 11 Jun 2024 15:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718120867; cv=none; b=Q48o/mIJJAJeS9irf34qj2Q7FtQwNzpl1Oo79409bWXebI2kD3lHPUmDl30vfQeZidkSUWpR5+qm7rk8G3ppxL5GnEE5ZtTmdaVEOtcDNGnDuMqbaKlzFLyBI/hzH0OjPsq3uPGYX0TQJLA5lWUl9ZkVxggzvvdFzYbTGs2gV5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718120867; c=relaxed/simple;
	bh=q0+ki6HVOhwr0cIvbtw/FNbnVhJ42oKOYY1uJYOso1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=om96QQtOpFoYzR99fLTp+Y2Ysp7Mj7Gv/BOl9NY3AZaWvBhmiXVoxWiwZIHrABZKlMKinYK13xjeadH5RBRJy8N/6hLKIiOTs9brYfufNZXsFYiz+WMtUQwG/R2iIRaF3GmAlxXJkhrjXvLM+ivZ9sGnYnBT919dT/+kvZWn0Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8C28B113E;
	Tue, 11 Jun 2024 08:48:09 -0700 (PDT)
Received: from bogus (e103737-lin.cambridge.arm.com [10.1.197.49])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D8DD63F73B;
	Tue, 11 Jun 2024 08:47:43 -0700 (PDT)
Date: Tue, 11 Jun 2024 16:47:41 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, sebastianene@google.com,
	Sudeep Holla <sudeep.holla@arm.com>, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: FFA: Release hyp rx buffer
Message-ID: <ZmhxnbYCIufu-9XV@bogus>
References: <20240530131734.2724454-1-vdonnefort@google.com>
 <ZloIGlEuEiEy3_0v@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZloIGlEuEiEy3_0v@google.com>

On Fri, May 31, 2024 at 06:25:46PM +0100, Vincent Donnefort wrote:
> Hi Sudeep,
> 
> On Thu, May 30, 2024 at 02:17:34PM +0100, Vincent Donnefort wrote:
> > According to the FF-A spec (1.2 BET0 7.2.2.4.2), after a producer has
> > written into a buffer, it is "full" and now owned by the consumer until
> > it is read and "empty". This must be signaled by the consumer with the
> > RX_RELEASE invocation.
> > 
> > It is clear from the spec (7.2.2.4.2), that MEM_RETRIEVE_RESP is
> > transferring the ownership from producer (in our case SPM) to consumer
> > (hypervisor). We must then subsequently invoke RX_RELEASE to transfer
> > back the ownership (i.e. to let SPM mark the buffer as "empty").
> > 
> > It is less clear though what is happening with MEM_FRAG_TX. But this
> > invocation, as a response to MEM_FRAG_RX writes into the same hypervisor
> > RX buffer. Also this is matching the TF-A implementation where the RX
> > buffer is marked "full" during a MEM_FRAG_RX.
> 
> Perhaps a change is needed here in the FF-A spec? Not only it seems strange that
> there are no mention about MEM_FRAG_RX in the buffer ownership paragraph but
> also this seems strange to have to RX_RELEASE: If one invoke MEM_FRAG_RX, that's
> probably because the Rx buffer is ready to be read anyway?
>

Yes, it is kind of implicit.

Under section "Transmission of transaction descriptor in fragments"
subsection "Description", you can see the below statement(just to avoid spec
document version confusion)

"A Receiver must request the Sender to transmit the next fragment through an
invocation of the FFA_MEM_FRAG_RX ABI".

By that it means the receiver(e.g. SPM) has received the current fragment
sent by the sender via FFA_MEM_FRAG_TX(or specific mem API for first fragment)
and it is ready to receive the next when it invokes FFA_MEM_FRAG_RX.

If you think anything can be improved, happy to take it spec authors. I may
be missing to see something obvious.

--
Regards,
Sudeep
