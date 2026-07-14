Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC123417BD4
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 17:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784051353; cv=none; b=PYlJtw8v/uEKZrCjvK0vi/Dx2KCYh5zxuk2mtafi7cXXGx7dA9EGJPnlstKO+2I2MBP1HQ76rzNJsOS5Bsm1u0MmbTwFCyehoXfHoRqnConeHCRG1oq01saqUUCBsBImTDBL6QUWAx9/scvxea05GA5/PDoe2WAF61RELMr4jp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784051353; c=relaxed/simple;
	bh=JfAbCkEFsOPWfPBQGypiRwo78nH7XDUnBSBOLeNQN8Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z0SibTPE2wubI7++nxmG90jiklW1ygj0koYQGCLXGW4qW/UsgNQNyqwOstXu78F3u6pw562P3zea6gnK8BHvdwcJ8pQuX4SRtPFd9ghJRUX0hd0h2EpjlcEfslp+dRwMbkKrIAPCTevqEFMBAErgAL5r5ZeyYefDjwvEV1bT6RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OzzFKpQo; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OzzFKpQo"
X-Forwarded-Encrypted: i=1; AHgh+Ro0nYkPziwtU5stfs1B4E/INgzomixBd9N9SOR/BSZFCSQCi+Gu6LvFjpKGFDYOy2nPdLyZLIE=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784051334;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cmz5eXxPx0qgl3ng7iAKomOvPAZo+1HLYOuh5tFme5I=;
	b=OzzFKpQoRL+Fyg4CRGkuBzuPM/sFxihA/FSWMhvsfS6Ksz5jJmqxJSJfpYcUwkK9XqqjGY
	OvGSoCcyz+4vjZ9xqctsgwtWij5BEHbRk6Vvf2KiI5KxYhc8FcXuzd05GDF/RbFscaDT9f
	spBis6YdGIODjU9Eis5QVVCO+3J0fbk=
X-Gm-Message-State: AOJu0YyNhxOWNBcqZTB1Ebox841p1ckb1sp8iDiQPFD/2op5BDP/3RGl
	/mx+kGaWxra3A/XuPDquvYIX0LbiIIIPaydJmYb5L2L6Hi+kyEWbO28hOp3S3P2mwj+GDP+lwx7
	K6my57d0ue2DjxbK7MWH9twp/cNZ7Y9WQueFtO40f
X-Received: by 2002:ac8:7d0b:0:b0:51c:7a90:a797 with SMTP id
 d75a77b69052e-51d83845eafmr17464581cf.23.1784051329702; Tue, 14 Jul 2026
 10:48:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com> <20260706175415.2604046-3-vdonnefort@google.com>
In-Reply-To: <20260706175415.2604046-3-vdonnefort@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 14 Jul 2026 18:48:12 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwAs6C1Yes4faiGkEo_0ryW4Vr-3e_q0xxKpWpuuS4pmg@mail.gmail.com>
X-Gm-Features: AUfX_myKMm_rXrImC7y2DgTClP124-2IwTOiSDsHgDt8Uxb8A98F_Li2Irk5mZA
Message-ID: <CA+EHjTwAs6C1Yes4faiGkEo_0ryW4Vr-3e_q0xxKpWpuuS4pmg@mail.gmail.com>
Subject: Re: [PATCH v2 02/18] KVM: arm64: Add pkvm_remove_mappings
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Mon, 6 Jul 2026 at 18:54, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> Add the counterpart to pkvm_create_mappings(), allowing previously
> mapped ranges to be removed. This will be useful for the upcoming pKVM
> heap allocator to manage its private mappings.
>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> index d3137c16b632..725bb0fb941d 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> @@ -25,6 +25,7 @@ int hyp_back_vmemmap(phys_addr_t back);
>  int pkvm_cpu_set_vector(enum arm64_hyp_spectre_vector slot);
>  int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
>  int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot);
> +void pkvm_remove_mappings(void *from, void *to);
>  int __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
>                                   enum kvm_pgtable_prot prot,
>                                   unsigned long *haddr);
> diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> index 773426a68d2d..ec59da1322a7 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> @@ -146,6 +146,20 @@ int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
>         return ret;
>  }
>
> +void pkvm_remove_mappings(void *from, void *to)
> +{
> +       u64 size;
> +
> +       to = PTR_ALIGN(to, PAGE_SIZE);
> +       from = PTR_ALIGN_DOWN(from, PAGE_SIZE);
> +       size = (u64)to - (u64)from;
> +       WARN_ON(from > to);
> +
> +       hyp_spin_lock(&pkvm_pgd_lock);
> +       WARN_ON(kvm_pgtable_hyp_unmap(&pkvm_pgtable, (u64)from, size) != size);
> +       hyp_spin_unlock(&pkvm_pgd_lock);
> +}
> +
>  int hyp_back_vmemmap(phys_addr_t back)
>  {
>         unsigned long i, start, size, end = 0;
> --
> 2.55.0.rc2.803.g1fd1e6609c-goog
>
