Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616FF330D2A
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 13:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784554879; cv=none; b=KgZoYWCci//Uf2RwZdFt9mzR098m4Q+8y1WIv4YI7z1zuARDFIprQWBJffnVXg7aWEVvtQTDDFJa1YWeARxdjD3HNdcpPcHL78m+vgNq5r3XUfFEVNcIgbhUzFV5xA8wTsQSuq5P/g+9FDX6qdFBQ2AMrTgJLYkz9m6dAveAss4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784554879; c=relaxed/simple;
	bh=zLmo2FIttzKvGbmRQyJkt+F1ymtKZum8SbbQCrq7rLo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gtcwHW+cLf1Vzk5lS9K7+svwvX4bKhqCbZDpVvyMPuMxYZmHQlxMdVWHtdbkBAoJQb9LC1MuMVEMC0Ttsssn7oEimsHQCfpucYr948iwVNcgHB0g3JqLYUROXEJB/v/TBsFaNUC1wA4Pootaoc6fhxaEw02pkHUCIXUJHb55cbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ujpWmPrG; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ujpWmPrG"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c15e2dab83eso1098031966b.1
        for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 06:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784554877; x=1785159677; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Y/kPz5ajPeR8UdBb+Kn3rMnPwkhqf5YXoddQSOq9Wck=;
        b=ujpWmPrGzWCWFpnWTzeH2X3CUzr0GRyVTY6seeySur6TJQSiQ0/a95ep8U4ofgsxUV
         7qMJ/ztE7/8C1ZocGlSed+4J59CO+fG2ETl12oucwf5kur0Pn3nTaXWu0myGopUr1BUD
         tSVoxfzaW5EJQE41Vaop5/5TfQwzTHSGHLb9e91aJK6pEzCKV+CtslDRxHyEX6QTi2b+
         0W1i0Uou7bRxZ1ry7EgRGtdRjjrNn7rqYlJztZ5BzRUXLKJpohHPNuw5xnVP48nj3biB
         v5qDlWbvArsq6jN2rtXj7e28IYfR0F5UfGPQTx8RSEWH+sP/o/2zGp7mLadCf9CqGMkW
         NkAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784554877; x=1785159677;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y/kPz5ajPeR8UdBb+Kn3rMnPwkhqf5YXoddQSOq9Wck=;
        b=rDu8zxzZQERHptVnGiJINFG7cuxGAn4+wur4S2ome7KCWSTe0vR/RYplDYQZ5RPQFh
         +EAKBmVBJ2H1XYDPQTTIb0IBGoHgXPU1mZeSIFD4LTKObAGLINQJvDRuJ0JIDvBDIEB/
         4nOnxBRZx1EQeR3xXJlnHhKqtpLrjj3NYYTFhO3b9sFWaYzclsXo9EAJTjZ52P7I+nyR
         jos1cF0Br7XDTKskshjPiziiSNsRmERicjqt8LoA7pNSDg/87isx7+g7I4dI4MFgZ+Xw
         ZG7ekuT6Wx3aJGBjEAqT3TUdSHpIeVlbbyeuxPPwDdCgCpuIHfofguG37DgEBz1P7ZwE
         jl+w==
X-Forwarded-Encrypted: i=1; AHgh+RpAN9f5KN4RnOnWAYK4TFb+6+T4hFaoXNXB2JnlhzOacrvXsAIju1qo9nClD7kRPz/sm8g2gH0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwQJRU/mDDA85UCOHmmwzhzGSKkgdyOJ0fRo1txGBC3wzB0YAwv
	KjSipyeQesNazIqhELfL7uhO6OTSqD2mePzPjktDeHCvU5/S4/AvcCf6Xv5M4DAbZg==
