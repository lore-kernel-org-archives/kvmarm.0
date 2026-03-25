Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA00350A33
	for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 19:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774466893; cv=pass; b=ZU3mWkTrOze4KGzCq8k9i6S6pQD6Ipb2HxbiVhPkDDtJU0rnQay2keqifc+NbCN6vL73FKWWsY6TEcZ6sDByuHa0s5syoCDB4SL/btTVRnsQ9RslWeHLvcwbg5607XT8MGFcOtJzZctpAaEOPIDtXMsqA9KrEJLIYbJCl6vMtvw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774466893; c=relaxed/simple;
	bh=8fqbfHwieLaxs2OhvQdTi8NOCEP5wPpiqcjlhSGkQZE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qUDIy/OgPeREe7Oq+gyuPecYM07amBGp0m80duEPgRLQuuBLpEPpkBvHp3+gltz8vJI/rKB+JpaIcNuHcQb19wb08On3qbSRbu2rwjTMt5wuthSanVib0nXK4UJdSWKJWeAYK6GpcGdAJi6Ju0ZclWaclL+Zi8KSMXzHgXtN41o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PdvipEz+; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PdvipEz+"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5091ed02c54so11481cf.1
        for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 12:28:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774466890; cv=none;
        d=google.com; s=arc-20240605;
        b=EEKPFQ8UoxNCs17Xzpp8OH3NcZHUXQ+orp28Fx4zPU8+/6rjr+qBLbqe+WWJ1ZOoCA
         dW1/4CGau3QYthufL1NYQNrEvk5DgO0VUeT1uozBZWwL71uHI5X46R1u7CkuYV8yDD8c
         RgANKmWu4z6z1R+rrHwtQ/OgGvAsMJ144pjTOZb0GkwNpoCT1+IvzN8133O1OcsCsKZF
         LM3tlEKR8a5aDcBZLgZ+420OZDiR0y9WH81J/3p6FPjs9d34vnSQBQAbXSc214yB1FN7
         uPBiNfUbYH1A+9wVyWDW20RgoQKhY18lu3PuQWlYNwlIwrtNdvdg8JPbGv5RGJnGB13f
         WucQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=3jXRKuQ+zscB32uOukv3fqFuaunkYR2fmb+32Ylt9Zk=;
        fh=WXifrakrhHpMKuV+YM1LZ/K83mZPglPFmcpcPxsJbCI=;
        b=Y/CMca7ef3vKEb6T0cJGxwLHdCYI2Gmh10L3yjHTvMCDur2MWcvZdCX0qJ6zHF0jKw
         SfyVZvAFK7fUISMUQfkdqZHXclptDO8CnSZrVklCDn737WD+suFdHxJhhxRb01+Y6n5l
         sjB3Dwh1USAQlcQvsVEjLPXi6c0iuroEITtDHJNGo4BbDZyHZIqXzTeFqQNFehRb9yKz
         v67vKJF25750Sbq41EWalcSd/d3OebJAldT+dwisuJuGdRGlInIPsP7p2VdN+UP61W8c
         7+YUkqCQw7YMhYvjJJB36zxfj0O54yjBes9hwvUEfjf9JKtQNMr6HTSfyLFbzkvBgt77
         rvMw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774466890; x=1775071690; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3jXRKuQ+zscB32uOukv3fqFuaunkYR2fmb+32Ylt9Zk=;
        b=PdvipEz+nWWzD8UOVhA+QxOt4W0xxyjUP6sIJwNhp+vM2zgWZkKvsuuK+tmujbnU4j
         ZeaB43DQ7TLuBVc73VMNr639Aq601hf6VYExYY8+WIpAmOyuCRP+8ZOD+XvM7nmOGFsU
         ayq7ttplNzcCIORL4vPNow75gl1p+bsP7Q7wGJ8xDmkGgp7d4qZBT8sxrADZtPzvd13S
         zzFvv1qup45SCoUx4O+97Vr6Al4knCjTFApToo+FiqEqpTkb7bL5Mir1A7iFeOXYsjbB
         s2IYHf55cXH562r0cTmIXya4J8tYoYSQmyFo9uRhSOnHzVgR/z4sBo3szFlTMMQ08+sJ
         ueeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774466890; x=1775071690;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3jXRKuQ+zscB32uOukv3fqFuaunkYR2fmb+32Ylt9Zk=;
        b=d5HuUivXkocBdBec0Lw/RSVVv7U7OzMbxH/W/9VZw/TSVWdQZRc1HXZhNOoVxwVcbz
         X3UYt3O9hKbSjVlwy6CRILstNMM4EdcmUL/HyB8cZ2Spr/lWu6aORox/+mRNg/3wDZTR
         T3f6U4/cVXuOpW10PNbbZzRJxmG8chem61cJFsIfhtZna0UyMSoR6x9tYij2Vwcdp16I
         19SDjI3kzAj71t6OKiALnCj4FOSuFg4C70ni8HF0ny0Anoy+JSdwYwMlvDM6USKPfuhj
         JD3l+Y9kV+XKYIUMOSHW5P94wIfla484AXzCazL63HPsGQpcL1NOBx23YvT8h54bHwC+
         +zRw==
