Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6EDDF76
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 06:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784011327; cv=none; b=HyuYyrbEjTCEYtbQzgsOmk4Y+I/NgC9PUIEnFOWRYu5YLqynKef/avWPnMfrdhvh/+a4xg4wL66fpxYkP9QdehgvpfjfliFUxTOW0LmLunU3vSVhfkisAD4o8YazmsVyBx+VlJE9KlmRrlwDOOPxNzIvdB+YKeetCbyUyHquZtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784011327; c=relaxed/simple;
	bh=uDZzdzJlYvwUuJhs7Qh43kiA8VzvLxJOc3P1/aneLnc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p+HT4ihGySiJOP8I7vu8h1jFHUppZwQZou4aLVG1GfycT91qfwz5voYfrnipbLg02u6H4N2yJgnHYWxOoqlqJedrgfIaR83mGA073FUwH5+ZCVBj208Pg8oYHAYVZ4sfnrg3ZpMY6UIpG0BeZG/ZQml+e5/Kx8j4zIFUJ54Qrpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pmyDJ5Oc; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pmyDJ5Oc"
X-Forwarded-Encrypted: i=1; AHgh+RrStUdjdq9ob3XD4TUg22xcQRRkDCZWQImbFRi1jyMAwjNP4q07njMdFIdwRjQdnIYtbWp0GSM=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784011323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gCVaWlwXy1h6K7yqumgVi+lXEd0MerF1f9OEA/4dDMA=;
	b=pmyDJ5OcmqxCE7LCU7tErR0CnmsYAhPELFEsS6fMJla0LsQyHtesFyKlaUkV09ktIsU72Q
	8Izytqrm+lmK/TzWWvkvmJlSrMUgNyVX9wSS1uUwYCypStSTX8Lap4t1pZcDAey3nH0m+G
	NuAj5TpJjLS6zYlfRca5u/YqdHuf5GE=
X-Gm-Message-State: AOJu0YwEeEilzjC25RPejbm5ZIoC1CApLjjcHfsGABCk0QEnd6yuI0+8
	+KkL4/ibnnvy8M8sitre6gXA9XOZf5hiN+2qtKbLjCKcXrD08qx48ASpDc0u5lJEAIK+o05louU
	lW8TeRNoc5AVOxMdAETQ3ItEZunZXSc7PSMUL8KT9
X-Received: by 2002:a05:622a:512:b0:50f:af60:3496 with SMTP id
 d75a77b69052e-51d7bc994f7mr11182851cf.1.1784011304760; Mon, 13 Jul 2026
 23:41:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260706095927.560795-1-fuad.tabba@linux.dev> <20260706095927.560795-3-fuad.tabba@linux.dev>
 <alWDI7uj9YFedXET@kernel.org>
In-Reply-To: <alWDI7uj9YFedXET@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 14 Jul 2026 07:41:08 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwX-q5WEJ0pF5CJvtxwc2Vy4y=mmEvzo07sUa1SiyCM0A@mail.gmail.com>
X-Gm-Features: AUfX_mw5sgsKATxPxS4kpnWDGYO2p3GXI8BHq80imxIR3rQoh-xFNvj2QTUN5uI
Message-ID: <CA+EHjTwX-q5WEJ0pF5CJvtxwc2Vy4y=mmEvzo07sUa1SiyCM0A@mail.gmail.com>
Subject: Re: [PATCH v4 2/8] KVM: arm64: Make vcpu_{read,write}_sys_reg
 available to HYP code
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Quentin Perret <qperret@google.com>, 
	Sebastian Ene <sebastianene@google.com>, Hyunwoo Kim <imv4bel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Tue, 14 Jul 2026 at 01:30, Oliver Upton <oupton@kernel.org> wrote:
>
> Hi Fuad,
>
> On Mon, Jul 06, 2026 at 10:59:21AM +0100, Fuad Tabba wrote:
> > The vcpu_{read,write}_sys_reg() accessors are host-only, so helpers
> > built on them such as kvm_vcpu_set_be()/kvm_vcpu_is_be() cannot be
> > shared with hyp code. exception.c already wraps them in
> > __vcpu_{read,write}_sys_reg(), which pick the host- or hyp-side accessor
> > via has_vhe() and so are valid in any context.
> >
> > Move those wrappers to kvm_emulate.h as kvm_vcpu_{read,write}_sys_reg()
> > and switch the callers over, so a follow-up series can share that
> > emulation code at EL2.
> >
> > No functional change intended.
> >
> > Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
> > Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> > ---
> >  arch/arm64/include/asm/kvm_emulate.h | 22 +++++++++++++++---
> >  arch/arm64/kvm/hyp/exception.c       | 34 ++++++++--------------------
> >  2 files changed, 28 insertions(+), 28 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> > index 5bf3d7e1d92c7..80b30fead3d16 100644
> > --- a/arch/arm64/include/asm/kvm_emulate.h
> > +++ b/arch/arm64/include/asm/kvm_emulate.h
> > @@ -506,6 +506,22 @@ static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
> >       return __vcpu_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
> >  }
> >
> > +static inline u64 kvm_vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
> > +{
> > +     if (has_vhe())
> > +             return vcpu_read_sys_reg(vcpu, reg);
> > +
> > +     return __vcpu_sys_reg(vcpu, reg);
> > +}
> > +
> > +static inline void kvm_vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
> > +{
> > +     if (has_vhe())
> > +             vcpu_write_sys_reg(vcpu, val, reg);
> > +     else
> > +             __vcpu_assign_sys_reg(vcpu, reg, val);
> > +}
> > +
>
> Can you instead name the wrappers vcpu_{read,write}_sys_reg() and rename
> the current implementations, like __vcpu_{read,write}_sysreg_vhe()?
>
> Just want to avoid confusion between kvm_vcpu_ and vcpu_

Will do, thanks!
/fuad

>
> Thanks,
> Oliver
