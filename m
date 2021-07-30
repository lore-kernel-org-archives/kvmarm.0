Return-Path: <SRS0=pkzt=MX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E71BC4320E
	for <kvmarm@archiver.kernel.org>; Sat, 31 Jul 2021 09:33:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1053261042
	for <kvmarm@archiver.kernel.org>; Sat, 31 Jul 2021 09:33:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1053261042
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A76DB4A023;
	Sat, 31 Jul 2021 05:33:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YcljkslbMm+n; Sat, 31 Jul 2021 05:33:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FEFF4B0A1;
	Sat, 31 Jul 2021 05:33:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F15E54B0CB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 13:48:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WDqzOSZQgcMR for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jul 2021 13:48:52 -0400 (EDT)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
 [209.85.216.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3C2C14B0BC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 13:48:52 -0400 (EDT)
Received: by mail-pj1-f52.google.com with SMTP id
 pf12-20020a17090b1d8cb0290175c085e7a5so21921602pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 10:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=UmB59NwUASoAiuqPG0gXKQPa2DHp4E2y7rCLlLWAM6Y=;
 b=YhdhHZ26TdjmARyTr29rFcM9xOHAWF1BwCkf8kqDrwr8J1Bm0qm1Dh4YPg5U2+2eAa
 IpP9lfWz0XIcHXUEGy4vQAMIPq7mS2JxkqQS7aXlaMB/TFPmx1TcVKZdoh9z1IgfxdUP
 g/FOIIkHDgr8xeVEhp5Du9CsguWSQkmI1+5YxDRRJeUsdmm32USonXUUG9VwDqeFtHoW
 kc6RI+T9Fnlsy3mAJxs13DXb3aoNPCDj/+Q0kJhIGk+A8fjBBnqQJqckjsGrdvHomcuQ
 b+u2eizRZuEl7PubKDPmmX4SCcmMczwkGXQZiilpA2cm4vkXnq42qBnCeXKSkiQiwH4A
 CXpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=UmB59NwUASoAiuqPG0gXKQPa2DHp4E2y7rCLlLWAM6Y=;
 b=hXh7ow3btMDcOtjeAsnBbPFBN0eqHSLicz63q2WVi/ekQmAtFd1wTj8LF7WV5O/JCh
 GizMbai2RVbc1cAqXdmYaxYvAbee1BkqAWOPHT2pCIeLkAH1Ypziq90O/2/IVCrJj6+S
 EIsJnRFskcAxhvY+rNDzOC7SMxRW488dtm/hPnRsiXmXozTpbr4p/MJdMtOjwBjaMAv/
 vcyxz8AXlaFiyHCWk/0RsUcQKKmygjUEog9g5joK/YWica0+SnOy7WpwSebN0/gsO3+S
 mypxxEjmfHXxX7vAZbBmSkqJW6vrBeiyHE0Nycyfe03nTO6BKtTnQun4+0V8rrk+35Cs
 DLHA==
X-Gm-Message-State: AOAM533/MwrkA8dxVwCyh4g0oS4WF3XG5hlzDcsE13ml7BwmtJT/owwO
 ceglskLc1v43kEgR5W8+Ejcg5g==
X-Google-Smtp-Source: ABdhPJyBbuBExkFZTKgnnW1Em8rYr9r6DdkNQcwT5+VrDs5bteCbeJWLOAaPBgV2dlgXiIzkX2BjuA==
X-Received: by 2002:a17:90a:5913:: with SMTP id
 k19mr4288014pji.30.1627667330975; 
 Fri, 30 Jul 2021 10:48:50 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id d134sm3223414pfd.60.2021.07.30.10.48.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 30 Jul 2021 10:48:50 -0700 (PDT)
Date: Fri, 30 Jul 2021 17:48:46 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v5 01/13] KVM: x86: Report host tsc and realtime values
 in KVM_GET_CLOCK
