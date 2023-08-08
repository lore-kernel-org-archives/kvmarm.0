Received: from out-117.mta1.migadu.com (out-117.mta1.migadu.com [95.215.58.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DC814A88
	for <kvmarm@lists.linux.dev>; Tue,  8 Aug 2023 17:03:01 +0000 (UTC)
Date: Tue, 8 Aug 2023 17:02:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1691514179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BnRIeeXwdzMlgL7F+jbPI9mR9l8NZ8evsBZQnJMMlI0=;
	b=lsaCbpgive06ISvMWopxU9mCkabxLZFFooclVgmXpzOe7YiLUanXzqsW+HHVph4r+qqk6v
	V/WKfDvqn2JvUL/hYSxVsvIwmjJnGm1+OgWWy3j+2BLrLVV5wzfn5hb8qlTIociKTZmNGw
	jITEvjw8F0Sgrhfl/koOnV90117d6V0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Cornelia Huck <cohuck@redhat.com>
Cc: Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
	KVMARM <kvmarm@lists.linux.dev>,
	ARMLinux <linux-arm-kernel@lists.infradead.org>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Suraj Jitindar Singh <surajjs@amazon.com>
Subject: Re: [PATCH v7 01/10] KVM: arm64: Allow userspace to get the writable
 masks for feature ID registers
Message-ID: <ZNJ1PQQ4WZjyJhU7@linux.dev>
References: <20230801152007.337272-1-jingzhangos@google.com>
 <20230801152007.337272-2-jingzhangos@google.com>
 <ZMmdnou5Pk/9V1Gs@linux.dev>
 <CAAdAUtj-6tk53TE6p0TYBfmFghj94g+Sg2KK_80Gar18kJ=5OA@mail.gmail.com>
 <ZMqMofRCmB14XUZr@linux.dev>
 <877cqc8dp2.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877cqc8dp2.fsf@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Aug 03, 2023 at 03:20:41PM +0200, Cornelia Huck wrote:
> On Wed, Aug 02 2023, Oliver Upton <oliver.upton@linux.dev> wrote:
> > Sorry, 'index' is a bit overloaded in this context. The point I was
> > trying to get across is that we might want to describe a completely
> > different range of registers than the feature ID registers in the
> > future. Nonetheless, we shouldn't even presume the shape of future
> > extensions to the ioctl.
> >
> > 	struct reg_mask_range {
> > 		__u64 addr;	/* pointer to mask array */
> > 		__u64 rsvd[7];
> > 	};
> >
> > Then in KVM we should require ::rsvd be zero and fail the ioctl
> > otherwise.
> 
> [I assume rsvd == reserved? I think I have tried to divine further
> meaning into this for far too long...]

Indeed.

> Is the idea here for userspace the request a mask array for FEATURE_ID
> and future ranges separately instead of getting all id-type regs in one
> go?

I rambled a bit, but the overall suggestion is that we leave room in the
UAPI for future extension. Asserting that the reserved portions of the
structure must be zero is the easiest way to accomplish that. The
complete feature ID register space is known, but maybe there are other
ranges of registers (possibly unrelated to ID) that we'd like to
similarly describe with masks.

-- 
Thanks,
Oliver
