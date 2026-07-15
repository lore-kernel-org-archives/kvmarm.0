Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF521331A63
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 11:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784114503; cv=none; b=AoTDZF5aUXD3S8SbHujWd4unGbGgXB77HTR+XkiMANsAOZFUdAXhqwQquEmrZXulZPs7xYnidqg3bOsf50X/fAyCSB/q93Uk0IEBuXPI60G0H8c0FrcTxX8xmYqjsNychfxGJp18ozZsYLNzEz28/Su2giIzzIgjRx5jnamG1OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784114503; c=relaxed/simple;
	bh=zjRJFc0fMMunqcORPqfH+M7qVy9GPREs6UeoJ0DLZNQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HA43RKOGYHPOft/IylSQXIo4a1Se9VnJqZqFgxLeZ2+gCfw/ilubxfcvzavqOn4J6eAYgFW+ocMFhBuimqOmhp7t5xG5s9ZsAibH2imPQg3KU1zbvmXy8qFPraN4bKU1g8nRvpqFxqCaMlQ1CPs2D0SC+yLsweEwJibtTGApads=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VuveKuRJ; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VuveKuRJ"
X-Forwarded-Encrypted: i=1; AHgh+RrF/gLOrfRijeBUvAGeVVcEZeLLHevIO0lLBZWA78FoOt9A/Wgwj1hPXUS/U7icPlReqEi0M2g=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784114499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g2xc5XImhz7yv/LH3/qlvK74Dh7JZH9qnVWu+RRjZYc=;
	b=VuveKuRJs7E0fk5mfh0V4EbyVsX/lcOlC1wAXZ7SvnOjGKWbAHgrE0dwwUAcsBURWC3iAs
	aVsALJSoTT6Hnxx8YJxDr94yFQ3mhS+qEJIIZfbeUYBBdB5sY058yWjGZm+KBrRJweF8mK
	NwL9+8S9jkwhaz92jZpwxEp6jnGKC2E=
X-Gm-Message-State: AOJu0YwNFL1y+CTssFNqpgAzpYSWYZCFamgHak245HUS+ltBKGtpjX4L
	0wWlhPFPUWoJZZ14LbPJ41iKHQ/mVWWD40Tk9Fh1fMVSN77AWIMdlj9DHOuI4oHtWTH7+ue3v1t
	6HumLoepphOpwmHwK5kKnMS5JWp3jOx2WBhW1bh7N
X-Received: by 2002:a05:622a:1803:b0:51b:fd21:c077 with SMTP id
 d75a77b69052e-51d7bd8c7aemr25509781cf.21.1784114490270; Wed, 15 Jul 2026
 04:21:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com> <20260706175415.2604046-12-vdonnefort@google.com>
In-Reply-To: <20260706175415.2604046-12-vdonnefort@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 15 Jul 2026 12:20:51 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwcz8T_RfgE46+xMKP_nz7Mi9rVCdhtnC2CbjtO1O5xCQ@mail.gmail.com>
X-Gm-Features: AUfX_mz1RLvH9JXOmIBy2vCcAXLuKzZgjvV33kiVgqna39ElIrdN_-tuf2FZors
Message-ID: <CA+EHjTwcz8T_RfgE46+xMKP_nz7Mi9rVCdhtnC2CbjtO1O5xCQ@mail.gmail.com>
Subject: Re: [PATCH v2 11/18] KVM: arm64: Add a shrinker for pKVM
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Mon, 6 Jul 2026 at 18:54, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> Integrate the pKVM memory reclaim interface with the host's memory
> management subsystem.
>
> This allows the host to automatically recover unused memory fom the
> hypervisor's heap allocator when the host is under memory pressure.
>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 50adfff75be8..3dc2b9d2c322 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -122,6 +122,8 @@ static bool vgic_present, kvm_arm_initialised;
>
>  static DEFINE_PER_CPU(unsigned char, kvm_hyp_initialized);
>
> +static struct shrinker *pkvm_shrinker;
> +
>  bool is_kvm_arm_initialised(void)
>  {
>         return kvm_arm_initialised;
> @@ -2526,8 +2528,8 @@ static void __init teardown_hyp_mode(void)
>                 }
>
>                 free_pages(kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[cpu], nvhe_percpu_order());
> -
>         }
> +       shrinker_free(pkvm_shrinker);
>  }
>
>  static int __init do_pkvm_init(u32 hyp_va_bits)
> @@ -2713,6 +2715,18 @@ static void pkvm_hyp_init_ptrauth(void)
>         }
>  }
>
> +static unsigned long
> +pkvm_shrinker_count(struct shrinker *shrink, struct shrink_control *sc)
> +{
> +       return pkvm_hyp_reclaimable(PKVM_TOPUP_HYP_ALLOC) ?: SHRINK_EMPTY;
> +}
> +
> +static unsigned long
> +pkvm_shrinker_scan(struct shrinker *shrink, struct shrink_control *sc)
> +{
> +       return pkvm_hyp_reclaim(PKVM_TOPUP_HYP_ALLOC, sc->nr_to_scan);
> +}
> +
>  /* Inits Hyp-mode on all online CPUs */
>  static int __init init_hyp_mode(void)
>  {
> @@ -2883,6 +2897,16 @@ static int __init init_hyp_mode(void)
>                         kvm_err("Failed to init hyp memory protection\n");
>                         goto out_err;
>                 }
> +
> +               pkvm_shrinker = shrinker_alloc(0, "pkvm");
> +               if (pkvm_shrinker) {
> +                       pkvm_shrinker->count_objects = pkvm_shrinker_count;
> +                       pkvm_shrinker->scan_objects = pkvm_shrinker_scan;
> +                       shrinker_register(pkvm_shrinker);
> +               } else {
> +                       kvm_err("Failed to register shrinker for pKVM\n");
> +               }
> +
>         }

Sashiko might be onto something here. The shrinker goes live in
init_hyp_mode(), but kvm_protected_mode_initialized isn't set until
finalize_pkvm()...

Cheers,
/fuad

>
>         return 0;
> --
> 2.55.0.rc2.803.g1fd1e6609c-goog
>
