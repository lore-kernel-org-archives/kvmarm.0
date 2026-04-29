Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E2F35AC3B
	for <kvmarm@lists.linux.dev>; Wed, 29 Apr 2026 22:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777503201; cv=pass; b=Gtsi/zoX6jyvhrM/HX/+5NP74E9WvQVVYmTZ9Jo0fjl5hhD8cKOSX0RVnmDjMa2eeS6dxIcXCV10SQbfuV0vditS9fwWtK2lrjuTYWrmTxNO5rPNQJmJiUBjPpXgHMk/Cg9T/OFCmt0v9w76qBL5Ny1LJv/nf2tBId/JowJkseE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777503201; c=relaxed/simple;
	bh=Lj8LOXURCYndQNT/h+c2HKIGnJoMvCjUnhNkTBIm79Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YXmgqgnZuHrgVem9if0Acj4JraWJ5lgT6JtL6o0HXpnaS4HhQnksiuLwHT0F2uWCW1qvcz09YQ31I46qsHM9ZCiYytK5VmKeUgQ12E0/lZ76LP3ccktx0+RQEElraRk4b6qEirA+MAoCkl+UUhnOLV12/rKgXEFDTcgCHwkmVz4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u5HLCsHB; arc=pass smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u5HLCsHB"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5a40b2d26a1so214585e87.0
        for <kvmarm@lists.linux.dev>; Wed, 29 Apr 2026 15:53:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777503198; cv=none;
        d=google.com; s=arc-20240605;
        b=OGtGdoT+ZbddAKqn8uQjFx794OGawy6t2/pO08cC9QitDL2QLVJr7yMJ20uBlM3j04
         SqPq97GSmIo95DEiNmqus3OrFBvIQDQhcXNnE6+knuCZa0aLbBNZK7OkHkhZWn7F90NF
         qazTP/2zN84L+Cx6guyAJ/wJQmxi6HsaBQUmF2rFqwn4fOGNcDRa4vVlzWutosOChDwy
         I5Ajf7Ne1y1jJC7PDS1FhEziWvY6w4bgSDoByE8oha+odL5y6I1Qe9thZ6wGSCKAkfFE
         y02wK09VgHmubhQa86vtHaOr383Rrb+wa4Fox5uUOMNuOeCgtPVVDSk9h7H7L/3k7oVi
         lOGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vu88QnCcMw4zGWFEh8gTkrt2bkF3vQw7+Fn4qdJhZIw=;
        fh=rZr2vPIozxCM/DAJn9nwwvIO4DRO3bzhzaTqjfGJwuM=;
        b=YUF/3XmYufAFlcUP4zTQwl8QmiHdVgPatiQHjCRlIwOBeX7AvD7ZXc1wEGVpVSTKhU
         cAtsRYEDJEuZChAE/wPvEWYSCMuDleaKTzLIBLEz0pRVXV60ebStwBeyMM21Fk1dpXKf
         sogWT/Ytk2aoUV5PTP4/IonEEkEnJrUL1IZCobFElsPbW/pgKfPty/DcaA8hG0xnavz2
         WXods1vONnSPrA8j2pUaykqffZK4iGUMtij/FIYq/6Ne6BIutor9lc4A8EKXp6tKlvu3
         LzscPxnyvPmDDt6fd8t6vDjveSv5rh7X5ryLdflOyk9piNfQ26ekc8oM1SAF7hWWe/+g
         S2pg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777503198; x=1778107998; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vu88QnCcMw4zGWFEh8gTkrt2bkF3vQw7+Fn4qdJhZIw=;
        b=u5HLCsHBx5DQ1sU8+RDI84DtJj9M9E5xYw5hlZJFRZsnIstFdZ+f7xSIK6gIjtc3xi
         gCaB5TstDE1DiUraHE5lBBAESz/U2WlW+29br2+Vehy7AsXhzlKynHqUqnpiOfzldpib
         L77qAsdnCJhgF20QfT5MOpDL2unqsF6BJK6WHWCC4qhRO4C8cmSRTg5r29vBkmz0czwy
         Qk2r9kL0eMmnLnlwh2QV0Js3jWXcPxzQbZnHZ9X3wJxBs5jwONC3omtU/qzW+WmSSPyJ
         l9CjNK87IMaBwOR/503KnXCVtyLg/bPZpeDJGcgpiut2o/kJdkxfQmcvvOBW0JKeoqaI
         Zx8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777503198; x=1778107998;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vu88QnCcMw4zGWFEh8gTkrt2bkF3vQw7+Fn4qdJhZIw=;
        b=pIvCZcJWSvkRfRVmlenF/PDRuMYBiCB9W7iLqOuXuJ/0Vwz/gcuvK/QJpmzYnbj/Yx
         kNh1U402D4QmU+HP2xxEMU3ZRjNLaksYkNx9qeIMEZhNFhQcRVU9F+4DEvGPiJRRAOnL
         diw4p9s43KKK6ZDyEFh8L+7fwJ4bQHJzykHfyjgoVAot0tr5lomsUx2ukujwxzonnJnb
         lIwxJuYgDosROCF1JI4hYgvENwcK8Go6yZeWef53/Emv9QxLnJ+2LKzlgfULBCzeeu7X
         GYp/hiHVS+B/WbWRqctEF4tur5idXv24iIKnB9ih7w0iVfmcTmKZmDWuUj8b4hCa7RgP
         1bJQ==
