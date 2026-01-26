Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0657120DD51
	for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 21:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769463124; cv=pass; b=FjSeo+1A7BBtVlijcHOMNJLU7B7AI8sxB+ojyOJKt3gt3e5XNLcCvWQQcIHH0ytIqyr+mqC5RASPgDQFfkLDRDHk1dag8oPsL3mzCMh7HKtDK5LFwYR52Ij0dpEBnOg5bIPiBdnbmLonBlC8oc/S7w+v8OvLZSZCruhaPn3qmcc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769463124; c=relaxed/simple;
	bh=x4ddBnE6UlmuM4UnSaFJuF1X0KUypj4oAt9SZYS5klo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Eiekak/VlJpSi9hvuCFqkxhwWFetfJKqn534aYdWHsRh7yZmr/e19TLqKtU7BB2IbmtDXQ9f9bRPc6i0SELaJYHerpK8CXLgFJPlSwdSXUOaeb5cwnm92R6BHztAVHW85qpo12Fo2dJqnWxautMTAbOMPwYu7VziAyOrXWU+9Qw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=URCa2pmO; arc=pass smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="URCa2pmO"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a1462573caso7075ad.0
        for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 13:32:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769463122; cv=none;
        d=google.com; s=arc-20240605;
        b=VTLRr68s07PrmYCFUUIEtYxNPqN2GglC3Rz+sS1wrK1Gl2724I6R5ENtsmFDrw06Jk
         A/WYXCGxQrZQuI+HOczzDQHQ1qXzLY/LmIXqJ1hJcGw072tGAm10RoRVaHBYMQiwBCl9
         dtoTuIOa0psIxSsDniuUuah+eMTSG0E++cak9/iXIh70XrOmlNJMe9z+tcuJx2TB1W0S
         1IeggQvWvj6AMFubzMLGK8Ca3cDaJjI3B6NwqnbdjD7YQtu2/zxOtsC9rgZKusoaoI2A
         oCA2jzJN/0PWVD3KonJvDb3uPkUReKaNKn0U+Bm34n6hyI1xs+Su5VrXqW2xaYjuzyj5
         Y2rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GdffSHeo/iYpRVNWqMXBIRygwWn3EwsHPHsZ8am4tRk=;
        fh=7TaHyhT7ELVKNoY+O22yzF+5TW7GVxNMQX6rx76BuM0=;
        b=RaIbQOwtjr/OS2az1XONWfF/+vgemOIz7443cqXIb/yXlEsHmSNfL4sqFuGSkXs6KM
         z6MAHRK+YOapwmxNeGvT6kIBujRMAc5omRCwKbl56euGbnS/qFfNqMY9mSV7SsEKYhbg
         PefQ0q9VUtmX/Je4ZjUwVPUM3z+l6+06djMV7dYp9IwCAlXhAylkIQZ0Hpr4H5Cc43af
         qcIwkqAt9r6sCAt+UPstHNX//rUoJjuJ7hijLgSsnRdesGCBIFyTtJDnAzy2JLVZtPvH
         mxHKiSbSe62nL4gnColnvGURYivygUtGVtM8h3JTDAXntaCN8/8jbBq72i6MPtUxTyts
         HRvg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769463122; x=1770067922; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GdffSHeo/iYpRVNWqMXBIRygwWn3EwsHPHsZ8am4tRk=;
        b=URCa2pmOBV2HS7tZ2CtmJ8APTNfcftq70HCKLr5spEmLfAjba+OmJOvgZimIghLW8W
         ozEaQgWpWHbwicpTZ4rjl4o2a0CX/6jgJJ9iSxNHdhvcsBlZPkKzT9x9MMoqyDK8RGMk
         qg44GC5gytEXViiZ3xFgP2RmjGVQkr97OyFgJ23ssh5zYGiZx0OkDq31Atl8mikWnOn9
         n08JfSCZi0RNHeSbhzoa5FnSRD8gRSw71xfKBsdVk79r/hYwGktxEl36QgDt4cZ76HTG
         yIhEEJh20hnBj1BZ8MVmvkcrc7iVVRJ6PrUw7844+7RBeK4eFmwNFDEca7oidtY2fhzF
         3vxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769463122; x=1770067922;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GdffSHeo/iYpRVNWqMXBIRygwWn3EwsHPHsZ8am4tRk=;
        b=EewzBZTcQ7gi4+m1yaq0J8IloyBrvJSOR9G+OuASRWFMF8D1dyCY8tQdSX1PTqigX8
         EemR6MbgH7tKNY+/IWjW7cR29ITJWfYOAsBqLHZp1LphVgKWU+QCvzUtXoGgjZ0b131M
         gkW1kVs7Vs+ODYYEGy8iszStVqXspvezISqS7bLvGK+HW/RpMG8suqVrCKUNaY/1eHFE
         TK6cHcpVUIhqRYsiI1ihYL3//EFJrSOIT5zEbtyBTVnam0iU1Gy1wXkEqMloWvDVWSd4
         95Weu1x+S2Wzpl2CtwC4Ri3z6gTqPkXQeRVGAvJX460QD9Nd3WFIrZieoasxzHaChBVr
         n1QA==
