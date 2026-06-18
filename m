Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9292E0413
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 10:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781777962; cv=pass; b=MeCcIqza6fdlm2+qjSABZaD3lzohIuDV2JRCvJpX1k9Q6z7EQv+69p8iI4uXXSaklwG+MJjPW3l12+RrXJ8CsQITejHMEKTtp+3vLYx6aYu6USzjh625h7HtcTpp2oPcMIroct2eNrFeswIw5fWlOnYGJASi+x3Dkkw/1pRX5qM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781777962; c=relaxed/simple;
	bh=Xr9ZbMLhectYO3rTK0D3joeR77dT7fyW4DMS28W3PxU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ywt3VNYeGbb5SP/c6s6Imw08bjk+w0/XfP7RNmUBEge5NKv2fIqwoLdDRyZm8/IwAtFOmUk7n/M2YDhGEQVwTfGCoRHxCmsDRYlKnS7s+Of1eG1jyO9mda8km07tFbpixvX+oEX1LaaJmhIHsRWLUU7WRQ0brWr5mEWmu/fsZb8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GEbdX3z8; arc=pass smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GEbdX3z8"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5ad4d840d43so4894e87.1
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 03:19:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781777959; cv=none;
        d=google.com; s=arc-20260327;
        b=igsirxtQlpL7sp15iYQFki8Eko9Y53Gf2ksGbZZe2pVo9NOv4anJoq/whALRrxftz+
         8T1Vj5jzWyieoOQFvOLJb+nnBeKK7vA0Hsmxn6K46ZSUztLMPaLpKJxhjHGa58LFr+fW
         /8iK+nyoYhPLFyf/2mBuWVM61s6wgmjXNkozfFf+oXOHpR0t290ZPAxkXJ4RgYJB0PdK
         gwu5caAc4y8MxH4YAgGl4nTNyNDbawIlJdpgQ2rN/o+ryTvdY9EsiMgg/tr6PaVlLYbb
         gBgFEEBwTXONk+h2Bfu+wzYPKu0uW/mChhazUMSyyqLmssrYgn4+vbqSc9pBJiYErvvg
         1YUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=0T7MVioxOqJtt2c5QhAul9oWeixmd9Ypl72khnmpGh0=;
        fh=DAc3MNA2wZlf9fGxSkN5MrEyang/0vYXJGnzsQcSSJ0=;
        b=kBVmJcxq3RQnUZIJNokHpXt47X/QRfGP9WJn7nKi2C9cb0IXj7g8zyl4wsp6Idm0Rq
         6Tgr6c3DY4A97tBMP5E81ceMKiRZgLVDlw4rMSKYWW8mtvG4CDP1kDhIbwIXNN+3aI2m
         Hzp/2bpOHgAAkhEwW2NJGFcfpjtxPx3u2LCkDD+iLlYo0GHpamVnKfoq5tW+hAUsIR6t
         8OPmRpaxlMavkyZPvaioiUm0MX5ntQUzQrb+asFgaAY7TcHcrA6pbKqJKuI+GvRU0Uzx
         iql5GBJojgxEGVnA9x/vuuuBuYg1w3lN/FQoGSlWBQXNzMLiXqyYK9K7v3dLrTu8HSoo
         0RGQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781777959; x=1782382759; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0T7MVioxOqJtt2c5QhAul9oWeixmd9Ypl72khnmpGh0=;
        b=GEbdX3z8l9ZX0b2nE1tvPB9+zcPdfTElUltCiwtvAgIWBqu0GpflATcI55AhkFmKks
         KAoRxGWfcIp6gdi39A6wnGOr46tJBRQNQgCaakyRX0YvWBW+Mo7JLE4rZahxZ0w5jvs/
         WGMf3GJolkAZw7QpvIU7B3vfjV/ucOf1cqiAC9kS7K5rrLeBXkqQGLaKSpZcyh1JyaDY
         w8Nqqbm/U25DCsF5ZvypQDMnUJ9E57Qy8gnwzP/HemL8BFZWe3ufQk6i/xjvQNG1KH/t
         xM3+iTXdiwkgOhdiNVtm0RNu08QsdZ2fCZr/x9dLFnFsY1lDSemgxCCdcZnFJe5RYk4n
         P5Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781777959; x=1782382759;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=0T7MVioxOqJtt2c5QhAul9oWeixmd9Ypl72khnmpGh0=;
        b=gzPzvwIxvlQ/sE9v5KNJ6tMRThrXFDV1SdIfIK6gJIyoOe/qrbQUP/aUVNx1fvpt7+
         m13Qf5eV5QJ8QpjvFsyuQipbc1tyG3w5lHqCnQRYVPnZZ77CFmSlEQVToIfZ4/+BdJfY
         bPvzKzlkqn9pGK9gHU+OM+YqXcN30odIZob+O+348xEGatWOf0c02s1aNycOyIKPvOTZ
         aNRJPM/GXNMMbatI9F7UQ1A6WOt1yD0RT6yPism/WPbzQEPdZjiMjXIpD11jizpVHawB
         vt2oe3XV73uD7UJQw3oymwdojWGx7m1J0qtfJmGC/KpuRB67kPESSpFYD9CN/xOXBTCV
         skUg==
