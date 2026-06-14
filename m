Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A573439935D
	for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 15:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781450776; cv=pass; b=jzokoFNQNEadtrZhIzZF5DZG/uHTNCaPTIWIs7Ut/iFhZl3YcaH2zM7Wbv4oBvUP1R5co/7KfBVaSh4OTsE8wH+Npl8s130A2WcssuoMGpcIVYHyF2NqjLqEPkO2L6mG/k8gBjE170PxSqKYR/X7/hy0QFsdgSi1AE3WyDf5H9U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781450776; c=relaxed/simple;
	bh=UCmNqZHjs338hfEQ7mcXR4Ib7mpre4NAa9gmeyI/tfM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ArYh6pU8YIkugWjN2aBeWsIZeZLOqsH58MRDEAMC2HplrM/dGlRbpZVkHTfwHszLoBaLL+gsOc4vFftdREbSdzutzg6RUvE0InNWQULZVeN/wXdPt4CTKL/sbwSrhMeJhsCkTniJPzttKVYndMoXP4UwmVetxSO+QzQqlaT1PWw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MExQUPXN; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MExQUPXN"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5175d339e8bso644191cf.0
        for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 08:26:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781450774; cv=none;
        d=google.com; s=arc-20240605;
        b=PyDqY68mdlRQtzbsoOOnL54kIb/mlNBZkvcnMQ/XniY1w2bbVLdRJXDUV0xivbenAS
         J+eIn4AYPi5WijnQHrHZ7/pjfFeSV0Imyb1ijXarGWduXQTkHrzggvdDYGM5KRoXF8uZ
         u2r3L/mjtFVgzvVf0yQgMinnT/fvf3GtidfmcP8VMNH+zdXlEphdyeNncHfPtuhzVfGH
         pHvAE/7TtafgLlADMpkOm7pSlhLJ4uHoWkmQNyCg1m15UsT7XpSgyqzIW1DpreX4Ty/L
         0/QJZsjYRREGm5U1KUFq9EPuYrZLRPqg2QOF5+JfSUdmPhQZuONh1Jn9t7wEl073DOnP
         +U1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=FGzUT7o3snYLzagtZmGzpgj1W1aUepNTYr7YbHmemOE=;
        fh=jhqzUeLTfmacM0gg9Ga5kXMeerYR3jVad4LoIRnGxpo=;
        b=AWRvT35uLL55PCH71tNl1+j+JTgd3zxXbhQiWjZfOh/wX9V1HAjPeOmuTRHQOYDrLj
         unA/msDmtUhTNTKCDYWUVm5rWtFurj1zdBL2I4rsz3oCmSIv/4eJFxwxyjdhkAo+RptK
         HnxRao4bvQNRHTtc3uhe3MwWkHXIs+QHqpcTzyaTiuxhgODhf1tPfEVewxrTaKcs4EbQ
         w6PcLRCAMWkmHwAmST2ops1wGiwA1CVbD9Kn6DUabgi8Dpq4KUMEFB/39y8eCprwCzP0
         ibfdaM1sPFKYOybtGrkl8oQuTKNJkCVRJL/kMl5ubFkRRNTvTEugYakGZGoVBslkZ1f4
         +qIQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781450774; x=1782055574; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FGzUT7o3snYLzagtZmGzpgj1W1aUepNTYr7YbHmemOE=;
        b=MExQUPXNDVPq5WM36m6NZpkX7wTuM04Pzhn8xYVTXEZcqeTJkI7zj4CXjxrJiktQZo
         6Nb3qPgtq5F/W4Bh4Y6vsr2J9Gnf1fDeVCdW/8noDFzbfaHlzVAtS7qMuWj5iTbdjP8f
         0rK5leGZl4yKba4AHMp1zzlatl5v1FZ9D4FnRId00by2mwOIUshpI34ITd7xVd7+JWd2
         GOErs1TeObIrafALEuZf2tZTslGDsncdnyH4G9ref18e3BrwTTI+wlDJDvYWq9wlLvVM
         YyuxtH1Sefusc8d+j42ZiZHiSBUkFUOs9gh1ktDqGk1OExKgapHkGypnf7Wogt2GtPnR
         h1lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781450774; x=1782055574;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FGzUT7o3snYLzagtZmGzpgj1W1aUepNTYr7YbHmemOE=;
        b=dtKuvBqwlMb1UPMy56oMbwt6sg2qhqB76rxR35kSwpVf2FXdyIL4IKDNkkWG/j7lyF
         h+/qk2l0mI2YBmWLsV2/AtJ+HyfG1bsuClnP2XDvT8G4IH11rlXwaZDUOq2pwi2dvnHv
         Xqm1c5Er4fcqCRu0RzXGwR2BR+j8DwDu4s/IFSrBRoWn2DBufAP1s0asaiujaLxpPKb1
         tzVMvGCXho6BDr/0gYvZiH70EClNDMiK8jYEWJQayyM8uhA5w8EYF2HkyXd0GXU9KFAp
         cTQXk1dD4wd16InA1GVRRVBY068Muzgbe3zemx9b9qTiFX1WLU3slGvCZendkQvVaTrs
         XpiA==
