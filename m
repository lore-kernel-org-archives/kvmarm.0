Received: from mta1.migadu.com (out-107.mta1.migadu.com [95.215.58.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D20246783
	for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 12:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792413962; cv=none; b=LlK5AtTIqaUgYNyCnOEcIhfM2y31g1dlyKISQ6aSKpP/fMW35LWHBnwhp2IDxDYhWgQXWppecZsdjEaSnxwd/fKJkzCDZQwyseGMp8iCh+6wSAGGYG0Qqey79VBZUJpGalPESBoKt2cCtX7DTumCsySt8SQLxUvu4rsrOerlk7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792413962; c=relaxed/simple;
	bh=Qxp6b0ax9oueHkME8135NN7XH5RwaIVlp3JI/E88/tc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dpZqkOVYIVIUw1F1gvdFHZoNT148Y1m6MatFcYpYdN7r9YLu0yKA+X1ezIL9njcuOMX73zWy0CBY3PUNqz0Lbmf+8IrOnIjsEySGGW3KYclMlay2vD6MicVJJfET1SNJMjGhhEEqyIh5ckIyxfoBsSr120f5zkY3L72zojWik1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YcGLXmLA; arc=none smtp.client-ip=95.215.58.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YcGLXmLA"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Qxp6b0ax9oueHkME8135NN7XH5RwaIVlp3JI/E88/tc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792413958; v=1; x=1793018758;
 b=YcGLXmLAftMXIYn6PRnT1QOkOfVZiwVQcxYfCu4MAJr32DchnMhxsCkqsOzmUfOQfuCrOXB+
 NjcIcBBbxa4Gg2AXmsmFX+AYV4NkwZyvmuWhKMRdxDNwGsjams/oEOizfqDXEIXoz1H9d7uLcli
 Ohd9c4PD0rPQOAO2VFc9Uo6U=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 4d71a47899b365dd;
	Mon, 19 Oct 2026 12:45:58 +0000
X-Mizu-Trace-ID: 4d71a47899b365dd
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5be4a7b9e6fso9484e87.1
        for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 05:45:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByJXwTOTMSOjX6BPdzqx8JKGP9fhLgIBSlOP/83Bx4JIFcXrbOCNtWdFZ+0gAxBaWLtiUM1IGE=@lists.linux.dev
X-Gm-Message-State: AFq9FYK+ko7/Z59LYqN0e38YRvclyY/lvhIUPfXbMOtNVssV1ec/FEn9
	USSnQoFnn6xCTlJ1UjkFLU0DGBg+EANL3UqoZeKHmFI2KknMIrhUkz/4/tqQ6/eZ5ipuoy77Rcu
	fGc7HJuI8MmNYum/M+anFgdjzufo8PcpD3hoF9eTF
X-Received: by 2002:a05:6512:4026:b0:5be:5605:3606 with SMTP id
 2adb3069b0e04-5be560540ecmr122144e87.8.1792413957034; Mon, 19 Oct 2026
 05:45:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261014125510.2928306-1-fuad.tabba@linux.dev>
 <20261014125510.2928306-3-fuad.tabba@linux.dev> <atXqLxU5bBtJ8U9W@google.com>
 <20261019114357.3528498-1-fuad.tabba@linux.dev> <atYPZeJuw2grFDlz@google.com> <atYQKaLo4VJDoNJn@google.com>
In-Reply-To: <atYQKaLo4VJDoNJn@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 19 Oct 2026 13:45:20 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxU_dAPcm7C77SkWffJRtAzkTG3NJ6ix3Qk1hC-09wRBQ@mail.gmail.com>
X-Gm-Features: AclHuK88biJmUkYYPe6V74w0Egs3dpNZ2AJ9BmPKg1toG3idbbnqb7l-xriaAuI
Message-ID: <CA+EHjTxU_dAPcm7C77SkWffJRtAzkTG3NJ6ix3Qk1hC-09wRBQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Ensure TLBs and I-cache are private to
 each vCPU in pKVM
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Quentin Perret <qperret@google.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 19 Oct 2026 at 13:42, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> On Mon, Oct 19, 2026 at 01:39:01PM +0100, Vincent Donnefort wrote:
> > On Mon, Oct 19, 2026 at 12:43:57PM +0100, Fuad Tabba wrote:
> > > Hi Vincent,
> > >
> > > On Mon, 19 Oct 2026 11:00:15 +0100, Vincent Donnefort <vdonnefort@google.com> wrote:
> > > [...]
> > > > > diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> > > [...]
> > > > > @@ -54,6 +54,9 @@ struct pkvm_hyp_vm {
> > > > >          unsigned short refcount;
> > > > >          hyp_spinlock_t lock;
> > > > >
> > > > > +        /* Per physical CPU, the vcpu_idx of the last vCPU of this VM loaded there. */
> > > > > +        int *last_vcpu_ran;
> > > >
> > > > Unlikely to be a problem in pratice, but vcpu_idx is "unsigned int". I wonder if
> > > > this shouldn't be unsigned int here too and initialised to UINT_MAX?
> > >
> > > I'd copied int and -1 from the host's mmu->last_vcpu_ran, but the
> > > vcpu_idx it's comparing against here is unsigned int, so I'll switch to
> > > unsigned int and UINT_MAX in v2.
> > >
> > > Thanks,
> > > /fuad
> >
> > Also,
> >
> > as it is always allocated when pkvm_hyp_vm is, Would it make sense to add this
> > to pkvm_get_hyp_vm_size() instead of allocating separately?
> >
> > --
> > Vincent
>
> Ha, I just saw your answer to Marc and you will switch to a per-cpu approach
> anyway it seems?

Yes. Now v2 (coming soon) doesn't allocate it at all. As you noticed,
after Marc's comment on patch 1 [1], I'm dropping that patch and made
this a static per-CPU array indexed by the VM's table entry.

Cheers,
/fuad

[1] https://lore.kernel.org/all/86y0buyo5s.wl-maz@kernel.org/

>
> --
> Vincent
