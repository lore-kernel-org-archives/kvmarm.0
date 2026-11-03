Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793724453;
	b=brCbQqydGWp0fODYa5KCG+OhZ0Dcpmxq38mJpDBm422QsgBUogyfINwCV/ZEWKMY/QNs
	 5Aw+kJJ7Q2FF627lSdODwNDu12odMEoIxH9tL5XB+osNKkZUmtQxqQFLy33x6PLpYJvo6
	 CfyH+Go40lZalVO7hbYsj9Qu3h/BdncGvMY8rTW/vmsUwMtPcaEIuQpJIHUnSFYdZ2O37
	 Vob5axGsYcjC2Kecf2onBOW0dHWzUWvonGD6JMSADh0T9blhXBeMKQGLsQ4VAENrbrubv
	 WERI33g1JW2Uml+RB1caZfZsDOLLTsr1yoKRMsmMszVQr2bhZJA1iQQGYO1/aaUJdHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724453;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Q/ltEAc+N+3ENVziqnPe9OWDAKNpP/rCTARs1hVfB1Y=;
	b=AF96scrZ6qXz9SmNfHi4WWLr70hx41trYg6h7iFIGI0X+cShFurfrM9YRVQCmo+BCkQA
	 7SjOCOkCyoKxnhI8NHG+n9aPmHKB3aEhUwZpxc9r0oI3ToWQ7etsuAaIaFp1H5RoITiKo
	 MxxzmSbCozUYA5Z++nh5u/tet3YCwkZpNLiRATsPiG1yVkgZYjvB/Xfvt8jDC8qqYjY/9
	 1c5QmggJsoLjref2r1fnzRhCf5VNNiicWv3D9kZ4144ONWviq9nnnFb/3CP1LTLpfY+Qg
	 Ufwunzqd4aYHPL6Oi6NOV0nph6PqlP5H1OqRZULqkX9nCokSPAm+40WEb4/X95FelWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EH1UgyGW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D22606A329;
	Tue,  3 Nov 2026 16:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EH1UgyGW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769DE1F00919;
	Tue,  3 Nov 2026 16:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793724452;
	bh=Q/ltEAc+N+3ENVziqnPe9OWDAKNpP/rCTARs1hVfB1Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EH1UgyGWR3BQgaGa2fY0FrvPhw0YrCxuvKsWxRS4qOVEE4xwX1BtTABDzgitcwH+F
	 d5TpvMRv/iEnKwkiN8ZLZmfJYjxsGa1608mwytH5s/dLdvYGanDtHoo3M1ED4+/VhZ
	 SJHH4ERCS/OlaC7IIpraTBgPsU8zulVrWGbln8CXqudG5U0b+dhq2SfVagd4AX7Rg1
	 AAqTWlmMKLtqFfq7aaogICoZSaDCZrpGieBzKIwhQpcSsC9mSnJlZhGhEYPmBc4gl0
	 OHTJs4XktOIdB128KA3U5V0c/ueV//1psyTDDiWxzrSjVBNkBgBSYSAnJMTdwSUSgM
	 /M/3kNXS6w+Qg==
Date: Tue, 3 Nov 2026 08:47:31 -0800
From: Oliver Upton <oupton@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Don't walk the whole IPA space when
 destroying a pKVM stage-2
Message-ID: <auoQIzfM8tF4F98q@kernel.org>
References: <20261103084742.1302597-1-fuad.tabba@linux.dev>
 <20261103084742.1302597-2-fuad.tabba@linux.dev>
 <auoN4h8iloqPuepc@google.com>
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
In-Reply-To: <auoN4h8iloqPuepc@google.com>

On Tue, Nov 03, 2026 at 04:37:54PM +0000, Vincent Donnefort wrote:
> > @@ -513,10 +514,18 @@ void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
> >  		kvm->arch.pkvm.is_dying = true;
> >  	}
> >  
> > -	if (kvm_vm_is_protected(kvm))
> > -		__pkvm_pgtable_stage2_reclaim(pgt, addr, addr + size);
> > -	else
> > -		__pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
> > +	/* Called once for the whole IPA space, so reschedule between mappings */
> > +	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
> > +		u64 start = __pkvm_mapping_start(mapping);
> > +		u64 end = __pkvm_mapping_end(mapping) + 1;
> > +
> > +		if (kvm_vm_is_protected(kvm))
> > +			__pkvm_pgtable_stage2_reclaim(pgt, start, end);
> > +		else
> > +			__pkvm_pgtable_stage2_unshare(pgt, start, end);
> > +
> > +		cond_resched();
> > +	}
> >  }
> 
> Just thought that it is a bit weird that pkvm_pgtable_stage2_destroy_range()
> does cond_resched() while kvm_pgtable_stage2_destroy_range() does not.
> 
> How about instead kvm_stage2_destroy() refines start/end with some accessors
> calling in pkvm.c pkvm_mapping_iter_first() / pkvm_mapping_iter_last()?

Yeah, I'd rather we tackle this as a general problem than doing some
pKVM specific hacks.

Seems to me that we do a lot of wasted work even in the non-pKVM case
where the outer loop will continue to iterate KVM_PGTABLE_MIN_BLOCK_LEVEL
worth of IPA even if the underlying table is empty.

What we'd want is for the kvm_pgtable_stage2_destroy_range()
implementation to report back how much of the IPA space it actually
iterated over. We wouldn't want to keep re-visiting the same invalid PGD
entry only because it's larger than our max block size.

Thanks,
Oliver