X-Forwarded-Encrypted: i=1; AFNElJ8W+nXwStUjUP3dFb3aiN/D1iHkWRrVyrKQCDs/W9GT1Av36VQ6MVYTiZW4nY6uuKqTijFQ+Ws=@lists.linux.dev
X-Gm-Message-State: AOJu0YxqD2dfXnI5nCWuct5fRW5Q24ASHizcS+q4nxmdreDGnsdzwy13
	T0pQ0xoDoVCyM8x/MrEmFy9X0nPesoyvi1WgkP0I6vv13nJIbY3B+VOaa/fsovzpbMGlKNaO7F9
	n2S0awagKtAbcnog23Ly3eEjHs+TCjBr28pPSuWA8
X-Gm-Gg: Acq92OG5Whxitb0OcZcn46Bn9C6HldwcMLXmwJxJbQMU5AnyDrpckWA5FHLDJfjr0mE
	g2V5HnQzdNcooPK2ygvl5q8F/mSDSx3DplhZeyI4cEZDktUlw1LtxyFa/o3IKUCC34VHPvNgYE9
	710MPFtKf0IOBk9FiKrs450ZQeiwqdAtfKNUJBYB0fuiCAnrL8QgNxOScj72v0KoLBfIl17Vb8h
	pf9EZpEUdQuDpTDpxrGpNlXzYgILjnmKBuzn5E3fRSH28Xy9IdaoTsP+HPdTanfvacC3HSDhCow
	UXJA9Tdr
X-Received: by 2002:a05:622a:4c05:b0:516:d570:82c0 with SMTP id
 d75a77b69052e-51955ebe27amr9381711cf.15.1781450772554; Sun, 14 Jun 2026
 08:26:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260612142245.1015744-1-vdonnefort@google.com> <20260612142245.1015744-5-vdonnefort@google.com>
In-Reply-To: <20260612142245.1015744-5-vdonnefort@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Sun, 14 Jun 2026 16:25:00 +0100
X-Gm-Features: AVVi8CdcaS9xeWZgynwMNRE2NQoozlB_AWZbPCepJCXytIRa9g7eAmYSGeF27AM
Message-ID: <CA+EHjTwqp=Hjzyn469Gvm-JRNovfnj=0eFB5+Kei_9pRQrnG0Q@mail.gmail.com>
Subject: Re: [PATCH v1 4/4] KVM: arm64: Add hyp_printk event to nVHE/pKVM hyp
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, rostedt@goodmis.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kernel-team@android.com, qerret@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,

