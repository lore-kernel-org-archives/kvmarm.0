Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C11B1FAE
	for <kvmarm@lists.linux.dev>; Fri, 28 Oct 2022 10:23:42 +0000 (UTC)
Date: Fri, 28 Oct 2022 10:23:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1666952620;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L4OIthJifQ5swLs+ejUqtpsuyuxlkNQcRrSkG5lvVuU=;
	b=vxttRypFANLybcEOz+fXk4/ydf1CvcSqFUutaV/7xpJMPOb2OZ4PiEVY4zUSMWcHw26Zc5
	q/g+CCWNjfxFxRy+CYfZl/2OqGAJKnj/dmLyGDt2KiupdcXSq8PPC5suvcsqloVUhO2a+a
	wNmoPX+2gFxpD5fxvVbo4twcmTwuO0U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Redefine pKVM memory transitions in
 terms of source/target
Message-ID: <Y1utqG5f0lRrNwlI@google.com>
References: <20221028083448.1998389-1-oliver.upton@linux.dev>
 <20221028083448.1998389-3-oliver.upton@linux.dev>
 <Y1uncNq2oyc5wALG@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1uncNq2oyc5wALG@google.com>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221028102336.0HQuFVwn6iStmptKPOoSFyrGYFzuIrqof3dEDMb4bzs@z>

Quentin,

On Fri, Oct 28, 2022 at 09:57:04AM +0000, Quentin Perret wrote:
> Hey Oliver,
> 
> On Friday 28 Oct 2022 at 08:34:48 (+0000), Oliver Upton wrote:
> > Perhaps it is just me, but the 'initiator' and 'completer' terms are
> > slightly confusing descriptors for the addresses involved in a memory
> > transition. Apply a rename to instead describe memory transitions in
> > terms of a source and target address.
> 
> Just to provide some rationale for the initiator/completer terminology,
> the very first implementation we did of this used 'sender/recipient (or
> something along those lines I think), and we ended up confusing
> ourselves massively. The main issue is that memory doesn't necessarily
> 'flow' in the same direction as the transition. It's all fine for a
> donation or a share, but reclaim and unshare become funny. 'The
> recipient of an unshare' can be easily misunderstood, I think.
> 
> So yeah, we ended up with initiator/completer, which may not be the
> prettiest terminology, but it was useful to disambiguate things at
> least.

I see, thanks for the background :) If I've managed to re-ambiguate the
language here then LMK. Frankly, I'm more strongly motivated on the
first patch anyway.

--
Thanks,
Oliver
