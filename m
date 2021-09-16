Return-Path: <SRS0=nyIz=OH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C811C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 17 Sep 2021 08:46:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7FF5461056
	for <kvmarm@archiver.kernel.org>; Fri, 17 Sep 2021 08:46:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7FF5461056
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EEB464B0B8;
	Fri, 17 Sep 2021 04:46:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z8DnAOPrRIZw; Fri, 17 Sep 2021 04:46:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD3454B0CB;
	Fri, 17 Sep 2021 04:46:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F6C449E93
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 17:37:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7d-51o9avn2r for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Sep 2021 17:37:49 -0400 (EDT)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5777E49E57
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 17:37:49 -0400 (EDT)
Received: by mail-pj1-f54.google.com with SMTP id
 k23-20020a17090a591700b001976d2db364so5799436pji.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=HRmclIUd+IXQYZmIP/8HeB41v2sSRX/lMU3hqPZHzVc=;
 b=Y5uK5usJpzBqYTtETIZzqzrlpEcCGhV1j72nBokzqPxRHfzfqcv9p8/VHqtByMLMa0
 7qnKk2mXRWZ/QVGLWlLUF5fmAtrANk6SVsEq1yvp8Onbj0l+EW2VdhbQ4ssaqq3XvXG+
 UIKM1VSQcdm2YELLCqHTNz0YRbJwYR+FmuDGCbuEaAumq4dsS2jCwrqpahV4jYDPFBXn
 +EFOprbkB9HNvtLDp/UkAPEYfLhp0RIxcvNz5Sev+mrGTECnwFfzaEXBv/uyDuKWSXl9
 MKEl69zQIthFjeiLPFYtD50iSHjTDfTtVEJ8PfVuNwd6e3VXHqiBdyMOjirUU+xrvFcM
 TwGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=HRmclIUd+IXQYZmIP/8HeB41v2sSRX/lMU3hqPZHzVc=;
 b=y7PULFTMnBbgIvzpUloD9V/bGKDTKyLdy37VI5kM7GS6tV12i48pFEhORTKOlUzE1S
 9WXl1LymDYxbnkIANY2zqvz70zPMtKFkqE0mbIvCl3EALZMzSyyxeZ/hXRJGIG0AtElI
 B3/DMaLzUwt90ID3kDIDhd1gTu5BamAwAnqiYyFIUDws0WRPfhkjachKtKteD4cWSfpd
 kqePiyI1CuUZpQsyjGsVT0eQO6h9i/hAPJMFX4WvaNjTWMWghuEOwitcjLf1DR+3+3Th
 4V98VuFNXp+TbVUqM19qh0phqHYjq3V5WAeH8FKoRF0iGGU8SJLT9QO1OQSEXnfM7Qsr
 GkOw==
X-Gm-Message-State: AOAM531wuMzvWy9EZAgaXYIVejVZeC4nlzHYIyF9gfs8DY+g7Btcyx6A
 MHCzx7YvTJBc51JqgyRA5Ev7+Q==
X-Google-Smtp-Source: ABdhPJxrNs7jIZy34jmkRTyON4Y+9pNnsbkx7GECTLo7e1rXLwAWohi0Xxo5Jb11PEVRFoL9wO4HSQ==
X-Received: by 2002:a17:90b:1291:: with SMTP id
 fw17mr6609537pjb.135.1631828268138; 
 Thu, 16 Sep 2021 14:37:48 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id t15sm4013977pgk.13.2021.09.16.14.37.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 16 Sep 2021 14:37:47 -0700 (PDT)
Date: Thu, 16 Sep 2021 21:37:43 +0000
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 00/13] perf: KVM: Fix, optimize, and clean up callbacks
Message-ID: <YUO5J/jTMa2KGbsq@google.com>
References: <20210828003558.713983-1-seanjc@google.com>
 <20210828201336.GD4353@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210828201336.GD4353@worktop.programming.kicks-ass.net>
X-Mailman-Approved-At: Fri, 17 Sep 2021 04:46:52 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Guo Ren <guoren@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-riscv@lists.infradead.org,
 Vincent Chen <deanbo422@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>, xen-devel@lists.xenproject.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
 linux-csky@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 Ingo Molnar <mingo@redhat.com>, Like Xu <like.xu.linux@gmail.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Zhu Lingshan <lingshan.zhu@intel.com>,
 Will Deacon <will@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Borislav Petkov <bp@alien8.de>, Greentime Hu <green.hu@gmail.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Namhyung Kim <namhyung@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Juergen Gross <jgross@suse.com>, Nick Hu <nickhu@andestech.com>,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Sat, Aug 28, 2021, Peter Zijlstra wrote:
> On Fri, Aug 27, 2021 at 05:35:45PM -0700, Sean Christopherson wrote:
> > Like Xu (2):
> >   perf/core: Rework guest callbacks to prepare for static_call support
> >   perf/core: Use static_call to optimize perf_guest_info_callbacks
> > 
> > Sean Christopherson (11):
> >   perf: Ensure perf_guest_cbs aren't reloaded between !NULL check and
> >     deref
> >   KVM: x86: Register perf callbacks after calling vendor's
> >     hardware_setup()
> >   KVM: x86: Register Processor Trace interrupt hook iff PT enabled in
> >     guest
> >   perf: Stop pretending that perf can handle multiple guest callbacks
> >   perf: Force architectures to opt-in to guest callbacks
> >   KVM: x86: Drop current_vcpu for kvm_running_vcpu + kvm_arch_vcpu
> >     variable
> >   KVM: x86: More precisely identify NMI from guest when handling PMI
> >   KVM: Move x86's perf guest info callbacks to generic KVM
> >   KVM: x86: Move Intel Processor Trace interrupt handler to vmx.c
> >   KVM: arm64: Convert to the generic perf callbacks
> >   KVM: arm64: Drop perf.c and fold its tiny bits of code into arm.c /
> >     pmu.c

Argh, sorry, I somehow managed to miss all of your replies.  I'll get back to
this series next week.  Thanks for the quick response!

> Lets keep the whole intel_pt crud inside x86...

In theory, I like the idea of burying intel_pt inside x86 (and even in Intel+VMX code
for the most part), but the actual implementation is a bit gross.  Because of the
whole "KVM can be a module" thing, either the static call and __static_call_return0
would need to be exported, or a new register/unregister pair would have to be exported.

The unregister path would also need its own synchronize_rcu().  In general, I
don't love duplicating the logic, but it's not the end of the world.

Either way works for me.  Paolo or Peter, do either of you have a preference?

> ---
> Index: linux-2.6/arch/x86/events/core.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/events/core.c
> +++ linux-2.6/arch/x86/events/core.c
> @@ -92,7 +92,7 @@ DEFINE_STATIC_CALL_RET0(x86_pmu_guest_ge
>  
>  DEFINE_STATIC_CALL_RET0(x86_guest_state, *(perf_guest_cbs->state));
>  DEFINE_STATIC_CALL_RET0(x86_guest_get_ip, *(perf_guest_cbs->get_ip));
> -DEFINE_STATIC_CALL_RET0(x86_guest_handle_intel_pt_intr, *(perf_guest_cbs->handle_intel_pt_intr));
> +DEFINE_STATIC_CALL_RET0(x86_guest_handle_intel_pt_intr, unsigned int (*)(void));

FWIW, the param needs to be a raw function, not a function pointer. 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
