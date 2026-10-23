Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792770976;
	b=QEPZyfOUg6/I34faheQ1uQ3kj5WpMp0l5V22Ztd9Ve/qQkDzDP6TS1jewbfIZ7HznyI9
	 cujt8Idk26fUf9ZLSMaOQTf+45rK5xvPARHuXtOtRvBqX3HxP9p0xbtZa5ilI295Nm0De
	 CbYf2ANpcctRxEtbo9ZjKryjOP2WBVA3HXVP9dq1yrCobXmkA3RdYN1Bhfy8n981gi2nO
	 JvDsj7oKGwh/kI8FKyAQKo/eE67AYJk2sM4I2PmAoI1K/fxWtcTLIOnhi0ItZyz6RblTl
	 yug7OdqvvZJkIFkHj2ZvSKKAqbLQ44Y/ZmMaD8FR3NIaFHvT6q/xSTqXCTQt5whM0QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792770976;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=XuZgvrBWboI3rpW18QcCXiO5LrzdiM17tAi+GoKtDEc=;
	b=MBy1HxSDtkODCPMOvwRleC4w2Y2GIwHoff4EKDx5V2SfvYSAKfT+BHVLxkW+F2YGRrMk
	 VZKB+x1XPvz4/DM4wgdJ7SmypZgjB6SpRNodpi3bBeoYeUokFThn8y/g3FK+aiSeGfuB3
	 P/KcbCIfsDoHha1H1SkRVxC+7OVJG+raNiw4fjAWSOOg2uduakmL120tfBvNduaoSWzdK
	 k4KY8zDUJ0HT9PyLGsHinSEkC6Hu5h9/IujfnRp54Y81y5gUSs9OqU/EnBljN3bixf8Gn
	 jfVJ0mYAGJitOzL3v2rmLnEnZ2qZCcay/STQ6R2T8KXt1arjoS7McuS6MV3sHzYVYrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TWB7iaoU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B965606A31B;
	Fri, 23 Oct 2026 15:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TWB7iaoU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0351C1F01825;
	Fri, 23 Oct 2026 15:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792770975;
	bh=XuZgvrBWboI3rpW18QcCXiO5LrzdiM17tAi+GoKtDEc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TWB7iaoU0mqHu7XMC6qJKeP6ShXGY/fvZ0moZp8oYAhvj+Erh31gPg6uk5N+YkGUv
	 fjw5vIBRdELK/grhuh/8ykk2bF6Seq3+J8EWPILmphRz6hDQrGbQbX3MKbXys7xHpY
	 6GnGgVrvMOwypfqqPOjVkoduLfcBH3Xmi7WNa5Uu7nsJQK+VeHK3vQvuQsDcfNQyIu
	 Rv7D7qvQflAOj/K1U6rmyTTwNMrweW6RjE4yNMpWwP6SdPpD3vD/glpmuhlHaMQBV1
	 /UQv8RJgj6+nvx1zFN+uhYPfGBLVL1u7t8Abgejl7E6cXlzdBIhlcUeIGwCtbSpY4r
	 JVHRY2AsStYZg==
Date: Fri, 23 Oct 2026 16:56:46 +0100
From: Jean-Philippe Brucker <jpb@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Alex Williamson <alex@shazbot.org>,
	Jason Gunthorpe <jgg@nvidia.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Oded Gabbay <ogabbay@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH v2 11/15] KVM: arm64: Export stage-2 MMU config
Message-ID: <20261023155646.GA52056@myrica>
References: <20261015142552.4128028-1-ryan.roberts@arm.com>
 <20261015142552.4128028-12-ryan.roberts@arm.com>
 <86h5idzqow.wl-maz@kernel.org>
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
In-Reply-To: <86h5idzqow.wl-maz@kernel.org>

On Thu, Oct 22, 2026 at 04:43:27PM +0100, Marc Zyngier wrote:
> > +struct kvm_arch_guest_mmu *kvm_arch_get_guest_mmu(struct kvm *kvm)
> > +{
> > +	int ret;
> > +	struct kvm_arch_guest_mmu *mmu;
> > +
> > +	guard(mutex)(&kvm->arch.config_lock);
> > +
> > +	if (is_protected_kvm_enabled())
> > +		return ERR_PTR(-EOPNOTSUPP);
> 
> How does this compose with CCA?

This function would reject realm VMs once they're supported. If we
wanted to assign a CLA device to a realm VM, I think it would be managed
entirely outside the host:

* EL3 driver reconfigures the device's accesses to
  physical memory (security state, memory encryption etc),
* RMM driver owns the PL2 registers to program the stage 2 MTC,
* the VM owns the rest of the device.

Lack of interrupts should make this assignment relatively simple.

> Can it be restricted to exclusively running VHE rather than also
> dealing with the lesser configurations?

Yes, I don't think we want to support any nVHE config at this point.


> > +	mmu->vtcr = kvm->arch.mmu.vtcr;
> > +	mmu->vttbr = kvm_get_vttbr(&kvm->arch.mmu);
> > +	mmu->hcr = kvm_mmu_get_hcr(kvm, 0);
> 
> How about the hcrx field in the structure?

It's 0 because HCRX doesn't seem to have bits relevant to MMU
translation, except maybe EnSDERR and EnSNERR that KVM doesn't set.
But it's not entirely clear which bits are relevant to this function,
because other possible users may access memory differently (eg. no
instruction fetch or CMO from a CLA device). Your suggestion below
should simplify this.

> > +
> > +	return mmu;
> > +
> > +err_unpin_vmid:
> > +	kvm_arm_pinned_vmid_put(kvm);
> > +	return ERR_PTR(ret);
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_arch_get_guest_mmu);
> 
> It really feels like this is a bit upside down. Since you are actively
> pinning the S2 MMU context, it should only be a matter of taking a
> reference on the kvm struct (just like KVM devices do), and handing
> off the kvm_s2_mmu structure, rather than copying things. When you're
> done with it, drop the reference.

OK, I'll update this. The reason for this copy was to keep a clear
separation between KVM and the CLA driver, so the driver wouldn't have
to use KVM internals like kvm_get_vttbr() and kvm_has_mte(). I think
those are the only ones at the moment.

> If there is a need to deal with a different value for HCR_EL2 (or
> anything else), it can be done in the code that makes use of it,
> rather than being in the KVM code.

Makes sense

Thanks,
Jean
