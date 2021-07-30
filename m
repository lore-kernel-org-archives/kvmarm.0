Return-Path: <SRS0=HDjL=MW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C468C432BE
	for <kvmarm@archiver.kernel.org>; Fri, 30 Jul 2021 18:25:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C333960F9B
	for <kvmarm@archiver.kernel.org>; Fri, 30 Jul 2021 18:25:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C333960F9B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B58D4B0EC;
	Fri, 30 Jul 2021 14:25:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PYG27Xw8lIGs; Fri, 30 Jul 2021 14:25:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A0B264B0D4;
	Fri, 30 Jul 2021 14:25:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D857E4B0B4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 14:24:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EG91TxtnEHUM for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jul 2021 14:24:58 -0400 (EDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com
 [209.85.208.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 60EE44A49C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 14:24:58 -0400 (EDT)
Received: by mail-lj1-f171.google.com with SMTP id n6so13579327ljp.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 11:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=rqMYq2CWXiNrNOrfwEzFO/KTNa6FWzj2w0cC6kBlhtc=;
 b=VPhZ21dZARDbHcMs08hZe0sJhMKOZMXsX2u8qhO8X6scpIJjrtbj4VWZHqI/4GigEj
 1qCt/sKqN3deIP+2fzjE3nzzmsNkXbLWrrBiEDQbv/9qhkfbnK4MP+3rujkEHb43uefs
 Klk8/GZ07sxxhBQe4K96vYdQIMlQZKjelr+UfdlhMywAp5dQb+bkzptisPTZc55NTOrX
 vA2XEY9DS0n9G+3pBSEnCw7PHygN2LSM3y5Qs9Ck3BdGZnZsAXOML62gO/2iAY5L5gJJ
 upjTgnsf4tdR0tbZqgggxPVSsL4qpHlHttYumbNL9TmR6gqv4tNidTszuHH8uh7caf+B
 cD5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=rqMYq2CWXiNrNOrfwEzFO/KTNa6FWzj2w0cC6kBlhtc=;
 b=V+Ftqy0MV/MMu3IsO4m2q5nISFLuWk0oUT+5xBkOWbG36wfULP5SfroYzMpCjMCXqw
 KP/QsdIHU0wIk2fFfe+EfyhECyKDEhEpmsgG5TeB/b7YxtaPNDUw4rxMaG/UkfOnne8R
 DONkTyLrxsZA88E7Pip22rTaCac7krUr6MLjQHGyJhHXqnvu49+xIacvu4GmHCRbGWZ2
 e0KPJCl2J6ZhMw93OwP4gXkiGIwwfDxkjklgogofYkvMcI50WJ8tHR5J/5md0qD33zwL
 2NthzQKqNjpslxNbh6ov7kzORuYFzmEvqX5egyYVSsycOcaOIZUwclUJJBeZ7CLKbg94
 nQGg==
X-Gm-Message-State: AOAM531ZNPp0XyquDkCfDCAI+4vDA4Z1gYOHcpqUHzl2Z8Ms8HVRRlr0
 KC4tmbRe7jR8TFcPM0En5v0wW5wF6cQ9UufpzWv9hQ==
X-Google-Smtp-Source: ABdhPJzdtPl6p6Ma5FhWcVM12t2+r5Hw1Cc+5/G0Nha/v+f1rF5QoRu64gmbzCNjcgoiXH4m7bT9LOCk65t0MJXdddw=
X-Received: by 2002:a2e:535c:: with SMTP id t28mr2435423ljd.129.1627669496637; 
 Fri, 30 Jul 2021 11:24:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210729173300.181775-1-oupton@google.com>
 <20210729173300.181775-2-oupton@google.com>
 <YQQ7fuOhSoJVfkYn@google.com>
In-Reply-To: <YQQ7fuOhSoJVfkYn@google.com>
From: Oliver Upton <oupton@google.com>
Date: Fri, 30 Jul 2021 11:24:45 -0700
Message-ID: <CAOQ_QsgVqS_PuJo8F10Gg5Xw+tKt+5gDx+kJf1j3CiPO4MAOqg@mail.gmail.com>
Subject: Re: [PATCH v5 01/13] KVM: x86: Report host tsc and realtime values in
 KVM_GET_CLOCK
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Raghavendra Rao Anata <rananta@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, Jul 30, 2021 at 10:48 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Jul 29, 2021, Oliver Upton wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 916c976e99ab..e052c7afaac4 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -2782,17 +2782,24 @@ static void kvm_gen_update_masterclock(struct kvm *kvm)
> >  #endif
> >  }
> >
> > -u64 get_kvmclock_ns(struct kvm *kvm)
> > +/*
> > + * Returns true if realtime and TSC values were written back to the caller.
> > + * Returns false if a clock triplet cannot be obtained, such as if the host's
> > + * realtime clock is not based on the TSC.
> > + */
> > +static bool get_kvmclock_and_realtime(struct kvm *kvm, u64 *kvmclock_ns,
> > +                                   u64 *realtime_ns, u64 *tsc)
> >  {
> >       struct kvm_arch *ka = &kvm->arch;
> >       struct pvclock_vcpu_time_info hv_clock;
> >       unsigned long flags;
> > -     u64 ret;
> > +     bool ret = false;
> >
> >       spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
> >       if (!ka->use_master_clock) {
> >               spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
> > -             return get_kvmclock_base_ns() + ka->kvmclock_offset;
> > +             *kvmclock_ns = get_kvmclock_base_ns() + ka->kvmclock_offset;
> > +             return false;
> >       }
> >
> >       hv_clock.tsc_timestamp = ka->master_cycle_now;
> > @@ -2803,18 +2810,36 @@ u64 get_kvmclock_ns(struct kvm *kvm)
> >       get_cpu();
> >
> >       if (__this_cpu_read(cpu_tsc_khz)) {
> > +             struct timespec64 ts;
> > +             u64 tsc_val;
> > +
> >               kvm_get_time_scale(NSEC_PER_SEC, __this_cpu_read(cpu_tsc_khz) * 1000LL,
> >                                  &hv_clock.tsc_shift,
> >                                  &hv_clock.tsc_to_system_mul);
> > -             ret = __pvclock_read_cycles(&hv_clock, rdtsc());
> > +
> > +             if (kvm_get_walltime_and_clockread(&ts, &tsc_val)) {
> > +                     *realtime_ns = ts.tv_nsec + NSEC_PER_SEC * ts.tv_sec;
> > +                     *tsc = tsc_val;
> > +                     ret = true;
> > +             }
> > +
> > +             *kvmclock_ns = __pvclock_read_cycles(&hv_clock, tsc_val);
>
> This is buggy, as tsc_val is not initialized if kvm_get_walltime_and_clockread()
> returns false.  This also straight up fails to compile on 32-bit kernels because
> kvm_get_walltime_and_clockread() is wrapped with CONFIG_X86_64.

Pssh... works on my machine ;-)

>
> A gross way to resolve both issues would be (see below regarding 'data'):
>
>         if (__this_cpu_read(cpu_tsc_khz)) {
> #ifdef CONFIG_X86_64
>                 struct timespec64 ts;
>
>                 if (kvm_get_walltime_and_clockread(&ts, &data->host_tsc)) {
>                         data->realtime = ts.tv_nsec + NSEC_PER_SEC * ts.tv_sec;
>                         data->flags |= KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC;
>                 } else
> #endif
>                 data->host_tsc = rdtsc();
>
>                 kvm_get_time_scale(NSEC_PER_SEC, __this_cpu_read(cpu_tsc_khz) * 1000LL,
>                                    &hv_clock.tsc_shift,
>                                    &hv_clock.tsc_to_system_mul);
>
>                 data->clock = __pvclock_read_cycles(&hv_clock, data->host_tsc);
>         } else {
>                 data->clock = get_kvmclock_base_ns() + ka->kvmclock_offset;
>         }
>

I'll mull on this if there's any cleaner way to fix it, but thanks for
the suggested fix! I missed the x86_64 ifdefs first time around.

> >       } else
>
> Not your code, but this needs braces.

Ack.

>
> > -             ret = get_kvmclock_base_ns() + ka->kvmclock_offset;
> > +             *kvmclock_ns = get_kvmclock_base_ns() + ka->kvmclock_offset;
> >
> >       put_cpu();
> >
> >       return ret;
> >  }
>
> ...
>
> > @@ -5820,6 +5845,68 @@ int kvm_arch_pm_notifier(struct kvm *kvm, unsigned long state)
> >  }
> >  #endif /* CONFIG_HAVE_KVM_PM_NOTIFIER */
> >
> > +static int kvm_vm_ioctl_get_clock(struct kvm *kvm,
> > +                               void __user *argp)
> > +{
> > +     struct kvm_clock_data data;
> > +
> > +     memset(&data, 0, sizeof(data));
> > +
> > +     if (get_kvmclock_and_realtime(kvm, &data.clock, &data.realtime,
> > +                                   &data.host_tsc))
> > +             data.flags |= KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC;
> > +
> > +     if (kvm->arch.use_master_clock)
> > +             data.flags |= KVM_CLOCK_TSC_STABLE;
>
> I know nothing about the actual behavior, but this appears to have a potential
> race (though it came from the existing code).  get_kvmclock_and_realtime() checks
> arch.use_master_clock under pvclock_gtod_sync_lock, but this does not.  Even if
> that's functionally ok, it's a needless complication.
>
> Fixing that weirdness would also provide an opportunity to clean up the API,
> e.g. the boolean return is not exactly straightforward.  The simplest approach
> would be to take "struct kvm_clock_data *data" in get_kvmclock_and_realtime()
> instead of multiple params.  Then that helper can set the flags accordingly, thus
> avoiding the question of whether or not there's a race and eliminating the boolean
> return.  E.g.

Yeah, agreed. I think it may be best to separate fixing the mess from
the new API here.

>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e052c7afaac4..872a53a7c467 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2782,25 +2782,20 @@ static void kvm_gen_update_masterclock(struct kvm *kvm)
>  #endif
>  }
>
> -/*
> - * Returns true if realtime and TSC values were written back to the caller.
> - * Returns false if a clock triplet cannot be obtained, such as if the host's
> - * realtime clock is not based on the TSC.
> - */
> -static bool get_kvmclock_and_realtime(struct kvm *kvm, u64 *kvmclock_ns,
> -                                     u64 *realtime_ns, u64 *tsc)
> +static void get_kvmclock_and_realtime(struct kvm *kvm,
> +                                     struct kvm_clock_data *data)
>  {
>         struct kvm_arch *ka = &kvm->arch;
>         struct pvclock_vcpu_time_info hv_clock;
>         unsigned long flags;
> -       bool ret = false;
>
>         spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
>         if (!ka->use_master_clock) {
>                 spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
> -               *kvmclock_ns = get_kvmclock_base_ns() + ka->kvmclock_offset;
> -               return false;
> +               data->clock = get_kvmclock_base_ns() + ka->kvmclock_offset;
> +               return;
>         }
> +       data->flags |= KVM_CLOCK_TSC_STABLE;
>
>         hv_clock.tsc_timestamp = ka->master_cycle_now;
>         hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;
> @@ -2810,34 +2805,40 @@ static bool get_kvmclock_and_realtime(struct kvm *kvm, u64 *kvmclock_ns,
>         get_cpu();
>
>         if (__this_cpu_read(cpu_tsc_khz)) {
> +#ifdef CONFIG_X86_64
>                 struct timespec64 ts;
> -               u64 tsc_val;
> +
> +               if (kvm_get_walltime_and_clockread(&ts, &data->host_tsc)) {
> +                       data->realtime = ts.tv_nsec + NSEC_PER_SEC * ts.tv_sec;
> +                       data->flags |= KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC;
> +               } else
> +#endif
> +               data->host_tsc = rdtsc();
>
>                 kvm_get_time_scale(NSEC_PER_SEC, __this_cpu_read(cpu_tsc_khz) * 1000LL,
>                                    &hv_clock.tsc_shift,
>                                    &hv_clock.tsc_to_system_mul);
>
> -               if (kvm_get_walltime_and_clockread(&ts, &tsc_val)) {
> -                       *realtime_ns = ts.tv_nsec + NSEC_PER_SEC * ts.tv_sec;
> -                       *tsc = tsc_val;
> -                       ret = true;
> -               }
> -
> -               *kvmclock_ns = __pvclock_read_cycles(&hv_clock, tsc_val);
> -       } else
> -               *kvmclock_ns = get_kvmclock_base_ns() + ka->kvmclock_offset;
> +               data->clock = __pvclock_read_cycles(&hv_clock, data->host_tsc);
> +       } else {
> +               data->clock = get_kvmclock_base_ns() + ka->kvmclock_offset;
> +       }
>
>         put_cpu();
> -
> -       return ret;
>  }
>
>  u64 get_kvmclock_ns(struct kvm *kvm)
>  {
> -       u64 kvmclock_ns, realtime_ns, tsc;
> +       struct kvm_clock_data data;
>
> -       get_kvmclock_and_realtime(kvm, &kvmclock_ns, &realtime_ns, &tsc);
> -       return kvmclock_ns;
> +       /*
> +        * Zero flags as it's accessed RMW, leave everything else uninitialized
> +        * as clock is always written and no other fields are consumed.
> +        */
> +       data.flags = 0;
> +
> +       get_kvmclock_and_realtime(kvm, &data);
> +       return data.clock;
>  }
>
>  static void kvm_setup_pvclock_page(struct kvm_vcpu *v,
> @@ -5852,12 +5853,7 @@ static int kvm_vm_ioctl_get_clock(struct kvm *kvm,
>
>         memset(&data, 0, sizeof(data));
>
> -       if (get_kvmclock_and_realtime(kvm, &data.clock, &data.realtime,
> -                                     &data.host_tsc))
> -               data.flags |= KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC;
> -
> -       if (kvm->arch.use_master_clock)
> -               data.flags |= KVM_CLOCK_TSC_STABLE;
> +       get_kvmclock_and_realtime(kvm, &data);
>
>         if (copy_to_user(argp, &data, sizeof(data)))
>                 return -EFAULT;
>
> > +
> > +     if (copy_to_user(argp, &data, sizeof(data)))
> > +             return -EFAULT;
> > +
> > +     return 0;
> > +}
> > +
> > +static int kvm_vm_ioctl_set_clock(struct kvm *kvm,
> > +                               void __user *argp)
> > +{
> > +     struct kvm_arch *ka = &kvm->arch;
> > +     struct kvm_clock_data data;
> > +     u64 now_raw_ns;
> > +
> > +     if (copy_from_user(&data, argp, sizeof(data)))
> > +             return -EFAULT;
> > +
> > +     if (data.flags & ~KVM_CLOCK_REALTIME)
> > +             return -EINVAL;
>
> Huh, this an odd ABI, the output of KVM_GET_CLOCK isn't legal input to KVM_SET_CLOCK.
> The existing code has the same behavior, so apparently it's ok, just odd.

Quite the head scratcher to me as well /shrug

> > +
> > +     /*
> > +      * TODO: userspace has to take care of races with VCPU_RUN, so
> > +      * kvm_gen_update_masterclock() can be cut down to locked
> > +      * pvclock_update_vm_gtod_copy().
> > +      */
> > +     kvm_gen_update_masterclock(kvm);
> > +
> > +     spin_lock_irq(&ka->pvclock_gtod_sync_lock);
> > +     if (data.flags & KVM_CLOCK_REALTIME) {
> > +             u64 now_real_ns = ktime_get_real_ns();
> > +
> > +             /*
> > +              * Avoid stepping the kvmclock backwards.
> > +              */
> > +             if (now_real_ns > data.realtime)
> > +                     data.clock += now_real_ns - data.realtime;
> > +     }
> > +
> > +     if (ka->use_master_clock)
> > +             now_raw_ns = ka->master_kernel_ns;
> > +     else
> > +             now_raw_ns = get_kvmclock_base_ns();
> > +     ka->kvmclock_offset = data.clock - now_raw_ns;
> > +     spin_unlock_irq(&ka->pvclock_gtod_sync_lock);
> > +
> > +     kvm_make_all_cpus_request(kvm, KVM_REQ_CLOCK_UPDATE);
> > +     return 0;
> > +}
> > +
> >  long kvm_arch_vm_ioctl(struct file *filp,
> >                      unsigned int ioctl, unsigned long arg)
> >  {
> > @@ -6064,57 +6151,11 @@ long kvm_arch_vm_ioctl(struct file *filp,
> >       }
> >  #endif
> >       case KVM_SET_CLOCK: {
>
> The curly braces can be dropped, both here and in KVM_GET_CLOCK.

Ack.

> >       }
> >       case KVM_GET_CLOCK: {
>
> ...
>
> >       }

As always, thanks for the careful review Sean!

--
Best,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