X-Gm-Message-State: AOJu0YzMrgfdmmh5OADyzZQJdGxZE9PfSLEPyK6MhbOj0qRPdLnQxgsc
	LmutsP9tnyRtUlMvGCGI0wGO3wyLNN4clabXldl7Su1DIjcahjHpKM8270IMDgk3ZqTxN3/mhuk
	ITfnReywO0MA9EnlgRF1a59qfFo5O36SYIjOY3ho0
X-Gm-Gg: AeBDievsShtolVbKwx/bqMcusEGwV7kO5GuRNCqXK8jilEmh9WKLE5GNama/lYOliH+
	WoDlzB3R9QaJ49tb0bajlQ2fM7FeYb72NQvhHHpzqRZnF5ylSLGIWYnSpWaInJ32yYNlSFZqGg8
	mBu4Ct9bZSetRMejXNw7T48Kstck0JcRuM/nWliB3ZNlyLjjV6NuhuzpnahDbBP4uRjzyff9b1A
	94/96zFmkd//v7DG1oyHmZrCm5HH+qYxvmHnhfq+ApgPFWQ7ZuYNRaQ8ObDX2P7p36BFzJ60U3K
	Su0H0OKCQ8vtp/0K9V/RaC6naig0rZzJHY9khnWiFOY0VljQcoV1kKS1BPKwLyxWXnBJnZdl
X-Received: by 2002:a05:6512:b14:b0:5a3:f04a:67f3 with SMTP id
 2adb3069b0e04-5a8522dda63mr46505e87.25.1777503197508; Wed, 29 Apr 2026
 15:53:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260422130820.4023122-1-joey.gouly@arm.com>
