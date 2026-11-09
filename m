Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794255607;
	b=cf3GYFPig0MnHPLs3H9Z+IXpbV8YYxaIZ1+1eQDdv2jjvtRlXKaBgXgYX4jBZnSMgci+
	 OMbtyl20oWTbT81Y3F+KUTwXTl0Lm+qUQqFjCy+LMSYLb92MTg65a+bEuMlwYOBa2bhLN
	 fKIjfWphSfhL3l0oscWYVXS6jCvhfoVM0pNT5haqKENgoIuzJ5DjhY71awpQMS5rKh44/
	 HEayo7I5m6D7ALeSvYCLSbtX8SeALF2rZGwc/5SG6HoqS8AxDUDAPbL/GNSIHz0unT4rJ
	 acV63cwBzzEvoj/W8wesH1Om6ygD49OzMJD/FtKLZTgs8i0zfLut/FR7/q+d1Ex3EXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794255607;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=IcBL3a80r84RA3Ro027wMRJVkdShjlT42KuGCQbF6jo=;
	b=wbWzwTKhLk0Ak+X10EjiHbHy9ipJ1Dgj9GskYRhZVvGomyod6wQjRIs8nuAvk1jAG4jo
	 w6mExYBogNJE5m0WAUwDlQQfNEqTm/Mi6qQrqSfDKqMmWjQdp8hhUyGXV5IbjHnWWOvaW
	 Z9Py7MhebOE2502NvesaFD/+jkIAfb2P7kyvk7r6B5/8QjPnurUtykQ2ppbhSgpVLMe/l
	 DdETALX82/gdfD6EezKbCLoruFDrsgp8YznOwcWVeQvLEb2i6Vt73UdqXKmMZmo9JIGg3
	 Nvqm/SgAAfyKpKyH5SbvqJa3GswbHqZ8GEl8GeZfvMvWNzIVO/BZPHhlkG3LPS2ZsQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HjMw8nLW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A6F606A32A;
	Mon,  9 Nov 2026 20:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HjMw8nLW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19EDB1F0089F;
	Mon,  9 Nov 2026 20:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794255606;
	bh=IcBL3a80r84RA3Ro027wMRJVkdShjlT42KuGCQbF6jo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HjMw8nLWjwc11PenB3/UnNBdeoGofUyEt89ZWH7hSnJqYtJzhDuOFrD/q+apcceBz
	 Q9tR3Hey2bMYOlvmAQk6LpbuBOtm/4cZlOjJtmwwX/Xox/4Zp7RaQGME+UhxTOWjpD
	 e6RN6m1ApDYmolSL6diC4RuCAHs9UDvNrm66KoiDVfdUZcC3q1pe2aDnhUdWElD16w
	 U5ifvLJyb90nArCqI8OqLj+OTGNu73t73V80RSrPJbyKXzaPPtf7TaHGJvQGKTu22F
	 VoeGztmXiSY7Lbo2p1NbfY9tnr2ot1OyP1zC0vT/GK/a+J/IU8BNQddEsbo/YSnuTw
	 oFkwUz9vCKJLg==
Date: Mon, 9 Nov 2026 12:20:04 -0800
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] KVM: arm64: Support debug, SVE, MOPS, PIE/POE,
 FPMR and more in protected VMs
Message-ID: <avIq9AIE-9igDzsV@kernel.org>
References: <20261109083205.806619-1-fuad.tabba@linux.dev>
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
In-Reply-To: <20261109083205.806619-1-fuad.tabba@linux.dev>

Hi Fuad,

On Mon, Nov 09, 2026 at 08:31:49AM +0000, Fuad Tabba wrote:
> Hi folks,
> 
> With most of the groundwork now merged, bringing protected VMs up to
> the features we support for them in Android turns out not to be a big
> series. So this folds self-hosted debug [1] and SVE [2], which I posted
> separately last week, into one series with the rest. Both are small,
> and keeping them apart would only leave a few conflicts where they add
> neighbouring lines to the pVM ID-register code. The debug and SVE
> patches are unchanged from those postings.
> 
>   01:     Self-hosted debug.
>   02-05:  SVE, with EL2 owning a protected vCPU's SVE state.
>   06-07:  Compute a protected vCPU's fine-grained traps at EL2.
>   08-16:  Advertise TCR2, SCTLR2, S1PIE, S1POE, MOPS, FPMR and the
>           features EL2 already handles for non-protected guests.
> 
> Tested on QEMU, in hVHE and nVHE, and on FVP for S1POE and the fields
> QEMU doesn't model (CLRBHB, RPRFM, ECBHB, LSFE, LSUI, HAFT, ETS3 and
> F16MM). v2 of the pKVM selftests series [3] will cover debug, SVE,
> MOPS, PIE, POE and FPMR.
> 
> Based on Linux 7.4-rc1 (6628e7d4c6b25); it also applies to 7.4-rc2
> (7475ea8b58616).
> 
> Cheers,
> /fuad
> 
> [1] https://lore.kernel.org/all/20261102093950.2922035-1-fuad.tabba@linux.dev/
> [2] https://lore.kernel.org/all/20261105130456.1617185-1-fuad.tabba@linux.dev/
> [3] https://lore.kernel.org/all/20261104084842.132944-1-fuad.tabba@linux.dev/

Ok, we really need to slow down the rate of patches here. I had already
applied the SVE series locally and now we've got a grab-bag of CPU
features in addition to what I was ready to apply.

The whole point of respinning a series is so we can converge on the
shape of the feature and get it merged. Adding a whole pile of things
that wasn't asked for just muddies the context for us dumb humans and
slows down the rate at which you're going to land things upstream.

Going forward, can you please:

 - Keep an individual series focused on the original intent. Don't
   unnecessarily expand scope.

 - Only iterate on a couple of series on the list at a time. Sashiko
   findings are interesting, but you're gonna have to draw a cutline in
   terms of how many additional patches are going to ride the coattails
   of any particular series.

   You're obviously a very active contributor and reviewer, so I don't
   anticipate such a rate limit to actually impede your patch velocity.

Sorry, I really do appreciate the amount of work that you're doing to
get pKVM in good shape upstream. I just get the sense that Marc and I
are going to quickly encounter bandwidth limitations.

Thanks,
Oliver
