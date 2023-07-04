Received: from out-56.mta1.migadu.com (out-56.mta1.migadu.com [95.215.58.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFBC63C1
	for <kvmarm@lists.linux.dev>; Tue,  4 Jul 2023 16:04:01 +0000 (UTC)
Date: Tue, 4 Jul 2023 09:04:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1688486639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xg1CxT90wNmSWa/vx8SW5k6nUJUgbxG4tgKxda7745o=;
	b=uaRPw79dm4tUwP/VcgTH/hskZNj+VzcQJ36RKXDXu0TGH2w7ty2bSyzUxwCF/MEH22YRL7
	l8Wjxr9kN+IOFC1wPh7SbH0PJiTzddIGLKylgFpABhbXVZ6ot1UsqNrRfBhmyc3v2pUPSh
	VyxXFHDBJClzHSI1N8Ie+KOtCG/u80Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Cornelia Huck <cohuck@redhat.com>
Cc: Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
	KVMARM <kvmarm@lists.linux.dev>,
	ARMLinux <linux-arm-kernel@lists.infradead.org>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@google.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Suraj Jitindar Singh <surajjs@amazon.com>
Subject: Re: [PATCH v4 1/4] KVM: arm64: Enable writable for ID_AA64DFR0_EL1
Message-ID: <ZKRC80hb4hXwW8WK@thinky-boi>
References: <20230607194554.87359-1-jingzhangos@google.com>
 <20230607194554.87359-2-jingzhangos@google.com>
 <ZJm+Kj0C5YySp055@linux.dev>
 <874jmjiumh.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874jmjiumh.fsf@redhat.com>
X-Migadu-Flow: FLOW_OUT

Hi Cornelia,

On Tue, Jul 04, 2023 at 05:06:30PM +0200, Cornelia Huck wrote:
> On Mon, Jun 26 2023, Oliver Upton <oliver.upton@linux.dev> wrote:
> 
> > On Wed, Jun 07, 2023 at 07:45:51PM +0000, Jing Zhang wrote:
> >> +	brps = FIELD_GET(ID_AA64DFR0_EL1_BRPs_MASK, val);
> >> +	ctx_cmps = FIELD_GET(ID_AA64DFR0_EL1_CTX_CMPs_MASK, val);
> >> +	if (ctx_cmps > brps)
> >> +		return -EINVAL;
> >> +
> >
> > I'm not fully convinced on the need to do this sort of cross-field
> > validation... I think it is probably more trouble than it is worth. If
> > userspace writes something illogical to the register, oh well. All we
> > should care about is that the advertised feature set is a subset of
> > what's supported by the host.
> >
> > The series doesn't even do complete sanity checking, and instead works
> > on a few cherry-picked examples. AA64PFR0.EL{0-3} would also require
> > special handling depending on how pedantic you're feeling. AArch32
> > support at a higher exception level implies AArch32 support at all lower
> > exception levels.
> >
> > But that isn't a suggestion to implement it, more of a suggestion to
> > just avoid the problem as a whole.
> 
> Generally speaking, how much effort do we want to invest to prevent
> userspace from doing dumb things? "Make sure we advertise a subset of
> features of what the host supports" and "disallow writing values that
> are not allowed by the architecture in the first place" seem reasonable,
> but if userspace wants to create weird frankencpus[1], should it be
> allowed to break the guest and get to keep the pieces?

What I'm specifically objecting to is having KVM do sanity checks across
multiple fields. That requires explicit, per-field plumbing that will
eventually become a tangled mess that Marc and I will have to maintain.
The context-aware breakpoints is one example, as is ensuring SVE is
exposed iff FP is too. In all likelihood we'll either get some part of
this wrong, or miss a required check altogether.

Modulo a few exceptions to this case, I think per-field validation is
going to cover almost everything we're worried about, and we get that
largely for free from arm64_check_features().

> I'd be more in favour to rely on userspace to configure something that
> is actually usable; it needs to sanitize any user-provided configuration
> anyway.

Just want to make sure I understand your sentiment here, you'd be in
favor of the more robust sanitization?

> [1] I think userspace will end up creating frankencpus in any case, but
> at least it should be the kind that doesn't look out of place in the
> subway if you dress it in proper clothing.

I mean, KVM already advertises a frankencpu in the first place, so we're
off to a good start :)

--
Thanks,
Oliver