X-Gm-Message-State: AOJu0Yyvt4/yQkjmpRLXcbbRjxEtP9UTTW52/FImncqhOxUQpvk6zZtj
	AU+MvjTYlph3DG/ojVXFNJeEBhr2MsOaEURrI1kXesc7RQtuIbIs4G9VOMtdVT7Xgq4zAZeQUzS
	dcET15lWizi1TCDC8s7COMGEt/cO8pq79xMlB/dQ5
X-Gm-Gg: ATEYQzwB7m4pC9k0P4G54Xk07t75aNp5Z+r9J+FiK6BcBBl9fdyfQxBpFN460g5Qf2e
	Q/WdrknvjQCJY63NH2D1eYW81GBb5spdnl0f12pGrNw3SEDYCtZriAxZ18AShTTAkGjMmawD4S5
	+OnlInSZ7VWxihKH6dsOZ9X/ZWmTzhvRINW2NyjTtaUZclZEXYHth8HN4/f4v0tTL60svDSb+47
	g4VILxVERMg4p9EPUkRt+2KDHUzeNWKpyyrMnIsUkSpby72gEvnSjwbWUSM6RnRXekUfQzK4GsT
	l2D34CTl
X-Received: by 2002:a05:622a:a950:b0:509:21ff:cd49 with SMTP id
 d75a77b69052e-50b93a03cafmr822391cf.4.1774466890075; Wed, 25 Mar 2026
 12:28:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260227212136.7660-1-will@kernel.org> <20260227212136.7660-2-will@kernel.org>
In-Reply-To: <20260227212136.7660-2-will@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 25 Mar 2026 19:27:32 +0000
X-Gm-Features: AQROBzBtSgn9cQ7N1iYo4S0niMNCLJ309hN3EBlrhv7VQmdymp5sBSZavqCW-tE
Message-ID: <CA+EHjTxcc2FArmi1hu17LW3BHUZ5zTnqbaQP0kbV39HXZfp9+Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] KVM: arm64: Disable TRBE Trace Buffer Unit when
 running in guest context
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, mark.rutland@arm.com, 
	linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, James Clark <james.clark@linaro.org>, Leo Yan <leo.yan@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Yabin Cui <yabinc@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Will,

Now that I have backported this to various Android versions....

