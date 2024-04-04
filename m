Received: from toucan.tulip.relay.mailchannels.net (toucan.tulip.relay.mailchannels.net [23.83.218.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4038D82D90
	for <kvmarm@lists.linux.dev>; Thu,  4 Apr 2024 22:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.254
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712268424; cv=pass; b=eHpACbvVtqFJrBhSVkryzmW5BcyS58+Uw6LGMyxuK3e8vAVuVDYGjQBlxHVyH/SPy1acDIE/QjpOcaYX3nfp6eofVjWn/Z9MVOn0/qIFCcDSYdO2+dzyQSSfwkIOoqQikdm6oFS2tMfx7MVt/Xo11+Didd1N9SfKZMwnH3bbMjQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712268424; c=relaxed/simple;
	bh=M6DIshYVJQR0DO4VUKuLo4E19fWk1vmFQ2Kk6iCE5tk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k21WshQJX/+sGeIZCrXujx/2hM/1+wTN80J4BXoQhOlL9dHBBIbF0XXkRUCuo3fGBfmRUgr6XhcUT+bF4u22Q8+WUluSc6eXTwJmEGf7LQCoY3CPQSXb3rEg47isCSvI7+Hk0cMne9AAwR3ZrhdzWjtaQQCQmr6LyKb6zrYcbYo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com; spf=pass smtp.mailfrom=templeofstupid.com; dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b=LMIK8Xyl; arc=pass smtp.client-ip=23.83.218.254
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b="LMIK8Xyl"
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 85637801143
	for <kvmarm@lists.linux.dev>; Thu,  4 Apr 2024 21:41:58 +0000 (UTC)
Received: from pdx1-sub0-mail-a264.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id F03E1801075
	for <kvmarm@lists.linux.dev>; Thu,  4 Apr 2024 21:41:57 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1712266918; a=rsa-sha256;
	cv=none;
	b=vDvpixj1pgm0wmEFxEbQ3+uT8++B5c0FhMLmdK6etY5lmpz1Jt7I4v8Lw9pnQZBC9Fj1b7
	VdN+TP2hFhVjy5w4vPC6QfF4EG+IvwJg6qFjqFJqwIZ/s7S9ZVwFTr28fn2dkKvtpkF4KP
	WAsjEAIMe7gOZ2ToF0kse4OgzdD2x5HnYcZEtEkyuxQ6wBEAUwTb9gAfRC/nPXSjb1zQUY
	4W3qKZ8GyWtRt4pdd/MZuqzU8J3nnDVHj+mNvIXZ1OePQMBEL6hISjKBe/IdNPv0uYe2YD
	5cBWFkCCfAloK07eN4YH2umElrMckeulg/2JCS58wo/3cAAab7YKnsYK4qr4GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1712266918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oiU215bQMRqMD25CrXr9YpvEHYCDhTpFJaAfQebstxE=;
	b=nY0DjQdHDclxMtwSxuZQGF4xWborKIMbnHnjxy1o2bdyWgXitePHENmB/qW68b2mx7jMs1
	vgeLICaeiBH4Zw+dV1u7vG745NEUjsSlRPd3FCTdsnZwlVlaxq4tnMBDxqRPALyFb+DDlI
	gKMUX4av4RbHpuAR4aFPoyS91+i+kbjKpQ3f5wlZyaWCXQmegMHsl6ZzAwymNgw9nTQxsS
	fwCNK65UaCAZtVFHheXJqWA0M/in4Su8iP+TsDM7w5bUgBbFqenq690g3IBxaeMQ95J8TY
	JJU+rcnLTsV2UYo+LRwyTLA1vczusz5uSKYqlRfRuvxKk/CtkEt9BpIP5YuwVw==
ARC-Authentication-Results: i=1;
	rspamd-687b9dd446-qv82j;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=kjlx@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Desert-Cooperative: 7194710d76c7d3cf_1712266918381_2700242363
X-MC-Loop-Signature: 1712266918381:2520276560
X-MC-Ingress-Time: 1712266918381
Received: from pdx1-sub0-mail-a264.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.112.72.244 (trex/6.9.2);
	Thu, 04 Apr 2024 21:41:58 +0000
Received: from kmjvbox.templeofstupid.com (c-73-222-159-162.hsd1.ca.comcast.net [73.222.159.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a264.dreamhost.com (Postfix) with ESMTPSA id 4V9Znx2P4bzgY
	for <kvmarm@lists.linux.dev>; Thu,  4 Apr 2024 14:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1712266917;
	bh=oiU215bQMRqMD25CrXr9YpvEHYCDhTpFJaAfQebstxE=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=LMIK8Xyl6bHblGCtjWTDQm/b66eFVU/mhAWcAHTczX+sQgZ1d/KhhBYxz6YF+Nkl4
	 M1dGy/oyIWRXRI7sABKox7pd2poOj0ID/nTA94ZDsFKHdc1NMncUVSndihX3qhEnRz
	 sBnj9sIc/4MY3YVzcKHf62ucff/Y9coWWktaClQ2viyYp+AkHBdZArpAkWE5enIHK1
	 pOG4qmGndYS0AmrVyjSrQfqcSPJN0KJoQpKGBzS6m2rskWbGPFKH6EFkH9XKsFoSge
	 2WfajbRLfnG+l4pvGsQQT84OSRQgExQoNe5DHzQ6qPeQUscrC9wGcpCYUHM+lsrFZ7
	 X9KWR0A5TFUHQ==
Received: from johansen (uid 1000)
	(envelope-from kjlx@templeofstupid.com)
	id e0103
	by kmjvbox.templeofstupid.com (DragonFly Mail Agent v0.12);
	Thu, 04 Apr 2024 14:41:56 -0700
Date: Thu, 4 Apr 2024 14:41:56 -0700
From: Krister Johansen <kjlx@templeofstupid.com>
To: Ali Saidi <alisaidi@amazon.com>
Cc: catalin.marinas@arm.com, james.morse@arm.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	maz@kernel.org, me@davidreaver.com, oliver.upton@linux.dev,
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com
Subject: Re: [PATCH] KVM: arm64: Limit stage2_apply_range() batch size to
 smallest block
Message-ID: <20240404214156.GF2178@templeofstupid.com>
References: <20240404044028.GA1976@templeofstupid.com>
 <20240404212742.11248-1-alisaidi@amazon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240404212742.11248-1-alisaidi@amazon.com>

On Thu, Apr 04, 2024 at 09:27:42PM +0000, Ali Saidi wrote:
> > Just a quick followup that I did test Will's patches and didn't find
> > that it changed the performance of the workload that I'd been testing.
> > IOW, I wasn't able to discern a network performance difference between
> > the baseline and those changes.
> 
> That is a bit unexpected that the performance wasn't worse with the patch Will
> sent because it should have disabled the range invalidates since they these 
> invalidates will be getting rid of blocks?  Which Graviton were you testing
> this on? 

Sorry I didn't mention it earlier.  This was on a Graviton 4 with
FEAT_TLBIRANGE.  Due to the placement of the test machine and the client
the max single flow rate was 5Gbps, and with both the baseline and
Will's patches I wasn't able to discern any slowdown there, at least in
terms of impact to the adjacent networking traffic.  I saw an approx 1%
slowdown with multiple flows at 10Gbps, but didn't have a baseline for
that test case so was hesitant to offer it as conclusive.  I should be
clear that I _wasn't_ measuring the the teardown times in this test
-- just how the teardown itself impacted the networking performance.

-K
