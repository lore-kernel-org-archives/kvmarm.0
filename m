Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794419089;
	b=ow5y3hYbG0Mq05qOSmNLQcan9y0HbGZUwsoP00aVY5LZ/DVzMi0S/DHqeBWvY4B4WWoR
	 cU4egzzb6ooklC4JviiNflG+mq+/7DxpeYP6iIgYmUFD/TzBOdyw3+srp9+0fb773HfsN
	 beJZ7KljK9/0CMHnHpLa3eiL6HpmmksHazlG8tDCvdW0XBL+03i3X2HZ+lg4v/eEl/aHW
	 dv1z5Z1rOFTBuUkRVeU13rPcFhqZFMuscirydZdAxrzSt276pFY6nptNf6hhbiOAwxz4O
	 D7TsG8zkhSynd4pJ/kzBIiIJ5M4V4HhCR8nGcwO9Xj7IM8kEk5uVozPj8FrgvWsHoOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794419089;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Lg38hiBjDXw9cSHliNLU5G5GwmBdVZAwW1RU9LwK+4w=;
	b=AgN41vT5DvPvucU2lWaAzlvaFxT1Z75Z/IYNRGtrfYMDap+ZpR+nh/dfXP0ZKkCQIdGo
	 4IvCqReEKnAZVlJDp/xcHdDZQOAoRW/Z9mLI7Dtf5hc68TPmOVy12TbHQUQoXsiG2Ht4+
	 plFQrp2s6HKwZ+maDt0l4k2EAFBNlr0yAJ/YNqkDuakg6Htm1VV2vuTMQvlKSl3I4CZWW
	 lnqb3bTDr2ufUc3QZ6VP3yb+ngScCxYjlOo7vIH9Xz2u/DTq9GFWovM5WZXhlCO5AqOKV
	 86KVGghl9kcbyNPOuRUlRV2ezmTtkys+tEn/QKhQ7rud5vNlUuNv9gVOVvnMM1DrM2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aYsNj+Jj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A99606A326;
	Wed, 11 Nov 2026 17:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aYsNj+Jj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0F61F00A05;
	Wed, 11 Nov 2026 17:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794419089;
	bh=Lg38hiBjDXw9cSHliNLU5G5GwmBdVZAwW1RU9LwK+4w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aYsNj+JjgNOG/AX25zAAGt2RliUQSf76sv5AsNjNO1u/LByCnXQg19OCButP+nN+L
	 2zFXvTe6prgut3foVwuXfZs2xfSptIk7wI92j8dQmtsqfyEJRsBvFMWbOD4RPnMpaV
	 WNHqkEh/XbLnB5pBb/G6pDjSktZAka5wOlmHItQ8YK+mxmtw1BTllMhFomoSfYKotW
	 woD4H7rHXd3hTGYsaiQB4ELEVeSx6z+IgOquJnfR8pT9NnlVpPFXrekXY53aBev0aJ
	 FQdENxc9+JVgax638KjqDUH4UV/TolKmzVK5KyIsfqVtckoPkifyhnLoZlIPKqATud
	 qfZlrleX+BcwA==
Date: Wed, 11 Nov 2026 17:44:43 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, maz@kernel.org, oupton@kernel.org, 
	suzuki.poulose@arm.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	david@kernel.org, mark.rutland@arm.com, ackerleytng@google.com
Subject: Re: [PATCH v2] KVM: Ignore MMU notifiers for guest_memfd-only
 memslots
Message-ID: <avSpIZXjqXZbpUIi@gremlin>
References: <20260714160411.302386-1-alexandru.elisei@arm.com>
 <amPCdAswlk24Xilf@google.com>
 <anxAGkdyPYXBlS00@raptor>
 <autwsR83Ii-tRrqF@gremlin>
 <auzSxEsGAcm3MYtN@google.com>
 <avSn-IW8DMybO-Tg@seanjc-mac.roam.internal>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avSn-IW8DMybO-Tg@seanjc-mac.roam.internal>

On Wed, Nov 11, 2026 at 09:38:00AM -0800, Sean Christopherson wrote:
> On Thu, Nov 05, 2026, Sean Christopherson wrote:
> > On Wed, Nov 04, 2026, Lorenzo Stoakes (ARM) wrote:
> > > [updated David's email address to @kernel.org]
> > >
> > > On Wed, Aug 12, 2026 at 10:42:50AM +0100, Alexandru Elisei wrote:
> > > [ ... ]
> > > > On Fri, Jul 24, 2026 at 12:52:20PM -0700, Sean Christopherson wrote:
> > > > > It'll probably take me a few weeks to circle back to this, as I finally crawled
> > > > > out from underneath a pile of urgent and am just now getting back into review
> > > > > mode, but this is fairly high on my todo list, so with luck we might still squeeze
> > > > > this into 7.3.
> > >
> > > Hey Sean,
> > >
> > > I wondered whether you'd had a chance to look at this?
> > >
> > > After discussing this with Marc and Alex it is clear that this is really a
> > > blocker for Alex's SPE series, as we need a sensible means of ensuring
> > > that stage-2 mappings stay in place.
> > >
> > > So ideally would prefer to get something like this in in the next cycle,
> > > if you don't have any objections to it? :)
> > >
> > > If it'd be easier, I think a smaller version of the same patch would also
> > > give us what we need? I.e. your snippet from June with the page ageing part
> > > dropped, as below.
> >
> > The GPC invalidation fix landed, so we can go straight to the super simple v1.
> > Compile tested only at this point, I'll formally post this (hopefully today),
> > assuming nothing explodes in testing.
>
> /facepalm
>
> I spaced on sending this (and I think on testing it too...).  I'll try to get it
> posted in the next few days.

Thanks :) and understandable, the AI wave is making the mailing list
quite... an interesting place to be lately!

--
Cheers, Lorenzo
