Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BE716D9DD
	for <kvmarm@lists.linux.dev>; Mon,  5 Aug 2024 23:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722902190; cv=none; b=NQZOLCkT25mVrPh97uQ8xdgDO3fM3BXHW/lFQZpHFAua6TviwtqhjdjmslP41czumqZHkj+HwiO3XT8+MUjL9+OmD7IQYst5WtkfPnspI6+jAuayEp1Omx7Rk66xzTUb+dIMYLrW5+QByRzWkBgSd+NwmFVw6utpqUqRW3k6zLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722902190; c=relaxed/simple;
	bh=Il0vorw5sMMNi5kRXAvIxumP3y5S5hrk5bLk6JKlfbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GfbbJ5w7tTHyzOOobXbX9uJ0UPTJLd5WY3snjgcaFrhIaC07OuMXQf4VAP4MfsUXSE7CMqaVwRTpZjMV/jk8eabidsM1IbLDwVRznUPzeEWmY3QRiCGL41iwqBAhy3gQePrAWw7uX9CvTHiKDOza1ZFF1lTWiIKnuOoGuZbVSho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ltAj9C7x; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ltAj9C7x"
Date: Mon, 5 Aug 2024 23:56:18 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1722902186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pN1+APSAtAExH8nmjZxjfeQ8B4XYksdtaPF9+NGomwI=;
	b=ltAj9C7xL0C220uapJ5lUkG5kNHP2zZtS1WYxPlhAzd6j+Tb/QV3RDuco0pM+j1z556Q9A
	hoU/lQELQ0mjJMI+uXIgqaezOeALKRjbAQbjCFVaZB2D2C3tgIkiE36obKMbKTDvluByU8
	L3cwZkpNHubjmM0zvEZGMwTs9FMKJX4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	David Matlack <dmatlack@google.com>,
	David Stevens <stevensd@chromium.org>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v12 54/84] KVM: arm64: Mark "struct page" pfns
 accessed/dirty before dropping mmu_lock
Message-ID: <ZrFmool3SKpp_NRZ@linux.dev>
References: <20240726235234.228822-1-seanjc@google.com>
 <20240726235234.228822-55-seanjc@google.com>
 <ZrFfgzRbiqT-Zi2O@linux.dev>
 <ZrFfvjy_-Tyx4xUV@linux.dev>
 <ZrFl3faiGHQ5oLjf@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrFl3faiGHQ5oLjf@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Aug 05, 2024 at 04:53:01PM -0700, Sean Christopherson wrote:
> On Mon, Aug 05, 2024, Oliver Upton wrote:
> > > > ---
> > > >  arch/arm64/kvm/mmu.c | 10 ++++++----
> > > >  1 file changed, 6 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > > index 22ee37360c4e..ce13c3d884d5 100644
> > > > --- a/arch/arm64/kvm/mmu.c
> > > > +++ b/arch/arm64/kvm/mmu.c
> > > > @@ -1685,15 +1685,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > > >  	}
> > > >  
> > > >  out_unlock:
> > > > +	if (writable && !ret)
> > > > +		kvm_set_pfn_dirty(pfn);
> > > 
> > > I'm guessing you meant kvm_release_pfn_dirty() here, because this leaks
> > > a reference.
> 
> Doh, I did indeed.  Alternatively, this could be:
> 
> 	if (writable && !ret)
> 		kvm_set_pfn_dirty(pfn);
> 
> 	kvm_release_pfn_clean(pfn);
> 
> It won't matter in the end, because this just becomes:
> 
> 	kvm_release_faultin_page(kvm, page, !!ret, writable);
> 
> So I guess the question is if you prefer to make the switch to an if-else in this
> path, or more implicitly in the conversion to kvm_release_faultin_page().
> 
> I made the same goof for RISC-V, perhaps to prove that I too can copy+paste arm64's
> MMU code ;-)

LOL, whatever way you want to address it is fine by me, just wanted to
make sure this intermediate bug wouldn't bite an unlucky bisection.

-- 
Thanks,
Oliver
