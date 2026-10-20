Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792502259;
	b=wYs3eQZPj6mBxlST7rnhGUxR3bpdtxEsqsbtIp2aQaLncmCyLqlIoimwn7ywj+l65Wh2
	 39RaQrLa+y6yEooi6BzNZrWhF1llhlATuz1Mh9VhyHYijETOpiuH2LrvTk+q1vIarVA0U
	 UUvr5G9a+R5j53ZXQniU0Zg3oOno/qjg23LI+5fK/kDAjbJqU/V6XAmBqjyWBtPIkVSt7
	 BRaUc76zmGaFvzaEKqE4c+edVOvRE2+kxuFrbl9U9kFD5D59SWPuaNqcVpupT6lG7tGTM
	 I2VI07pZkaH4Ip3RVo7vIYpQYisMmwUg6+OSlsC9TSeJUvr/Q1n+EZmVkcbHPvGMggg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792502259;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=gUAeRgbmHYJ9C+mDpvtxIRPjXTbjGx5SuGL9roQvzK0=;
	b=j9Ac9aIRtZysLWv0TenRKV672hLVeBhNwyJJZUSsC6NtddJ2VlvlZXQtML8Cneb34Ahp
	 cJh3D2aRBtEUVzfSUJYbSvKblvUdzR07LP0SVgFRzHqk93sSLy68BoLTRnrYx7kcaSmfR
	 Yj+gc7DfWGn0cgufe5vqeX6fKZseWk8G8mdOvmjlq0U66KAKg6Cy/894b1oGZs/aYxE/M
	 1VYv6c+RDZyGxfYALwxPp9OowAFFDEMmsxYrXlk+zGQxiy3pk2M+H6+lsNQg4NjbECyL2
	 QbmJ2ANab4e5YFSpOLq5qajMhHRNWqRpfFtZbkBXAi8Q4I27mX/lhMdYIJbym8ol3yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zvp3kpCL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CC1606A31A;
	Tue, 20 Oct 2026 13:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zvp3kpCL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29111F000C4;
	Tue, 20 Oct 2026 13:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792502259;
	bh=gUAeRgbmHYJ9C+mDpvtxIRPjXTbjGx5SuGL9roQvzK0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Zvp3kpCLVvGB8ZOTuW3HVZ8PQvuUuEuMQwPUlnGBdvwb61ASqkxJyi/1LIRpzHkxT
	 U5RTDX0MiQwkj6AiuhNPmZ9RMGjh7tcChNPfJ+/kBgjevNURE189XwZJzsxCZoJYqB
	 dUpyW0E/TOa7tRhYG1Vbl4BaQePJtbTFvKQlCLM7YRUIpnfb+JlMV2wYyVFx80y5jw
	 /6pSY5VHwJCp3hLOM9y6jCcZAo48PpFgBPrufObDb/bZrhti/5Rx8jHW3gYvPdsa8y
	 D2tVYgF2mtmuJxiUjdmIkR3Es/iijAD1TfQU49qenXLgwDyeI1kOD1fA6PdD+Huuuv
	 PJ/d9Dk0qEllg==
Date: Tue, 20 Oct 2026 14:17:32 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Steven Price <steven.price@arm.com>, 
	Yang Shi <yang@os.amperecomputing.com>, David Hildenbrand <david@kernel.org>, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] KVM: arm64: Clear the whole hugetlb folio when
 storing MTE tags
Message-ID: <atdp3mclSi-Cc5FK@gremlin>
References: <20261019132103.3836646-1-fuad.tabba@linux.dev>
 <20261019132103.3836646-3-fuad.tabba@linux.dev>
 <atdWIpk9Qh8ngs-Y@gremlin>
 <CA+EHjTwb9V+12siUswmUX0-jr=sidKdAJ+vht+HyqS0KgA6v6g@mail.gmail.com>
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
In-Reply-To: <CA+EHjTwb9V+12siUswmUX0-jr=sidKdAJ+vht+HyqS0KgA6v6g@mail.gmail.com>

On Tue, Oct 20, 2026 at 02:11:11PM +0100, Fuad Tabba wrote:

> > > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > > @@ -1042,12 +1043,14 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
> > > -                        if (folio_test_hugetlb(folio))
> > > -                                folio_try_hugetlb_mte_tagging(folio);
> > > -                        else
> > > +                        if (!folio_test_hugetlb(folio))
> > >                                  try_page_mte_tagging(page);
> > > +                        else if (folio_try_hugetlb_mte_tagging(folio))
> >
> > Slightly awkward logic, testing a negative then the negative of the negative
> > (i.e. else) plus folio_try_hugetlb_mte_tagging(), makes it a little harder to
> > understand.
> >
> > With mte_clear_folio_tags() you can make life simpler:
> >
> >         if (folio_test_hugetlb(folio)) {
> >                 if (folio_try_hugetlb_mte_tagging(folio))
> >                         mte_clear_folio_tags(folio);
> >         } else {
> >                 try_page_mte_tagging(page);
> >         }
>
> Without the helper, the extra level of nesting takes the loop body
> past 100 columns, so I'll switch to your version in the separate patch
> that adds mte_clear_folio_tags() (see 1/3).

Ack makes sense, thanks!

--
Cheers, Lorenzo
