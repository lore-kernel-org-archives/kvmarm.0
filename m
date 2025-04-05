Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993944C62
	for <kvmarm@lists.linux.dev>; Sat,  5 Apr 2025 00:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743813149; cv=none; b=dsJYntBMA5Ppo1bsn2QWAQ21BiTs2JqgAB098s4xpdslKyvDZhzjcTC2r+mnQvp+UKfkmtS2MGAx9FhapV6PkFua62MHyPUhsZeaDv+IG03cDs2lWR/2nFAFnRLYX+lbYYOqikXBawSmMrcgOV10ZV49V1IXouYlFZSIauPA+Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743813149; c=relaxed/simple;
	bh=Sp6+0cwU9/FKMgxRKFjmZLvuoauBZNCxKbw0Q3jR9Vo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fg6OjiOZEH1wFKfKYWRoj0dm9Da+82oVVqkEtWeAiDrhSZiGSlSqNxL8niLcAcwPF0H/52IMnN2f8yLoaU7XuE18JoT1x0zvrOo6joUmh5gkQ6TkKCA0mKDobEjmQwJBEaiOZzdYF4a0GPqJNFEfdwj8ZhWj9mgobo7AbGe3V2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lrV0AWSF; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lrV0AWSF"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6e17d3e92d9so22942666d6.1
        for <kvmarm@lists.linux.dev>; Fri, 04 Apr 2025 17:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743813146; x=1744417946; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pG5OgA5u3r7SWYVRvl04U+VJKzgkH/slr5SK5HxcIr8=;
        b=lrV0AWSFaxrbSWalfbUZtNDtcdMy5pEj4xDkeClC7Uqjk2Lr0erIbJ2n+xIwDHaOMg
         NR514Aizd5yyq4mepE7mE6yoO6oz7h1VCblwrWKdTRtHi9kUN6lq2AYWyAGiz69JOwVC
         HcjDBAqATYXNpzbCOx2YSB78U9Fi4NSqfpl0v7aQSACfd3YPNtN0YTWHBwne9Nmeu0CH
         GhCYIJdzykP1I+N4/9O8rvuoUF5yim3NRr1jLeTE+NlBgpiBCQSm9JkKmbjWXn8YuyJY
         gw89np6fcqrsYfbgtigA03cN5WkZ2US0MUUPDhuBWWLZ1oSm5F0shlcbY0vcrjhUhzhg
         sM/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743813146; x=1744417946;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pG5OgA5u3r7SWYVRvl04U+VJKzgkH/slr5SK5HxcIr8=;
        b=b7cUCnh8PvffjrJUv2wMc/SsH/YHSaF+Pyy/fNTPDuVTAbUCS6H8Jstps9ywFREAeC
         sSuwvzjEcV4Uzbaw8Lw5SdkiFqjx08KwCbs6N6uqGHfJc1hjHYFfWyXDWAatPBZONrgH
         1OsrFz8lo+S93sVWh7AcVZHV1jbL/xtw/giopwutezQbYD6a0RRBBK6BHt1xv0vtMRU7
         bctPJb03QmMGHBV31UTWADRPlR+ph4BTP1hizFWtVlF6fZRkjPiTGlETKULPudub16lF
         u8rt2TSLKIeXWStxPAdcHDj/BJRZXvdLxX7bBibSzbLubwHV595iz6No5XGaAtmk5Svj
         mpJQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJGUmvlwBu0xfUEo/cCeMw89Z+Hd3IChsjsR8sLrlzP6FJ+Nd3i6Ltnp9Uqhp1LuRyyW1ozgg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzPIWQqr+U2zGMsZQMFYtRRmkeG2Uyuo7crbc7p53DgpAnj5DG9
	4Q+Yo1O2ci4R1no3TK0T/b2ImMy43Zt3PeCQP59O/ymvc71Je0dRHw/Nl4WC1FHhpXwwXC2gvbk
	AdJG6i2cXjZ+aUvL84lxL+4FLT2Z1iG4utdar
X-Gm-Gg: ASbGncsZYqBYbGh+h44JO8TeQw5quZ7U4HXybmSCAUVqtUPPQBcg0hIBVXlR68m8GA5
	59Z8oqT5yeMI6dyJUb/Fx+sQPDXZkiCH4aV/YOQZOUJViDpEMmyEuACMuoAwTdamMjxEznaopUu
	Rlw/WLeVYlrJQela/u9b6mRxlKYTBT
