Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB72B377AB6
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 18:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784054259; cv=none; b=WLHQt3E9fFrOOdAXFT796ga2Dl4AZCEhurDtXQuBNiBombqBjRY+8L/5Wf4irLZGkRqQuuxwkY3iJIS/iH3r1ftyxO2I+Irtd84wH/hTCquGHRPFwcwpUvQxQ0ldJbnhFG256XuKdbZqF4JuyOKbIYUip/+87ATbIoID2eBxl8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784054259; c=relaxed/simple;
	bh=Fywnf0NhBe2rpVBRTr8CFqs8b3D72FSz2o3nmm3o6Cw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lQUY7b59UN4aB7Yjr7NVh6BrR5se0jfZsLWHFYLCT/G6iwVUvP8x6bEPy0s4dBse8d/w9xftZGxMCQekb8siaERoNvjE4LNU2MwqSekrzNdhBHFZXrAowv+jHeJzp1GKrD8bmHcnANf/8wOyP6VgUozkR0AG44a1V4WSJOQh7+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Bc50wHJH; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Bc50wHJH"
X-Forwarded-Encrypted: i=1; AHgh+RqDSYxc+Qlg+NcwRkQxvhamVPG7d2e5yft6UZCdmzVmfLEjI2LWOHfozWwjeLnLA4KCYWsJvaM=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784054215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HNZSBmfBDNmYrRJyHxAOlhjiIPet8aW1LhhHhsLWuDI=;
	b=Bc50wHJHgUK9w4irpCWjKX5v64PBYgc6YKYPWRcxXHzva3ZFfhKYPoqb0rf037KJpMAoA4
	uufhKEv+PfnNcfmaReKnOf3SxhJJhvclrieB2OcKEL/DD3dYHHdjcZcI4PzS+fhw/c3bzH
	V9es5kWABNHkGG/mw0jh0e4QvfHDsNk=
X-Gm-Message-State: AOJu0YwfYCTaiNWXxCa/32+0TqMFOgwKfJ7Dp2HgwmmolMlBhuwFerA1
	0aciu+U7iBLcVFAiePB0cTw98W3ptrFQH5A9xgDYcwSZATIbJ0hXz3DZFe2dpVuhXSqy/7w0Ula
	8UrNhjpudyIxgLDi6oC9UszRMxvcG4qnHpIPauhJO
X-Received: by 2002:a05:622a:5811:b0:516:d25f:f038 with SMTP id
 d75a77b69052e-51d7bcdc629mr19496341cf.10.1784054209379; Tue, 14 Jul 2026
 11:36:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com> <20260706175415.2604046-5-vdonnefort@google.com>
In-Reply-To: <20260706175415.2604046-5-vdonnefort@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 14 Jul 2026 19:35:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzbQukkKpNfdTHKS5aAPCn4hnCxu+EHnm6OWpW=mTS+Gw@mail.gmail.com>
X-Gm-Features: AUfX_mwujOVFYFITNMrHijW4eH9F2RFdyBeop_XKVBPHf6u1glhbNBh1Runw6Wo
Message-ID: <CA+EHjTzbQukkKpNfdTHKS5aAPCn4hnCxu+EHnm6OWpW=mTS+Gw@mail.gmail.com>
Subject: Re: [PATCH v2 04/18] KVM: arm64: Add a heap allocator for the pKVM hyp
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Mon, 6 Jul 2026 at 18:54, Vincent Donnefort <vdonnefort@google.com> wrote:

...

> +static u32 chunk_hash_compute(const struct chunk_hdr *chunk)
> +{
> +       u32 hash = 0;
> +
> +       BUILD_BUG_ON(sizeof(*chunk) != 16);
> +
> +       hash ^= hash_64(*(const u64 *)chunk, 32);
> +       hash ^= hash_32(chunk->__unmapped, 32);

Could you state the threat model in the commit msg? The VA range is
hyp-private and the hash is unkeyed (anything that can write EL2
memory recomputes it), so this only catches _accidental_ corruption,
i.e. a debug aid.

Since that's the goal, should it be gated on CONFIG_NVHE_EL2_DEBUG
like the other checks here? As written it's O(n) hashing per
hyp_alloc(), in production, for a check that only fires on a hyp bug.
And a plain XOR/additive checksum would be cheaper and just as good
for accidental corruption.

> +       return hash;
> +}
> +

...


> diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> index 75b00c323310..1c10cf78c869 100644
> --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> @@ -10,6 +10,7 @@
>  #include <asm/kvm_pgtable.h>
>  #include <asm/kvm_pkvm.h>
>
> +#include <nvhe/alloc.h>
>  #include <nvhe/early_alloc.h>
>  #include <nvhe/ffa.h>
>  #include <nvhe/gfp.h>
> @@ -363,6 +364,10 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long *per_cpu_bas
>         if (ret)
>                 return ret;
>
> +       ret = hyp_alloc_init(SZ_128M);

Where does 128M come from? A comment would help.

Cheers,
/fuad



> +       if (ret)
> +               return ret;
> +
>         update_nvhe_init_params();
>
>         /* Jump in the idmap page to switch to the new page-tables */
> --
> 2.55.0.rc2.803.g1fd1e6609c-goog
>
