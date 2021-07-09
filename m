Return-Path: <SRS0=dXrF=MC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC0ECC07E9B
	for <kvmarm@archiver.kernel.org>; Sat, 10 Jul 2021 10:18:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6A6BC613D2
	for <kvmarm@archiver.kernel.org>; Sat, 10 Jul 2021 10:18:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A6BC613D2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E40A4A523;
	Sat, 10 Jul 2021 06:18:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PZL6XB1q2iwR; Sat, 10 Jul 2021 06:18:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDAD049FA6;
	Sat, 10 Jul 2021 06:18:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AFFA4A003
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Jul 2021 17:53:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2gUXb8x8M7n8 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Jul 2021 17:53:36 -0400 (EDT)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com
 [209.85.216.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4328B40856
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Jul 2021 17:53:36 -0400 (EDT)
Received: by mail-pj1-f47.google.com with SMTP id
 g6-20020a17090adac6b029015d1a9a6f1aso7814947pjx.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 09 Jul 2021 14:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=MZOA2XtQ30UKVk79SAgvpwg07B6ibw25WfTMs1wX3wg=;
 b=IHpJ/O/YNCyIx4/laDpAon1vX+8b5IFxxvglK8qpKhTPOdXtzVfowf6Gn/lj3L8b8G
 ZLdmYlc2pmGf7R7ikoL3oohwJdn/OZb3wEznR+VIu738fICua1/lPUkE+onuLQ+f2+51
 ZfAVPWJwKXhqTB7+T4dvTXU1f1GV+C4573rQ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=MZOA2XtQ30UKVk79SAgvpwg07B6ibw25WfTMs1wX3wg=;
 b=c2dRPMBHDbTleSPjY3znS9ymdABY7SVEviiW0wU2l5F1NAH8eL1anXz/wPXztX/bc5
 +aUwZo6mA0rL/DkZnTWwppMLkr9id70JB6FOSaYXXTQKsUo+jAqeRg39Cb5dpq3Qj5IE
 zMs4ZIghuUNzFHkDQgvLDicaq77RXByrbsEI+QI5qPH6ktWqzpkHHh8VLmrMtUoq2kXl
 ipXH7FnF0lP4rLUypgx2ofmYQ3KGYU9Ea2Y7DFNsfKOrWoLXvU4rvrIzmtQw+CuPILrI
 bA9kP3QB2r/KZt35PjqOcj+GH6GjmKHPFDzHyACiJUMoOgiShp6KT7da2uGi+C8B5B8v
 ovUA==
X-Gm-Message-State: AOAM532j4ipJ5SLXVQ+Ez3NPBVb61ZKsW1Pm7lbxeIMVZNzD4C6PgRWo
 gsUjwRI3djYZO+g7oMCL0JqJeA==
X-Google-Smtp-Source: ABdhPJwIjvak1eY/U96Fw1Oiw9RnSDu8AcJfIY+8EEtq4BMJ3aC1wMo18+OQIYafwjiNiLBisKi3AQ==
X-Received: by 2002:a17:90a:9a1:: with SMTP id
 30mr40550193pjo.53.1625867615194; 
 Fri, 09 Jul 2021 14:53:35 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:2538:c0b6:d152:9164])
 by smtp.gmail.com with ESMTPSA id d129sm7222990pfd.218.2021.07.09.14.53.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 09 Jul 2021 14:53:34 -0700 (PDT)
Date: Sat, 10 Jul 2021 06:53:29 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Joel Fernandes <joelaf@google.com>
Subject: Re: [PATCHv2 2/4] arm64: add guest pvstate support
Message-ID: <YOjFWZzgQxjPWaXw@google.com>
References: <20210709043713.887098-1-senozhatsky@chromium.org>
 <20210709043713.887098-3-senozhatsky@chromium.org>
 <CAJWu+opFedsq6CdgUYErnxsv3-Pr7MHi0vz9=hhpMCujFPp8+A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJWu+opFedsq6CdgUYErnxsv3-Pr7MHi0vz9=hhpMCujFPp8+A@mail.gmail.com>
X-Mailman-Approved-At: Sat, 10 Jul 2021 06:18:40 -0400
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Suleiman Souhlal <suleiman@google.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Joel,

On (21/07/09 14:58), Joel Fernandes wrote:
[..]
> > +struct vcpu_state {
> > +       bool    preempted;
> > +       u8      reserved[63];
> > +};
> > +
> >  #ifdef CONFIG_PARAVIRT
> >  #include <linux/static_call_types.h>
> >
> > @@ -20,8 +25,22 @@ static inline u64 paravirt_steal_clock(int cpu)
> >
> >  int __init pv_time_init(void);
> >
> > +bool dummy_vcpu_is_preempted(unsigned int cpu);
> > +
> > +extern struct static_key pv_vcpu_is_preempted_enabled;.
> 
> pv_vcpu_is_preempted_enabled static_key is not used in any patch.
> Maybe it is stale?

Oh, it is, thanks.

> > +DECLARE_STATIC_CALL(pv_vcpu_is_preempted, dummy_vcpu_is_preempted);
> > +
> > +static inline bool paravirt_vcpu_is_preempted(unsigned int cpu)
> > +{
> > +       return static_call(pv_vcpu_is_preempted)(cpu);
> > +}
> > +
> > +int __init pv_vcpu_state_init(void);
> > +
> >  #else
> >
> > +#define pv_vcpu_state_init() do {} while (0)
> > +
> >  #define pv_time_init() do {} while (0)
> >
> >  #endif // CONFIG_PARAVIRT
> > diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
> > index 75fed4460407..d8fc46795d94 100644
> > --- a/arch/arm64/kernel/paravirt.c
> > +++ b/arch/arm64/kernel/paravirt.c
> > @@ -40,6 +40,11 @@ struct pv_time_stolen_time_region {
> >
> >  static DEFINE_PER_CPU(struct pv_time_stolen_time_region, stolen_time_region);
> >
> > +static DEFINE_PER_CPU(struct vcpu_state, vcpus_states);
> > +struct static_key pv_vcpu_is_preempted_enabled;
> > +
> > +DEFINE_STATIC_CALL(pv_vcpu_is_preempted, dummy_vcpu_is_preempted);
> 
> Could we use DEFINE_STATIC_CALL_NULL and get rid of the dummy
> function? I believe that makes the function trampoline as return
> instruction, till it is updated.

Is DEFINE_STATIC_CALL_NULL for cases when function returns void?

We need something that returns `false` to vcpu_is_preempted() or
per_cpu(vcpus_states) once pv vcpu-state is initialised.

[..]
> > +static bool __vcpu_is_preempted(unsigned int cpu)
> > +{
> > +       struct vcpu_state *st;
> > +
> > +       st = &per_cpu(vcpus_states, cpu);
> > +       return READ_ONCE(st->preempted);
> 
> I guess you could just do:
> {
>   return READ_ONCE(per_cpu(vcpus_states, cpu).preempted);
> }

Ack.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