X-Gm-Gg: AfdE7cmkIvYFEgTR3bCmiTr/+JP2dgirlystMFoAsEUCJea9xhzHlCVgKMCxaJcyOlY
	giyCrmiQV63EBaBTlG+z3c1p/a64zTFBXwFqgLQxCFEM8yVBbxt0fRtgAWxCc4q09ZPJuY88Oge
	xdnou8aBCwK20QqPZCMBKot12MHrcG7alVKElHBFMYpz4+JLr9osuQblh1bGTT+6BJnsQ1YP0Xr
	HRK/64+Av0LPGbXT1lcPyzKvDwEaGbNPDpS/2TVoOKo551238hAsAFjOGbDeIDDObB6NfdKZEcB
	vU0w3KL0+SUFGWP5mM/y4Ok0G5EbkjAoVyq7o+p4LObjZ3llfekVRouPZAbV+Yk5S1ajTsI3nu5
	ENtKlThNxoKIjpI393TnYB94snw/74xo2huPq1vNjWMYSFuH0RCrxrGgji4H0reeVs4U6V85dJi
	wmhT/UBq/ko5P8tcpDgfvmZawhNcdXlMUs0tQwpX10wJa93fJynHE=
X-Received: by 2002:a17:906:7953:b0:c16:9d11:8f51 with SMTP id a640c23a62f3a-c16b48c8020mr590472366b.46.1784554876054;
        Mon, 20 Jul 2026 06:41:16 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c17361fc972sm465211766b.54.2026.07.20.06.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 06:41:15 -0700 (PDT)
Date: Mon, 20 Jul 2026 14:41:11 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kernel-team@android.com, qperret@google.com
Subject: Re: [PATCH v2 14/18] KVM: arm64: Use noclear for PGD in
 __pkvm_init_vm error path
Message-ID: <al4ldxSPH2MJKJcD@google.com>
References: <20260706175415.2604046-1-vdonnefort@google.com>
 <20260706175415.2604046-15-vdonnefort@google.com>
 <CA+EHjTyFavaVQ=bmo=1s9LgDVQftdsCELUudSza1ARZCJo+dqw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTyFavaVQ=bmo=1s9LgDVQftdsCELUudSza1ARZCJo+dqw@mail.gmail.com>

On Wed, Jul 15, 2026 at 01:09:12PM +0100, Fuad Tabba wrote:
> On Mon, 6 Jul 2026 at 18:54, Vincent Donnefort <vdonnefort@google.com> wrote:
> >
> > In the error path of __pkvm_init_vm(), use unmap_donated_memory_noclear()
> > instead of the clearing variant to release the donated stage-2 PGD back
> > to the host.
> >
> > This intends to eliminate the clearing variant of
> > unmap_donated_memory(), as zeroing the PGD memory before returning it to
> > the host is unnecessary in this failure path.
> >
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > index d9ab58226889..0c82f1ddb93d 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > @@ -861,7 +861,7 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
> >         kvm_guest_destroy_stage2(hyp_vm);
> >  err_remove_mappings:
> >         unmap_donated_memory(hyp_vm, vm_size);
> > -       unmap_donated_memory(pgd, pgd_size);
> > +       unmap_donated_memory_noclear(pgd, pgd_size);
> 
> 
> We spoke about this in person before you sent the series and I thought
> it was ok. Sashiko's review made me doubt at first, since the freed
> blocks carry EL2 list_head pointers that the noclear variant hands
> back to the host.
> 
> You mentioned that the mapping isn't secret (later when we discussed
> Sashiko's review in person), and I checked: kvm_compute_layout() runs
> at EL1 on the host and rolls the tag itself. The host already knows
> the PA of every page it donated, so it can compute those VAs anyway.
> So I don't think this is a real leak.
> 
> However, this relies on the pool and hyp_vm both being donated
> linear-map memory here. Once hyp_vm moves to hyp_alloc() in the
> private range, the free_area anchor becomes a private-range VA, and I
> haven't checked whether that's host-derivable.
> 
> Given it's the init error path and not hot, clearing costs basically
> nothing, so I'd lean towards just keeping unmap_donated_memory()
> rather than reasoning about derivability.
> 
> What do you think?

Happy to not take any risk and to drop it. It was just an attempt to simplify
the code anyway.

> 
> 
> 
> /fuad
> 
> >  err_unpin_kvm:
> >         hyp_unpin_shared_mem(host_kvm, host_kvm + 1);
> >         return ret;
> > --
> > 2.55.0.rc2.803.g1fd1e6609c-goog
> >
