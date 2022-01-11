Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B31B6C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 11 Jan 2022 17:36:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB14F4B0D7;
	Tue, 11 Jan 2022 12:36:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i4n0Qa80qaLc; Tue, 11 Jan 2022 12:36:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AEE9D4B130;
	Tue, 11 Jan 2022 12:36:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A911D4B0D7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 12:36:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zurDkxTRLnnd for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Jan 2022 12:36:31 -0500 (EST)
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com
 [209.85.214.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 948264B0CC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 12:36:31 -0500 (EST)
Received: by mail-pl1-f174.google.com with SMTP id z3so18312891plg.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 09:36:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=kmqD567CtlmXllpc1rQayweyZNMIGqk+RZtPJBuYT90=;
 b=sivzBEkWVy1S0pf5Z71owP5T4t13Zyykw7vqCCakVV0L1ZomD5pSrWWdeOgJuBAzWL
 zFUHh31Ym7mqCNUa7K4JxPVQhFbPy4N3qrzqt5roRk7BcHeqGnIc2hOgv6DFtWK5tTy2
 WdWZCAOQdakcQ38IpcuCVuoEK9rwgLOE50yRhvkZiFuadJGbVSlIPWXMc7yIFrHCMtIG
 bTt98MWR4oDq6HIq7Y/sVn7MmFX9CS1xFwzTO6bvb1DR9JWIcoX/Hrrl/rCckOdh5LoP
 mdC2nr6t5awVklH9vDGx4GBF7LvyiGNU3Chu6orbgSoWmiYl0jqTamZ/7yzMNKGRgmwF
 24Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=kmqD567CtlmXllpc1rQayweyZNMIGqk+RZtPJBuYT90=;
 b=fbOb2tg3WzxAfEB9zyqV/zh0+vpyRP7DaNYmAgHljp+/cxHS9xHMopkkWUHVfZ7uER
 U0rguZwyLZsAHw6sNt6fjOmlJMYrP0vK9KiKdlYoOkqCo+0F+VVtsF1WlsgMn6ST2EBx
 EnL04ObQB5NZkKlfMmNMPIWq1j0k6hEvkoCSQqZdXxUGe+eeWr4LDrLO+2IgGKe1AmtD
 BF6ONZXxUSr6IIIHbCurlYp/QJLF4gHChuCVQHPsvpJLyk2RMCmdpMMGoVv506cBEZeU
 ZtaIyOP22c3ylt4JxQT/c7cr6ICQjLVN02l2V10zLz0HeCbsuPWmR+aP1Y+XJoeHRM+M
 MWHg==
X-Gm-Message-State: AOAM532hdAqyA+L3GTVyFGY5iSIRAVG1yyb2kPCSgL20h1Gtv9dIHINA
 bFaNoY9z7JOb1UOgm3gejtLsMQ==
X-Google-Smtp-Source: ABdhPJyi/ql3rEX/0G3ckRnHJKB6twfx7NB9W6on7gUjJywSRrz2rhGBuYgadAJVOgr9Cf/e9+m1Mg==
X-Received: by 2002:a62:79c2:0:b0:4bd:e9da:c173 with SMTP id
 u185-20020a6279c2000000b004bde9dac173mr5462897pfc.65.1641922590326; 
 Tue, 11 Jan 2022 09:36:30 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id qe10sm3488021pjb.5.2022.01.11.09.36.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 11 Jan 2022 09:36:29 -0800 (PST)
Date: Tue, 11 Jan 2022 17:36:25 +0000
From: Sean Christopherson <seanjc@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
Message-ID: <Yd3AGRtkBgWSmGf2@google.com>
References: <20220104194918.373612-1-rananta@google.com>
 <20220104194918.373612-2-rananta@google.com>
 <Ydjje8qBOP3zDOZi@google.com>
 <CAJHc60ziKv6P4ZmpLXrv+s4DrrDtOwuQRAc4bKcrbR3aNAK5mQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJHc60ziKv6P4ZmpLXrv+s4DrrDtOwuQRAc4bKcrbR3aNAK5mQ@mail.gmail.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Mon, Jan 10, 2022, Raghavendra Rao Ananta wrote:
> On Fri, Jan 7, 2022 at 5:06 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Tue, Jan 04, 2022, Raghavendra Rao Ananta wrote:
> > > +#define kvm_vm_has_started(kvm) (kvm->vm_started)
> >
> > Needs parantheses around (kvm), but why bother with a macro?  This is the same
> > header that defines struct kvm.
> >
> No specific reason for creating a macro as such. I can remove it if it
> feels noisy.

Please do.  In the future, don't use a macro unless there's a good reason to do
so.  Don't get me wrong, I love abusing macros, but for things like this they are
completely inferior to

  static inline bool kvm_vm_has_started(struct kvm *kvm)
  {
  	return kvm->vm_started;
  }

because a helper function gives us type safety, doesn't suffer from concatenation
of tokens potentially doing weird things, is easier to extend to a multi-line
implementation, etc...

An example of when it's ok to use a macro is x86's

  #define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)

which uses a macro instead of a proper function to avoid a circular dependency
due to arch/x86/include/asm/kvm_host.h being included by include/linux/kvm_host.h
and thus x86's implementation of kvm_arch_vcpu_memslots_id() coming before the
definition of struct kvm_vcpu.  But that's very much an exception and done only
because the alternatives suck more.

> > > +                      */
> > > +                     mutex_lock(&kvm->lock);
> >
> > This adds unnecessary lock contention when running vCPUs.  The naive solution
> > would be:
> >                         if (!kvm->vm_started) {
> >                                 ...
> >                         }
> >
> Not sure if I understood the solution..

In your proposed patch, KVM_RUN will take kvm->lock _every_ time.  That introduces
unnecessary contention as it will serialize this bit of code if multiple vCPUs
are attempting KVM_RUN.  By checking !vm_started, only the "first" KVM_RUN for a
VM will acquire kvm->lock and thus avoid contention once the VM is up and running.
There's still a possibility that multiple vCPUs will contend for kvm->lock on their
first KVM_RUN, hence the quotes.  I called it "naive" because it's possible there's
a more elegant solution depending on the use case, e.g. a lockless approach might
work (or it might not).

> > > +                     kvm->vm_started = true;
> > > +                     mutex_unlock(&kvm->lock);
> >
> > Lastly, why is this in generic KVM?
> >
> The v1 of the series originally had it in the arm specific code.
> However, I was suggested to move it to the generic code since the book
> keeping is not arch specific and could be helpful to others too [1].

I'm definitely in favor of moving/adding thing to generic KVM when it makes sense,
but I'm skeptical in this particular case.  The code _is_ arch specific in that
arm64 apparently needs to acquire kvm->lock when checking if a vCPU has run, e.g.
versus a hypothetical x86 use case that might be completely ok with a lockless
implementation.  And it's not obvious that there's a plausible, safe use case
outside of arm64, e.g. on x86, there is very, very little that is truly shared
across the entire VM/system, most things are per-thread/core/package in some way,
shape, or form.  In other words, I'm a wary of providing something like this for
x86 because odds are good that any use will be functionally incorrect.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
