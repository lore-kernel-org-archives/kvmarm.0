Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDDB3F9264
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 12:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784117406; cv=none; b=exXY42lPhxM8M484/WL/9NOH8gVNvFukqfJBMOli0dEnCzvCZlx8IXE9egcERs3jc6PFMLuoezGHVw5ZVyareCgWxkSKt4iM2oAb/jNXcDvHUFymd8wca7BhE589n+f4x7bTrBA7ijViq5msdMneWTzsInWodi/WWB+wf6QGPZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784117406; c=relaxed/simple;
	bh=VpWwj+Pa2xCTIMJxiK0sUS9dp3wYGaXvKKMnRqninKw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AmH8Ty3QGYNqugRFdTSwJwjur1u6J6olsALLVS5BkJaeqyPulrHhNlVSkIUfznn7Quyc4Rsw+0oBDBC2eOgASbYx4iN0N9Rv7Y7NYjpJ8FgvSH6S6JEkkbJ6HnozsV1AIA5ijS+3MZXGtHfRzhkiHm98ExWFdRj5tqPrRJTjIjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=E50Y5Ozl; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="E50Y5Ozl"
X-Forwarded-Encrypted: i=1; AHgh+Rqw7bJgaXyulfHvy+r2UykDDRAQhzs0Ev6bM+pnmSVqEkACpZ+ZrSpu4BzpggPtfMx/a9HENrY=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784117402;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qSZ5JB9zKtrIkO0EaAygHi+SrnAqqj+A/rbob9XSOYk=;
	b=E50Y5OzlVU6SM23BNZ4H55Y+JVLjYxcCdq+4R7uEH9eE8y9LOBl4a9+amPenTIsziN6Y/j
	gRestWlnYHPnk2UEz40jMm19s9sIEdx4BB+xjJc4lYVuIZ1jnRlRzSXUKU11VjgfQCRFGb
	IOlth7yqHDP1OUQreCo3wLC2YoUAX84=
X-Gm-Message-State: AOJu0YwYBSZ1IZ0XR/FCCHdwhGWlAjfTKBjHwHAf8EW2abGHWY+QcRG6
	kf0jwj4VmxqPg6+eJB3Y3FPMEERQNgDi8lsXOC2fWwSKJGAexr2lYgfGlJIsQ/WTbBtaKOTVzZm
	d7IJIvdSW2On90XyrnHCYx/dYTOHraYwwk3P2CnYe
X-Received: by 2002:a05:622a:5c12:b0:51c:7a8b:c3ff with SMTP id
 d75a77b69052e-51d7bdb83edmr25842211cf.24.1784117390174; Wed, 15 Jul 2026
 05:09:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com> <20260706175415.2604046-15-vdonnefort@google.com>
In-Reply-To: <20260706175415.2604046-15-vdonnefort@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 15 Jul 2026 13:09:12 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyFavaVQ=bmo=1s9LgDVQftdsCELUudSza1ARZCJo+dqw@mail.gmail.com>
X-Gm-Features: AUfX_mwz8PnRCmbDIQiL7DM9woWrklxzmZ2ssGxPRW2w8RFTYJWSLHIFabD23mk
Message-ID: <CA+EHjTyFavaVQ=bmo=1s9LgDVQftdsCELUudSza1ARZCJo+dqw@mail.gmail.com>
Subject: Re: [PATCH v2 14/18] KVM: arm64: Use noclear for PGD in
 __pkvm_init_vm error path
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Mon, 6 Jul 2026 at 18:54, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> In the error path of __pkvm_init_vm(), use unmap_donated_memory_noclear()
> instead of the clearing variant to release the donated stage-2 PGD back
> to the host.
>
> This intends to eliminate the clearing variant of
> unmap_donated_memory(), as zeroing the PGD memory before returning it to
> the host is unnecessary in this failure path.
>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index d9ab58226889..0c82f1ddb93d 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -861,7 +861,7 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
>         kvm_guest_destroy_stage2(hyp_vm);
>  err_remove_mappings:
>         unmap_donated_memory(hyp_vm, vm_size);
> -       unmap_donated_memory(pgd, pgd_size);
> +       unmap_donated_memory_noclear(pgd, pgd_size);


We spoke about this in person before you sent the series and I thought
it was ok. Sashiko's review made me doubt at first, since the freed
blocks carry EL2 list_head pointers that the noclear variant hands
back to the host.

You mentioned that the mapping isn't secret (later when we discussed
Sashiko's review in person), and I checked: kvm_compute_layout() runs
at EL1 on the host and rolls the tag itself. The host already knows
the PA of every page it donated, so it can compute those VAs anyway.
So I don't think this is a real leak.

However, this relies on the pool and hyp_vm both being donated
linear-map memory here. Once hyp_vm moves to hyp_alloc() in the
private range, the free_area anchor becomes a private-range VA, and I
haven't checked whether that's host-derivable.

Given it's the init error path and not hot, clearing costs basically
nothing, so I'd lean towards just keeping unmap_donated_memory()
rather than reasoning about derivability.

What do you think?



/fuad

>  err_unpin_kvm:
>         hyp_unpin_shared_mem(host_kvm, host_kvm + 1);
>         return ret;
> --
> 2.55.0.rc2.803.g1fd1e6609c-goog
>