Message-ID: <YQQ7fuOhSoJVfkYn@google.com>
References: <20210729173300.181775-1-oupton@google.com>
 <20210729173300.181775-2-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210729173300.181775-2-oupton@google.com>
X-Mailman-Approved-At: Sat, 31 Jul 2021 05:33:51 -0400
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

On Thu, Jul 29, 2021, Oliver Upton wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 916c976e99ab..e052c7afaac4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2782,17 +2782,24 @@ static void kvm_gen_update_masterclock(struct kvm *kvm)
>  #endif
>  }
>  
> -u64 get_kvmclock_ns(struct kvm *kvm)
> +/*
> + * Returns true if realtime and TSC values were written back to the caller.
> + * Returns false if a clock triplet cannot be obtained, such as if the host's
> + * realtime clock is not based on the TSC.
> + */
> +static bool get_kvmclock_and_realtime(struct kvm *kvm, u64 *kvmclock_ns,
> +				      u64 *realtime_ns, u64 *tsc)
>  {
>  	struct kvm_arch *ka = &kvm->arch;
>  	struct pvclock_vcpu_time_info hv_clock;
>  	unsigned long flags;
> -	u64 ret;
> +	bool ret = false;
>  
>  	spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
>  	if (!ka->use_master_clock) {
>  		spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
> -		return get_kvmclock_base_ns() + ka->kvmclock_offset;
> +		*kvmclock_ns = get_kvmclock_base_ns() + ka->kvmclock_offset;
> +		return false;
>  	}
>  
>  	hv_clock.tsc_timestamp = ka->master_cycle_now;
> @@ -2803,18 +2810,36 @@ u64 get_kvmclock_ns(struct kvm *kvm)
>       get_cpu();
>
>       if (__this_cpu_read(cpu_tsc_khz)) {
> +             struct timespec64 ts;
> +             u64 tsc_val;
> +
>               kvm_get_time_scale(NSEC_PER_SEC, __this_cpu_read(cpu_tsc_khz) * 1000LL,
>                                  &hv_clock.tsc_shift,
>                                  &hv_clock.tsc_to_system_mul);
> -             ret = __pvclock_read_cycles(&hv_clock, rdtsc());
> +
> +             if (kvm_get_walltime_and_clockread(&ts, &tsc_val)) {
> +                     *realtime_ns = ts.tv_nsec + NSEC_PER_SEC * ts.tv_sec;
> +                     *tsc = tsc_val;
> +                     ret = true;
> +             }
> +
> +             *kvmclock_ns = __pvclock_read_cycles(&hv_clock, tsc_val);

This is buggy, as tsc_val is not initialized if kvm_get_walltime_and_clockread()
returns false.  This also straight up fails to compile on 32-bit kernels because
kvm_get_walltime_and_clockread() is wrapped with CONFIG_X86_64.

A gross way to resolve both issues would be (see below regarding 'data'):

	if (__this_cpu_read(cpu_tsc_khz)) {
#ifdef CONFIG_X86_64
		struct timespec64 ts;

		if (kvm_get_walltime_and_clockread(&ts, &data->host_tsc)) {
			data->realtime = ts.tv_nsec + NSEC_PER_SEC * ts.tv_sec;
			data->flags |= KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC;
		} else
#endif
		data->host_tsc = rdtsc();

		kvm_get_time_scale(NSEC_PER_SEC, __this_cpu_read(cpu_tsc_khz) * 1000LL,
				   &hv_clock.tsc_shift,
				   &hv_clock.tsc_to_system_mul);

		data->clock = __pvclock_read_cycles(&hv_clock, data->host_tsc);
	} else {
		data->clock = get_kvmclock_base_ns() + ka->kvmclock_offset;
	}


>       } else

Not your code, but this needs braces.

> -             ret = get_kvmclock_base_ns() + ka->kvmclock_offset;
> +             *kvmclock_ns = get_kvmclock_base_ns() + ka->kvmclock_offset;
>
>       put_cpu();
>
>       return ret;
>  } 

...