X-Forwarded-Encrypted: i=1; AJvYcCXEkYhYhmQtiWSrHgD/9BjTZyycqgwwcSoPkyIPxitYV7+pRub/sP6AxKjwCct0OOFQFw1/vqM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzZOq4lKE4dQpfsxrzKv6bGmLJzEqQioyXBjT4a/nxoLJSG3R+m
	lMrlTBPC1AqqbxJXU4CXswC16rfH+sbs3vBKlvBEKMvkJjf+22tUwr4tSfaFUOx2dQu61YXTuv/
	cceQXY8akOJI4FhGjIR0Kqt0H7fd49BBa/M2uNGxM
X-Gm-Gg: AZuq6aLBFwdZasOq4Q8HSu9J4JUqer2G8u1EqErhihaRiEQ4C/wLO019wc5dtKH9Y2l
	kPHVCsFIBvfDyyFUUtwzGBoT/nA3mCIFkNnhy5WYSfudHFNldxpLQ5lwRGmAC48e0Fim1mvbZQ0
	tneTizAkZSkjbBLSdraGUoOGKsdquPAAdNgsdUPJQKlUe5LmfS27MqVNqhmd9TFvaZaXDH8KXFa
	Il7D/VvoG7Bz6GjfPDqYlPrJ+kzKksr997I4y5JLjTUm8JR4nWr5PVSTBEOIfH3x/74dcyxIWNT
	VDtibzBfVP9LLJylXEZL30fN
X-Received: by 2002:a17:903:18b:b0:2a0:7fac:c031 with SMTP id
 d9443c01a7336-2a844e78abcmr3049555ad.14.1769463121618; Mon, 26 Jan 2026
 13:32:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260126104419.1649811-1-vdonnefort@google.com> <20260126104419.1649811-20-vdonnefort@google.com>
In-Reply-To: <20260126104419.1649811-20-vdonnefort@google.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Mon, 26 Jan 2026 13:31:49 -0800
X-Gm-Features: AZwV_QjRVAsI7BYNB-SSd0KqV-MZmQcJjsc_0anhfEHofc202jxoz2KReva1YZQ
Message-ID: <CAC_TJvfzETz53ZXCk89ndqhj0+nuMUxPsB=NNT8kSZP-iwLm7A@mail.gmail.com>
Subject: Re: [PATCH v10 19/30] KVM: arm64: Add PKVM_DISABLE_STAGE2_ON_PANIC
To: Vincent Donnefort <vdonnefort@google.com>
Cc: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 26, 2026 at 2:44=E2=80=AFAM Vincent Donnefort <vdonnefort@googl=
e.com> wrote:
>
> On NVHE_EL2_DEBUG, when using pKVM, the host stage-2 is relaxed to grant
> the kernel access to the stacktrace, hypervisor bug table and text to
> symbolize addresses. This is unsafe for production. In preparation for
> adding more debug options to NVHE_EL2_DEBUG, decouple the stage-2
> relaxation into a separate option.
>
> While at it, rename PROTECTED_NVHE_STACKTRACE into PKVM_STACKTRACE,
> following the same naming scheme as PKVM_DISABLE_STAGE2_ON_PANIC.
>
> Cc: Kalesh Singh <kaleshsingh@google.com>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Kalesh Singh <kaleshsingh@google.com>

