Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF3B19471
	for <kvmarm@lists.linux.dev>; Sat,  9 Dec 2023 23:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zT3unBuB"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1d0ccda19eeso22430345ad.1
        for <kvmarm@lists.linux.dev>; Sat, 09 Dec 2023 15:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702165745; x=1702770545; darn=lists.linux.dev;
        h=mime-version:message-id:date:in-reply-to:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=OPCNY52nyiQdIzlwx6EU4oIvd2oaUqsRoubFMnhv/R4=;
        b=zT3unBuBiVy3i9AH7tFCIEHEHmihCLghnnJrvzulnUk3mCGsxB2jlWkQ4OELiHXo6B
         F8AgazUt+Fo8sGJ8WgJvPSrDgZgDBVrT/ywG6fCz9Llqcm+CN0yyMd+SxXNWxMXr8ZUd
         6Xggwp3KjBIKfge6q3MR0QiGK7VDttBpzn+45gTufIUfTdXbwljCwlZxhjS59QaqIDt6
         EtTgp0Mb/ypQwhYPuNIX8WEnaan+Sz4f6XNPekNzXJqZLyQ1wzUDuuH+/lXme3lAMUh0
         P6Qlob9g8ChwaW+CqZT4AY5zyUjO5afUC1uGyPRacQqG5/UtmrPT+hrduil89fqeEFVe
         /W1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702165745; x=1702770545;
        h=mime-version:message-id:date:in-reply-to:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OPCNY52nyiQdIzlwx6EU4oIvd2oaUqsRoubFMnhv/R4=;
        b=kxzMT8pNekRpsMRpW7fX4j/LgFIq3Jg4t5msaspu1yttQTPVb6O4c3WFIe4egSietx
         Oinpg9HAEnrjLrIbnx4P4PAH52jQ571oBa+6uSR2Wv8qBR2yGS36U2EeMa9/lwdhoAVt
         jbRtAcDOGjVAKYhoD5uTnF29cVS0+StL5jinz42SMMCb0AqTrz9s2KFnfIOo1HQa++yc
         Z8k9i5NUSaa/WIEp0n9xDD8KMfNacnhcuMcKQIzVamTNOFncNnEDMAQridudIkEPcCgu
         RPTnQq70H+PDiuPK5MA9IkrhOA5ZtORUeRIfIHx10rj/HeQh/D4P+PSpM9TWjue03dED
         n+aw==
X-Gm-Message-State: AOJu0Yw4DH1Us7FS0tNcfJgcqnumgnwIoPQMGOZ53IUXKf90J5P57t/F
	Kd8vXy96N9MfPvZIUifgHEILpg==
X-Google-Smtp-Source: AGHT+IEJJXjirbJfGvEGv9wlC7QhPL3oJqPTSZjXXGeMs1qcfj17IHUevHGTEfzPXl+gH/HmXyzIBw==
X-Received: by 2002:a17:902:c64a:b0:1d0:c41b:1d1e with SMTP id s10-20020a170902c64a00b001d0c41b1d1emr919404pls.73.1702165744705;
        Sat, 09 Dec 2023 15:49:04 -0800 (PST)
Received: from localhost ([2804:14d:7e39:8470:ded6:9593:9f4f:5c29])
        by smtp.gmail.com with ESMTPSA id n2-20020a170902d2c200b001cfcf3dd317sm3918148plc.61.2023.12.09.15.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Dec 2023 15:49:04 -0800 (PST)
References: <20231122-arm64-gcs-v7-0-201c483bd775@kernel.org>
 <20231122-arm64-gcs-v7-26-201c483bd775@kernel.org>
User-agent: mu4e 1.10.8; emacs 29.1
From: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon
 <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton
 <akpm@linux-foundation.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton
 <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Arnd Bergmann <arnd@arndb.de>, Oleg
 Nesterov <oleg@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Kees
 Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>, "Rick P.
 Edgecombe" <rick.p.edgecombe@intel.com>, Deepak Gupta
 <debug@rivosinc.com>, Ard Biesheuvel <ardb@kernel.org>, Szabolcs Nagy
 <Szabolcs.Nagy@arm.com>, "H.J. Lu" <hjl.tools@gmail.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
 <aou@eecs.berkeley.edu>, Florian Weimer <fweimer@redhat.com>, Christian
 Brauner <brauner@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH v7 26/39] arm64/ptrace: Expose GCS via ptrace and core
 files
