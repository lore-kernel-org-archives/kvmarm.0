Return-Path: <SRS0=aM0J=O7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77D28C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 11 Oct 2021 14:46:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DC5C8603E9
	for <kvmarm@archiver.kernel.org>; Mon, 11 Oct 2021 14:46:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DC5C8603E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 41AF94B0DB;
	Mon, 11 Oct 2021 10:46:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZaCF4PyW2B1H; Mon, 11 Oct 2021 10:46:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E1A5407D1;
	Mon, 11 Oct 2021 10:46:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67CC5407D1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 10:46:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 74NSKYScIT-d for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Oct 2021 10:46:32 -0400 (EDT)
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com
 [209.85.215.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 54A8E40642
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 10:46:32 -0400 (EDT)
Received: by mail-pg1-f181.google.com with SMTP id a73so11091720pge.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 07:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=DBJ7ew0y4wvSmKi4WuGSAOH7oUWp7VGZaMnxUGUZnug=;
 b=WUgGM/f+tuPQ7vGNX0cNBBwPv0afu/Zf4dQxhALEj1CWce6SG/QX3MDYljf0Gbuor/
 sj1ONxiUie1VuDLeZqyzP3U8wgCb5jI5/lPjBFHrG3lQw2dxyh3W+h6mZVvyEvJz8G7y
 1nEPJR+H3CxD/4MNWxAGoi6oKI9swc9dOAfsAmuD9ToN3kvenxSiEM2lWlzMHV2o9VoH
 KyJiDN0gZI6nT02ZPzo0daWaK+RTn7Ob4pOSdy5AEMo6f68pgZs/vQbuhgd7TqLjMpzx
 27dHqDzBC8kH05vyX+/CHU4byC6ZoMfjoSir4u7rmWajgW3NJ9i2O+wJZUYyUoDZl7A9
 85aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=DBJ7ew0y4wvSmKi4WuGSAOH7oUWp7VGZaMnxUGUZnug=;
 b=ps+iOAd7LAEeUFciUMoxZKbZeEHqQ+oY+C48Y7zpU0ZGzoJIE1UVMakEdWLspF9OQO
 RZPlz6gi3Cd9wkp05aM7LxRhqyH4K3FGQZ1OJOPwFABEgzLXMOMMq19zIflpJDTPLhiL
 /82zEKSjajnwBqYOK555AicYBdlSmr9HlCujW7Iy5XfKeHu8TleGhfdFxDLMmXPrmzuO
 RewDUOIg8x0qiqKYs66fkYE5DyoAt855ljW1+3Aep3i44Nl4GnN51MA614a3qZihwAHU
 ZUOb9KLjGjyk40wtfxAeXFkiff46keRb12/0AMQzCLNK+bKiKr3sB1hW/+spzQFp64so
 PLnQ==
X-Gm-Message-State: AOAM533l+dGIX90Irz6UflvIDgi3iMyJ3tZA8k+xj54+HkccwsoDQHYJ
 VOMTXmezI28HbDFfa5bYAF1FKw==
X-Google-Smtp-Source: ABdhPJy9JeaIFsaMhzjKrm4gRLnqTQlHrSTvgGmlHsrREml2i4T5hhC4ZlLxJitHkoHCOL8HD11SpQ==
X-Received: by 2002:a63:c:: with SMTP id 12mr18698297pga.477.1633963591022;
 Mon, 11 Oct 2021 07:46:31 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id x129sm8062008pfc.140.2021.10.11.07.46.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 11 Oct 2021 07:46:30 -0700 (PDT)
Date: Mon, 11 Oct 2021 14:46:25 +0000
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 12/16] KVM: Move x86's perf guest info callbacks to
 generic KVM
Message-ID: <YWROQSGPuPf3wfC9@google.com>
References: <20210922000533.713300-1-seanjc@google.com>
 <20210922000533.713300-13-seanjc@google.com>
 <87wnmjq4y3.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87wnmjq4y3.wl-maz@kernel.org>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Peter Zijlstra <peterz@infradead.org>, Guo Ren <guoren@kernel.org>,
 linux-riscv@lists.infradead.org, Vincent Chen <deanbo422@gmail.com>,
 Jiri Olsa <jolsa@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Stefano Stabellini <sstabellini@kernel.org>, xen-devel@lists.xenproject.org,
 Will Deacon <will@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 linux-csky@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Ingo Molnar <mingo@redhat.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Like Xu <like.xu.linux@gmail.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Zhu Lingshan <lingshan.zhu@intel.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Greentime Hu <green.hu@gmail.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Namhyung Kim <namhyung@kernel.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Juergen Gross <jgross@suse.com>, Nick Hu <nickhu@andestech.com>,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Mon, Oct 11, 2021, Marc Zyngier wrote:
> On Wed, 22 Sep 2021 01:05:29 +0100, Sean Christopherson <seanjc@google.com> wrote:
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index ed940aec89e0..828b6eaa2c56 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -673,6 +673,14 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa);
> >  void kvm_perf_init(void);
> >  void kvm_perf_teardown(void);
> >  
> > +#ifdef CONFIG_GUEST_PERF_EVENTS
> > +static inline bool kvm_arch_pmi_in_guest(struct kvm_vcpu *vcpu)
> 
> Pardon my x86 ignorance, what is PMI? PMU Interrupt?

Ya, Performance Monitoring Interrupt.  I didn't realize the term wasn't common
perf terminology.  Maybe kvm_arch_perf_events_in_guest() to be less x86-centric?

> > +{
> > +	/* Any callback while a vCPU is loaded is considered to be in guest. */
> > +	return !!vcpu;
> > +}
> > +#endif
> 
> Do you really need this #ifdef?

Nope, should compile fine without it, though simply dropping the #ifdef would make
make the semantics of the function wrong, even if nothing consumes it.  Tweak it
to use IS_ENABLED()?

	return IS_ENABLED(CONFIG_GUEST_PERF_EVENTS) && !!vcpu;
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
