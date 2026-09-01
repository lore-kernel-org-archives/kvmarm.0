Received: from mta1.migadu.com (out-49.mta1.migadu.com [95.215.58.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12DD32BEFF5
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 17:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788283818; cv=none; b=t1ZowydgR/FK9ZDKBPu2Ef4VnUxBzlMkAnueoI1QIs8+xnKUjBn1C+XbbJ2aQ1ILrZziG6yz67d7o/KJveinzomD7/T3sSLMyB+47Flc/dLVAYEI1xogH4mKvbUUZyaKxtwPgPWNOoQGjHLPxkAgy/a1pBVCmiITlMZ8kP76UOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788283818; c=relaxed/simple;
	bh=ULSR5be2YtUyyk60Ms2Rw0/VkY/Y5pS/9BTkgu36FE4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o6watzQ6ef/2ZBhJfxlzEZUN0C5bOxcJgli359pHos1DNbfkvAWLp/UbCPJLViwX2K5m8WJlVZXGXOwiA/85Qv2M/xtYHz2IVSZdHSszC1XZtvFtSFeTvl7l9yE7sQXilgO/RmctTsyPGwl+2zHmM1C+vjCSiFx43ZLscZUSqnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aioJSWXD; arc=none smtp.client-ip=95.215.58.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aioJSWXD"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ULSR5be2YtUyyk60Ms2Rw0/VkY/Y5pS/9BTkgu36FE4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788283810; v=1; x=1788888610;
 b=aioJSWXDeQhvR0n4EozPQNoFaNKGEwT1lnN0P9BF/aKdWLhMHadCrLfkhkfBf6ppeyhJRa0w
 Io//CuKxcTw9Ue71Yu3xxJwrpm7OljuOGQTPm9hQllraM9aQbDhnHLcSgzog8apDkj4iB+VeHu3
 u0K903ozmP+QJuj0Dj8pJ2zQ=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id ad8a45f6d4c58723;
	Tue, 01 Sep 2026 17:30:10 +0000
X-Mizu-Trace-ID: ad8a45f6d4c58723
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5b2a73da7e1so518e87.0
        for <kvmarm@lists.linux.dev>; Tue, 01 Sep 2026 10:30:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzx2wF+WmPS8bI9gLXPSIX8nMgEFpHs73/GwFoU9D3qHbxt0n1YhnEDkXrQ7AfNFxsDv163Vts=@lists.linux.dev
X-Gm-Message-State: AFuF++mLD6YzJUbWMtUlsYw/9QdNqo492q763i4Rmpqs+An0OLliqs6l
	rMHTorlU9PZYbmQNojl+mP4Dq+aTPMOtzt3dG6us3/EOZm2J0bh3gquouOWdfiu9H09f9lgHnQT
	Zl9/Mvw6Z8QERMqQc+AqKzzSukzHOlmYZUwhMSs/6
X-Received: by 2002:a05:6512:158b:b0:5b1:ca0b:25d2 with SMTP id
 2adb3069b0e04-5b606b396b9mr6047e87.4.1788283807433; Tue, 01 Sep 2026 10:30:07
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260901080941.997769-1-vdonnefort@google.com> <20260901080941.997769-11-vdonnefort@google.com>
In-Reply-To: <20260901080941.997769-11-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 1 Sep 2026 18:30:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTw91tzLNXZDoRfty767vxLjao9bADkVD=vyhH64chLyDw@mail.gmail.com>
X-Gm-Features: AcwNN1VxnCRhcWk2F0atM0MG2flGmEqHcqfsD7nDrWqtoce5L066OBj30S3ayJY
Message-ID: <CA+EHjTw91tzLNXZDoRfty767vxLjao9bADkVD=vyhH64chLyDw@mail.gmail.com>
Subject: Re: [PATCH v5 10/18] KVM: arm64: Add a shrinker for pKVM
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 1 Sept 2026 at 09:10, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> Integrate the pKVM memory reclaim interface with the host's memory
> management subsystem.
>
> This allows the host to automatically recover unused memory fom the
> hypervisor's heap allocator when the host is under memory pressure.
>
> Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad


>
> diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> index 366bbd5c854b..976fa65522fe 100644
> --- a/arch/arm64/include/asm/kvm_pkvm.h
> +++ b/arch/arm64/include/asm/kvm_pkvm.h
> @@ -19,6 +19,7 @@
>
>  enum pkvm_topup_id {
>         PKVM_TOPUP_HYP_ALLOC,
> +       NR_PKVM_TOPUP_HYP_IDS,
>         PKVM_TOPUP_HYP_ALLOC_SELFTEST,
>  };
>
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 7821f2592eba..ea96744f41fb 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -133,7 +133,7 @@ static unsigned long __pkvm_hyp_reclaim(enum pkvm_topup_id id, unsigned long tar
>         return reclaimed;
>  }
>
> -static __maybe_unused unsigned long pkvm_hyp_reclaim(enum pkvm_topup_id id, unsigned long target)
> +static unsigned long pkvm_hyp_reclaim(enum pkvm_topup_id id, unsigned long target)
>  {
>         unsigned long reclaimed = 0;
>
> @@ -154,7 +154,7 @@ static __maybe_unused unsigned long pkvm_hyp_reclaim(enum pkvm_topup_id id, unsi
>         return reclaimed;
>  }
>
> -static __maybe_unused unsigned long pkvm_hyp_reclaimable(enum pkvm_topup_id id)
> +static unsigned long pkvm_hyp_reclaimable(enum pkvm_topup_id id)
>  {
>         return kvm_call_hyp_nvhe(__pkvm_hyp_reclaimable, id);
>  }
> @@ -360,8 +360,39 @@ void __init pkvm_selftests(void)
>  #endif
>  }
>
> +static unsigned long pkvm_shrinker_count(struct shrinker *shrink, struct shrink_control *sc)
> +{
> +       unsigned long reclaimable = 0;
> +       int id;
> +
> +       for (id = 0; id < NR_PKVM_TOPUP_HYP_IDS; id++)
> +               reclaimable += pkvm_hyp_reclaimable(id);
> +
> +       return reclaimable ?: SHRINK_EMPTY;
> +}
> +
> +static unsigned long pkvm_shrinker_scan(struct shrinker *shrink, struct shrink_control *sc)
> +{
> +       unsigned long reclaimed = 0;
> +       int id;
> +
> +       sc->nr_scanned = 0;
> +
> +       for (id = 0; id < NR_PKVM_TOPUP_HYP_IDS; id++) {
> +               unsigned long r = pkvm_hyp_reclaim(id, sc->nr_to_scan - sc->nr_scanned);
> +
> +               reclaimed += r;
> +               sc->nr_scanned += r;
> +               if (sc->nr_scanned >= sc->nr_to_scan)
> +                       break;
> +       }
> +
> +       return reclaimed ?: SHRINK_STOP;
> +}
> +
>  static int __init finalize_pkvm(void)
>  {
> +       struct shrinker *pkvm_shrinker;
>         int ret;
>
>         if (!is_protected_kvm_enabled() || !is_kvm_arm_initialised())
> @@ -377,10 +408,21 @@ static int __init finalize_pkvm(void)
>         kmemleak_free_part_phys(hyp_mem_base, hyp_mem_size);
>
>         ret = pkvm_drop_host_privileges();
> -       if (ret)
> +       if (ret) {
>                 pr_err("Failed to finalize Hyp protection: %d\n", ret);
> +               return ret;
> +       }
>
> -       return ret;
> +       pkvm_shrinker = shrinker_alloc(0, "pkvm");
> +       if (pkvm_shrinker) {
> +               pkvm_shrinker->count_objects = pkvm_shrinker_count;
> +               pkvm_shrinker->scan_objects = pkvm_shrinker_scan;
> +               shrinker_register(pkvm_shrinker);
> +       } else {
> +               kvm_err("Failed to register shrinker for pKVM\n");
> +       }
> +
> +       return 0;
>  }
>  device_initcall_sync(finalize_pkvm);
>
> --
> 2.55.0.897.gb25b4bd76c-goog
>