X-Google-Smtp-Source: AGHT+IFdsVd/lCa/5EHlC59IfCvD5ejt4ymZP3PtjMovWWTZHQUVaynKa8ekIZOHGPXU7kyqQ3Dv7qIk0/P6Afy4pSo=
X-Received: by 2002:a05:6214:212e:b0:6e8:f4e2:26e1 with SMTP id
 6a1803df08f44-6f00deededemr91976776d6.20.1743813146236; Fri, 04 Apr 2025
 17:32:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250405001042.1470552-1-rananta@google.com> <20250405001042.1470552-3-rananta@google.com>
In-Reply-To: <20250405001042.1470552-3-rananta@google.com>
From: Mingwei Zhang <mizhang@google.com>
Date: Fri, 4 Apr 2025 17:31:49 -0700
X-Gm-Features: ATxdqUEh8xXy0f-Tg56BnLvVp3zRksb0Z3WI3QPNIi_wEpzrRIgGyHaX6LOUeOs
Message-ID: <CAL715WKaAHSgUhtMMT3Ztw90mMoHpVLdKUgVM15xx6yoUws9+Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: selftests: arm64: Explicitly set the page
 attrs to Inner-Shareable
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

.

On Fri, Apr 4, 2025 at 5:10=E2=80=AFPM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> Atomic instructions such as 'ldset' over (global) variables in the guest
> is observed to cause an EL1 data abort with FSC 0x35 (IMPLEMENTATION
> DEFINED fault (Unsupported Exclusive or Atomic access)). The observation
> was particularly apparent on Neoverse-N3.
>
> According to ARM ARM DDI0487L.a B2.2.6 (Possible implementation
> restrictions on using atomic instructions), atomic instructions are
> architecturally guaranteed for Inner Shareable and Outer Shareable
> attributes. For Non-Shareable attribute, the atomic instructions are
> not atomic and issuing such an instruction can lead to the FSC
> mentioned in this case (among other things).
>
> Moreover, according to DDI0487L.a C3.2.6 (Single-copy atomic 64-byte
> load/store), it is implementation defined that a data abort with the
> mentioned FSC is reported for the first stage of translation that
> provides an inappropriate memory type. It's likely that Neoverse-N3
> chose to implement these two and why we see an FSC of 0x35 in EL1 upon
> executing atomic instructions.

nit: It's likely that Neoverse-N3 chose to implement this option (the
first option) instead of reporting at the final enabled stage of
translation

I have minor question here: The DDI0487L C3.2.6 (Single-copy atomic
64-byte load/store) mentioned

"""
When the instructions access a memory type that is not one of the
following, a data abort for unsupported Exclusive or atomic access is
generated:

=E2=80=A2 Normal Inner Non-cacheable, Outer Non-cacheable.
"""

So, the above is the "Normal Inner Non-cacheable", but in our case we
have "Normal and non-shareable" in stage-1 mapping, right? I know it
is very close, but it seems the situation is still only "one bit" away
in my understanding...

>
> ARM64 KVM selftests sets no shareable attributes, which makes them
> Non-Shareable by default. Hence, explicitly set them as Inner-Shareable
> to fix this issue.
>
> Suggested-by: Oliver Upton <oupton@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  tools/testing/selftests/kvm/include/arm64/processor.h | 1 +
>  tools/testing/selftests/kvm/lib/arm64/processor.c     | 3 +++
>  2 files changed, 4 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tool=
s/testing/selftests/kvm/include/arm64/processor.h
> index 7d88ff22013a..b0fc0f945766 100644
> --- a/tools/testing/selftests/kvm/include/arm64/processor.h
> +++ b/tools/testing/selftests/kvm/include/arm64/processor.h
> @@ -113,6 +113,7 @@
>  #define PMD_TYPE_TABLE         BIT(1)
>  #define PTE_TYPE_PAGE          BIT(1)
>
> +#define PTE_SHARED             (UL(3) << 8) /* SH[1:0], inner shareable =
*/
>  #define PTE_AF                 BIT(10)
>
>  #define PTE_ADDR_MASK(page_shift)      GENMASK(47, (page_shift))
> diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/te=
sting/selftests/kvm/lib/arm64/processor.c
> index da5802c8a59c..9d69904cb608 100644
> --- a/tools/testing/selftests/kvm/lib/arm64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
> @@ -172,6 +172,9 @@ static void _virt_pg_map(struct kvm_vm *vm, uint64_t =
vaddr, uint64_t paddr,
>         }
>
>         pg_attr =3D PTE_AF | PTE_ATTRINDX(attr_idx) | PTE_TYPE_PAGE | PTE=
_VALID;
> +       if (!use_lpa2_pte_format(vm))
> +               pg_attr |=3D PTE_SHARED;
> +
>         *ptep =3D addr_pte(vm, paddr, pg_attr);
>  }
>
> --
> 2.49.0.504.g3bcea36a83-goog
>
