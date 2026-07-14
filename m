Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400AA3126B9
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 17:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784051680; cv=none; b=fOXpP1RgPi52UaOu3DyKhylEkcSf8W3IiPrPQ0FwXJFJiszQYy9mx+kmf3uWMgLMyGnlSPk9+VD6YpmMjaoyDyQyovDIIPRnKh6flvvk7A4J0pE9+pYD+e6HDqQkUOAV8U277YSFtDK9TWwU+gP0/2Dyo5RVLeVPBx7WLM3cI5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784051680; c=relaxed/simple;
	bh=ZpVVebsI0yxw5WW2CxTkqmepFmTlatern8ksUkvw/30=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ta/Ro7PlRAC3DSTY5YJY6XNisILZwnG29LNJfjZtb4n0gopvKgHmaQrHFtcZHmzR8MqhDmifygMg+dbFPM6YRupg3pCYJGKPP4Ji3+i65DBnpzv6l9deABTgZGJqeSPjuJUwARukbxosGOGec8TdzjUmcjef5Gwh+ffwXa7QNN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OASUEUQk; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OASUEUQk"
X-Forwarded-Encrypted: i=1; AHgh+RrrPrtlha3b5r8gX4xbUObl9tKfMdlCB8f/A/z2fqFtTNiG1OsNaRytM1zULNXueWan8ybA2CI=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784051674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=10VT7gL+lmA+QIPWzvdgixXz8JOFpc48OxM2n67zUxY=;
	b=OASUEUQk4oeMT6HnQQkxIMAAUySXqYYtlO5t3zzN07jbzfq0sM5Vd7790upk6fD2NvBjKP
	67sAk1cRKL0k/TTz5HVAS+PmryqquQMtjKTmPcfQ9eX7JEndl1OPF2wwJ4vHiDH+SBqqYq
	3Zux09lqBqFVETOWj8t+YPrD9waNPXM=
X-Gm-Message-State: AOJu0YwRRaxJhcOG5AUhGHiSSFMFkBwBdXexJJpKjtuM1gSLx4DU6wk8
	4Cg/ZDuFJZk+nzCv6KZpZRKnW88BE5rqNpbptbMIQKpnYiIR4Dx3yOEonVIrkpZT9rh9B1tLzly
	Kb/wHyc0FNhBhv4/w+AEXnqD9J/j+bNEj8tlsotlo
X-Received: by 2002:a05:622a:4d47:b0:517:5e32:2d14 with SMTP id
 d75a77b69052e-51d7bc5094cmr17035731cf.10.1784051672252; Tue, 14 Jul 2026
 10:54:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com> <20260706175415.2604046-4-vdonnefort@google.com>
In-Reply-To: <20260706175415.2604046-4-vdonnefort@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 14 Jul 2026 18:53:55 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwMz+Ojq18Fq9USJqz_pZmemryNhy99Sw36sOejtpaf4w@mail.gmail.com>
X-Gm-Features: AUfX_mx9lqp3kjAw6qAWT5YzHWzZHDucv8goST7s8ZDRn3t91Ab_Li535_XJs6w
Message-ID: <CA+EHjTwMz+Ojq18Fq9USJqz_pZmemryNhy99Sw36sOejtpaf4w@mail.gmail.com>
Subject: Re: [PATCH v2 03/18] KVM: arm64: Add __hyp_allocator_map for the pKVM hyp
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Mon, 6 Jul 2026 at 18:54, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> In preparation for the pKVM heap allocator, introduce __hyp_allocator_map()
> to map a single physical page to a given virtual address in the hypervisor
> stage-1 page-table.
>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> index 725bb0fb941d..98a7774b541c 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> @@ -32,5 +32,6 @@ int __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
>  int pkvm_create_stack(phys_addr_t phys, unsigned long *haddr);
>  int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr);
>  phys_addr_t __pkvm_private_range_pa(void *va);
> +int __hyp_allocator_map(void *va, phys_addr_t phys);
>
>  #endif /* __KVM_HYP_MM_H */
> diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> index ec59da1322a7..c1c01f81ac5f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> @@ -160,6 +160,11 @@ void pkvm_remove_mappings(void *from, void *to)
>         hyp_spin_unlock(&pkvm_pgd_lock);
>  }
>
> +int __hyp_allocator_map(void *va, phys_addr_t phys)
> +{
> +       return __pkvm_create_mappings((unsigned long)va, PAGE_SIZE, phys, PAGE_HYP);
> +}
> +

nit: __hyp_allocator_map() is named for its caller rather than what it does
(map a single hyp page). Its siblings here (pkvm_create_mappings,
pkvm_remove_mappings) are named for the operation. Consider a name like
pkvm_map_page() so it reads as a generic primitive.

That said, naming is hard:

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

>  int hyp_back_vmemmap(phys_addr_t back)
>  {
>         unsigned long i, start, size, end = 0;
> --
> 2.55.0.rc2.803.g1fd1e6609c-goog
>