> @@ -5820,6 +5845,68 @@ int kvm_arch_pm_notifier(struct kvm *kvm, unsigned long state)
>  }
>  #endif /* CONFIG_HAVE_KVM_PM_NOTIFIER */
>  
> +static int kvm_vm_ioctl_get_clock(struct kvm *kvm,
> +				  void __user *argp)
> +{
> +	struct kvm_clock_data data;
> +
> +	memset(&data, 0, sizeof(data));
> +
> +	if (get_kvmclock_and_realtime(kvm, &data.clock, &data.realtime,
> +				      &data.host_tsc))
> +		data.flags |= KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC;
> +
> +	if (kvm->arch.use_master_clock)
> +		data.flags |= KVM_CLOCK_TSC_STABLE;

I know nothing about the actual behavior, but this appears to have a potential
race (though it came from the existing code).  get_kvmclock_and_realtime() checks
arch.use_master_clock under pvclock_gtod_sync_lock, but this does not.  Even if
that's functionally ok, it's a needless complication.

Fixing that weirdness would also provide an opportunity to clean up the API,
e.g. the boolean return is not exactly straightforward.  The simplest approach
would be to take "struct kvm_clock_data *data" in get_kvmclock_and_realtime()
instead of multiple params.  Then that helper can set the flags accordingly, thus
avoiding the question of whether or not there's a race and eliminating the boolean
return.  E.g.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e052c7afaac4..872a53a7c467 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2782,25 +2782,20 @@ static void kvm_gen_update_masterclock(struct kvm *kvm)
 #endif
 }
 