On Fri, 27 Feb 2026 at 21:22, Will Deacon <will@kernel.org> wrote:
>
> The nVHE world-switch code relies on zeroing TRFCR_EL1 to disable trace
> generation in guest context when self-hosted TRBE is in use by the host.
>
> Per D3.2.1 ("Controls to prohibit trace at Exception levels"), clearing
> TRFCR_EL1 means that trace generation is prohibited at EL1 and EL0 but
> per R_YCHKJ the Trace Buffer Unit will still be enabled if
> TRBLIMITR_EL1.E is set. R_SJFRQ goes on to state that, when enabled, the
> Trace Buffer Unit can perform address translation for the "owning
> exception level" even when it is out of context.
>
> Consequently, we can end up in a state where TRBE performs speculative
> page-table walks for a host VA/IPA in guest/hypervisor context depending
> on the value of MDCR_EL2.E2TB, which changes over world-switch. The
> potential result appears to be a heady mixture of SErrors, data
> corruption and hardware lockups.
>
> Extend the TRBE world-switch code to clear TRBLIMITR_EL1.E after
> draining the buffer, restoring the register on return to the host. This
> unfortunately means we need to tackle CPU errata #2064142 and #2038923
> which add additional synchronisation requirements around manipulations
> of the limit register. Hopefully this doesn't need to be fast.
>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oupton@kernel.org>
> Cc: James Clark <james.clark@linaro.org>
> Cc: Leo Yan <leo.yan@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Fuad Tabba <tabba@google.com>
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Fixes: a1319260bf62 ("arm64: KVM: Enable access to TRBE support for host")
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h  |  1 +
>  arch/arm64/kvm/hyp/nvhe/debug-sr.c | 73 ++++++++++++++++++++++++++----
>  arch/arm64/kvm/hyp/nvhe/switch.c   |  2 +-
>  3 files changed, 66 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 5d5a3bbdb95e..1532ad2b2ec2 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -770,6 +770,7 @@ struct kvm_host_data {
>                 u64 pmscr_el1;
>                 /* Self-hosted trace */
>                 u64 trfcr_el1;
> +               u64 trblimitr_el1;
>                 /* Values of trap registers for the host before guest entry. */
>                 u64 mdcr_el2;
>                 u64 brbcr_el1;
> diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> index 2a1c0f49792b..3dbdee1148d3 100644
> --- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> +++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> @@ -57,12 +57,56 @@ static void __trace_do_switch(u64 *saved_trfcr, u64 new_trfcr)
>         write_sysreg_el1(new_trfcr, SYS_TRFCR);
>  }
>
> -static bool __trace_needs_drain(void)
> +static void __trace_drain_and_disable(void)
>  {
> -       if (is_protected_kvm_enabled() && host_data_test_flag(HAS_TRBE))
> -               return read_sysreg_s(SYS_TRBLIMITR_EL1) & TRBLIMITR_EL1_E;
> +       u64 *trblimitr_el1 = host_data_ptr(host_debug_state.trblimitr_el1);
>
> -       return host_data_test_flag(TRBE_ENABLED);
> +       *trblimitr_el1 = 0;
> +
> +       if (is_protected_kvm_enabled()) {
> +               if (!host_data_test_flag(HAS_TRBE))
> +                       return;
> +       } else {
> +               if (!host_data_test_flag(TRBE_ENABLED))
> +                       return;
> +       }

Can we simplify this? e.g.,

+      bool needs_drain = is_protected_kvm_enabled() ?
host_data_test_flag(HAS_TRBE) : host_data_test_flag(TRBE_ENABLED);
....

That said:

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> +
> +       *trblimitr_el1 = read_sysreg_s(SYS_TRBLIMITR_EL1);
> +       if (*trblimitr_el1 & TRBLIMITR_EL1_E) {
> +               /*
> +                * The host has enabled the Trace Buffer Unit so we have
> +                * to beat the CPU with a stick until it stops accessing
> +                * memory.
> +                */
> +
> +               /* First, ensure that our prior write to TRFCR has stuck. */
> +               isb();
> +
> +               /* Now synchronise with the trace and drain the buffer. */
> +               tsb_csync();
> +               dsb(nsh);
> +
> +               /*
> +                * With no more trace being generated, we can disable the
> +                * Trace Buffer Unit.
> +                */
> +               write_sysreg_s(0, SYS_TRBLIMITR_EL1);
> +               if (cpus_have_final_cap(ARM64_WORKAROUND_2064142)) {
> +                       /*
> +                        * Some CPUs are so good, we have to drain 'em
> +                        * twice.
> +                        */
> +                       tsb_csync();
> +                       dsb(nsh);
> +               }
> +
> +               /*
> +                * Ensure that the Trace Buffer Unit is disabled before
> +                * we start mucking with the stage-2 and trap
> +                * configuration.
> +                */
> +               isb();
> +       }
>  }
>
>  static bool __trace_needs_switch(void)
> @@ -79,15 +123,26 @@ static void __trace_switch_to_guest(void)
>
>         __trace_do_switch(host_data_ptr(host_debug_state.trfcr_el1),
>                           *host_data_ptr(trfcr_while_in_guest));
> -
> -       if (__trace_needs_drain()) {
> -               isb();
> -               tsb_csync();
> -       }
> +       __trace_drain_and_disable();
>  }
>
>  static void __trace_switch_to_host(void)
>  {
> +       u64 trblimitr_el1 = *host_data_ptr(host_debug_state.trblimitr_el1);
> +
> +       if (trblimitr_el1 & TRBLIMITR_EL1_E) {
> +               /* Re-enable the Trace Buffer Unit for the host. */
> +               write_sysreg_s(trblimitr_el1, SYS_TRBLIMITR_EL1);
> +               isb();
> +               if (cpus_have_final_cap(ARM64_WORKAROUND_2038923)) {
> +                       /*
> +                        * Make sure the unit is re-enabled before we
> +                        * poke TRFCR.
> +                        */
> +                       isb();
> +               }
> +       }
> +
>         __trace_do_switch(host_data_ptr(trfcr_while_in_guest),
>                           *host_data_ptr(host_debug_state.trfcr_el1));
>  }
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index 779089e42681..f00688e69d88 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -278,7 +278,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>          * We're about to restore some new MMU state. Make sure
>          * ongoing page-table walks that have started before we
>          * trapped to EL2 have completed. This also synchronises the
> -        * above disabling of BRBE, SPE and TRBE.
> +        * above disabling of BRBE and SPE.
>          *
>          * See DDI0487I.a D8.1.5 "Out-of-context translation regimes",
>          * rule R_LFHQG and subsequent information statements.
> --
> 2.53.0.473.g4a7958ca14-goog
>
