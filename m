Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B9586249
	for <kvmarm@lists.linux.dev>; Wed, 28 Feb 2024 21:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709154480; cv=none; b=Yx9RJYZC3bdPsS1ClFt3eR5hIcIxb0UQguEagF3xuN2lUYcAsrhm6Ptx4ID20nAFxwfptzdDN91I3+uxpzPmjgXjKzl0x0x6QTbIz154nTYURCXklV1GzhaWtPvBsQcCX+omiW1NvDj3qlau8zNQmLS1pGW/pNwiInRQM9HKTpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709154480; c=relaxed/simple;
	bh=+VuYqMA4ysyQEE9bOcxGbYQyl4XcKJ99xA9lO59ovYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t231edNJnFJlulb1JqX2qRtegyW1ypg8HuRDq4ISXrnGY9z1W8CwGwMB8YVaH6R5OwzzrYTkqmjbCBIDFr7MiJEPsBRUHoLEQtempGNMfYKKsAXwQat7vexcGh7+gBwAKvEs7uODpG85BaGc+lrBiroZ4McBFWeoyBxSOKnq59I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Q/FxPMFI; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Q/FxPMFI"
Date: Wed, 28 Feb 2024 21:07:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709154475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WfAYpCGli5RcVr4bIK9AcC0ySdJoYFL6QliNOicVlxs=;
	b=Q/FxPMFIIcJfc7A91mbgOssGbUsPhYp8NNqM7tDmP/Hy/mSazbMtFSNN2YQM7ZD9g/XV3O
	MrCfEtir5746Vad4Qw7Iw7ZiGMiTZejJXp9fOUZWE7rBiJ4qiDxZ7opfLkna6vH6pGmuVd
	Y04dZVpOMbLAet7QSd9zf75VAO7CzdI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH 01/20] KVM: Treat the device list as an rculist
Message-ID: <Zd-gpo4nADOFt4wA@linux.dev>
References: <20240227224249.2209194-1-oliver.upton@linux.dev>
 <20240227224249.2209194-2-oliver.upton@linux.dev>
 <Zd9q5KbkLnh5Wddf@google.com>
 <Zd92fobEy4HFOb24@linux.dev>
 <Zd-F8F9OTehNoQiq@google.com>
 <Zd-KDOLB4J1qyfYJ@linux.dev>
 <CABgObfa7WpDayTg2xopH4VSrNWZ0RdtiHF2muytqnK5EM3u6VA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfa7WpDayTg2xopH4VSrNWZ0RdtiHF2muytqnK5EM3u6VA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 28, 2024 at 09:23:38PM +0100, Paolo Bonzini wrote:
> On Wed, Feb 28, 2024 at 8:31 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > On Wed, Feb 28, 2024 at 11:13:52AM -0800, Sean Christopherson wrote:
> > > I'm taking exception to the "Prepare by converting to an rculist." statement.
> > > This is not an RCU-protected list, it's a list that abuses rcu_list_add() and
> > > list_for_each_rcu() to allow readers to run concurrently with insertion.  E.g.
> > > IIUC, if it weren't for PROVE_RCU, the rcu_read_(un)lock() in the reader could
> > > be omitted and everything would work just fine.
> >
> > Fair, if we wanted to be exact about it this change relies on the
> > pointer assignment properties of RCU, but not necessarily full-blown RCU
> > protection. But...
> >
> > > Ah, but it's a moot point, because kvm_device_release() does delete from the list,
> > > and does not do so in an RCU-safe manner.  So that needs to be fixed, and then
> > > this is indeed an RCU-protected list.
> >
> > Shows how much thought I threw at the problem :D Nice catch, I'll fold
> > in a fix next time around.
> 
> You also need to adjust the error case of kvm_ioctl_create_device()
> (not a thorough review, I did).
> 
> Also double check that it's okay for your concurrent reader to find
> the device while ops->init runs (or, better, ensure that it only does
> what it has to do after ops->init is finished, with the appropriate
> store-release/load-acquire operations on the two sides).

The reader on the GIC side of things is protected against this by
construction (no ->init() op), but I'd expect the reader & device to
establish their own ordering / synchronization for the relevant data.
Feel like the generic code is only responsible for protecting the
structure of the liest.

TBH, the issue I was working around isn't lock serialization
but rather lock ordering (I need to get at this while holding the
vcpu->mutex). Zero performance expectations for the reader I added over
in the vgic side of things.

So, with that in mind, I'm equally satisfied doing the less-complicated
thing of protecting the structure of the list with its own lock.

-- 
Thanks,
Oliver
