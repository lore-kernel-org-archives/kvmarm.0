Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88611FAC21
	for <kvmarm@lists.linux.dev>; Mon, 21 Oct 2024 18:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729534134; cv=none; b=uZZlTpP/RXrNeB6GgqZfKeSs7co6OVW0T8f0XV1uf/54EKEjfSjwBzdlUy3qH4KHa7YDUJw0OxHDs1TgBPqt6/uFBVm44FlnlIbY4V+irauzMa8hkDSWkWfcustv7tbmerTMfGMRfOtqAJGWzz13NdQAvTffjWcCs14s+IIc0GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729534134; c=relaxed/simple;
	bh=lGAahFUJB47Jv0GHevlLPsXzZ4O8VtjPyAFbuGdCp8E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pBXG5WN1NDeNsLQf5mQzRT4j64boIZShNptNoVT3v1klobYBHYXdQWW66R+TVyY9PP7CjNTKQDx/rDckHOxT0aFhkthPsfzQUYR72TbQcVCbSR/mlv+OqhBd3w+Uxvhpb8coLj+7QWz53uDpNX1ypF+6Qy7FnpNUauT2EXeR8rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R36JuzFX; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R36JuzFX"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2e5c75bee71so1376763a91.0
        for <kvmarm@lists.linux.dev>; Mon, 21 Oct 2024 11:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729534131; x=1730138931; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B4nB5AD8jm9woOflkJu9LaOALYzY3FWUJ+pKW1FSB8o=;
        b=R36JuzFXePXUZhWzKa/NR0txmpImVhmvaH3EVKvLLBQSln0i+jIJcrqG/QlKLOsrcJ
         eHPP1cCIckoUMDa7PlJe5b4eVS6b26G00DugV6RhJqpnvaAwbMPvIovysMQiT4uuzsvV
         G1ugQbsdog9hHTNi/8MavklNIDiVAoKcChDyVhfuHYQIe8Fje8YoH9uvTmUt3aqbSkqJ
         wawTc1bbnJHonZ8ttDZvKLOpgmAYshbnmqnmQY3UjOWwdHbi2Uv0pyQwT0aHwwTE2rH7
         0jTpOTI5mCnOO/N2OIN1wGUIHgRA1LrkCCNF0pqis5AW6iv4NPbejKOKQ5im7aSyE5Xe
         ANAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729534131; x=1730138931;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B4nB5AD8jm9woOflkJu9LaOALYzY3FWUJ+pKW1FSB8o=;
        b=iU1o1MsBRiNRhICHOudetn7J4HpmfD3BvG09r0xH1qLPDTvxd/mdTFOHOJE8OCPlMv
         y/+9GhKi6QFNpmQ3/xxSwFTzhbsn9ufZUNAVfgA5/J6+44P7CxQ1Az5UtkU4OSsFPkqZ
         m6BmanMwB6DnMVpyOUfbKcHW5thqG013g/b4YhKnhHi0bC5W3z9tjoiO84lcvwsyDKIo
         VaOo5rFtxvMYnrd0TIbzvBuFTOFdrWlUytQG7lQyhbywy4cNpkEs2OOy35Tk/b/nM64g
         Pr9npvjk7glzg76ga5u31GTAeq3kRvGmsbV+4NygZbCDUykL6zfvVECLgGmCq9i2J1Me
         hg4w==
X-Forwarded-Encrypted: i=1; AJvYcCW1vvXODIfXZHti0tsw6HvXMVJC8P8sCcCS9NKU95YpfT0E51lG3rfFev9+LHcNKO/mriY+vD8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyGvcH3XzprnbJOACmx40Ef5GjMwtupd/ZT+SykoQuAZ5d6f6+k
	RnVouCUXg66jwELQZWBaObRJC9rpOTEQbarZZdSs0pvd9PzE7yLkP7ymtUJmejTnpgnIkii8az6
	Niw==
X-Google-Smtp-Source: AGHT+IHz/sqxbIaZMzAhwQE+KHAQ50pc4vGOx7OQ/MlEMfrpYKQ16K4ySzEgLcCV5+myw9EmSbX31Z6uvf4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e147:b0:2d8:a9c2:2f3a with SMTP id
 98e67ed59e1d1-2e5616d8f42mr22750a91.3.1729534130899; Mon, 21 Oct 2024
 11:08:50 -0700 (PDT)
Date: Mon, 21 Oct 2024 11:08:49 -0700
In-Reply-To: <ZxYVnsW9WF1Wp8mx@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com> <20241010182427.1434605-20-seanjc@google.com>
 <ZxYVnsW9WF1Wp8mx@yzhao56-desk.sh.intel.com>
Message-ID: <ZxaYsfc0m6UHmi10@google.com>
Subject: Re: [PATCH v13 19/85] KVM: Introduce kvm_follow_pfn() to eventually
 replace "gfn_to_pfn" APIs
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	"Alex =?utf-8?Q?Benn=C3=A9e?=" <alex.bennee@linaro.org>, David Matlack <dmatlack@google.com>, 
	David Stevens <stevensd@chromium.org>, Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 21, 2024, Yan Zhao wrote:
> On Thu, Oct 10, 2024 at 11:23:21AM -0700, Sean Christopherson wrote:
> > --- a/virt/kvm/pfncache.c
> > +++ b/virt/kvm/pfncache.c
> > @@ -159,6 +159,12 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
> >  	kvm_pfn_t new_pfn = KVM_PFN_ERR_FAULT;
> >  	void *new_khva = NULL;
> >  	unsigned long mmu_seq;
> > +	struct kvm_follow_pfn kfp = {
> > +		.slot = gpc->memslot,
> > +		.gfn = gpa_to_gfn(gpc->gpa),
> > +		.flags = FOLL_WRITE,
> > +		.hva = gpc->uhva,
> > +	};
> Is .map_writable uninitialized?

Nope, per C99, "subobjects without explicit initializers are initialized to zero",
i.e. map_writable is initialized to "false".
