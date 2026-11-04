Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793812947;
	b=xsEJJFkn2Iq4zdj+ccSiTYsE+GoGfHRzuPBuzpJZeDhKlSFv4OouFcU5O5BeFzOfcMNo
	 t6a0DIZBmmat4UYpACqNns7BhQDVCvyBEv+l1cdZdYCBP53Ctojb73heDZVb1tqgVOadF
	 PFMO5JPe37NUZMOKtlmkvgO0m9O5k0SV4703x5JEuS3iavq/hO67dYCgzI9gouAmwxOSV
	 BXpdc9wqdJgkR+ChVHgbkEqrNz1ZImlyjVeS/dZqVjnwqPD2jaG5+7LDEveRx7lX6MBJJ
	 dGevg93Zx7ebfoileB1oXfTSkjwPZy2rsxALTISzu6bdj75pCi4Eil52o37vmgjvW/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793812947;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=1mzE91UiZbJ0OwSDAQ4zCNTem1xCHCHlFCTGXkp+0aM=;
	b=0mSAOxMp3t1ha5rwca1sN9iHpmOdxeTEYJ7cicF8JlEq2Q+OZhRnVSSSG7e1rt9S9brj
	 aiJzZ0AVStg6jzYixEI9yN+qUlx2uM8OkvlMus1K1JJwj1fD9ehP6o6oEuS+cd2aoyjmf
	 KjKo0N14DhMaZy4dfZ92b4ySe/jYn6hgUtZk4JEC+JCeMbAQXl7ugEp40sT3VxnJ1eh4z
	 WjeNDXwqIeLKun0wWXvkm6eoIuT69/B2Rwpm5jMuWIfjOUmWOmxHa6YIlv0FQgdbTlzAA
	 FUXdGYQtLXQly9rZJJQdkKXA1gJG093iGic0sj6P2SRXBrzR57xaZ2tFwP+US216ZzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WJdVUEiO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C02606A32D
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 17:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WJdVUEiO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6908B1F000C1;
	Wed,  4 Nov 2026 17:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793812946;
	bh=1mzE91UiZbJ0OwSDAQ4zCNTem1xCHCHlFCTGXkp+0aM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WJdVUEiONEUR0nMv5b1oYAB9lrw0xcfKakTIGrxaJa5AiWiWHdQZOqI9lZY4ASPbC
	 JmfnZNzUvz2c2uhHKweA+93ZowFAnN/pUtJECxoQehBvQqWXTOISDNyjJx77VyCwAO
	 JX4O42gzK46RVLo3mPoz+T6AJ5CXO0bT5TO+FHyYJhxS1Laf5n1SNnMHfwoCrUFbCc
	 DuZb+VXrBeJ/dO6BPIy5B9ZLHmqBeeW0N/MOc1dAV2gapo/UxQyj7fcsfgUqSMAigF
	 /vtGuL14FKANYbt7NokDZSO5nZ/8FtzGxw7CgnXo2rpV4ys6Z2GTQ0vQe9gtkYj9w9
	 BkhCHUy7qOIuA==
Date: Wed, 4 Nov 2026 09:22:25 -0800
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
Message-ID: <autp0cVkXwvSXPGC@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org>
 <20261023205610.1044532-19-oupton@kernel.org>
 <autJUntFMhCoqZeH@LeoBrasDK>
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
In-Reply-To: <autJUntFMhCoqZeH@LeoBrasDK>

On Wed, Nov 04, 2026 at 03:03:46PM +0000, Leonardo Bras wrote:
> > +		/*
> > +		 * Plug your nose for a moment.
> > +		 *
> > +		 * Writable-clean translations are shadowed using a read-only
> > +		 * mapping so KVM can set the dirty state on the L1 descriptor
> > +		 * before installing a writable mapping.
> > +		 *
> > +		 * Certain cache maintenance instructions require a write
> > +		 * permission check but leave the translation in a writable-clean
> > +		 * state, meaning KVM is on the hook to emulate CMOs that use a
> > +		 * writable-clean translation.
> > +		 *
> > +		 * "Emulate" the CMO as a NOP, as KVM only exposes FEAT_HAFDBS
> > +		 * when FEAT_S2FWB is present and the I-cache is coherent.
> > +		 */
> > +		if (kvm_vcpu_dabt_is_cm(vcpu) && trans->writable && !trans->dirty) {
> > +			kvm_incr_pc(vcpu);
> > +			return -EAGAIN;
> > +		}
> > +
> >  		forward_fault = ((write_fault && !trans->writable) ||
> >  				 (!write_fault && !trans->readable));
> >  	}
> 
> Maybe it's just to messy or plain wrong, but could we make the descriptor 
> WC, then run the said DC instruction, then make it RO again?
> 
> I mean, maybe I got it wrong, but if we can't enable HAFDBS for the 
> nested guest, as updating a shadow PTE from WC->WD would require us to 
> take a fault to update the PTE inside the guest hypervisor, we could have 
> the PTE as WC without risking it to be promoted to WD by hardware.
> 
> I am probably missing something.

The writable-clean state is nonexistent when VTCR_EL2.HD=0 in the direct
permission model. So we have no way to construct a translation in the
stage-2 that satisfies our requirements.

The other way to do this would likely involve halting all vCPUs in the
VM and attempting to single-step which has a near 100% chance of blowing
up in our face.

Thanks,
Oliver
