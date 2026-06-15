Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594353C5850
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 08:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781512185; cv=none; b=iNmXBImm18F0+hh+alxf54IvH+tsONykbZNhNRAtkZwBWyBRgshAxy9yPpG0JKRLEBrVfisvTtH+f8QxfVW6Y3WifdgX5VtOtrXTaKS+VDeHt7nJdiugmMVUYXkprYSHWxyd04bh1u1KRVpDd8yG3EKB71NRwDc1LaZKu3cDGb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781512185; c=relaxed/simple;
	bh=SAaDL9FwKJAUBfOLWNe5ncp5//mdsetgcPR1ystFDv0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BxsURkz5DJG95tbPC2BXB+TzLZcYcwuI2ZKqHRJX/9Xgr2wnyHzAEu02J3/pma66nUOH+/+naB/CwbP9a2HidjoL7zTjMWc1bGvyyd4qeNx/nvFHQbICwLELzOJ2FUGHXdoSRj0mxQ1d4wiqMOJKmh6/wDUoALSpt1K3smwtfDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W4+z1hka; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W4+z1hka"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-bf1cdcfd6deso340233366b.3
        for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 01:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781512179; x=1782116979; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qh/f0emaQJNnjCet88c5hb5H0v5eyVAvoPkaJcGoOm8=;
        b=W4+z1hkaw5v0rIYpFySQmQB9jKlw/EVnyIsDOu9hEyyY+vlvNDV9oWSZfenMmhbbF5
         AeZd4lIKwaQgHewmwBsLgKzJQKTqx6PviO2FebvYCmfCkGQ4HQvQj83fembrRgXR9BJI
         NoVJ1C2Hk2/v9wClQOCjVkyWyBqqlDB9FHPKF4yeMMrLI12DrZ3xD+2dMja/Rp7iyGov
         av7K2EHyuCH1ddw8VdyKNpt2Fwy4m3OOLZsMAkCLTlbgzGwZS/ClYiNRf5XvmzKmQ5Ta
         kfp9kGCezesESDC5/N15kMQYLktuqKTrWAzTx1hv/Y+l+w6wr/sxa37ZM1q5OAosLJn1
         r2Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781512179; x=1782116979;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qh/f0emaQJNnjCet88c5hb5H0v5eyVAvoPkaJcGoOm8=;
        b=LXdsUaK3vzbHqRUs3p5jkI6Bo7EIqS7Q7tggc4POITaXiQF1MeqGzhfy3D/4g5KeQj
         MDu5h86/d3ZDqjfvPL8ecHas+lkhUa6Kgtel4VhgQroS7taWkVnNKWm/mfAWakedU1Cg
         DFpWosgqPyXAR75+Bn5DYuANsypcXGcXK4y2c4Cv8C7ARibSFv/igJTqF4yOE1fgxCt1
         lxW3q7I1dXN6As+fKKEnU6hIMM1IsjLIOAQHlJnLp5TXt+tcPWuGu1ba6ZiOHO9/fAUk
         rLSwhU9UBxfDt1uRGUlKrF9TI1VpjL5nN9ZYe0+exEONXlVHLxQLOsBQZiQ/7gNDSl88
         xyjg==
X-Forwarded-Encrypted: i=1; AFNElJ/pp6v3Z2jsX5ljwTkH2fNYggLDvk5C3FzRUNw4Sr8lwUGl2pcJgfBEzOL8ulwicegE7iuulx0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwwscDX359EQXlMrOnWHf5iVqFr0HF8GswuFySQO9I57/j5oyF9
	anEgP2P3SZVIpRBdlIOjlEW1WkmQcoDWQMzoOR5GPeLgsS2jomB0uerCXrqz4izv60L84c+Vu6Y
	VV0NKEA==
X-Gm-Gg: Acq92OF059DtRZz+6JYtWn9gS66M8JHlg6uXQZoW1Oz4LkioDDSATLq2MIJdYUPcLUK
	YelF6ahR7SpzBwo/rh9Yevb/po6QP65ndkw5zpBU2rynFS60dqra3Ld1Bcjd5xXqf25Fn3ZhJ0+
	7e3QusJpPJ8l3hiPIwfnAB48aeSkdlSKm2OObSjyoPMs31mMFIRCZK2JKtmrQGb3A1JZDVl8b6L
	CRD8rVq8SnhRva3hbyHSLlGZbil6sRHg9rPqBuUCD0E6JZhPpFimpercMCAsOSvOznysT4j2AVE
	jOqTdFCEPDRtRfjnQNFQHjoke1llmwTvSCLid5XBLWlpcoKfG54d4kWXGJN54QKv0wovlFMQlnV
	2SFNaKzZxX3JBMZYzk9bHCiNqS+BLlivmXCV2MN5DB8xE70PIHVmKDOeEaQdpDV6IujSy3lAjp3
	PYR/FEM+Cx2Hvvc5V3rfdoYU0VQM/7rL/Bo3xpa3zz74NRmQrnmGNbbUnP4LLQU/qXrGQ=
X-Received: by 2002:a17:906:cc5a:b0:bfd:aee0:5156 with SMTP id a640c23a62f3a-bfe2810469fmr388102966b.7.1781512178750;
        Mon, 15 Jun 2026 01:29:38 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bfdb83420e9sm405850366b.45.2026.06.15.01.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 01:29:38 -0700 (PDT)
Date: Mon, 15 Jun 2026 09:29:34 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, rostedt@goodmis.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kernel-team@android.com, qerret@google.com
Subject: Re: [PATCH v1 4/4] KVM: arm64: Add hyp_printk event to nVHE/pKVM hyp
Message-ID: <ai-37kQ0e_VCma2z@google.com>
References: <20260612142245.1015744-1-vdonnefort@google.com>
 <20260612142245.1015744-5-vdonnefort@google.com>
 <CA+EHjTwqp=Hjzyn469Gvm-JRNovfnj=0eFB5+Kei_9pRQrnG0Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTwqp=Hjzyn469Gvm-JRNovfnj=0eFB5+Kei_9pRQrnG0Q@mail.gmail.com>

On Sun, Jun 14, 2026 at 04:25:00PM +0100, Fuad Tabba wrote:
> Hi Vincent,
> 
> On Fri, 12 Jun 2026 at 15:22, Vincent Donnefort <vdonnefort@google.com> wrote:
> >
> > Create an event to allow developers to log pretty much anything into the
> > hypervisor tracing buffer with trace_hyp_printk(), just like the kernel
> > tracing has the function trace_printk().
> >
> >   trace_hyp_printk("foobar");
> >   trace_hyp_printk("foo=%d", foo);
> >   trace_hyp_printk("foo=%d bar=0x%016llx", foo, bar);
> >
> > To ensure writing into the tracing buffer is fast, store the string
> > format into a kernel-accessible ELF section. The hypervisor only has to
> > write into the event the string ID, which is the delta between the
> > hyp_string_fmt and the start of the ELF section.
> >
> > To not waste tracing buffer data, use a dynamic size. Each
> > argument is 8 bytes and the in-kernel printing function can simply know
> > how many of them there are by looking at the event length.
> >
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> >
> > diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h
> > index 743c49bd878f..8465b523cb1d 100644
> > --- a/arch/arm64/include/asm/kvm_hypevents.h
> > +++ b/arch/arm64/include/asm/kvm_hypevents.h
> > @@ -57,4 +57,18 @@ HYP_EVENT(selftest,
> >         ),
> >         RE_PRINTK("id=%llu", __entry->id)
> >  );
> > +
> > +/*
> > + * trace_hyp_printk() has too many specificities to be declared with HYP_EVENT().
> > + * However, we can use a REMOTE_EVENT macro to automatically do the declaration
> > + * for the kernel side.
> > + */
> > +REMOTE_EVENT_CUSTOM_PRINTK(hyp_printk,
> > +       0, /* id will be overwritten during hyp event init */
> > +       RE_STRUCT(
> > +               re_field(u16, fmt_id)
> > +               re_field(u64, args[])
> > +       ),
> > +       __hyp_trace_printk(evt, seq)
> > +);
> >  #endif
> > diff --git a/arch/arm64/include/asm/kvm_hyptrace.h b/arch/arm64/include/asm/kvm_hyptrace.h
> > index de133b735f72..46097105fdd8 100644
> > --- a/arch/arm64/include/asm/kvm_hyptrace.h
> > +++ b/arch/arm64/include/asm/kvm_hyptrace.h
> > @@ -23,4 +23,12 @@ extern struct remote_event __hyp_events_end[];
> >  extern struct hyp_event_id __hyp_event_ids_start[];
> >  extern struct hyp_event_id __hyp_event_ids_end[];
> >
> > +#define HYP_STRING_FMT_MAX_SIZE 128
> > +
> > +struct hyp_string_fmt {
> > +       const char      fmt[HYP_STRING_FMT_MAX_SIZE];
> > +};
> > +
> > +extern struct hyp_string_fmt __hyp_string_fmts_start[];
> > +extern struct hyp_string_fmt __hyp_string_fmts_end[];
> >  #endif
> > diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
> > index d4c7d45ae6bc..ec03621d7a81 100644
> > --- a/arch/arm64/kernel/image-vars.h
> > +++ b/arch/arm64/kernel/image-vars.h
> > @@ -141,6 +141,7 @@ KVM_NVHE_ALIAS(__hyp_rodata_end);
> >  #ifdef CONFIG_NVHE_EL2_TRACING
> >  KVM_NVHE_ALIAS(__hyp_event_ids_start);
> >  KVM_NVHE_ALIAS(__hyp_event_ids_end);
> > +KVM_NVHE_ALIAS(__hyp_string_fmts_start);
> >  #endif
> >
> >  /* pKVM static key */
> > diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
> > index e1ac876200a3..b6d62642b6bd 100644
> > --- a/arch/arm64/kernel/vmlinux.lds.S
> > +++ b/arch/arm64/kernel/vmlinux.lds.S
> > @@ -324,6 +324,10 @@ SECTIONS
> >                 __hyp_events_start = .;
> >                 *(SORT(_hyp_events.*))
> >                 __hyp_events_end = .;
> > +
> > +               __hyp_string_fmts_start = .;
> > +               *(_hyp_string_fmts)
> > +               __hyp_string_fmts_end = .;
> >         }
> >  #endif
> >         /*
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/define_events.h b/arch/arm64/kvm/hyp/include/nvhe/define_events.h
> > index 776d4c6cb702..370e8c2d39fe 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/define_events.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/define_events.h
> > @@ -10,5 +10,3 @@
> >  #define HYP_EVENT_MULTI_READ
> >  #include <asm/kvm_hypevents.h>
> >  #undef HYP_EVENT_MULTI_READ
> > -
> > -#undef HYP_EVENT
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/trace.h b/arch/arm64/kvm/hyp/include/nvhe/trace.h
> > index 8813ff250f8e..3d0b5c634bb3 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/trace.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/trace.h
> > @@ -46,6 +46,69 @@ static inline pid_t __tracing_get_vcpu_pid(struct kvm_cpu_context *host_ctxt)
> >  void *tracing_reserve_entry(unsigned long length);
> >  void tracing_commit_entry(void);
> >
> > +/*
> > + * The trace_hyp_printk boilerplate is too fiddly to be declared with
> > + * HYP_EVENT():
> > + *
> > + * The string format is stored into a kernel-accessible ELF section. The
> > + * hypervisor only writes the format ID.
> > + *
> > + * The function has a variadic prototype. We have no easy way to know each
> > + * argument width so they must all cast to u64.
> > + */
> > +#define REMOTE_EVENT_CUSTOM_PRINTK(...)
> > +
> > +#define __TO_U64_0()
> > +#define __TO_U64_1(x)                  , (u64)(x)
> > +#define __TO_U64_2(x, ...)             , (u64)(x) __TO_U64_1(__VA_ARGS__)
> > +#define __TO_U64_3(x, ...)             , (u64)(x) __TO_U64_2(__VA_ARGS__)
> > +#define __TO_U64_4(x, ...)             , (u64)(x) __TO_U64_3(__VA_ARGS__)
> > +#define __TO_U64_5(x, ...)             , (u64)(x) __TO_U64_4(__VA_ARGS__)
> > +#define __TO_U64_6(x, ...)             , (u64)(x) __TO_U64_5(__VA_ARGS__)
> > +#define __TO_U64_7(x, ...)             , (u64)(x) __TO_U64_6(__VA_ARGS__)
> > +#define __TO_U64_8(x, ...)             , (u64)(x) __TO_U64_7(__VA_ARGS__)
> > +
> > +#define __TO_U64_X(N, ...)             CONCATENATE(__TO_U64_, N)(__VA_ARGS__)
> > +#define __TO_U64(...)                  __TO_U64_X(COUNT_ARGS(__VA_ARGS__), ##__VA_ARGS__)
> > +
> > +REMOTE_EVENT_FORMAT(hyp_printk, HE_STRUCT(he_field(u16, fmt_id) he_field(u64, args[])));
> > +extern struct hyp_event_id hyp_event_id_hyp_printk;
> > +
> > +static __always_inline void __trace_hyp_printk(struct hyp_string_fmt *fmt, int nr_args, ...)
> > +{
> > +       struct remote_event_format_hyp_printk *entry;
> > +       va_list va;
> > +       int i;
> > +
> > +       if (!atomic_read(&hyp_event_id_hyp_printk.enabled))
> > +               return;
> > +
> > +       entry = tracing_reserve_entry(struct_size(entry, args, nr_args));
> > +       if (!entry)
> > +               return;
> > +
> > +       entry->hdr.id = hyp_event_id_hyp_printk.id;
> > +       entry->fmt_id = fmt - __hyp_string_fmts_start;
> 
> nit: fmt_id is u16, the subtraction is ptrdiff_t. Silent truncation if
> the section ever has more than 65536 entries. Not realistic today, but
> a WARN_ON on the section size in hyp_trace_init_events() would catch
> it at boot for free.

Ack. That wouldn't cost anything. I'll add that in a v2

> 
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Tested-by: Fuad Tabba <tabba@google.com>
> 
> Cheers,
> /fuad
> 
> 
> > +
> > +       va_start(va, nr_args);
> > +       for (i = 0; i < nr_args; i++)
> > +               entry->args[i] = va_arg(va, u64);
> > +       va_end(va);
> > +
> > +       tracing_commit_entry();
> > +}
> > +
> > +
> > +#define trace_hyp_printk(__fmt, __args...)                                             \
> > +do {                                                                                   \
> > +       static struct hyp_string_fmt __used __section("_hyp_string_fmts") fmt = {       \
> > +               .fmt = __fmt                                                            \
> > +       };                                                                              \
> > +       BUILD_BUG_ON(sizeof(__fmt) > HYP_STRING_FMT_MAX_SIZE);                          \
> > +       /* __TO_U64 prepends a comma if there are arguments */                          \
> > +       __trace_hyp_printk(&fmt, COUNT_ARGS(__args) __TO_U64(__args));                  \
> > +} while (0)
> > +
> >  int __tracing_load(unsigned long desc_va, size_t desc_size);
> >  void __tracing_unload(void);
> >  int __tracing_enable(bool enable);
> > @@ -58,6 +121,8 @@ static inline void *tracing_reserve_entry(unsigned long length) { return NULL; }
> >  static inline void tracing_commit_entry(void) { }
> >  #define HYP_EVENT(__name, __proto, __struct, __assign, __printk)      \
> >         static inline void trace_##__name(__proto) {}
> > +#define REMOTE_EVENT_CUSTOM_PRINTK(...)
> > +#define trace_hyp_printk(fmt, args...) do { } while (0)
> >
> >  static inline int __tracing_load(unsigned long desc_va, size_t desc_size) { return -ENODEV; }
> >  static inline void __tracing_unload(void) { }
> > diff --git a/arch/arm64/kvm/hyp/nvhe/events.c b/arch/arm64/kvm/hyp/nvhe/events.c
> > index add9383aadb5..12223d2e3618 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/events.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/events.c
> > @@ -9,6 +9,12 @@
> >
> >  #include <nvhe/define_events.h>
> >
> > +/*
> > + * The hyp_printk event is not declared with HYP_EVENT in kvm_hypevents.h,
> > + * so we manually add the boilerplate here.
> > + */
> > +HYP_EVENT(hyp_printk, 0, 0, 0, 0);
> > +
> >  int __tracing_enable_event(unsigned short id, bool enable)
> >  {
> >         struct hyp_event_id *event_id = &__hyp_event_ids_start[id];
> > diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
> > index 821bc93ecdd1..187a8a295d6f 100644
> > --- a/arch/arm64/kvm/hyp_trace.c
> > +++ b/arch/arm64/kvm/hyp_trace.c
> > @@ -391,6 +391,9 @@ static struct trace_remote_callbacks trace_remote_callbacks = {
> >
> >  static const char *__hyp_enter_exit_reason_str(u8 reason);
> >
> > +struct remote_event_format_hyp_printk;
> > +static void __hyp_trace_printk(struct remote_event_format_hyp_printk *entry, struct trace_seq *seq);
> > +
> >  #include "define_hypevents.h"
> >
> >  static const char *__hyp_enter_exit_reason_str(u8 reason)
> > @@ -409,6 +412,61 @@ static const char *__hyp_enter_exit_reason_str(u8 reason)
> >         return strs[min(reason, HYP_REASON_UNKNOWN)];
> >  }
> >
> > +static void __hyp_trace_printk(struct remote_event_format_hyp_printk *entry, struct trace_seq *seq)
> > +{
> > +       const char *fmt = (const char *)(&__hyp_string_fmts_start[entry->fmt_id]);
> > +       struct ring_buffer_event *evt = (void *)entry - RB_EVNT_HDR_SIZE;
> > +       int nr_args;
> > +
> > +       trace_seq_putc(seq, ' ');
> > +
> > +       if ((void *)fmt >= (void *)__hyp_string_fmts_end) {
> > +               trace_seq_printf(seq, "Unknown hyp_string_fmt ID %d\n", entry->fmt_id);
> > +               return;
> > +       }
> > +
> > +       nr_args = (ring_buffer_event_length(evt) -
> > +                  offsetof(struct remote_event_format_hyp_printk, args)) / sizeof(entry->args[0]);
> > +       switch (nr_args) {
> > +       case 0:
> > +               trace_seq_printf(seq, fmt);
> > +               break;
> > +       case 1:
> > +               trace_seq_printf(seq, fmt, entry->args[0]);
> > +               break;
> > +       case 2:
> > +               trace_seq_printf(seq, fmt, entry->args[0], entry->args[1]);
> > +               break;
> > +       case 3:
> > +               trace_seq_printf(seq, fmt, entry->args[0], entry->args[1], entry->args[2]);
> > +               break;
> > +       case 4:
> > +               trace_seq_printf(seq, fmt, entry->args[0], entry->args[1], entry->args[2],
> > +                                entry->args[3]);
> > +               break;
> > +       case 5:
> > +               trace_seq_printf(seq, fmt, entry->args[0], entry->args[1], entry->args[2],
> > +                                entry->args[3], entry->args[4]);
> > +               break;
> > +       case 6:
> > +               trace_seq_printf(seq, fmt, entry->args[0], entry->args[1], entry->args[2],
> > +                                entry->args[3], entry->args[4], entry->args[5]);
> > +               break;
> > +       case 7:
> > +               trace_seq_printf(seq, fmt, entry->args[0], entry->args[1], entry->args[2],
> > +                                entry->args[3], entry->args[4], entry->args[5], entry->args[6]);
> > +               break;
> > +       default:
> > +               trace_seq_printf(seq, fmt, entry->args[0], entry->args[1],
> > +                                entry->args[2], entry->args[3], entry->args[4], entry->args[5],
> > +                                entry->args[6], entry->args[7]);
> > +               break;
> > +       }
> > +
> > +       if (seq->buffer[trace_seq_used(seq) - 1] != '\n')
> > +               trace_seq_putc(seq, '\n');
> > +}
> > +
> >  static void __init hyp_trace_init_events(void)
> >  {
> >         struct hyp_event_id *hyp_event_id = __hyp_event_ids_start;
> > --
> > 2.54.0.1136.gdb2ca164c4-goog
> >
