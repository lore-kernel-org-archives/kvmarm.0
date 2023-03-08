Received: from out-38.mta0.migadu.com (out-38.mta0.migadu.com [91.218.175.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576B37B
	for <kvmarm@lists.linux.dev>; Wed,  8 Mar 2023 07:46:07 +0000 (UTC)
Date: Wed, 8 Mar 2023 07:46:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1678261565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WKzyZZ5TvHHv+nFcORL1XTaFGVCC5mIp3QEkslOGjpM=;
	b=pecnibry7D0AwevOwIcO8UrAJTSKX40E+DlEkvW+GKrHUO3XhEWYK89YgKhyyDma0I3nlW
	+8aMPyy+tAec1ZV/rmxDkbLBB36GwHf2BGoHVGo2SjoNI/TWgors07Tv1PU/Zit5+xS3ux
	rQpO1uuv/KwLWBboGjF3wDl7r2NSC5U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ricardo Koller <ricarkol@google.com>,
	Simon Veith <sveith@amazon.de>, dwmw2@infradead.org
Subject: Re: [PATCH 08/16] KVM: arm64: timers: Allow userspace to set the
 counter offsets
Message-ID: <ZAg9ONoYhUoa0mH9@linux.dev>
References: <20230216142123.2638675-1-maz@kernel.org>
 <20230216142123.2638675-9-maz@kernel.org>
 <Y+6pqz3pCwu7izZL@linux.dev>
 <86k00gy4so.wl-maz@kernel.org>
 <Y+/7mO1sxH4jThmu@linux.dev>
 <86bkllyku2.wl-maz@kernel.org>
 <Y/ZEGHkw5Jft19RP@linux.dev>
 <867cw8xmq2.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <867cw8xmq2.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey Marc,

On Thu, Feb 23, 2023 at 06:25:57PM +0000, Marc Zyngier wrote:

[...]

> > Do we need to bend over backwards for a theoretical use case with
> > the new UAPI? If anyone depends on the existing behavior then they can
> > continue to use the old UAPI to partially migrate the guest counters.
> 
> I don't buy the old/new thing. My take is that these things should be
> cumulative if there isn't a hard reason to break the existing API.

Unsurprisingly, I may have been a bit confusing in my replies to you.

I have zero interest in breaking the existing API. Any suggestion of
'changing the rules' was more along the lines of providing an alternate
scheme for the counters and letting the quirks of the old interface
continue.

> > My previous suggestion of tying the physical and virtual counters
> > together at VM creation would definitely break such a use case, though,
> > so we'd be at the point of requiring explicit opt-in from userspace.
> 
> I'm trying to find a middle ground, so bear with me. Here's the
> situation as I see it:
> 
> (1) a VM that is migrating today can only set the virtual offset and
>     doesn't affect the physical counter. This behaviour must be
>     preserved in we cannot prove that nobody relies on it.
> 
> (2) setting the physical offset could be done by two means:
> 
>     (a) writing the counter register (like we do for CNTVCT)
>     (b) providing an offset via a side channel
> 
> I think (1) must stay forever, just like we still support the old
> GICv2 implicit initialisation.

No argument here. Unless userspace pokes some new bit of UAPI, the old
behavior of CNTVCT must live on.

> (2a) is also desirable as it requires no extra work on the VMM side.
> Just restore the damn thing, and nothing changes (we're finally able
> to migrate the physical timer). (2b) really is icing on the cake.
> 
> The question is whether we can come up with an API offering (2b) that
> still allows (1) and (2a). I'd be happy with a new API that, when
> used, resets both offsets to the same value, matching your pretty
> picture. But the dual offsetting still has to exist internally.
> 
> When it comes to NV, it uses either the physical offset that has been
> provided by writing CNTPCT, or the one that has been written via the
> new API. Under the hood, this is the same piece of data, of course.
> 
> The only meaningful difference with my initial proposal is that there
> is no new virtual offset API. It is either register writes that obey
> the same rules as before, or a single offset setting.

I certainly agree that (2a) is highly desirable to get existing VMMs to
'do the right thing' for free. Playing devil's advocate, would this not
also break the tracing example you've given of correlating timestamps
between the host and guest? I wouldn't expect a userspace + VM tracing
contraption to live migrate but restoring from a snapshot seems
plausible.

Regardless, I like the general direction you've proposed. IIUC, you'll
want to go ahead with ignoring writes to CNT{P,V}CT if the offset was
written by userspace, right?

-- 
Thanks,
Oliver
