Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D21C217F40
	for <kvmarm@lists.linux.dev>; Mon,  3 Mar 2025 19:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741029499; cv=none; b=moO1DU9eJdZM96CX53UpAzgvI1SEWruZjqzW7RyY5BiTT1rCi+3YxnvoZdbyw8OAAMpChKxuCNTf/lYE7ixo+LsOeDSOEHdbgBh1FTL38E6A1/sRCB7dkrydqW/Unq0tCYV+Shv4MU4wmdR3ySEf3/0dezUUUbvqPKJKeqR22m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741029499; c=relaxed/simple;
	bh=Vg/2VuaawTLlMnp2NzzvT8YzOf8Czwrf1poIJiGpqqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iqzTLCrD99WxBl/JMGPHn1gHZGIUX9nn96SEnGX62AbE18g7DLDkLfcmsUMYNZzN6bDXhHfoQDRi14r/IADWfuQiHBvaWOFlkETyF3A4DJS9+0jsIqBozOlDk/i/yuzqPz5iJ9C5Q4Da8DmSk+O9bDz/QQxsdJLnIgCbdpxHBWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rRVnXtrJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rRVnXtrJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD033C4CED6;
	Mon,  3 Mar 2025 19:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741029499;
	bh=Vg/2VuaawTLlMnp2NzzvT8YzOf8Czwrf1poIJiGpqqI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rRVnXtrJnlrgRsLrO9TGTZLe50ESltIbfTGcEudZwgeL9oCCckHNN41yquyDdnUiI
	 4ffOEpOrqa1N6rV0eJn0Y/IuC8wLzMGJTy19O6/GzHBRs8J6FpSLRogZKI3+qMY0fx
	 S16HdyLEEnxgPLz/IvK3lF3rO+Y/w7X2Bg1mMBUhs7vi0bmIE1Wj85XtEM0gR64K/D
	 KiKsuARv24cFfG607vxBFQBNoyBj4uma6Rrpi3jrreAhr4jjv9HIaks6tbJO8qVlhu
	 pme30VYiKza+nlwOkWDmtPq7nSgPpTsrSA3KoZMV4l1s8aNYT4ALT01l2hSXkLuEtT
	 62XB5ShLnHXXQ==
Date: Mon, 3 Mar 2025 19:18:13 +0000
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: Quentin Perret <qperret@google.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	oliver.upton@linux.dev, mark.rutland@arm.com, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, broonie@kernel.org, vdonnefort@google.com
Subject: Re: [PATCH v2 3/4] KVM: arm64: Factor out pKVM hyp vcpu creation to
 separate function
Message-ID: <20250303191811.GA30361@willie-the-truck>
References: <20250226215520.1759218-1-tabba@google.com>
 <20250226215520.1759218-4-tabba@google.com>
 <Z8ISLxQRcsx2uuHw@google.com>
 <CA+EHjTympdi0wei2Qx=hF2cYvHpzE0sWto2ypcJB3ddmonTROg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTympdi0wei2Qx=hF2cYvHpzE0sWto2ypcJB3ddmonTROg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Mar 03, 2025 at 07:57:00AM +0000, Fuad Tabba wrote:
> On Fri, 28 Feb 2025 at 19:44, Quentin Perret <qperret@google.com> wrote:
> >
> > On Wednesday 26 Feb 2025 at 21:55:19 (+0000), Fuad Tabba wrote:
> > >  static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
> > >  {
> > > -     size_t pgd_sz, hyp_vm_sz, hyp_vcpu_sz;
> > > +     size_t pgd_sz, hyp_vm_sz;
> > >       struct kvm_vcpu *host_vcpu;
> > > -     pkvm_handle_t handle;
> > >       void *pgd, *hyp_vm;
> > >       unsigned long idx;
> > >       int ret;
> > > @@ -161,33 +178,12 @@ static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
> > >       if (ret < 0)
> > >               goto free_vm;
> > >
> > > -     handle = ret;
> > > +     WRITE_ONCE(host_kvm->arch.pkvm.handle, ret);
> >
> > What's the reason to make this a WRITE_ONCE? Does it mean we should
> > update the readers to be READ_ONCE()?
> 
> I don't remember the original reason, to be honest. In this case, it
> was to make it consistent with downstream code in Android. That said,
> I plan on revising all of these soon and fixing this (and related
> code) in light of Will's comment regarding potential specter gadgets:
> 
> https://lore.kernel.org/all/20250218092705.GA17030@willie-the-truck/

I'm not sure the spectre stuff changes the concurrency aspects here, so
Quentin's question presumably still stands even after that.

Looking at the Android code, this WRITE_ONCE() pairs with a READ_ONCE()
in pkvm_is_hyp_created() which is called without the config_lock held
by kvm_arch_prepare_memory_region(). However, given that
pkvm_is_hyp_created() is only testing against 0, I don't think the
_ONCE() accessors are doing anything useful in that case.

The more confusing stuff is where 'kvm->arch.pkvm.handle' is read
directly without the 'config_lock' held. The MMU notifiers look like
they can do that, so I wonder if there's a theoretical race where they
can race with first run and issue TLB invalidation with the wrong handle?
That would apply equally to the upstream code, I think.

Will
