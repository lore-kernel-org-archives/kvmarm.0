Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286AF1DAC65
	for <kvmarm@lists.linux.dev>; Fri,  2 Aug 2024 11:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722597377; cv=none; b=aJwzl4XgFxoxgKgbi+ZWP6ZAfTCdDYuRW1Osbn69NvVoo5rNTvjS/OBGiyrHW2Wu0Airylds8MzOQaXC3sL4OrbauN7YDxMaA2HJ1E/7z9PWrRBhu8nm/VQMW0YlJdjpwl7tM6TvlgeQYw/ncL0quFKsS+xn1YbuLatBYVRw0WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722597377; c=relaxed/simple;
	bh=5/L0Yc2Z+AOSOKZw3/Dotf6pZ+cloK9IZVwKZGtH7AE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=bWH36oY8TjlAgG5WpDxidzN3jWnvZeIidbTwSFby89m3Jm+qk1wYz/hUu++5y+moXv8i2obWgNzHmcn2Dyv8m2OUuXg8DIurvWGP1KwhehN9fX7UivneZKGjOqi7MFI0ymLPmjT2WBb7LkshxsKkh/ABjSr+ws7kEZ1XlVlcZ+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=REymIrjO; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="REymIrjO"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5af326eddb2so5439388a12.1
        for <kvmarm@lists.linux.dev>; Fri, 02 Aug 2024 04:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722597373; x=1723202173; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h+a+YbUYnYp2O9o3vDX++ZHVr+zNy81A/L7Ak8HFY0M=;
        b=REymIrjO6nz8wh62hISnn4LImQPpjFqsUw8yhtlO6qeC0I9bgSWxKozVCOCE0hBxcn
         3BzwHdOKC/9Rci/92rYO3hkxjj74RtkvwcnTN3Mx0spXMn85Bsv4MZsbruZ2kJhDYCtm
         dWnnIRp46D/R0T5Y0oHZ/WssjT34nN5dr+SVBNxU0g/K8vQp7k64sk53qyTSkbHoOOym
         k3tbe+rrfFXRPG8ic6lH3kGDVvLwA3W1a4EGp9ye+wuHLIlJccbQ6I6H7UQyYRDEUQ5k
         hbd+K8lGzCxIa+Tfmogw6szFwAPPxZ2iJt78gCo9oe5/1yJQuG3N/0nr2G0g/fKXHyOU
         oWBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722597373; x=1723202173;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h+a+YbUYnYp2O9o3vDX++ZHVr+zNy81A/L7Ak8HFY0M=;
        b=ejx4z98YhPpRYUjtmqigUOvFzI404yOW6lnaV0jWNXqYrOPlLyiFU0HxHyyPzHnYhk
         v+bNawU0OQmtnC1mCzkkaabBFoyJgTvyY1ORzQva/owvoRGV0EnjgxxGe1DiUTdvP7Fa
         o1piJ5uQR1Or2Jom3AyDlChOijvnaXhgAvf23xBeMwnbLTSuzYpdnAI7vLgneFxrnsJ0
         85HRBeOqBghSQttcLmluplWFAOoS4pe6Ihn2dVJ2xdVtM9cgGEE3WGiHpsYysfQFujC8
         lx3wgIaZQoE4Ed+77YmrL4DhAaR2vSF4JNWemcI4gXXsk30lZzEN0EwjG8JNQhOobN+W
         q/2A==
X-Forwarded-Encrypted: i=1; AJvYcCWNKU3CURunjYR8GMaecQjudJ6fUVpQsA+1qjSaaxn4UKVqF1/Q7K3XtB1CJe+roSL1a/ROnr3/XNPwXdxl1AgzMI/8CdVh
X-Gm-Message-State: AOJu0YzUFViJZSXvTPyEbC8gtffZfPh7W1IXtzafUqdpqy+fFGZoDOd9
	0tmNlMmWcphCAPesPAlvm2mPp+3JeEtCGjL/5YMrbmBXFeJN7vtXmyWpN3Uu8Pg=