-/*
- * Returns true if realtime and TSC values were written back to the caller.
- * Returns false if a clock triplet cannot be obtained, such as if the host's
- * realtime clock is not based on the TSC.
- */
-static bool get_kvmclock_and_realtime(struct kvm *kvm, u64 *kvmclock_ns,
-                                     u64 *realtime_ns, u64 *tsc)
+static void get_kvmclock_and_realtime(struct kvm *kvm,
+                                     struct kvm_clock_data *data)
 {
        struct kvm_arch *ka = &kvm->arch;
        struct pvclock_vcpu_time_info hv_clock;
        unsigned long flags;
-       bool ret = false;
 
        spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
        if (!ka->use_master_clock) {
                spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
-               *kvmclock_ns = get_kvmclock_base_ns() + ka->kvmclock_offset;
-               return false;
+               data->clock = get_kvmclock_base_ns() + ka->kvmclock_offset;
+               return;
        }
+       data->flags |= KVM_CLOCK_TSC_STABLE;
 
        hv_clock.tsc_timestamp = ka->master_cycle_now;
        hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;
@@ -2810,34 +2805,40 @@ static bool get_kvmclock_and_realtime(struct kvm *kvm, u64 *kvmclock_ns,
        get_cpu();
 
        if (__this_cpu_read(cpu_tsc_khz)) {
+#ifdef CONFIG_X86_64
                struct timespec64 ts;
-               u64 tsc_val;
+
+               if (kvm_get_walltime_and_clockread(&ts, &data->host_tsc)) {
+                       data->realtime = ts.tv_nsec + NSEC_PER_SEC * ts.tv_sec;
+                       data->flags |= KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC;
+               } else
+#endif
+               data->host_tsc = rdtsc();
 
                kvm_get_time_scale(NSEC_PER_SEC, __this_cpu_read(cpu_tsc_khz) * 1000LL,
                                   &hv_clock.tsc_shift,
                                   &hv_clock.tsc_to_system_mul);
 
-               if (kvm_get_walltime_and_clockread(&ts, &tsc_val)) {
-                       *realtime_ns = ts.tv_nsec + NSEC_PER_SEC * ts.tv_sec;
-                       *tsc = tsc_val;
-                       ret = true;
-               }
-
-               *kvmclock_ns = __pvclock_read_cycles(&hv_clock, tsc_val);
-       } else
-               *kvmclock_ns = get_kvmclock_base_ns() + ka->kvmclock_offset;
+               data->clock = __pvclock_read_cycles(&hv_clock, data->host_tsc);
+       } else {
+               data->clock = get_kvmclock_base_ns() + ka->kvmclock_offset;
+       }
 
        put_cpu();
-
-       return ret;
 }
 
 u64 get_kvmclock_ns(struct kvm *kvm)
 {
-       u64 kvmclock_ns, realtime_ns, tsc;
+       struct kvm_clock_data data;
 
-       get_kvmclock_and_realtime(kvm, &kvmclock_ns, &realtime_ns, &tsc);
-       return kvmclock_ns;
+       /*
+        * Zero flags as it's accessed RMW, leave everything else uninitialized
+        * as clock is always written and no other fields are consumed.
+        */
+       data.flags = 0;
+
+       get_kvmclock_and_realtime(kvm, &data);
+       return data.clock;
 }
 
 static void kvm_setup_pvclock_page(struct kvm_vcpu *v,
@@ -5852,12 +5853,7 @@ static int kvm_vm_ioctl_get_clock(struct kvm *kvm,
 
        memset(&data, 0, sizeof(data));
 
-       if (get_kvmclock_and_realtime(kvm, &data.clock, &data.realtime,
-                                     &data.host_tsc))
-               data.flags |= KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC;
-
-       if (kvm->arch.use_master_clock)
-               data.flags |= KVM_CLOCK_TSC_STABLE;
+       get_kvmclock_and_realtime(kvm, &data);
 
        if (copy_to_user(argp, &data, sizeof(data)))
                return -EFAULT;

> +
> +	if (copy_to_user(argp, &data, sizeof(data)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static int kvm_vm_ioctl_set_clock(struct kvm *kvm,
> +				  void __user *argp)
> +{
> +	struct kvm_arch *ka = &kvm->arch;
> +	struct kvm_clock_data data;
> +	u64 now_raw_ns;
> +
> +	if (copy_from_user(&data, argp, sizeof(data)))
> +		return -EFAULT;
> +
> +	if (data.flags & ~KVM_CLOCK_REALTIME)
> +		return -EINVAL;

Huh, this an odd ABI, the output of KVM_GET_CLOCK isn't legal input to KVM_SET_CLOCK.
The existing code has the same behavior, so apparently it's ok, just odd.

> +
> +	/*
> +	 * TODO: userspace has to take care of races with VCPU_RUN, so
> +	 * kvm_gen_update_masterclock() can be cut down to locked
> +	 * pvclock_update_vm_gtod_copy().
> +	 */
> +	kvm_gen_update_masterclock(kvm);
> +
> +	spin_lock_irq(&ka->pvclock_gtod_sync_lock);
> +	if (data.flags & KVM_CLOCK_REALTIME) {
> +		u64 now_real_ns = ktime_get_real_ns();
> +
> +		/*
> +		 * Avoid stepping the kvmclock backwards.
> +		 */
> +		if (now_real_ns > data.realtime)
> +			data.clock += now_real_ns - data.realtime;
> +	}
> +
> +	if (ka->use_master_clock)
> +		now_raw_ns = ka->master_kernel_ns;
> +	else
> +		now_raw_ns = get_kvmclock_base_ns();
> +	ka->kvmclock_offset = data.clock - now_raw_ns;
> +	spin_unlock_irq(&ka->pvclock_gtod_sync_lock);
> +
> +	kvm_make_all_cpus_request(kvm, KVM_REQ_CLOCK_UPDATE);
> +	return 0;
> +}
> +
>  long kvm_arch_vm_ioctl(struct file *filp,
>  		       unsigned int ioctl, unsigned long arg)
>  {
> @@ -6064,57 +6151,11 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  	}
>  #endif
>  	case KVM_SET_CLOCK: {

The curly braces can be dropped, both here and in KVM_GET_CLOCK.

>  	}
>  	case KVM_GET_CLOCK: {

...

>  	}
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