In-reply-to: <20231122-arm64-gcs-v7-26-201c483bd775@kernel.org>
Date: Sat, 09 Dec 2023 20:49:02 -0300
Message-ID: <877clney35.fsf@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Mark Brown <broonie@kernel.org> writes:

> Provide a new register type NT_ARM_GCS reporting the current GCS mode
> and pointer for EL0.  Due to the interactions with allocation and
> deallocation of Guarded Control Stacks we do not permit any changes to
> the GCS mode via ptrace, only GCSPR_EL0 may be changed.

The code allows disabling GCS. Is that unintended?

> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/uapi/asm/ptrace.h |  8 +++++
>  arch/arm64/kernel/ptrace.c           | 59 ++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/elf.h             |  1 +
>  3 files changed, 68 insertions(+)
>
> diff --git a/arch/arm64/include/uapi/asm/ptrace.h b/arch/arm64/include/uapi/asm/ptrace.h
> index 7fa2f7036aa7..0f39ba4f3efd 100644
> --- a/arch/arm64/include/uapi/asm/ptrace.h
> +++ b/arch/arm64/include/uapi/asm/ptrace.h
> @@ -324,6 +324,14 @@ struct user_za_header {
>  #define ZA_PT_SIZE(vq)						\
>  	(ZA_PT_ZA_OFFSET + ZA_PT_ZA_SIZE(vq))
>  
> +/* GCS state (NT_ARM_GCS) */
> +
> +struct user_gcs {
> +	__u64 features_enabled;
> +	__u64 features_locked;
> +	__u64 gcspr_el0;
> +};

If there's a reserved field in sigframe's gcs_context, isn't it worth it
to have a reserved field here as well?

> +
>  #endif /* __ASSEMBLY__ */
>  
>  #endif /* _UAPI__ASM_PTRACE_H */
> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
> index 20d7ef82de90..f15b8e33561e 100644
> --- a/arch/arm64/kernel/ptrace.c
> +++ b/arch/arm64/kernel/ptrace.c
> @@ -33,6 +33,7 @@
>  #include <asm/cpufeature.h>
>  #include <asm/debug-monitors.h>
>  #include <asm/fpsimd.h>
> +#include <asm/gcs.h>
>  #include <asm/mte.h>
>  #include <asm/pointer_auth.h>
>  #include <asm/stacktrace.h>
> @@ -1409,6 +1410,51 @@ static int tagged_addr_ctrl_set(struct task_struct *target, const struct
>  }
>  #endif
>  
> +#ifdef CONFIG_ARM64_GCS
> +static int gcs_get(struct task_struct *target,
> +		   const struct user_regset *regset,
> +		   struct membuf to)
> +{
> +	struct user_gcs user_gcs;
> +
> +	if (target == current)
> +		gcs_preserve_current_state();
> +
> +	user_gcs.features_enabled = target->thread.gcs_el0_mode;
> +	user_gcs.features_locked = target->thread.gcs_el0_locked;
> +	user_gcs.gcspr_el0 = target->thread.gcspr_el0;
> +
> +	return membuf_write(&to, &user_gcs, sizeof(user_gcs));
> +}
> +
> +static int gcs_set(struct task_struct *target, const struct
> +		   user_regset *regset, unsigned int pos,
> +		   unsigned int count, const void *kbuf, const
> +		   void __user *ubuf)
> +{
> +	int ret;
> +	struct user_gcs user_gcs;
> +
> +	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &user_gcs, 0, -1);
> +	if (ret)
> +		return ret;
> +
> +	if (user_gcs.features_enabled & ~PR_SHADOW_STACK_SUPPORTED_STATUS_MASK)
> +		return -EINVAL;
> +
> +	/* Do not allow enable via ptrace */
> +	if ((user_gcs.features_enabled & PR_SHADOW_STACK_ENABLE) &&
> +	    !!(target->thread.gcs_el0_mode & PR_SHADOW_STACK_ENABLE))

There should be only one '!' above.

Though contrary to the patch description, this code allows disabling
GCS. Shouldn't we require that

  (user_gcs.features_enabled & PR_SHADOW_STACK_ENABLE) ==
    (target->thread.gcs_el0_mode & PR_SHADOW_STACK_ENABLE)

? That would ensure that the GCS mode can't be changed.

> +		return -EBUSY;
> +
> +	target->thread.gcs_el0_mode = user_gcs.features_enabled;
> +	target->thread.gcs_el0_locked = user_gcs.features_locked;
> +	target->thread.gcspr_el0 = user_gcs.gcspr_el0;
> +
> +	return 0;
> +}
> +#endif

-- 
Thiago