Thanks,
Kalesh

>
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 4f803fd1c99a..6498dec00fe9 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -43,9 +43,27 @@ menuconfig KVM
>
>           If unsure, say N.
>
> +if KVM
> +
> +config PTDUMP_STAGE2_DEBUGFS
> +       bool "Present the stage-2 pagetables to debugfs"
> +       depends on DEBUG_KERNEL
> +       depends on DEBUG_FS
> +       depends on ARCH_HAS_PTDUMP
> +       select PTDUMP
> +       default n
> +       help
> +         Say Y here if you want to show the stage-2 kernel pagetables
> +         layout in a debugfs file. This information is only useful for k=
ernel developers
> +         who are working in architecture specific areas of the kernel.
> +         It is probably not a good idea to enable this feature in a prod=
uction
> +         kernel.
> +
> +         If in doubt, say N.
> +
>  config NVHE_EL2_DEBUG
>         bool "Debug mode for non-VHE EL2 object"
> -       depends on KVM
> +       default n
>         help
>           Say Y here to enable the debug mode for the non-VHE KVM EL2 obj=
ect.
>           Failure reports will BUG() in the hypervisor. This is intended =
for
> @@ -53,10 +71,23 @@ config NVHE_EL2_DEBUG
>
>           If unsure, say N.
>
> -config PROTECTED_NVHE_STACKTRACE
> -       bool "Protected KVM hypervisor stacktraces"
> -       depends on NVHE_EL2_DEBUG
> +if NVHE_EL2_DEBUG
> +
> +config PKVM_DISABLE_STAGE2_ON_PANIC
> +       bool "Disable the host stage-2 on panic"
>         default n
> +       help
> +         Relax the host stage-2 on hypervisor panic to allow the kernel =
to
> +         unwind and symbolize the hypervisor stacktrace. This however ta=
mpers
> +         the system security. This is intended for local EL2 hypervisor
> +         development.
> +
> +         If unsure, say N.
> +
> +config PKVM_STACKTRACE
> +       bool "Protected KVM hypervisor stacktraces"
> +       depends on PKVM_DISABLE_STAGE2_ON_PANIC
> +       default y
>         help
>           Say Y here to enable pKVM hypervisor stacktraces on hyp_panic()
>
> @@ -66,21 +97,6 @@ config PROTECTED_NVHE_STACKTRACE
>
>           If unsure, or not using protected nVHE (pKVM), say N.
>
> -config PTDUMP_STAGE2_DEBUGFS
> -       bool "Present the stage-2 pagetables to debugfs"
> -       depends on KVM
> -       depends on DEBUG_KERNEL
> -       depends on DEBUG_FS
> -       depends on ARCH_HAS_PTDUMP
> -       select PTDUMP
> -       default n
> -       help
> -         Say Y here if you want to show the stage-2 kernel pagetables
> -         layout in a debugfs file. This information is only useful for k=
ernel developers
> -         who are working in architecture specific areas of the kernel.
> -         It is probably not a good idea to enable this feature in a prod=
uction
> -         kernel.
> -
> -         If in doubt, say N.
> -
> +endif # NVHE_EL2_DEBUG
> +endif # KVM
>  endif # VIRTUALIZATION
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index cc7d5d1709cb..54aedf93c78b 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -539,7 +539,7 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr=
, u64 spsr,
>
>                 /* All hyp bugs, including warnings, are treated as fatal=
. */
>                 if (!is_protected_kvm_enabled() ||
> -                   IS_ENABLED(CONFIG_NVHE_EL2_DEBUG)) {
> +                   IS_ENABLED(CONFIG_PKVM_DISABLE_STAGE2_ON_PANIC)) {
>                         struct bug_entry *bug =3D find_bug(elr_in_kimg);
>
>                         if (bug)
> diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/hos=
t.S
> index eef15b374abb..3092befcd97c 100644
> --- a/arch/arm64/kvm/hyp/nvhe/host.S
> +++ b/arch/arm64/kvm/hyp/nvhe/host.S
> @@ -120,7 +120,7 @@ SYM_FUNC_START(__hyp_do_panic)
>
>         mov     x29, x0
>
> -#ifdef CONFIG_NVHE_EL2_DEBUG
> +#ifdef PKVM_DISABLE_STAGE2_ON_PANIC
>         /* Ensure host stage-2 is disabled */
>         mrs     x0, hcr_el2
>         bic     x0, x0, #HCR_VM
> diff --git a/arch/arm64/kvm/hyp/nvhe/stacktrace.c b/arch/arm64/kvm/hyp/nv=
he/stacktrace.c
> index 5b6eeab1a774..7c832d60d22b 100644
> --- a/arch/arm64/kvm/hyp/nvhe/stacktrace.c
> +++ b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
> @@ -34,7 +34,7 @@ static void hyp_prepare_backtrace(unsigned long fp, uns=
igned long pc)
>         stacktrace_info->pc =3D pc;
>  }
>
> -#ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
> +#ifdef CONFIG_PKVM_STACKTRACE
>  #include <asm/stacktrace/nvhe.h>
>
>  DEFINE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)], pkvm_s=
tacktrace);
> @@ -134,11 +134,11 @@ static void pkvm_save_backtrace(unsigned long fp, u=
nsigned long pc)
>
>         unwind(&state, pkvm_save_backtrace_entry, &idx);
>  }
> -#else /* !CONFIG_PROTECTED_NVHE_STACKTRACE */
> +#else /* !CONFIG_PKVM_STACKTRACE */
>  static void pkvm_save_backtrace(unsigned long fp, unsigned long pc)
>  {
>  }
> -#endif /* CONFIG_PROTECTED_NVHE_STACKTRACE */
> +#endif /* CONFIG_PKVM_STACKTRACE */
>
>  /*
>   * kvm_nvhe_prepare_backtrace - prepare to dump the nVHE backtrace
> diff --git a/arch/arm64/kvm/stacktrace.c b/arch/arm64/kvm/stacktrace.c
> index af5eec681127..9724c320126b 100644
> --- a/arch/arm64/kvm/stacktrace.c
> +++ b/arch/arm64/kvm/stacktrace.c
> @@ -197,7 +197,7 @@ static void hyp_dump_backtrace(unsigned long hyp_offs=
et)
>         kvm_nvhe_dump_backtrace_end();
>  }
>
> -#ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
> +#ifdef CONFIG_PKVM_STACKTRACE
>  DECLARE_KVM_NVHE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long=
)],
>                          pkvm_stacktrace);
>
> @@ -225,12 +225,12 @@ static void pkvm_dump_backtrace(unsigned long hyp_o=
ffset)
>                 kvm_nvhe_dump_backtrace_entry((void *)hyp_offset, stacktr=
ace[i]);
>         kvm_nvhe_dump_backtrace_end();
>  }
> -#else  /* !CONFIG_PROTECTED_NVHE_STACKTRACE */
> +#else  /* !CONFIG_PKVM_STACKTRACE */
>  static void pkvm_dump_backtrace(unsigned long hyp_offset)
>  {
> -       kvm_err("Cannot dump pKVM nVHE stacktrace: !CONFIG_PROTECTED_NVHE=
_STACKTRACE\n");
> +       kvm_err("Cannot dump pKVM nVHE stacktrace: !CONFIG_PKVM_STACKTRAC=
E\n");
>  }
> -#endif /* CONFIG_PROTECTED_NVHE_STACKTRACE */
> +#endif /* CONFIG_PKVM_STACKTRACE */
>
>  /*
>   * kvm_nvhe_dump_backtrace - Dump KVM nVHE hypervisor backtrace.
> --
> 2.52.0.457.g6b5491de43-goog
>
