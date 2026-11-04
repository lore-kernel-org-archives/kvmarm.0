Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793815457;
	b=czOoizFupQyyRmNu4whY5QcyJdagE2qWMyc8peGLHj2y6O1BeHTz6W1hKvwhC5AOUcvC
	 fkwt7CVOyOrL6uf+SrrLzOXd1nt4bUikRud8dHFidtmdgS9jQkMflK7QHl4vZcyEvfmwS
	 CAjPsLdBeye8mwwTw4e8VCoGLJiME+a6ra6EVy1RuE+hC4BDAIUyeScVehmyL1Hgnq0BE
	 MPRoUS9dV8ZgPTWl+ZVuIhMYEKxrnvJeE39jbjFo0DlQPZLzPO+eI92cu0tth29G300ao
	 LNYY4aIDx4ffu4my11b9+TfYE73O78JyZBjqJwfB4ZKjQTCdkGTF2coYY7oA+gX0Uzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793815457;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Und4D4ow7DAvuQu9jjQ2COay1VB0KMeWjaIjSCk7WfE=;
	b=h50LmDURKwjW9X+G8wTwZOmGADw8atdjsjY5e9x/iXSDFR0jvhl572qS5C1Ow84ItHN5
	 TCKyAg8g/0F6oCzKp35v4RVScfzzpNeB7Xoi+zXA0iNRjM7ihxRrZ8TwcU1dduPnObgug
	 cXagl/fqAIiZNZxk3QXuVxHMX2FuyZvTwx1fVhPA5wOpOlUl+9zLevLXbs1AH4CaG526u
	 IjSM9tNm5KNs23lRBlQLpHIgarnuLfYL4CPkWv2WlKUoeCQwa5R74iSFEt22if20GxJbw
	 sxgnVS8A3Rjb9z2J4amv6IInbuQP9M7HYM9OnC1NsUzt1qutCyyLZ2o6tEFvHx6OU4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hpQN0bYp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB941606A33B
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 18:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hpQN0bYp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE131F000C1;
	Wed,  4 Nov 2026 18:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793815456;
	bh=Und4D4ow7DAvuQu9jjQ2COay1VB0KMeWjaIjSCk7WfE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hpQN0bYpwt4CXvj54kF2CsMJOs3bmK/IHGMDYhQZ+r6B/+/oWkBLxoP+kavOupU11
	 +AylIUz0xoUQfIkFUye4+KW7I5k1rxKpFF9xipsTqUrJVRsOYE79xpvMBMqzthUJL/
	 y/IhCVqg2GE7JeiYdVvkW0aGIMTRWr1o1XX+Yaym2umytW4WeCABKQ0ZpNeCQ1drCA
	 kWKg9bOUMBOkZbaU11FK5B4jrSfm3g9Go6WDqIxeQdqpPEgSqe7yCOExSUwqbhDmcY
	 9tXTLU31zt7IDq5eAfOFDE/k/A7aBxpO4am32Vg9cowz4hKzzvQdS+nMWp2VYfRKhH
	 m8r4cy1oGhwUg==
Date: Wed, 4 Nov 2026 10:04:14 -0800
From: Oliver Upton <oupton@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH v2 18/28] KVM: arm64: nv: Emulate CMOs via writable-clean
 translations as NOPs
Message-ID: <autzno1eEpw4X-0I@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org>
 <20261023205610.1044532-19-oupton@kernel.org>
 <autJUntFMhCoqZeH@LeoBrasDK>
 <autp0cVkXwvSXPGC@kernel.org>
 <autrOLZWT-s4Ailc@LeoBrasDK>
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
In-Reply-To: <autrOLZWT-s4Ailc@LeoBrasDK>

On Wed, Nov 04, 2026 at 05:28:24PM +0000, Leonardo Bras wrote:
> > The writable-clean state is nonexistent when VTCR_EL2.HD=0 in the direct
> > permission model. So we have no way to construct a translation in the
> > stage-2 that satisfies our requirements.
> 
> Since other vcpus will have VTCR_EL2.HD=0, couldn't we enable it just for 
> the sake of processing this CMO?
> 
> I guess it would need to either decode the instruction or single-step this 
> vcpu just to make sure it does not write to the same page we just did mark 
> WC.
> 
> > 
> > The other way to do this would likely involve halting all vCPUs in the
> > VM and attempting to single-step which has a near 100% chance of blowing
> > up in our face.
> 
> Sorry, why all vCPUs?
> 
> I know for all vCPUs it would be terrible for performance, what else 
> do you mean by "blowing up in our face"? 

In order to make this work, you need to guarantee that there's no
concurrent updates to either the instruction itself of the stage-1
translation.

The operations would be, approximately:

 - Take a stage-2 permission fault on the cache maintenance instruction.
   Walk the guest's stage-2 and find a translation in writable-clean
   state.

 - Pause the VM, re-enter the guest and single-step the instruction. If
   we take the debug exception then the guest must've changed the
   instruction. Go back to base state.

 - If we take another stage-2 permission fault for a cache maintenance
   instruction, temporarily promote the translation to RW in the shadow
   stage-2 and re-enter with single-step enabled.

 - Take the debug exception, invalidate the shadow stage-2 translation,
   disarm single-step, restart the VM.

The transient RW mappings seems ripe for pretty nasty bugs.

Thanks,
Oliver
