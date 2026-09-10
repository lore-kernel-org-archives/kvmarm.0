Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDA1248F57;
	Thu, 10 Sep 2026 09:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789030836; cv=none; b=L2aK2+dgE8YIO91h0tAXK7amnDz4lu6DmG6uDnhNiI97cVxfFhCXypSET9y05jnfTvDLiN7j/l8AQZV1p/+hKLtBZbr4lBsqQopSRxjpw/PkNEXiJkh9pEGNSgl2wPbnnIHWu7U/W/1vFv3IFVw71Ug/H5jiZGaAB9jA/XMDIOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789030836; c=relaxed/simple;
	bh=SioSdBfob/16+3LCoOEMaUJBFsI4P14u8iozrJUxHWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oO2m951tpap1P4Lg3XKOMTzsuQKFK6Dij+X5cYVIa3QoAzDu/fa+Gwclazq8Q7N1wD4XeM/gs9m624Q03bSvSSpjxIsEPwFP6/YQiIYwHLK+fHWlkvsdmJo5qznqP7O9DcLsFba8sHXOoBuyijsbASPZPorLZ79IpjJJswgjxyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DPjmbeYt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DPjmbeYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198601F000FF;
	Thu, 10 Sep 2026 09:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789030824;
	bh=LRhYS2kI6eOa7Tpev+em9TAqjMhsmAucfC4Y4Gky9+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DPjmbeYt3sdGHBOhGLtRoQycU+3nrhk1iYIqstsRONVzdz2zfYtSFNThl9ierVTZF
	 mQpMzQSN92nAOpZnCK7PvTmp6hMISU1rUH5hs/Cfyvp89p+Tgzyhy/rS7arPpJDJX/
	 l3E9x3+CjHJVRxKjxT95YVhxUzQZvhB9jeTB5w8BL9n2lK288/ql2BW+PNT2lZPCTT
	 aIh7qDQ4DSOQipPg6f+nMLvC2PLFuI/7EobGFZYepPdYXp32F3dGKVpjPMDlFCAX0S
	 XEa2NDl1+5pjY4yTesqhEdS5zFNnObevx4pialgN8ygYBrIBdb8IZ44c6OCDPN+C/Y
	 lEJdAZeoY3HLg==
Date: Thu, 10 Sep 2026 10:00:15 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Oliver Upton <oupton@kernel.org>, Fuad Tabba <tabba@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jack Thomson <jackabt@amazon.com>, Jack Thomson <jackabt.amazon@gmail.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Vincent Donnefort <vdonnefort@google.com>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Leo Soares Passos <Leo.Bras@arm.com>
Subject: Re: [PATCH 3/8] KVM: arm64: Propagate and use kvm_s2_fault_result on
 S2 fault
Message-ID: <aqJwzEGcQVUKgYKO@gremlin>
References: <20260825-kvm-arm-prefault-v1-0-befe8947702e@kernel.org>
 <20260825-kvm-arm-prefault-v1-3-befe8947702e@kernel.org>
 <86v78d7apn.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86v78d7apn.wl-maz@kernel.org>

On Thu, Sep 10, 2026 at 09:49:08AM +0100, Marc Zyngier wrote:
> On Tue, 25 Aug 2026 17:00:37 +0100,
> "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
> >  arch/arm64/kvm/mmu.c | 33 +++++++++++++++++++++++++++------
> >  1 file changed, 27 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 80cb520e25b9..da15da4e40e6 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1607,6 +1607,11 @@ struct kvm_s2_fault_desc {
> >  	struct kvm_s2_mmu	*mmu;
> >  };
> >
> > +struct kvm_s2_fault_result {
> > +	unsigned long mapping_size;
> > +	bool mapped;
> > +};
> > +
> >  static bool kvm_s2_fault_is_perm(const struct kvm_s2_fault_desc *s2fd)
> >  {
> >  	return esr_fsc_is_permission_fault(s2fd->esr);
> > @@ -1632,7 +1637,17 @@ static u64 kvm_s2_perm_fault_granule(const struct kvm_s2_fault_desc *s2fd)
> >  	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(level));
> >  }
> >
> > -static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
> > +static void populate_fault_result(struct kvm_s2_fault_result *result,
> > +				  unsigned long mapping_size)
> > +{
> > +	/* A THP upgrade may have altered mapping size. */
> > +	result->mapping_size = mapping_size;
> > +	/* -EAGAIN is swallowed so be explicit when we actually map. */
> > +	result->mapped = true;
>
> I'm not sold on this boolean. I'd rather we use the fact that the
> fault handler has passed a result pointer to return -EAGAIN rather
> than turning into a 0, because that's a clear sign that the fault
> hasn't been generated by a vcpu.

Yeah I did actually think that myself when writing it :) I was a bit in two
minds about how to do this, but yeah that's just a better way, will fix
that!

>
>
> 	M.
>
> --
> Without deviation from the norm, progress is not possible.

--
Cheers, Lorenzo