X-Google-Smtp-Source: AGHT+IHUr2+eigMQMyKiFV2SC/+LcUpbtIeuSXGg+vhEQqD67tJuIK6amWVCFT4RRO+CzEGYIGxtXA==
X-Received: by 2002:a17:907:25c5:b0:a7a:acae:340b with SMTP id a640c23a62f3a-a7dc628bf8fmr256404766b.31.1722597372903;
        Fri, 02 Aug 2024 04:16:12 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7dc9bcb19csm87224666b.42.2024.08.02.04.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Aug 2024 04:16:08 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 91DEE5F8A9;
	Fri,  2 Aug 2024 12:16:04 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  Marc Zyngier <maz@kernel.org>,
  Oliver Upton <oliver.upton@linux.dev>,  Tianrui Zhao
 <zhaotianrui@loongson.cn>,  Bibo Mao <maobibo@loongson.cn>,  Huacai Chen
 <chenhuacai@kernel.org>,  Michael Ellerman <mpe@ellerman.id.au>,  Anup
 Patel <anup@brainfault.org>,  Paul Walmsley <paul.walmsley@sifive.com>,
  Palmer Dabbelt <palmer@dabbelt.com>,  Albert Ou <aou@eecs.berkeley.edu>,
  Christian Borntraeger <borntraeger@linux.ibm.com>,  Janosch Frank
 <frankja@linux.ibm.com>,  Claudio Imbrenda <imbrenda@linux.ibm.com>,
  kvm@vger.kernel.org,  linux-arm-kernel@lists.infradead.org,
  kvmarm@lists.linux.dev,  loongarch@lists.linux.dev,
  linux-mips@vger.kernel.org,  linuxppc-dev@lists.ozlabs.org,
  kvm-riscv@lists.infradead.org,  linux-riscv@lists.infradead.org,
  linux-kernel@vger.kernel.org,  David Matlack <dmatlack@google.com>,
  David Stevens <stevensd@chromium.org>
Subject: Re: [PATCH v12 11/84] KVM: Rename gfn_to_page_many_atomic() to
 kvm_prefetch_pages()
In-Reply-To: <20240726235234.228822-12-seanjc@google.com> (Sean
	Christopherson's message of "Fri, 26 Jul 2024 16:51:20 -0700")
References: <20240726235234.228822-1-seanjc@google.com>
	<20240726235234.228822-12-seanjc@google.com>
Date: Fri, 02 Aug 2024 12:16:04 +0100
Message-ID: <87frrncgzv.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Sean Christopherson <seanjc@google.com> writes:

> Rename gfn_to_page_many_atomic() to kvm_prefetch_pages() to try and
> communicate its true purpose, as the "atomic" aspect is essentially a
> side effect of the fact that x86 uses the API while holding mmu_lock.

It's never too late to start adding some kdoc annotations to a function
and renaming a kvm_host API call seems like a good time to do it.

> E.g. even if mmu_lock weren't held, KVM wouldn't want to fault-in pages,
> as the goal is to opportunistically grab surrounding pages that have
> already been accessed and/or dirtied by the host, and to do so quickly.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
<snip>

/**
 * kvm_prefetch_pages() - opportunistically grab previously accessed pages
 * @slot: which @kvm_memory_slot the pages are in
 * @gfn: guest frame
 * @pages: array to receives page pointers
 * @nr_pages: number of pages
 *
 * Returns the number of pages actually mapped.
 */

?

>=20=20
> -int gfn_to_page_many_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
> -			    struct page **pages, int nr_pages)
> +int kvm_prefetch_pages(struct kvm_memory_slot *slot, gfn_t gfn,
> +		       struct page **pages, int nr_pages)
>  {
>  	unsigned long addr;
>  	gfn_t entry =3D 0;
> @@ -3075,7 +3075,7 @@ int gfn_to_page_many_atomic(struct kvm_memory_slot =
*slot, gfn_t gfn,
>=20=20
>  	return get_user_pages_fast_only(addr, nr_pages, FOLL_WRITE, pages);
>  }
> -EXPORT_SYMBOL_GPL(gfn_to_page_many_atomic);
> +EXPORT_SYMBOL_GPL(kvm_prefetch_pages);
>=20=20
>  /*
>   * Do not use this helper unless you are absolutely certain the gfn _mus=
t_ be

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro
