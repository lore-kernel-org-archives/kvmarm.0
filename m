Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21FCEC3
	for <kvmarm@lists.linux.dev>; Fri,  3 Mar 2023 00:47:08 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id v11so1073244plz.8
        for <kvmarm@lists.linux.dev>; Thu, 02 Mar 2023 16:47:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677804428;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NU0rjrjUgK9UPMJSdQ+7dnHdl8K0SghnjzsbTsmj3Ag=;
        b=TYHVnKkDpwjH8a1fiWkJJLS9ndCnG4I1g1BYddtN2ar35mGnN82+tbX39xKwI/8BeN
         pWtnDWV66OhFYew1W1q/3kd2qI1+LtJP4x/AGPYYEpVxSmeognokqWfMBNklHWLD2hZ1
         CGZ5WUBRFIRQPGZPGhZVLHAHsvgtfRytOC6uRcIGBQ0ZIvQOqvogS9uHjoP3pIda/iLF
         7+jq/ot2GajAKp9C2SoVb1SCXKcoau+giMPlZSv4fJ759gStAl4UMKZnHbtj7nlYv+Xm
         YDXb52RmdERNx7ntXJa5wxxuWZiunxYYlvwPxrPSlGxPbSp9EY78yguj+1zh28akhwk+
         ddNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677804428;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NU0rjrjUgK9UPMJSdQ+7dnHdl8K0SghnjzsbTsmj3Ag=;
        b=KCp7wMAcDLRFqxVrE/8ekqDzSD0pQ2ne/BZUxnoLLCWwBjbnFR5SvuDaDVELVZmEw3
         9c1at6gt8HMwT2/X6P+l+9UMfECtD6SLG+JAZGfWDTPJ9wBvy1Gf8irvojqs0TAEm2ox
         Fc0teYc4XdGLGeODz1cbn+8fvidO2wMhTzfQk4sjk2XXeEwLHGR3CB01mUqMEjDllyX3
         2zldOjImLUQOn04ApwpM/VBHix/jrKGUW1gb9q4JgCFUTMSrEmGHj3B3kRc7xog58umX
         n5PVTnEHW75W4/uKv6EbQSYBefFEsqedFv8QGVNBt/EonFygRLsR/bKEkujgyNqrxMkw
         ngWw==
X-Gm-Message-State: AO0yUKVJJsUVsDQBA0P9bG+fZA/nfHmPVBwhlQhCP95XC7kj7Ja8ZJQM
	VbP+03E8gXnQNb50fpfkKiQkxIwZwdTAJ19QYw+xLg==
X-Google-Smtp-Source: AK7set8ZZrRi0qeKqTr30s8g0fTBn8gg+Ebb9eSsgyj8YAUkp51xb+A200hC7FaZ6ERHui06IV+QymO/X0I7sksnzUs=
X-Received: by 2002:a17:902:f783:b0:19c:140d:aada with SMTP id
 q3-20020a170902f78300b0019c140daadamr70591pln.2.1677804428140; Thu, 02 Mar
 2023 16:47:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com> <20230215010717.3612794-7-rananta@google.com>
In-Reply-To: <20230215010717.3612794-7-rananta@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 2 Mar 2023 16:46:51 -0800
Message-ID: <CAAeT=FyrgUjQWhL75n7z43msubHHghhy3Tj2JjsYop14f3kFhg@mail.gmail.com>
Subject: Re: [REPOST PATCH 06/16] tools: arm64: perf_event: Define Cycle
 counter enable/overflow bits
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Ricardo Koller <ricarkol@google.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Raghu,

On Tue, Feb 14, 2023 at 5:07=E2=80=AFPM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> Add the definitions of ARMV8_PMU_CNTOVS_C (Cycle counter overflow
> bit) for overflow status registers and ARMV8_PMU_CNTENSET_C (Cycle
> counter enable bit) for PMCNTENSET_EL0 register.
>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  tools/arch/arm64/include/asm/perf_event.h | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/tools/arch/arm64/include/asm/perf_event.h b/tools/arch/arm64=
/include/asm/perf_event.h
> index 97e49a4d4969f..8ce23aabf6fe6 100644
> --- a/tools/arch/arm64/include/asm/perf_event.h
> +++ b/tools/arch/arm64/include/asm/perf_event.h
> @@ -222,9 +222,11 @@
>  /*
>   * PMOVSR: counters overflow flag status reg
>   */
> +#define ARMV8_PMU_CNTOVS_C      (1 << 31) /* Cycle counter overflow bit =
*/

Nit: This macro doesn't seem to be used in any of the patches.
Do we need this ?

Thank you,
Reiji


>  #define        ARMV8_PMU_OVSR_MASK             0xffffffff      /* Mask f=
or writable bits */
>  #define        ARMV8_PMU_OVERFLOWED_MASK       ARMV8_PMU_OVSR_MASK
>
> +
>  /*
>   * PMXEVTYPER: Event selection reg
>   */
> @@ -247,6 +249,11 @@
>  #define ARMV8_PMU_USERENR_CR   (1 << 2) /* Cycle counter can be read at =
EL0 */
>  #define ARMV8_PMU_USERENR_ER   (1 << 3) /* Event counter can be read at =
EL0 */
>
> +/*
> + * PMCNTENSET: Count Enable set reg
> + */
> +#define ARMV8_PMU_CNTENSET_C    (1 << 31) /* Cycle counter enable bit */
> +
>  /* PMMIR_EL1.SLOTS mask */
>  #define ARMV8_PMU_SLOTS_MASK   0xff
>
> --
> 2.39.1.581.gbfd45094c4-goog
>