X-Forwarded-Encrypted: i=1; AFNElJ/LdTblMV7oACN0y8QiM5+SB78UNnPf6WdjcCsigelr+DI3YgcwP5uX5pSK89AXPzVkWLwfde0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxOKra1KxOZRFA8CqNPZkyVyfnstjLSNvyo6tKq9ecot4R09vut
	MXfN4e+B8eeb1nNDd4ETfDCgJPL4TadOrysIn4ydG0WL21252TCddk+IpZGfCdkde1Dty7J5Vlh
	znhph5Yl4GjPTtVFKADqaHvNJoKWMtzNRyR9iQ7XX
X-Gm-Gg: AfdE7cmjXm+VMgSmg1s96ybIORs6JHl2GH/8//QM4T2IP0CL4kMGAmzM2kUhvyqfjkm
	i9D2qUQR4GeJyZgSssX8zmofqt+9tytMwccB89CTjc9vqZrw8nD+R7IW0GwSAd/oTV7JjkaL36M
	MeWOKDGmuPiKIAVsw5C3hu3L1ikARyKUn9+G+fZMlVVmx9jTZZpnes9dLCjLJii51aAhQJdELQM
	EOYb+wM4tNxwnejTJ0smcdqqMSx/NLmRoFV7LmDmfB7D7/AtxHDXnGu4Y5hlOw9Vnf5yNU7mQ==
X-Received: by 2002:a05:6512:3d1a:b0:5ad:4839:b289 with SMTP id
 2adb3069b0e04-5ad4eea2dfemr85294e87.11.1781777958357; Thu, 18 Jun 2026
 03:19:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260612065925.755562-1-tabba@google.com> <20260612065925.755562-12-tabba@google.com>
 <86fr2krw56.wl-maz@kernel.org>
In-Reply-To: <86fr2krw56.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 18 Jun 2026 11:18:39 +0100
X-Gm-Features: AVVi8CfjTVhiF9Kb7_RTtLmGC6nmCGGpZSCVKIx3kdcfq-Vfjr3lT9JfoaFLcnQ
Message-ID: <CA+EHjTzeSsLUj2FVxzFyTF1sNvit6U7v2szX0uo5m7f91_W2Qw@mail.gmail.com>
Subject: Re: [PATCH v1 11/11] KVM: arm64: Implement lazy vCPU state sync for
 non-protected guests
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Sebastian Ene <sebastianene@google.com>, 
	Per Larsen <perlarsen@google.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Jonathan Cameron <jonathan.cameron@huawei.com>, Hyunwoo Kim <imv4bel@gmail.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 18 Jun 2026 at 11:16, Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 12 Jun 2026 07:59:25 +0100,
> tabba@google.com wrote:
> >
> > pKVM copies a non-protected guest's register context between the host
> > and the hypervisor on every world switch, even when the host never
> > inspects it. Defer the copy: on entry, flush the host context into the
> > hyp vCPU only when the host marked it dirty (PKVM_HOST_STATE_DIRTY); on
> > exit, leave it in the hyp vCPU and copy it back only when the host needs
> > it, via a __pkvm_vcpu_sync_state hypercall on trap handling or at vcpu
> > put. A protected guest's context is copied as before, since lazy sync
> > only helps where the host is trusted to see the guest's registers.
> >
> > The PC is the exception: it is copied back on every exit so the
> > kvm_exit tracepoint reports the guest's real exit PC rather than the
> > value left by the previous sync.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_asm.h   |  1 +
> >  arch/arm64/include/asm/kvm_host.h  |  2 +
> >  arch/arm64/kvm/arm.c               |  7 +++
> >  arch/arm64/kvm/handle_exit.c       | 22 ++++++++
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 88 ++++++++++++++++++++++++++++--
> >  5 files changed, 115 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > index 043495f7fc78..6e1135b3ded4 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -113,6 +113,7 @@ enum __kvm_host_smccc_func {
> >       __KVM_HOST_SMCCC_FUNC___pkvm_finalize_teardown_vm,
> >       __KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
> >       __KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
> > +     __KVM_HOST_SMCCC_FUNC___pkvm_vcpu_sync_state,
> >       __KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
> >
> >       MARKER(__KVM_HOST_SMCCC_FUNC_MAX)
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index a49042bfa801..1ef660774adc 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -1113,6 +1113,8 @@ struct kvm_vcpu_arch {
> >  /* SError pending for nested guest */
> >  #define NESTED_SERROR_PENDING        __vcpu_single_flag(sflags, BIT(8))
> >
> > +/* pKVM host vcpu state is dirty, needs resync (nVHE-only) */
> > +#define PKVM_HOST_STATE_DIRTY        __vcpu_single_flag(iflags, BIT(4))
>
> Please don't add flags in random positions. Keep them grouped by
> type.
>
> Also, it is unclear to me whether this is really an input to the
> hypervisor (which is what iflags indicates), but rather a new type of
> flag that indicate some hypervisor-private state. May not be that
> important right now, but worth keeping in mind.

Will move it and come up with a better name/comment.

Cheers,
/fuad

>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
