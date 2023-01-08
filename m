Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F268028F9;
	Sun,  8 Jan 2023 18:55:02 +0000 (UTC)
Date: Sun, 8 Jan 2023 10:54:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1673204094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4GStBHBtIG3HNcYtPXIN3DoEZyGgjZQviRxuFt95GoM=;
	b=X13ajs2XGrutReGcRqwlVGSU7/tqNFg1P9f23nK0lDUDSAiOeTw7qrF3ci84nm7YJOjcP4
	Ov+VVCmftGYQCtYqKR6LCRELb+P4AeaslGWvkp82IcAwl6v6rbLOW9juS3umMnEVqWC5iI
	p9mHX2vw+0sqF4w7wSYx73h1aRCDelo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>,
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	James Morse <james.morse@arm.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>, asahi@lists.linux.dev,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Sven Peter <sven@svenpeter.dev>, Hector Martin <marcan@marcan.st>
Subject: Re: [PATCH v5 6/7] KVM: arm64: Mask FEAT_CCIDX
Message-ID: <Y7sRdy13b4NoN/lH@thinky-boi>
References: <20221230095452.181764-1-akihiko.odaki@daynix.com>
 <20221230095452.181764-7-akihiko.odaki@daynix.com>
 <Y7dNihZMs4NSSw0v@google.com>
 <b47d77c6-0fb5-b11b-d98a-f85e1bbc5d38@daynix.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b47d77c6-0fb5-b11b-d98a-f85e1bbc5d38@daynix.com>
X-Migadu-Flow: FLOW_OUT

Akihiko,

On Sat, Jan 07, 2023 at 06:53:28PM +0900, Akihiko Odaki wrote:
> On 2023/01/06 7:22, Oliver Upton wrote:
> > On Fri, Dec 30, 2022 at 06:54:51PM +0900, Akihiko Odaki wrote:
> > > The CCSIDR access handler masks the associativity bits according to the
> > > bit layout for processors without FEAT_CCIDX. KVM also assumes CCSIDR is
> > > 32-bit where it will be 64-bit if FEAT_CCIDX is enabled. Mask FEAT_CCIDX
> > > so that these assumptions hold.
> > > 
> > > Suggested-by: Marc Zyngier <maz@kernel.org>
> > > Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> > 
> > FYI, I'm an idiot and replied to v4 of this patch... Forwarding comments
> > below:
> > 
> > > ---
> > >   arch/arm64/kvm/sys_regs.c | 11 +++++++++++
> > >   1 file changed, 11 insertions(+)
> > > 
> > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > index f4a7c5abcbca..aeabf1f3370b 100644
> > > --- a/arch/arm64/kvm/sys_regs.c
> > > +++ b/arch/arm64/kvm/sys_regs.c
> > > @@ -1124,6 +1124,12 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r
> > >   						      ID_DFR0_PERFMON_SHIFT,
> > >   						      kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_4 : 0);
> > >   		break;
> > > +	case SYS_ID_AA64MMFR2_EL1:
> > > +		val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
> > > +		break;
> > > +	case SYS_ID_MMFR4_EL1:
> > > +		val &= ~ARM64_FEATURE_MASK(ID_MMFR4_CCIDX);
> > > +		break;
> > 
> > Not that it is necessarily worth addressing, but I wanted to point
> > something out.
> > 
> > This change breaks migration from older kernels on implementations w/
> > FEAT_CCIDX. There is most likely exactly 0 of those in the wild, but
> > we need to be careful changing user-visible stuff like this.
> > 
> > --
> > Thanks,
> > Oliver
> 
> I also don't think whether FEAT_CCIDX is visible matters for any guest
> because the line size a guest would care is held in the same bits whether
> FEAT_CCIDX is implemented. But if it concerns you I can write a bit more
> code so that it won't mask CCIDX bit if it's set from the userspace.

The particular issue I'm alluding to is the fact that KVM treats the ID
registers as invariant. Userspace will save/restore the ID registers for
the VM as part of a migration. Existing kernels advertize FEAT_CCIDX,
whereas kernels with this patch will not. KVM will return an error
(EINVAL) when ID_AA64MMFR2_EL1 is written by userspace.

We've worked around this issue in the past by implementing set_user
calls for ID registers that have changed to tolerate the 'old' value
that KVM advertized.

In any case, it may not be worth addressing given that there are no
implementations in the wild with FEAT_CCIDX. But I wanted to bring it up
on the list for the sake of posterity and also allow anyone to scream
who might be adversely affected by the change.

--
Thanks,
Oliver
