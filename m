Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9E647CA80
	for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 16:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784824230; cv=none; b=VlkbsNgMuMcnotnvjRHxMF9A6aL2uSYwx9h+NW0rIy6kgcF4ieVI22Ww2TLUl/1tlCuMFt/uMryY8dLBDg9PQNm+MlNp36Jcwcd12jQqY5YSU+am/a+ztynvQDItE95gel5jeypI6b79XS92txZ/jBKSf7HNy4iInxARMDbVgzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784824230; c=relaxed/simple;
	bh=eqcqk9WLljubatE22m5POuO+n6ynnNiOo3dFq3scve4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aOZ6geLMrGKOLuz7DnmsNrZvCwqEu1mcTjby70sUXzZGIhQyo47qsB0tSWfm3Kn0m0FgbEwLyF+hRapGR0vCiWz+oa8JDATT9JpKHIFIwVG2cPJze91PvraYc7XC7ahA0Ykvc8EPwtxD5KH2i+0SU7SlRHo7jb8jLcxzJkxkS+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JgcnIApD; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JgcnIApD"
X-Forwarded-Encrypted: i=1; AHgh+RrG7k7M1FtsDc263QwtZrffG7J91kyel1tgR7hKIvPpurMYBQOJX8gkfId0K4OntQv008K9cb4=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784824225;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gl83NMyq+s3gbl2Tp74bU9xdnH6nJ4JMTF1QkNTBKrk=;
	b=JgcnIApDZnqO79gnVjbtV1+Rs6IMLqsM0hlb1pPabikalkjPx9mrtYkJKbAf07y/FzmMcZ
	NX7EAtwLnNmCinntiOwxZX8j61t4H5kopZhDLeY91P20QXVckLY9wgQwUMtIGt9Y4vllwn
	7lLvE8N3U5CYihFN8Txd/Ny9BuM5wm0=
X-Gm-Message-State: AOJu0YwLum4MdSUy6YP7RBwOWiD89aNZkorgrgUEchew9xuFI8nOydTU
	UUn6mMDeevbeMcgxJBTiBZoyOoUZ3mQnYkiGJo/fAZ1fNRDnSOjAR4+yuLe32VJj7gESnRHywJv
	qLWRXQBWAYbbQmq/HjhLoeHmqv4igpEuetZNSaP3r
X-Received: by 2002:a05:622a:134c:b0:516:3f51:81cb with SMTP id
 d75a77b69052e-5283d81a915mr9160761cf.13.1784824207475; Thu, 23 Jul 2026
 09:30:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723162002.3848054-1-smostafa@google.com>
In-Reply-To: <20260723162002.3848054-1-smostafa@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 23 Jul 2026 17:29:30 +0100
X-Gmail-Original-Message-ID: <CA+EHjTx0fU8uL0pop=faUv7PW9=8dS1CHbn0DdMQdHcCwxOefw@mail.gmail.com>
X-Gm-Features: AUfX_mxA_nKRECz2-8RwfmQfgOzLkEwARqpAv0FN4JNQqX6QCq1Eo0mlzwuphto
Message-ID: <CA+EHjTx0fU8uL0pop=faUv7PW9=8dS1CHbn0DdMQdHcCwxOefw@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: arm64: Optimize protected mode with FWB and DIC
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, maz@kernel.org, oupton@kernel.org, 
	seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Thu, 23 Jul 2026 at 17:20, Mostafa Saleh <smostafa@google.com> wrote:
>
> KVM opportunistically enables FWB if supported by the system for guest
> VMs, which allows it to elude cache maintenance for data as they are
> forced to be cacheable from stage-2.
> In that case, __clean_dcache_guest_page() will immediately return.
> However in protected mode, before calling __clean_dcache_guest_page()
> it loops over the range and fix_map/unmap it, issuing TLB
> invalidations, dsb() and isb() unnecessarily.
>
> This can be optimized by returning early if FWB is supported,
> kvm_pgtable_stage2_map() already issues dsb() and tlb invalidation
> functions issue dsb() for the unmap path.
>
> Similarly for DIC, we can omit the call in
> invalidate_icache_guest_page()
>
> No isb() needed as ERET is context synchronization event.
>
> Signed-off-by: Mostafa Saleh <smostafa@google.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad


> ---
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 4e329e39a695..39aa8911f62c 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -261,11 +261,18 @@ static void __apply_guest_page(void *va, size_t size,
>
>  static void clean_dcache_guest_page(void *va, size_t size)
>  {
> +       /* See comment in __clean_dcache_guest_page() */
> +       if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
> +               return;
> +
>         __apply_guest_page(va, size, __clean_dcache_guest_page);
>  }
>
>  static void invalidate_icache_guest_page(void *va, size_t size)
>  {
> +       if (alternative_has_cap_unlikely(ARM64_HAS_CACHE_DIC))
> +               return;
> +
>         __apply_guest_page(va, size, __invalidate_icache_guest_page);
>  }
>
> --
> 2.55.0.229.g6434b31f56-goog
>