In-Reply-To: <20260422130820.4023122-1-joey.gouly@arm.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 29 Apr 2026 15:53:05 -0700
X-Gm-Features: AVHnY4LtmTexErFx94peOACvyHnQPMhsC0cXW_WWEjRSPQEjSnrbr1lkk6dqdyI
Message-ID: <CAAdAUtgAk1=1trAX1nJK1pGhrJHCMgyfkGMiVZiT0oCrLg6v2A@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v1] arm64: update ESR_ELx definitions to
 match Linux kernel
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvmarm@lists.linux.dev, andrew.jones@linux.dev, alexandru.elisei@arm.com, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 22, 2026 at 6:08=E2=80=AFAM Joey Gouly <joey.gouly@arm.com> wro=
te:
>
> kvm-unit-test supports EL2, so replace the ESR_EL1* names with ESR_ELx.
>
> This section was copied from arch/arm64/include/asm/esr.h, as was the pre=
vious
> contents of the file.
>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Cc: Jing Zhang <jingzhangos@google.com>
> ---
>
> Hi,
>
> This is a patch to help with the EL2 stage2 mmu series, replacing patch
> 1 [1].
>
> Thanks,
> Joey
>
> [1] https://lore.kernel.org/kvmarm/20260413204630.1149038-2-jingzhangos@g=
oogle.com/
>
>  arm/mte.c             |   6 +--
>  arm/psci.c            |   2 +-
>  arm/selftest.c        |  16 +++----
>  arm/timer.c           |   4 +-
>  lib/arm64/asm/esr.h   | 100 ++++++++++++++++++++++++++----------------
>  lib/arm64/processor.c |  82 +++++++++++++++++-----------------
>  6 files changed, 117 insertions(+), 93 deletions(-)
>
> diff --git a/arm/mte.c b/arm/mte.c
> index a1bed8a7..35707fc6 100644
> --- a/arm/mte.c
> +++ b/arm/mte.c
> @@ -192,7 +192,7 @@ static void mte_sync_test(void)
>
>         mte_exception =3D false;
>
> -       install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, mte_fau=
lt_handler);
> +       install_exception_handler(EL1H_SYNC, ESR_ELx_EC_DABT_CUR, mte_fau=
lt_handler);
>
>         mem_read(tagged(mem, 2), &val);
>
> @@ -218,12 +218,12 @@ static void mte_asymm_test(void)
>         mte_set_tcf(MTE_TCF_ASYMM);
>         mte_exception =3D false;
>
> -       install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, mte_fau=
lt_handler);
> +       install_exception_handler(EL1H_SYNC, ESR_ELx_EC_DABT_CUR, mte_fau=
lt_handler);
>
>         mem_read(tagged(mem, 3), &val);
>         report((val =3D=3D 0) && mte_exception && (get_clear_tfsr() =3D=
=3D 0), "read");
>
> -       install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, NULL);
> +       install_exception_handler(EL1H_SYNC, ESR_ELx_EC_DABT_CUR, NULL);
>
>         mem_write(tagged(mem, 4), 0xaaaaaaaa);
>         report((*mem =3D=3D 0xaaaaaaaa) && (get_clear_tfsr() =3D=3D TFSR_=
EL1_TF0), "write");
> diff --git a/arm/psci.c b/arm/psci.c
> index 55308c8f..5800c0ac 100644
> --- a/arm/psci.c
> +++ b/arm/psci.c
> @@ -36,7 +36,7 @@ static void install_invalid_function_handler(exception_=
fn handler)
>  #ifdef __arm__
>         install_exception_handler(EXCPTN_UND, handler);
>  #else
> -       install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, handler)=
;
> +       install_exception_handler(EL1H_SYNC, ESR_ELx_EC_UNKNOWN, handler)=
;
>  #endif
>  }
>
> diff --git a/arm/selftest.c b/arm/selftest.c
> index 33f4cf42..0604e530 100644
> --- a/arm/selftest.c
> +++ b/arm/selftest.c
> @@ -326,12 +326,12 @@ static bool check_und(void)
>  {
>         enum vector v =3D check_vector_prep();
>
> -       install_exception_handler(v, ESR_EL1_EC_UNKNOWN, unknown_handler)=
;
> +       install_exception_handler(v, ESR_ELx_EC_UNKNOWN, unknown_handler)=
;
>
>         /* try to read an el3 sysreg from el0/1/2 */
>         test_exception("", "mrs x0, sctlr_el3", "", "x0");
>
> -       install_exception_handler(v, ESR_EL1_EC_UNKNOWN, NULL);
> +       install_exception_handler(v, ESR_ELx_EC_UNKNOWN, NULL);
>
>         return und_works;
>  }
> @@ -348,18 +348,18 @@ static bool check_svc(void)
>  {
>         enum vector v =3D check_vector_prep();
>
> -       install_exception_handler(v, ESR_EL1_EC_SVC64, svc_handler);
> +       install_exception_handler(v, ESR_ELx_EC_SVC64, svc_handler);
>
>         test_exception("", "svc #123", "");
>
> -       install_exception_handler(v, ESR_EL1_EC_SVC64, NULL);
> +       install_exception_handler(v, ESR_ELx_EC_SVC64, NULL);
>
>         return svc_works;
>  }
>
>  static void pabt_handler(struct pt_regs *regs, unsigned int esr)
>  {
> -       bool is_extabt =3D (esr & ESR_EL1_FSC_MASK) =3D=3D ESR_EL1_FSC_EX=
TABT;
> +       bool is_extabt =3D (esr & ESR_ELx_FSC_MASK) =3D=3D ESR_ELx_FSC_EX=
TABT;
>
>         expected_regs.regs[30] =3D expected_regs.pc + 4;
>         expected_regs.pc =3D expected_regs.regs[9];
> @@ -373,7 +373,7 @@ static bool check_pabt(void)
>  {
>         enum vector v =3D check_vector_prep();
>
> -       install_exception_handler(v, ESR_EL1_EC_IABT_EL1, pabt_handler);
> +       install_exception_handler(v, ESR_ELx_EC_IABT_CUR, pabt_handler);
>
>         test_exception("adrp    x9, check_pabt_invalid_paddr\n"
>                        "add     x9, x9, :lo12:check_pabt_invalid_paddr\n"
> @@ -381,7 +381,7 @@ static bool check_pabt(void)
>                        "blr     x9\n",
>                        "", "x9", "x30");
>
> -       install_exception_handler(v, ESR_EL1_EC_IABT_EL1, NULL);
> +       install_exception_handler(v, ESR_ELx_EC_IABT_CUR, NULL);
>
>         return pabt_works;
>  }
> @@ -400,7 +400,7 @@ static void check_vectors(void *arg __unused)
>  #ifdef __arm__
>                 install_exception_handler(EXCPTN_UND, user_psci_system_of=
f);
>  #else
> -               install_exception_handler(EL0_SYNC_64, ESR_EL1_EC_UNKNOWN=
,
> +               install_exception_handler(EL0_SYNC_64, ESR_ELx_EC_UNKNOWN=
,
>                                           user_psci_system_off);
>  #endif
>         } else {
> diff --git a/arm/timer.c b/arm/timer.c
> index 43fb6d88..898043f0 100644
> --- a/arm/timer.c
> +++ b/arm/timer.c
> @@ -356,9 +356,9 @@ static void test_init(void)
>                 vtimer_info.irq =3D TIMER_HVTIMER_IRQ;
>         }
>
> -       install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, ptimer_u=
nsupported_handler);
> +       install_exception_handler(EL1H_SYNC, ESR_ELx_EC_UNKNOWN, ptimer_u=
nsupported_handler);
>         ptimer_info.read_ctl();
> -       install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, NULL);
> +       install_exception_handler(EL1H_SYNC, ESR_ELx_EC_UNKNOWN, NULL);
>
>         if (ptimer_unsupported && !ERRATA(7b6b46311a85)) {
>                 report_skip("Skipping ptimer tests. Set ERRATA_7b6b46311a=
85=3Dy to enable.");
> diff --git a/lib/arm64/asm/esr.h b/lib/arm64/asm/esr.h
> index 335343c5..629e2e3c 100644
> --- a/lib/arm64/asm/esr.h
> +++ b/lib/arm64/asm/esr.h
> @@ -8,44 +8,68 @@
>  #ifndef _ASMARM64_ESR_H_
>  #define _ASMARM64_ESR_H_
>
> -#define ESR_EL1_WRITE          (1 << 6)
> -#define ESR_EL1_CM             (1 << 8)
> -#define ESR_EL1_IL             (1 << 25)
> +#define ESR_ELx_EC_SHIFT       (26)
> +#define ESR_ELx_EC_UNKNOWN      UL(0x00)
> +#define ESR_ELx_EC_WFx          UL(0x01)
> +/* Unallocated EC: 0x02 */
> +#define ESR_ELx_EC_CP15_32      UL(0x03)
> +#define ESR_ELx_EC_CP15_64      UL(0x04)
> +#define ESR_ELx_EC_CP14_MR      UL(0x05)
> +#define ESR_ELx_EC_CP14_LS      UL(0x06)
> +#define ESR_ELx_EC_FP_ASIMD     UL(0x07)
> +#define ESR_ELx_EC_CP10_ID      UL(0x08)        /* EL2 only */
> +#define ESR_ELx_EC_PAC          UL(0x09)        /* EL2 and above */
> +#define ESR_ELx_EC_OTHER        UL(0x0A)
> +/* Unallocated EC: 0x0B */
> +#define ESR_ELx_EC_CP14_64      UL(0x0C)
> +#define ESR_ELx_EC_BTI          UL(0x0D)
> +#define ESR_ELx_EC_ILL          UL(0x0E)
> +/* Unallocated EC: 0x0F - 0x10 */
> +#define ESR_ELx_EC_SVC32        UL(0x11)
> +#define ESR_ELx_EC_HVC32        UL(0x12)        /* EL2 only */
> +#define ESR_ELx_EC_SMC32        UL(0x13)        /* EL2 and above */
> +/* Unallocated EC: 0x14 */
> +#define ESR_ELx_EC_SVC64        UL(0x15)
> +#define ESR_ELx_EC_HVC64        UL(0x16)        /* EL2 and above */
> +#define ESR_ELx_EC_SMC64        UL(0x17)        /* EL2 and above */
> +#define ESR_ELx_EC_SYS64        UL(0x18)
> +#define ESR_ELx_EC_SVE          UL(0x19)
> +#define ESR_ELx_EC_ERET         UL(0x1a)        /* EL2 only */
> +/* Unallocated EC: 0x1B */
> +#define ESR_ELx_EC_FPAC         UL(0x1C)        /* EL1 and above */
> +#define ESR_ELx_EC_SME          UL(0x1D)
> +/* Unallocated EC: 0x1E */
> +#define ESR_ELx_EC_IMP_DEF      UL(0x1f)        /* EL3 only */
> +#define ESR_ELx_EC_IABT_LOW     UL(0x20)
> +#define ESR_ELx_EC_IABT_CUR     UL(0x21)
> +#define ESR_ELx_EC_PC_ALIGN     UL(0x22)
> +/* Unallocated EC: 0x23 */
> +#define ESR_ELx_EC_DABT_LOW     UL(0x24)
> +#define ESR_ELx_EC_DABT_CUR     UL(0x25)
> +#define ESR_ELx_EC_SP_ALIGN     UL(0x26)
> +#define ESR_ELx_EC_MOPS         UL(0x27)
> +#define ESR_ELx_EC_FP_EXC32     UL(0x28)
> +/* Unallocated EC: 0x29 - 0x2B */
> +#define ESR_ELx_EC_FP_EXC64     UL(0x2C)
> +#define ESR_ELx_EC_GCS          UL(0x2D)
> +/* Unallocated EC:  0x2E */
> +#define ESR_ELx_EC_SERROR       UL(0x2F)
> +#define ESR_ELx_EC_BREAKPT_LOW  UL(0x30)
> +#define ESR_ELx_EC_BREAKPT_CUR  UL(0x31)
> +#define ESR_ELx_EC_SOFTSTP_LOW  UL(0x32)
> +#define ESR_ELx_EC_SOFTSTP_CUR  UL(0x33)
> +#define ESR_ELx_EC_WATCHPT_LOW  UL(0x34)
> +#define ESR_ELx_EC_WATCHPT_CUR  UL(0x35)
> +/* Unallocated EC: 0x36 - 0x37 */
> +#define ESR_ELx_EC_BKPT32       UL(0x38)
> +/* Unallocated EC: 0x39 */
> +#define ESR_ELx_EC_VECTOR32     UL(0x3A)        /* EL2 only */
> +/* Unallocated EC: 0x3B */
> +#define ESR_ELx_EC_BRK64        UL(0x3C)
> +/* Unallocated EC: 0x3D - 0x3F */
> +#define ESR_ELx_EC_MAX          UL(0x3F)
>
> -#define ESR_EL1_EC_SHIFT       (26)
> -#define ESR_EL1_EC_UNKNOWN     (0x00)
> -#define ESR_EL1_EC_WFI         (0x01)
> -#define ESR_EL1_EC_CP15_32     (0x03)
> -#define ESR_EL1_EC_CP15_64     (0x04)
> -#define ESR_EL1_EC_CP14_MR     (0x05)
> -#define ESR_EL1_EC_CP14_LS     (0x06)
> -#define ESR_EL1_EC_FP_ASIMD    (0x07)
> -#define ESR_EL1_EC_CP10_ID     (0x08)
> -#define ESR_EL1_EC_CP14_64     (0x0C)
> -#define ESR_EL1_EC_ILL_ISS     (0x0E)
> -#define ESR_EL1_EC_SVC32       (0x11)
> -#define ESR_EL1_EC_SVC64       (0x15)
> -#define ESR_EL1_EC_SYS64       (0x18)
> -#define ESR_EL1_EC_SVE         (0x19)
> -#define ESR_EL1_EC_IABT_EL0    (0x20)
> -#define ESR_EL1_EC_IABT_EL1    (0x21)
> -#define ESR_EL1_EC_PC_ALIGN    (0x22)
> -#define ESR_EL1_EC_DABT_EL0    (0x24)
> -#define ESR_EL1_EC_DABT_EL1    (0x25)
> -#define ESR_EL1_EC_SP_ALIGN    (0x26)
> -#define ESR_EL1_EC_FP_EXC32    (0x28)
> -#define ESR_EL1_EC_FP_EXC64    (0x2C)
> -#define ESR_EL1_EC_SERROR      (0x2F)
> -#define ESR_EL1_EC_BREAKPT_EL0 (0x30)
> -#define ESR_EL1_EC_BREAKPT_EL1 (0x31)
> -#define ESR_EL1_EC_SOFTSTP_EL0 (0x32)
> -#define ESR_EL1_EC_SOFTSTP_EL1 (0x33)
> -#define ESR_EL1_EC_WATCHPT_EL0 (0x34)
> -#define ESR_EL1_EC_WATCHPT_EL1 (0x35)
> -#define ESR_EL1_EC_BKPT32      (0x38)
> -#define ESR_EL1_EC_BRK64       (0x3C)
> -
> -#define ESR_EL1_FSC_MASK       (0x3F)
> -#define ESR_EL1_FSC_EXTABT     (0x10)
> +#define ESR_ELx_FSC_MASK       (0x3F)
> +#define ESR_ELx_FSC_EXTABT     (0x10)
>
>  #endif /* _ASMARM64_ESR_H_ */
> diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
> index f9fea519..86328c01 100644
> --- a/lib/arm64/processor.c
> +++ b/lib/arm64/processor.c
> @@ -31,37 +31,37 @@ static const char *vector_names[] =3D {
>  };
>
>  static const char *ec_names[EC_MAX] =3D {
> -       [ESR_EL1_EC_UNKNOWN]            =3D "UNKNOWN",
> -       [ESR_EL1_EC_WFI]                =3D "WFI",
> -       [ESR_EL1_EC_CP15_32]            =3D "CP15_32",
> -       [ESR_EL1_EC_CP15_64]            =3D "CP15_64",
> -       [ESR_EL1_EC_CP14_MR]            =3D "CP14_MR",
> -       [ESR_EL1_EC_CP14_LS]            =3D "CP14_LS",
> -       [ESR_EL1_EC_FP_ASIMD]           =3D "FP_ASMID",
> -       [ESR_EL1_EC_CP10_ID]            =3D "CP10_ID",
> -       [ESR_EL1_EC_CP14_64]            =3D "CP14_64",
> -       [ESR_EL1_EC_ILL_ISS]            =3D "ILL_ISS",
> -       [ESR_EL1_EC_SVC32]              =3D "SVC32",
> -       [ESR_EL1_EC_SVC64]              =3D "SVC64",
> -       [ESR_EL1_EC_SYS64]              =3D "SYS64",
> -       [ESR_EL1_EC_SVE]                =3D "SVE",
> -       [ESR_EL1_EC_IABT_EL0]           =3D "IABT_EL0",
> -       [ESR_EL1_EC_IABT_EL1]           =3D "IABT_EL1",
> -       [ESR_EL1_EC_PC_ALIGN]           =3D "PC_ALIGN",
> -       [ESR_EL1_EC_DABT_EL0]           =3D "DABT_EL0",
> -       [ESR_EL1_EC_DABT_EL1]           =3D "DABT_EL1",
> -       [ESR_EL1_EC_SP_ALIGN]           =3D "SP_ALIGN",
> -       [ESR_EL1_EC_FP_EXC32]           =3D "FP_EXC32",
> -       [ESR_EL1_EC_FP_EXC64]           =3D "FP_EXC64",
> -       [ESR_EL1_EC_SERROR]             =3D "SERROR",
> -       [ESR_EL1_EC_BREAKPT_EL0]        =3D "BREAKPT_EL0",
> -       [ESR_EL1_EC_BREAKPT_EL1]        =3D "BREAKPT_EL1",
> -       [ESR_EL1_EC_SOFTSTP_EL0]        =3D "SOFTSTP_EL0",
> -       [ESR_EL1_EC_SOFTSTP_EL1]        =3D "SOFTSTP_EL1",
> -       [ESR_EL1_EC_WATCHPT_EL0]        =3D "WATCHPT_EL0",
> -       [ESR_EL1_EC_WATCHPT_EL1]        =3D "WATCHPT_EL1",
> -       [ESR_EL1_EC_BKPT32]             =3D "BKPT32",
> -       [ESR_EL1_EC_BRK64]              =3D "BRK64",
> +       [ESR_ELx_EC_UNKNOWN]            =3D "UNKNOWN",
> +       [ESR_ELx_EC_WFx]                =3D "WFx",
> +       [ESR_ELx_EC_CP15_32]            =3D "CP15_32",
> +       [ESR_ELx_EC_CP15_64]            =3D "CP15_64",
> +       [ESR_ELx_EC_CP14_MR]            =3D "CP14_MR",
> +       [ESR_ELx_EC_CP14_LS]            =3D "CP14_LS",
> +       [ESR_ELx_EC_FP_ASIMD]           =3D "FP_ASMID",
> +       [ESR_ELx_EC_CP10_ID]            =3D "CP10_ID",
> +       [ESR_ELx_EC_CP14_64]            =3D "CP14_64",
> +       [ESR_ELx_EC_ILL]                =3D "ILL",
> +       [ESR_ELx_EC_SVC32]              =3D "SVC32",
> +       [ESR_ELx_EC_SVC64]              =3D "SVC64",
> +       [ESR_ELx_EC_SYS64]              =3D "SYS64",
> +       [ESR_ELx_EC_SVE]                =3D "SVE",
> +       [ESR_ELx_EC_IABT_LOW]           =3D "IABT_LOW",
> +       [ESR_ELx_EC_IABT_CUR]           =3D "IABT_CUR",
> +       [ESR_ELx_EC_PC_ALIGN]           =3D "PC_ALIGN",
> +       [ESR_ELx_EC_DABT_LOW]           =3D "DABT_LOW",
> +       [ESR_ELx_EC_DABT_CUR]           =3D "DABT_CUR",
> +       [ESR_ELx_EC_SP_ALIGN]           =3D "SP_ALIGN",
> +       [ESR_ELx_EC_FP_EXC32]           =3D "FP_EXC32",
> +       [ESR_ELx_EC_FP_EXC64]           =3D "FP_EXC64",
> +       [ESR_ELx_EC_SERROR]             =3D "SERROR",
> +       [ESR_ELx_EC_BREAKPT_LOW]        =3D "BREAKPT_LOW",
> +       [ESR_ELx_EC_BREAKPT_CUR]        =3D "BREAKPT_CUR",
> +       [ESR_ELx_EC_SOFTSTP_LOW]        =3D "SOFTSTP_LOW",
> +       [ESR_ELx_EC_SOFTSTP_CUR]        =3D "SOFTSTP_CUR",
> +       [ESR_ELx_EC_WATCHPT_LOW]        =3D "WATCHPT_LOW",
> +       [ESR_ELx_EC_WATCHPT_CUR]        =3D "WATCHPT_CUR",
> +       [ESR_ELx_EC_BKPT32]             =3D "BKPT32",
> +       [ESR_ELx_EC_BRK64]              =3D "BRK64",
>  };
>
>  void show_regs(struct pt_regs *regs)
> @@ -82,18 +82,18 @@ void show_regs(struct pt_regs *regs)
>
>  bool get_far(unsigned int esr, unsigned long *far)
>  {
> -       unsigned int ec =3D esr >> ESR_EL1_EC_SHIFT;
> +       unsigned int ec =3D esr >> ESR_ELx_EC_SHIFT;
>
>         asm volatile("mrs %0, far_el1": "=3Dr" (*far));
>
>         switch (ec) {
> -       case ESR_EL1_EC_IABT_EL0:
> -       case ESR_EL1_EC_IABT_EL1:
> -       case ESR_EL1_EC_PC_ALIGN:
> -       case ESR_EL1_EC_DABT_EL0:
> -       case ESR_EL1_EC_DABT_EL1:
> -       case ESR_EL1_EC_WATCHPT_EL0:
> -       case ESR_EL1_EC_WATCHPT_EL1:
> +       case ESR_ELx_EC_IABT_LOW:
> +       case ESR_ELx_EC_IABT_CUR:
> +       case ESR_ELx_EC_PC_ALIGN:
> +       case ESR_ELx_EC_DABT_LOW:
> +       case ESR_ELx_EC_DABT_CUR:
> +       case ESR_ELx_EC_WATCHPT_LOW:
> +       case ESR_ELx_EC_WATCHPT_CUR:
>                 if ((esr & 0x3f /* DFSC */) !=3D 0x10
>                                 || !(esr & 0x400 /* FnV */))
>                         return true;
> @@ -108,7 +108,7 @@ static void bad_exception(enum vector v, struct pt_re=
gs *regs,
>  {
>         unsigned long far;
>         bool far_valid =3D get_far(esr, &far);
> -       unsigned int ec =3D esr >> ESR_EL1_EC_SHIFT;
> +       unsigned int ec =3D esr >> ESR_ELx_EC_SHIFT;
>         uintptr_t text =3D (uintptr_t)&_text;
>
>         printf("Load address: %" PRIxPTR "\n", text);
> @@ -158,7 +158,7 @@ void default_vector_sync_handler(enum vector v, struc=
t pt_regs *regs,
>                                  unsigned int esr)
>  {
>         struct thread_info *ti =3D thread_info_sp(regs->sp);
> -       unsigned int ec =3D esr >> ESR_EL1_EC_SHIFT;
> +       unsigned int ec =3D esr >> ESR_ELx_EC_SHIFT;
>
>         if (ti->flags & TIF_USER_MODE) {
>                 if (ec < EC_MAX && ti->exception_handlers[v][ec]) {
> --
> 2.25.1
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>
