Received: from mta0.migadu.com (out-145.mta0.migadu.com [91.218.175.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7474835028C
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 15:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787066965; cv=none; b=A6YGGuf7GsGhBNHD0/oWWgTEcD1sP9Z8yMuLXjRHj2ncmbORjhtUXlsuXiJx9HrCFL8JCuEgVvNlzBrKDCt+z+f8pEgH0w2oYMZEhuchYFO8fkk2d5B0DXiIE3CI2T9z/oQayMM0IeVWolagxdNfC+RXVq1pcjnpeMz2ZzUuSZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787066965; c=relaxed/simple;
	bh=yz1BirAozlV32Y/a88BgBar1iXFJiUM3ZwE+H9gRd8c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vCEyJ+QHxNy51u3qyPfD690OJjCMXMid5Xs4Kj/wby/yfDe8VP8mraftnspMwcZk3XvV/5kLdi2bYzZCYaJseomBcUH1VhUI/CYOf8UN0PlM0eORHYt4q/YBPng+MzsVVxiaZ4ViDsIyKaoWaF+PbHr5irHhzed2gi8nPS3zjA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=e8M0+zY5; arc=none smtp.client-ip=91.218.175.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="e8M0+zY5"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=yz1BirAozlV32Y/a88BgBar1iXFJiUM3ZwE+H9gRd8c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787066960; v=1; x=1787671760;
 b=e8M0+zY53zsR24YP7pABz4A2rzbsMODv5WRIXIqCojZh3zycPwpsnq9r8yk4H/um3VQngxS6
 mI+evqfGmA8vXGavDnIkdq1+DDy/ykO0L0MMbgEryTVpEYgPvK/LT+ojuuRyoZNCj07J3VRnHIL
 JihfFMMtXBrIvkMNjrNg2h8A=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f52.google.com (209.85.167.52)
	by smtp.migadu.com with ESMTPS id c39fb64a2fff8f3c;
	Tue, 18 Aug 2026 15:29:20 +0000
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5aeb688ae83so8532e87.1
        for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 08:29:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqEhEywDI+zUZACAJbkuSMCC2dl2lyoFJRB+WPu4dKGQbMMKo+RFmd6AnMnxmWFj1nRs4NX1PA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6TpvkNbmPed3NVEnrBcPgwY7Sc/WunmZMRHD7SviYsFeiB90C
	slMaOPy3lHBADmKMr9ariSd1TJRDjtoKhSUx1iCO+AyPpes+JCpQZDQgLrRXIioYea9NB4/sRpw
	Ed+Or590eqt8vIgbHXZW7rt/2nCMIi4BaMTs7vLvY
X-Received: by 2002:a05:6512:12cc:b0:5ae:b0ee:f737 with SMTP id
 2adb3069b0e04-5b47435ae97mr200338e87.9.1787066955105; Tue, 18 Aug 2026
 08:29:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260731143541.956291-1-vdonnefort@google.com> <20260731143541.956291-11-vdonnefort@google.com>
In-Reply-To: <20260731143541.956291-11-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 18 Aug 2026 16:28:38 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxU2GCpSR587oR_EaMOvXfu+teCnfC2KCg=vpOtf4sgRA@mail.gmail.com>
X-Gm-Features: AcwNN1W6PPY08uqxncvUvJozD_j76RCdP1Tiifaln0euga5uj7dgz3TH-pHwMWM
Message-ID: <CA+EHjTxU2GCpSR587oR_EaMOvXfu+teCnfC2KCg=vpOtf4sgRA@mail.gmail.com>
Subject: Re: [PATCH v4 10/17] KVM: arm64: Add a shrinker for pKVM
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,

On Fri, 31 Jul 2026 at 15:36, 'Vincent Donnefort' via kernel-team
<kernel-team@android.com> wrote:
>
> Integrate the pKVM memory reclaim interface with the host's memory
> management subsystem.
>
> This allows the host to automatically recover unused memory fom the
> hypervisor's heap allocator when the host is under memory pressure.
>
> Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
>
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index d28422f5c3d6..bfbb1266491d 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -115,7 +115,7 @@ static int pkvm_hyp_topup(enum pkvm_topup_id id, unsigned long nr_pages)
>         return ret;
>  }
>
> -static __maybe_unused unsigned long pkvm_hyp_reclaim(enum pkvm_topup_id id, unsigned long target)
> +static unsigned long pkvm_hyp_reclaim(enum pkvm_topup_id id, unsigned long target)

This is the first caller of these, so it is where reclaim starts
running against a concurrent top-up.

Nothing marks the pages a top-up just put in allocator->mc as spoken
for, and hyp_allocator_reclaim() ends with an unbounded drain of it,
so a shrink with target 1 hands back the lot. Land that between a
top-up and the retry it was for, and the retry asks again, and
pkvm_call_hyp_req() goes round.

Both are driven by memory pressure, so they are busiest together.
Worth holding back what a pending request asked for?

>  {
>         struct kvm_hyp_memcache mc;
>         struct arm_smccc_res res;
> @@ -133,7 +133,7 @@ static __maybe_unused unsigned long pkvm_hyp_reclaim(enum pkvm_topup_id id, unsi
>         return reclaimed;
>  }
>
> -static __maybe_unused unsigned long pkvm_hyp_reclaimable(enum pkvm_topup_id id)
> +static unsigned long pkvm_hyp_reclaimable(enum pkvm_topup_id id)
>  {
>         return kvm_call_hyp_nvhe(__pkvm_hyp_reclaimable, id);
>  }
> @@ -342,8 +342,19 @@ void __init pkvm_selftests(void)
>  #endif
>  }
>
> +static unsigned long pkvm_shrinker_count(struct shrinker *shrink, struct shrink_control *sc)
> +{
> +       return pkvm_hyp_reclaimable(PKVM_TOPUP_HYP_ALLOC) ?: SHRINK_EMPTY;
> +}
> +
> +static unsigned long pkvm_shrinker_scan(struct shrinker *shrink, struct shrink_control *sc)
> +{
> +       return pkvm_hyp_reclaim(PKVM_TOPUP_HYP_ALLOC, sc->nr_to_scan);
> +}

Returning 0 rather than SHRINK_STOP when reclaim comes back empty
leaves do_shrink_slab() calling this until total_scan runs out, and
each call is an HVC. count_objects() covers the case where there is
nothing at all, but not the one where it goes stale between the two
calls.

Cheers,
/fuad

> +
>  static int __init finalize_pkvm(void)
>  {
> +       struct shrinker *pkvm_shrinker;
>         int ret;
>
>         if (!is_protected_kvm_enabled() || !is_kvm_arm_initialised())
> @@ -359,10 +370,21 @@ static int __init finalize_pkvm(void)
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
> 2.55.0.508.g3f0d502094-goog
>
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
