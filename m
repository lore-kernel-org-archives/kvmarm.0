Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D318E3BA248
	for <kvmarm@lists.linux.dev>; Wed,  4 Mar 2026 14:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772633299; cv=none; b=nDatXFLgC5Y+Nqsb4fMgdUmh0bH6JbX3i66GFRIoG/NeJppfy+aO6pGhidFVB+OagWLKjrJ/hvRcTWIzHSMY6CMKVmXtTKv8allHMBcwJcWPaIHCGzo9n+Wt44jjEfRCRFEXEgBQraxj2ZeR58+3VFheGt9mW/nL4odFqaXczqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772633299; c=relaxed/simple;
	bh=RlN6e8YUqUZvBpyKIk+jEAHmPAFSy30sIJkU6Fd/PU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GhONMQJlEvPzlsouK5rh30wZEWCjCqSmQE9Mv4hflVUb1YuCn2YK35IJP4lcP99BEPX2kDBv1WnrZGkTQduuJcSgeQALISiA+FgESDJz6Vn+C9iTaBPKZPhz8LMWrnk0IXVrYwCofHczOiDssasEj9AgC6xZIkWrZUwVcjSlpF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AxBcEsGN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AxBcEsGN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7AAC4CEF7;
	Wed,  4 Mar 2026 14:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772633299;
	bh=RlN6e8YUqUZvBpyKIk+jEAHmPAFSy30sIJkU6Fd/PU8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AxBcEsGN1Hc+DNF0l3YqqsIZNXxDWnVXVmaGrsijnSWngNh5Yc3LMljz9COhNTMfX
	 0ZIn6H18WgoNJEwgb77rsb9y6fxxqr2oWfRMN5glvUrDD4Q70ecICIDxPdzpxvdl03
	 jJSoORO7Mzd+AU+RAeGBy54YDanpBtL8zBjbQAgFi5mgjDyljY934S3o9VDXuHzTOH
	 ZFzQg0QIxrX/dX2JyXOO9r3QvX7JivHxxwahIhk/GbgsgSAN2TYC+NEFoe4fbNW09b
	 JMoe+gnRcTXrD02hUkCwWnVY+dyGsATzLpPUiSGaQqM8xIUjntSwSBRRSxIFu4Lf1q
	 ZwOSDUdM3/pNA==
Date: Wed, 4 Mar 2026 14:08:13 +0000
From: Will Deacon <will@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 24/35] KVM: arm64: Introduce hypercall to force
 reclaim of a protected page
Message-ID: <aag8zZpi_r5hduQJ@willie-the-truck>
References: <20260119124629.2563-1-will@kernel.org>
 <20260119124629.2563-25-will@kernel.org>
 <aY4LchRsyTvjIBVb@raptor>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aY4LchRsyTvjIBVb@raptor>

On Thu, Feb 12, 2026 at 05:18:42PM +0000, Alexandru Elisei wrote:
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > index dee1a406b0c2..4cedb720c75d 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > @@ -30,6 +30,12 @@ enum pkvm_page_state {
> >  	 * struct hyp_page.
> >  	 */
> >  	PKVM_NOPAGE			= BIT(0) | BIT(1),
> > +
> > +	/*
> > +	 * 'Meta-states' which aren't encoded directly in the PTE's SW bits (or
> > +	 * the hyp_vmemmap entry for the host)
> > +	 */
> > +	PKVM_POISON			= BIT(2),
> >  };
> >  #define PKVM_PAGE_STATE_MASK		(BIT(0) | BIT(1))
> 
> Looks a bit awkward to me, having the page state encoded using 3 bits, but the
> mask only 2 bits.

It's a little fiddly because we have three ways to track the page state:

1. In the two software bits of the pte mapping the page. This uses
   PKVM_PAGE_STATE_PROT_MASK.

2. In the four bits of each 'struct hyp_page' entry in the
   'hyp_vmemmap'. This means we can avoid fragmenting the host stage-2
   page-table for pages that are shared. These use PKVM_PAGE_STATE_MASK.

3. States derived from an invalid pte that are never stored explicitly.

PKVM_POISON fits into the last category, and so isn't constrained by the
masks.

Perhaps I should rename PKVM_PAGE_STATE_MASK to something like
PKVM_PAGE_STATE_VMEMMAP_MASK to make it clearer?

Will