On Fri, 12 Jun 2026 at 15:22, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> Create an event to allow developers to log pretty much anything into the
> hypervisor tracing buffer with trace_hyp_printk(), just like the kernel
> tracing has the function trace_printk().
>
>   trace_hyp_printk("foobar");
>   trace_hyp_printk("foo=%d", foo);
>   trace_hyp_printk("foo=%d bar=0x%016llx", foo, bar);
>
> To ensure writing into the tracing buffer is fast, store the string
> format into a kernel-accessible ELF section. The hypervisor only has to
> write into the event the string ID, which is the delta between the
> hyp_string_fmt and the start of the ELF section.
>
> To not waste tracing buffer data, use a dynamic size. Each
> argument is 8 bytes and the in-kernel printing function can simply know
> how many of them there are by looking at the event length.
>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
>
> diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h
> index 743c49bd878f..8465b523cb1d 100644
> --- a/arch/arm64/include/asm/kvm_hypevents.h
> +++ b/arch/arm64/include/asm/kvm_hypevents.h
> @@ -57,4 +57,18 @@ HYP_EVENT(selftest,
>         ),
>         RE_PRINTK("id=%llu", __entry->id)
>  );
> +
> +/*
> + * trace_hyp_printk() has too many specificities to be declared with HYP_EVENT().
> + * However, we can use a REMOTE_EVENT macro to automatically do the declaration
> + * for the kernel side.
> + */
> +REMOTE_EVENT_CUSTOM_PRINTK(hyp_printk,
> +       0, /* id will be overwritten during hyp event init */
> +       RE_STRUCT(
> +               re_field(u16, fmt_id)
> +               re_field(u64, args[])
> +       ),
> +       __hyp_trace_printk(evt, seq)
> +);
>  #endif
> diff --git a/arch/arm64/include/asm/kvm_hyptrace.h b/arch/arm64/include/asm/kvm_hyptrace.h
> index de133b735f72..46097105fdd8 100644
> --- a/arch/arm64/include/asm/kvm_hyptrace.h
> +++ b/arch/arm64/include/asm/kvm_hyptrace.h
> @@ -23,4 +23,12 @@ extern struct remote_event __hyp_events_end[];
>  extern struct hyp_event_id __hyp_event_ids_start[];
>  extern struct hyp_event_id __hyp_event_ids_end[];
>
> +#define HYP_STRING_FMT_MAX_SIZE 128
> +
> +struct hyp_string_fmt {
> +       const char      fmt[HYP_STRING_FMT_MAX_SIZE];
> +};
> +
> +extern struct hyp_string_fmt __hyp_string_fmts_start[];
> +extern struct hyp_string_fmt __hyp_string_fmts_end[];
>  #endif
> diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
> index d4c7d45ae6bc..ec03621d7a81 100644
> --- a/arch/arm64/kernel/image-vars.h
> +++ b/arch/arm64/kernel/image-vars.h
> @@ -141,6 +141,7 @@ KVM_NVHE_ALIAS(__hyp_rodata_end);
>  #ifdef CONFIG_NVHE_EL2_TRACING
>  KVM_NVHE_ALIAS(__hyp_event_ids_start);
>  KVM_NVHE_ALIAS(__hyp_event_ids_end);
> +KVM_NVHE_ALIAS(__hyp_string_fmts_start);
>  #endif
>
>  /* pKVM static key */
> diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
> index e1ac876200a3..b6d62642b6bd 100644
> --- a/arch/arm64/kernel/vmlinux.lds.S
> +++ b/arch/arm64/kernel/vmlinux.lds.S
> @@ -324,6 +324,10 @@ SECTIONS
>                 __hyp_events_start = .;
>                 *(SORT(_hyp_events.*))
>                 __hyp_events_end = .;
> +
> +               __hyp_string_fmts_start = .;
> +               *(_hyp_string_fmts)
> +               __hyp_string_fmts_end = .;
>         }
>  #endif
>         /*
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/define_events.h b/arch/arm64/kvm/hyp/include/nvhe/define_events.h
> index 776d4c6cb702..370e8c2d39fe 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/define_events.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/define_events.h
> @@ -10,5 +10,3 @@
>  #define HYP_EVENT_MULTI_READ
>  #include <asm/kvm_hypevents.h>
>  #undef HYP_EVENT_MULTI_READ
> -
> -#undef HYP_EVENT
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/trace.h b/arch/arm64/kvm/hyp/include/nvhe/trace.h
> index 8813ff250f8e..3d0b5c634bb3 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/trace.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/trace.h
> @@ -46,6 +46,69 @@ static inline pid_t __tracing_get_vcpu_pid(struct kvm_cpu_context *host_ctxt)
>  void *tracing_reserve_entry(unsigned long length);
>  void tracing_commit_entry(void);
>
> +/*
> + * The trace_hyp_printk boilerplate is too fiddly to be declared with
> + * HYP_EVENT():
> + *
> + * The string format is stored into a kernel-accessible ELF section. The
> + * hypervisor only writes the format ID.
> + *
> + * The function has a variadic prototype. We have no easy way to know each
> + * argument width so they must all cast to u64.
> + */
> +#define REMOTE_EVENT_CUSTOM_PRINTK(...)
> +
> +#define __TO_U64_0()
> +#define __TO_U64_1(x)                  , (u64)(x)
> +#define __TO_U64_2(x, ...)             , (u64)(x) __TO_U64_1(__VA_ARGS__)
> +#define __TO_U64_3(x, ...)             , (u64)(x) __TO_U64_2(__VA_ARGS__)
> +#define __TO_U64_4(x, ...)             , (u64)(x) __TO_U64_3(__VA_ARGS__)
> +#define __TO_U64_5(x, ...)             , (u64)(x) __TO_U64_4(__VA_ARGS__)
> +#define __TO_U64_6(x, ...)             , (u64)(x) __TO_U64_5(__VA_ARGS__)
> +#define __TO_U64_7(x, ...)             , (u64)(x) __TO_U64_6(__VA_ARGS__)
> +#define __TO_U64_8(x, ...)             , (u64)(x) __TO_U64_7(__VA_ARGS__)
> +
> +#define __TO_U64_X(N, ...)             CONCATENATE(__TO_U64_, N)(__VA_ARGS__)
> +#define __TO_U64(...)                  __TO_U64_X(COUNT_ARGS(__VA_ARGS__), ##__VA_ARGS__)
> +
> +REMOTE_EVENT_FORMAT(hyp_printk, HE_STRUCT(he_field(u16, fmt_id) he_field(u64, args[])));
> +extern struct hyp_event_id hyp_event_id_hyp_printk;
> +
> +static __always_inline void __trace_hyp_printk(struct hyp_string_fmt *fmt, int nr_args, ...)
> +{
> +       struct remote_event_format_hyp_printk *entry;
> +       va_list va;
> +       int i;
> +
> +       if (!atomic_read(&hyp_event_id_hyp_printk.enabled))
> +               return;
> +
> +       entry = tracing_reserve_entry(struct_size(entry, args, nr_args));
> +       if (!entry)
> +               return;
> +
> +       entry->hdr.id = hyp_event_id_hyp_printk.id;
> +       entry->fmt_id = fmt - __hyp_string_fmts_start;

nit: fmt_id is u16, the subtraction is ptrdiff_t. Silent truncation if
the section ever has more than 65536 entries. Not realistic today, but
a WARN_ON on the section size in hyp_trace_init_events() would catch
it at boot for free.

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> +
> +       va_start(va, nr_args);
> +       for (i = 0; i < nr_args; i++)
> +               entry->args[i] = va_arg(va, u64);
> +       va_end(va);
> +
> +       tracing_commit_entry();
> +}
> +
> +
> +#define trace_hyp_printk(__fmt, __args...)                                             \
> +do {                                                                                   \
> +       static struct hyp_string_fmt __used __section("_hyp_string_fmts") fmt = {       \
> +               .fmt = __fmt                                                            \
> +       };                                                                              \
> +       BUILD_BUG_ON(sizeof(__fmt) > HYP_STRING_FMT_MAX_SIZE);                          \
> +       /* __TO_U64 prepends a comma if there are arguments */                          \
> +       __trace_hyp_printk(&fmt, COUNT_ARGS(__args) __TO_U64(__args));                  \
> +} while (0)
> +
>  int __tracing_load(unsigned long desc_va, size_t desc_size);
>  void __tracing_unload(void);
>  int __tracing_enable(bool enable);
> @@ -58,6 +121,8 @@ static inline void *tracing_reserve_entry(unsigned long length) { return NULL; }
>  static inline void tracing_commit_entry(void) { }
>  #define HYP_EVENT(__name, __proto, __struct, __assign, __printk)      \
>         static inline void trace_##__name(__proto) {}
> +#define REMOTE_EVENT_CUSTOM_PRINTK(...)
> +#define trace_hyp_printk(fmt, args...) do { } while (0)
>
>  static inline int __tracing_load(unsigned long desc_va, size_t desc_size) { return -ENODEV; }
>  static inline void __tracing_unload(void) { }
> diff --git a/arch/arm64/kvm/hyp/nvhe/events.c b/arch/arm64/kvm/hyp/nvhe/events.c
> index add9383aadb5..12223d2e3618 100644
> --- a/arch/arm64/kvm/hyp/nvhe/events.c
> +++ b/arch/arm64/kvm/hyp/nvhe/events.c
> @@ -9,6 +9,12 @@
>
>  #include <nvhe/define_events.h>
>
> +/*
> + * The hyp_printk event is not declared with HYP_EVENT in kvm_hypevents.h,
> + * so we manually add the boilerplate here.
> + */
> +HYP_EVENT(hyp_printk, 0, 0, 0, 0);
> +
>  int __tracing_enable_event(unsigned short id, bool enable)
>  {
>         struct hyp_event_id *event_id = &__hyp_event_ids_start[id];
> diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
> index 821bc93ecdd1..187a8a295d6f 100644
> --- a/arch/arm64/kvm/hyp_trace.c
> +++ b/arch/arm64/kvm/hyp_trace.c
> @@ -391,6 +391,9 @@ static struct trace_remote_callbacks trace_remote_callbacks = {
>
>  static const char *__hyp_enter_exit_reason_str(u8 reason);
>
> +struct remote_event_format_hyp_printk;
> +static void __hyp_trace_printk(struct remote_event_format_hyp_printk *entry, struct trace_seq *seq);
> +
>  #include "define_hypevents.h"
>
>  static const char *__hyp_enter_exit_reason_str(u8 reason)
> @@ -409,6 +412,61 @@ static const char *__hyp_enter_exit_reason_str(u8 reason)
>         return strs[min(reason, HYP_REASON_UNKNOWN)];
>  }
>
> +static void __hyp_trace_printk(struct remote_event_format_hyp_printk *entry, struct trace_seq *seq)
> +{
> +       const char *fmt = (const char *)(&__hyp_string_fmts_start[entry->fmt_id]);
> +       struct ring_buffer_event *evt = (void *)entry - RB_EVNT_HDR_SIZE;
> +       int nr_args;
> +
> +       trace_seq_putc(seq, ' ');
> +
> +       if ((void *)fmt >= (void *)__hyp_string_fmts_end) {
> +               trace_seq_printf(seq, "Unknown hyp_string_fmt ID %d\n", entry->fmt_id);
> +               return;
> +       }
> +
> +       nr_args = (ring_buffer_event_length(evt) -
> +                  offsetof(struct remote_event_format_hyp_printk, args)) / sizeof(entry->args[0]);
> +       switch (nr_args) {
> +       case 0:
> +               trace_seq_printf(seq, fmt);
> +               break;
> +       case 1:
> +               trace_seq_printf(seq, fmt, entry->args[0]);
> +               break;
> +       case 2:
> +               trace_seq_printf(seq, fmt, entry->args[0], entry->args[1]);
> +               break;
> +       case 3:
> +               trace_seq_printf(seq, fmt, entry->args[0], entry->args[1], entry->args[2]);
> +               break;
> +       case 4:
> +               trace_seq_printf(seq, fmt, entry->args[0], entry->args[1], entry->args[2],
> +                                entry->args[3]);
> +               break;
> +       case 5:
> +               trace_seq_printf(seq, fmt, entry->args[0], entry->args[1], entry->args[2],
> +                                entry->args[3], entry->args[4]);
> +               break;
> +       case 6:
> +               trace_seq_printf(seq, fmt, entry->args[0], entry->args[1], entry->args[2],
> +                                entry->args[3], entry->args[4], entry->args[5]);
> +               break;
> +       case 7:
> +               trace_seq_printf(seq, fmt, entry->args[0], entry->args[1], entry->args[2],
> +                                entry->args[3], entry->args[4], entry->args[5], entry->args[6]);
> +               break;
> +       default:
> +               trace_seq_printf(seq, fmt, entry->args[0], entry->args[1],
> +                                entry->args[2], entry->args[3], entry->args[4], entry->args[5],
> +                                entry->args[6], entry->args[7]);
> +               break;
> +       }
> +
> +       if (seq->buffer[trace_seq_used(seq) - 1] != '\n')
> +               trace_seq_putc(seq, '\n');
> +}
> +
>  static void __init hyp_trace_init_events(void)
>  {
>         struct hyp_event_id *hyp_event_id = __hyp_event_ids_start;
> --
> 2.54.0.1136.gdb2ca164c4-goog
>
