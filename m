Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CE074412
	for <kvmarm@lists.linux.dev>; Wed, 28 Feb 2024 19:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709148699; cv=none; b=iaardhAUM3tkfMXSPjExNiGM7jWXYJX4ARKvfYcZN3aV55qDn8JHExMmYfkb/hpwrDqW994PaRaa7LItguhnZ1jKgmIiB+kMi8v4nkAy/jQlbKrP9x3i/GIZVH3Hb/7siB3fSOCrrkQQ4EUvBOYIVmbZfVMl6ycDRU+4/qj/EYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709148699; c=relaxed/simple;
	bh=hrMwNX6A7pJytyZojWuDHp1usR2rD85v/dl7KJ4hv/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aO83G8SKwAY8cxTAzUA79xN8PZOBtSy5vDmM9/pcxygqE/hsBrmUZpq75K35Ng/RXbm6rsX5jK3GBHHb/RBjesfakAQ/NGjTitQgC1f4czx14EpPgvRBt4oyycO8+Ih2RG14qHPXxYpI47/TNLEK6FM2X37AeS/jAOK9ivIcRqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lQ0PQv3C; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lQ0PQv3C"
Date: Wed, 28 Feb 2024 19:31:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709148694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YY4/fzheh6IWBCdc3jx9FxZv9kS1tZvedIm27FGVTag=;
	b=lQ0PQv3C7Y0qmKKxpkLpdcAFrT7ftMdGTh2dxVeJxqwPTxTH/gvFsOCSTjOzNMSYlKtJiA
	jE6DXyuK81w8xnauxok2rE9RLleY+3swb8LqdaXfv/J4kbZagyBFfWb0cv2c0Vm+gHmVcJ
	uJKN43yoz/UiJ5WKDC0DxGtD7FioB0Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 01/20] KVM: Treat the device list as an rculist
Message-ID: <Zd-KDOLB4J1qyfYJ@linux.dev>
References: <20240227224249.2209194-1-oliver.upton@linux.dev>
 <20240227224249.2209194-2-oliver.upton@linux.dev>
 <Zd9q5KbkLnh5Wddf@google.com>
 <Zd92fobEy4HFOb24@linux.dev>
 <Zd-F8F9OTehNoQiq@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd-F8F9OTehNoQiq@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 28, 2024 at 11:13:52AM -0800, Sean Christopherson wrote:
> I'm taking exception to the "Prepare by converting to an rculist." statement.
> This is not an RCU-protected list, it's a list that abuses rcu_list_add() and
> list_for_each_rcu() to allow readers to run concurrently with insertion.  E.g.
> IIUC, if it weren't for PROVE_RCU, the rcu_read_(un)lock() in the reader could
> be omitted and everything would work just fine.

Fair, if we wanted to be exact about it this change relies on the
pointer assignment properties of RCU, but not necessarily full-blown RCU
protection. But...

> Ah, but it's a moot point, because kvm_device_release() does delete from the list,
> and does not do so in an RCU-safe manner.  So that needs to be fixed, and then
> this is indeed an RCU-protected list.

Shows how much thought I threw at the problem :D Nice catch, I'll fold
in a fix next time around.

> > list_del() or list_del_rcu() will fail in an equally-miserable manner if
> > the previously stated expectation of readers is violated. Poisoning the
> > forward pointer would be nice from a debugging POV, but readers could
> > still hit a use-after-free.
> 
> My primary concern is not what happens on failure, I'm concerned about misleading
> readers by implying that this is a proper RCU-protected list.  But as above, that's
> a moot point.
> 
> As far as the failure mode, my preference is to poison the forward pointer.  It's
> not just debug friendly; hitting a fault (#GP on x86) is a "safer" failure mode
> than UAF, e.g. UAF could result in data corruption if the freed memory is
> re-allocated before the rogue write happens.

Same -- what I was getting at here is that the moment our house of cards
falls apart we cannot guarantee all readers have seen the poison
(instead of the stale ->next pointer), so failure patterns are not
predictable.

> > I feel like that borders on contempt for the reader.
> 
> IMO, RCU is one of the most difficult things to use _safely_.  (Ab)Using RCU in
> a way that _looks_ unsafe is setting people up to fail.

Fair enough. Coming along and saying "I know better, let's do X" is
equally (if not more) contemptuous :)

-- 
Thanks,
Oliver
